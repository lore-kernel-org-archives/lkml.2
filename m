Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151Ab1HSPhQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 11:37:16 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:7840 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754415Ab1HSPhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 11:37:12 -0400
From: Maxim Patlasov <maxim.patlasov@gmail.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] CFQ: fixing performance issues
Date: Fri, 19 Aug 2011 19:38:37 +0400
Message-Id: <1313768318-7960-1-git-send-email-maxim.patlasov@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

While chasing cfq vs. noop performance degradation in some complex testing
environment (RHEL6-based kernel, Intel vconsolidate and Dell dvd-store tests
running in virtual environments on relaively powerful servers equipped with
fast h/w raid-s), I found a bunch of problems relating to 'idling' in cases
when 'preempting' would be much more beneficial. Now, securing some free time
to fiddle with mainline kernel (I used 3.1.0-rc2 in my tests), I managed to
reproduce one of performance issues using aio-stress alone. The problem that
this patch-set concerns is idling on seeky cfqq-s marked as 'deep'.

Special handling of 'deep' cfqq-s was introduced long time ago by commit
76280aff1c7e9ae761cac4b48591c43cd7d69159. The idea was that, if an application
is using large I/O depth, it is already optimized to make full utilization of
the hardware, and therefore idling should be beneficial. The problem was that
it's enough to see large I/O depth only once and given cfqq would keep 'deep'
flag for long while. Obviously, it may hurt performance much if h/w is able to
concurrently process many i/o request effectively.

Later, the problem was (partially) amended by patch
8e1ac6655104bc6e1e79d67e2df88cc8fa9b6e07 clearing 'deep' and 'idle_window'
flags if "the device is much faster than the queue can deliver". Unfortunately,
the logic introduced by that patch suffers from two main problems:
 - cfqq may keep 'deep' and 'idle_window' flags for a while till that logic
   clears these flags; preemption is effectively disabled within this time gap
 - even on commodity h/w with single slow SATA hdd, that logic may provide
   wrong estimation (claim device as fast when it's actually slow).
There are also a few more deficiencies in that logic. I described them in some
details in patch description.

Let's now look at figures. Commodity server with slow hdd, eight aio-stress
running concurrently, cmd-line of each:

# aio-stress -a 4 -b 4 -c 1 -r 4 -O -o 0 -t 1 -d 1 -i 1 -s 16 f1_$I f2_$I f3_$I f4_$I

Aggreagate throughput:

Pristine 3.1.0-rc2 (CFQ): 3.59 MB/s
Pristine 3.1.0-rc2 (noop): 2.49 MB/s
3.1.0-rc2 w/o 8e1ac6655104bc6e1e79d67e2df88cc8fa9b6e07 (CFQ): 5.46 MB/s

So, that patch steals about 35% of throughput on single slow hdd!

Now let's look at the server with fast h/w raid (LSI 1078 RAID-0 from 8 10K
RPMS SAS Disks). To make "time gap" effect visible, I had to modify aio-stress
slightly:

> --- aio-stress-orig.c	2011-08-16 17:00:04.000000000 -0400
> +++ aio-stress.c	2011-08-18 14:49:31.000000000 -0400
> @@ -884,6 +884,7 @@ static int run_active_list(struct thread
>      }
>      if (num_built) {
>  	ret = run_built(t, num_built, t->iocbs);
> +	usleep(1000);
>  	if (ret < 0) {
>  	    fprintf(stderr, "error %d on run_built\n", ret);
>  	    exit(1);

(this change models an app with non-zero think-time). Aggregate throughput:

Pristine 3.1.0-rc2 (CFQ): 67.29 MB/s
Pristine 3.1.0-rc2 (noop): 99.76 MB/s

So, we can see about 30% performance degradation of CFQ as compared with noop.
Let's see how idling affects it:

Pristine 3.1.0-rc2 (CFQ, slice_idle=0): 106.28 MB/s

This proves that all degradation is due to idling. To be 100% sure that idling
on "deep" tasks is guilty, let's re-run test after commenting out lines marking
cfqq as "deep":

>        //if (cfqq->queued[0] + cfqq->queued[1] >= 4)
>        //      cfq_mark_cfqq_deep(cfqq);

3.1.0-rc2 (CFQ, mark_cfqq_deep is commented, default slice_idle): 98.51 MB/s

The throughput here is essentially the same as in case of noop scheduler. This
proves that 30% degradation resulted from idling on "deep" tasks and that patch
8e1ac6655104bc6e1e79d67e2df88cc8fa9b6e07 doesn't fully address such a
test-case. As a last effort let's verify that that patch really recognize fast
h/w raid as "fast enough". To do it, let's revert changes in
cfq_update_idle_window back to the state of pristine 3.1.0-rc2, but make
clearing "deep" flag in cfq_select_queue unconditional (pretending that
condition "the queue delivers all requests before half its slice is used" is
always met):

>        if (CFQQ_SEEKY(cfqq) && cfq_cfqq_idle_window(cfqq) /* &&
>            (cfq_cfqq_slice_new(cfqq) ||
>            (cfqq->slice_end - jiffies > jiffies - cfqq->slice_start)) */ ) {
>                cfq_clear_cfqq_deep(cfqq);
>                cfq_clear_cfqq_idle_window(cfqq);
>        }

3.1.0-rc2 (CFQ, always clear "deep" flag, default slice_idle): 67.67 MB/s

The throughput here is the same as in case of CFQ on pristine 3.1.0-rc2. This
testifies hypothesis that degradation results from lack of preemption due to
time gap between marking a task as "deep" in cfq_update_idle_window and clearing
this flag in cfq_select_queue.

After applying the patch from this patch-set, aggregate througput on the server
with fast h/w raid is 98.13 MB/s. On commodity server with slow hdd: 5.45 MB/s.

Thanks,
Maxim

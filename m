Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab1IMMq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 08:46:56 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:43622 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321Ab1IMMqz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 08:46:55 -0400
MIME-Version: 1.0
In-Reply-To: <1315884601.29510.87.camel@sli10-conroe>
References: <1313768318-7960-1-git-send-email-maxim.patlasov@gmail.com>
	<1313768318-7960-2-git-send-email-maxim.patlasov@gmail.com>
	<CANejiEWadFK9GdXSwKgzNoj1Da_4QTUidTp-6FGkBtZwhbKvfw@mail.gmail.com>
	<CA+X1aCRSADrUB+YVJ9j5u+VgGn=8fKw7A1eVVzPtODg+hK-B-w@mail.gmail.com>
	<CANejiEX=S8tyPDhAjm84+9xBNt08Q0mjWHjqh-kFqL4H1ME-RA@mail.gmail.com>
	<CA+X1aCSMb9CTpoHWv=UiMg-mHkB2ssmKRACtbDofWG=QSxXOdg@mail.gmail.com>
	<CANejiEV7UfEHEMwokKwE+Pwqn_HRUT0_9wHakhOYj8r0roGYuw@mail.gmail.com>
	<CA+X1aCR6Rptj_7bKf7O7TJ8a9z7AH0vXL90XAgY=+054WegsgQ@mail.gmail.com>
	<CANejiEUTjZbxesiKFzGE4a9rs-GQfq1ekzaDAv34pMGrEQAUcg@mail.gmail.com>
	<CA+X1aCQhUALGLrtjSzdHonQ1WdPgVMPa7kW2Yi0UFqBwD0Vv6w@mail.gmail.com>
	<CA+X1aCSPPoHjOyVpTgZ+NFySLiEK6hLM5boCVFaTTYBcQnYS1g@mail.gmail.com>
	<1315884601.29510.87.camel@sli10-conroe>
Date: Tue, 13 Sep 2011 16:46:54 +0400
Message-ID: <CA+X1aCRgNfUurajzkt-cCN166Q_7PCm91FZOFfU3rb1+zoE2jA@mail.gmail.com>
Subject: Re: [PATCH 1/1] CFQ: fix handling 'deep' cfqq
From: Maxim Patlasov <maxim.patlasov@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shaohua,

See, please, test results below.

>> 1. Single slow disk (ST3200826AS). Eight instances of aio-stress, cmd-line:
>>
>> # aio-stress -a 4 -b 4 -c 1 -r 4 -O -o 0 -t 1 -d 1 -i 1 -s 16 f1_$I
>> f2_$I f3_$I f4_$I
>>
>> Aggreagate throughput:
>>
>> Pristine 3.1.0-rc5 (CFQ): 3.77 MB/s
>> Pristine 3.1.0-rc5 (noop): 2.63 MB/s
>> Pristine 3.1.0-rc5 (CFQ, slice_idle=0): 2.81 MB/s
>> 3.1.0-rc5 + my patch (CFQ): 5.76 MB/s
>> 3.1.0-rc5 + your patch (CFQ): 5.61 MB/s

3.1.0-rc5 + your patch-v2 (CFQ): 2.85 MB/s

I re-run test many times (including node reboot), results varied from
2.79 to 2.9. It's quite close to pristine 3.1.0-rc5 with slice_idle=0.
Probably, in this case hdd was claimed as 'fast' mistakenly by the
patch.

>> 2. Four modern disks (WD1003FBYX) assembled in RAID-0 (Adaptec
>> AAC-RAID (rev 09) 256Mb RAM). Eight instances of aio-stress with
>> think-time 1msec:
>>
>> > --- aio-stress-orig.c       2011-08-16 17:00:04.000000000 -0400
>> > +++ aio-stress.c    2011-08-18 14:49:31.000000000 -0400
>> > @@ -884,6 +884,7 @@ static int run_active_list(struct thread
>> >      }
>> >      if (num_built) {
>> >     ret = run_built(t, num_built, t->iocbs);
>> > +   usleep(1000);
>> >     if (ret < 0) {
>> >         fprintf(stderr, "error %d on run_built\n", ret);
>> >         exit(1);
>>
>> Cmd-line:
>>
>> # aio-stress -a 4 -b 4 -c 1 -r 4 -O -o 0 -t 1 -d 1 -i 1 f1_$I f2_$I f3_$I f4_$I
>>
>> Aggreagate throughput:
>>
>> Pristine 3.1.0-rc5 (CFQ): 63.67 MB/s
>> Pristine 3.1.0-rc5 (noop): 100.8 MB/s
>> Pristine 3.1.0-rc5 (CFQ, slice_idle=0): 105.63 MB/s
>> 3.1.0-rc5 + my patch (CFQ): 105.59 MB/s
>> 3.1.0-rc5 + your patch (CFQ): 14.36 MB/s

3.1.0-rc5 + your patch-v2 (CFQ): 92.44 - 109.49 MB/s.

First time (after reboot) I got 92.44. One of instances of aio-stress
took much longer than others to complete: 597secs, while others took
approximately 335secs. May be this happened because one instance got
deepy flag set before claiming disk as 'fast'. Second run: 109.49.
Then, after reboot, 101.44 in the first run and 109.41 in the second
run.

> Thanks for the testing. You are right, this method doesn't work for hard
> raid. I missed each request in raid still has long finish time. I
> changed the patch to detect fast device, the idea remains but the
> algorithm is different. It detects my hard disk/ssd well, but I haven't
> raid setup, so please help test.

A few general concerns (strictly IMHO) about this version of the patch:
1. If some cfqq was marked as 'deep' in the past and now we're
claiming disk 'fast', it would be nice either to clear stale flag or
ignore it (in making decision about idle/noidle behaviour).
2. cfqd->fast_device_samples is never expired. I think it's wrong. The
system might experience some peculiar workload long time ago that
resulted in claiming disk 'fast'. Why should we trust it now? Another
concern is the noise: from time to time requests may hit h/w disk
cache and so be completed very quickly. W/o expiration logic, such a
noise will eventually end up in claiming disk 'fast'.
3. CFQQ_STRICT_SEEKY() looks extremely strict. Theoretically, it's
possible that we have many SEEKY cfqq-s but the rate of STRICT_SEEKY
events is too low to make reliable estimation. Any rationale why
STRICT_SEEKY should be typical case?

> I'm not satisfied with fast device detection in dispatch stage, even
> slow device with NCQ can dispatch several requests in short time (so my
> original implementation is wrong as you pointed out)

I'd like to understand this concern better. OK, let it be slow device
with NCQ which can dispatch several requests in short time. But if we
have one or more disk-bound apps keeping device busy, is it possible
that the device dispatches several requests in short time more often
than in longer time? As soon as its internal queue is saturated, the
device will be able to snatch next request from CFQ only when one of
those which are servicing now is completed, won't it? If the device
drains deep queue in short time again and again and again, it's fast,
not slow, isn't it? What I'm missing?

Thanks in advance,
Maxim

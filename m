Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302Ab1DZQLv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 12:11:51 -0400
Received: from smtp-out.google.com ([74.125.121.67]:14710 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754769Ab1DZQLs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 12:11:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=YgxE8YUY8dkJ7iD2BM3XdixMao8EqWjxNPYnUZXjRH9AmiE36MPaqflK8kpbSamLGk
         sGlNymbSEW5SXJkJEoEg==
MIME-Version: 1.0
In-Reply-To: <20110421061643.GA31388@elte.hu>
References: <1303332697-16426-1-git-send-email-ncrao@google.com> <20110421061643.GA31388@elte.hu>
From: Nikhil Rao <ncrao@google.com>
Date: Tue, 26 Apr 2011 09:11:25 -0700
Message-ID: <BANLkTikXxLZUUHYLjut6x2a27Oq4imUzbw@mail.gmail.com>
Subject: Re: [RFC][PATCH 00/18] Increase resolution of load weights
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>,
        Mike Galbraith <efault@gmx.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 20, 2011 at 11:16 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Nikhil Rao <ncrao@google.com> wrote:
>
>> Major TODOs:
>> - Detect overflow in update shares calculations (time * load), and set load_avg
>>   to maximum possible value (~0ULL).
>> - tg->task_weight uses an atomic which needs to be updates to 64-bit on 32-bit
>>   machines. Might need to add a lock to protect this instead of atomic ops.
>> - Check wake-affine math and effective load calculations for overflows.
>> - Needs more testing and need to ensure fairness/balancing is not broken.
>
> Please measure micro-costs accurately as well, via perf stat --repeat 10 or so.
>
> For example, on a testsystem doing 200k pipe triggered context switches (100k
> pipe ping-pongs) costs this much:
>
>  $ taskset 1 perf stat --repeat 10 ./pipe-test-100k
>
>        630.908390 task-clock-msecs         #      0.434 CPUs    ( +-   0.499% )
>           200,001 context-switches         #      0.317 M/sec   ( +-   0.000% )
>                 0 CPU-migrations           #      0.000 M/sec   ( +-  66.667% )
>               145 page-faults              #      0.000 M/sec   ( +-   0.253% )
>     1,374,978,900 cycles                   #   2179.364 M/sec   ( +-   0.516% )
>     1,373,646,429 instructions             #      0.999 IPC     ( +-   0.134% )
>       264,223,224 branches                 #    418.798 M/sec   ( +-   0.134% )
>        16,613,988 branch-misses            #      6.288 %       ( +-   0.755% )
>           204,162 cache-references         #      0.324 M/sec   ( +-  18.805% )
>             5,152 cache-misses             #      0.008 M/sec   ( +-  21.280% )
>
> We want to know the delta in the 'instructions' value resulting from the patch
> (this can be measured very accurately) and we also want to see the 'cycles'
> effect - both can be measured pretty accurately.
>
> I've attached the testcase - you might need to increase the --repeat value so
> that noise drops below the level of the effect from these patches. (the effect
> is likely in the 0.01% range)
>

Thanks for the test program. Sorry for the delay in getting back to
you with results. I had some trouble wrangling machines :-(

I have data from pipe_test_100k on 32-bit builds below. I ran this
test 5000 times on each kernel with the two events (instructions,
cycles) configured (the test machine does not have enough PMUs to
measure all events without scaling).

    taskset 1 perf stat --repeat 5000 -e instructions,cycles ./pipe-test-100k

baseline (v2.6.39-rc4):

 Performance counter stats for './pipe-test-100k' (5000 runs):

       994,061,050 instructions             #      0.412 IPC     ( +-   0.133% )
     2,414,463,154 cycles                     ( +-   0.056% )

        2.251820874  seconds time elapsed   ( +-   0.429% )

kernel + patch:

 Performance counter stats for './pipe-test-100k' (5000 runs):

     1,064,610,666 instructions             #      0.435 IPC     ( +-   0.086% )
     2,448,568,573 cycles                     ( +-   0.037% )

        1.704553841  seconds time elapsed   ( +-   0.288% )

We see a ~7.1% increase in instructions executed and a 1.4% increase
in cycles. We also see a 5.5% increase in IPC (understandable since we
do more work). I can't explain how elapsed time drops by about 0.5s
though.

> It would also be nice to see how 'size vmlinux' changes with these patches
> applied, on a 'make defconfig' build.
>

With a defconfig build, we see a marginal increase in vmlinux text
size (3049 bytes, 0.043%), and a small decreased in data size (-4040
bytes, -0.57%).

baseline (v2.6.39-rc4):
   text	   data	    bss	    dec	    hex	filename
7025688	 711604	1875968	9613260	 92afcc	vmlinux-2.6.39-rc4

kernel + patch:
   text	   data	    bss	    dec	    hex	filename
7028737	 707564	1875968	9612269	 92abed	vmlinux

-Thanks
Nikhil

> Thanks,
>
>        Ingo
>

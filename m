Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751065Ab1INFJZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 01:09:25 -0400
Received: from mga14.intel.com ([143.182.124.37]:42591 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953Ab1INFJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 01:09:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,378,1312182000"; 
   d="scan'208";a="16884944"
Subject: Re: [PATCH 1/1] CFQ: fix handling 'deep' cfqq
From: Shaohua Li <shaohua.li@intel.com>
To: Maxim Patlasov <maxim.patlasov@gmail.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <CA+X1aCRgNfUurajzkt-cCN166Q_7PCm91FZOFfU3rb1+zoE2jA@mail.gmail.com>
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
	 <CA+X1aCRgNfUurajzkt-cCN166Q_7PCm91FZOFfU3rb1+zoE2jA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Sep 2011 13:12:58 +0800
Message-ID: <1315977178.29510.111.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-13 at 20:46 +0800, Maxim Patlasov wrote:
Hi,
> See, please, test results below.
Thanks for trying it.

> >> 1. Single slow disk (ST3200826AS). Eight instances of aio-stress, cmd-line:
> >>
> >> # aio-stress -a 4 -b 4 -c 1 -r 4 -O -o 0 -t 1 -d 1 -i 1 -s 16 f1_$I
> >> f2_$I f3_$I f4_$I
> >>
> >> Aggreagate throughput:
> >>
> >> Pristine 3.1.0-rc5 (CFQ): 3.77 MB/s
> >> Pristine 3.1.0-rc5 (noop): 2.63 MB/s
> >> Pristine 3.1.0-rc5 (CFQ, slice_idle=0): 2.81 MB/s
> >> 3.1.0-rc5 + my patch (CFQ): 5.76 MB/s
> >> 3.1.0-rc5 + your patch (CFQ): 5.61 MB/s
> 
> 3.1.0-rc5 + your patch-v2 (CFQ): 2.85 MB/s
> 
> I re-run test many times (including node reboot), results varied from
> 2.79 to 2.9. It's quite close to pristine 3.1.0-rc5 with slice_idle=0.
> Probably, in this case hdd was claimed as 'fast' mistakenly by the
> patch.
Looks current seeky detection isn't good. I investigated your workload.
each task accesses 4 files, the task access disk sectors, A, B, C, D, A
+1, B+1, C+1, D+1,.... accessing A, B, C, D is seeky. but since disk has
cache, when A is accessed, actually A+1 is disk cache, so later
accessing A+1 just fetches cache. This task queue really should be
detected as sequential. Current CFQ seeky detection only maintains one
history, if it maintains 4, the task queue will be detected as
sequential.
But not sure if we should fix it, if no real workload has such access
patten.

> 
> > Thanks for the testing. You are right, this method doesn't work for hard
> > raid. I missed each request in raid still has long finish time. I
> > changed the patch to detect fast device, the idea remains but the
> > algorithm is different. It detects my hard disk/ssd well, but I haven't
> > raid setup, so please help test.
> 
> A few general concerns (strictly IMHO) about this version of the patch:
> 1. If some cfqq was marked as 'deep' in the past and now we're
> claiming disk 'fast', it would be nice either to clear stale flag or
> ignore it (in making decision about idle/noidle behaviour).
yes, this is wrong, I fixed it already.

> 2. cfqd->fast_device_samples is never expired. I think it's wrong. The
> system might experience some peculiar workload long time ago that
> resulted in claiming disk 'fast'. Why should we trust it now? Another
> concern is the noise: from time to time requests may hit h/w disk
> cache and so be completed very quickly. W/o expiration logic, such a
> noise will eventually end up in claiming disk 'fast'.
This is the reason why I use STRICT_SEEKY() to avoid noise. But when I
investigated your above aiostress workload, I found my algorithm can't
work reliable. It depends on measurement of seeky requests. But how to
detect a queue is really seeky is quite hard too.

> 3. CFQQ_STRICT_SEEKY() looks extremely strict. Theoretically, it's
> possible that we have many SEEKY cfqq-s but the rate of STRICT_SEEKY
> events is too low to make reliable estimation. Any rationale why
> STRICT_SEEKY should be typical case?
so we really need make fast_device_samples expirable, then we don't need
so strict. I need to rethink if it's possible.

> > I'm not satisfied with fast device detection in dispatch stage, even
> > slow device with NCQ can dispatch several requests in short time (so my
> > original implementation is wrong as you pointed out)
> 
> I'd like to understand this concern better. OK, let it be slow device
> with NCQ which can dispatch several requests in short time. But if we
> have one or more disk-bound apps keeping device busy, is it possible
> that the device dispatches several requests in short time more often
> than in longer time? As soon as its internal queue is saturated, the
> device will be able to snatch next request from CFQ only when one of
> those which are servicing now is completed, won't it?
yes. If the queue is saturated and drive can dispatch several requests
in short time, we _might_ can think the drive is fast. But how can you
know the drive is saturated? Usually the drive queue isn't saturated,
because CFQ limits how many requests a queue can dispatch for latency
considering, please see cfq_may_dispatch().
Why I said '__might__' above is you will have the same issue I occurs
above - how to detect seeky queue. The drive might dispatch several
requests in short time, which the queue is detected as seeky, but
actually not. In this case we will have wrong judgment.

> If the device
> drains deep queue in short time again and again and again, it's fast,
> not slow, isn't it? What I'm missing?
you are right here. but you didn't know if the device really drains the
deep queue in dispatch stage. it might just dispatch several requests
but not actually finish them.

Thanks,
Shaohua


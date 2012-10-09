Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866Ab2JIST5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 14:19:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17829 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754878Ab2JISTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 14:19:55 -0400
X-Authority-Analysis: v=2.0 cv=YP4dOG6x c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=F0my4ousGMIA:10 a=VwQbUJbxAAAA:8 a=gHW2ynD7t_GgzrDDy2EA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1349806792.24256.34.camel@gandalf.local.home>
Subject: Re: [ANNOUNCE] 3.6.1-rt1
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Date: Tue, 09 Oct 2012 14:19:52 -0400
In-Reply-To: <alpine.LFD.2.02.1210091535140.10988@ionos>
References: <alpine.LFD.2.02.1210091535140.10988@ionos>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-09 at 15:46 +0200, Thomas Gleixner wrote:
> Dear RT Folks,
> 
> I'm pleased to announce the 3.6.1-rt1 release.
> 
> This is a pretty straight forward move from the 3.4-rt series which
> includes a few significant updates which need to be backported to the
> 3.x-rt stable series:

My scripts detected these patches to be pulled into stable. It detects
any patch that has a Cc: to stable-rt@vger.kernel.org that does not
already exist in stable. It also adds the '000x-' prefix to keep the
order.

0000-scsi-qla2xxx-fix-bug-sleeping-function-called-from-invalid-context.patch
0001-upstream-net-rt-remove-preemption-disabling-in-netif_rx.patch
0002-random-make-it-work-on-rt.patch
0003-softirq-init-softirq-local-lock-after-per-cpu-section-is-set-up.patch
0004-mm-slab-fix-potential-deadlock.patch
0005-mm-page-alloc-use-local-lock-on-target-cpu.patch
0006-rt-rw-lockdep-annotations.patch
0007-stomp-machine-deal-clever-with-stopper-lock.patch

> 
>    * Make interrupt randomness work again on RT. Based on the 3.x.y
>      stable updates in that area. Should be applicable to all 3.x-rt
>      series with almost no modifications.

Looks to be: random-make-it-work-on-rt.patch

> 
>    * RT softirq initialization sequence fix (Steven Rostedt)

As I remembered that I forgot to Cc stable-rt, I manually added it to my
patch before running the script.

> 
>    * Fix for a potential deadlock in mm/slab.c. This had been reported
>      as lockdep splats several times and stupidly ignored as a false
>      positive, but in fact it's a real (though almost impossible to
>      trigger) deadlock lurking.

Looks to be: mm-slab-fix-potential-deadlock.patch

> 
>    * Use the proper local_lock primitives in mm/page_alloc.c. That's
>      not a real bug, but this fixes an inconsistency which helps
>      debugability and therefore is worthwhile to be backported.

Looks to be: mm-page-alloc-use-local-lock-on-target-cpu.patch

> 
>    * RT-rwlock/rwsem annotations:

Looks to be: rt-rw-lockdep-annotations.patch

> 
>      RT does not allow multiple readers on rwlocks and rwsems. The
>      lockdep annotations did not yet consider that fact. One might
>      think that this is a complete RT specific issue, but it's
>      not. The FIFO fair rwsem/lock modifications in mainline made
>      reader/writer primitives prone to very subtle deadlock problems
>      which cannot be detected by the current lockdep annotations in
>      mainline. The reason is that if a writer interleaves with two
>      readers it will block the second reader from proceeding in order
>      not to allow writer starvation. The restricted RWlocks semantics
>      of RT allow an easy detection of that problem. We already
>      triggered a real deadlock in RT (see:
>      peterz-srcu-crypto-chain.patch) which could result in a hard to
>      trigger, but mainline relevant deadlock. Wait for more
>      interesting problems in that area.
> 
>    * The output of might_sleep debugging is silent about the possible
>      causes vs. the preempt count. Contrary to interrupt disabling
>      there is zero information about what disabled preemption
>      last. Again, not strictly a bugfix, but debuggability is key.

Is this: sched-better-debug-output-for-might-sleep.patch ? It's not
marked to Cc stable-rt.

> 
>    * Fix a potentially deadly sto(m)p_machine deadlock. A CPU which
>      calls that code from its inactive state (don't ask me for the
>      ghastly deatils why this is necessary) can run into a contended
>      state of the stomp machine mutex which would cause a rather
>      awkward issue of idle scheduling itself away to idle as the only
>      possible task on that upcoming cpu. Not pretty ....

Looks to be: stomp-machine-deal-clever-with-stopper-lock.patch


If I'm wrong with the above, let me know. Thanks,

-- Steve



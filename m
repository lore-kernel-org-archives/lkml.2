Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933285Ab2EKVOv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 17:14:51 -0400
Received: from www.linutronix.de ([62.245.132.108]:40846 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932951Ab2EKVOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 17:14:48 -0400
Date: Fri, 11 May 2012 23:14:41 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Igor Mammedov <imammedo@redhat.com>
cc: linux-kernel@vger.kernel.org, rob@landley.net, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, luto@mit.edu, suresh.b.siddha@intel.com,
        avi@redhat.com, a.p.zijlstra@chello.nl, johnstul@us.ibm.com,
        arjan@linux.intel.com, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/5] Fix soft-lookup in stop machine on secondary cpu
 bring up
In-Reply-To: <4FAD2D63.5010208@redhat.com>
Message-ID: <alpine.LFD.2.02.1205112256220.3231@ionos>
References: <1336559102-28103-1-git-send-email-imammedo@redhat.com> <1336559102-28103-2-git-send-email-imammedo@redhat.com> <alpine.LFD.2.02.1205111234460.3231@ionos> <4FAD2D63.5010208@redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2012, Igor Mammedov wrote:
> On 05/11/2012 01:45 PM, Thomas Gleixner wrote:
> > In fact your change can result in
> > CPU_ONLINE notifier being called _BEFORE_ CPU_STARTING. Do you really
> > think that's correct?
> 
> That's certainly is not correct, it asks for a barrier after
> cpu_starting and before setting cpu_online_mask.

Ah, a barrier will solve that. Interesting approach.

> > Aside of that your whole patch series tackles the wrong aspect.
> 
> patch series tries to prevent a failed to boot cpu wreck havoc on
> running kernel. How wrong is that?

Emphasis on "tries". And as I explained before you are fixing stuff at
the wrong place.

> What should be fixed instead?

If that timeout happens, then prevent that the following code is
reached, perhaps ?
 
> > Why the heck do you need extra magic in check_tsc_sync_target() ?
> Because it's plainly racy. patch 2/5 describes/fixes race condition in
> check_tsc_sync_target().

Crap. You do not understand at all. If the code which is before
check_tsc_sync_target() is failing then check_tsc_sync_target() should
not be called at all. It's that simple. Putting weird ass checks into
that code is simply the wrong solution.
 
> > If the booting CPU fails to set the callin map within 5 seconds then
> > it should not even reach check_tsc_sync_target() at all.
> 
> Why it shouldn't reach check_tsc_sync_target () at all. There is nothing
> that prevents it and guaranties such behavior.

That's the whole fcking point. The code is missing which prevents that
and instead of hacking that crap into check_tsc_sync_target() we need
to add that what's missing.

> > And just for the record, the new CPU can run into the v()ery same
> > timeout problem, when the boot CPU fails to set the callout mask.
> 
> Yes, it can.
> I've tried to fix only what was reproducible on my test system, so I
> haven't touched this.
> That might result in panic in smp_callin():
>    panic("%s: CPU%d started up but did not get a callout!\n"

I know that. And it's fucking wrong and I don't care whether you are
only fixing what's reproducible on your test system. If we touch that
code for that purpose then we better touch it so it's correct in all
aspects and not in some "this fixes my esoteric problem" approach.

> > This whole stuff is a complete trainwreck already and I don't want to
> > see anything like your "fixing the symptoms" hackery near it, really.
> 
> Fixing slow to respond cpu might be not option, so we need to gracefully
> abort failed cpu_online operation instead of hanging in stop_machine or
> crashing in scheduler[https://lkml.org/lkml/2012/5/9/137].

I'm tired of your symptom links. You are simply not understanding the
scope of the problem and you just try to fix it so your testing
failures go away.
 
> > This whole stuff needs a proper rewrite and not some more braindamaged
> > bandaids. And if we apply bandaids for the time being, then certainly
> > not bandaids like the mess you created.
>
> Rewrite will need to deal with failed to boot in time cpu as well.

Really? Thanks for the hint, didn't know that.

> So if rewrite is not near completion, then maybe for a time being bandaids
> would be needed.

As I said, I don't object against proper bandaids, but I object
against the hackery you provided.

> Any ideas/suggestions for "right bandaids" instead of braindamaged ones?

Maybe start to think about my answers instead of blindly repeating
your observations of symptoms and praising your symptom cures.

Even in bandaid mode we can fix that behaviour by putting proper
synchronization into the right points, instead of hacking weird
failure handling into code which should never be affected by that.

Thanks,

	tglx

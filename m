Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab2BTJeL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 04:34:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9318 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752609Ab2BTJeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 04:34:08 -0500
Date: Mon, 20 Feb 2012 11:33:50 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Tejun Heo <tj@kernel.org>,
        John Stultz <johnstul@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        David Howells <dhowells@redhat.com>, Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 1/1] linux headers: header file(s) changes to enable
 spinlock use jumplabel
Message-ID: <20120220093350.GF10038@redhat.com>
References: <20120217082527.15283.72980.sendpatchset@oc5400248562.ibm.com>
 <4F403268.7040804@goop.org>
 <20120219092456.GB10038@redhat.com>
 <4F41D72E.7000605@goop.org>
 <4F41E4C1.9010901@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F41E4C1.9010901@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 20, 2012 at 11:44:25AM +0530, Raghavendra K T wrote:
> On 02/20/2012 10:46 AM, Jeremy Fitzhardinge wrote:
> [...]
> >>>>  So we get following error when we try to include jump_label.h from
> >>>>arch/x86/include/asm/spinlock.h because of cyclic dependency
> >>>><spinlock.h>  ->  <jumplabe.h>  ->  <workque.h>  ->  ...<seqlock.h>  ->  <spinlock.h>
> >>>What about splitting the jump_label_key_deferred stuff into a separate
> >>>jump_label_deferred.h, and just include that where it's needed?
> >>>
> >>Andrew Jones did exactly that (CCed).
> 
> Sorry, did not get it. Tried to search the patch. Is it similar
> work or same work?. Could you please point. shall try both the way
> (current way and jump_label_deferred way). So whichever makes
> maintainer happy, let that go :)
> 
It was not CCed to any ML. I CCed Andrew so he can chime in.

> But does pvlock have to use jump
> >>label? I looked at the code and it is used like paravirt patching. Meaning
> >>it is patched only once on a boot up when XEN is detected. May be use
> >>paravirt patching instead of jump label? What if jump label will want
> >>to use spinlock for some reason in the future (it uses mutex currently)?
> >
> >The point of the pv ticketlocks is to avoid any pvop calls on the
> >lock/unlock fastpath, relegating them to only the slow path.
> >Unfortunately, the pv unlock case can't be identical with the non-pv
> >unlock, and jump_labels are lighter weight and more efficient than pvops.
> >
> >It doesn't matter if jump_labels start using spinlocks; all we need the
> >jump_label machinery to do is patch the jump sites in the code so that
> >one of two execution paths can be selected.  Since all the ticketlock
> >jump_label patching happens before SMP is enabled, there's no problem
> >with changing a lock while a cpu is executing the code.
> >
> 
> I also felt agreeing with Jeremy. seemed to me that latter is more
> performance friendly. no?.
> 

I thought not about pvop, but about alternative().  jump_labels is used
by spinlock to patch out jump into nops It can be done via alternative()
too I think.

> (Hmm. Thinking..  By the way is it not that Jeremy's earlier version
> had implementation similar to what Gleb asked ?)

--
			Gleb.

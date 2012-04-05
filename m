Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952Ab2DEJQe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 05:16:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37872 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752875Ab2DEJQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 05:16:32 -0400
Message-ID: <4F7D62CC.9010108@redhat.com>
Date: Thu, 05 Apr 2012 12:15:56 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Stephan Diestelhorst <stephan.diestelhorst@amd.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Attilio Rao <attilio.rao@citrix.com>
Subject: Re: [PATCH RFC V6 0/11] Paravirtualized ticketlocks
References: <20120321102041.473.61069.sendpatchset@codeblue.in.ibm.com> <4F7616F5.4070000@zytor.com> <alpine.LFD.2.02.1203302333560.2542@ionos> <4F7858C0.90405@redhat.com> <alpine.LFD.2.02.1204021117560.2542@ionos>
In-Reply-To: <alpine.LFD.2.02.1204021117560.2542@ionos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2012 12:26 PM, Thomas Gleixner wrote:
> > One thing about it is that it can give many false positives.  Consider a
> > fine-grained spinlock that is being accessed by many threads.  That is,
> > the lock is taken and released with high frequency, but there is no
> > contention, because each vcpu is accessing a different instance.  So the
> > host scheduler will needlessly delay preemption of vcpus that happen to
> > be holding a lock, even though this gains nothing.
>
> You're talking about per cpu locks, right? I can see the point there,
> but per cpu stuff might be worth annotating to avoid this.

Or any lock which is simply uncontended.  Say a single process is
running, the rest of the system is idle.  It will take and release many
locks; but it can be preempted at any point by the hypervisor with no
performance loss.

The overhead is arming a timer twice and an extra exit per deferred
context switch.  Perhaps not much given that you don't see tons of
context switches on virt workloads, at least without threaded interrupts
(or maybe interrupt threads should override this mechanism, by being
realtime threads).

> > A second issue may happen with a lock that is taken and released with
> > high frequency, with a high hold percentage.  The host scheduler may
> > always sample the guest in a held state, leading it to conclude that
> > it's exceeding its timeout when in fact the lock is held for a short
> > time only.
>
> Well, no. You can avoid that.
>
> host		VCPU
> 		spin_lock()
> 		 modify_global_state()
>    	exit
> check_global_state()
> mark_global_state()
> reschedule vcpu
>
> 		spin_unlock()
> 		 check_global_state()
> 		  trigger_exit()
>
> So when an exit occures in the locked section, then the host can mark
> the global state to tell the guest to issue a trap on unlock.

Right.

How does this nest?  Do we trigger the exit on the outermost unlock?

-- 
error compiling committee.c: too many arguments to function


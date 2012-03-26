Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932637Ab2CZOcc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 10:32:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20105 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932473Ab2CZOca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 10:32:30 -0400
Message-ID: <4F707C5F.1000905@redhat.com>
Date: Mon, 26 Mar 2012 16:25:35 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
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
References: <20120321102041.473.61069.sendpatchset@codeblue.in.ibm.com>
In-Reply-To: <20120321102041.473.61069.sendpatchset@codeblue.in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2012 12:20 PM, Raghavendra K T wrote:
> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>
> Changes since last posting: (Raghavendra K T)
> [
>  - Rebased to linux-3.3-rc6.
>  - used function+enum in place of macro (better type checking) 
>  - use cmpxchg while resetting zero status for possible race
> 	[suggested by Dave Hansen for KVM patches ]
> ]
>
> This series replaces the existing paravirtualized spinlock mechanism
> with a paravirtualized ticketlock mechanism.
>
> Ticket locks have an inherent problem in a virtualized case, because
> the vCPUs are scheduled rather than running concurrently (ignoring
> gang scheduled vCPUs).  This can result in catastrophic performance
> collapses when the vCPU scheduler doesn't schedule the correct "next"
> vCPU, and ends up scheduling a vCPU which burns its entire timeslice
> spinning.  (Note that this is not the same problem as lock-holder
> preemption, which this series also addresses; that's also a problem,
> but not catastrophic).
>
> (See Thomas Friebel's talk "Prevent Guests from Spinning Around"
> http://www.xen.org/files/xensummitboston08/LHP.pdf for more details.)
>
> Currently we deal with this by having PV spinlocks, which adds a layer
> of indirection in front of all the spinlock functions, and defining a
> completely new implementation for Xen (and for other pvops users, but
> there are none at present).
>
> PV ticketlocks keeps the existing ticketlock implemenentation
> (fastpath) as-is, but adds a couple of pvops for the slow paths:
>
> - If a CPU has been waiting for a spinlock for SPIN_THRESHOLD
>   iterations, then call out to the __ticket_lock_spinning() pvop,
>   which allows a backend to block the vCPU rather than spinning.  This
>   pvop can set the lock into "slowpath state".
>
> - When releasing a lock, if it is in "slowpath state", the call
>   __ticket_unlock_kick() to kick the next vCPU in line awake.  If the
>   lock is no longer in contention, it also clears the slowpath flag.
>
> The "slowpath state" is stored in the LSB of the within the lock tail
> ticket.  This has the effect of reducing the max number of CPUs by
> half (so, a "small ticket" can deal with 128 CPUs, and "large ticket"
> 32768).
>
> This series provides a Xen implementation, but it should be
> straightforward to add a KVM implementation as well.
>

Looks like a good baseline on which to build the KVM implementation.  We
might need some handshake to prevent interference on the host side with
the PLE code.

-- 
error compiling committee.c: too many arguments to function


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab1IEMF4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 08:05:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50718 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752489Ab1IEMFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 08:05:47 -0400
Message-ID: <4E64BAED.2040101@redhat.com>
Date: Mon, 05 Sep 2011 15:05:01 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>, Marcelo Tosatti <mtosatti@redhat.com>,
        KVM <kvm@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [PATCH 08/13] xen/pvticketlock: disable interrupts while blocking
References: <cover.1314922370.git.jeremy.fitzhardinge@citrix.com>   <38bb37e15f6e5056d5238adac945bc1837a996ec.1314922370.git.jeremy.fitzhardinge@citrix.com>  <1314974826.1861.1.camel@twins> <4E612EA1.20007@goop.org> <1314996468.8255.0.camel@twins> <4E614FBD.2030509@goop.org>
In-Reply-To: <4E614FBD.2030509@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2011 12:50 AM, Jeremy Fitzhardinge wrote:
> On 09/02/2011 01:47 PM, Peter Zijlstra wrote:
> >  On Fri, 2011-09-02 at 12:29 -0700, Jeremy Fitzhardinge wrote:
> >>>  I know that its generally considered bad form, but there's at least one
> >>>  spinlock that's only taken from NMI context and thus hasn't got any
> >>>  deadlock potential.
> >>  Which one?
> >  arch/x86/kernel/traps.c:nmi_reason_lock
> >
> >  It serializes NMI access to the NMI reason port across CPUs.
>
> Ah, OK.  Well, that will never happen in a PV Xen guest.  But PV
> ticketlocks are equally applicable to an HVM Xen domain (and KVM guest),
> so I guess there's at least some chance there could be a virtual
> emulated NMI.  Maybe?  Does qemu do that kind of thing?

kvm does.  In fact, I want to use 'hlt' for blocking vcpus in the 
slowpath and an NMI IPI for waking them up.  That's not going to work in 
an NMI, but I guess I can replace the 'hlt' with a 'pause' if we're in 
an NMI, and just spin there.

btw, doing a race-free NMI wakeup is going to be interesting - we'll 
have to look at %rip and see if is just before our hlt, since there's no 
magic sti; hlt sequence we can use.

-- 
error compiling committee.c: too many arguments to function


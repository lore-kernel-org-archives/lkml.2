Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293Ab1IBVu6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 17:50:58 -0400
Received: from claw.goop.org ([74.207.240.146]:45372 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756229Ab1IBVu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 17:50:57 -0400
Message-ID: <4E614FBD.2030509@goop.org>
Date: Fri, 02 Sep 2011 14:50:53 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [PATCH 08/13] xen/pvticketlock: disable interrupts while blocking
References: <cover.1314922370.git.jeremy.fitzhardinge@citrix.com>   <38bb37e15f6e5056d5238adac945bc1837a996ec.1314922370.git.jeremy.fitzhardinge@citrix.com>  <1314974826.1861.1.camel@twins> <4E612EA1.20007@goop.org> <1314996468.8255.0.camel@twins>
In-Reply-To: <1314996468.8255.0.camel@twins>
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2011 01:47 PM, Peter Zijlstra wrote:
> On Fri, 2011-09-02 at 12:29 -0700, Jeremy Fitzhardinge wrote:
>>> I know that its generally considered bad form, but there's at least one
>>> spinlock that's only taken from NMI context and thus hasn't got any
>>> deadlock potential.
>> Which one? 
> arch/x86/kernel/traps.c:nmi_reason_lock
>
> It serializes NMI access to the NMI reason port across CPUs.

Ah, OK.  Well, that will never happen in a PV Xen guest.  But PV
ticketlocks are equally applicable to an HVM Xen domain (and KVM guest),
so I guess there's at least some chance there could be a virtual
emulated NMI.  Maybe?  Does qemu do that kind of thing?

But, erm, does that even make sense?  I'm assuming the NMI reason port
tells the CPU why it got an NMI.  If multiple CPUs can get NMIs and
there's only a single reason port, then doesn't that mean that either 1)
they all got the NMI for the same reason, or 2) having a single port is
inherently racy?  How does the locking actually work there?

    J

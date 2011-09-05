Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580Ab1IELov (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 07:44:51 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:32360 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215Ab1IELon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 07:44:43 -0400
X-IronPort-AV: E=Sophos;i="4.68,333,1312156800"; 
   d="scan'208";a="7603009"
Date: Mon, 5 Sep 2011 12:52:42 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Keir Fraser <keir@xen.org>
Subject: Re: [PATCH 08/13] xen/pvticketlock: disable interrupts while
 blocking
In-Reply-To: <4E614FBD.2030509@goop.org>
Message-ID: <alpine.DEB.2.00.1109051219590.12963@kaball-desktop>
References: <cover.1314922370.git.jeremy.fitzhardinge@citrix.com>   <38bb37e15f6e5056d5238adac945bc1837a996ec.1314922370.git.jeremy.fitzhardinge@citrix.com>  <1314974826.1861.1.camel@twins> <4E612EA1.20007@goop.org> <1314996468.8255.0.camel@twins>
 <4E614FBD.2030509@goop.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC'ing Keir.

On Fri, 2 Sep 2011, Jeremy Fitzhardinge wrote:
> On 09/02/2011 01:47 PM, Peter Zijlstra wrote:
> > On Fri, 2011-09-02 at 12:29 -0700, Jeremy Fitzhardinge wrote:
> >>> I know that its generally considered bad form, but there's at least one
> >>> spinlock that's only taken from NMI context and thus hasn't got any
> >>> deadlock potential.
> >> Which one? 
> > arch/x86/kernel/traps.c:nmi_reason_lock
> >
> > It serializes NMI access to the NMI reason port across CPUs.
> 
> Ah, OK.  Well, that will never happen in a PV Xen guest.  But PV
> ticketlocks are equally applicable to an HVM Xen domain (and KVM guest),
> so I guess there's at least some chance there could be a virtual
> emulated NMI.  Maybe?  Does qemu do that kind of thing?

Xen knows how to inject NMIs to HVM guests, even though I am not sure
if it is actually done in practice at the moment.

However digging into the implementation details, it looks like virtual
NMIs are not injected if blocking-by-STI (or blocking-by-MOV-SS), so we
should be fine, even though I don't know if you actually want to rely on
this:

/*
 * We can only inject an NMI if no blocking by MOV SS (also, depending on
 * implementation, if no blocking by STI). If pin-based 'virtual NMIs'
 * control is specified then the NMI-blocking interruptibility flag is
 * also checked. The 'virtual NMI pending' control (available only in
 * conjunction with 'virtual NMIs') causes a VM exit when all these checks
 * succeed. It will exit immediately after VM entry if the checks succeed
 * at that point.
 * 
 * Because a processor may or may not check blocking-by-STI when injecting
 * a virtual NMI, it will be necessary to convert that to block-by-MOV-SS
 * before specifying the 'virtual NMI pending' control. Otherwise we could
 * enter an infinite loop where we check blocking-by-STI in software and
 * thus delay delivery of a virtual NMI, but the processor causes immediate
 * VM exit because it does not check blocking-by-STI.
 */

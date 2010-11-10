Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686Ab0KJDHo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 22:07:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18386 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753569Ab0KJDHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 22:07:35 -0500
Subject: Re: [PATCH 0/2] vfio: virtualize INTX_DISABLE
From: Alex Williamson <alex.williamson@redhat.com>
To: Tom Lyon <pugs@cisco.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org
In-Reply-To: <201011091659.04480.pugs@cisco.com>
References: <20101105171624.1638.33349.stgit@s20.home>
	 <201011091659.04480.pugs@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Nov 2010 20:07:33 -0700
Message-ID: <1289358453.14321.88.camel@x201>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-09 at 16:59 -0800, Tom Lyon wrote:
> Alex - I am rejecting these 2 patches.
> 
> For patch 1/2, I started with yours and found a couple of problems, but then I 
> got into the spirit and did a buinch more cleaning up. My patch to follow.

Great, I'll take a look.

> For patch 2/2, the INTX stuff, I don't really see the problem.  If the user 
> turns on the bit, it'll result in at most one more interrupt, right?  If he 
> turns off the bit, then he doesn't want interrupts.

The scenario I'm thinking of is that an interrupt comes in, VFIO sets
INTX_DISABLE, signals eventfd.  We're already in a little bit of a weird
state for a VM because INTX_DISABLE just changed on it's own.  The guest
interrupt handler blindly sets INTX_DISABLE again, and services the
interrupt.  This has the side effect of sending the emulated APIC EOI,
which ends with VFIO clearing INTX_DISABLE, and now the guest is getting
interrupts it's not expecting.

Another aspect of it is that since the non-PCI-2.3/EOI patches, the VFIO
interrupt handler is wrapped around an irq_disabled check, where
irq_disabled only gets cleared by the EOI interfaces.  So userspace
might clear INTX_DISABLE and expect new INTx eventfds, but it won't
happen without an EOI call.  If we virtualize INTX_DISABLE, we can allow
userspace to use either the EOI interfaces or (in)directly manipulate
INTX_DISABLE from config space.

I could also virtualize the INTX_DISABLE bit in the qemu VFIO driver but
it gets a little bit tricky that I need to disable the EOI_EVENTFD to be
sure to catch all the EOIs in userspace.  Emulating INTX_DISABLE for
non-PCI 2.3 devices is also a little more cumbersome from userspace, but
ultimately I'm not sure how valuable that is anyway.  Overall, I figured
the above behavior issues were probably sufficient to implement it for
everyone in the VFIO driver.

Alex


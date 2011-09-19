Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430Ab1ISQBX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 12:01:23 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50441 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250Ab1ISQBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 12:01:21 -0400
Date: Mon, 19 Sep 2011 17:00:50 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Cousson, Benoit" <b-cousson@ti.com>
Cc: Rob Herring <robherring2@gmail.com>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        "jamie@jamieiles.com" <jamie@jamieiles.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 5/5] ARM: gic: add OF based initialization
Message-ID: <20110919160050.GW16381@n2100.arm.linux.org.uk>
References: <1316017900-19918-1-git-send-email-robherring2@gmail.com> <1316017900-19918-6-git-send-email-robherring2@gmail.com> <CAJuYYwSFu2HC+u2NY41+yw9tEyy85RKa4Dpm3SL+jbwS_OOA0A@mail.gmail.com> <4E71CE5D.9030900@ti.com> <4E71F978.6020402@gmail.com> <4E72030F.1090300@ti.com> <4E722B2D.4050307@gmail.com> <4E76615C.3000005@gmail.com> <4E77310A.3000106@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E77310A.3000106@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 19, 2011 at 02:09:46PM +0200, Cousson, Benoit wrote:
> Every CortexA9 based SoC have to add the 32 offset to the SoC level
> interrupt number line. The ID numbering scheme is relevant only inside
> the GIC, but at SoC level only the IRQ lines that entered the MP core
> are relevant. That ID is a pure internal GIC encoding.

As far as SPIs go, I think what should be done is that the DT should
refer to a SPI phandle plus the SPI number, and be done with just that.

The point as to whether SoCs internally use SPIs themselves is a complete
distraction - if they're using SPIs internally then we _also_ need some
way for the on-SoC peripherals to refer to them too.

What the GIC exports are 16 PPIs per CPU, 16 SGIs and N SPIs.  That's what
we should be modelling for the GIC, not something else.  So peripherals
connect to an SPI numbered N where N >= 0.

How we want SPIs to map to Linux IRQ numbers is the issue, and as things
stand at present, we want SPI0 to map to IRQ32 on all platforms where the
GIC is the root, to avoid any unnecessary complexity (because the hardware
tells us that SPI0 gives us ID32 in the interrupt acknowledge register.)
Doing anything else requires computation or a lookup table, and we shouldn't
be doing that kind of thing unless there's a real reason to do so (there
isn't, especially with sparse irq support.)

As far as PPIs go, support for that is still being worked on, and most of
that at present does not go through genirq stuff (and it isn't relevant to
use the standard genirq interfaces for PPIs _anyway_.)

SGIs don't use genirq in any way, and are used for SMP IPIs.  That's
completely separate from the way IRQs are used - they're not connected
to devices at all. (They're provided as an inter-processor communication
method.)  So forget SGIs.  They may apparantly occupy IRQ IDs 0-15, but
reality is they leave those IDs unused, IRQs 0-15 are not requestable,
which is a definite *good* thing.

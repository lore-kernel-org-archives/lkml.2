Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758Ab1IRMDu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 08:03:50 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46928 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab1IRMDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 08:03:49 -0400
Date: Sun, 18 Sep 2011 13:03:12 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, b-cousson@ti.com, marc.zyngier@arm.com,
        Rob Herring <rob.herring@calxeda.com>, grant.likely@secretlab.ca,
        thomas.abraham@linaro.org, jamie@jamieiles.com, shawn.guo@linaro.org
Subject: Re: [PATCH 4/5] ARM: gic: allow irq_start to be 0
Message-ID: <20110918120312.GL16381@n2100.arm.linux.org.uk>
References: <1316017900-19918-1-git-send-email-robherring2@gmail.com> <1316017900-19918-5-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316017900-19918-5-git-send-email-robherring2@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 14, 2011 at 11:31:39AM -0500, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> There's really no need to set irq_start per platform for the primary gic.
> The SGIs and PPIs are not handled as normal irqs, so how irqs 0-31 are
> setup doesn't really matter. So allow irq_start to be set to 0 to match
> the linux irq numbering.

That's not correct.  The hardware starts numbering SPI IRQs from 32 when
reading the INTACK register.  The number which gets passed through into
asm_do_IRQ() will therefore be from 32 and above.

There's several reasons for this:
1. To avoid IRQ0, which is commonly used to indicate 'no interrupt' to
   drivers.
2. To avoid the ISA IRQ range 1-15 which are hard-coded into various
   drivers (and we want those to fail.)
3. It's wasteful and pointless to manipulate the IRQ number given that we
   have sparse irq support.

Also, bear in mind that gic_irq(SPI0) needs to return 32 to hit the
right registers - so you'd have to set gic->irq_start to -32 to make
SPI0 = IRQ0 work.

Finally, the valid range for irq_start is 16 to 32 + the Linux IRQ base
for the first GIC (SGI) interrupt.  We should probably make gic_init()
BUG() if its passed values less than 16.

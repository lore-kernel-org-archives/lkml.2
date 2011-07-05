Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198Ab1GED7I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 23:59:08 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:52176 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045Ab1GED7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 23:59:06 -0400
Date: Mon, 4 Jul 2011 21:59:02 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: linux-kernel@vger.kernel.org, alexander.stein@systec-electronic.com,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com,
        tglx@linutronix.de
Subject: Re: [PATCH v4] pch_gpio: Support interrupt function
Message-ID: <20110705035902.GB13713@ponder.secretlab.ca>
References: <1309486572-2789-1-git-send-email-tomoya-linux@dsn.okisemi.com>
 <20110704163137.GA28042@ponder.secretlab.ca>
 <4E128A7D.9020508@dsn.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E128A7D.9020508@dsn.okisemi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 05, 2011 at 12:52:29PM +0900, Tomoya MORINAGA wrote:
> Hi Grant,
> 
> (2011/07/05 1:31), Grant Likely wrote:
> 
> >>+#define PCH_IRQ_BASE		23
> >
> >Yikes!  IRQ ranges should really be dynamically assigned.  Don't hard
> >code an irq base.
> 
> As we discussed before,
> without specifying PCH_IRQ_BASE,
> it seemed IRQ number collision issue occurred.
> Thus, I added PCH_IRQ_BASE.

Then fix the irq collision.  If the core code hands out an irq range
that is in-use by some other driver, then the other driver isn't
reserving it's irqs correctly and it needs to be fixed.  Hacking
around the problem doesn't help anything in the long run.

> >>@@ -202,8 +345,36 @@ static int __devinit pch_gpio_probe(struct pci_dev *pdev,
> >>  		goto err_gpiochip_add;
> >>  	}
> >>
> >>+	irq_base = irq_alloc_descs(-1, PCH_IRQ_BASE, GPIO_NUM_PINS, GFP_KERNEL);
> >>+	if (irq_base<  0) {
> >>+		dev_err(&pdev->dev, "PCH gpio: Failed to get IRQ base num\n");
> >>+		goto err_irq_alloc_descs;
> >>+	}
> >>+	chip->irq_base = irq_base;
> >
> >This looks like it will cause the driver probe to completely fail,
> >even if the GPIO portion of the chip was setup correctly.  I would
> >think that if GPIO works the driver should at least enable that bit
> >even if IRQs are broken.
> 
> Do you mean in case of failing irq_alloc_descs,
> probe() shouldn't return ERROR but SUCCESS. Right ?

That's what I'm suggesting.  I'll leave it up to you whether or not it
is worthwhile though.

g.


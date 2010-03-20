Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534Ab0CTFop (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 01:44:45 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:53712 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751349Ab0CTFoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 01:44:44 -0400
Date: Sat, 20 Mar 2010 05:44:40 +0000
From: Marc Zyngier <maz@misterjones.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Miao <eric.y.miao@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Jebediah Huang <jebediah.huang@gmail.com>
Subject: Re: [PATCH] gpio: add interrupt handling capability to max732x
Message-ID: <20100320054440.63364b3a@taxman.wild-wind.fr.eu.org>
In-Reply-To: <20100319164156.87b6fc43.akpm@linux-foundation.org>
References: <4ed0c90d27185c38ccb15d6d4442cfd4@localhost>
	<20100319164156.87b6fc43.akpm@linux-foundation.org>
Organization: Metropolis -- Nowhere
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 93.97.26.37
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, eric.y.miao@gmail.com, linux-kernel@vger.kernel.org, jebediah.huang@gmail.com
X-SA-Exim-Mail-From: maz@misterjones.org
X-SA-Exim-Scanned: No (on inca-roads.misterjones.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Mar 2010 16:41:56 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 16 Mar 2010 11:34:52 +0100
> Marc Zyngier <maz@misterjones.org> wrote:
> 
> > +static irqreturn_t max732x_irq_handler(int irq, void *devid)
> > +{
> > +	struct max732x_chip *chip = devid;
> > +	uint8_t pending;
> > +	uint8_t level;
> > +
> > +	pending = max732x_irq_pending(chip);
> > +
> > +	if (!pending)
> > +		return IRQ_HANDLED;
> 
> Should be IRQ_NONE?

The main problem is that some of the supported expanders do not have a
hardware interrupt mask, so the IRQ will fire on each input pin toggle,
including the ones we don't care about (pca953x has the same problem).

Returning IRQ_NONE will cause the irq core to quickly disable the line.
Not good either. I could add a test for the mask feature bit, and
return IRQ_NONE only in that case.

> If this device was on a shared interrupt line and the interrupt was
> caused by some other device, and this handler is called first then the
> incorrect IRQ_HANDLED return could cause the irq core to do wrong things.

This is exactly why the irq handler is requested without the SHARED
flag:

+		ret = request_threaded_irq(client->irq,
+					   NULL,
+					   max732x_irq_handler,
+					   IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
+					   dev_name(&client->dev), chip);

The same mask feature bit could be used to allow shared interrupts with
devices that support it.

Thanks,

	M.
-- 
I'm the slime oozin' out from your TV set...

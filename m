Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247Ab0CSXmI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 19:42:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46486 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751528Ab0CSXmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 19:42:06 -0400
Date: Fri, 19 Mar 2010 16:41:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Marc Zyngier <maz@misterjones.org>
Cc: Eric Miao <eric.y.miao@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Jebediah Huang <jebediah.huang@gmail.com>
Subject: Re: [PATCH] gpio: add interrupt handling capability to max732x
Message-Id: <20100319164156.87b6fc43.akpm@linux-foundation.org>
In-Reply-To: <4ed0c90d27185c38ccb15d6d4442cfd4@localhost>
References: <4ed0c90d27185c38ccb15d6d4442cfd4@localhost>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Mar 2010 11:34:52 +0100
Marc Zyngier <maz@misterjones.org> wrote:

> +static irqreturn_t max732x_irq_handler(int irq, void *devid)
> +{
> +	struct max732x_chip *chip = devid;
> +	uint8_t pending;
> +	uint8_t level;
> +
> +	pending = max732x_irq_pending(chip);
> +
> +	if (!pending)
> +		return IRQ_HANDLED;

Should be IRQ_NONE?

If this device was on a shared interrupt line and the interrupt was
caused by some other device, and this handler is called first then the
incorrect IRQ_HANDLED return could cause the irq core to do wrong things.


> +	do {
> +		level = __ffs(pending);
> +		handle_nested_irq(level + chip->irq_base);
> +
> +		pending &= ~(1 << level);
> +	} while (pending);
> +
> +	return IRQ_HANDLED;
> +}

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533Ab2EALcA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 07:32:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:9819 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755009Ab2EALbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 07:31:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="138673307"
Date: Tue, 1 May 2012 13:31:30 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Michel JAOUEN <michel.jaouen@stericsson.com>,
        Maxime Coquelin <maxime.coquelin@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 5/6] mfd/ab8500: support of hierachical interrupt
Message-ID: <20120501113130.GE20224@sortiz-mobl>
References: <1334647849-1773-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334647849-1773-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Tue, Apr 17, 2012 at 09:30:49AM +0200, Linus Walleij wrote:
> +static irqreturn_t ab8500_hierarchical_irq(int irq, void *dev)
> +{
> +	struct ab8500 *ab8500 = dev;
> +	int i;
> +
> +	dev_vdbg(ab8500->dev, "interrupt\n");
> +
> +	/*  Hierarchical interrupt version */
> +	for (i = 0; i < AB8500_IT_LATCHHIER_NUM; i++) {
> +		int status;
> +		u8 hier_val;
> +
> +		status = get_register_interruptible(ab8500, AB8500_INTERRUPT,
> +			AB8500_IT_LATCHHIER1_REG + i, &hier_val);
> +		if (status < 0 || hier_val == 0)
> +			continue;
> +
> +		do {
> +			int latch_bit = __ffs(hier_val);
> +			u8 offset = i * 8 + latch_bit;
> +			u8 latch_val;
> +
> +			/* Fix inconsistent ITFromLatch25 bit mapping... */
> +			if (unlikely(offset == 17))
> +				offset = 24;
> +
> +			status = get_register_interruptible(ab8500,
> +					AB8500_INTERRUPT,
> +					AB8500_IT_LATCH1_REG + offset,
> +					&latch_val);
> +			if (status < 0 || latch_val == 0)
> +				goto discard;
> +
> +			do {
> +				int int_bit = __ffs(latch_val);
> +				int line;
> +				int j;
> +
> +				for (j = 0; j < ab8500->mask_size; j++)
> +					if (ab8500->irq_reg_offset[j] == offset)
> +						break;
> +
> +				if (j >= ab8500->mask_size) {
> +					dev_err(ab8500->dev,
> +							"Register offset 0x%2x not declared\n",
> +							offset);
> +					return IRQ_HANDLED;
> +				}
> +
> +				line = j * 8 + int_bit;
> +
> +				handle_nested_irq(ab8500->irq_base + line);
> +				latch_val &= ~(1 << int_bit);
> +			} while (latch_val);
> +discard:
> +			hier_val &= ~(1 << latch_bit);
> +		} while (hier_val);
> +	}
> +	return IRQ_HANDLED;
> +}
With 4 nested loops, this one is getting difficult to read. Have you
considered splitting the loops into separate routines ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

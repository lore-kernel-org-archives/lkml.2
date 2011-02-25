Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932468Ab1BYJys (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 04:54:48 -0500
Received: from www.tglx.de ([62.245.132.106]:49059 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932375Ab1BYJyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 04:54:46 -0500
Date: Fri, 25 Feb 2011 10:54:28 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Pratheesh Gangadhar <pratheesh@ti.com>
cc: davinci-linux-open-source@linux.davincidsp.com, hjk@hansjkoch.de,
        gregkh@suse.de, sshtylyov@mvista.com, arnd@arndb.de,
        amit.chatterjee@ti.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 1/2] PRUSS UIO driver support
In-Reply-To: <1298623530-10294-2-git-send-email-pratheesh@ti.com>
Message-ID: <alpine.LFD.2.00.1102251049090.2701@localhost6.localdomain6>
References: <1298623530-10294-1-git-send-email-pratheesh@ti.com> <1298623530-10294-2-git-send-email-pratheesh@ti.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Feb 2011, Pratheesh Gangadhar wrote:
> +static irqreturn_t pruss_handler(int irq, struct uio_info *dev_info)
> +{
> +	void __iomem *base = dev_info->mem[0].internal_addr;
> +	void __iomem *intren_reg = base + PINTC_HIER;
> +	void __iomem *intrstat_reg = base + PINTC_HIPIR + ((irq - 1) << 2);
> +	int val = ioread32(intren_reg), intr_mask = (1 << (irq - 1));
> +
> +	/* Is interrupt enabled and active ? */
> +	if (!(val & intr_mask) && (ioread32(intrstat_reg) & HIPIR_NOPEND))
> +		return IRQ_NONE;
> +
> +	/* Disable interrupt */
> +	iowrite32((val & ~intr_mask), intren_reg);
> +	return IRQ_HANDLED;
> +}

Hmm, just noticed, that you fiddle with the interrupt enable register
here totally unprotected. So on a SMP system you might haandle two
different interrupts at the same time. That wants locking.

And even on UP, you have a problem as you reenable that thing from
user space which requires a read modify write. Racy as hell.

Please look at the other UIO drivers which have the same problem.
Sorry for not noticing earlier!

Thanks,

	tglx


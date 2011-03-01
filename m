Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117Ab1CAVpn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 16:45:43 -0500
Received: from www.tglx.de ([62.245.132.106]:43453 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755684Ab1CAVpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 16:45:42 -0500
Date: Tue, 1 Mar 2011 22:45:25 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Pratheesh Gangadhar <pratheesh@ti.com>
cc: linux-kernel@vger.kernel.org, hjk@hansjkoch.de, gregkh@suse.de,
        sshtylyov@mvista.com, arnd@arndb.de, amit.chatterjee@ti.com,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v7 1/1] PRUSS UIO driver support
In-Reply-To: <1299014895-2022-2-git-send-email-pratheesh@ti.com>
Message-ID: <alpine.LFD.2.00.1103012238360.2701@localhost6.localdomain6>
References: <1299014895-2022-1-git-send-email-pratheesh@ti.com> <1299014895-2022-2-git-send-email-pratheesh@ti.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Mar 2011, Pratheesh Gangadhar wrote:
> +
> +static DEFINE_SPINLOCK(lock);
> +static struct clk *pruss_clk;
> +static struct uio_info *info;
> +static dma_addr_t sram_paddr, ddr_paddr;
> +static void *prussio_vaddr, *sram_vaddr, *ddr_vaddr;
> +
> +static irqreturn_t pruss_handler(int irq, struct uio_info *info)
> +{
> +	int intr_bit = (irq - IRQ_DA8XX_EVTOUT0 + 2);
> +	int val, intr_mask = (1 << intr_bit);
> +	void __iomem *base = info->mem[0].internal_addr;
> +	void __iomem *intren_reg = base + PINTC_HIER;
> +	void __iomem *intrstat_reg = base + PINTC_HIPIR + (intr_bit << 2);
> +
> +	spin_lock_irq(&lock);

No, I said: spin_lock() is sufficient.

> +	val = ioread32(intren_reg);
> +	/* Is interrupt enabled and active ? */
> +	if (!(val & intr_mask) && (ioread32(intrstat_reg) & HIPIR_NOPEND)) {
> +		spin_unlock_irq(&lock);

You unconditinally enable interrupts here where you are not supposed
to do so.

> +		return IRQ_NONE;
> +	}
> +
> +	/* Disable interrupt */
> +	iowrite32((val & ~intr_mask), intren_reg);
> +	spin_unlock_irq(&lock);
> +	return IRQ_HANDLED;
> +}
> +
> +static int pruss_irqcontrol(struct uio_info *info, s32 irq_on)
> +{
> +	int intr_bit = info->irq - IRQ_DA8XX_EVTOUT0 + 2;
> +	int val, intr_mask = (1 << intr_bit);
> +	void __iomem *base = info->mem[0].internal_addr;
> +	void __iomem *intren_reg = base + PINTC_HIER;
> +
> +	spin_lock_irq(&lock);

This one is correct, as this is always called from non interrupt
disabled context.

> +	val = ioread32(intren_reg);
> +	if (irq_on)
> +		iowrite32((val | intr_mask), intren_reg);
> +	else
> +		iowrite32((val & ~intr_mask), intren_reg);
> +	spin_unlock_irq(&lock);
> +
> +	return 0;
> +}


> +
> +	spin_lock_init(&lock);

Sigh. DEFINE_SPINLOCK(lock); already initializes the lock.

It's not the purpose of a review to tell you what you need to change
mechanically. Reviewers hint to a correct solution and you are
supposed to lookup what that solution means and act accordingly. If
you do not understand the hint or its implications please ask _before_
sending a new patch set.

Thanks,

	tglx

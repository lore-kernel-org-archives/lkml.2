Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab1CAJwF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 04:52:05 -0500
Received: from www.tglx.de ([62.245.132.106]:58795 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756084Ab1CAJwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 04:52:03 -0500
Date: Tue, 1 Mar 2011 10:51:43 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Pratheesh Gangadhar <pratheesh@ti.com>
cc: linux-kernel@vger.kernel.org, hjk@hansjkoch.de, gregkh@suse.de,
        sshtylyov@mvista.com, arnd@arndb.de, amit.chatterjee@ti.com,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v6 1/1] PRUSS UIO driver support
In-Reply-To: <1298926895-5294-2-git-send-email-pratheesh@ti.com>
Message-ID: <alpine.LFD.2.00.1103011045340.2701@localhost6.localdomain6>
References: <1298926895-5294-1-git-send-email-pratheesh@ti.com> <1298926895-5294-2-git-send-email-pratheesh@ti.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Mar 2011, Pratheesh Gangadhar wrote:
> +
> +static spinlock_t lock;

static DEFINE_SPINLOCK(lock);

> +static struct clk *pruss_clk;
> +static struct uio_info *info;
> +static dma_addr_t sram_paddr, ddr_paddr;
> +static void *prussio_vaddr, *sram_vaddr, *ddr_vaddr;
> +
> +static irqreturn_t pruss_handler(int irq, struct uio_info *dev_info)
> +{
> +	unsigned long flags;
> +	int val, intr_mask = (1 << (irq - 1));
> +	void __iomem *base = dev_info->mem[0].internal_addr;
> +	void __iomem *intren_reg = base + PINTC_HIER;
> +	void __iomem *intrstat_reg = base + PINTC_HIPIR + ((irq - 1) << 2);
> +
> +	spin_lock_irqsave(&lock, flags);

spin_lock() is enough as we run handlers with interrupts disabled.

> +	val = ioread32(intren_reg);
> +	/* Is interrupt enabled and active ? */
> +	if (!(val & intr_mask) && (ioread32(intrstat_reg) & HIPIR_NOPEND)) {
> +		spin_unlock_irqrestore(&lock, flags);
> +		return IRQ_NONE;
> +	}
> +
> +	/* Disable interrupt */
> +	iowrite32((val & ~intr_mask), intren_reg);
> +	spin_unlock_irqrestore(&lock, flags);
> +	return IRQ_HANDLED;
> +}

So now you still have not solved the problem of user space enabling an
interrupt again. That's racy as well and you can solve it by providing
an uio->irq_control function which handles the interrupt enable
register under the lock as well.

Thanks,

	tglx



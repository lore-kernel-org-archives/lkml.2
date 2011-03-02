Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab1CBIsS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 03:48:18 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:37171 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755634Ab1CBIsQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 03:48:16 -0500
From: "TK, Pratheesh Gangadhar" <pratheesh@ti.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hjk@hansjkoch.de" <hjk@hansjkoch.de>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "sshtylyov@mvista.com" <sshtylyov@mvista.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "Chatterjee, Amit" <amit.chatterjee@ti.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Wed, 2 Mar 2011 14:17:42 +0530
Subject: RE: [PATCH v7 1/1] PRUSS UIO driver support
Thread-Topic: [PATCH v7 1/1] PRUSS UIO driver support
Thread-Index: AcvYWgOumzf0JrIaSf6AYgJtHISiUgAV67uQ
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024BF36776@dbde02.ent.ti.com>
References: <1299014895-2022-1-git-send-email-pratheesh@ti.com>
 <1299014895-2022-2-git-send-email-pratheesh@ti.com>
 <alpine.LFD.2.00.1103012238360.2701@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1103012238360.2701@localhost6.localdomain6>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> From: Thomas Gleixner [mailto:tglx@linutronix.de]
> Sent: Wednesday, March 02, 2011 3:15 AM
> > +
> > +static DEFINE_SPINLOCK(lock);
> > +static struct clk *pruss_clk;
> > +static struct uio_info *info;
> > +static dma_addr_t sram_paddr, ddr_paddr;
> > +static void *prussio_vaddr, *sram_vaddr, *ddr_vaddr;
> > +
> > +static irqreturn_t pruss_handler(int irq, struct uio_info *info)
> > +{
> > +	int intr_bit = (irq - IRQ_DA8XX_EVTOUT0 + 2);
> > +	int val, intr_mask = (1 << intr_bit);
> > +	void __iomem *base = info->mem[0].internal_addr;
> > +	void __iomem *intren_reg = base + PINTC_HIER;
> > +	void __iomem *intrstat_reg = base + PINTC_HIPIR + (intr_bit << 2);
> > +
> > +	spin_lock_irq(&lock);
> 
> No, I said: spin_lock() is sufficient.
Ok. 
> > +	val = ioread32(intren_reg);
> > +	/* Is interrupt enabled and active ? */
> > +	if (!(val & intr_mask) && (ioread32(intrstat_reg) & HIPIR_NOPEND)) {
> > +		spin_unlock_irq(&lock);
> 
> You unconditinally enable interrupts here where you are not supposed
> to do so.
> 
Ok.
> > +		return IRQ_NONE;
> > +	}
> > +
> > +	/* Disable interrupt */
> > +	iowrite32((val & ~intr_mask), intren_reg);

I checked more on this and actually INTC h/w has Host Interrupt
Enable Indexed Set Register (HIEISR) and Host Interrupt Enable Indexed
Clear Register(HIEICR) which I can use to enable/disable interrupts
without doing RMW. I will use these registers and then we don't need
all the spinlock and irqcontrol stuff. So I need to do

iowrite32((intr_bit, HIEICR);// This disable the interrupt bit
in intern_reg.

Userspace can use HIEISR to re-enable the interrupt.

> > +	spin_unlock_irq(&lock);
> > +	return IRQ_HANDLED;
> > +}
> > +
> > +static int pruss_irqcontrol(struct uio_info *info, s32 irq_on)
> > +{
> > +	int intr_bit = info->irq - IRQ_DA8XX_EVTOUT0 + 2;
> > +	int val, intr_mask = (1 << intr_bit);
> > +	void __iomem *base = info->mem[0].internal_addr;
> > +	void __iomem *intren_reg = base + PINTC_HIER;
> > +
> > +	spin_lock_irq(&lock);
> 
> This one is correct, as this is always called from non interrupt
> disabled context.
> 
> > +	val = ioread32(intren_reg);
> > +	if (irq_on)
> > +		iowrite32((val | intr_mask), intren_reg);
> > +	else
> > +		iowrite32((val & ~intr_mask), intren_reg);
> > +	spin_unlock_irq(&lock);
> > +
> > +	return 0;
> > +}
> 
> 
> > +
> > +	spin_lock_init(&lock);
> 
> Sigh. DEFINE_SPINLOCK(lock); already initializes the lock.
> 
> It's not the purpose of a review to tell you what you need to change
> mechanically. Reviewers hint to a correct solution and you are
> supposed to lookup what that solution means and act accordingly. If
> you do not understand the hint or its implications please ask _before_
> sending a new patch set.

Seriously, I went to "fix the comments" mode. Sorry about that. Anyway
I learnt more about things by making mistakes i.e. the positive side.
Thanks a lot for helping us improve on this. 

Pratheesh

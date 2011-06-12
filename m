Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab1FLSxt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 14:53:49 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57832 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415Ab1FLSxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 14:53:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=neS6oR/ykksZ6QsiKT5a/43kdKgj5KDPpW8LlzGWB/5t/VlLh30klXIWsDFFlBptfD
         QDfv2HWF4aAQnnEWu0yqEuu294OiWVxVKtSiri3eJo0M9QkuUIbQCwV2EyLV9Rokz3Cr
         7nEStJZ1N5ikgjlwmxWfhZGxWf41Ym91NRkp8=
MIME-Version: 1.0
Date: Sun, 12 Jun 2011 20:53:46 +0200
Message-ID: <BANLkTi=urdW0WBHcVbVzDwwLzupP_Vh2EA@mail.gmail.com>
Subject: chained irq handler problems
From: Manuel Lauss <manuel.lauss@googlemail.com>
To: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Thomas,

I've been struggling to get an external IRQ multiplexer to work with the
chained handler infrastructure, and I was wondering whether you could shed
some light on it:

The code below is the one that works: in the ->irq_startup callback it
installs a "traditional" irq handler for the multiplexer cascade, and
the handler then reads the external status register and dispatches all
pending external irqs at once.

Now, when I register the cascade handler with irq_set_chained_handler() and
remove the irq_startup callback the system is overrun with an irq storm from
the external mux, which starts when userspace is booting (i.e. after
"Freeing unused kernel memory: xx" appears), rendering it effectively dead.

My question is: what are the differences in interrupt handling between the
"traditional" handler and the cascade handler case?
I also noticed that the cascade irq (the muxer irq line to the cpu) is not
disabled when the interrupt is serviced. Is this by design?

Thank you!
        Manuel Lauss


static irqreturn_t db1300_csc_handler(int irq, void *dev_id)
{
        unsigned short bisr = __raw_readw(__bcsr_virt + BCSR_REG_INTSTAT);

        for ( ; bisr; bisr &= bisr - 1)
                generic_handle_irq(__cscfirst + __ffs(bisr));

        return IRQ_HANDLED;
}

// mask/unmask/maskack for external ints come here

static unsigned int db1300_csc_startup(struct irq_data *d)
{
        int retval = 0;

        mutex_lock(&__cscmtx);
        if ((++__cscusecnt) == 1)
                retval = request_irq(__cscirq, &db1300_csc_handler,
                                     IRQF_TRIGGER_HIGH, "csc", 0);
        mutex_unlock(&__cscmtx);

        db1300_csc_unmask(d);

        return retval;
}

static void db1300_csc_shutdown(struct irq_data *d)
{
        db1300_csc_mask(d);

        mutex_lock(&__cscmtx);
        if ((--__cscusecnt) == 0)
                free_irq(__cscirq, &db1300_csc_handler);
        mutex_unlock(&__cscmtx);
}

static struct irq_chip db1300_csc_irq_type = {
        [...]
        .irq_startup    = db1300_csc_startup,
        .irq_shutdown   = db1300_csc_shutdown,
};

// external int initialization:
[...]
        for (irq = first; irq <= last; irq++)
                irq_set_chip_and_handler_name(irq, &db1300_csc_irq_type,
                                         handle_level_irq, "level");
[...]

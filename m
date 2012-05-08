Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319Ab2EHLPX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 07:15:23 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55071 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000Ab2EHLPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 07:15:21 -0400
Message-ID: <1336475689.1179.12.camel@mop>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to
 variable-length record buffer
From: Kay Sievers <kay@vrfy.org>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Greg Kroah-Hartmann <greg@kroah.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Date: Tue, 08 May 2012 13:14:49 +0200
In-Reply-To: <CA+1xoqdCk9FcqdLEvwgHtfrauNh=s0dDwcpaJimMC_H83N=_5w@mail.gmail.com>
References: <1336004953.4240.9.camel@mop>
	 <CA+1xoqdCk9FcqdLEvwgHtfrauNh=s0dDwcpaJimMC_H83N=_5w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.1 (3.4.1-2.fc17) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-08 at 10:48 +0200, Sasha Levin wrote:
> This patch was included in today's linux-next, and it looks like it
> broke printk on my configuration.
> 
> It's a bit hard to describe exactly what's wrong, but here are the main points:
> 
> 1. PRINTK_TIME timing information is gone.

It's always unconditionally recorded now. It looks fine in 'dmesg'
output, right?

> 2. Newline issues. It appears to be adding newlines where it
> shouldn't.

> parport0: PC-style at 0x378
> , irq 7
>  [
> PCSPP

Yeah, we need to make sure, we never merge the (always racy)
continuation printk() users with (non-racy) non-continuation users.
Therefore KERN_CONT is required to suppress the newline and to merge the
content with the earlier non-newline-terminated printk() line. 

I 'm sure, I have signed up for the job to fix what's needed here. :)

Patch for parport is below.

> 3. Things are not properly aligned, such as stack traces.

Mind sending the entire output of your 'dmesg', which shows it?

We recently just needed to fix the "<%u>" in the dump, which got
recognized as syslog prority prefixes. There might be a few more
KERN_CONT missing ...

Thanks,
Kay


From: Kay Sievers <kay@vrfy.org>
Subject: parport: use KERN_CONT in printk() continuation lines

On Tue, May 8, 2012 at 10:48 AM, Sasha Levin <levinsasha928@gmail.com> wrote:
> Before:
> [   10.110626] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
>
> After:
> parport0: PC-style at 0x378
> , irq 7
>  [
> PCSPP
> ,TRISTATE
> ]

Reported-By: Sasha Levin <levinsasha928@gmail.com>
Signed-off-by: Kay Sievers <kay@vrfy.org>
---
 drivers/parport/parport_pc.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/parport/parport_pc.c
+++ b/drivers/parport/parport_pc.c
@@ -2351,7 +2351,7 @@ struct parport *parport_pc_probe_port(un
 
 	printk(KERN_INFO "%s: PC-style at 0x%lx", p->name, p->base);
 	if (p->base_hi && priv->ecr)
-		printk(" (0x%lx)", p->base_hi);
+		printk(KERN_CONT " (0x%lx)", p->base_hi);
 	if (p->irq == PARPORT_IRQ_AUTO) {
 		p->irq = PARPORT_IRQ_NONE;
 		parport_irq_probe(p);
@@ -2362,7 +2362,7 @@ struct parport *parport_pc_probe_port(un
 		p->irq = PARPORT_IRQ_NONE;
 	}
 	if (p->irq != PARPORT_IRQ_NONE) {
-		printk(", irq %d", p->irq);
+		printk(KERN_CONT ", irq %d", p->irq);
 		priv->ctr_writable |= 0x10;
 
 		if (p->dma == PARPORT_DMA_AUTO) {
@@ -2386,21 +2386,21 @@ struct parport *parport_pc_probe_port(un
 		/* p->ops->ecp_read_data = parport_pc_ecp_read_block_pio; */
 #endif /* IEEE 1284 support */
 		if (p->dma != PARPORT_DMA_NONE) {
-			printk(", dma %d", p->dma);
+			printk(KERN_CONT ", dma %d", p->dma);
 			p->modes |= PARPORT_MODE_DMA;
 		} else
-			printk(", using FIFO");
+			printk(KERN_CONT ", using FIFO");
 	} else
 		/* We can't use the DMA channel after all. */
 		p->dma = PARPORT_DMA_NONE;
 #endif /* Allowed to use FIFO/DMA */
 
-	printk(" [");
+	printk(KERN_CONT " [");
 
 #define printmode(x) \
 	{\
 		if (p->modes & PARPORT_MODE_##x) {\
-			printk("%s%s", f ? "," : "", #x);\
+			printk(KERN_CONT "%s%s", f ? "," : "", #x);\
 			f++;\
 		} \
 	}
@@ -2416,9 +2416,9 @@ struct parport *parport_pc_probe_port(un
 	}
 #undef printmode
 #ifndef CONFIG_PARPORT_1284
-	printk("(,...)");
+	printk(KERN_CONT "(,...)");
 #endif /* CONFIG_PARPORT_1284 */
-	printk("]\n");
+	printk(KERN_CONT "]\n");
 	if (probedirq != PARPORT_IRQ_NONE)
 		printk(KERN_INFO "%s: irq %d detected\n", p->name, probedirq);
 



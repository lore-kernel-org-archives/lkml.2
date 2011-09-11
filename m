Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760093Ab1IKNk6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 09:40:58 -0400
Received: from vm4.telegraphics.com.au ([98.124.60.149]:42917 "EHLO
	vps4.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754498Ab1IKNk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 09:40:57 -0400
Date: Sun, 11 Sep 2011 23:40:50 +1000 (EST)
From: Finn Thain <fthain@telegraphics.com.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/28] m68k/irq: Switch irq_chip methods to "struct
 irq_data *data"
In-Reply-To: <1315742394-16036-8-git-send-email-geert@linux-m68k.org>
Message-ID: <alpine.LNX.2.00.1109112327500.2286@nippy.intranet>
References: <1315742394-16036-1-git-send-email-geert@linux-m68k.org> <1315742394-16036-8-git-send-email-geert@linux-m68k.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 11 Sep 2011, Geert Uytterhoeven wrote:

> diff --git a/arch/m68k/mac/macints.c b/arch/m68k/mac/macints.c
> index ffa1b3f..3cee6d2 100644
> --- a/arch/m68k/mac/macints.c
> +++ b/arch/m68k/mac/macints.c
> @@ -193,10 +193,20 @@ irqreturn_t mac_debug_handler(int, void *);
>  void mac_enable_irq(unsigned int irq);
>  void mac_disable_irq(unsigned int irq);
>  
> +static void mac_irq_enable(struct irq_data *data)
> +{
> +	mac_enable_irq(data->irq);
> +}
> +
> +static void mac_irq_disable(struct irq_data *data)
> +{
> +	mac_disable_irq(data->irq);
> +}
> +
>  static struct irq_chip mac_irq_chip = {
>  	.name		= "mac",
> -	.irq_enable	= mac_enable_irq,
> -	.irq_disable	= mac_disable_irq,
> +	.irq_enable	= mac_irq_enable,
> +	.irq_disable	= mac_irq_disable,
>  };
>  
>  void __init mac_init_IRQ(void)


I wrote a patch (below) to remove these wrapper functions from the 
m68k-genirq branch. What do you think of it? (Perhaps fold it into the 
patch above?)

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

Index: linux-m68k/arch/m68k/mac/baboon.c
===================================================================
--- linux-m68k.orig/arch/m68k/mac/baboon.c	2011-08-27 22:52:44.000000000 +1000
+++ linux-m68k/arch/m68k/mac/baboon.c	2011-08-27 22:53:10.000000000 +1000
@@ -23,9 +23,6 @@
 
 /* #define DEBUG_IRQS */
 
-extern void mac_enable_irq(unsigned int);
-extern void mac_disable_irq(unsigned int);
-
 int baboon_present;
 static volatile struct baboon *baboon;
 static unsigned char baboon_disabled;
@@ -152,7 +149,7 @@ void baboon_irq_enable(int irq)
 
 	baboon_disabled &= ~(1 << irq_idx);
 	if (!baboon_disabled)
-		mac_enable_irq(IRQ_NUBUS_C);
+		mac_irq_enable(irq_get_irq_data(IRQ_NUBUS_C));
 }
 
 void baboon_irq_disable(int irq)
@@ -165,7 +162,7 @@ void baboon_irq_disable(int irq)
 
 	baboon_disabled |= 1 << irq_idx;
 	if (baboon_disabled)
-		mac_disable_irq(IRQ_NUBUS_C);
+		mac_irq_disable(irq_get_irq_data(IRQ_NUBUS_C));
 }
 
 void baboon_irq_clear(int irq)
Index: linux-m68k/arch/m68k/mac/macints.c
===================================================================
--- linux-m68k.orig/arch/m68k/mac/macints.c	2011-08-27 22:52:44.000000000 +1000
+++ linux-m68k/arch/m68k/mac/macints.c	2011-08-27 22:52:58.000000000 +1000
@@ -190,19 +190,6 @@ irqreturn_t mac_debug_handler(int, void
 
 /* #define DEBUG_MACINTS */
 
-void mac_enable_irq(unsigned int irq);
-void mac_disable_irq(unsigned int irq);
-
-static void mac_irq_enable(struct irq_data *data)
-{
-	mac_enable_irq(data->irq);
-}
-
-static void mac_irq_disable(struct irq_data *data)
-{
-	mac_disable_irq(data->irq);
-}
-
 static struct irq_chip mac_irq_chip = {
 	.name		= "mac",
 	.irq_enable	= mac_irq_enable,
@@ -250,16 +237,17 @@ void __init mac_init_IRQ(void)
 }
 
 /*
- *  mac_enable_irq - enable an interrupt source
- * mac_disable_irq - disable an interrupt source
+ *  mac_irq_enable - enable an interrupt source
+ * mac_irq_disable - disable an interrupt source
  *   mac_clear_irq - clears a pending interrupt
- * mac_pending_irq - Returns the pending status of an IRQ (nonzero = pending)
+ * mac_irq_pending - returns the pending status of an IRQ (nonzero = pending)
  *
  * These routines are just dispatchers to the VIA/OSS/PSC routines.
  */
 
-void mac_enable_irq(unsigned int irq)
+void mac_irq_enable(struct irq_data *data)
 {
+	int irq = data->irq;
 	int irq_src = IRQ_SRC(irq);
 
 	switch(irq_src) {
@@ -292,8 +280,9 @@ void mac_enable_irq(unsigned int irq)
 	}
 }
 
-void mac_disable_irq(unsigned int irq)
+void mac_irq_disable(struct irq_data *data)
 {
+	int irq = data->irq;
 	int irq_src = IRQ_SRC(irq);
 
 	switch(irq_src) {
Index: linux-m68k/arch/m68k/include/asm/macintosh.h
===================================================================
--- linux-m68k.orig/arch/m68k/include/asm/macintosh.h	2011-08-27 22:52:44.000000000 +1000
+++ linux-m68k/arch/m68k/include/asm/macintosh.h	2011-08-27 22:52:58.000000000 +1000
@@ -12,6 +12,8 @@ extern void mac_reset(void);
 extern void mac_poweroff(void);
 extern void mac_init_IRQ(void);
 extern int mac_irq_pending(unsigned int);
+extern void mac_irq_enable(struct irq_data *data);
+extern void mac_irq_disable(struct irq_data *data);
 
 /*
  *	Floppy driver magic hook - probably shouldn't be here

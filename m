Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab1JTDpS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 23:45:18 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64643 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102Ab1JTDpR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 23:45:17 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1110171055570.3240@ionos>
References: <1318817327-4589-1-git-send-email-nobuhiro.iwamatsu.yj@renesas.com>
 <1318817327-4589-2-git-send-email-nobuhiro.iwamatsu.yj@renesas.com> <alpine.LFD.2.02.1110171055570.3240@ionos>
From: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Date: Thu, 20 Oct 2011 12:44:55 +0900
X-Google-Sender-Auth: N0DKWr-ik6QMi2TzXZmq3ryaXYw
Message-ID: <CABMQnVKpFnRwy1ujwQ5aeDn8M3iKYTgWTMK13iUY-_0V_Jw1WQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] irq: Add function pointer table for generic-chip
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2011/10/17 Thomas Gleixner <tglx@linutronix.de>:
> On Mon, 17 Oct 2011, Nobuhiro Iwamatsu wrote:
>
>> This adds the function table to access it with function pointer
>> by some functions providedd in generic-chip.
>> The driver who uses the function offered in generic-chip can use
>> this via this function table.
>>
>> -/* Generic chip callback functions */
>> -void irq_gc_noop(struct irq_data *d);
>> -void irq_gc_mask_disable_reg(struct irq_data *d);
>> -void irq_gc_mask_set_bit(struct irq_data *d);
>> -void irq_gc_mask_clr_bit(struct irq_data *d);
>> -void irq_gc_unmask_enable_reg(struct irq_data *d);
>> -void irq_gc_ack_set_bit(struct irq_data *d);
>> -void irq_gc_ack_clr_bit(struct irq_data *d);
>> -void irq_gc_mask_disable_reg_and_ack(struct irq_data *d);
>> -void irq_gc_eoi(struct irq_data *d);
>> -int irq_gc_set_wake(struct irq_data *d, unsigned int on);
>
> This breaks the world and some more. We have code which references
> those functions directly.
>
>> +             gc->functions.gc_noop = irq_gc_noop;
>> +             gc->functions.gc_mask_disable_reg = irq_gc_mask_disable_reg;
>> +             gc->functions.gc_mask_set_bit = irq_gc_mask_set_bit;
>> +             gc->functions.gc_mask_clr_bit = irq_gc_mask_clr_bit;
>> +             gc->functions.gc_unmask_enable_reg = irq_gc_unmask_enable_reg;
>> +             gc->functions.gc_ack_set_bit = irq_gc_ack_set_bit;
>> +             gc->functions.gc_ack_clr_bit = irq_gc_ack_clr_bit;
>> +             gc->functions.gc_mask_disable_reg_and_ack = irq_gc_mask_disable_reg_and_ack;
>> +             gc->functions.gc_eoi = irq_gc_eoi;
>> +             gc->functions.gc_set_wake = irq_gc_set_wake;
>
> Why do you want to add that to every instance of generic irq chip?
> What I asked for is:
>
> struct bla {
>       .noop = irq_gc_noop,
>       ...
> };
> EXPORT_SYMBOL_GPL(bla);
>
> Now when we have this, we can run a coccinelle script over the tree
> and convert all current users to use bla.fun instead of the direct
> functions and then make those static.
>

OK, I misled about your point.
You do not make many symbols by EXPORT_SYMBOL,
genetic_chip makes the object with the function pointer, and you
suggest that each
driver uses the function defined in the object.
Is it correct?

I created new patch. could you check this?

-----

>From c8b422d8bf3d1575a48d62ac6f785e86b36a8709 Mon Sep 17 00:00:00 2001
From: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Date: Wed, 19 Oct 2011 12:23:19 +0900
Subject: [PATCH] irq: Add function pointer table for generic-chip

This adds the function table to access it with function pointer
by some functions providedd in generic-chip.
The driver who uses the function offered in generic-chip can use
this via this function table.

For example, driver is used as follows.
...
chip.irq_ack = &irq_gc_function_tbl.ack_set_bit;
chip.irq_mask = &irq_gc_function_tbl.mask_clr_bit;
...

Signed-off-by: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
---
 include/linux/irq.h       |   16 ++++++++++++++++
 kernel/irq/generic-chip.c |   18 ++++++++++++++++++
 2 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index bff29c5..8b271cc 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -700,6 +700,22 @@ void irq_gc_mask_disable_reg_and_ack(struct irq_data *d);
 void irq_gc_eoi(struct irq_data *d);
 int irq_gc_set_wake(struct irq_data *d, unsigned int on);

+/* Generic chip callback function table */
+struct irq_gc_functions {
+	void (* noop)(struct irq_data *d);
+	void (* mask_disable_reg)(struct irq_data *d);
+	void (* mask_set_bit)(struct irq_data *d);
+	void (* mask_clr_bit)(struct irq_data *d);
+	void (* unmask_enable_reg)(struct irq_data *d);
+	void (* ack_set_bit)(struct irq_data *d);
+	void (* ack_clr_bit)(struct irq_data *d);
+	void (* mask_disable_reg_and_ack)(struct irq_data *d);
+	void (* eoi)(struct irq_data *d);
+	int (* set_wake)(struct irq_data *d, unsigned int on);
+};
+
+extern struct irq_gc_functions irq_gc_function_tbl;
+
 /* Setup functions for irq_chip_generic */
 struct irq_chip_generic *
 irq_alloc_generic_chip(const char *name, int nr_ct, unsigned int irq_base,
diff --git a/kernel/irq/generic-chip.c b/kernel/irq/generic-chip.c
index 6cb7613..03df526 100644
--- a/kernel/irq/generic-chip.c
+++ b/kernel/irq/generic-chip.c
@@ -183,6 +183,24 @@ int irq_gc_set_wake(struct irq_data *d, unsigned int on)
 }

 /**
+ * irq generic chip user needs to access irq_gc_XXX function using
+ * irq_gc_function_tbl.
+ */
+struct irq_gc_functions irq_gc_function_tbl ={
+	.noop = irq_gc_noop,
+	.mask_disable_reg = irq_gc_mask_disable_reg,
+	.mask_set_bit = irq_gc_mask_set_bit,
+	.mask_clr_bit = irq_gc_mask_clr_bit,
+	.unmask_enable_reg = irq_gc_unmask_enable_reg,
+	.ack_set_bit = irq_gc_ack_set_bit,
+	.ack_clr_bit = irq_gc_ack_clr_bit,
+	.mask_disable_reg_and_ack = irq_gc_mask_disable_reg_and_ack,
+	.eoi = irq_gc_eoi,
+	.set_wake = irq_gc_set_wake,
+};
+EXPORT_SYMBOL_GPL(irq_gc_function_tbl);
+
+/**
  * irq_alloc_generic_chip - Allocate a generic chip and initialize it
  * @name:	Name of the irq chip
  * @num_ct:	Number of irq_chip_type instances associated with this
-- 
1.7.7

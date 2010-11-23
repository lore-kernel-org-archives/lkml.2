Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410Ab0KWJWa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 04:22:30 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:39685 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab0KWJW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 04:22:28 -0500
Message-ID: <4CEB877D.9060709@kernel.org>
Date: Tue, 23 Nov 2010 01:21:01 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101026 SUSE/3.0.10 Thunderbird/3.0.10
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] sparseirq: Increase nr_irqs if needed
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


only do that when we need more.

For x86_64 system:
when we have 128 cpus with 5 ioapics, will have nr_irqs = 3064
	120 + 8 * 128 + 120 * 16
systems could take 20 pcie,  when intel 10g are used with
sriov and ixgbevf, every vf will need 3 irqs, and one device
have 64 vf. so will need 20 * 3 * 64 = 3840.
some 6 ports Intel 10gb may need more.

with this patch, nr_irqs will increase 25% every time if nr_irqs is not
big enough.

Also later We could change nr_irqs initial value to
	 min(nr_irqs_gsi, 224*nr_cpu_ids).
for x86.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 kernel/irq/irqdesc.c |   29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

Index: linux-2.6/kernel/irq/irqdesc.c
===================================================================
--- linux-2.6.orig/kernel/irq/irqdesc.c
+++ linux-2.6/kernel/irq/irqdesc.c
@@ -301,6 +301,27 @@ void irq_free_descs(unsigned int from, u
 	mutex_unlock(&sparse_irq_lock);
 }
 
+static bool increase_nr_irqs(void)
+{
+#ifdef CONFIG_SPARSE_IRQ
+	int new;
+
+	if (nr_irqs == NR_IRQS)
+		return false;
+
+	new = nr_irqs;
+	new += nr_irqs >> 2;
+	if (new > NR_IRQS)
+		new = NR_IRQS;
+	if (new > nr_irqs) {
+		nr_irqs = new;
+		printk(KERN_INFO "nr_irqs increase to %d\n", nr_irqs);
+		return true;
+	}
+#endif
+	return false;
+}
+
 /**
  * irq_alloc_descs - allocate and initialize a range of irq descriptors
  * @irq:	Allocate for specific irq number if irq >= 0
@@ -320,14 +341,16 @@ irq_alloc_descs(int irq, unsigned int fr
 
 	mutex_lock(&sparse_irq_lock);
 
-	start = bitmap_find_next_zero_area(allocated_irqs, nr_irqs, from, cnt, 0);
+	start = bitmap_find_next_zero_area(allocated_irqs, NR_IRQS, from, cnt, 0);
 	ret = -EEXIST;
 	if (irq >=0 && start != irq)
 		goto err;
 
 	ret = -ENOMEM;
-	if (start >= nr_irqs)
-		goto err;
+	while ((start + cnt) >= nr_irqs) {
+		if (!increase_nr_irqs())
+			goto err;
+	}
 
 	bitmap_set(allocated_irqs, start, cnt);
 	mutex_unlock(&sparse_irq_lock);

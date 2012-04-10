Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758231Ab2DJAHJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 20:07:09 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46147 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab2DJAHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 20:07:07 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH] iqrdomain: Improve formatting in debugfs.
Date: Mon,  9 Apr 2012 17:06:57 -0700
Message-Id: <1334016417-18748-1-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

The irq_domain_mapping file has some interesting output when chip_data
contains leading zeros:

virq   hwirq    chip name        chip data           domain name
.
.
.
  103  0x00000  CIU2-W           0x 5e0000000000000  none
  104  0x00000  CIU2-W           0x 5f0000000000000  none
  105  0x00000  CIU2-M           0x          (null)  none
  113  0x00000  CIU2-E           0x1080000000000000  none
.
.
.

I think there should be no space in there between the "0x" and the
rest.  Also the '(null)' entry doesn't make much sense at all with a
"0x".

Instead I suggest:
.
.
.
  103  0x00000  CIU2-W           0x05e0000000000000  none
  104  0x00000  CIU2-W           0x05f0000000000000  none
  105  0x00000  CIU2-M           0x0000000000000000  none
  113  0x00000  CIU2-E           0x1080000000000000  none
.
.
.

This patch also prints the "chip data" as an 8 character wide number
for 32-bit kernels, instead of the 16 characters wide in the 64-bit
case.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 kernel/irq/irqdomain.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 481f2da..83474bf 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -642,9 +642,10 @@ static int virq_debug_show(struct seq_file *m, void *private)
 	static const char none[] = "none";
 	void *data;
 	int i;
+	int ptr_width = sizeof(void *) * 2;
 
-	seq_printf(m, "%-5s  %-7s  %-15s  %-18s  %s\n", "virq", "hwirq",
-		      "chip name", "chip data", "domain name");
+	seq_printf(m, "%-5s  %-7s  %-15s  %-*s  %s\n", "virq", "hwirq",
+		   "chip name", ptr_width + 2, "chip data", "domain name");
 
 	for (i = 1; i < nr_irqs; i++) {
 		desc = irq_to_desc(i);
@@ -667,7 +668,8 @@ static int virq_debug_show(struct seq_file *m, void *private)
 			seq_printf(m, "%-15s  ", p);
 
 			data = irq_desc_get_chip_data(desc);
-			seq_printf(m, "0x%16p  ", data);
+			seq_printf(m, "0x%0*lx  ",
+				   ptr_width, (unsigned long)data);
 
 			if (desc->irq_data.domain && desc->irq_data.domain->of_node)
 				p = desc->irq_data.domain->of_node->full_name;
-- 
1.7.2.3


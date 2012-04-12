Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966103Ab2DLW2p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 18:28:45 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:59168 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964932Ab2DLW2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 18:28:44 -0400
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        David Daney <david.daney@cavium.com>
Subject: [PATCH] irq_domain: fix type mismatch in debugfs output format
Date: Thu, 12 Apr 2012 16:28:36 -0600
Message-Id: <1334269716-2850-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sizeof(void*) returns an unsigned long, but it was being used as a width parameter to a "%-*s" format string which requires an int.  On 64 bit platforms this causes a type mismatch:

    linux/kernel/irq/irqdomain.c:575: warning: field width should have type
    'int', but argument 6 has type 'long unsigned int'

This change casts the size to an int so printf gets the right data type.

Reported-by: Andreas Schwab <schwab@linux-m68k.org>
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: David Daney <david.daney@cavium.com>
---
 kernel/irq/irqdomain.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index d34413e..0e0ba5f 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -629,7 +629,8 @@ static int virq_debug_show(struct seq_file *m, void *private)
 	int i;
 
 	seq_printf(m, "%-5s  %-7s  %-15s  %-*s  %s\n", "irq", "hwirq",
-		      "chip name", 2 * sizeof(void *) + 2, "chip data", "domain name");
+		      "chip name", (int)(2 * sizeof(void *) + 2), "chip data",
+		      "domain name");
 
 	for (i = 1; i < nr_irqs; i++) {
 		desc = irq_to_desc(i);
-- 
1.7.9.1


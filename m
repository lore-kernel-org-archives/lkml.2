Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019Ab1BUUXF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 15:23:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:38557 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485Ab1BUUXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 15:23:03 -0500
Date: Mon, 21 Feb 2011 20:22:47 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de
In-Reply-To: <4D6014F9.8040605@kernel.org>
References: <4D6014F9.8040605@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Use IRQ_BITMAP_BITS as search size in irq_alloc_descs()
Message-ID: <tip-ed4dea6e0e33a3e58d8b77b775a8f0e433e7a005@git.kernel.org>
Git-Commit-ID: ed4dea6e0e33a3e58d8b77b775a8f0e433e7a005
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 21 Feb 2011 20:22:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ed4dea6e0e33a3e58d8b77b775a8f0e433e7a005
Gitweb:     http://git.kernel.org/tip/ed4dea6e0e33a3e58d8b77b775a8f0e433e7a005
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Sat, 19 Feb 2011 11:07:37 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 21 Feb 2011 21:20:00 +0100

genirq: Use IRQ_BITMAP_BITS as search size in irq_alloc_descs()

The runtime expansion of nr_irqs does not take into account that
bitmap_find_next_zero_area() returns "start" + size in case the search
for an matching zero area fails. That results in a start value which
can be completely off and is not covered by the following
expand_nr_irqs() and possibly outside of the absolute limit. But we
use it without further checking.

Use IRQ_BITMAP_BITS as the limit for the bitmap search and expand
nr_irqs when the start bit is beyond nr_irqs. So start is always
pointing to the correct area in the bitmap. nr_irqs is just the limit
for irq enumerations, not the real limit for the irq space.

[ tglx: Let irq_expand_nr_irqs() take the new upper end so we do not
  	expand nr_irqs more than necessary. Made changelog readable ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <4D6014F9.8040605@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/irqdesc.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index 394ab6a..dbccc79 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -207,11 +207,11 @@ struct irq_desc * __ref irq_to_desc_alloc_node(unsigned int irq, int node)
 	return NULL;
 }
 
-static int irq_expand_nr_irqs(unsigned int cnt)
+static int irq_expand_nr_irqs(unsigned int nr)
 {
-	if (nr_irqs + cnt > IRQ_BITMAP_BITS)
+	if (nr > IRQ_BITMAP_BITS)
 		return -ENOMEM;
-	nr_irqs += cnt;
+	nr_irqs = nr;
 	return 0;
 }
 
@@ -298,7 +298,7 @@ static inline int alloc_descs(unsigned int start, unsigned int cnt, int node)
 	return start;
 }
 
-static int irq_expand_nr_irqs(unsigned int cnt)
+static int irq_expand_nr_irqs(unsigned int nr)
 {
 	return -ENOMEM;
 }
@@ -346,13 +346,14 @@ irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node)
 
 	mutex_lock(&sparse_irq_lock);
 
-	start = bitmap_find_next_zero_area(allocated_irqs, nr_irqs, from, cnt, 0);
+	start = bitmap_find_next_zero_area(allocated_irqs, IRQ_BITMAP_BITS,
+					   from, cnt, 0);
 	ret = -EEXIST;
 	if (irq >=0 && start != irq)
 		goto err;
 
-	if (start >= nr_irqs) {
-		ret = irq_expand_nr_irqs(cnt);
+	if (start + cnt > nr_irqs) {
+		ret = irq_expand_nr_irqs(start + cnt);
 		if (ret)
 			goto err;
 	}

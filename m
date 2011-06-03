Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901Ab1FCM7S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 08:59:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:60573 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754705Ab1FCM7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 08:59:17 -0400
Date: Fri, 3 Jun 2011 12:59:08 GMT
From: tip-bot for Mark Brown <broonie@opensource.wolfsonmicro.com>
Message-ID: <tip-c5182b8867e189e14a8df5dbfcba1c73f286e061@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        broonie@opensource.wolfsonmicro.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        broonie@opensource.wolfsonmicro.com, tglx@linutronix.de
In-Reply-To: <1307037313-15733-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1307037313-15733-1-git-send-email-broonie@opensource.wolfsonmicro.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/urgent] genirq: Ensure we locate the passed IRQ in irq_alloc_descs()
Git-Commit-ID: c5182b8867e189e14a8df5dbfcba1c73f286e061
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 03 Jun 2011 12:59:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c5182b8867e189e14a8df5dbfcba1c73f286e061
Gitweb:     http://git.kernel.org/tip/c5182b8867e189e14a8df5dbfcba1c73f286e061
Author:     Mark Brown <broonie@opensource.wolfsonmicro.com>
AuthorDate: Thu, 2 Jun 2011 18:55:13 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 3 Jun 2011 14:53:16 +0200

genirq: Ensure we locate the passed IRQ in irq_alloc_descs()

When irq_alloc_descs() is called with no base IRQ specified then it will
search for a range of IRQs starting from a specified base address. In the
case where an IRQ is specified it still does this search in order to ensure
that none of the requested range is already allocated and it still uses the
from parameter to specify the base for the search. This means that in the
case where a base is specified but from is zero (which is reasonable as
any IRQ number is in the range specified by a zero from) the function will
get confused and try to allocate the first suitably sized block of free IRQs
it finds.

Instead use a specified IRQ as the base address for the search, and insist
that any from that is specified can support that IRQ.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Link: http://lkml.kernel.org/r/1307037313-15733-1-git-send-email-broonie@opensource.wolfsonmicro.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/irqdesc.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index c7ddc87..4c60a50 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -344,6 +344,12 @@ irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node)
 	if (!cnt)
 		return -EINVAL;
 
+	if (irq >= 0) {
+		if (from > irq)
+			return -EINVAL;
+		from = irq;
+	}
+
 	mutex_lock(&sparse_irq_lock);
 
 	start = bitmap_find_next_zero_area(allocated_irqs, IRQ_BITMAP_BITS,

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932740Ab0JDUfN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 16:35:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:38326 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932719Ab0JDUfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 16:35:08 -0400
Date: Mon, 4 Oct 2010 20:34:46 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100927121842.927527393@linutronix.de>
References: <20100927121842.927527393@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Provide compat handling for chip->set_wake()
Message-ID: <tip-2f7e99bb9be6a2d8d7b808dc86037710cc8b7bf1@git.kernel.org>
Git-Commit-ID: 2f7e99bb9be6a2d8d7b808dc86037710cc8b7bf1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 04 Oct 2010 20:34:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2f7e99bb9be6a2d8d7b808dc86037710cc8b7bf1
Gitweb:     http://git.kernel.org/tip/2f7e99bb9be6a2d8d7b808dc86037710cc8b7bf1
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Mon, 27 Sep 2010 12:45:50 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 4 Oct 2010 12:43:48 +0200

genirq: Provide compat handling for chip->set_wake()

Wrap the old chip function set_wake() until the migration is complete
and the old chip functions are removed.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20100927121842.927527393@linutronix.de>
Reviewed-by: H. Peter Anvin <hpa@zytor.com>
Reviewed-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/irq/chip.c   |    7 +++++++
 kernel/irq/manage.c |    4 ++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index b7dd02a..8775dd3 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -381,6 +381,11 @@ static int compat_irq_set_type(struct irq_data *data, unsigned int type)
 	return data->chip->set_type(data->irq, type);
 }
 
+static int compat_irq_set_wake(struct irq_data *data, unsigned int on)
+{
+	return data->chip->set_wake(data->irq, on);
+}
+
 static void compat_bus_lock(struct irq_data *data)
 {
 	data->chip->bus_lock(data->irq);
@@ -451,6 +456,8 @@ void irq_chip_set_defaults(struct irq_chip *chip)
 		chip->irq_set_affinity = compat_irq_set_affinity;
 	if (chip->set_type)
 		chip->irq_set_type = compat_irq_set_type;
+	if (chip->set_wake)
+		chip->irq_set_wake = compat_irq_set_wake;
 }
 
 static inline void mask_ack_irq(struct irq_desc *desc)
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 3618362..644e8d5 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -337,8 +337,8 @@ static int set_irq_wake_real(unsigned int irq, unsigned int on)
 	struct irq_desc *desc = irq_to_desc(irq);
 	int ret = -ENXIO;
 
-	if (desc->irq_data.chip->set_wake)
-		ret = desc->irq_data.chip->set_wake(irq, on);
+	if (desc->irq_data.chip->irq_set_wake)
+		ret = desc->irq_data.chip->irq_set_wake(&desc->irq_data, on);
 
 	return ret;
 }

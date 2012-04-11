Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760540Ab2DKOWl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 10:22:41 -0400
Received: from kamaji.grokhost.net ([87.117.218.43]:54960 "EHLO
	kamaji.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760395Ab2DKOV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 10:21:27 -0400
From: Chris Boot <bootc@bootc.net>
To: linux1394-devel@lists.sourceforge.net, target-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, agrover@redhat.com, clemens@ladisch.de,
        nab@linux-iscsi.org, stefanr@s5r6.in-berlin.de,
        Chris Boot <bootc@bootc.net>
Subject: [PATCH 02/11] firewire: Move fw_card kref functions into linux/firewire.h
Date: Wed, 11 Apr 2012 15:20:34 +0100
Message-Id: <1334154043-69076-3-git-send-email-bootc@bootc.net>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1334154043-69076-1-git-send-email-bootc@bootc.net>
References: <1329317248-94128-1-git-send-email-bootc@bootc.net>
 <1334154043-69076-1-git-send-email-bootc@bootc.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When writing a firewire driver that doesn't deal with struct fw_device
objects (e.g. it only publishes FireWire units and doesn't subscribe to
them), you likely need to keep referenced to struct fw_card objects so
that you can send messages to other nodes. This patch moves
fw_card_put(), fw_card_get() and fw_card_release() into the public
include/linux/firewire.h header instead of drivers/firewire/core.h, and
adds EXPORT_SYMBOL_GPL(fw_card_release).

The firewire-sbp-target module requires these so it can keep a reference
to the fw_card object in order that it can fetch ORBs to execute and
read/write related data and status information.

Signed-off-by: Chris Boot <bootc@bootc.net>
Acked-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Clemens Ladisch <clemens@ladisch.de>
---
 drivers/firewire/core-card.c |    1 +
 drivers/firewire/core.h      |   15 ---------------
 include/linux/firewire.h     |   14 ++++++++++++++
 3 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/firewire/core-card.c b/drivers/firewire/core-card.c
index cc595eb..f5552b3 100644
--- a/drivers/firewire/core-card.c
+++ b/drivers/firewire/core-card.c
@@ -676,6 +676,7 @@ void fw_card_release(struct kref *kref)
 
 	complete(&card->done);
 }
+EXPORT_SYMBOL_GPL(fw_card_release);
 
 void fw_core_remove_card(struct fw_card *card)
 {
diff --git a/drivers/firewire/core.h b/drivers/firewire/core.h
index 9047f55..b5a2f61 100644
--- a/drivers/firewire/core.h
+++ b/drivers/firewire/core.h
@@ -120,21 +120,6 @@ int fw_compute_block_crc(__be32 *block);
 void fw_schedule_bus_reset(struct fw_card *card, bool delayed, bool short_reset);
 void fw_schedule_bm_work(struct fw_card *card, unsigned long delay);
 
-static inline struct fw_card *fw_card_get(struct fw_card *card)
-{
-	kref_get(&card->kref);
-
-	return card;
-}
-
-void fw_card_release(struct kref *kref);
-
-static inline void fw_card_put(struct fw_card *card)
-{
-	kref_put(&card->kref, fw_card_release);
-}
-
-
 /* -cdev */
 
 extern const struct file_operations fw_device_ops;
diff --git a/include/linux/firewire.h b/include/linux/firewire.h
index 4683130..e83c24a 100644
--- a/include/linux/firewire.h
+++ b/include/linux/firewire.h
@@ -135,6 +135,20 @@ struct fw_card {
 	__be32 maint_utility_register;
 };
 
+static inline struct fw_card *fw_card_get(struct fw_card *card)
+{
+	kref_get(&card->kref);
+
+	return card;
+}
+
+void fw_card_release(struct kref *kref);
+
+static inline void fw_card_put(struct fw_card *card)
+{
+	kref_put(&card->kref, fw_card_release);
+}
+
 struct fw_attribute_group {
 	struct attribute_group *groups[2];
 	struct attribute_group group;
-- 
1.7.9.5


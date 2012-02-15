Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759468Ab2BOO4G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 09:56:06 -0500
Received: from kamaji.grokhost.net ([87.117.218.43]:42094 "EHLO
	kamaji.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754271Ab2BOOuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 09:50:46 -0500
From: Chris Boot <bootc@bootc.net>
To: linux1394-devel@lists.sourceforge.net, target-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, agrover@redhat.com, clemens@ladisch.de,
        nab@linux-iscsi.org, stefanr@s5r6.in-berlin.de,
        Chris Boot <bootc@bootc.net>
Subject: [PATCH v2 02/11] firewire: Move fw_card kref functions into linux/firewire.h
Date: Wed, 15 Feb 2012 14:47:19 +0000
Message-Id: <1329317248-94128-3-git-send-email-bootc@bootc.net>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1329317248-94128-1-git-send-email-bootc@bootc.net>
References: <1328989452-20921-1-git-send-email-bootc@bootc.net>
 <1329317248-94128-1-git-send-email-bootc@bootc.net>
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
Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-card.c |    1 +
 drivers/firewire/core.h      |   15 ---------------
 include/linux/firewire.h     |   14 ++++++++++++++
 3 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/firewire/core-card.c b/drivers/firewire/core-card.c
index 85661b0..42b180b 100644
--- a/drivers/firewire/core-card.c
+++ b/drivers/firewire/core-card.c
@@ -654,6 +654,7 @@ void fw_card_release(struct kref *kref)
 
 	complete(&card->done);
 }
+EXPORT_SYMBOL_GPL(fw_card_release);
 
 void fw_core_remove_card(struct fw_card *card)
 {
diff --git a/drivers/firewire/core.h b/drivers/firewire/core.h
index b45be57..b44657b 100644
--- a/drivers/firewire/core.h
+++ b/drivers/firewire/core.h
@@ -111,21 +111,6 @@ int fw_compute_block_crc(__be32 *block);
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
index f010307..341e51c 100644
--- a/include/linux/firewire.h
+++ b/include/linux/firewire.h
@@ -138,6 +138,20 @@ struct fw_card {
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
1.7.9


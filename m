Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998Ab1DPTcj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 15:32:39 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:37751 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab1DPTcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 15:32:32 -0400
Date: Sat, 16 Apr 2011 14:32:22 -0500
From: David Fries <david@fries.net>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH] W1: have netlink search update kernel list
Message-ID: <20110416193222.GZ26616@spacedout.fries.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.7 (SpacedOut.fries.net [127.0.0.1]); Sat, 16 Apr 2011 14:32:24 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Fries <David@Fries.net>

Reorganize so the netlink connector one wire search command will
update the kernel list of detected slave devices.  Otherwise, a newly
detected device is unusable because unless it's in the kernel list of
known devices any commands will result in ENODEV status.

Signed-off-by: David Fries <David@Fries.net>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
---
 drivers/w1/w1.c         |   12 +++++++++---
 drivers/w1/w1.h         |    4 +++-
 drivers/w1/w1_netlink.c |    5 ++++-
 3 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index b7b5014..10606c8 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -827,7 +827,7 @@ void w1_reconnect_slaves(struct w1_family *f, int attach)
 	mutex_unlock(&w1_mlock);
 }
 
-static void w1_slave_found(struct w1_master *dev, u64 rn)
+void w1_slave_found(struct w1_master *dev, u64 rn)
 {
 	struct w1_slave *sl;
 	struct w1_reg_num *tmp;
@@ -933,14 +933,15 @@ void w1_search(struct w1_master *dev, u8 search_type, w1_slave_found_callback cb
 	}
 }
 
-void w1_search_process(struct w1_master *dev, u8 search_type)
+void w1_search_process_cb(struct w1_master *dev, u8 search_type,
+	w1_slave_found_callback cb)
 {
 	struct w1_slave *sl, *sln;
 
 	list_for_each_entry(sl, &dev->slist, w1_slave_entry)
 		clear_bit(W1_SLAVE_ACTIVE, (long *)&sl->flags);
 
-	w1_search_devices(dev, search_type, w1_slave_found);
+	w1_search_devices(dev, search_type, cb);
 
 	list_for_each_entry_safe(sl, sln, &dev->slist, w1_slave_entry) {
 		if (!test_bit(W1_SLAVE_ACTIVE, (unsigned long *)&sl->flags) && !--sl->ttl)
@@ -953,6 +954,11 @@ void w1_search_process(struct w1_master *dev, u8 search_type)
 		dev->search_count--;
 }
 
+static void w1_search_process(struct w1_master *dev, u8 search_type)
+{
+	w1_search_process_cb(dev, search_type, w1_slave_found);
+}
+
 int w1_process(void *data)
 {
 	struct w1_master *dev = (struct w1_master *) data;
diff --git a/drivers/w1/w1.h b/drivers/w1/w1.h
index d8a9709..dc2f24f 100644
--- a/drivers/w1/w1.h
+++ b/drivers/w1/w1.h
@@ -193,7 +193,9 @@ void w1_destroy_master_attributes(struct w1_master *master);
 void w1_search(struct w1_master *dev, u8 search_type, w1_slave_found_callback cb);
 void w1_search_devices(struct w1_master *dev, u8 search_type, w1_slave_found_callback cb);
 struct w1_slave *w1_search_slave(struct w1_reg_num *id);
-void w1_search_process(struct w1_master *dev, u8 search_type);
+void w1_slave_found(struct w1_master *dev, u64 rn);
+void w1_search_process_cb(struct w1_master *dev, u8 search_type,
+	w1_slave_found_callback cb);
 struct w1_master *w1_search_master_id(u32 id);
 
 /* Disconnect and reconnect devices in the given family.  Used for finding
diff --git a/drivers/w1/w1_netlink.c b/drivers/w1/w1_netlink.c
index 7e667bc..55aabd9 100644
--- a/drivers/w1/w1_netlink.c
+++ b/drivers/w1/w1_netlink.c
@@ -55,6 +55,9 @@ static void w1_send_slave(struct w1_master *dev, u64 rn)
 	struct w1_netlink_cmd *cmd = (struct w1_netlink_cmd *)(hdr + 1);
 	int avail;
 
+	/* update kernel slave list */
+	w1_slave_found(dev, rn);
+
 	avail = dev->priv_size - cmd->len;
 
 	if (avail > 8) {
@@ -85,7 +88,7 @@ static int w1_process_search_command(struct w1_master *dev, struct cn_msg *msg,
 	dev->priv = msg;
 	dev->priv_size = avail;
 
-	w1_search_devices(dev, search_type, w1_send_slave);
+	w1_search_process_cb(dev, search_type, w1_send_slave);
 
 	msg->ack = 0;
 	cn_netlink_send(msg, 0, GFP_KERNEL);
-- 
1.7.2.3


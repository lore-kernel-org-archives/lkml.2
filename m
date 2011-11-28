Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab1K1UIY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 15:08:24 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63486 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab1K1UIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 15:08:23 -0500
From: Hubert Feurstein <h.feurstein@gmail.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: linux-kernel@vger.kernel.org, Hubert Feurstein <h.feurstein@gmail.com>
Subject: [PATCH] w1: add fast search for single slave bus
Date: Mon, 28 Nov 2011 21:06:47 +0100
Message-Id: <1322510807-3247-1-git-send-email-h.feurstein@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This enables a much more efficient way of device searching. It uses the
1-wire read-rom operation which allows the direct reading of the slave
address. BUT this works only with exactly one slave on the bus.

Signed-off-by: Hubert Feurstein <h.feurstein@gmail.com>
---
 drivers/w1/Kconfig |    8 ++++++++
 drivers/w1/w1.c    |   11 +++++++++++
 2 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/w1/Kconfig b/drivers/w1/Kconfig
index fd2c7bd..e5006bc 100644
--- a/drivers/w1/Kconfig
+++ b/drivers/w1/Kconfig
@@ -25,6 +25,14 @@ config W1_CON
 	  2. Userspace commands. Includes read/write and search/alarm search commands.
 	  3. Replies to userspace commands.
 
+config W1_FAST_SEARCH
+	bool "Fast search (single slave bus only!)"
+	---help---
+	  This enables a much more efficient way of device searching. It uses the
+	  1-wire read-rom operation which allows the direct reading of the slave
+	  address. BUT this works only with exactly one slave on the bus.
+	  If unsure, say 'N'.
+
 source drivers/w1/masters/Kconfig
 source drivers/w1/slaves/Kconfig
 
diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index c374978..7c648ec 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -892,6 +892,17 @@ void w1_search(struct w1_master *dev, u8 search_type, w1_slave_found_callback cb
 			break;
 		}
 
+#ifdef CONFIG_W1_FAST_SEARCH
+		if (dev->max_slave_count == 1) {
+			w1_write_8(dev, W1_READ_ROM);
+
+			if (w1_read_block(dev, (u8 *)&rn, 8) == 8 && rn)
+				cb(dev, rn);
+
+			break;
+		}
+#endif
+
 		/* Start the search */
 		w1_write_8(dev, search_type);
 		for (i = 0; i < 64; ++i) {
-- 
1.7.4.1


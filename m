Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749Ab1LDQrR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 11:47:17 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45625 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665Ab1LDQrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 11:47:13 -0500
From: Hubert Feurstein <h.feurstein@gmail.com>
To: zbr@ioremap.net, jeff.dagenais@gmail.com
Cc: linux-kernel@vger.kernel.org, Hubert Feurstein <h.feurstein@gmail.com>
Subject: [PATCH v2] w1: add fast search for single slave bus
Date: Sun,  4 Dec 2011 17:46:50 +0100
Message-Id: <1323017210-14666-1-git-send-email-h.feurstein@gmail.com>
X-Mailer: git-send-email 1.7.7.4
In-Reply-To: <258EF057-8FF6-4432-A9E5-77F87607C45F@gmail.com>
References: <258EF057-8FF6-4432-A9E5-77F87607C45F@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This enables a much more efficient way of device searching. It uses the
1-wire read-rom operation which allows the direct reading of the slave
address. BUT this works only with exactly one slave on the bus.

Signed-off-by: Hubert Feurstein <h.feurstein@gmail.com>
---
 v2: remove config option

 drivers/w1/w1.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index c374978..9761950 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -892,6 +892,16 @@ void w1_search(struct w1_master *dev, u8 search_type, w1_slave_found_callback cb
 			break;
 		}
 
+		/* Do fast search on single slave bus */
+		if (dev->max_slave_count == 1) {
+			w1_write_8(dev, W1_READ_ROM);
+
+			if (w1_read_block(dev, (u8 *)&rn, 8) == 8 && rn)
+				cb(dev, rn);
+
+			break;
+		}
+
 		/* Start the search */
 		w1_write_8(dev, search_type);
 		for (i = 0; i < 64; ++i) {
-- 
1.7.7.4


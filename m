Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043Ab2H1Ner (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 09:34:47 -0400
Received: from noserose.net ([66.220.18.76]:59813 "HELO noserose.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752757Ab2H1Neq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 09:34:46 -0400
Message-Id: <40ed5d0a752c872e74d5c2c06cd27ff3528af6bd.1346158422.git.ecashin@coraid.com>
In-Reply-To: <cover.1346158422.git.ecashin@coraid.com>
References: <cover.1346158422.git.ecashin@coraid.com>
From: Ed Cashin <ecashin@coraid.com>
Date: Sat, 25 Aug 2012 10:39:50 -0400
Subject: [PATCH 07/14] aoe: do revalidation steps in order
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ecashin@coraid.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The discovery process begins with an optional AoE config query command
and an AoE config query response.  Normally when an aoe device is
already open, the config query response does not trigger an ATA
identify device command to be sent out, since the response contains
storage capacity information that, if changed, could surprise the user
of the device.

The userland "aoe-revalidate" tool uses a character device to trigger
an AoE config query for a particular AoE storage target and an ATA
device identify command, even when the device is open.

This change causes the config query to go out first, reflecting the
normal discovery sequence.  The responses could come back in any
order, so this change is fairly cosmetic.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoechr.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/aoe/aoechr.c b/drivers/block/aoe/aoechr.c
index 3557f0d..acdd0ad 100644
--- a/drivers/block/aoe/aoechr.c
+++ b/drivers/block/aoe/aoechr.c
@@ -96,13 +96,14 @@ revalidate(const char __user *str, size_t size)
 		return -EINVAL;
 	spin_lock_irqsave(&d->lock, flags);
 	aoecmd_cleanslate(d);
+	aoecmd_cfg(major, minor);
 loop:
 	skb = aoecmd_ata_id(d);
 	spin_unlock_irqrestore(&d->lock, flags);
 	/* try again if we are able to sleep a bit,
 	 * otherwise give up this revalidation
 	 */
-	if (!skb && !msleep_interruptible(200)) {
+	if (!skb && !msleep_interruptible(250)) {
 		spin_lock_irqsave(&d->lock, flags);
 		goto loop;
 	}
@@ -113,7 +114,6 @@ loop:
 		__skb_queue_tail(&queue, skb);
 		aoenet_xmit(&queue);
 	}
-	aoecmd_cfg(major, minor);
 	return 0;
 }
 
-- 
1.7.2.5


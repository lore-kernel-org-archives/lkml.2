Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325Ab2KIAYD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 19:24:03 -0500
Received: from dupo.coraid.com ([208.71.232.133]:49836 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753755Ab2KIAYC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 19:24:02 -0500
Message-Id: <a12d57ea99f89b84b32e503db04f63bb12b42283.1352410985.git.ecashin@coraid.com>
In-Reply-To: <cover.1352410985.git.ecashin@coraid.com>
References: <cover.1352410985.git.ecashin@coraid.com>
From: Ed Cashin <ecashin@coraid.com>
Subject: [PATCH 4/8] aoe: err device: include MAC addresses for unexpected responses
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ecashin@coraid.com
From: Ed Cashin <ecashin@coraid.com>
X-Mailer: nedmail
Date: Thu, 8 Nov 2012 19:23:16 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The /dev/etherd/err character device provides low-level
information about normal but sometimes interesting AoE command
retransmits and "unexpected responses", i.e., responses for
packets that have already been retransmitted.

This change adds MAC addresses to the messages about unexpected
responses, so that when they occur, it's more easy to determine
the network paths to which they belong.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoecmd.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index f849fa2..6ea27fd 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -1204,12 +1204,14 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 			spin_unlock_irqrestore(&d->lock, flags);
 			aoedev_put(d);
 			snprintf(ebuf, sizeof(ebuf),
-				 "%15s e%d.%d    tag=%08x@%08lx\n",
+				 "%15s e%d.%d    tag=%08x@%08lx s=%pm d=%pm\n",
 				 "unexpected rsp",
 				 get_unaligned_be16(&h->major),
 				 h->minor,
 				 get_unaligned_be32(&h->tag),
-				 jiffies);
+				 jiffies,
+				 h->src,
+				 h->dst);
 			aoechr_error(ebuf);
 			return skb;
 		}
-- 
1.7.1


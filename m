Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758330Ab1FFWic (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 18:38:32 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:39469
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758201Ab1FFWfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 18:35:03 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>
Subject: [PATCH 42/49] Staging: hv: vmbus: Properly handle memory allocation failure in channel.c
Date: Mon,  6 Jun 2011 15:50:06 -0700
Message-Id: <1307400613-13234-42-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307400613-13234-1-git-send-email-kys@microsoft.com>
References: <1307400540-13193-1-git-send-email-kys@microsoft.com>
 <1307400613-13234-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Properly handle memory allocation failure in channel.c.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
---
 drivers/staging/hv/channel.c |   19 +++++++++++++++++--
 1 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/hv/channel.c b/drivers/staging/hv/channel.c
index 69b5641..1833f27 100644
--- a/drivers/staging/hv/channel.c
+++ b/drivers/staging/hv/channel.c
@@ -355,9 +355,24 @@ static int create_gpadl_header(void *kbuffer, u32 size,
 				  sizeof(struct vmbus_channel_gpadl_body) +
 				  pfncurr * sizeof(u64);
 			msgbody = kzalloc(msgsize, GFP_KERNEL);
-			/* FIXME: we probably need to more if this fails */
-			if (!msgbody)
+
+			if (!msgbody) {
+				struct vmbus_channel_msginfo *pos = NULL;
+				struct vmbus_channel_msginfo *tmp = NULL;
+				/*
+				 * Free up all the allocated messages.
+				 */
+				list_for_each_entry_safe(pos, tmp,
+					&msgheader->submsglist,
+					msglistentry) {
+
+					list_del(&pos->msglistentry);
+					kfree(pos);
+				}
+
 				goto nomem;
+			}
+
 			msgbody->msgsize = msgsize;
 			(*messagecount)++;
 			gpadl_body =
-- 
1.7.4.1


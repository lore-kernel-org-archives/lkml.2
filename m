Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965189Ab2CMA1e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:27:34 -0400
Received: from mail.windriver.com ([147.11.1.11]:49046 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965264Ab2CMAZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:25:05 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Paul Fox <pgf@laptop.org>,
        Daniel Drake <dsd@laptop.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 178/196] libertas: fix cmdpendingq locking
Date: Mon, 12 Mar 2012 20:21:31 -0400
Message-Id: <1331598109-31424-133-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Fox <pgf@laptop.org>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 2ae1b8b35faba31a59b153cbad07f9c15de99740 upstream.

We occasionally see list corruption using libertas.

While we haven't been able to diagnose this precisely, we have spotted
a possible cause: cmdpendingq is generally modified with driver_lock
held. However, there are a couple of points where this is not the case.

Fix up those operations to execute under the lock, it seems like
the correct thing to do and will hopefully improve the situation.

Signed-off-by: Paul Fox <pgf@laptop.org>
Signed-off-by: Daniel Drake <dsd@laptop.org>
Acked-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/net/wireless/libertas/cmd.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index cdb9b96..91bafae 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -1267,8 +1267,8 @@ int lbs_execute_next_command(struct lbs_private *priv)
 				    cpu_to_le16(CMD_SUBCMD_EXIT_PS)) {
 					lbs_deb_host(
 					       "EXEC_NEXT_CMD: ignore ENTER_PS cmd\n");
-					list_del(&cmdnode->list);
 					spin_lock_irqsave(&priv->driver_lock, flags);
+					list_del(&cmdnode->list);
 					lbs_complete_command(priv, cmdnode, 0);
 					spin_unlock_irqrestore(&priv->driver_lock, flags);
 
@@ -1280,8 +1280,8 @@ int lbs_execute_next_command(struct lbs_private *priv)
 				    (priv->psstate == PS_STATE_PRE_SLEEP)) {
 					lbs_deb_host(
 					       "EXEC_NEXT_CMD: ignore EXIT_PS cmd in sleep\n");
-					list_del(&cmdnode->list);
 					spin_lock_irqsave(&priv->driver_lock, flags);
+					list_del(&cmdnode->list);
 					lbs_complete_command(priv, cmdnode, 0);
 					spin_unlock_irqrestore(&priv->driver_lock, flags);
 					priv->needtowakeup = 1;
@@ -1294,7 +1294,9 @@ int lbs_execute_next_command(struct lbs_private *priv)
 				       "EXEC_NEXT_CMD: sending EXIT_PS\n");
 			}
 		}
+		spin_lock_irqsave(&priv->driver_lock, flags);
 		list_del(&cmdnode->list);
+		spin_unlock_irqrestore(&priv->driver_lock, flags);
 		lbs_deb_host("EXEC_NEXT_CMD: sending command 0x%04x\n",
 			    le16_to_cpu(cmd->command));
 		lbs_submit_command(priv, cmdnode);
-- 
1.7.9.3


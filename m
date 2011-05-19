Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934241Ab1ESSQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:16:18 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:45116 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934055Ab1ESSIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:08:54 -0400
X-Sasl-enc: cjoIpWjg9SkJmG4aJRoNif8uf6sNDRcaDbacUnGm35SF 1305828533
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May 19 11:05:58 2011
Message-Id: <20110519180558.527886779@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 19 May 2011 11:05:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Paul Fox <pgf@laptop.org>, Daniel Drake <dsd@laptop.org>,
        Dan Williams <dcbw@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [44/71] libertas: fix cmdpendingq locking
In-Reply-To: <20110519180626.GA16555@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Paul Fox <pgf@laptop.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/libertas/cmd.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -1335,8 +1335,8 @@ int lbs_execute_next_command(struct lbs_
 				    cpu_to_le16(PS_MODE_ACTION_EXIT_PS)) {
 					lbs_deb_host(
 					       "EXEC_NEXT_CMD: ignore ENTER_PS cmd\n");
-					list_del(&cmdnode->list);
 					spin_lock_irqsave(&priv->driver_lock, flags);
+					list_del(&cmdnode->list);
 					lbs_complete_command(priv, cmdnode, 0);
 					spin_unlock_irqrestore(&priv->driver_lock, flags);
 
@@ -1348,8 +1348,8 @@ int lbs_execute_next_command(struct lbs_
 				    (priv->psstate == PS_STATE_PRE_SLEEP)) {
 					lbs_deb_host(
 					       "EXEC_NEXT_CMD: ignore EXIT_PS cmd in sleep\n");
-					list_del(&cmdnode->list);
 					spin_lock_irqsave(&priv->driver_lock, flags);
+					list_del(&cmdnode->list);
 					lbs_complete_command(priv, cmdnode, 0);
 					spin_unlock_irqrestore(&priv->driver_lock, flags);
 					priv->needtowakeup = 1;
@@ -1362,7 +1362,9 @@ int lbs_execute_next_command(struct lbs_
 				       "EXEC_NEXT_CMD: sending EXIT_PS\n");
 			}
 		}
+		spin_lock_irqsave(&priv->driver_lock, flags);
 		list_del(&cmdnode->list);
+		spin_unlock_irqrestore(&priv->driver_lock, flags);
 		lbs_deb_host("EXEC_NEXT_CMD: sending command 0x%04x\n",
 			    le16_to_cpu(cmd->command));
 		lbs_submit_command(priv, cmdnode);



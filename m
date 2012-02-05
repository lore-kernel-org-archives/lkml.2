Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab2BEWnP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:43:15 -0500
Received: from 1wt.eu ([62.212.114.60]:61912 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753927Ab2BEW0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:26:25 -0500
Message-Id: <20120205220950.302168576@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:10:09 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Paul Fox <pgf@laptop.org>, Daniel Drake <dsd@laptop.org>,
        Dan Williams <dcbw@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 20/91] libertas: fix cmdpendingq locking
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

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
 1 files changed, 4 insertions(+), 2 deletions(-)

Index: longterm-2.6.27/drivers/net/wireless/libertas/cmd.c
===================================================================
--- longterm-2.6.27.orig/drivers/net/wireless/libertas/cmd.c	2012-02-05 22:34:34.401915241 +0100
+++ longterm-2.6.27/drivers/net/wireless/libertas/cmd.c	2012-02-05 22:34:37.731916421 +0100
@@ -1751,8 +1751,8 @@
 				    cpu_to_le16(CMD_SUBCMD_EXIT_PS)) {
 					lbs_deb_host(
 					       "EXEC_NEXT_CMD: ignore ENTER_PS cmd\n");
-					list_del(&cmdnode->list);
 					spin_lock_irqsave(&priv->driver_lock, flags);
+					list_del(&cmdnode->list);
 					lbs_complete_command(priv, cmdnode, 0);
 					spin_unlock_irqrestore(&priv->driver_lock, flags);
 
@@ -1764,8 +1764,8 @@
 				    (priv->psstate == PS_STATE_PRE_SLEEP)) {
 					lbs_deb_host(
 					       "EXEC_NEXT_CMD: ignore EXIT_PS cmd in sleep\n");
-					list_del(&cmdnode->list);
 					spin_lock_irqsave(&priv->driver_lock, flags);
+					list_del(&cmdnode->list);
 					lbs_complete_command(priv, cmdnode, 0);
 					spin_unlock_irqrestore(&priv->driver_lock, flags);
 					priv->needtowakeup = 1;
@@ -1778,7 +1778,9 @@
 				       "EXEC_NEXT_CMD: sending EXIT_PS\n");
 			}
 		}
+		spin_lock_irqsave(&priv->driver_lock, flags);
 		list_del(&cmdnode->list);
+		spin_unlock_irqrestore(&priv->driver_lock, flags);
 		lbs_deb_host("EXEC_NEXT_CMD: sending command 0x%04x\n",
 			    le16_to_cpu(cmd->command));
 		lbs_submit_command(priv, cmdnode);



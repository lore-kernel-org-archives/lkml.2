Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab2DBL43 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 07:56:29 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:48122 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697Ab2DBLzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:55:13 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Jiri Kosina <jkosina@suse.cz>, David Sterba <dsterba@suse.cz>
Subject: [PATCH 48/69] TTY: ipwireless, move prints to appropriate places
Date: Mon,  2 Apr 2012 13:54:32 +0200
Message-Id: <1333367693-3244-49-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
References: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two functions which only print a status. Let us do that
directly at places where they are called.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: David Sterba <dsterba@suse.cz>
---
 drivers/tty/ipwireless/tty.c |   31 ++++++++++---------------------
 1 file changed, 10 insertions(+), 21 deletions(-)

diff --git a/drivers/tty/ipwireless/tty.c b/drivers/tty/ipwireless/tty.c
index e539621..4270bfd 100644
--- a/drivers/tty/ipwireless/tty.c
+++ b/drivers/tty/ipwireless/tty.c
@@ -73,23 +73,6 @@ static char *tty_type_name(int tty_type)
 	return channel_names[tty_type];
 }
 
-static void report_registering(struct ipw_tty *tty)
-{
-	char *iftype = tty_type_name(tty->tty_type);
-
-	printk(KERN_INFO IPWIRELESS_PCCARD_NAME
-	       ": registering %s device ttyIPWp%d\n", iftype, tty->index);
-}
-
-static void report_deregistering(struct ipw_tty *tty)
-{
-	char *iftype = tty_type_name(tty->tty_type);
-
-	printk(KERN_INFO IPWIRELESS_PCCARD_NAME
-	       ": deregistering %s device ttyIPWp%d\n", iftype,
-	       tty->index);
-}
-
 static struct ipw_tty *get_tty(int index)
 {
 	/*
@@ -500,8 +483,12 @@ static int add_tty(int j,
 		ipwireless_associate_network_tty(network,
 						 secondary_channel_idx,
 						 ttys[j]);
-	if (get_tty(j) == ttys[j])
-		report_registering(ttys[j]);
+	/* check if we provide raw device (if loopback is enabled) */
+	if (get_tty(j))
+		printk(KERN_INFO IPWIRELESS_PCCARD_NAME
+		       ": registering %s device ttyIPWp%d\n",
+		       tty_type_name(tty_type), j);
+
 	return 0;
 }
 
@@ -560,8 +547,10 @@ void ipwireless_tty_free(struct ipw_tty *tty)
 
 		if (ttyj) {
 			mutex_lock(&ttyj->ipw_tty_mutex);
-			if (get_tty(j) == ttyj)
-				report_deregistering(ttyj);
+			if (get_tty(j))
+				printk(KERN_INFO IPWIRELESS_PCCARD_NAME
+				       ": deregistering %s device ttyIPWp%d\n",
+				       tty_type_name(ttyj->tty_type), j);
 			ttyj->closing = 1;
 			if (ttyj->linux_tty != NULL) {
 				mutex_unlock(&ttyj->ipw_tty_mutex);
-- 
1.7.9.2



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964776Ab2CEOF4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 09:05:56 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:34682 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932384Ab2CENxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:53:12 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Jiri Kosina <jkosina@suse.cz>, David Sterba <dsterba@suse.cz>
Subject: [PATCH 15/68] TTY: ipwireless, fix tty->index handling
Date: Mon,  5 Mar 2012 14:52:02 +0100
Message-Id: <1330955575-26641-16-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* do not test if tty->index is in bounds. It is always.
* tty->index is not a minor! Fix that.

>From now on, let's assume that the parameter of the function is tty
index with base being zero. This makes also the code more readable.

Factually, there is no real change as tty_driver->minor_start is zero,
so the tests are equivalent. But it did not make sense. And if this
had changed eventually, it would have caused troubles.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: David Sterba <dsterba@suse.cz>
---
 drivers/tty/ipwireless/tty.c |   36 +++++++++++++-----------------------
 1 file changed, 13 insertions(+), 23 deletions(-)

diff --git a/drivers/tty/ipwireless/tty.c b/drivers/tty/ipwireless/tty.c
index 6990b3b..77ceaa9 100644
--- a/drivers/tty/ipwireless/tty.c
+++ b/drivers/tty/ipwireless/tty.c
@@ -90,33 +90,23 @@ static void report_deregistering(struct ipw_tty *tty)
 	       tty->index);
 }
 
-static struct ipw_tty *get_tty(int minor)
+static struct ipw_tty *get_tty(int index)
 {
-	if (minor < ipw_tty_driver->minor_start
-			|| minor >= ipw_tty_driver->minor_start +
-			IPWIRELESS_PCMCIA_MINORS)
+	/*
+	 * The 'ras_raw' channel is only available when 'loopback' mode
+	 * is enabled.
+	 * Number of minor starts with 16 (_RANGE * _RAS_RAW).
+	 */
+	if (!ipwireless_loopback && index >=
+			 IPWIRELESS_PCMCIA_MINOR_RANGE * TTYTYPE_RAS_RAW)
 		return NULL;
-	else {
-		int minor_offset = minor - ipw_tty_driver->minor_start;
-
-		/*
-		 * The 'ras_raw' channel is only available when 'loopback' mode
-		 * is enabled.
-		 * Number of minor starts with 16 (_RANGE * _RAS_RAW).
-		 */
-		if (!ipwireless_loopback &&
-				minor_offset >=
-				 IPWIRELESS_PCMCIA_MINOR_RANGE * TTYTYPE_RAS_RAW)
-			return NULL;
-
-		return ttys[minor_offset];
-	}
+
+	return ttys[index];
 }
 
 static int ipw_open(struct tty_struct *linux_tty, struct file *filp)
 {
-	int minor = linux_tty->index;
-	struct ipw_tty *tty = get_tty(minor);
+	struct ipw_tty *tty = get_tty(linux_tty->index);
 
 	if (!tty)
 		return -ENODEV;
@@ -510,7 +500,7 @@ static int add_tty(int j,
 		ipwireless_associate_network_tty(network,
 						 secondary_channel_idx,
 						 ttys[j]);
-	if (get_tty(j + ipw_tty_driver->minor_start) == ttys[j])
+	if (get_tty(j) == ttys[j])
 		report_registering(ttys[j]);
 	return 0;
 }
@@ -570,7 +560,7 @@ void ipwireless_tty_free(struct ipw_tty *tty)
 
 		if (ttyj) {
 			mutex_lock(&ttyj->ipw_tty_mutex);
-			if (get_tty(j + ipw_tty_driver->minor_start) == ttyj)
+			if (get_tty(j) == ttyj)
 				report_deregistering(ttyj);
 			ttyj->closing = 1;
 			if (ttyj->linux_tty != NULL) {
-- 
1.7.9.2



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358Ab2KSTMM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 14:12:12 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:59945 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355Ab2KSTMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 14:12:08 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Hansjoerg Lipp <hjlipp@web.de>,
        gigaset307x-common@lists.sourceforge.net
Subject: [PATCH 1/2] TTY: isdn/gigaset destroy tty_port properly
Date: Mon, 19 Nov 2012 20:11:42 +0100
Message-Id: <1353352303-24299-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the port may be destroyed twice or destroyed without being
initialized. Fix this by sticking the destroy call in the right place
as suggested by Tilman.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Reported-by: Tilman Schmidt <tilman@imap.cc>
Cc: Hansjoerg Lipp <hjlipp@web.de>
Cc: gigaset307x-common@lists.sourceforge.net
---
 drivers/isdn/gigaset/common.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/isdn/gigaset/common.c b/drivers/isdn/gigaset/common.c
index bc9d89a..6849a11 100644
--- a/drivers/isdn/gigaset/common.c
+++ b/drivers/isdn/gigaset/common.c
@@ -507,6 +507,7 @@ void gigaset_freecs(struct cardstate *cs)
 		gig_dbg(DEBUG_INIT, "clearing at_state");
 		clear_at_state(&cs->at_state);
 		dealloc_temp_at_states(cs);
+		tty_port_destroy(&cs->port);
 
 		/* fall through */
 	case 0:	/* error in basic setup */
@@ -518,7 +519,6 @@ f_bcs:	gig_dbg(DEBUG_INIT, "freeing bcs[]");
 	kfree(cs->bcs);
 f_cs:	gig_dbg(DEBUG_INIT, "freeing cs");
 	mutex_unlock(&cs->mutex);
-	tty_port_destroy(&cs->port);
 	free_cs(cs);
 }
 EXPORT_SYMBOL_GPL(gigaset_freecs);
@@ -752,14 +752,14 @@ struct cardstate *gigaset_initcs(struct gigaset_driver *drv, int channels,
 	gig_dbg(DEBUG_INIT, "setting up iif");
 	if (gigaset_isdn_regdev(cs, modulename) < 0) {
 		pr_err("error registering ISDN device\n");
-		goto error_port;
+		goto error;
 	}
 
 	make_valid(cs, VALID_ID);
 	++cs->cs_init;
 	gig_dbg(DEBUG_INIT, "setting up hw");
 	if (cs->ops->initcshw(cs) < 0)
-		goto error_port;
+		goto error;
 
 	++cs->cs_init;
 
@@ -774,7 +774,7 @@ struct cardstate *gigaset_initcs(struct gigaset_driver *drv, int channels,
 		gig_dbg(DEBUG_INIT, "setting up bcs[%d]", i);
 		if (gigaset_initbcs(cs->bcs + i, cs, i) < 0) {
 			pr_err("could not allocate channel %d data\n", i);
-			goto error_port;
+			goto error;
 		}
 	}
 
@@ -787,8 +787,7 @@ struct cardstate *gigaset_initcs(struct gigaset_driver *drv, int channels,
 
 	gig_dbg(DEBUG_INIT, "cs initialized");
 	return cs;
-error_port:
-	tty_port_destroy(&cs->port);
+
 error:
 	gig_dbg(DEBUG_INIT, "failed");
 	gigaset_freecs(cs);
-- 
1.8.0



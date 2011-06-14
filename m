Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab1FNUgH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 16:36:07 -0400
Received: from mga01.intel.com ([192.55.52.88]:22868 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753852Ab1FNUgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 16:36:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,366,1304319600"; 
   d="scan'208";a="18190754"
From: Russ Gorby <russ.gorby@intel.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Cc: suhail.ahmed@intel.com, russ.gorby@intel.com
Subject: [PATCH] tty: n_gsm: expose gsmtty device nodes at ldisc open time
Date: Tue, 14 Jun 2011 13:35:32 -0700
Message-Id: <1308083732-9327-1-git-send-email-russ.gorby@intel.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The n_gsm driver being an ldisc, does not provide a convenient method
e.g. udev to create the tty device nodes automatically when the ldisc
is opened.

The TTY device nodes are now created via calls to tty_register_device
from the ldisc open.

Signed-off-by: Russ Gorby <russ.gorby@intel.com>
---
 drivers/tty/n_gsm.c |   19 +++++++++++++++++--
 1 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 20dd6b9..20e53db 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -169,6 +169,7 @@ struct gsm_control {
 struct gsm_mux {
 	struct tty_struct *tty;		/* The tty our ldisc is bound to */
 	spinlock_t lock;
+	unsigned int num;
 
 	/* Events on the GSM channel */
 	wait_queue_head_t event;
@@ -250,6 +251,8 @@ struct gsm_mux {
 static struct gsm_mux *gsm_mux[MAX_MUX];	/* GSM muxes */
 static spinlock_t gsm_mux_lock;
 
+static struct tty_driver *gsm_tty_driver;
+
 /*
  *	This section of the driver logic implements the GSM encodings
  *	both the basic and the 'advanced'. Reliable transport is not
@@ -2010,6 +2013,7 @@ int gsm_activate_mux(struct gsm_mux *gsm)
 	spin_lock(&gsm_mux_lock);
 	for (i = 0; i < MAX_MUX; i++) {
 		if (gsm_mux[i] == NULL) {
+			gsm->num = i;
 			gsm_mux[i] = gsm;
 			break;
 		}
@@ -2115,13 +2119,20 @@ static int gsmld_output(struct gsm_mux *gsm, u8 *data, int len)
 
 static int gsmld_attach_gsm(struct tty_struct *tty, struct gsm_mux *gsm)
 {
-	int ret;
+	int ret, i;
+	int base = gsm->num << 6; /* Base for this MUX */
 
 	gsm->tty = tty_kref_get(tty);
 	gsm->output = gsmld_output;
 	ret =  gsm_activate_mux(gsm);
 	if (ret != 0)
 		tty_kref_put(gsm->tty);
+	else {
+		/* Don't register device 0 - this is the control channel and not
+		   a usable tty interface */
+		for (i = 1; i < NUM_DLCI; i++)
+			tty_register_device(gsm_tty_driver, base + i, NULL);
+	}
 	return ret;
 }
 
@@ -2136,7 +2147,12 @@ static int gsmld_attach_gsm(struct tty_struct *tty, struct gsm_mux *gsm)
 
 static void gsmld_detach_gsm(struct tty_struct *tty, struct gsm_mux *gsm)
 {
+	int i;
+	int base = gsm->num << 6; /* Base for this MUX */
+
 	WARN_ON(tty != gsm->tty);
+	for (i = 1; i < NUM_DLCI; i++)
+		tty_unregister_device(gsm_tty_driver, base + i);
 	gsm_cleanup_mux(gsm);
 	tty_kref_put(gsm->tty);
 	gsm->tty = NULL;
@@ -2728,7 +2744,6 @@ static int gsmtty_break_ctl(struct tty_struct *tty, int state)
 	return gsmtty_modem_update(dlci, encode);
 }
 
-static struct tty_driver *gsm_tty_driver;
 
 /* Virtual ttys for the demux */
 static const struct tty_operations gsmtty_ops = {
-- 
1.7.0.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564Ab1GZNZq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 09:25:46 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:48762 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129Ab1GZNZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 09:25:41 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH RESEND] n_gsm: generate gsmtty device nodes
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 26 Jul 2011 14:27:50 +0100
Message-ID: <20110726132716.27387.21457.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Seems this one got lost somewhere but it is still relevant)

From: Ken Mills <ken.k.mills@intel.com>

The mux does not generate gsmtty device nodes in /dev.

Added call to tty_register_device in function gsmld_attach_gsm to do this.

Signed-off-by: Ken Mills <ken.k.mills@intel.com>
[Rewrote to work with multiple muxes]
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/tty/n_gsm.c |   25 ++++++++++++++++---------
 1 files changed, 16 insertions(+), 9 deletions(-)


diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 19b4ae0..fef7ccb 100644
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
@@ -1950,14 +1953,8 @@ void gsm_cleanup_mux(struct gsm_mux *gsm)
 	gsm->dead = 1;
 
 	spin_lock(&gsm_mux_lock);
-	for (i = 0; i < MAX_MUX; i++) {
-		if (gsm_mux[i] == gsm) {
-			gsm_mux[i] = NULL;
-			break;
-		}
-	}
+	gsm_mux[gsm->num] = NULL;
 	spin_unlock(&gsm_mux_lock);
-	WARN_ON(i == MAX_MUX);
 
 	del_timer_sync(&gsm->t2_timer);
 	/* Now we are sure T2 has stopped */
@@ -2010,6 +2007,7 @@ int gsm_activate_mux(struct gsm_mux *gsm)
 	spin_lock(&gsm_mux_lock);
 	for (i = 0; i < MAX_MUX; i++) {
 		if (gsm_mux[i] == NULL) {
+			gsm->num = i;
 			gsm_mux[i] = gsm;
 			break;
 		}
@@ -2115,13 +2113,18 @@ static int gsmld_output(struct gsm_mux *gsm, u8 *data, int len)
 
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
+	/* Don't register device 0 - this is the control channel and not
+	   a usable tty interface */
+	for (i = 1; i < NUM_DLCI; i++)
+		tty_register_device(gsm_tty_driver, base + i, NULL);
 	return ret;
 }
 
@@ -2136,7 +2139,12 @@ static int gsmld_attach_gsm(struct tty_struct *tty, struct gsm_mux *gsm)
 
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
@@ -2726,7 +2734,6 @@ static int gsmtty_break_ctl(struct tty_struct *tty, int state)
 	return gsmtty_modem_update(dlci, encode);
 }
 
-static struct tty_driver *gsm_tty_driver;
 
 /* Virtual ttys for the demux */
 static const struct tty_operations gsmtty_ops = {


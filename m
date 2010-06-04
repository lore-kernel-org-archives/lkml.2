Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419Ab0FDUuI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 16:50:08 -0400
Received: from kroah.org ([198.145.64.141]:44018 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932167Ab0FDUsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 16:48:03 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Dan Carpenter <error27@gmail.com>, stable <stable@kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 05/11] TTY/n_gsm: potential double lock
Date: Fri,  4 Jun 2010 13:47:51 -0700
Message-Id: <1275684477-20172-5-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100604204445.GB19761@kroah.com>
References: <20100604204445.GB19761@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>

In gsm_dlci_data_kick() we call gsm_dlci_data_sweep() with the
"gsm->tx_lock" held so we can't lock it again inside
gsm_dlci_data_sweep().  I removed that lock from and added one to
gsmld_write_wakeup() instead.  The sweep function is only called from
those two places.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Acked-by: Alan Cox <alan@linux.intel.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/n_gsm.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/char/n_gsm.c b/drivers/char/n_gsm.c
index c4161d5..e4089c4 100644
--- a/drivers/char/n_gsm.c
+++ b/drivers/char/n_gsm.c
@@ -904,9 +904,7 @@ static void gsm_dlci_data_sweep(struct gsm_mux *gsm)
 	int len;
 	/* Priority ordering: We should do priority with RR of the groups */
 	int i = 1;
-	unsigned long flags;
 
-	spin_lock_irqsave(&gsm->tx_lock, flags);
 	while (i < NUM_DLCI) {
 		struct gsm_dlci *dlci;
 
@@ -927,7 +925,6 @@ static void gsm_dlci_data_sweep(struct gsm_mux *gsm)
 		if (len == 0)
 			i++;
 	}
-	spin_unlock_irqrestore(&gsm->tx_lock, flags);
 }
 
 /**
@@ -2230,12 +2227,16 @@ static int gsmld_open(struct tty_struct *tty)
 static void gsmld_write_wakeup(struct tty_struct *tty)
 {
 	struct gsm_mux *gsm = tty->disc_data;
+	unsigned long flags;
 
 	/* Queue poll */
 	clear_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
 	gsm_data_kick(gsm);
-	if (gsm->tx_bytes < TX_THRESH_LO)
+	if (gsm->tx_bytes < TX_THRESH_LO) {
+		spin_lock_irqsave(&gsm->tx_lock, flags);
 		gsm_dlci_data_sweep(gsm);
+		spin_unlock_irqrestore(&gsm->tx_lock, flags);
+	}
 }
 
 /**
-- 
1.7.1


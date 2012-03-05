Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932538Ab2CEOKB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 09:10:01 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:34617 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932298Ab2CENxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:53:07 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        netdev@vger.kernel.org
Subject: [PATCH 16/68] NET: pc300, do not zero global variables
Date: Mon,  5 Mar 2012 14:52:03 +0100
Message-Id: <1330955575-26641-17-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They are in .bss which is initialized to zeros when the module is
loaded/kernel booted.

What a strange way to do the initialization once in the pci probe
routine...

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: netdev@vger.kernel.org
---
 drivers/net/wan/pc300_drv.c |    4 ----
 drivers/net/wan/pc300_tty.c |   18 ------------------
 2 files changed, 22 deletions(-)

diff --git a/drivers/net/wan/pc300_drv.c b/drivers/net/wan/pc300_drv.c
index 1eeedd6..a6dd00d 100644
--- a/drivers/net/wan/pc300_drv.c
+++ b/drivers/net/wan/pc300_drv.c
@@ -299,7 +299,6 @@ void cpc_tty_init(pc300dev_t * dev);
 void cpc_tty_unregister_service(pc300dev_t * pc300dev);
 void cpc_tty_receive(pc300dev_t * pc300dev);
 void cpc_tty_trigger_poll(pc300dev_t * pc300dev);
-void cpc_tty_reset_var(void);
 #endif
 
 /************************/
@@ -3421,9 +3420,6 @@ cpc_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (first_time) {
 		first_time = 0;
 		show_version();
-#ifdef CONFIG_PC300_MLPPP
-		cpc_tty_reset_var();
-#endif
 	}
 
 	if ((err = pci_enable_device(pdev)) < 0)
diff --git a/drivers/net/wan/pc300_tty.c b/drivers/net/wan/pc300_tty.c
index d47d2cd..4709f42 100644
--- a/drivers/net/wan/pc300_tty.c
+++ b/drivers/net/wan/pc300_tty.c
@@ -139,7 +139,6 @@ void cpc_tty_init(pc300dev_t *dev);
 void cpc_tty_unregister_service(pc300dev_t *pc300dev);
 void cpc_tty_receive(pc300dev_t *pc300dev);
 void cpc_tty_trigger_poll(pc300dev_t *pc300dev);
-void cpc_tty_reset_var(void);
 
 /*
  * PC300 TTY clear "signal"
@@ -1078,20 +1077,3 @@ void cpc_tty_trigger_poll(pc300dev_t *pc300dev)
 	}
 	schedule_work(&(cpc_tty->tty_tx_work)); 
 } 
-
-/*
- * PC300 TTY reset var routine
- * This routine is called by pc300driver to init the TTY area. 
- */
-
-void cpc_tty_reset_var(void)
-{
-	int i ; 
-
-	CPC_TTY_DBG("hdlcX-tty: reset variables\n");
-	/* reset  the tty_driver structure - serial_drv */ 
-	memset(&serial_drv, 0, sizeof(struct tty_driver));
-	for (i=0; i < CPC_TTY_NPORTS; i++){
-		memset(&cpc_tty_area[i],0, sizeof(st_cpc_tty_area)); 
-	}
-}
-- 
1.7.9.2



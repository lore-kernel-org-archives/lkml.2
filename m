Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199Ab1ACNyF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 08:54:05 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60593 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755251Ab1ACNuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 08:50:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=avKXyUWhcAwnyRMPCeKDu+z44o527ttxDSE5JIEi0JoCsArdNdFz50avQXY7RKWh6S
         0wrTS4D8fe2eYCfFUkY1Jz3OcNHZMjcUpCEhut8TVkg1gjaUCDazzDNmK9rO7vVEtV84
         58augzy7GfnFcjVrl/gmLQySod3fT4my7UIrA=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Stanislaw Gruszka <stf_xl@wp.pl>,
        linux-usb@vger.kernel.org
Subject: [PATCH 19/32] usb/ueagle-atm: use system_wq instead of dedicated workqueues
Date: Mon,  3 Jan 2011 14:49:42 +0100
Message-Id: <1294062595-30097-20-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1294062595-30097-1-git-send-email-tj@kernel.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With cmwq, there's no reason to use separate workqueues.  Drop
uea_softc->work_q and use system_wq instead.  The used work item is
sync flushed on driver detach.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: linux-usb@vger.kernel.org
---
Only compile tested.  Please feel free to take it into the subsystem
tree or simply ack - I'll route it through the wq tree.

Thanks.

 drivers/usb/atm/ueagle-atm.c |   19 +++++--------------
 1 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/usb/atm/ueagle-atm.c b/drivers/usb/atm/ueagle-atm.c
index 44447f5..55c1d3b 100644
--- a/drivers/usb/atm/ueagle-atm.c
+++ b/drivers/usb/atm/ueagle-atm.c
@@ -168,7 +168,6 @@ struct uea_softc {
 	union cmv_dsc cmv_dsc;
 
 	struct work_struct task;
-	struct workqueue_struct *work_q;
 	u16 pageno;
 	u16 ovl;
 
@@ -1879,7 +1878,7 @@ static int uea_start_reset(struct uea_softc *sc)
 	/* start loading DSP */
 	sc->pageno = 0;
 	sc->ovl = 0;
-	queue_work(sc->work_q, &sc->task);
+	schedule_work(&sc->task);
 
 	/* wait for modem ready CMV */
 	ret = wait_cmv_ack(sc);
@@ -2091,14 +2090,14 @@ static void uea_schedule_load_page_e1(struct uea_softc *sc,
 {
 	sc->pageno = intr->e1_bSwapPageNo;
 	sc->ovl = intr->e1_bOvl >> 4 | intr->e1_bOvl << 4;
-	queue_work(sc->work_q, &sc->task);
+	schedule_work(&sc->task);
 }
 
 static void uea_schedule_load_page_e4(struct uea_softc *sc,
 						struct intr_pkt *intr)
 {
 	sc->pageno = intr->e4_bSwapPageNo;
-	queue_work(sc->work_q, &sc->task);
+	schedule_work(&sc->task);
 }
 
 /*
@@ -2170,13 +2169,6 @@ static int uea_boot(struct uea_softc *sc)
 
 	init_waitqueue_head(&sc->sync_q);
 
-	sc->work_q = create_workqueue("ueagle-dsp");
-	if (!sc->work_q) {
-		uea_err(INS_TO_USBDEV(sc), "cannot allocate workqueue\n");
-		uea_leaves(INS_TO_USBDEV(sc));
-		return -ENOMEM;
-	}
-
 	if (UEA_CHIP_VERSION(sc) == ADI930)
 		load_XILINX_firmware(sc);
 
@@ -2222,7 +2214,6 @@ err1:
 	sc->urb_int = NULL;
 	kfree(intr);
 err0:
-	destroy_workqueue(sc->work_q);
 	uea_leaves(INS_TO_USBDEV(sc));
 	return -ENOMEM;
 }
@@ -2243,8 +2234,8 @@ static void uea_stop(struct uea_softc *sc)
 	kfree(sc->urb_int->transfer_buffer);
 	usb_free_urb(sc->urb_int);
 
-	/* stop any pending boot process, when no one can schedule work */
-	destroy_workqueue(sc->work_q);
+	/* flush the work item, when no one can schedule it */
+	flush_work_sync(&sc->task);
 
 	if (sc->dsp_firm)
 		release_firmware(sc->dsp_firm);
-- 
1.7.1


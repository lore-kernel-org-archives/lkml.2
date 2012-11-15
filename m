Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993349Ab2KOI46 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 03:56:58 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:58343 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992983Ab2KOIuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 03:50:04 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 8/9] TTY: isicom, fix tty buffers memory leak
Date: Thu, 15 Nov 2012 09:49:55 +0100
Message-Id: <1352969396-23760-9-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1352969396-23760-1-git-send-email-jslaby@suse.cz>
References: <1352969396-23760-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit "TTY: move tty buffers to tty_port", the tty buffers are
not freed in some drivers. This is because tty_port_destructor is not
called whenever a tty_port is freed. This was an assumption I counted
with but was unfortunately untrue. So fix the drivers to fulfil this
assumption.

This one is special as we need more work to be done. Previously,
the tty_port was initialized at module load time, but to be able to
destroy the port and init it again, we now do the initialization in
probe and destroy in remove. I.e. at more appropriate places for that.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/isicom.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/tty/isicom.c b/drivers/tty/isicom.c
index 5f3ecbc..67f288d 100644
--- a/drivers/tty/isicom.c
+++ b/drivers/tty/isicom.c
@@ -1610,10 +1610,15 @@ static int __devinit isicom_probe(struct pci_dev *pdev,
 	if (retval < 0)
 		goto errunri;
 
-	for (index = 0; index < board->port_count; index++)
-		tty_port_register_device(&board->ports[index].port,
-				isicom_normal, board->index * 16 + index,
-				&pdev->dev);
+	for (index = 0; index < board->port_count; index++) {
+		struct tty_port *tport = &board->ports[index].port;
+		tty_port_init(tport);
+		tport->ops = &isicom_port_ops;
+		tport->close_delay = 50 * HZ/100;
+		tport->closing_wait = 3000 * HZ/100;
+		tty_port_register_device(tport, isicom_normal,
+				board->index * 16 + index, &pdev->dev);
+	}
 
 	return 0;
 
@@ -1635,8 +1640,10 @@ static void __devexit isicom_remove(struct pci_dev *pdev)
 	struct isi_board *board = pci_get_drvdata(pdev);
 	unsigned int i;
 
-	for (i = 0; i < board->port_count; i++)
+	for (i = 0; i < board->port_count; i++) {
 		tty_unregister_device(isicom_normal, board->index * 16 + i);
+		tty_port_destroy(&board->ports[i].port);
+	}
 
 	free_irq(board->irq, board);
 	pci_release_region(pdev, 3);
@@ -1655,13 +1662,9 @@ static int __init isicom_init(void)
 		isi_card[idx].ports = port;
 		spin_lock_init(&isi_card[idx].card_lock);
 		for (channel = 0; channel < 16; channel++, port++) {
-			tty_port_init(&port->port);
-			port->port.ops = &isicom_port_ops;
 			port->magic = ISICOM_MAGIC;
 			port->card = &isi_card[idx];
 			port->channel = channel;
-			port->port.close_delay = 50 * HZ/100;
-			port->port.closing_wait = 3000 * HZ/100;
 			port->status = 0;
 			/*  . . .  */
 		}
-- 
1.8.0



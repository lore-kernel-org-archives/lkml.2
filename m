Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846Ab2K1Chp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 21:37:45 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:58671 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751640Ab2K1Chn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 21:37:43 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>,
        Jiri Slaby <jslaby@suse.cz>, Alan Cox <alan@linux.intel.com>
Subject: [PATCH -next 1/3] staging/fwserial: Destruct embedded tty_port on teardown
Date: Tue, 27 Nov 2012 21:37:11 -0500
Message-Id: <1354070233-4838-2-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1354070233-4838-1-git-send-email-peter@hurleysoftware.com>
References: <20121127170407.GC2687@kroah.com>
 <1354070233-4838-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For TTY drivers that manage the port lifetime, the tty_port should
to be specifically destructed when the port lifetime ends. Now that
a method has been added to do this, use it.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Alan Cox <alan@linux.intel.com>
---
 drivers/staging/fwserial/fwserial.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/fwserial/fwserial.c b/drivers/staging/fwserial/fwserial.c
index 5d4d64a..99a2d2d 100644
--- a/drivers/staging/fwserial/fwserial.c
+++ b/drivers/staging/fwserial/fwserial.c
@@ -955,6 +955,7 @@ static void fwserial_destroy(struct kref *kref)
 	for (j = 0; j < num_ports; ++j) {
 		fw_core_remove_address_handler(&ports[j]->rx_handler);
 		dma_fifo_free(&ports[j]->tx_fifo);
+		tty_port_destroy(&ports[j]->port);
 		kfree(ports[j]);
 	}
 	kfree(serial);
@@ -2369,8 +2370,10 @@ unregister_ttys:
 	return err;
 
 free_ports:
-	for (--i; i >= 0; --i)
+	for (--i; i >= 0; --i) {
+		tty_port_destroy(&serial->ports[i]->port);
 		kfree(serial->ports[i]);
+	}
 	kfree(serial);
 	return err;
 }
-- 
1.8.0


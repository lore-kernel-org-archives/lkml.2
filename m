Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995Ab1GaHDK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 03:03:10 -0400
Received: from lunge.queued.net ([173.255.254.236]:33889 "EHLO
	lunge.queued.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab1GaHDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 03:03:03 -0400
Date: Sun, 31 Jul 2011 00:03:00 -0700
From: Andres Salomon <dilinger@queued.net>
To: dcbw@redhat.com
Cc: David Woodhouse <dwmw2@infradead.org>, libertas-dev@lists.infradead.org,
        dsd@laptop.org, cjb@laptop.org, linux-kernel@vger.kernel.org
Subject: [PATCH] libertas: prioritize usb8388_v5.bin firmware on OLPC
 machines
Message-ID: <20110731000300.5c08e95f@debxo>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Normally, the v9 firmware will be loaded if it's available.  However, on
OLPC XO-1 machines, the v5 firmware supports extra functionality.  This
makes the libertas driver attempt to load the v5 firmware first if the
machine is an OLPC machine; if that fails (or it's not an OLPC machine),
fall back to attempting to load the other firmwares.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/net/wireless/libertas/if_usb.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index b5acc39..6a2e70e 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -973,6 +973,26 @@ static const struct {
 	{ MODEL_8682, "libertas/usb8682.bin" }
 };
 
+#ifdef CONFIG_OLPC
+
+/* default OLPC firmware to try; index into fw_table above */
+#define OLPC_FW 1
+
+static int try_olpc_fw(struct if_usb_card *cardp)
+{
+	int retval = -ENOENT;
+
+	/* try the OLPC firmware first; fall back to any others */
+	if (machine_is_olpc())
+		retval = request_firmware(&cardp->fw,
+				fw_table[OLPC_FW].fwname, &cardp->udev->dev);
+	return retval;
+}
+
+#else
+static int try_olpc_fw(struct if_usb_card *cardp) { return -ENOENT; }
+#endif /* !CONFIG_OLPC */
+
 static int get_fw(struct if_usb_card *cardp, const char *fwname)
 {
 	int i;
@@ -981,6 +1001,10 @@ static int get_fw(struct if_usb_card *cardp, const char *fwname)
 	if (fwname)
 		return request_firmware(&cardp->fw, fwname, &cardp->udev->dev);
 
+	/* Handle OLPC firmware */
+	if (try_olpc_fw(cardp) == 0)
+		return 0;
+
 	/* Otherwise search for firmware to use */
 	for (i = 0; i < ARRAY_SIZE(fw_table); i++) {
 		if (fw_table[i].model != cardp->model)
-- 
1.7.2.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703Ab1HDXG7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 19:06:59 -0400
Received: from lunge.queued.net ([173.255.254.236]:57495 "EHLO
	lunge.queued.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216Ab1HDXGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 19:06:54 -0400
Date: Thu, 4 Aug 2011 16:06:52 -0700
From: Andres Salomon <dilinger@queued.net>
To: dcbw@redhat.com
Cc: David Woodhouse <dwmw2@infradead.org>, libertas-dev@lists.infradead.org,
        dsd@laptop.org, cjb@laptop.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] libertas: prioritize usb8388_olpc.bin firmware on OLPC
 machines
Message-ID: <20110804160652.2c87efef@debxo>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Normally, the v9 firmware will be loaded if it's available.  However, on
OLPC XO-1 machines, the olpc-specific firmware supports extra functionality.
This makes the libertas driver attempt to load the custom firmware first
if the machine is an OLPC machine; if that fails (or it's not an OLPC
machine), fall back to attempting to load the other firmwares.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/net/wireless/libertas/if_usb.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index b5acc39..527cb11 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -973,6 +973,23 @@ static const struct {
 	{ MODEL_8682, "libertas/usb8682.bin" }
 };
 
+#ifdef CONFIG_OLPC
+
+static int try_olpc_fw(struct if_usb_card *cardp)
+{
+	int retval = -ENOENT;
+
+	/* try the OLPC firmware first; fall back to fw_table list */
+	if (machine_is_olpc() && cardp->model == MODEL_8388)
+		retval = request_firmware(&cardp->fw, "usb8388_olpc.bin",
+				&cardp->udev->dev);
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
@@ -981,6 +998,10 @@ static int get_fw(struct if_usb_card *cardp, const char *fwname)
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


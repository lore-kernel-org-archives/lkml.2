Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab1ECUCw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 16:02:52 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:4682 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805Ab1ECUCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 16:02:51 -0400
Subject: [PATCH 14/16] cciss: do not attempt PCI power management reset method
	if we know it won't work.
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: mikem@beardog.cce.hp.com, akpm@linux-foundation.org, thenzl@redhat.com,
        linux-kernel@vger.kernel.org, smcameron@yahoo.com
Date: Tue, 03 May 2011 14:54:02 -0500
Message-ID: <20110503195402.5154.40908.stgit@beardog.cce.hp.com>
In-Reply-To: <20110503194919.5154.78352.stgit@beardog.cce.hp.com>
References: <20110503194919.5154.78352.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Just go straight to the soft-reset method instead.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |   36 +++++++++++++++++++++++++++++++-----
 1 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 7990b98..865484e 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -558,7 +558,7 @@ static void __devinit cciss_procinit(ctlr_info_t *h)
 #define to_hba(n) container_of(n, struct ctlr_info, dev)
 #define to_drv(n) container_of(n, drive_info_struct, dev)
 
-/* List of controllers which cannot be reset on kexec with reset_devices */
+/* List of controllers which cannot be hard reset on kexec with reset_devices */
 static u32 unresettable_controller[] = {
 	0x324a103C, /* Smart Array P712m */
 	0x324b103C, /* SmartArray P711m */
@@ -576,23 +576,45 @@ static u32 unresettable_controller[] = {
 	0x409D0E11, /* Smart Array 6400 EM */
 };
 
-static int ctlr_is_resettable(struct ctlr_info *h)
+/* List of controllers which cannot even be soft reset */
+static u32 soft_unresettable_controller[] = {
+	0x409C0E11, /* Smart Array 6400 */
+	0x409D0E11, /* Smart Array 6400 EM */
+};
+
+static int ctlr_is_hard_resettable(u32 board_id)
 {
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(unresettable_controller); i++)
-		if (unresettable_controller[i] == h->board_id)
+		if (unresettable_controller[i] == board_id)
 			return 0;
 	return 1;
 }
 
+static int ctlr_is_soft_resettable(u32 board_id)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(soft_unresettable_controller); i++)
+		if (soft_unresettable_controller[i] == board_id)
+			return 0;
+	return 1;
+}
+
+static int ctlr_is_resettable(u32 board_id)
+{
+	return ctlr_is_hard_resettable(board_id) ||
+		ctlr_is_soft_resettable(board_id);
+}
+
 static ssize_t host_show_resettable(struct device *dev,
 				    struct device_attribute *attr,
 				    char *buf)
 {
 	struct ctlr_info *h = to_hba(dev);
 
-	return snprintf(buf, 20, "%d\n", ctlr_is_resettable(h));
+	return snprintf(buf, 20, "%d\n", ctlr_is_resettable(h->board_id));
 }
 static DEVICE_ATTR(resettable, S_IRUGO, host_show_resettable, NULL);
 
@@ -4601,12 +4623,16 @@ static __devinit int cciss_kdump_hard_reset_controller(struct pci_dev *pdev)
 	 * likely not be happy.  Just forbid resetting this conjoined mess.
 	 */
 	cciss_lookup_board_id(pdev, &board_id);
-	if (board_id == 0x409C0E11 || board_id == 0x409D0E11) {
+	if (!ctlr_is_resettable(board_id)) {
 		dev_warn(&pdev->dev, "Cannot reset Smart Array 640x "
 				"due to shared cache module.");
 		return -ENODEV;
 	}
 
+	/* if controller is soft- but not hard resettable... */
+	if (!ctlr_is_hard_resettable(board_id))
+		return -ENOTSUPP; /* try soft reset later. */
+
 	/* Save the PCI command register */
 	pci_read_config_word(pdev, 4, &command_register);
 	/* Turn the board off.  This is so that later pci_restore_state()


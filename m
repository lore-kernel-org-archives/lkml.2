Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914Ab1I1Wmp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:42:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54103 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755868Ab1I1Wmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:42:40 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:36 2011
Message-Id: <20110928220136.394274517@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:01:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [105/244] [SCSI] hpsa: fix problem that OBDR devices are not detected
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>

commit 0b0e1d6cbcc8627970e0399df8f06edd690ec7d9 upstream.

The test to detect OBDR ("One Button Disaster Recovery")
cd-rom devices was comparing against uninitialized data.

Fixed by moving the test for the device to where the
inquiry data is collected, and uninitialized variable
altogether as it wasn't really being used.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/hpsa.c |   47 +++++++++++++++++++++++++++--------------------
 1 file changed, 27 insertions(+), 20 deletions(-)

--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1548,10 +1548,17 @@ static inline void hpsa_set_bus_target_l
 }
 
 static int hpsa_update_device_info(struct ctlr_info *h,
-	unsigned char scsi3addr[], struct hpsa_scsi_dev_t *this_device)
+	unsigned char scsi3addr[], struct hpsa_scsi_dev_t *this_device,
+	unsigned char *is_OBDR_device)
 {
-#define OBDR_TAPE_INQ_SIZE 49
+
+#define OBDR_SIG_OFFSET 43
+#define OBDR_TAPE_SIG "$DR-10"
+#define OBDR_SIG_LEN (sizeof(OBDR_TAPE_SIG) - 1)
+#define OBDR_TAPE_INQ_SIZE (OBDR_SIG_OFFSET + OBDR_SIG_LEN)
+
 	unsigned char *inq_buff;
+	unsigned char *obdr_sig;
 
 	inq_buff = kzalloc(OBDR_TAPE_INQ_SIZE, GFP_KERNEL);
 	if (!inq_buff)
@@ -1583,6 +1590,16 @@ static int hpsa_update_device_info(struc
 	else
 		this_device->raid_level = RAID_UNKNOWN;
 
+	if (is_OBDR_device) {
+		/* See if this is a One-Button-Disaster-Recovery device
+		 * by looking for "$DR-10" at offset 43 in inquiry data.
+		 */
+		obdr_sig = &inq_buff[OBDR_SIG_OFFSET];
+		*is_OBDR_device = (this_device->devtype == TYPE_ROM &&
+					strncmp(obdr_sig, OBDR_TAPE_SIG,
+						OBDR_SIG_LEN) == 0);
+	}
+
 	kfree(inq_buff);
 	return 0;
 
@@ -1716,7 +1733,7 @@ static int add_msa2xxx_enclosure_device(
 		return 0;
 	}
 
-	if (hpsa_update_device_info(h, scsi3addr, this_device))
+	if (hpsa_update_device_info(h, scsi3addr, this_device, NULL))
 		return 0;
 	(*nmsa2xxx_enclosures)++;
 	hpsa_set_bus_target_lun(this_device, bus, target, 0);
@@ -1808,7 +1825,6 @@ static void hpsa_update_scsi_devices(str
 	 */
 	struct ReportLUNdata *physdev_list = NULL;
 	struct ReportLUNdata *logdev_list = NULL;
-	unsigned char *inq_buff = NULL;
 	u32 nphysicals = 0;
 	u32 nlogicals = 0;
 	u32 ndev_allocated = 0;
@@ -1824,11 +1840,9 @@ static void hpsa_update_scsi_devices(str
 		GFP_KERNEL);
 	physdev_list = kzalloc(reportlunsize, GFP_KERNEL);
 	logdev_list = kzalloc(reportlunsize, GFP_KERNEL);
-	inq_buff = kmalloc(OBDR_TAPE_INQ_SIZE, GFP_KERNEL);
 	tmpdevice = kzalloc(sizeof(*tmpdevice), GFP_KERNEL);
 
-	if (!currentsd || !physdev_list || !logdev_list ||
-		!inq_buff || !tmpdevice) {
+	if (!currentsd || !physdev_list || !logdev_list || !tmpdevice) {
 		dev_err(&h->pdev->dev, "out of memory\n");
 		goto out;
 	}
@@ -1863,7 +1877,7 @@ static void hpsa_update_scsi_devices(str
 	/* adjust our table of devices */
 	nmsa2xxx_enclosures = 0;
 	for (i = 0; i < nphysicals + nlogicals + 1; i++) {
-		u8 *lunaddrbytes;
+		u8 *lunaddrbytes, is_OBDR = 0;
 
 		/* Figure out where the LUN ID info is coming from */
 		lunaddrbytes = figure_lunaddrbytes(h, raid_ctlr_position,
@@ -1874,7 +1888,8 @@ static void hpsa_update_scsi_devices(str
 			continue;
 
 		/* Get device type, vendor, model, device id */
-		if (hpsa_update_device_info(h, lunaddrbytes, tmpdevice))
+		if (hpsa_update_device_info(h, lunaddrbytes, tmpdevice,
+							&is_OBDR))
 			continue; /* skip it if we can't talk to it. */
 		figure_bus_target_lun(h, lunaddrbytes, &bus, &target, &lun,
 			tmpdevice);
@@ -1898,7 +1913,7 @@ static void hpsa_update_scsi_devices(str
 		hpsa_set_bus_target_lun(this_device, bus, target, lun);
 
 		switch (this_device->devtype) {
-		case TYPE_ROM: {
+		case TYPE_ROM:
 			/* We don't *really* support actual CD-ROM devices,
 			 * just "One Button Disaster Recovery" tape drive
 			 * which temporarily pretends to be a CD-ROM drive.
@@ -1906,15 +1921,8 @@ static void hpsa_update_scsi_devices(str
 			 * device by checking for "$DR-10" in bytes 43-48 of
 			 * the inquiry data.
 			 */
-				char obdr_sig[7];
-#define OBDR_TAPE_SIG "$DR-10"
-				strncpy(obdr_sig, &inq_buff[43], 6);
-				obdr_sig[6] = '\0';
-				if (strncmp(obdr_sig, OBDR_TAPE_SIG, 6) != 0)
-					/* Not OBDR device, ignore it. */
-					break;
-			}
-			ncurrent++;
+			if (is_OBDR)
+				ncurrent++;
 			break;
 		case TYPE_DISK:
 			if (i < nphysicals)
@@ -1947,7 +1955,6 @@ out:
 	for (i = 0; i < ndev_allocated; i++)
 		kfree(currentsd[i]);
 	kfree(currentsd);
-	kfree(inq_buff);
 	kfree(physdev_list);
 	kfree(logdev_list);
 }



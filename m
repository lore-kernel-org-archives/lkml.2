Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028Ab2FJNkd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 09:40:33 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:37553 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934Ab2FJNkc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 09:40:32 -0400
From: "Camuso, Tony" <Tony.Camuso@hp.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Abrams, Melissa" <melissa.abrams@hp.com>,
        "Rusk, Mark" <mark.rusk@hp.com>
Date: Sun, 10 Jun 2012 14:39:20 +0100
Subject: Re: misc: hpilo patch for increasing max channels
Thread-Topic: Re: misc: hpilo patch for increasing max channels
Thread-Index: Ac1HDnCp8tK2RRQbRPuGoEWpjoR+Zw==
Message-ID: <B9407FD6893A644D9D6B72C30268E7A94AF2791602@GVW0538EXC.americas.hpqcorp.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In-reply-to: http://marc.info/?i=20120216000741.GA21792%20()%20kroah%20!%20com

Hi, Greg.

Here is the corrected patch. Applies to 3.5.0-rc2 without complaint.

---

Increase number of supported channels from 8 to 24.
Make the number of channels configurable via module parameter max_ccb.

Signed-off-by: Mark Rusk <mark.rusk@hp.com>
Signed-off-by: Tony Camuso <tony.camuso@hp.com>
---
 drivers/misc/hpilo.c |   33 +++++++++++++++++++++------------
 drivers/misc/hpilo.h |    4 +++-
 2 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/drivers/misc/hpilo.c b/drivers/misc/hpilo.c
index fffc227..6df0da4 100644
--- a/drivers/misc/hpilo.c
+++ b/drivers/misc/hpilo.c
@@ -30,6 +30,7 @@
 
 static struct class *ilo_class;
 static unsigned int ilo_major;
+static unsigned int max_ccb = MIN_CCB;
 static char ilo_hwdev[MAX_ILO_DEV];
 
 static inline int get_entry_id(int entry)
@@ -424,7 +425,7 @@ static void ilo_set_reset(struct ilo_hwinfo *hw)
 	 * Mapped memory is zeroed on ilo reset, so set a per ccb flag
 	 * to indicate that this ccb needs to be closed and reopened.
 	 */
-	for (slot = 0; slot < MAX_CCB; slot++) {
+	for (slot = 0; slot < max_ccb; slot++) {
 		if (!hw->ccb_alloc[slot])
 			continue;
 		set_channel_reset(&hw->ccb_alloc[slot]->driver_ccb);
@@ -535,7 +536,7 @@ static int ilo_close(struct inode *ip, struct file *fp)
 	struct ilo_hwinfo *hw;
 	unsigned long flags;
 
-	slot = iminor(ip) % MAX_CCB;
+	slot = iminor(ip) % max_ccb;
 	hw = container_of(ip->i_cdev, struct ilo_hwinfo, cdev);
 
 	spin_lock(&hw->open_lock);
@@ -566,7 +567,7 @@ static int ilo_open(struct inode *ip, struct file *fp)
 	struct ilo_hwinfo *hw;
 	unsigned long flags;
 
-	slot = iminor(ip) % MAX_CCB;
+	slot = iminor(ip) % max_ccb;
 	hw = container_of(ip->i_cdev, struct ilo_hwinfo, cdev);
 
 	/* new ccb allocation */
@@ -663,7 +664,7 @@ static irqreturn_t ilo_isr(int irq, void *data)
 		ilo_set_reset(hw);
 	}
 
-	for (i = 0; i < MAX_CCB; i++) {
+	for (i = 0; i < max_ccb; i++) {
 		if (!hw->ccb_alloc[i])
 			continue;
 		if (pending & (1 << i))
@@ -697,14 +698,14 @@ static int __devinit ilo_map_device(struct pci_dev *pdev, struct ilo_hwinfo *hw)
 	}
 
 	/* map the adapter shared memory region */
-	hw->ram_vaddr = pci_iomap(pdev, 2, MAX_CCB * ILOHW_CCB_SZ);
+	hw->ram_vaddr = pci_iomap(pdev, 2, max_ccb * ILOHW_CCB_SZ);
 	if (hw->ram_vaddr == NULL) {
 		dev_err(&pdev->dev, "Error mapping shared mem\n");
 		goto mmio_free;
 	}
 
 	/* map the doorbell aperture */
-	hw->db_vaddr = pci_iomap(pdev, 3, MAX_CCB * ONE_DB_SIZE);
+	hw->db_vaddr = pci_iomap(pdev, 3, max_ccb * ONE_DB_SIZE);
 	if (hw->db_vaddr == NULL) {
 		dev_err(&pdev->dev, "Error mapping doorbell\n");
 		goto ram_free;
@@ -727,7 +728,7 @@ static void ilo_remove(struct pci_dev *pdev)
 	clear_device(ilo_hw);
 
 	minor = MINOR(ilo_hw->cdev.dev);
-	for (i = minor; i < minor + MAX_CCB; i++)
+	for (i = minor; i < minor + max_ccb; i++)
 		device_destroy(ilo_class, MKDEV(ilo_major, i));
 
 	cdev_del(&ilo_hw->cdev);
@@ -737,7 +738,7 @@ static void ilo_remove(struct pci_dev *pdev)
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
 	kfree(ilo_hw);
-	ilo_hwdev[(minor / MAX_CCB)] = 0;
+	ilo_hwdev[(minor / max_ccb)] = 0;
 }
 
 static int __devinit ilo_probe(struct pci_dev *pdev,
@@ -746,6 +747,11 @@ static int __devinit ilo_probe(struct pci_dev *pdev,
 	int devnum, minor, start, error;
 	struct ilo_hwinfo *ilo_hw;
 
+	if (max_ccb > MAX_CCB)
+		max_ccb = MAX_CCB;
+	else if (max_ccb < MIN_CCB)
+		max_ccb = MIN_CCB;
+
 	/* find a free range for device files */
 	for (devnum = 0; devnum < MAX_ILO_DEV; devnum++) {
 		if (ilo_hwdev[devnum] == 0) {
@@ -795,14 +801,14 @@ static int __devinit ilo_probe(struct pci_dev *pdev,
 
 	cdev_init(&ilo_hw->cdev, &ilo_fops);
 	ilo_hw->cdev.owner = THIS_MODULE;
-	start = devnum * MAX_CCB;
-	error = cdev_add(&ilo_hw->cdev, MKDEV(ilo_major, start), MAX_CCB);
+	start = devnum * max_ccb;
+	error = cdev_add(&ilo_hw->cdev, MKDEV(ilo_major, start), max_ccb);
 	if (error) {
 		dev_err(&pdev->dev, "Could not add cdev\n");
 		goto remove_isr;
 	}
 
-	for (minor = 0 ; minor < MAX_CCB; minor++) {
+	for (minor = 0 ; minor < max_ccb; minor++) {
 		struct device *dev;
 		dev = device_create(ilo_class, &pdev->dev,
 				    MKDEV(ilo_major, minor), NULL,
@@ -879,11 +885,14 @@ static void __exit ilo_exit(void)
 	class_destroy(ilo_class);
 }
 
-MODULE_VERSION("1.2");
+MODULE_VERSION("1.3");
 MODULE_ALIAS(ILO_NAME);
 MODULE_DESCRIPTION(ILO_NAME);
 MODULE_AUTHOR("David Altobelli <david.altobelli@hp.com>");
 MODULE_LICENSE("GPL v2");
 
+module_param(max_ccb, uint, 0444);
+MODULE_PARM_DESC(max_ccb, "Maximum number of HP iLO channels to attach (8)");
+
 module_init(ilo_init);
 module_exit(ilo_exit);
diff --git a/drivers/misc/hpilo.h b/drivers/misc/hpilo.h
index 54e43ad..b97672e 100644
--- a/drivers/misc/hpilo.h
+++ b/drivers/misc/hpilo.h
@@ -14,7 +14,9 @@
 #define ILO_NAME "hpilo"
 
 /* max number of open channel control blocks per device, hw limited to 32 */
-#define MAX_CCB		8
+#define MAX_CCB	       24
+/* min number of open channel control blocks per device, hw limited to 32 */
+#define MIN_CCB		8
 /* max number of supported devices */
 #define MAX_ILO_DEV	1
 /* max number of files */
-- 
1.7.10.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab0DFPWz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 11:22:55 -0400
Received: from havoc.gtf.org ([69.61.125.42]:39967 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665Ab0DFPWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 11:22:49 -0400
Date: Tue, 6 Apr 2010 11:22:48 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20100406152248.GA369@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



The Host Protected Area (HPA) fix is rather large, but nothing to be
done about that except fix it, unfortunately.  The other two fixes are
one/two-liners.



Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/libata-core.c |   77 ++++++++++++++++++++++++++++-----------------
 drivers/ata/libata-sff.c  |    4 --
 include/linux/libata.h    |    1 +
 3 files changed, 49 insertions(+), 33 deletions(-)

Tejun Heo (3):
      libata: don't whine on spurious IRQ
      libata: disable NCQ on Crucial C300 SSD
      libata: unlock HPA if device shrunk

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 3f6771e..49cffb6 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1494,6 +1494,7 @@ static int ata_hpa_resize(struct ata_device *dev)
 {
 	struct ata_eh_context *ehc = &dev->link->eh_context;
 	int print_info = ehc->i.flags & ATA_EHI_PRINTINFO;
+	bool unlock_hpa = ata_ignore_hpa || dev->flags & ATA_DFLAG_UNLOCK_HPA;
 	u64 sectors = ata_id_n_sectors(dev->id);
 	u64 native_sectors;
 	int rc;
@@ -1510,7 +1511,7 @@ static int ata_hpa_resize(struct ata_device *dev)
 		/* If device aborted the command or HPA isn't going to
 		 * be unlocked, skip HPA resizing.
 		 */
-		if (rc == -EACCES || !ata_ignore_hpa) {
+		if (rc == -EACCES || !unlock_hpa) {
 			ata_dev_printk(dev, KERN_WARNING, "HPA support seems "
 				       "broken, skipping HPA handling\n");
 			dev->horkage |= ATA_HORKAGE_BROKEN_HPA;
@@ -1525,7 +1526,7 @@ static int ata_hpa_resize(struct ata_device *dev)
 	dev->n_native_sectors = native_sectors;
 
 	/* nothing to do? */
-	if (native_sectors <= sectors || !ata_ignore_hpa) {
+	if (native_sectors <= sectors || !unlock_hpa) {
 		if (!print_info || native_sectors == sectors)
 			return 0;
 
@@ -4186,36 +4187,51 @@ int ata_dev_revalidate(struct ata_device *dev, unsigned int new_class,
 		goto fail;
 
 	/* verify n_sectors hasn't changed */
-	if (dev->class == ATA_DEV_ATA && n_sectors &&
-	    dev->n_sectors != n_sectors) {
-		ata_dev_printk(dev, KERN_WARNING, "n_sectors mismatch "
-			       "%llu != %llu\n",
-			       (unsigned long long)n_sectors,
-			       (unsigned long long)dev->n_sectors);
-		/*
-		 * Something could have caused HPA to be unlocked
-		 * involuntarily.  If n_native_sectors hasn't changed
-		 * and the new size matches it, keep the device.
-		 */
-		if (dev->n_native_sectors == n_native_sectors &&
-		    dev->n_sectors > n_sectors &&
-		    dev->n_sectors == n_native_sectors) {
-			ata_dev_printk(dev, KERN_WARNING,
-				       "new n_sectors matches native, probably "
-				       "late HPA unlock, continuing\n");
-			/* keep using the old n_sectors */
-			dev->n_sectors = n_sectors;
-		} else {
-			/* restore original n_[native]_sectors and fail */
-			dev->n_native_sectors = n_native_sectors;
-			dev->n_sectors = n_sectors;
-			rc = -ENODEV;
-			goto fail;
-		}
+	if (dev->class != ATA_DEV_ATA || !n_sectors ||
+	    dev->n_sectors == n_sectors)
+		return 0;
+
+	/* n_sectors has changed */
+	ata_dev_printk(dev, KERN_WARNING, "n_sectors mismatch %llu != %llu\n",
+		       (unsigned long long)n_sectors,
+		       (unsigned long long)dev->n_sectors);
+
+	/*
+	 * Something could have caused HPA to be unlocked
+	 * involuntarily.  If n_native_sectors hasn't changed and the
+	 * new size matches it, keep the device.
+	 */
+	if (dev->n_native_sectors == n_native_sectors &&
+	    dev->n_sectors > n_sectors && dev->n_sectors == n_native_sectors) {
+		ata_dev_printk(dev, KERN_WARNING,
+			       "new n_sectors matches native, probably "
+			       "late HPA unlock, continuing\n");
+		/* keep using the old n_sectors */
+		dev->n_sectors = n_sectors;
+		return 0;
 	}
 
-	return 0;
+	/*
+	 * Some BIOSes boot w/o HPA but resume w/ HPA locked.  Try
+	 * unlocking HPA in those cases.
+	 *
+	 * https://bugzilla.kernel.org/show_bug.cgi?id=15396
+	 */
+	if (dev->n_native_sectors == n_native_sectors &&
+	    dev->n_sectors < n_sectors && n_sectors == n_native_sectors &&
+	    !(dev->horkage & ATA_HORKAGE_BROKEN_HPA)) {
+		ata_dev_printk(dev, KERN_WARNING,
+			       "old n_sectors matches native, probably "
+			       "late HPA lock, will try to unlock HPA\n");
+		/* try unlocking HPA */
+		dev->flags |= ATA_DFLAG_UNLOCK_HPA;
+		rc = -EIO;
+	} else
+		rc = -ENODEV;
 
+	/* restore original n_[native_]sectors and fail */
+	dev->n_native_sectors = n_native_sectors;
+	dev->n_sectors = n_sectors;
  fail:
 	ata_dev_printk(dev, KERN_ERR, "revalidation failed (errno=%d)\n", rc);
 	return rc;
@@ -4354,6 +4370,9 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	{ "HTS541080G9SA00",    "MB4OC60D",     ATA_HORKAGE_NONCQ, },
 	{ "HTS541010G9SA00",    "MBZOC60D",     ATA_HORKAGE_NONCQ, },
 
+	/* https://bugzilla.kernel.org/show_bug.cgi?id=15573 */
+	{ "C300-CTFDDAC128MAG",	"0001",		ATA_HORKAGE_NONCQ, },
+
 	/* devices which puke on READ_NATIVE_MAX */
 	{ "HDS724040KLSA80",	"KFAOA20N",	ATA_HORKAGE_BROKEN_HPA, },
 	{ "WDC WD3200JD-00KLB0", "WD-WCAMR1130137", ATA_HORKAGE_BROKEN_HPA },
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 6411e0c..e3877b6 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -1816,10 +1816,6 @@ retry:
 			    !ap->ops->sff_irq_check(ap))
 				continue;
 
-			if (printk_ratelimit())
-				ata_port_printk(ap, KERN_INFO,
-						"clearing spurious IRQ\n");
-
 			if (idle & (1 << i)) {
 				ap->ops->sff_check_status(ap);
 				ap->ops->sff_irq_clear(ap);
diff --git a/include/linux/libata.h b/include/linux/libata.h
index f8ea71e..b2f2003 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -146,6 +146,7 @@ enum {
 	ATA_DFLAG_SLEEPING	= (1 << 15), /* device is sleeping */
 	ATA_DFLAG_DUBIOUS_XFER	= (1 << 16), /* data transfer not verified */
 	ATA_DFLAG_NO_UNLOAD	= (1 << 17), /* device doesn't support unload */
+	ATA_DFLAG_UNLOCK_HPA	= (1 << 18), /* unlock HPA */
 	ATA_DFLAG_INIT_MASK	= (1 << 24) - 1,
 
 	ATA_DFLAG_DETACH	= (1 << 24),

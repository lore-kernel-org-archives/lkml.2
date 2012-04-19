Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933481Ab2DSVNd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:13:33 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33843 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933432Ab2DSVN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:13:28 -0400
Message-Id: <20120419210614.270060356@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:06:48 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        Masayuki Ohtak <masa-korg@dsn.okisemi.com>,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        Denis Turischev <denis@compulab.co.il>
Subject: [ 37/59] pch_phub: Improve ADE(Address Decode Enable) control
In-Reply-To: <20120419210623.GA12156@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomoya MORINAGA <tomoya.rohm@gmail.com>

commit 9914a0de7a27ef2cb5d9aacfe50ae97ebb532f28 upstream.

Currently, external ROM access is enabled/disabled in probe()/remove().
So, when a buggy software access unanticipated memory area,
in case of enabling this ADE bit,
external ROM memory area can be broken.

This patch enables the ADE bit only accessing external ROM area.

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Masayuki Ohtak <masa-korg@dsn.okisemi.com>
Cc: Alexander Stein <alexander.stein@systec-electronic.com>
Cc: Denis Turischev <denis@compulab.co.il>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/misc/pch_phub.c |   51 ++++++++++++++++++++++++++++++++----------------
 1 file changed, 34 insertions(+), 17 deletions(-)

--- a/drivers/misc/pch_phub.c
+++ b/drivers/misc/pch_phub.c
@@ -118,6 +118,7 @@
  * @pch_mac_start_address:		MAC address area start address
  * @pch_opt_rom_start_address:		Option ROM start address
  * @ioh_type:				Save IOH type
+ * @pdev:				pointer to pci device struct
  */
 struct pch_phub_reg {
 	u32 phub_id_reg;
@@ -139,6 +140,7 @@ struct pch_phub_reg {
 	u32 pch_mac_start_address;
 	u32 pch_opt_rom_start_address;
 	int ioh_type;
+	struct pci_dev *pdev;
 };
 
 /* SROM SPEC for MAC address assignment offset */
@@ -501,6 +503,7 @@ static ssize_t pch_phub_bin_read(struct
 	unsigned int orom_size;
 	int ret;
 	int err;
+	ssize_t rom_size;
 
 	struct pch_phub_reg *chip =
 		dev_get_drvdata(container_of(kobj, struct device, kobj));
@@ -512,6 +515,10 @@ static ssize_t pch_phub_bin_read(struct
 	}
 
 	/* Get Rom signature */
+	chip->pch_phub_extrom_base_address = pci_map_rom(chip->pdev, &rom_size);
+	if (!chip->pch_phub_extrom_base_address)
+		goto exrom_map_err;
+
 	pch_phub_read_serial_rom(chip, chip->pch_opt_rom_start_address,
 				(unsigned char *)&rom_signature);
 	rom_signature &= 0xff;
@@ -542,10 +549,13 @@ static ssize_t pch_phub_bin_read(struct
 		goto return_err;
 	}
 return_ok:
+	pci_unmap_rom(chip->pdev, chip->pch_phub_extrom_base_address);
 	mutex_unlock(&pch_phub_mutex);
 	return addr_offset;
 
 return_err:
+	pci_unmap_rom(chip->pdev, chip->pch_phub_extrom_base_address);
+exrom_map_err:
 	mutex_unlock(&pch_phub_mutex);
 return_err_nomutex:
 	return err;
@@ -558,6 +568,7 @@ static ssize_t pch_phub_bin_write(struct
 	int err;
 	unsigned int addr_offset;
 	int ret;
+	ssize_t rom_size;
 	struct pch_phub_reg *chip =
 		dev_get_drvdata(container_of(kobj, struct device, kobj));
 
@@ -574,6 +585,12 @@ static ssize_t pch_phub_bin_write(struct
 		goto return_ok;
 	}
 
+	chip->pch_phub_extrom_base_address = pci_map_rom(chip->pdev, &rom_size);
+	if (!chip->pch_phub_extrom_base_address) {
+		err = -ENOMEM;
+		goto exrom_map_err;
+	}
+
 	for (addr_offset = 0; addr_offset < count; addr_offset++) {
 		if (PCH_PHUB_OROM_SIZE < off + addr_offset)
 			goto return_ok;
@@ -588,10 +605,14 @@ static ssize_t pch_phub_bin_write(struct
 	}
 
 return_ok:
+	pci_unmap_rom(chip->pdev, chip->pch_phub_extrom_base_address);
 	mutex_unlock(&pch_phub_mutex);
 	return addr_offset;
 
 return_err:
+	pci_unmap_rom(chip->pdev, chip->pch_phub_extrom_base_address);
+
+exrom_map_err:
 	mutex_unlock(&pch_phub_mutex);
 	return err;
 }
@@ -601,8 +622,14 @@ static ssize_t show_pch_mac(struct devic
 {
 	u8 mac[8];
 	struct pch_phub_reg *chip = dev_get_drvdata(dev);
+	ssize_t rom_size;
+
+	chip->pch_phub_extrom_base_address = pci_map_rom(chip->pdev, &rom_size);
+	if (!chip->pch_phub_extrom_base_address)
+		return -ENOMEM;
 
 	pch_phub_read_gbe_mac_addr(chip, mac);
+	pci_unmap_rom(chip->pdev, chip->pch_phub_extrom_base_address);
 
 	return sprintf(buf, "%02x:%02x:%02x:%02x:%02x:%02x\n",
 				mac[0], mac[1], mac[2], mac[3], mac[4], mac[5]);
@@ -612,6 +639,7 @@ static ssize_t store_pch_mac(struct devi
 			     const char *buf, size_t count)
 {
 	u8 mac[6];
+	ssize_t rom_size;
 	struct pch_phub_reg *chip = dev_get_drvdata(dev);
 
 	if (count != 18)
@@ -621,7 +649,12 @@ static ssize_t store_pch_mac(struct devi
 		(u32 *)&mac[0], (u32 *)&mac[1], (u32 *)&mac[2], (u32 *)&mac[3],
 		(u32 *)&mac[4], (u32 *)&mac[5]);
 
+	chip->pch_phub_extrom_base_address = pci_map_rom(chip->pdev, &rom_size);
+	if (!chip->pch_phub_extrom_base_address)
+		return -ENOMEM;
+
 	pch_phub_write_gbe_mac_addr(chip, mac);
+	pci_unmap_rom(chip->pdev, chip->pch_phub_extrom_base_address);
 
 	return count;
 }
@@ -644,7 +677,6 @@ static int __devinit pch_phub_probe(stru
 	int retval;
 
 	int ret;
-	ssize_t rom_size;
 	struct pch_phub_reg *chip;
 
 	chip = kzalloc(sizeof(struct pch_phub_reg), GFP_KERNEL);
@@ -681,19 +713,7 @@ static int __devinit pch_phub_probe(stru
 		"in pch_phub_base_address variable is %p\n", __func__,
 		chip->pch_phub_base_address);
 
-	if (id->driver_data != 3) {
-		chip->pch_phub_extrom_base_address =\
-						   pci_map_rom(pdev, &rom_size);
-		if (chip->pch_phub_extrom_base_address == 0) {
-			dev_err(&pdev->dev, "%s: pci_map_rom FAILED", __func__);
-			ret = -ENOMEM;
-			goto err_pci_map;
-		}
-		dev_dbg(&pdev->dev, "%s : "
-			"pci_map_rom SUCCESS and value in "
-			"pch_phub_extrom_base_address variable is %p\n",
-			__func__, chip->pch_phub_extrom_base_address);
-	}
+	chip->pdev = pdev; /* Save pci device struct */
 
 	if (id->driver_data == 1) { /* EG20T PCH */
 		retval = sysfs_create_file(&pdev->dev.kobj,
@@ -790,8 +810,6 @@ exit_bin_attr:
 	sysfs_remove_file(&pdev->dev.kobj, &dev_attr_pch_mac.attr);
 
 err_sysfs_create:
-	pci_unmap_rom(pdev, chip->pch_phub_extrom_base_address);
-err_pci_map:
 	pci_iounmap(pdev, chip->pch_phub_base_address);
 err_pci_iomap:
 	pci_release_regions(pdev);
@@ -809,7 +827,6 @@ static void __devexit pch_phub_remove(st
 
 	sysfs_remove_file(&pdev->dev.kobj, &dev_attr_pch_mac.attr);
 	sysfs_remove_bin_file(&pdev->dev.kobj, &pch_bin_attr);
-	pci_unmap_rom(pdev, chip->pch_phub_extrom_base_address);
 	pci_iounmap(pdev, chip->pch_phub_base_address);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);



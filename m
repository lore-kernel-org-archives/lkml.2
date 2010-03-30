Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889Ab0CaAmY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:42:24 -0400
Received: from kroah.org ([198.145.64.141]:48395 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755484Ab0C3XIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:08:53 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:49:44 2010
Message-Id: <20100330224944.190349953@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:48:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jean Delvare <khali@linux-fr.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [08/45] hwmon: (lm78) Fix I/O resource conflict with PNP
In-Reply-To: <20100330230410.GA28712@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jean Delvare <khali@linux-fr.org>

This fix is the combination of the following two upstream patches:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=197027e6ef830d60e10f76efc8d12bf3b6c35db5
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=47c15532ddcd6818f51cb15f914d63864b3ee9ab

Only request I/O ports 0x295-0x296 instead of the full I/O address
range. This solves a conflict with PNP resources on a few motherboards.

Also request the I/O ports individually during device detection,
otherwise the PNP resource may cause the request (and thus the
detection) fail.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/lm78.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

--- a/drivers/hwmon/lm78.c
+++ b/drivers/hwmon/lm78.c
@@ -655,7 +655,7 @@ static int __devinit lm78_isa_probe(stru
 
 	/* Reserve the ISA region */
 	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
-	if (!request_region(res->start, LM78_EXTENT, "lm78")) {
+	if (!request_region(res->start + LM78_ADDR_REG_OFFSET, 2, "lm78")) {
 		err = -EBUSY;
 		goto exit;
 	}
@@ -699,7 +699,7 @@ static int __devinit lm78_isa_probe(stru
 	device_remove_file(&pdev->dev, &dev_attr_name);
 	kfree(data);
  exit_release_region:
-	release_region(res->start, LM78_EXTENT);
+	release_region(res->start + LM78_ADDR_REG_OFFSET, 2);
  exit:
 	return err;
 }
@@ -711,7 +711,7 @@ static int __devexit lm78_isa_remove(str
 	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&pdev->dev.kobj, &lm78_group);
 	device_remove_file(&pdev->dev, &dev_attr_name);
-	release_region(data->client.addr, LM78_EXTENT);
+	release_region(data->client.addr + LM78_ADDR_REG_OFFSET, 2);
 	kfree(data);
 
 	return 0;
@@ -836,9 +836,17 @@ static struct lm78_data *lm78_update_dev
 static int __init lm78_isa_found(unsigned short address)
 {
 	int val, save, found = 0;
+	int port;
 
-	if (!request_region(address, LM78_EXTENT, "lm78"))
-		return 0;
+	/* Some boards declare base+0 to base+7 as a PNP device, some base+4
+	 * to base+7 and some base+5 to base+6. So we better request each port
+	 * individually for the probing phase. */
+	for (port = address; port < address + LM78_EXTENT; port++) {
+		if (!request_region(port, 1, "lm78")) {
+			pr_debug("lm78: Failed to request port 0x%x\n", port);
+			goto release;
+		}
+	}
 
 #define REALLY_SLOW_IO
 	/* We need the timeouts for at least some LM78-like
@@ -901,7 +909,8 @@ static int __init lm78_isa_found(unsigne
 			val & 0x80 ? "LM79" : "LM78", (int)address);
 
  release:
-	release_region(address, LM78_EXTENT);
+	for (port--; port >= address; port--)
+		release_region(port, 1);
 	return found;
 }
 



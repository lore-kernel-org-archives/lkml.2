Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932746Ab0HXXql (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:46:41 -0400
Received: from kroah.org ([198.145.64.141]:52094 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756433Ab0HXWxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:53:41 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:25:23 2010
Message-Id: <20100824222523.804429703@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:24:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jean Delvare <khali@linux-fr.org>, Jim Cromie <jim.cromie@gmail.com>
Subject: [16/59] hwmon: (pc87360) Fix device resource declaration
In-Reply-To: <20100824224625.GA5449@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jean Delvare <khali@linux-fr.org>

commit b9783dcebe952bf73449fe70a19ee4814adc81a0 upstream.

It's not OK to call platform_device_add_resources() multiple times
in a row. Despite its name, this functions sets the resources, it
doesn't add them. So we have to prepare an array with all the
resources, and then call platform_device_add_resources() once.

Before this fix, only the last I/O resource would be actually
registered. The other I/O resources were leaked.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Jim Cromie <jim.cromie@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/pc87360.c |   31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

--- a/drivers/hwmon/pc87360.c
+++ b/drivers/hwmon/pc87360.c
@@ -1610,11 +1610,8 @@ static struct pc87360_data *pc87360_upda
 
 static int __init pc87360_device_add(unsigned short address)
 {
-	struct resource res = {
-		.name	= "pc87360",
-		.flags	= IORESOURCE_IO,
-	};
-	int err, i;
+	struct resource res[3];
+	int err, i, res_count;
 
 	pdev = platform_device_alloc("pc87360", address);
 	if (!pdev) {
@@ -1623,22 +1620,28 @@ static int __init pc87360_device_add(uns
 		goto exit;
 	}
 
+	memset(res, 0, 3 * sizeof(struct resource));
+	res_count = 0;
 	for (i = 0; i < 3; i++) {
 		if (!extra_isa[i])
 			continue;
-		res.start = extra_isa[i];
-		res.end = extra_isa[i] + PC87360_EXTENT - 1;
+		res[res_count].start = extra_isa[i];
+		res[res_count].end = extra_isa[i] + PC87360_EXTENT - 1;
+		res[res_count].name = "pc87360",
+		res[res_count].flags = IORESOURCE_IO,
 
-		err = acpi_check_resource_conflict(&res);
+		err = acpi_check_resource_conflict(&res[res_count]);
 		if (err)
 			goto exit_device_put;
 
-		err = platform_device_add_resources(pdev, &res, 1);
-		if (err) {
-			printk(KERN_ERR "pc87360: Device resource[%d] "
-			       "addition failed (%d)\n", i, err);
-			goto exit_device_put;
-		}
+		res_count++;
+	}
+
+	err = platform_device_add_resources(pdev, res, res_count);
+	if (err) {
+		printk(KERN_ERR "pc87360: Device resources addition failed "
+		       "(%d)\n", err);
+		goto exit_device_put;
 	}
 
 	err = platform_device_add(pdev);



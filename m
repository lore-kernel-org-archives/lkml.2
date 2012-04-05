Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177Ab2DEPg3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 11:36:29 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:43230 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab2DEPg2 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Thu, 5 Apr 2012 11:36:28 -0400
Message-Id: <4F7DD852020000780007CC2A@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Thu, 05 Apr 2012 16:37:22 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "Jens Axboe" <axboe@kernel.dk>, "xen-devel" <xen-devel@lists.xen.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] xen-blkfront: properly name all devices
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- devices beyond xvdzz didn't get proper names assigned at all
- extended devices with minors not representable within the kernel's
  major/minor bit split spilled into foreign majors

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 drivers/block/xen-blkfront.c |   40 ++++++++++++++++++++++------------------
 1 file changed, 22 insertions(+), 18 deletions(-)

--- 3.4-rc1/drivers/block/xen-blkfront.c
+++ 3.4-rc1-xen-blkfront-all-devices/drivers/block/xen-blkfront.c
@@ -528,6 +528,14 @@ static int xen_translate_vdev(int vdevic
 	return 0;
 }
 
+static char *encode_disk_name(char *ptr, unsigned int n)
+{
+	if (n >= 26)
+		ptr = encode_disk_name(ptr, n / 26 - 1);
+	*ptr = 'a' + n % 26;
+	return ptr + 1;
+}
+
 static int xlvbd_alloc_gendisk(blkif_sector_t capacity,
 			       struct blkfront_info *info,
 			       u16 vdisk_info, u16 sector_size)
@@ -538,6 +546,7 @@ static int xlvbd_alloc_gendisk(blkif_sec
 	unsigned int offset;
 	int minor;
 	int nr_parts;
+	char *ptr;
 
 	BUG_ON(info->gd != NULL);
 	BUG_ON(info->rq != NULL);
@@ -562,7 +571,11 @@ static int xlvbd_alloc_gendisk(blkif_sec
 					"emulated IDE disks,\n\t choose an xvd device name"
 					"from xvde on\n", info->vdevice);
 	}
-	err = -ENODEV;
+	if (minor >> MINORBITS) {
+		pr_warn("blkfront: %#x's minor (%#x) out of range; ignoring\n",
+			info->vdevice, minor);
+		return -ENODEV;
+	}
 
 	if ((minor % nr_parts) == 0)
 		nr_minors = nr_parts;
@@ -576,23 +589,14 @@ static int xlvbd_alloc_gendisk(blkif_sec
 	if (gd == NULL)
 		goto release;
 
-	if (nr_minors > 1) {
-		if (offset < 26)
-			sprintf(gd->disk_name, "%s%c", DEV_NAME, 'a' + offset);
-		else
-			sprintf(gd->disk_name, "%s%c%c", DEV_NAME,
-				'a' + ((offset / 26)-1), 'a' + (offset % 26));
-	} else {
-		if (offset < 26)
-			sprintf(gd->disk_name, "%s%c%d", DEV_NAME,
-				'a' + offset,
-				minor & (nr_parts - 1));
-		else
-			sprintf(gd->disk_name, "%s%c%c%d", DEV_NAME,
-				'a' + ((offset / 26) - 1),
-				'a' + (offset % 26),
-				minor & (nr_parts - 1));
-	}
+	strcpy(gd->disk_name, DEV_NAME);
+	ptr = encode_disk_name(gd->disk_name + sizeof(DEV_NAME) - 1, offset);
+	BUG_ON(ptr >= gd->disk_name + DISK_NAME_LEN);
+	if (nr_minors > 1)
+		*ptr = 0;
+	else
+		snprintf(ptr, gd->disk_name + DISK_NAME_LEN - ptr,
+			 "%d", minor & (nr_parts - 1));
 
 	gd->major = XENVBD_MAJOR;
 	gd->first_minor = minor;




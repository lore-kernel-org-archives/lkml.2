Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965063Ab2DKXVu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:21:50 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:51056 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964985Ab2DKXVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:21:45 -0400
Message-Id: <20120411231036.889490776@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 11 Apr 2012 16:10:43 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Marc Kleine-Budde <mkl@blackshift.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [ 08/59] mtd: ixp4xx: oops in ixp4xx_flash_probe
In-Reply-To: <20120411231213.GA13124@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@blackshift.org>

commit a3c1e3b732b3708a80e4035b9d845f3f7c7dd0c9 upstream.

In commit "c797533 mtd: abstract last MTD partition parser argument" the
third argument of "mtd_device_parse_register()" changed from start address
of the MTD device to a pointer to a struct.

The "ixp4xx_flash_probe()" function was not converted properly, causing
an oops during boot.

This patch fixes the problem by filling the needed information into a
"struct mtd_part_parser_data" and passing it to
"mtd_device_parse_register()".

Signed-off-by: Marc Kleine-Budde <mkl@blackshift.org>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/maps/ixp4xx.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/mtd/maps/ixp4xx.c
+++ b/drivers/mtd/maps/ixp4xx.c
@@ -182,6 +182,9 @@ static int ixp4xx_flash_probe(struct pla
 {
 	struct flash_platform_data *plat = dev->dev.platform_data;
 	struct ixp4xx_flash_info *info;
+	struct mtd_part_parser_data ppdata = {
+		.origin = dev->resource->start,
+	};
 	int err = -1;
 
 	if (!plat)
@@ -247,7 +250,7 @@ static int ixp4xx_flash_probe(struct pla
 	/* Use the fast version */
 	info->map.write = ixp4xx_write16;
 
-	err = mtd_device_parse_register(info->mtd, probes, dev->resource->start,
+	err = mtd_device_parse_register(info->mtd, probes, &ppdata,
 			plat->parts, plat->nr_parts);
 	if (err) {
 		printk(KERN_ERR "Could not parse partitions\n");



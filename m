Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758338Ab0KSWHH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:07:07 -0500
Received: from kroah.org ([198.145.64.141]:53081 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758179Ab0KSWEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 17:04:33 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 14:01:26 2010
Message-Id: <20101119220126.711134310@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 14:01:26 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Michael Reed <mdr@sgi.com>, James Bottomley <James.Bottomley@suse.de>
Subject: [55/66] [SCSI] sd name space exhaustion causes system hang
In-Reply-To: <20101119220309.GA15562@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Michael Reed <mdr@sgi.com>

commit 1a03ae0f556a931aa3747b70e44b78308f5b0590 upstream.

Following a site power outage which re-enabled all the ports on my FC
switches, my system subsequently booted with far too many luns!  I had
let it run hoping it would make multi-user.  It didn't.  :(  It hung solid
after exhausting the last sd device, sdzzz, and attempting to create sdaaaa
and beyond.  I was unable to get a dump.

Discovered using a 2.6.32.13 based system.

correct this by detecting when the last index is utilized and failing
the sd probe of the device.  Patch applies to scsi-misc-2.6.

Signed-off-by: Michael Reed <mdr@sgi.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/sd.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2252,11 +2252,10 @@ static void sd_probe_async(void *data, a
 	index = sdkp->index;
 	dev = &sdp->sdev_gendev;
 
-	if (index < SD_MAX_DISKS) {
-		gd->major = sd_major((index & 0xf0) >> 4);
-		gd->first_minor = ((index & 0xf) << 4) | (index & 0xfff00);
-		gd->minors = SD_MINORS;
-	}
+	gd->major = sd_major((index & 0xf0) >> 4);
+	gd->first_minor = ((index & 0xf) << 4) | (index & 0xfff00);
+	gd->minors = SD_MINORS;
+
 	gd->fops = &sd_fops;
 	gd->private_data = &sdkp->driver;
 	gd->queue = sdkp->device->request_queue;
@@ -2346,6 +2345,12 @@ static int sd_probe(struct device *dev)
 	if (error)
 		goto out_put;
 
+	if (index >= SD_MAX_DISKS) {
+		error = -ENODEV;
+		sdev_printk(KERN_WARNING, sdp, "SCSI disk (sd) name space exhausted.\n");
+		goto out_free_index;
+	}
+
 	error = sd_format_disk_name("sd", index, gd->disk_name, DISK_NAME_LEN);
 	if (error)
 		goto out_free_index;



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224Ab1ABH2v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:28:51 -0500
Received: from mail.windriver.com ([147.11.1.11]:37197 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755003Ab1ABHZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:25:57 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Michael Reed <mdr@sgi.com>,
        James Bottomley <James.Bottomley@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 255/260] sd name space exhaustion causes system hang
Date: Sun,  2 Jan 2011 02:19:11 -0500
Message-Id: <1293952756-15010-256-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:24:48.0433 (UTC) FILETIME=[232A3210:01CBAA4E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/scsi/sd.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index de6c603..892f446 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2163,11 +2163,10 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
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
@@ -2256,6 +2255,12 @@ static int sd_probe(struct device *dev)
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
-- 
1.7.3.3


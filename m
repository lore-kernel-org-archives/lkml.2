Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958Ab2DPUjR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 16:39:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45233 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755380Ab2DPUjB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 16:39:01 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>
Subject: [EDAC ABI v13 25/25] i7core_edac: change the mem allocation scheme to make Documentation/kobject.txt happy
Date: Mon, 16 Apr 2012 17:38:49 -0300
Message-Id: <1334608729-30803-26-git-send-email-mchehab@redhat.com>
In-Reply-To: <1334608729-30803-1-git-send-email-mchehab@redhat.com>
References: <1334608729-30803-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel kobjects have rigid rules: each container object should be
dynamically allocated, and can't be allocated into a single kmalloc.

EDAC never obeyed this rule: it has a single malloc function that
allocates all needed data into a single kzalloc.

As this is not accepted anymore, change the allocation schema of the
EDAC *_info structs to enforce this Kernel standard.

Cc: Aristeu Rozanski <arozansk@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/i7core_edac.c |   56 +++++++++++++++++++++++++++----------------
 1 files changed, 35 insertions(+), 21 deletions(-)

diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index e6a8efd..cf27af8 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -246,7 +246,7 @@ struct i7core_dev {
 };
 
 struct i7core_pvt {
-	struct device addrmatch_dev, chancounts_dev;
+	struct device *addrmatch_dev, *chancounts_dev;
 
 	struct pci_dev	*pci_noncore;
 	struct pci_dev	*pci_mcr[MAX_MCR_FUNC + 1];
@@ -1102,6 +1102,7 @@ static const struct attribute_group *addrmatch_groups[] = {
 static void addrmatch_release(struct device *device)
 {
 	debugf1("Releasing device %s\n", dev_name(device));
+	kfree(device);
 }
 
 static struct device_type addrmatch_type = {
@@ -1132,6 +1133,7 @@ static const struct attribute_group *all_channel_counts_groups[] = {
 static void all_channel_counts_release(struct device *device)
 {
 	debugf1("Releasing device %s\n", dev_name(device));
+	kfree(device);
 }
 
 static struct device_type all_channel_counts_type = {
@@ -1174,32 +1176,44 @@ static int i7core_create_sysfs_devices(struct mem_ctl_info *mci)
 	if (rc < 0)
 		return rc;
 
-	pvt->addrmatch_dev.type = &addrmatch_type;
-	pvt->addrmatch_dev.bus = mci->dev.bus;
-	device_initialize(&pvt->addrmatch_dev);
-	pvt->addrmatch_dev.parent = &mci->dev;
-	dev_set_name(&pvt->addrmatch_dev, "inject_addrmatch");
-	dev_set_drvdata(&pvt->addrmatch_dev, mci);
+	pvt->addrmatch_dev = kzalloc(sizeof(*pvt->addrmatch_dev), GFP_KERNEL);
+	if (!pvt->addrmatch_dev)
+		return rc;
+
+	pvt->addrmatch_dev->type = &addrmatch_type;
+	pvt->addrmatch_dev->bus = mci->dev.bus;
+	device_initialize(pvt->addrmatch_dev);
+	pvt->addrmatch_dev->parent = &mci->dev;
+	dev_set_name(pvt->addrmatch_dev, "inject_addrmatch");
+	dev_set_drvdata(pvt->addrmatch_dev, mci);
 
 	debugf1("%s(): creating %s\n", __func__,
-		dev_name(&pvt->addrmatch_dev));
+		dev_name(pvt->addrmatch_dev));
 
-	rc = device_add(&pvt->addrmatch_dev);
+	rc = device_add(pvt->addrmatch_dev);
 	if (rc < 0)
 		return rc;
 
 	if (!pvt->is_registered) {
-		pvt->chancounts_dev.type = &all_channel_counts_type;
-		pvt->chancounts_dev.bus = mci->dev.bus;
-		device_initialize(&pvt->chancounts_dev);
-		pvt->chancounts_dev.parent = &mci->dev;
-		dev_set_name(&pvt->chancounts_dev, "all_channel_counts");
-		dev_set_drvdata(&pvt->chancounts_dev, mci);
+		pvt->chancounts_dev = kzalloc(sizeof(*pvt->chancounts_dev),
+					      GFP_KERNEL);
+		if (!pvt->chancounts_dev) {
+			put_device(pvt->addrmatch_dev);
+			device_del(pvt->addrmatch_dev);
+			return rc;
+		}
+
+		pvt->chancounts_dev->type = &all_channel_counts_type;
+		pvt->chancounts_dev->bus = mci->dev.bus;
+		device_initialize(pvt->chancounts_dev);
+		pvt->chancounts_dev->parent = &mci->dev;
+		dev_set_name(pvt->chancounts_dev, "all_channel_counts");
+		dev_set_drvdata(pvt->chancounts_dev, mci);
 
 		debugf1("%s(): creating %s\n", __func__,
-			dev_name(&pvt->chancounts_dev));
+			dev_name(pvt->chancounts_dev));
 
-		rc = device_add(&pvt->chancounts_dev);
+		rc = device_add(pvt->chancounts_dev);
 		if (rc < 0)
 			return rc;
 	}
@@ -1218,11 +1232,11 @@ static void i7core_delete_sysfs_devices(struct mem_ctl_info *mci)
 	device_remove_file(&mci->dev, &dev_attr_inject_enable);
 
 	if (!pvt->is_registered) {
-		put_device(&pvt->chancounts_dev);
-		device_del(&pvt->chancounts_dev);
+		put_device(pvt->chancounts_dev);
+		device_del(pvt->chancounts_dev);
 	}
-	put_device(&pvt->addrmatch_dev);
-	device_del(&pvt->addrmatch_dev);
+	put_device(pvt->addrmatch_dev);
+	device_del(pvt->addrmatch_dev);
 }
 
 /****************************************************************************
-- 
1.7.8


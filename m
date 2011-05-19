Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934848Ab1ESVeI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 17:34:08 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:59113 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934815Ab1ESVeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 17:34:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=poLHpq1WHBWxDceqf5T1X6EAooJ5aZllSo8Sy1taBy7/SwXkKUxtT/MmD8iS9htKW0
         Jl+tXntB1mwehAe8a7GEqF18NMl/CovDcKGJ1KqgQzL3ME5HoxDxEB0qbrWU3Eexe0gd
         htvoUTgZ6owp7KheKeJCq5eaG2xa4C7gEoVZU=
From: Jim Cromie <jim.cromie@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 03/23] use register_chrdev_ids to replace (register|alloc)_chrdev_region
Date: Thu, 19 May 2011 15:33:06 -0600
Message-Id: <1305840792-25877-4-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1305840792-25877-1-git-send-email-jim.cromie@gmail.com>
References: <1305840792-25877-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

replace __deprecated (register|alloc)_chrdev_region api calls with
register_chrdev_ids.

This patch brought to you by coccinelle-spatch with the following
cocci-file.  It transforms ~40 callsites, which are broken out on
MAINTAINER boundaries, but misses those with MKDEV(X,Y) in the
param-list.

@ combo @	// if-major-alloc-else-register
dev_t devid;
identifier rc;
expression major, minor;
expression CT, DEVNAME;
@@

-	if (major) {
-		devid = MKDEV(major, 0);
-		rc = register_chrdev_region(devid, CT, DEVNAME);
-	} else {
-		rc = alloc_chrdev_region(&devid, minor, CT, DEVNAME);
-		major = MAJOR(devid);
-	}

+	devid = MKDEV(major, minor);
+	rc = register_chrdev_ids(&devid, CT, DEVNAME);

// general rules, implicitly depend on !combo

@ register_chrdev_region @
dev_t devid;			// typed simple var, not MKDEV(x,y)
expression ct, name;
@@

- register_chrdev_region(devid, ct, name)
+ register_chrdev_ids(&devid, ct, name)

@ alloc_chrdev_region @
dev_t devid;			// typed simple var, not MKDEV(x,y)
expression minor, ct, name;
@@

- alloc_chrdev_region(&devid, minor, ct, name)
+ register_chrdev_ids(&devid, ct, name)

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 drivers/char/pc8736x_gpio.c |   20 ++++++--------------
 drivers/char/scx200_gpio.c  |   12 ++++--------
 2 files changed, 10 insertions(+), 22 deletions(-)

diff --git a/drivers/char/pc8736x_gpio.c b/drivers/char/pc8736x_gpio.c
index b304ec0..cf01c99 100644
--- a/drivers/char/pc8736x_gpio.c
+++ b/drivers/char/pc8736x_gpio.c
@@ -254,7 +254,7 @@ static struct cdev pc8736x_gpio_cdev;
 static int __init pc8736x_gpio_init(void)
 {
 	int rc;
-	dev_t devid;
+	dev_t devid = MKDEV(major, 0);
 
 	pdev = platform_device_alloc(DEVNAME, 0);
 	if (!pdev)
@@ -300,24 +300,16 @@ static int __init pc8736x_gpio_init(void)
 			pc8736x_gpio_base);
 		goto undo_platform_dev_add;
 	}
-	dev_info(&pdev->dev, "GPIO ioport %x reserved\n", pc8736x_gpio_base);
-
-	if (major) {
-		devid = MKDEV(major, 0);
-		rc = register_chrdev_region(devid, PC8736X_GPIO_CT, DEVNAME);
-	} else {
-		rc = alloc_chrdev_region(&devid, 0, PC8736X_GPIO_CT, DEVNAME);
-		major = MAJOR(devid);
-	}
 
+	rc = register_chrdev_ids(&devid, PC8736X_GPIO_CT, DEVNAME);
 	if (rc < 0) {
 		dev_err(&pdev->dev, "register-chrdev failed: %d\n", rc);
 		goto undo_request_region;
 	}
-	if (!major) {
-		major = rc;
-		dev_dbg(&pdev->dev, "got dynamic major %d\n", major);
-	}
+	major = MAJOR(devid);
+
+	dev_info(&pdev->dev, "GPIO ioport=%x, device-major=%d\n",
+		 pc8736x_gpio_base, major);
 
 	pc8736x_init_shadow();
 
diff --git a/drivers/char/scx200_gpio.c b/drivers/char/scx200_gpio.c
index 0bc135b..9b53a01 100644
--- a/drivers/char/scx200_gpio.c
+++ b/drivers/char/scx200_gpio.c
@@ -75,7 +75,7 @@ static struct cdev scx200_gpio_cdev;  /* use 1 cdev for all pins */
 static int __init scx200_gpio_init(void)
 {
 	int rc;
-	dev_t devid;
+	dev_t devid = MKDEV(major, 0);
 
 	if (!scx200_gpio_present()) {
 		printk(KERN_ERR DRVNAME ": no SCx200 gpio present\n");
@@ -94,17 +94,13 @@ static int __init scx200_gpio_init(void)
 	/* nsc_gpio uses dev_dbg(), so needs this */
 	scx200_gpio_ops.dev = &pdev->dev;
 
-	if (major) {
-		devid = MKDEV(major, 0);
-		rc = register_chrdev_region(devid, MAX_PINS, "scx200_gpio");
-	} else {
-		rc = alloc_chrdev_region(&devid, 0, MAX_PINS, "scx200_gpio");
-		major = MAJOR(devid);
-	}
+	rc = register_chrdev_ids(&devid, MAX_PINS, "scx200_gpio");
 	if (rc < 0) {
 		dev_err(&pdev->dev, "SCx200 chrdev_region err: %d\n", rc);
 		goto undo_platform_device_add;
 	}
+	major = MAJOR(devid);
+	dev_info(&pdev->dev, "GPIO device-major=%d\n", major);
 
 	cdev_init(&scx200_gpio_cdev, &scx200_gpio_fileops);
 	cdev_add(&scx200_gpio_cdev, devid, MAX_PINS);
-- 
1.7.4.4


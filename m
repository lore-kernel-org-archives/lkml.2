Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934921Ab1ESVf7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 17:35:59 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50593 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934835Ab1ESVeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 17:34:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=kH6kCwD5WUHdb+q7HOAO4GafbEMd40VNayVbN/QYhtfUuo9XQpX0E6ItA+04vr4bv6
         qjTw6ucZTOKuLeDq+Mj9pBq742b7ID7zHblKUJRbi7HVp3EsViCrZImJaoeO0U/KI8Di
         HMRPW1kaxxrRzJlU8qrzl0cwxXFeoWMbxju4Y=
From: Jim Cromie <jim.cromie@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, Jim Cromie <jim.cromie@gmail.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        linux-rdma@vger.kernel.org
Subject: [PATCH 05/23] use register_chrdev_ids in drivers/infiniband/
Date: Thu, 19 May 2011 15:33:08 -0600
Message-Id: <1305840792-25877-6-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1305840792-25877-1-git-send-email-jim.cromie@gmail.com>
References: <1305840792-25877-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since new api passes dev_t*, hoist inline MKDEV out to local var
assignment, and replace other inline MKDEVs with new var.

This patch brought to you by coccinelle/spatch,
with some manual rework afterwards.

cc: Hal Rosenstock <hal.rosenstock@gmail.com>
cc: Roland Dreier <roland@kernel.org>
cc: Sean Hefty <sean.hefty@intel.com>
cc: linux-rdma@vger.kernel.org

@ rcr_md @
identifier f;
expression major, minor;
expression ct, name;
@@

	f(...) {
// ++ gives multiple inserts, needed for tty_io.c, fix up manually
// fresh identifier apparently also helps here
++	dev_t devt;
++	devt = MKDEV(major,minor);

<+...
-	register_chrdev_region
+	register_chrdev_ids
	(
-	MKDEV(major,minor),
+	&devt,
	ct, name)
...+>

}

@ all_md depends on rcr_md @	// where above changes made, also do
identifier f;
expression major, minor;
@@

	f(...) {
	dev_t devt;
	devt = MKDEV(major,minor);

<+...
-	MKDEV(major,minor)
+	devt
...+>
	}

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 drivers/infiniband/core/ucm.c                |    2 +-
 drivers/infiniband/core/user_mad.c           |    7 ++++---
 drivers/infiniband/core/uverbs_main.c        |    3 ++-
 drivers/infiniband/hw/ipath/ipath_file_ops.c |    2 +-
 drivers/infiniband/hw/qib/qib_file_ops.c     |    2 +-
 5 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/core/ucm.c b/drivers/infiniband/core/ucm.c
index 08f948d..472a7b2 100644
--- a/drivers/infiniband/core/ucm.c
+++ b/drivers/infiniband/core/ucm.c
@@ -1244,7 +1244,7 @@ static int find_overflow_devnum(void)
 	int ret;
 
 	if (!overflow_maj) {
-		ret = alloc_chrdev_region(&overflow_maj, 0, IB_UCM_MAX_DEVICES,
+		ret = register_chrdev_ids(&overflow_maj, IB_UCM_MAX_DEVICES,
 					  "infiniband_cm");
 		if (ret) {
 			printk(KERN_ERR "ucm: couldn't register dynamic device number\n");
diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index cd1996d..7352683 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -980,7 +980,8 @@ static int find_overflow_devnum(void)
 	int ret;
 
 	if (!overflow_maj) {
-		ret = alloc_chrdev_region(&overflow_maj, 0, IB_UMAD_MAX_PORTS * 2,
+		ret = register_chrdev_ids(&overflow_maj,
+					  IB_UMAD_MAX_PORTS * 2,
 					  "infiniband_mad");
 		if (ret) {
 			printk(KERN_ERR "user_mad: couldn't register dynamic device number\n");
@@ -1180,8 +1181,8 @@ static int __init ib_umad_init(void)
 {
 	int ret;
 
-	ret = register_chrdev_region(base_dev, IB_UMAD_MAX_PORTS * 2,
-				     "infiniband_mad");
+	ret = register_chrdev_ids(&base_dev, IB_UMAD_MAX_PORTS * 2,
+				  "infiniband_mad");
 	if (ret) {
 		printk(KERN_ERR "user_mad: couldn't register device number\n");
 		goto out;
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index ec83e9f..2f92115 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -711,7 +711,8 @@ static int find_overflow_devnum(void)
 	int ret;
 
 	if (!overflow_maj) {
-		ret = alloc_chrdev_region(&overflow_maj, 0, IB_UVERBS_MAX_DEVICES,
+		ret = register_chrdev_ids(&overflow_maj,
+					  IB_UVERBS_MAX_DEVICES,
 					  "infiniband_verbs");
 		if (ret) {
 			printk(KERN_ERR "user_verbs: couldn't register dynamic device number\n");
diff --git a/drivers/infiniband/hw/ipath/ipath_file_ops.c b/drivers/infiniband/hw/ipath/ipath_file_ops.c
index ee79a2d..04abb61 100644
--- a/drivers/infiniband/hw/ipath/ipath_file_ops.c
+++ b/drivers/infiniband/hw/ipath/ipath_file_ops.c
@@ -2519,7 +2519,7 @@ static int user_init(void)
 {
 	int ret;
 
-	ret = register_chrdev_region(dev, IPATH_NMINORS, IPATH_DRV_NAME);
+	ret = register_chrdev_ids(&dev, IPATH_NMINORS, IPATH_DRV_NAME);
 	if (ret < 0) {
 		printk(KERN_ERR IPATH_DRV_NAME ": Could not register "
 		       "chrdev region (err %d)\n", -ret);
diff --git a/drivers/infiniband/hw/qib/qib_file_ops.c b/drivers/infiniband/hw/qib/qib_file_ops.c
index 406fca5..a5ecea2 100644
--- a/drivers/infiniband/hw/qib/qib_file_ops.c
+++ b/drivers/infiniband/hw/qib/qib_file_ops.c
@@ -2238,7 +2238,7 @@ int __init qib_dev_init(void)
 {
 	int ret;
 
-	ret = alloc_chrdev_region(&qib_dev, 0, QIB_NMINORS, QIB_DRV_NAME);
+	ret = register_chrdev_ids(&qib_dev, QIB_NMINORS, QIB_DRV_NAME);
 	if (ret < 0) {
 		printk(KERN_ERR QIB_DRV_NAME ": Could not allocate "
 		       "chrdev region (err %d)\n", -ret);
-- 
1.7.4.4


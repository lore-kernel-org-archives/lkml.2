Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935Ab2GCQqA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 12:46:00 -0400
Received: from smtp-out-143.synserver.de ([212.40.185.143]:1085 "EHLO
	smtp-out-143.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab2GCQpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 12:45:53 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 8920
From: Lars-Peter Clausen <lars@metafoo.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 1/2] driver-core: Move kobj_to_dev from genhd.h to device.h
Date: Tue,  3 Jul 2012 18:49:35 +0200
Message-Id: <1341334176-8801-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function is not really specific to the genhd layer and there are various
re-implementations or open-coded variants of it all throughout the kernel. To
avoid further duplications move the function to a more generic place.

While moving also convert it from a macro to a inline function.

Potential users of this function can be detected and converted using the
following coccinelle patch:

// <smpl>
@@
expression k;
@@
-container_of(k, struct device, kobj)
+kobj_to_dev(kobj)
// </smpl>

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 include/linux/device.h |    5 +++++
 include/linux/genhd.h  |    1 -
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/linux/device.h b/include/linux/device.h
index 161d962..5c4495c 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -689,6 +689,11 @@ struct device {
 	void	(*release)(struct device *dev);
 };
 
+static inline struct device *kobj_to_dev(struct kobject *kobj)
+{
+	return container_of(kobj, struct device, kobj);
+}
+
 /* Get the wakeup routines, which depend on struct device */
 #include <linux/pm_wakeup.h>
 
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 017a7fb..ae0aaa9 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -16,7 +16,6 @@
 
 #ifdef CONFIG_BLOCK
 
-#define kobj_to_dev(k)		container_of((k), struct device, kobj)
 #define dev_to_disk(device)	container_of((device), struct gendisk, part0.__dev)
 #define dev_to_part(device)	container_of((device), struct hd_struct, __dev)
 #define disk_to_dev(disk)	(&(disk)->part0.__dev)
-- 
1.7.10


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599Ab2G0EDH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 00:03:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39279 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab2G0EDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 00:03:04 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: gregkh@linuxfoundation.org, ccross@android.com, hmh@hmh.eng.br,
        rpurdie@rpsys.net, linux-kernel@vger.kernel.org,
        linux-leds@vger.kernel.org
Subject: [PATCH 1/3] sysfs: introduce a sysfs_create_file_uevent new API
Date: Fri, 27 Jul 2012 12:02:41 +0800
Message-Id: <1343361763-10307-2-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.11.1
In-Reply-To: <1343361763-10307-1-git-send-email-bryan.wu@canonical.com>
References: <1343361763-10307-1-git-send-email-bryan.wu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Send a uevent notification whenever a new sysfs file is created to allow
userspace processes such as udev to modify permissions on the new files.

This new API function helps to do this.

Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
---
 fs/sysfs/file.c       | 28 ++++++++++++++++++++++++++++
 include/linux/sysfs.h | 13 +++++++++++++
 2 files changed, 41 insertions(+)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 00012e3..5a22d13 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -576,6 +576,34 @@ int sysfs_create_file(struct kobject * kobj, const struct attribute * attr)
 
 }
 
+/**
+ *	sysfs_create_file_uevent - create an attribute file for an object
+					and send a uevent to userspace.
+ *	@kobj:	object we're creating for.
+ *	@attr:	attribute descriptor.
+ *	@desc:  description about the uevent.
+ *	@action: kobject uevent action type.
+ */
+
+int sysfs_create_file_uevent(struct kobject *kobj, const struct attribute *attr,
+			const char *desc, enum kobject_action action)
+{
+	int err = 0;
+	char *envp[2];
+
+	BUG_ON(!kobj || !kobj->sd || !attr || !desc);
+
+	err = sysfs_add_file(kobj->sd, attr, SYSFS_KOBJ_ATTR);
+
+	if (desc) {
+		envp[0] = desc;
+		envp[1] = NULL;
+		kobject_uevent_env(kobj, action, envp);
+	}
+
+	return err;
+}
+
 int sysfs_create_files(struct kobject *kobj, const struct attribute **ptr)
 {
 	int err = 0;
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 381f06d..0054d41 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -22,6 +22,7 @@
 struct kobject;
 struct module;
 enum kobj_ns_type;
+enum kobject_action;
 
 struct attribute {
 	const char		*name;
@@ -142,6 +143,10 @@ int __must_check sysfs_move_dir(struct kobject *kobj,
 
 int __must_check sysfs_create_file(struct kobject *kobj,
 				   const struct attribute *attr);
+int __must_check sysfs_create_file_uevent(struct kobject * kobj,
+				const struct attribute * attr,
+				const char * desc,
+				enum kobject_action action);
 int __must_check sysfs_create_files(struct kobject *kobj,
 				   const struct attribute **attr);
 int __must_check sysfs_chmod_file(struct kobject *kobj,
@@ -226,6 +231,14 @@ static inline int sysfs_create_file(struct kobject *kobj,
 	return 0;
 }
 
+static inline int sysfs_create_file_uevent(struct kobject * kobj,
+					const struct attribute * attr,
+					const char *desc,
+					enum kobject_action action)
+{
+	return 0;
+}
+
 static inline int sysfs_create_files(struct kobject *kobj,
 				    const struct attribute **attr)
 {
-- 
1.7.11.1


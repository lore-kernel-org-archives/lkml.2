Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055Ab2LDKok (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 05:44:40 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:36089 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752388Ab2LDKoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 05:44:34 -0500
From: Serban Constantinescu <serban.constantinescu@arm.com>
To: gregkh@linuxfoundation.org, arve@android.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, john.stultz@linaro.org,
        ccross@android.com, zach.pfeffer@linaro.org, Dave.Butcher@arm.com
Cc: Serban Constantinescu <serban.constantinescu@arm.com>
Subject: [PATCH 2/2] Staging: android: ashmem: Add support for 32bit ashmem calls in a 64bit kernel
Date: Tue,  4 Dec 2012 10:44:14 +0000
Message-Id: <1354617854-25296-3-git-send-email-serban.constantinescu@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1354617854-25296-1-git-send-email-serban.constantinescu@arm.com>
References: <1354617854-25296-1-git-send-email-serban.constantinescu@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Android's shared memory subsystem, Ashmem, does not support calls from a
32-bit userspace in a 64 bit kernel. This patch adds support for syscalls
coming from a 32-bit userspace in a 64-bit kernel.

Most of the changes were applied to types that change sizes between
32 and 64 bit world. This will also fix some of the issues around
checking the size of an incoming transaction package in the ioctl
switch. Since  the transaction's ioctl number are generated using
_IOC(dir,type,nr,size), a different userspace size will generate
a different ioctl number, thus switching by _IOC_NR is a better
solution.

The patch has been successfully tested on ARMv8 AEM and Versatile
Express V2P-CA9.

Signed-off-by: Serban Constantinescu <serban.constantinescu@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
---
 drivers/staging/android/ashmem.c |   60 +++++++++++++++++++++++++-------------
 drivers/staging/android/ashmem.h |    6 ++--
 2 files changed, 43 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/android/ashmem.c b/drivers/staging/android/ashmem.c
index 634b9ae..5e3e687 100644
--- a/drivers/staging/android/ashmem.c
+++ b/drivers/staging/android/ashmem.c
@@ -411,7 +411,7 @@ out:
 	return ret;
 }
 
-static int set_name(struct ashmem_area *asma, void __user *name)
+static int set_name(struct ashmem_area *asma, userptr32_t name)
 {
 	int ret = 0;
 
@@ -424,7 +424,7 @@ static int set_name(struct ashmem_area *asma, void __user *name)
 	}
 
 	if (unlikely(copy_from_user(asma->name + ASHMEM_NAME_PREFIX_LEN,
-				    name, ASHMEM_NAME_LEN)))
+				    (void *)(unsigned long)name, ASHMEM_NAME_LEN)))
 		ret = -EFAULT;
 	asma->name[ASHMEM_FULL_NAME_LEN-1] = '\0';
 
@@ -434,7 +434,7 @@ out:
 	return ret;
 }
 
-static int get_name(struct ashmem_area *asma, void __user *name)
+static int get_name(struct ashmem_area *asma, userptr32_t name)
 {
 	int ret = 0;
 
@@ -447,11 +447,11 @@ static int get_name(struct ashmem_area *asma, void __user *name)
 		 * prevents us from revealing one user's stack to another.
 		 */
 		len = strlen(asma->name + ASHMEM_NAME_PREFIX_LEN) + 1;
-		if (unlikely(copy_to_user(name,
+		if (unlikely(copy_to_user((void *)(unsigned long)name,
 				asma->name + ASHMEM_NAME_PREFIX_LEN, len)))
 			ret = -EFAULT;
 	} else {
-		if (unlikely(copy_to_user(name, ASHMEM_NAME_DEF,
+		if (unlikely(copy_to_user((void *)(unsigned long)name, ASHMEM_NAME_DEF,
 					  sizeof(ASHMEM_NAME_DEF))))
 			ret = -EFAULT;
 	}
@@ -586,7 +586,7 @@ static int ashmem_get_pin_status(struct ashmem_area *asma, size_t pgstart,
 }
 
 static int ashmem_pin_unpin(struct ashmem_area *asma, unsigned long cmd,
-			    void __user *p)
+			    userptr32_t p)
 {
 	struct ashmem_pin pin;
 	size_t pgstart, pgend;
@@ -595,7 +595,7 @@ static int ashmem_pin_unpin(struct ashmem_area *asma, unsigned long cmd,
 	if (unlikely(!asma->file))
 		return -EINVAL;
 
-	if (unlikely(copy_from_user(&pin, p, sizeof(pin))))
+	if (unlikely(copy_from_user(&pin, (void *)(unsigned long)p, sizeof(pin))))
 		return -EFAULT;
 
 	/* per custom, you can pass zero for len to mean "everything onward" */
@@ -638,35 +638,50 @@ static long ashmem_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	struct ashmem_area *asma = file->private_data;
 	long ret = -ENOTTY;
 
-	switch (cmd) {
-	case ASHMEM_SET_NAME:
-		ret = set_name(asma, (void __user *) arg);
+	/*
+	 * since  the transaction's IOCTL number are generated using
+	 * _IOC(dir,type,nr,size), a different userspace size will not
+	 * fall through
+	 */
+	switch (_IOC_NR(cmd)) {
+	case _IOC_NR(ASHMEM_SET_NAME):
+		if (_IOC_SIZE(cmd) != sizeof(char[ASHMEM_NAME_LEN]))
+			pr_err("ashmem: ASHMEM_SET_NAME transaction size differs\n");
+		ret = set_name(asma, arg);
 		break;
-	case ASHMEM_GET_NAME:
-		ret = get_name(asma, (void __user *) arg);
+	case _IOC_NR(ASHMEM_GET_NAME):
+		if (_IOC_SIZE(cmd) != sizeof(char[ASHMEM_NAME_LEN]))
+			pr_err("ashmem: ASHMEM_GET_NAME transaction size differs\n");
+		ret = get_name(asma, arg);
 		break;
-	case ASHMEM_SET_SIZE:
+	case _IOC_NR(ASHMEM_SET_SIZE):
+		if (_IOC_SIZE(cmd) != sizeof(uint32_t))
+			pr_err("ashmem: ASHMEM_SET_SIZE transaction size differs\n");
 		ret = -EINVAL;
 		if (!asma->file) {
 			ret = 0;
 			asma->size = (size_t) arg;
 		}
 		break;
-	case ASHMEM_GET_SIZE:
+	case _IOC_NR(ASHMEM_GET_SIZE):
 		ret = asma->size;
 		break;
-	case ASHMEM_SET_PROT_MASK:
+	case _IOC_NR(ASHMEM_SET_PROT_MASK):
+		if (_IOC_SIZE(cmd) != sizeof(uint32_t))
+			pr_err("ashmem: ASHMEM_SET_PROT_MASK transaction size differs\n");
 		ret = set_prot_mask(asma, arg);
 		break;
-	case ASHMEM_GET_PROT_MASK:
+	case _IOC_NR(ASHMEM_GET_PROT_MASK):
 		ret = asma->prot_mask;
 		break;
-	case ASHMEM_PIN:
-	case ASHMEM_UNPIN:
-	case ASHMEM_GET_PIN_STATUS:
-		ret = ashmem_pin_unpin(asma, cmd, (void __user *) arg);
+	case _IOC_NR(ASHMEM_PIN):
+	case _IOC_NR(ASHMEM_UNPIN):
+	case _IOC_NR(ASHMEM_GET_PIN_STATUS):
+		if (_IOC_SIZE(cmd) != sizeof(struct ashmem_pin))
+			pr_err("ashmem: ASHMEM_PIN transaction size differs\n");
+		ret = ashmem_pin_unpin(asma, cmd, arg);
 		break;
-	case ASHMEM_PURGE_ALL_CACHES:
+	case _IOC_NR(ASHMEM_PURGE_ALL_CACHES):
 		ret = -EPERM;
 		if (capable(CAP_SYS_ADMIN)) {
 			struct shrink_control sc = {
@@ -678,6 +693,9 @@ static long ashmem_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 			ashmem_shrink(&ashmem_shrinker, &sc);
 		}
 		break;
+	default:
+		pr_err("ashmem: IOCTL No. not found\n");
+		break;
 	}
 
 	return ret;
diff --git a/drivers/staging/android/ashmem.h b/drivers/staging/android/ashmem.h
index 1976b10..4ecdc73 100644
--- a/drivers/staging/android/ashmem.h
+++ b/drivers/staging/android/ashmem.h
@@ -27,6 +27,8 @@
 #define ASHMEM_IS_UNPINNED	0
 #define ASHMEM_IS_PINNED	1
 
+typedef uint32_t userptr32_t;
+
 struct ashmem_pin {
 	__u32 offset;	/* offset into region, in bytes, page-aligned */
 	__u32 len;	/* length forward from offset, in bytes, page-aligned */
@@ -36,9 +38,9 @@ struct ashmem_pin {
 
 #define ASHMEM_SET_NAME		_IOW(__ASHMEMIOC, 1, char[ASHMEM_NAME_LEN])
 #define ASHMEM_GET_NAME		_IOR(__ASHMEMIOC, 2, char[ASHMEM_NAME_LEN])
-#define ASHMEM_SET_SIZE		_IOW(__ASHMEMIOC, 3, size_t)
+#define ASHMEM_SET_SIZE		_IOW(__ASHMEMIOC, 3, unsigned int)
 #define ASHMEM_GET_SIZE		_IO(__ASHMEMIOC, 4)
-#define ASHMEM_SET_PROT_MASK	_IOW(__ASHMEMIOC, 5, unsigned long)
+#define ASHMEM_SET_PROT_MASK	_IOW(__ASHMEMIOC, 5, unsigned int)
 #define ASHMEM_GET_PROT_MASK	_IO(__ASHMEMIOC, 6)
 #define ASHMEM_PIN		_IOW(__ASHMEMIOC, 7, struct ashmem_pin)
 #define ASHMEM_UNPIN		_IOW(__ASHMEMIOC, 8, struct ashmem_pin)
-- 
1.7.9.5


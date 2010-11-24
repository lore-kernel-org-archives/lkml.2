Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756432Ab0KXTzk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 14:55:40 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:48617 "EHLO deliverator"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756368Ab0KXTx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 14:53:58 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 02/12] sep: handle the rar definition stuff in the header
To: greg@kroah.com, mark.a.allyn@intel.com, linux-kernel@vger.kernel.org
Date: Wed, 24 Nov 2010 19:33:43 +0000
Message-ID: <20101124193338.16425.36821.stgit@bob.linux.org.uk>
In-Reply-To: <20101124192136.16425.49994.stgit@bob.linux.org.uk>
References: <20101124192136.16425.49994.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

SEP isn't the only driver that may need to handle both cases easily

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/sep/sep_driver.c        |    1 +
 drivers/staging/sep/sep_driver_config.h |   61 -------------------------------
 include/linux/rar_register.h            |   16 ++++++++
 3 files changed, 17 insertions(+), 61 deletions(-)


diff --git a/drivers/staging/sep/sep_driver.c b/drivers/staging/sep/sep_driver.c
index ef36239..8a1ff86 100644
--- a/drivers/staging/sep/sep_driver.c
+++ b/drivers/staging/sep/sep_driver.c
@@ -53,6 +53,7 @@
 #include <asm/cacheflush.h>
 #include <linux/sched.h>
 #include <linux/delay.h>
+#include <linux/rar_register.h>
 
 #include <linux/netlink.h>
 #include <linux/connector.h>
diff --git a/drivers/staging/sep/sep_driver_config.h b/drivers/staging/sep/sep_driver_config.h
index 68688cb..cfda86f 100644
--- a/drivers/staging/sep/sep_driver_config.h
+++ b/drivers/staging/sep/sep_driver_config.h
@@ -236,15 +236,6 @@ held by the proccess (struct file) */
 /* This stub header is for non Moorestown driver only */
 
 /*
- * Constants that specify different kinds of RAR regions that could be
- * set up.
- */
-static __u32 const RAR_TYPE_VIDEO;  /* 0 */
-static __u32 const RAR_TYPE_AUDIO = 1;
-static __u32 const RAR_TYPE_IMAGE = 2;
-static __u32 const RAR_TYPE_DATA  = 3;
-
-/*
  * @struct RAR_stat
  *
  * @brief This structure is used for @c RAR_HANDLER_STAT ioctl and for
@@ -373,56 +364,4 @@ struct RAR_buffer {
 
 #endif  /* MEMRAR */
 
-/* rar_register */
-#ifndef CONFIG_RAR_REGISTER
-/* This stub header is for non Moorestown driver only */
-
-/* The register_rar function is to used by other device drivers
- * to ensure that this driver is ready. As we cannot be sure of
- * the compile/execute order of dirvers in ther kernel, it is
- * best to give this driver a callback function to call when
- * it is ready to give out addresses. The callback function
- * would have those steps that continue the initialization of
- * a driver that do require a valid RAR address. One of those
- * steps would be to call get_rar_address()
- * This function return 0 on success an -1 on failure.
- */
-#define register_rar(a, b, c) (-ENODEV)
-
-/* The get_rar_address function is used by other device drivers
- * to obtain RAR address information on a RAR. It takes two
- * parameter:
- *
- * int rar_index
- * The rar_index is an index to the rar for which you wish to retrieve
- * the address information.
- * Values can be 0,1, or 2.
- *
- * struct RAR_address_struct is a pointer to a place to which the function
- * can return the address structure for the RAR.
- *
- * The function returns a 0 upon success or a -1 if there is no RAR
- * facility on this system.
- */
-#define rar_get_address(a, b, c) (-ENODEV)
-
-/* The lock_rar function is ued by other device drivers to lock an RAR.
- * once an RAR is locked, it stays locked until the next system reboot.
- * The function takes one parameter:
- *
- * int rar_index
- * The rar_index is an index to the rar that you want to lock.
- * Values can be 0,1, or 2.
- *
- * The function returns a 0 upon success or a -1 if there is no RAR
- * facility on this system.
- */
-#define rar_lock(a) (-1)
-
-#else /* using real RAR_REGISTER */
-
-#include <linux/rar_register.h>
-
-#endif  /* CONFIG_RAR_REGISTER */
-
 #endif /* SEP DRIVER CONFIG */
diff --git a/include/linux/rar_register.h b/include/linux/rar_register.h
index ffa8057..5c61181 100644
--- a/include/linux/rar_register.h
+++ b/include/linux/rar_register.h
@@ -34,11 +34,27 @@
 
 struct rar_device;
 
+#if defined(CONFIG_RAR_REGISTER)
 int register_rar(int num,
 		int (*callback)(unsigned long data), unsigned long data);
 void unregister_rar(int num);
 int rar_get_address(int rar_index, dma_addr_t *start, dma_addr_t *end);
 int rar_lock(int rar_index);
+#else
+extern void unregister_rar(int num)  { }
+extern int rar_lock(int rar_index) { return -EIO; }
+
+extern inline int register_rar(int num,
+		int (*callback)(unsigned long data), unsigned long data)
+{
+	return -ENODEV;
+}
+
+extern int rar_get_address(int rar_index, dma_addr_t *start, dma_addr_t *end)
+{
+	return -ENODEV;
+}
+#endif	/* RAR_REGISTER */
 
 #endif  /* __KERNEL__ */
 #endif  /* _RAR_REGISTER_H */


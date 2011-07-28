Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771Ab1G1FRu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 01:17:50 -0400
Received: from mail.windriver.com ([147.11.1.11]:51309 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754674Ab1G1FQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 01:16:37 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: mingo@elte.hu, torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux-arch@vger.kernel.org
Subject: [PATCH 11/11] include: replace linux/module.h with "struct module" wherever possible
Date: Thu, 28 Jul 2011 01:16:18 -0400
Message-Id: <1311830178-30314-12-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311830178-30314-1-git-send-email-paul.gortmaker@windriver.com>
References: <1311830178-30314-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The <linux/module.h> pretty much brings in the kitchen sink along
with it, so it should be avoided wherever reasonably possible in
terms of being included from other commonly used <linux/something.h>
files, as it results in a measureable increase on compile times.

The worst culprit was probably device.h since it is used everywhere.
This file also had an implicit dependency/usage of mutex.h which was
masked by module.h, and is also fixed here at the same time.

There are over a dozen other headers that simply declare the
struct instead of pulling in the whole file, so follow their lead
and simply make it a few more.

Most of the implicit dependencies on module.h being present by
these headers pulling it in have been now weeded out, so we can
finally make this change with hopefully minimal breakage.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/drm/drmP.h              |    3 ++-
 include/linux/blkdev.h          |    2 +-
 include/linux/cpuidle.h         |    3 ++-
 include/linux/device.h          |    3 ++-
 include/linux/firmware.h        |    2 +-
 include/linux/ftrace.h          |    2 +-
 include/linux/i2c.h             |    3 ++-
 include/linux/ipmi.h            |    3 ++-
 include/linux/ipmi_smi.h        |    1 -
 include/linux/mdio-bitbang.h    |    3 ++-
 include/linux/mtd/mtd.h         |    3 ++-
 include/linux/sunrpc/svc_xprt.h |    3 ++-
 include/linux/textsearch.h      |    3 ++-
 include/linux/uio_driver.h      |    2 +-
 include/linux/vlynq.h           |    3 ++-
 include/media/saa7146.h         |    3 ++-
 include/media/v4l2-int-device.h |    3 ++-
 include/net/lib80211.h          |    3 ++-
 include/net/sock.h              |    2 +-
 include/sound/core.h            |    2 +-
 include/trace/define_trace.h    |    2 +-
 include/trace/events/module.h   |    2 +-
 22 files changed, 34 insertions(+), 22 deletions(-)

diff --git a/include/drm/drmP.h b/include/drm/drmP.h
index 9b7c2bb..7e447f8 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -42,7 +42,6 @@
  * can build the DRM (part of PI DRI). 4/21/2000 S + B */
 #include <asm/current.h>
 #endif				/* __alpha__ */
-#include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/miscdevice.h>
 #include <linux/fs.h>
@@ -80,6 +79,8 @@
 #define __OS_HAS_AGP (defined(CONFIG_AGP) || (defined(CONFIG_AGP_MODULE) && defined(MODULE)))
 #define __OS_HAS_MTRR (defined(CONFIG_MTRR))
 
+struct module;
+
 struct drm_file;
 struct drm_device;
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 0e67c45..0e484b9 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -14,7 +14,6 @@
 #include <linux/wait.h>
 #include <linux/mempool.h>
 #include <linux/bio.h>
-#include <linux/module.h>
 #include <linux/stringify.h>
 #include <linux/gfp.h>
 #include <linux/bsg.h>
@@ -22,6 +21,7 @@
 
 #include <asm/scatterlist.h>
 
+struct module;
 struct scsi_ioctl_command;
 
 struct request_queue;
diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
index 36719ea..4263b02 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -13,7 +13,6 @@
 
 #include <linux/percpu.h>
 #include <linux/list.h>
-#include <linux/module.h>
 #include <linux/kobject.h>
 #include <linux/completion.h>
 
@@ -21,6 +20,8 @@
 #define CPUIDLE_NAME_LEN	16
 #define CPUIDLE_DESC_LEN	32
 
+struct module;
+
 struct cpuidle_device;
 
 
diff --git a/include/linux/device.h b/include/linux/device.h
index 2ee926c..00b3588 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -20,7 +20,7 @@
 #include <linux/lockdep.h>
 #include <linux/compiler.h>
 #include <linux/types.h>
-#include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/pm.h>
 #include <linux/atomic.h>
 #include <asm/device.h>
@@ -29,6 +29,7 @@ struct device;
 struct device_private;
 struct device_driver;
 struct driver_private;
+struct module;
 struct class;
 struct subsys_private;
 struct bus_type;
diff --git a/include/linux/firmware.h b/include/linux/firmware.h
index 21b3e75..1e7c011 100644
--- a/include/linux/firmware.h
+++ b/include/linux/firmware.h
@@ -1,7 +1,6 @@
 #ifndef _LINUX_FIRMWARE_H
 #define _LINUX_FIRMWARE_H
 
-#include <linux/module.h>
 #include <linux/types.h>
 #include <linux/compiler.h>
 #include <linux/gfp.h>
@@ -15,6 +14,7 @@ struct firmware {
 	struct page **pages;
 };
 
+struct module;
 struct device;
 
 struct builtin_fw {
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index f0c0e8a..26eafce 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -10,7 +10,6 @@
 #include <linux/kallsyms.h>
 #include <linux/linkage.h>
 #include <linux/bitops.h>
-#include <linux/module.h>
 #include <linux/ktime.h>
 #include <linux/sched.h>
 #include <linux/types.h>
@@ -19,6 +18,7 @@
 
 #include <asm/ftrace.h>
 
+struct module;
 struct ftrace_hash;
 
 #ifdef CONFIG_FUNCTION_TRACER
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index ce472e3..3fad485 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -28,7 +28,6 @@
 
 #include <linux/types.h>
 #ifdef __KERNEL__
-#include <linux/module.h>
 #include <linux/mod_devicetable.h>
 #include <linux/device.h>	/* for struct device */
 #include <linux/sched.h>	/* for completion */
@@ -48,6 +47,8 @@ struct i2c_driver;
 union i2c_smbus_data;
 struct i2c_board_info;
 
+struct module;
+
 #if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
 /*
  * The master routines are the ones normally used to transmit data to devices
diff --git a/include/linux/ipmi.h b/include/linux/ipmi.h
index ca85cf8..bbd156b 100644
--- a/include/linux/ipmi.h
+++ b/include/linux/ipmi.h
@@ -220,10 +220,11 @@ struct kernel_ipmi_msg {
  * The in-kernel interface.
  */
 #include <linux/list.h>
-#include <linux/module.h>
 #include <linux/device.h>
 #include <linux/proc_fs.h>
 
+struct module;
+
 /* Opaque type for a IPMI message user.  One of these is needed to
    send and receive messages. */
 typedef struct ipmi_user *ipmi_user_t;
diff --git a/include/linux/ipmi_smi.h b/include/linux/ipmi_smi.h
index 204f9cd..3ef0d8b 100644
--- a/include/linux/ipmi_smi.h
+++ b/include/linux/ipmi_smi.h
@@ -36,7 +36,6 @@
 
 #include <linux/ipmi_msgdefs.h>
 #include <linux/proc_fs.h>
-#include <linux/module.h>
 #include <linux/device.h>
 #include <linux/platform_device.h>
 #include <linux/ipmi.h>
diff --git a/include/linux/mdio-bitbang.h b/include/linux/mdio-bitbang.h
index 8ea9a42..0fe00cd 100644
--- a/include/linux/mdio-bitbang.h
+++ b/include/linux/mdio-bitbang.h
@@ -2,7 +2,8 @@
 #define __LINUX_MDIO_BITBANG_H
 
 #include <linux/phy.h>
-#include <linux/module.h>
+
+struct module;
 
 struct mdiobb_ctrl;
 
diff --git a/include/linux/mtd/mtd.h b/include/linux/mtd/mtd.h
index 2541fb8..af31170 100644
--- a/include/linux/mtd/mtd.h
+++ b/include/linux/mtd/mtd.h
@@ -21,7 +21,6 @@
 #define __MTD_MTD_H__
 
 #include <linux/types.h>
-#include <linux/module.h>
 #include <linux/uio.h>
 #include <linux/notifier.h>
 #include <linux/device.h>
@@ -41,6 +40,8 @@
 
 #define MTD_FAIL_ADDR_UNKNOWN -1LL
 
+struct module;
+
 /* If the erase fails, fail_addr might indicate exactly which block failed.  If
    fail_addr = MTD_FAIL_ADDR_UNKNOWN, the failure was not at the device level or was not
    specific to any particular block. */
diff --git a/include/linux/sunrpc/svc_xprt.h b/include/linux/sunrpc/svc_xprt.h
index 7ad9751..8620f79 100644
--- a/include/linux/sunrpc/svc_xprt.h
+++ b/include/linux/sunrpc/svc_xprt.h
@@ -8,7 +8,8 @@
 #define SUNRPC_SVC_XPRT_H
 
 #include <linux/sunrpc/svc.h>
-#include <linux/module.h>
+
+struct module;
 
 struct svc_xprt_ops {
 	struct svc_xprt	*(*xpo_create)(struct svc_serv *,
diff --git a/include/linux/textsearch.h b/include/linux/textsearch.h
index d9a85d6..cfaee86 100644
--- a/include/linux/textsearch.h
+++ b/include/linux/textsearch.h
@@ -4,10 +4,11 @@
 #include <linux/types.h>
 #include <linux/list.h>
 #include <linux/kernel.h>
-#include <linux/module.h>
 #include <linux/err.h>
 #include <linux/slab.h>
 
+struct module;
+
 struct ts_config;
 
 #define TS_AUTOLOAD	1 /* Automatically load textsearch modules when needed */
diff --git a/include/linux/uio_driver.h b/include/linux/uio_driver.h
index 04cdc47..e01c233 100644
--- a/include/linux/uio_driver.h
+++ b/include/linux/uio_driver.h
@@ -14,10 +14,10 @@
 #ifndef _UIO_DRIVER_H_
 #define _UIO_DRIVER_H_
 
-#include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/interrupt.h>
 
+struct module;
 struct uio_map;
 
 /**
diff --git a/include/linux/vlynq.h b/include/linux/vlynq.h
index 8f6a958..017d4a5 100644
--- a/include/linux/vlynq.h
+++ b/include/linux/vlynq.h
@@ -20,9 +20,10 @@
 #define __VLYNQ_H__
 
 #include <linux/device.h>
-#include <linux/module.h>
 #include <linux/types.h>
 
+struct module;
+
 #define VLYNQ_NUM_IRQS 32
 
 struct vlynq_mapping {
diff --git a/include/media/saa7146.h b/include/media/saa7146.h
index 7982714..6e84cde 100644
--- a/include/media/saa7146.h
+++ b/include/media/saa7146.h
@@ -1,7 +1,6 @@
 #ifndef __SAA7146__
 #define __SAA7146__
 
-#include <linux/module.h>	/* for module-version */
 #include <linux/delay.h>	/* for delay-stuff */
 #include <linux/slab.h>		/* for kmalloc/kfree */
 #include <linux/pci.h>		/* for pci-config-stuff, vendor ids etc. */
@@ -47,6 +46,8 @@ extern unsigned int saa7146_debug;
 #define SAA7146_ISR_CLEAR(x,y) \
 	saa7146_write(x, ISR, (y));
 
+struct module;
+
 struct saa7146_dev;
 struct saa7146_extension;
 struct saa7146_vv;
diff --git a/include/media/v4l2-int-device.h b/include/media/v4l2-int-device.h
index fbf5855..e6aa231 100644
--- a/include/media/v4l2-int-device.h
+++ b/include/media/v4l2-int-device.h
@@ -25,7 +25,6 @@
 #ifndef V4L2_INT_DEVICE_H
 #define V4L2_INT_DEVICE_H
 
-#include <linux/module.h>
 #include <media/v4l2-common.h>
 
 #define V4L2NAMESIZE 32
@@ -41,6 +40,8 @@ enum v4l2_int_type {
 	v4l2_int_type_slave
 };
 
+struct module;
+
 struct v4l2_int_device;
 
 struct v4l2_int_master {
diff --git a/include/net/lib80211.h b/include/net/lib80211.h
index b95bbb0..4e57543 100644
--- a/include/net/lib80211.h
+++ b/include/net/lib80211.h
@@ -25,7 +25,6 @@
 
 #include <linux/types.h>
 #include <linux/list.h>
-#include <linux/module.h>
 #include <linux/atomic.h>
 #include <linux/if.h>
 #include <linux/skbuff.h>
@@ -42,6 +41,8 @@ enum {
 	IEEE80211_CRYPTO_TKIP_COUNTERMEASURES = (1 << 0),
 };
 
+struct module;
+
 struct lib80211_crypto_ops {
 	const char *name;
 	struct list_head list;
diff --git a/include/net/sock.h b/include/net/sock.h
index 8e4062f..4aa706c 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -46,7 +46,6 @@
 #include <linux/list_nulls.h>
 #include <linux/timer.h>
 #include <linux/cache.h>
-#include <linux/module.h>
 #include <linux/lockdep.h>
 #include <linux/netdevice.h>
 #include <linux/skbuff.h>	/* struct sk_buff */
@@ -720,6 +719,7 @@ struct request_sock_ops;
 struct timewait_sock_ops;
 struct inet_hashinfo;
 struct raw_hashinfo;
+struct module;
 
 /* Networking protocol blocks we attach to sockets.
  * socket layer -> transport layer interface
diff --git a/include/sound/core.h b/include/sound/core.h
index 1fa2407..a91d78e 100644
--- a/include/sound/core.h
+++ b/include/sound/core.h
@@ -22,7 +22,6 @@
  *
  */
 
-#include <linux/module.h>
 #include <linux/sched.h>		/* wake_up() */
 #include <linux/mutex.h>		/* struct mutex */
 #include <linux/rwsem.h>		/* struct rw_semaphore */
@@ -43,6 +42,7 @@
 #ifdef CONFIG_PCI
 struct pci_dev;
 #endif
+struct module;
 
 /* device allocation stuff */
 
diff --git a/include/trace/define_trace.h b/include/trace/define_trace.h
index da39b22..4fd1de1 100644
--- a/include/trace/define_trace.h
+++ b/include/trace/define_trace.h
@@ -23,7 +23,7 @@
 #include <linux/stringify.h>
 /*
  * module.h includes tracepoints, and because ftrace.h
- * pulls in module.h:
+ * used to pull in module.h via this path:
  *  trace/ftrace.h -> linux/ftrace_event.h -> linux/perf_event.h ->
  *  linux/ftrace.h -> linux/module.h
  * we must include module.h here before we play with any of
diff --git a/include/trace/events/module.h b/include/trace/events/module.h
index 21a546d..1619327 100644
--- a/include/trace/events/module.h
+++ b/include/trace/events/module.h
@@ -1,6 +1,6 @@
 /*
  * Because linux/module.h has tracepoints in the header, and ftrace.h
- * eventually includes this file, define_trace.h includes linux/module.h
+ * used to include this file, define_trace.h includes linux/module.h
  * But we do not want the module.h to override the TRACE_SYSTEM macro
  * variable that define_trace.h is processing, so we only set it
  * when module events are being processed, which would happen when
-- 
1.7.6


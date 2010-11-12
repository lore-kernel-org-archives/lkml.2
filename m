Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122Ab0KLNax (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 08:30:53 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:62667 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069Ab0KLNau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 08:30:50 -0500
Date: Fri, 12 Nov 2010 14:29:29 +0100
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCH 2/2] usb: gadget: f_fs: remove custom printk() wrappers
In-reply-to: <6516fbf233ddd5a134dc2852ce3128dda3c81ef7.1289566508.git.mina86@mina86.com>
To: greg@kroah.com
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Nazarewicz <mina86@mina86.com>
Message-id: <43c182ffa9b0cf2722ff2b17204b92a5fce41a1d.1289566508.git.mina86@mina86.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.2.3
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <6516fbf233ddd5a134dc2852ce3128dda3c81ef7.1289566508.git.mina86@mina86.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

This commit removes custom printk() wrappers from the f_fs.c
file.  They served little purpose above what pr_*() family of
macros provides.  Only FVDBG() has been left but renamed to
pr_vdebug() to match other uses.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/usb/gadget/f_fs.c |  108 ++++++++++++++++++++-------------------------
 1 files changed, 48 insertions(+), 60 deletions(-)

diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
index 2880e52..8f5b679 100644
--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -27,6 +27,8 @@
 /* #define DEBUG */
 /* #define VERBOSE_DEBUG */
 
+#define pr_fmt(fmt) "f_fs: " fmt "\n"
+
 #include <linux/blkdev.h>
 #include <linux/pagemap.h>
 #include <asm/unaligned.h>
@@ -41,31 +43,16 @@
 
 /* Debugging ****************************************************************/
 
-#define ffs_printk(level, fmt, args...) printk(level "f_fs: " fmt "\n", ## args)
-
-#define FERR(...)  ffs_printk(KERN_ERR,  __VA_ARGS__)
-#define FINFO(...) ffs_printk(KERN_INFO, __VA_ARGS__)
-
-#ifdef DEBUG
-#  define FDBG(...) ffs_printk(KERN_DEBUG, __VA_ARGS__)
-#else
-#  define FDBG(...) do { } while (0)
-#endif /* DEBUG */
-
-#ifdef VERBOSE_DEBUG
-#  define FVDBG FDBG
-#else
-#  define FVDBG(...) do { } while (0)
-#endif /* VERBOSE_DEBUG */
-
-#define ENTER()    FVDBG("%s()", __func__)
-
 #ifdef VERBOSE_DEBUG
+#  define pr_vdebug pr_debug
 #  define ffs_dump_mem(prefix, ptr, len) \
 	print_hex_dump_bytes("f_fs" prefix ": ", DUMP_PREFIX_NONE, ptr, len)
 #else
+#  define pr_vdebug(...)                 do { } while (0)
 #  define ffs_dump_mem(prefix, ptr, len) do { } while (0)
-#endif
+#endif /* VERBOSE_DEBUG */
+
+#define ENTER()    pr_vdebug("%s()", __func__)
 
 
 /* The data structure and setup file ****************************************/
@@ -403,12 +390,12 @@ static int __ffs_ep0_queue_wait(struct ffs_data *ffs, char *data, size_t len)
 static int __ffs_ep0_stall(struct ffs_data *ffs)
 {
 	if (ffs->ev.can_stall) {
-		FVDBG("ep0 stall\n");
+		pr_vdebug("ep0 stall");
 		usb_ep_set_halt(ffs->gadget->ep0);
 		ffs->setup_state = FFS_NO_SETUP;
 		return -EL2HLT;
 	} else {
-		FDBG("bogus ep0 stall!\n");
+		pr_debug("bogus ep0 stall!");
 		return -ESRCH;
 	}
 }
@@ -449,7 +436,7 @@ static ssize_t ffs_ep0_write(struct file *file, const char __user *buf,
 
 		/* Handle data */
 		if (ffs->state == FFS_READ_DESCRIPTORS) {
-			FINFO("read descriptors");
+			pr_info("read descriptors");
 			ret = __ffs_data_got_descs(ffs, data, len);
 			if (unlikely(ret < 0))
 				break;
@@ -457,7 +444,7 @@ static ssize_t ffs_ep0_write(struct file *file, const char __user *buf,
 			ffs->state = FFS_READ_STRINGS;
 			ret = len;
 		} else {
-			FINFO("read strings");
+			pr_info("read strings");
 			ret = __ffs_data_got_strings(ffs, data, len);
 			if (unlikely(ret < 0))
 				break;
@@ -1123,7 +1110,7 @@ static int ffs_fs_parse_opts(struct ffs_sb_fill_data *data, char *opts)
 		/* Value limit */
 		eq = strchr(opts, '=');
 		if (unlikely(!eq)) {
-			FERR("'=' missing in %s", opts);
+			pr_err("'=' missing in %s", opts);
 			return -EINVAL;
 		}
 		*eq = 0;
@@ -1131,7 +1118,7 @@ static int ffs_fs_parse_opts(struct ffs_sb_fill_data *data, char *opts)
 		/* Parse value */
 		value = simple_strtoul(eq + 1, &end, 0);
 		if (unlikely(*end != ',' && *end != 0)) {
-			FERR("%s: invalid value: %s", opts, eq + 1);
+			pr_err("%s: invalid value: %s", opts, eq + 1);
 			return -EINVAL;
 		}
 
@@ -1166,7 +1153,7 @@ static int ffs_fs_parse_opts(struct ffs_sb_fill_data *data, char *opts)
 
 		default:
 invalid:
-			FERR("%s: invalid option", opts);
+			pr_err("%s: invalid option", opts);
 			return -EINVAL;
 		}
 
@@ -1240,9 +1227,9 @@ static int functionfs_init(void)
 
 	ret = register_filesystem(&ffs_fs_type);
 	if (likely(!ret))
-		FINFO("file system registered");
+		pr_info("file system registered");
 	else
-		FERR("failed registering file system (%d)", ret);
+		pr_err("failed registering file system (%d)", ret);
 
 	return ret;
 }
@@ -1251,7 +1238,7 @@ static void functionfs_cleanup(void)
 {
 	ENTER();
 
-	FINFO("unloading");
+	pr_info("unloading");
 	unregister_filesystem(&ffs_fs_type);
 }
 
@@ -1281,7 +1268,7 @@ static void ffs_data_put(struct ffs_data *ffs)
 	ENTER();
 
 	if (unlikely(atomic_dec_and_test(&ffs->ref))) {
-		FINFO("%s(): freeing", __func__);
+		pr_info("%s(): freeing", __func__);
 		ffs_data_clear(ffs);
 		BUG_ON(mutex_is_locked(&ffs->mutex) ||
 		       spin_is_locked(&ffs->ev.waitq.lock) ||
@@ -1601,14 +1588,14 @@ static int __must_check ffs_do_desc(char *data, unsigned len,
 
 	/* At least two bytes are required: length and type */
 	if (len < 2) {
-		FVDBG("descriptor too short");
+		pr_vdebug("descriptor too short");
 		return -EINVAL;
 	}
 
 	/* If we have at least as many bytes as the descriptor takes? */
 	length = _ds->bLength;
 	if (len < length) {
-		FVDBG("descriptor longer then available data");
+		pr_vdebug("descriptor longer then available data");
 		return -EINVAL;
 	}
 
@@ -1616,15 +1603,15 @@ static int __must_check ffs_do_desc(char *data, unsigned len,
 #define __entity_check_STRING(val)     (val)
 #define __entity_check_ENDPOINT(val)   ((val) & USB_ENDPOINT_NUMBER_MASK)
 #define __entity(type, val) do {					\
-		FVDBG("entity " #type "(%02x)", (val));			\
+		pr_vdebug("entity " #type "(%02x)", (val));		\
 		if (unlikely(!__entity_check_ ##type(val))) {		\
-			FVDBG("invalid entity's value");		\
+			pr_vdebug("invalid entity's value");		\
 			return -EINVAL;					\
 		}							\
 		ret = entity(FFS_ ##type, &val, _ds, priv);		\
 		if (unlikely(ret < 0)) {				\
-			FDBG("entity " #type "(%02x); ret = %d",	\
-			     (val), ret);				\
+			pr_debug("entity " #type "(%02x); ret = %d",	\
+				 (val), ret);				\
 			return ret;					\
 		}							\
 	} while (0)
@@ -1636,13 +1623,13 @@ static int __must_check ffs_do_desc(char *data, unsigned len,
 	case USB_DT_STRING:
 	case USB_DT_DEVICE_QUALIFIER:
 		/* function can't have any of those */
-		FVDBG("descriptor reserved for gadget: %d",
+		pr_vdebug("descriptor reserved for gadget: %d",
 		      _ds->bDescriptorType);
 		return -EINVAL;
 
 	case USB_DT_INTERFACE: {
 		struct usb_interface_descriptor *ds = (void *)_ds;
-		FVDBG("interface descriptor");
+		pr_vdebug("interface descriptor");
 		if (length != sizeof *ds)
 			goto inv_length;
 
@@ -1654,7 +1641,7 @@ static int __must_check ffs_do_desc(char *data, unsigned len,
 
 	case USB_DT_ENDPOINT: {
 		struct usb_endpoint_descriptor *ds = (void *)_ds;
-		FVDBG("endpoint descriptor");
+		pr_vdebug("endpoint descriptor");
 		if (length != USB_DT_ENDPOINT_SIZE &&
 		    length != USB_DT_ENDPOINT_AUDIO_SIZE)
 			goto inv_length;
@@ -1669,7 +1656,7 @@ static int __must_check ffs_do_desc(char *data, unsigned len,
 
 	case USB_DT_INTERFACE_ASSOCIATION: {
 		struct usb_interface_assoc_descriptor *ds = (void *)_ds;
-		FVDBG("interface association descriptor");
+		pr_vdebug("interface association descriptor");
 		if (length != sizeof *ds)
 			goto inv_length;
 		if (ds->iFunction)
@@ -1683,17 +1670,17 @@ static int __must_check ffs_do_desc(char *data, unsigned len,
 	case USB_DT_SECURITY:
 	case USB_DT_CS_RADIO_CONTROL:
 		/* TODO */
-		FVDBG("unimplemented descriptor: %d", _ds->bDescriptorType);
+		pr_vdebug("unimplemented descriptor: %d", _ds->bDescriptorType);
 		return -EINVAL;
 
 	default:
 		/* We should never be here */
-		FVDBG("unknown descriptor: %d", _ds->bDescriptorType);
+		pr_vdebug("unknown descriptor: %d", _ds->bDescriptorType);
 		return -EINVAL;
 
 inv_length:
-		FVDBG("invalid length: %d (descriptor %d)",
-		      _ds->bLength, _ds->bDescriptorType);
+		pr_vdebug("invalid length: %d (descriptor %d)",
+			  _ds->bLength, _ds->bDescriptorType);
 		return -EINVAL;
 	}
 
@@ -1723,7 +1710,8 @@ static int __must_check ffs_do_descs(unsigned count, char *data, unsigned len,
 		/* Record "descriptor" entity */
 		ret = entity(FFS_DESCRIPTOR, (u8 *)num, (void *)data, priv);
 		if (unlikely(ret < 0)) {
-			FDBG("entity DESCRIPTOR(%02lx); ret = %d", num, ret);
+			pr_debug("entity DESCRIPTOR(%02lx); ret = %d",
+				 num, ret);
 			return ret;
 		}
 
@@ -1732,7 +1720,7 @@ static int __must_check ffs_do_descs(unsigned count, char *data, unsigned len,
 
 		ret = ffs_do_desc(data, len, entity, priv);
 		if (unlikely(ret < 0)) {
-			FDBG("%s returns %d", __func__, ret);
+			pr_debug("%s returns %d", __func__, ret);
 			return ret;
 		}
 
@@ -2025,11 +2013,11 @@ static void __ffs_event_add(struct ffs_data *ffs,
 			if ((*ev == rem_type1 || *ev == rem_type2) == neg)
 				*out++ = *ev;
 			else
-				FVDBG("purging event %d", *ev);
+				pr_vdebug("purging event %d", *ev);
 		ffs->ev.count = out - ffs->ev.types;
 	}
 
-	FVDBG("adding event %d", type);
+	pr_vdebug("adding event %d", type);
 	ffs->ev.types[ffs->ev.count++] = type;
 	wake_up_locked(&ffs->ev.waitq);
 }
@@ -2076,9 +2064,9 @@ static int __ffs_func_bind_do_descs(enum ffs_entity_type type, u8 *valuep,
 	ffs_ep = func->eps + idx;
 
 	if (unlikely(ffs_ep->descs[isHS])) {
-		FVDBG("two %sspeed descriptors for EP %d",
-		      isHS ? "high" : "full",
-		      ds->bEndpointAddress & USB_ENDPOINT_NUMBER_MASK);
+		pr_vdebug("two %sspeed descriptors for EP %d",
+			  isHS ? "high" : "full",
+			  ds->bEndpointAddress & USB_ENDPOINT_NUMBER_MASK);
 		return -EINVAL;
 	}
 	ffs_ep->descs[isHS] = ds;
@@ -2092,7 +2080,7 @@ static int __ffs_func_bind_do_descs(enum ffs_entity_type type, u8 *valuep,
 		struct usb_request *req;
 		struct usb_ep *ep;
 
-		FVDBG("autoconfig");
+		pr_vdebug("autoconfig");
 		ep = usb_ep_autoconfig(func->gadget, ds);
 		if (unlikely(!ep))
 			return -ENOTSUPP;
@@ -2162,7 +2150,7 @@ static int __ffs_func_bind_do_nums(enum ffs_entity_type type, u8 *valuep,
 		break;
 	}
 
-	FVDBG("%02x -> %02x", *valuep, newValue);
+	pr_vdebug("%02x -> %02x", *valuep, newValue);
 	*valuep = newValue;
 	return 0;
 }
@@ -2327,11 +2315,11 @@ static int ffs_func_setup(struct usb_function *f,
 
 	ENTER();
 
-	FVDBG("creq->bRequestType = %02x", creq->bRequestType);
-	FVDBG("creq->bRequest     = %02x", creq->bRequest);
-	FVDBG("creq->wValue       = %04x", le16_to_cpu(creq->wValue));
-	FVDBG("creq->wIndex       = %04x", le16_to_cpu(creq->wIndex));
-	FVDBG("creq->wLength      = %04x", le16_to_cpu(creq->wLength));
+	pr_vdebug("creq->bRequestType = %02x", creq->bRequestType);
+	pr_vdebug("creq->bRequest     = %02x", creq->bRequest);
+	pr_vdebug("creq->wValue       = %04x", le16_to_cpu(creq->wValue));
+	pr_vdebug("creq->wIndex       = %04x", le16_to_cpu(creq->wIndex));
+	pr_vdebug("creq->wLength      = %04x", le16_to_cpu(creq->wLength));
 
 	/*
 	 * Most requests directed to interface go through here
@@ -2431,7 +2419,7 @@ static char *ffs_prepare_buffer(const char * __user buf, size_t len)
 		return ERR_PTR(-EFAULT);
 	}
 
-	FVDBG("Buffer from user space:");
+	pr_vdebug("Buffer from user space:");
 	ffs_dump_mem("", data, len);
 
 	return data;
-- 
1.7.2.3


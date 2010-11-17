Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933420Ab0KQQKE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 11:10:04 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58408 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934741Ab0KQQKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 11:10:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=XkNFCoQR9ul1bNbx5/L0a7jxHRhqkdu94BzkHiB+0MVid+DQ8ipFhHZqF7UvjOIOKu
         ZOTh7WjZpKwI8esGwkBMgDgk560w4AszxnMf69x/+t5zk8Gjhs6yKTqyK5LFBWBgOteH
         0apV92XMXf2A63Fen2pkmQxS/ObLa48mX4fo0=
From: Michal Nazarewicz <mina86@mina86.com>
To: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-usb@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Nazarewicz <mina86@mina86.com>
Subject: [PATCH] usb: gadget: g_fs: Fix compilation warning
Date: Wed, 17 Nov 2010 17:09:47 +0100
Message-Id: <0c1bd123752a7adc7f034ef81d155903da115081.1290007778.git.mina86@mina86.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101116215906.GA2869@kroah.com>
References: <20101117131427.fd26efd8.sfr@canb.auug.org.au> <20101116215906.GA2869@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit fixes warning in f_fs.c introduced by "usb:
gadget: f_fs: remove custom printk() wrappers":

In file included from drivers/usb/gadget/g_ffs.c:64:
drivers/usb/gadget/f_fs.c:30:1: warning: "pr_fmt" redefined

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/usb/gadget/f_fs.c  |   78 +++++++++++++++++++++----------------------
 drivers/usb/gadget/g_ffs.c |    2 +
 2 files changed, 40 insertions(+), 40 deletions(-)

> On Fri, Nov 12, 2010 at 02:29:29PM +0100, Michal Nazarewicz wrote:
>> diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
>> @@ -27,6 +27,8 @@
>>  /* #define DEBUG */
>>  /* #define VERBOSE_DEBUG */
>>  
>> +#define pr_fmt(fmt) "f_fs: " fmt "\n"

Greg KH <greg@kroah.com> writes:
> Hm, this causes a compiler warning.  Care to fix this up with a
> follow-up patch as this isn't the way to do this...

Sorry about that.  Fix included.

diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
index 5950c4b..255969c 100644
--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -27,8 +27,6 @@
 /* #define DEBUG */
 /* #define VERBOSE_DEBUG */
 
-#define pr_fmt(fmt) "f_fs: " fmt "\n"
-
 #include <linux/blkdev.h>
 #include <linux/pagemap.h>
 #include <asm/unaligned.h>
@@ -46,13 +44,13 @@
 #ifdef VERBOSE_DEBUG
 #  define pr_vdebug pr_debug
 #  define ffs_dump_mem(prefix, ptr, len) \
-	print_hex_dump_bytes("f_fs" prefix ": ", DUMP_PREFIX_NONE, ptr, len)
+	print_hex_dump_bytes(pr_fmt(prefix ": "), DUMP_PREFIX_NONE, ptr, len)
 #else
 #  define pr_vdebug(...)                 do { } while (0)
 #  define ffs_dump_mem(prefix, ptr, len) do { } while (0)
 #endif /* VERBOSE_DEBUG */
 
-#define ENTER()    pr_vdebug("%s()", __func__)
+#define ENTER()    pr_vdebug("%s()\n", __func__)
 
 
 /* The data structure and setup file ****************************************/
@@ -390,12 +388,12 @@ static int __ffs_ep0_queue_wait(struct ffs_data *ffs, char *data, size_t len)
 static int __ffs_ep0_stall(struct ffs_data *ffs)
 {
 	if (ffs->ev.can_stall) {
-		pr_vdebug("ep0 stall");
+		pr_vdebug("ep0 stall\n");
 		usb_ep_set_halt(ffs->gadget->ep0);
 		ffs->setup_state = FFS_NO_SETUP;
 		return -EL2HLT;
 	} else {
-		pr_debug("bogus ep0 stall!");
+		pr_debug("bogus ep0 stall!\n");
 		return -ESRCH;
 	}
 }
@@ -436,7 +434,7 @@ static ssize_t ffs_ep0_write(struct file *file, const char __user *buf,
 
 		/* Handle data */
 		if (ffs->state == FFS_READ_DESCRIPTORS) {
-			pr_info("read descriptors");
+			pr_info("read descriptors\n");
 			ret = __ffs_data_got_descs(ffs, data, len);
 			if (unlikely(ret < 0))
 				break;
@@ -444,7 +442,7 @@ static ssize_t ffs_ep0_write(struct file *file, const char __user *buf,
 			ffs->state = FFS_READ_STRINGS;
 			ret = len;
 		} else {
-			pr_info("read strings");
+			pr_info("read strings\n");
 			ret = __ffs_data_got_strings(ffs, data, len);
 			if (unlikely(ret < 0))
 				break;
@@ -1110,7 +1108,7 @@ static int ffs_fs_parse_opts(struct ffs_sb_fill_data *data, char *opts)
 		/* Value limit */
 		eq = strchr(opts, '=');
 		if (unlikely(!eq)) {
-			pr_err("'=' missing in %s", opts);
+			pr_err("'=' missing in %s\n", opts);
 			return -EINVAL;
 		}
 		*eq = 0;
@@ -1118,7 +1116,7 @@ static int ffs_fs_parse_opts(struct ffs_sb_fill_data *data, char *opts)
 		/* Parse value */
 		value = simple_strtoul(eq + 1, &end, 0);
 		if (unlikely(*end != ',' && *end != 0)) {
-			pr_err("%s: invalid value: %s", opts, eq + 1);
+			pr_err("%s: invalid value: %s\n", opts, eq + 1);
 			return -EINVAL;
 		}
 
@@ -1153,7 +1151,7 @@ static int ffs_fs_parse_opts(struct ffs_sb_fill_data *data, char *opts)
 
 		default:
 invalid:
-			pr_err("%s: invalid option", opts);
+			pr_err("%s: invalid option\n", opts);
 			return -EINVAL;
 		}
 
@@ -1227,9 +1225,9 @@ static int functionfs_init(void)
 
 	ret = register_filesystem(&ffs_fs_type);
 	if (likely(!ret))
-		pr_info("file system registered");
+		pr_info("file system registered\n");
 	else
-		pr_err("failed registering file system (%d)", ret);
+		pr_err("failed registering file system (%d)\n", ret);
 
 	return ret;
 }
@@ -1238,7 +1236,7 @@ static void functionfs_cleanup(void)
 {
 	ENTER();
 
-	pr_info("unloading");
+	pr_info("unloading\n");
 	unregister_filesystem(&ffs_fs_type);
 }
 
@@ -1268,7 +1266,7 @@ static void ffs_data_put(struct ffs_data *ffs)
 	ENTER();
 
 	if (unlikely(atomic_dec_and_test(&ffs->ref))) {
-		pr_info("%s(): freeing", __func__);
+		pr_info("%s(): freeing\n", __func__);
 		ffs_data_clear(ffs);
 		BUG_ON(mutex_is_locked(&ffs->mutex) ||
 		       spin_is_locked(&ffs->ev.waitq.lock) ||
@@ -1588,14 +1586,14 @@ static int __must_check ffs_do_desc(char *data, unsigned len,
 
 	/* At least two bytes are required: length and type */
 	if (len < 2) {
-		pr_vdebug("descriptor too short");
+		pr_vdebug("descriptor too short\n");
 		return -EINVAL;
 	}
 
 	/* If we have at least as many bytes as the descriptor takes? */
 	length = _ds->bLength;
 	if (len < length) {
-		pr_vdebug("descriptor longer then available data");
+		pr_vdebug("descriptor longer then available data\n");
 		return -EINVAL;
 	}
 
@@ -1603,14 +1601,14 @@ static int __must_check ffs_do_desc(char *data, unsigned len,
 #define __entity_check_STRING(val)     (val)
 #define __entity_check_ENDPOINT(val)   ((val) & USB_ENDPOINT_NUMBER_MASK)
 #define __entity(type, val) do {					\
-		pr_vdebug("entity " #type "(%02x)", (val));		\
+		pr_vdebug("entity " #type "(%02x)\n", (val));		\
 		if (unlikely(!__entity_check_ ##type(val))) {		\
-			pr_vdebug("invalid entity's value");		\
+			pr_vdebug("invalid entity's value\n");		\
 			return -EINVAL;					\
 		}							\
 		ret = entity(FFS_ ##type, &val, _ds, priv);		\
 		if (unlikely(ret < 0)) {				\
-			pr_debug("entity " #type "(%02x); ret = %d",	\
+			pr_debug("entity " #type "(%02x); ret = %d\n",	\
 				 (val), ret);				\
 			return ret;					\
 		}							\
@@ -1623,13 +1621,13 @@ static int __must_check ffs_do_desc(char *data, unsigned len,
 	case USB_DT_STRING:
 	case USB_DT_DEVICE_QUALIFIER:
 		/* function can't have any of those */
-		pr_vdebug("descriptor reserved for gadget: %d",
+		pr_vdebug("descriptor reserved for gadget: %d\n",
 		      _ds->bDescriptorType);
 		return -EINVAL;
 
 	case USB_DT_INTERFACE: {
 		struct usb_interface_descriptor *ds = (void *)_ds;
-		pr_vdebug("interface descriptor");
+		pr_vdebug("interface descriptor\n");
 		if (length != sizeof *ds)
 			goto inv_length;
 
@@ -1641,7 +1639,7 @@ static int __must_check ffs_do_desc(char *data, unsigned len,
 
 	case USB_DT_ENDPOINT: {
 		struct usb_endpoint_descriptor *ds = (void *)_ds;
-		pr_vdebug("endpoint descriptor");
+		pr_vdebug("endpoint descriptor\n");
 		if (length != USB_DT_ENDPOINT_SIZE &&
 		    length != USB_DT_ENDPOINT_AUDIO_SIZE)
 			goto inv_length;
@@ -1656,7 +1654,7 @@ static int __must_check ffs_do_desc(char *data, unsigned len,
 
 	case USB_DT_INTERFACE_ASSOCIATION: {
 		struct usb_interface_assoc_descriptor *ds = (void *)_ds;
-		pr_vdebug("interface association descriptor");
+		pr_vdebug("interface association descriptor\n");
 		if (length != sizeof *ds)
 			goto inv_length;
 		if (ds->iFunction)
@@ -1670,16 +1668,16 @@ static int __must_check ffs_do_desc(char *data, unsigned len,
 	case USB_DT_SECURITY:
 	case USB_DT_CS_RADIO_CONTROL:
 		/* TODO */
-		pr_vdebug("unimplemented descriptor: %d", _ds->bDescriptorType);
+		pr_vdebug("unimplemented descriptor: %d\n", _ds->bDescriptorType);
 		return -EINVAL;
 
 	default:
 		/* We should never be here */
-		pr_vdebug("unknown descriptor: %d", _ds->bDescriptorType);
+		pr_vdebug("unknown descriptor: %d\n", _ds->bDescriptorType);
 		return -EINVAL;
 
 inv_length:
-		pr_vdebug("invalid length: %d (descriptor %d)",
+		pr_vdebug("invalid length: %d (descriptor %d)\n",
 			  _ds->bLength, _ds->bDescriptorType);
 		return -EINVAL;
 	}
@@ -1710,7 +1708,7 @@ static int __must_check ffs_do_descs(unsigned count, char *data, unsigned len,
 		/* Record "descriptor" entity */
 		ret = entity(FFS_DESCRIPTOR, (u8 *)num, (void *)data, priv);
 		if (unlikely(ret < 0)) {
-			pr_debug("entity DESCRIPTOR(%02lx); ret = %d",
+			pr_debug("entity DESCRIPTOR(%02lx); ret = %d\n",
 				 num, ret);
 			return ret;
 		}
@@ -1720,7 +1718,7 @@ static int __must_check ffs_do_descs(unsigned count, char *data, unsigned len,
 
 		ret = ffs_do_desc(data, len, entity, priv);
 		if (unlikely(ret < 0)) {
-			pr_debug("%s returns %d", __func__, ret);
+			pr_debug("%s returns %d\n", __func__, ret);
 			return ret;
 		}
 
@@ -2013,11 +2011,11 @@ static void __ffs_event_add(struct ffs_data *ffs,
 			if ((*ev == rem_type1 || *ev == rem_type2) == neg)
 				*out++ = *ev;
 			else
-				pr_vdebug("purging event %d", *ev);
+				pr_vdebug("purging event %d\n", *ev);
 		ffs->ev.count = out - ffs->ev.types;
 	}
 
-	pr_vdebug("adding event %d", type);
+	pr_vdebug("adding event %d\n", type);
 	ffs->ev.types[ffs->ev.count++] = type;
 	wake_up_locked(&ffs->ev.waitq);
 }
@@ -2064,7 +2062,7 @@ static int __ffs_func_bind_do_descs(enum ffs_entity_type type, u8 *valuep,
 	ffs_ep = func->eps + idx;
 
 	if (unlikely(ffs_ep->descs[isHS])) {
-		pr_vdebug("two %sspeed descriptors for EP %d",
+		pr_vdebug("two %sspeed descriptors for EP %d\n",
 			  isHS ? "high" : "full",
 			  ds->bEndpointAddress & USB_ENDPOINT_NUMBER_MASK);
 		return -EINVAL;
@@ -2080,7 +2078,7 @@ static int __ffs_func_bind_do_descs(enum ffs_entity_type type, u8 *valuep,
 		struct usb_request *req;
 		struct usb_ep *ep;
 
-		pr_vdebug("autoconfig");
+		pr_vdebug("autoconfig\n");
 		ep = usb_ep_autoconfig(func->gadget, ds);
 		if (unlikely(!ep))
 			return -ENOTSUPP;
@@ -2150,7 +2148,7 @@ static int __ffs_func_bind_do_nums(enum ffs_entity_type type, u8 *valuep,
 		break;
 	}
 
-	pr_vdebug("%02x -> %02x", *valuep, newValue);
+	pr_vdebug("%02x -> %02x\n", *valuep, newValue);
 	*valuep = newValue;
 	return 0;
 }
@@ -2315,11 +2313,11 @@ static int ffs_func_setup(struct usb_function *f,
 
 	ENTER();
 
-	pr_vdebug("creq->bRequestType = %02x", creq->bRequestType);
-	pr_vdebug("creq->bRequest     = %02x", creq->bRequest);
-	pr_vdebug("creq->wValue       = %04x", le16_to_cpu(creq->wValue));
-	pr_vdebug("creq->wIndex       = %04x", le16_to_cpu(creq->wIndex));
-	pr_vdebug("creq->wLength      = %04x", le16_to_cpu(creq->wLength));
+	pr_vdebug("creq->bRequestType = %02x\n", creq->bRequestType);
+	pr_vdebug("creq->bRequest     = %02x\n", creq->bRequest);
+	pr_vdebug("creq->wValue       = %04x\n", le16_to_cpu(creq->wValue));
+	pr_vdebug("creq->wIndex       = %04x\n", le16_to_cpu(creq->wIndex));
+	pr_vdebug("creq->wLength      = %04x\n", le16_to_cpu(creq->wLength));
 
 	/*
 	 * Most requests directed to interface go through here
@@ -2419,7 +2417,7 @@ static char *ffs_prepare_buffer(const char * __user buf, size_t len)
 		return ERR_PTR(-EFAULT);
 	}
 
-	pr_vdebug("Buffer from user space:");
+	pr_vdebug("Buffer from user space:\n");
 	ffs_dump_mem("", data, len);
 
 	return data;
diff --git a/drivers/usb/gadget/g_ffs.c b/drivers/usb/gadget/g_ffs.c
index 3dc1989..ebf6970 100644
--- a/drivers/usb/gadget/g_ffs.c
+++ b/drivers/usb/gadget/g_ffs.c
@@ -19,6 +19,8 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
+#define pr_fmt(fmt) "g_ffs: " fmt
+
 #include <linux/module.h>
 #include <linux/utsname.h>
 
-- 
1.7.1


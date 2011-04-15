Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284Ab1DOVe7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 17:34:59 -0400
Received: from mail6.webfaction.com ([74.55.86.74]:46405 "EHLO
	smtp.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757255Ab1DOVe5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 17:34:57 -0400
Subject: [PATCH] extra/1 Allow setting the maximum KBUS message size
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Tony Ibbs <tibs@tonyibbs.co.uk>
In-Reply-To: <DBA665CD-BE12-4DC8-9B3F-4170BED789BD@tonyibbs.co.uk>
Date: Fri, 15 Apr 2011 22:34:53 +0100
Cc: Grant Likely <grant.likely@secretlab.ca>,
        lkml <linux-kernel@vger.kernel.org>,
        Linux-embedded <linux-embedded@vger.kernel.org>,
        Tibs at Kynesim <tibs@kynesim.co.uk>,
        Richard Watts <rrw@kynesim.co.uk>
Content-Transfer-Encoding: 8BIT
Message-Id: <32934D05-E7A7-4A2C-92EF-96A0580F2234@tonyibbs.co.uk>
References: <cover.1300450604.git.tibs@tonyibbs.co.uk> <20110322133640.5d5c88e4@bike.lwn.net> <DBA665CD-BE12-4DC8-9B3F-4170BED789BD@tonyibbs.co.uk>
To: Jonathan Corbet <corbet@lwn.net>
X-Mailer: Apple Mail (2.1082)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 22 Mar 2011, at 19:36, Jonathan Corbet wrote:

> - Does anything bound the size of a message fed into the kernel with
>  write()?  I couldn't find it.  It seems like an application could
>  consume arbitrary amounts of kernel memory.

This patch provides mechanisms for setting an absolute maximum message
size at compile time, and a per-device maximum at runtime.

The patch is relative to the results of the previous set of patches - I
assume this is better than resubmitting all of them for what is a
relatively small change.

> - It would be good to use the kernel's dynamic debugging and tracing
>  facilities rather than rolling your own.
>
> - There's lots of kmalloc()/memset() pairs that could be kzalloc().

I shall address these next, although I'm afraid it may be a few days.
Thanks, by the way, for the timely LWN article on the dynamic debugging
interface.

Signed-off-by: Tony Ibbs <tibs@tonyibbs.co.uk>
---
 Documentation/Kbus.txt     |   15 ++++++++++-
 include/linux/kbus_defns.h |   14 ++++++++++-
 ipc/Kconfig                |   32 ++++++++++++++++++++++++-
 ipc/kbus_internal.h        |   11 ++++++++
 ipc/kbus_main.c            |   57 ++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 126 insertions(+), 3 deletions(-)

diff --git a/Documentation/Kbus.txt b/Documentation/Kbus.txt
index 7cf723fd6..16828b9 100644
--- a/Documentation/Kbus.txt
+++ b/Documentation/Kbus.txt
@@ -1058,6 +1058,18 @@ header file (``kbus_defns.h``). They are:
                 Both Python and C bindings provide a useful function to
                 extract the ``is_bind``, ``binder`` and ``name`` values from
                 the data.
+:MAXMSGSIZE:    Set the maximum size of a KBUS message for this KBUS device,
+                and return the value that is set. This is the size of the
+                largest message that may be written to a KBUS Ksock. Trying
+                to write a longer message will result in an -EMSGSIZE error.
+                An attempt to set this value of 0 will just return the current
+                maximum size. Otherwise, the size requested may not be less
+                than 100, or more than the kernel configuration value
+                KBUS_ABS_MAX_MESSAGE_SIZE.  The default maximum size is set by
+                the kernel configuration value KBUS_DEF_MAX_MESSAGE_SIZE, and
+                is typically 1024.  The size being tested is that returned by
+                the KBUS_ENTIRE_MESSAGE_LEN macro - i.e., the size of an
+                equivalent "entire" message.
 
 /proc/kbus/bindings
 -------------------
@@ -1158,7 +1170,8 @@ as values inside the IOError exception.
 :EINVAL:        Something went wrong (generic error).
 :EMSGSIZE:      On attempting to write a message: Data was written after
                 the end of the message (i.e., after the final end guard
-                of the message).
+                of the message), or an attempt was made to write a message
+                that is too long (see the MAXMSGSIZE ioctl).
 :ENAMETOOLONG:  On attempting to bind, unbind or send a message: The message
                 name is too long.
 :ENOENT:        On attempting to open a Ksock: There is no such device
diff --git a/include/linux/kbus_defns.h b/include/linux/kbus_defns.h
index 82779a6..29f6f99 100644
--- a/include/linux/kbus_defns.h
+++ b/include/linux/kbus_defns.h
@@ -655,9 +655,21 @@ struct kbus_replier_bind_event_data {
  * of the specified values)
  */
 #define KBUS_IOC_REPORTREPLIERBINDS  _IOWR(KBUS_IOC_MAGIC, 17, char *)
+/*
+ * MAXMSGSIZE - set the maximum size of a KBUS message for this KBUS device.
+ * This may not be set to less than 100, or more than
+ * CONFIG_KBUS_ABS_MAX_MESSAGE_SIZE.
+ * arg (in): __u32, the requested maximum message size, or 0 to just
+ *           request what the current limit is, 1 to request the absolute
+ *           maximum size.
+ * arg (out): __u32, the maximum essage size after this call has
+ *            succeeded
+ * retval: 0 for success, negative for failure
+ */
+#define KBUS_IOC_MAXMSGSIZE _IOWR(KBUS_IOC_MAGIC, 18, char *)
 
 /* If adding another IOCTL, remember to increment the next number! */
-#define KBUS_IOC_MAXNR	17
+#define KBUS_IOC_MAXNR	18
 
 #if !__KERNEL__ && defined(__cplusplus)
 }
diff --git a/ipc/Kconfig b/ipc/Kconfig
index 808d742..603b2f6 100644
--- a/ipc/Kconfig
+++ b/ipc/Kconfig
@@ -113,5 +113,35 @@ config KBUS_MAX_UNSENT_UNBIND_MESSAGES
 
 	  If unsure, choose the default.
 
-endif # KBUS
+config KBUS_ABS_MAX_MESSAGE_SIZE
+	int "Absolute maximum KBUS mesage size"
+	default 1024
+	range 100 2147483647
+	---help---
+	  This sets the absolute maximum size of an individual KBUS message,
+	  that is, the size of the largest KBUS message that may be written
+	  to a KBUS device node.
+
+	  It is not possible to set the maximum message size greater than
+	  this value using the KBUS_IOC_MAXMSGSIZE ioctl.
 
+	  The size is measured as by the KBUS_ENTIRE_MSG_LEN macro, and
+	  includes the message header (80 bytes on a 32-bit system).
+
+config KBUS_DEF_MAX_MESSAGE_SIZE
+	int "Default maximum KBUS mesage size"
+	default 1024
+	range 100 KBUS_ABS_MAX_MESSAGE_SIZE
+	---help---
+	  This sets the default maximum size of an individual KBUS message,
+	  that is, the size of the largest KBUS message that may be written
+	  to a KBUS device node.
+
+	  It may be altered at runtime, for a particular KBUS device, with
+	  the KBUS_IOC_MAXMSGSIZE ioctl, up to a limit of
+	  KBUS_ABS_MAX_MESSAGE_SIZE.
+
+	  The size is measured as by the KBUS_ENTIRE_MSG_LEN macro, and
+	  includes the message header (80 bytes on a 32-bit system).
+
+endif # KBUS
diff --git a/ipc/kbus_internal.h b/ipc/kbus_internal.h
index a24fcaf..51d512c 100644
--- a/ipc/kbus_internal.h
+++ b/ipc/kbus_internal.h
@@ -86,6 +86,14 @@
 #define CONFIG_KBUS_DEF_NUM_DEVICES	1
 #endif
 
+#ifndef CONFIG_KBUS_ABS_MAX_MESSAGE_SIZE
+#define CONFIG_KBUS_ABS_MAX_MESSAGE_SIZE 1024
+#endif
+
+#ifndef CONFIG_KBUS_DEF_MAX_MESSAGE_SIZE
+#define CONFIG_KBUS_DEF_MAX_MESSAGE_SIZE 1024
+#endif
+
 /*
  * Our initial array sizes could arguably be made configurable
  * for tuning, if we discover this is useful
@@ -685,6 +693,9 @@ struct kbus_dev {
 	struct list_head unsent_unbind_msg_list;
 	u32 unsent_unbind_msg_count;
 	int unsent_unbind_is_tragic;
+
+	/* The maximum message size that may be written to this device */
+	u32 max_message_size;
 };
 
 /*
diff --git a/ipc/kbus_main.c b/ipc/kbus_main.c
index e99bfca..64f863a 100644
--- a/ipc/kbus_main.c
+++ b/ipc/kbus_main.c
@@ -615,6 +615,8 @@ static int kbus_check_message_written(struct kbus_dev *dev,
 	struct kbus_message_header *user_msg =
 	    (struct kbus_message_header *)&this->user_msg;
 
+	int	msg_size;
+
 	if (this == NULL) {
 		dev_err(dev->dev, "pid %u [%s]"
 		       " Tried to check NULL message\n",
@@ -683,6 +685,15 @@ static int kbus_check_message_written(struct kbus_dev *dev,
 		       current->pid, current->comm);
 		return -EINVAL;
 	}
+
+	msg_size = KBUS_ENTIRE_MSG_LEN(user_msg->name_len, user_msg->data_len);
+	if (msg_size > dev->max_message_size) {
+		dev_err(dev->dev, "pid %u [%s]"
+			"Message size is %d, more than the maximum %d\n",
+			current->pid, current->comm,
+			msg_size, dev->max_message_size);
+		return -EMSGSIZE;
+	}
 	return 0;
 }
 
@@ -4150,6 +4161,39 @@ static int kbus_set_report_binds(struct kbus_private_data *priv,
 	return __put_user(old_value, (u32 __user *) arg);
 }
 
+static int kbus_maxmsgsize(struct kbus_private_data *priv,
+			   unsigned long arg)
+{
+	int retval = 0;
+	u32 requested_max;
+
+	retval = __get_user(requested_max, (u32 __user *) arg);
+	if (retval)
+		return retval;
+
+	kbus_maybe_dbg(priv->dev, "%u MAXMSGSIZE requests %u (was %u)\n",
+		       priv->id, requested_max, priv->dev->max_message_size);
+
+	dev_dbg(priv->dev->dev, "    abs max %d, def max %d\n",
+		CONFIG_KBUS_ABS_MAX_MESSAGE_SIZE,
+		CONFIG_KBUS_DEF_MAX_MESSAGE_SIZE);
+
+	/* A value of 0 is a query for the current length */
+	/* A value of 1 is a query for the absolute maximum */
+	if (requested_max == 0)
+		return __put_user(priv->dev->max_message_size,
+				  (u32 __user *) arg);
+	else if (requested_max == 1)
+		return __put_user(CONFIG_KBUS_ABS_MAX_MESSAGE_SIZE,
+				  (u32 __user *) arg);
+	else if (requested_max < 100 ||
+		 requested_max > CONFIG_KBUS_ABS_MAX_MESSAGE_SIZE)
+		return -EINVAL;
+
+	priv->dev->max_message_size = requested_max;
+	return __put_user(priv->dev->max_message_size, (u32 __user *) arg);
+}
+
 static long kbus_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	int err = 0;
@@ -4357,6 +4401,18 @@ static long kbus_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		retval = kbus_set_report_binds(priv, dev, arg);
 		break;
 
+	case KBUS_IOC_MAXMSGSIZE:
+		/*
+		 * Set (and/or query) maximum message size
+		 *
+		 * arg in: 0 or 1 (for query of current maximum or absolute
+		 * maximu) or maximum size wanted
+		 * arg out: maximum size allowed
+		 * return: 0 means OK, otherwise not OK
+		 */
+		retval = kbus_maxmsgsize(priv, arg);
+		break;
+
 	default:
 		/* *Should* be redundant, if we got our range checks right */
 		retval = -ENOTTY;
@@ -4545,6 +4601,7 @@ static int kbus_setup_new_device(int which)
 	new->index = which;
 
 	new->verbose = KBUS_DEFAULT_VERBOSE_SETTING;
+	new->max_message_size = CONFIG_KBUS_DEF_MAX_MESSAGE_SIZE;
 
 	new->dev = device_create(kbus_class_p, NULL,
 				 this_devno, NULL, "kbus%d", which);
-- 
1.7.4.1



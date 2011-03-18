Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932423Ab1CRRpk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 13:45:40 -0400
Received: from mail6.webfaction.com ([74.55.86.74]:60149 "EHLO
	smtp.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757239Ab1CRRp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 13:45:28 -0400
From: Tony Ibbs <tibs@tonyibbs.co.uk>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Linux-embedded <linux-embedded@vger.kernel.org>,
        Tibs at Kynesim <tibs@kynesim.co.uk>,
        Richard Watts <rrw@kynesim.co.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        Tony Ibbs <tibs@tonyibbs.co.uk>
Subject: [PATCH 08/11] KBUS add Replier Bind Events
Date: Fri, 18 Mar 2011 17:21:17 +0000
Message-Id: <100daf735e4bcf057ca5e84c391f04fa7dea1aaf.1300450604.git.tibs@tonyibbs.co.uk>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <6038dbd7e203bc102bd5d33ad9f1aa4f204a3a2e.1300450604.git.tibs@tonyibbs.co.uk>
References: <cover.1300450604.git.tibs@tonyibbs.co.uk>
 <273ee9658cbcbe19adfa0d7b30082d8966e70afc.1300450604.git.tibs@tonyibbs.co.uk>
 <979f23cd5f8a9ac727f17ad359ee487cbccbf7f6.1300450604.git.tibs@tonyibbs.co.uk>
 <c28914a66ae5526f18c331475298e7ef05bf57c7.1300450604.git.tibs@tonyibbs.co.uk>
 <ffc9b735a3b61c51881c108235155384a6e6f56c.1300450604.git.tibs@tonyibbs.co.uk>
 <e1e0c80ed995eccd4881081f5a769acb148b267b.1300450604.git.tibs@tonyibbs.co.uk>
 <023b39071aff3abc8e63336be501742333ceeced.1300450604.git.tibs@tonyibbs.co.uk>
 <6038dbd7e203bc102bd5d33ad9f1aa4f204a3a2e.1300450604.git.tibs@tonyibbs.co.uk>
In-Reply-To: <cover.1300450604.git.tibs@tonyibbs.co.uk>
References: <cover.1300450604.git.tibs@tonyibbs.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is useful to be able to write userspace proxies which allow
messages sent on one KBUS device to be received on another. In
order to do this, the userspace program needs to be reliably
informed of Replier bind and unbind events.

These proxies are referrred to as Limpets in the KBUS documentation.
There is a brief introduction to the concept here:
http://presentations.kbus.googlecode.com/hg/talks/europython2010.html#limpets

Signed-off-by: Tony Ibbs <tibs@tonyibbs.co.uk>
---
 include/linux/kbus_defns.h |   30 ++++-
 ipc/kbus_internal.h        |    5 +
 ipc/kbus_main.c            |  376 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 410 insertions(+), 1 deletions(-)

diff --git a/include/linux/kbus_defns.h b/include/linux/kbus_defns.h
index 4d3fcd5..c646a1d 100644
--- a/include/linux/kbus_defns.h
+++ b/include/linux/kbus_defns.h
@@ -489,6 +489,19 @@ struct kbus_replier_bind_event_data {
 #define KBUS_MSG_NAME_REPLIER_DISAPPEARED	"$.KBUS.Replier.Disappeared"
 #define KBUS_MSG_NAME_ERROR_SENDING		"$.KBUS.ErrorSending"
 
+/*
+ * Replier Bind Event
+ * ------------------
+ * This is the only message name for which KBUS generates data -- see
+ * kbus_replier_bind_event_data. It is also the only message name which KBUS
+ * does not allow binding to as a Replier.
+ *
+ * This is the message that is sent when a Replier binds or unbinds to another
+ * message name, if the KBUS_IOC_REPORTREPLIERBINDS ioctl has been used to
+ * request such notification.
+ */
+#define KBUS_MSG_NAME_REPLIER_BIND_EVENT	"$.KBUS.ReplierBindEvent"
+
 #define KBUS_IOC_MAGIC	'k'	/* 0x6b - which seems fair enough for now */
 /*
  * RESET: reserved for future use
@@ -621,8 +634,23 @@ struct kbus_replier_bind_event_data {
  */
 #define KBUS_IOC_NEWDEVICE _IOR(KBUS_IOC_MAGIC, 16, char *)
 
+/*
+ * REPORTREPLIERBINDS - request synthetic messages announcing Replier
+ * bind/unbind events.
+ *
+ * If this flag is set, then when someone binds or unbinds to a message name as
+ * a Replier, KBUS will send out a synthetic Announcement of this fact.
+ *
+ * arg(in): __u32, 1 to change to "report", 0 to change to "do not report",
+ * 0xFFFFFFFF to just return the current/previous state.
+ * arg(out): __u32, the previous state.
+ * retval: 0 for success, negative for failure (-EINVAL if arg in was not one
+ * of the specified values)
+ */
+#define KBUS_IOC_REPORTREPLIERBINDS  _IOWR(KBUS_IOC_MAGIC, 17, char *)
+
 /* If adding another IOCTL, remember to increment the next number! */
-#define KBUS_IOC_MAXNR	16
+#define KBUS_IOC_MAXNR	17
 
 #if !__KERNEL__ && defined(__cplusplus)
 }
diff --git a/ipc/kbus_internal.h b/ipc/kbus_internal.h
index 28c153c..13dc896 100644
--- a/ipc/kbus_internal.h
+++ b/ipc/kbus_internal.h
@@ -618,6 +618,11 @@ struct kbus_dev {
 
 	/* Are we wanting debugging messages? */
 	u32 verbose;
+
+	/*
+	 * Are we wanting to send a synthetic message for each Replier
+	 * bind/unbind? */
+	u32 report_replier_binds;
 };
 
 /*
diff --git a/ipc/kbus_main.c b/ipc/kbus_main.c
index 48ba4b2..6372b40 100644
--- a/ipc/kbus_main.c
+++ b/ipc/kbus_main.c
@@ -1031,6 +1031,203 @@ static void kbus_push_synthetic_message(struct kbus_dev *dev,
 }
 
 /*
+ * Add the data part to a bind/unbind synthetic message.
+ *
+ * 'is_bind' is true if this was a "bind" event, false if it was an "unbind".
+ *
+ * 'name' is the message name (or wildcard) that was bound (or unbound) to.
+ *
+ * Returns 0 if all goes well, or a negative value if something goes wrong.
+ */
+static int kbus_add_bind_message_data(struct kbus_private_data *priv,
+				      struct kbus_msg *new_msg,
+				      u32 is_bind,
+				      u32 name_len, char *name)
+{
+	struct kbus_replier_bind_event_data *data;
+	struct kbus_data_ptr *wrapped_data;
+	u32 padded_name_len = KBUS_PADDED_NAME_LEN(name_len);
+	u32 data_len = sizeof(*data) + padded_name_len;
+	u32 rest_len = padded_name_len / 4;
+	char *name_p;
+
+	unsigned long *parts;
+	unsigned *lengths;
+
+	data = kmalloc(data_len, GFP_KERNEL);
+	if (!data) {
+		kbus_free_message(new_msg);
+		return -ENOMEM;
+	}
+
+	name_p = (char *)&data->rest[0];
+
+	data->is_bind = is_bind;
+	data->binder = priv->id;
+	data->name_len = name_len;
+
+	data->rest[rest_len - 1] = 0;	/* terminating with enough '\0' */
+	strncpy(name_p, name, name_len);
+
+	/*
+	 * And that data, unfortunately for our simple mindedness,
+	 * needs wrapping up in a reference count...
+	 *
+	 * Note/remember that we are happy for the reference counting
+	 * wrapper to "own" our data, and free it when the it is done
+	 * with it.
+	 *
+	 * I'm going to assert that we have less than a PAGE length
+	 * of data, so we can simply do:
+	 */
+	parts = kmalloc(sizeof(*parts), GFP_KERNEL);
+	if (!parts) {
+		kfree(data);
+		return -ENOMEM;
+	}
+	lengths = kmalloc(sizeof(*lengths), GFP_KERNEL);
+	if (!lengths) {
+		kfree(parts);
+		kfree(data);
+		return -ENOMEM;
+	}
+	lengths[0] = data_len;
+	parts[0] = (unsigned long)data;
+	wrapped_data =
+	    kbus_wrap_data_in_ref(false, 1, parts, lengths, data_len);
+	if (!wrapped_data) {
+		kfree(lengths);
+		kfree(parts);
+		kfree(data);
+		return -ENOMEM;
+	}
+
+	new_msg->data_len = data_len;
+	new_msg->data_ref = wrapped_data;
+	return 0;
+}
+
+/*
+ * Create a new Replier Bind Event synthetic message.
+ *
+ * The initial design of things didn't really expect us to be
+ * generating messages with actual data inside the kernel module,
+ * so it's all a little bit more complicated than it might otherwise
+ * be, and there's some playing with things directly that might best
+ * be done otherwise (notably, sorting out the wrapping up of the
+ * data in a reference count). I think that's excusable given this
+ * should be the only sort of message we ever generate with actual
+ * data (or so I believe).
+ *
+ * Returns the new message, or NULL.
+ */
+static struct kbus_msg
+*kbus_new_synthetic_bind_message(struct kbus_private_data *priv,
+				 u32 is_bind,
+				 u32 name_len, char *name)
+{
+	ssize_t retval = 0;
+	struct kbus_msg *new_msg;
+	struct kbus_msg_id in_reply_to = { 0, 0 };	/* no-one */
+
+	kbus_maybe_dbg(priv->dev,
+		       "  Creating synthetic bind message for '%s'"
+		       " (%s)\n", name, is_bind ? "bind" : "unbind");
+
+	new_msg = kbus_build_kbus_message(priv->dev,
+					  KBUS_MSG_NAME_REPLIER_BIND_EVENT,
+					  0, 0, in_reply_to);
+	if (!new_msg)
+		return NULL;
+
+	/*
+	 * What happens if any one of the listeners can't receive the message
+	 * because they don't have room in their queues?
+	 *
+	 * If we flag the message as ALL_OR_FAIL, then if we can't deliver
+	 * to all of the listeners who care, we will get -EBUSY returned to
+	 * us, which we shall then return as -EAGAIN (people expect to check
+	 * for -EAGAIN to find out if they should, well, try again).
+	 *
+	 * In this scenario, the user needs to catch a "bind"/"unbind" return
+	 * of -EAGAIN and realise that it needs to try again.
+	 */
+	new_msg->flags |= KBUS_BIT_ALL_OR_FAIL;
+
+	/*
+	 * That gave us the basis of the message, but now we need to add in
+	 * its meaning.
+	 */
+	retval = kbus_add_bind_message_data(priv, new_msg, is_bind,
+					    name_len, name);
+	if (retval < 0) {
+		kbus_free_message(new_msg);
+		return NULL;
+	}
+
+	return new_msg;
+}
+
+/*
+ * Generate a bind/unbind synthetic message, and broadcast it.
+ *
+ * This is for use when we have been asked to announce when a Replier binds or
+ * unbinds.
+ *
+ * 'priv' is the sender - the entity that is doing the actual bind/unbind.
+ *
+ * 'is_bind' is true if this was a "bind" event, false if it was an "unbind".
+ *
+ * 'name' is the message name (or wildcard) that was bound (or unbound) to.
+ *
+ * Returns 0 if all goes well, or a negative value if something goes wrong,
+ * notably -EAGAIN if we couldn't send the message to ALL the Listeners who
+ * have bound to receive it.
+ */
+static int kbus_push_synthetic_bind_message(struct kbus_private_data *priv,
+					    u32 is_bind,
+					    u32 name_len, char *name)
+{
+
+	ssize_t retval = 0;
+	struct kbus_msg *new_msg;
+
+	kbus_maybe_dbg(priv->dev,
+		       "  Pushing synthetic bind message for '%s'"
+		       " (%s) onto queue\n", name,
+		       is_bind ? "bind" : "unbind");
+
+	new_msg =
+	    kbus_new_synthetic_bind_message(priv, is_bind, name_len, name);
+	if (new_msg == NULL)
+		return -ENOMEM;
+
+	kbus_maybe_report_message(priv->dev, new_msg);
+	kbus_maybe_dbg(priv->dev,
+		       "Writing synthetic message to "
+		       "recipients\n");
+
+	retval = kbus_write_to_recipients(priv, priv->dev, new_msg);
+	/*
+	 * kbus_push_message takes a copy of our message data, so we
+	 * must remember to free ours. Since we've made sure that it
+	 * looks just like a user-generated message (i.e., the name
+	 * can be freed as well as the data), this is fairly simple.
+	 */
+	kbus_free_message(new_msg);
+
+	/*
+	 * Because we used ALL_OR_FAIL, we will get -EBUSY back if we FAIL,
+	 * but we want to tell the user -EAGAIN, since they *should* try
+	 * again later.
+	 */
+	if (retval == -EBUSY)
+		retval = -EAGAIN;
+
+	return retval;
+}
+
+/*
  * Pop the next message off our queue.
  *
  * Returns a pointer to the message, or NULL if there is no next message.
@@ -1442,6 +1639,21 @@ static int kbus_remember_binding(struct kbus_dev *dev,
 	new->name_len = name_len;
 	new->name = name;
 
+	if (replier && dev->report_replier_binds) {
+		/*
+		 * We've been asked to announce when a Replier binds.
+		 * If we can't tell all the Listeners who care, we want
+		 * to give up, rather than tell some of them, and then
+		 * bind anyway.
+		 */
+		retval = kbus_push_synthetic_bind_message(priv, true,
+							  name_len, name);
+		if (retval != 0) {	/* Hopefully, just -EBUSY */
+			kfree(new);
+			return retval;
+		}
+	}
+
 	list_add(&new->list, &dev->bound_message_list);
 	return 0;
 }
@@ -1561,6 +1773,27 @@ static int kbus_forget_binding(struct kbus_dev *dev,
 		return -EINVAL;
 	}
 
+	if (replier && dev->report_replier_binds) {
+
+		/*
+		 * We want to send a message indicating that we've unbound
+		 * the Replier for this message.
+		 *
+		 * If we can't tell all the Listeners who're listening for this
+		 * message, we want to give up, rather then tell some of them,
+		 * and then unbind anyway.
+		 */
+		int retval = kbus_push_synthetic_bind_message(priv, false,
+							      name_len, name);
+		if (retval != 0)	/* Hopefully, just -EBUSY */
+			return retval;
+		/*
+		 * Note that if we were ourselves listening for replier bind
+		 * events, then we will ourselves get the message announcing
+		 * we're about to unbind.
+		 */
+	}
+
 	kbus_maybe_dbg(priv->dev, "  %u Unbound %u %c '%.*s'\n",
 		       priv->id, binding->bound_to_id,
 		       (binding->is_replier ? 'R' : 'L'),
@@ -1584,6 +1817,49 @@ static int kbus_forget_binding(struct kbus_dev *dev,
 	return 0;
 }
 
+
+/*
+ * Report a Replier Bind Event for unbinding from the given message name
+ */
+static void kbus_report_unbinding(struct kbus_private_data *priv,
+				  u32 name_len, char *name)
+{
+	struct kbus_msg *msg;
+	int retval;
+
+	kbus_maybe_dbg(priv->dev,
+		       "  %u Safe report unbinding of '%.*s'\n",
+		       priv->id, name_len, name);
+
+	/* Generate the "X has unbound from Y" message */
+	msg = kbus_new_synthetic_bind_message(priv, false, name_len, name);
+	if (msg == NULL)
+		return;	/* There is nothing sensible to do here */
+
+	/* ...and send it */
+	retval = kbus_write_to_recipients(priv, priv->dev, msg);
+	if (retval != -EBUSY)
+		goto done_sending;
+
+	/*
+	 * If someone who had bound to it wasn't able to take the message,
+	 * then there's not a lot we can do at this stage.
+	 *
+	 * XXX This is, of course, unacceptable. Sorting it out will
+	 * XXX be done in the next tranch of code, though, since it
+	 * XXX is not terribly simple.
+	 */
+	kbus_maybe_dbg(priv->dev,
+		       "  %u Someone was unable to receive message '%*s'\n",
+		       priv->id, name_len, name);
+
+done_sending:
+	/* Don't forget to free our copy of the message */
+	if (msg)
+		kbus_free_message(msg);
+	/* We aren't returning any status code. Oh well. */
+}
+
 /*
  * Remove all bindings for a particular listener.
  *
@@ -1608,6 +1884,10 @@ static void kbus_forget_my_bindings(struct kbus_private_data *priv)
 			       ptr->bound_to_id, (ptr->is_replier ? 'R' : 'L'),
 			       ptr->name_len, ptr->name);
 
+		if (ptr->is_replier && dev->report_replier_binds)
+			kbus_report_unbinding(priv, ptr->name_len,
+					      ptr->name);
+
 		list_del(&ptr->list);
 		kfree(ptr->name);
 		kfree(ptr);
@@ -2624,6 +2904,14 @@ static int kbus_bind(struct kbus_private_data *priv,
 		goto done;
 	}
 
+	if (bind->is_replier && !strcmp(name,
+					KBUS_MSG_NAME_REPLIER_BIND_EVENT)) {
+		kbus_maybe_dbg(priv->dev, "cannot bind %s as a Replier\n",
+			       KBUS_MSG_NAME_REPLIER_BIND_EVENT);
+		retval = -EBADMSG;
+		goto done;
+	}
+
 	kbus_maybe_dbg(priv->dev, "%u BIND %c '%.*s'\n", priv->id,
 		       (bind->is_replier ? 'R' : 'L'), bind->name_len, name);
 
@@ -3353,6 +3641,83 @@ static int kbus_set_verbosity(struct kbus_private_data *priv,
 	return __put_user(old_value, (u32 __user *) arg);
 }
 
+/* Report all existing replier bindings to the requester */
+static int kbus_report_existing_binds(struct kbus_private_data *priv,
+				      struct kbus_dev *dev)
+{
+	struct kbus_message_binding *ptr;
+	struct kbus_message_binding *next;
+
+	list_for_each_entry_safe(ptr, next, &dev->bound_message_list, list) {
+		struct kbus_msg *new_msg;
+		int retval;
+
+		kbus_maybe_dbg(priv->dev, "  %u Report %c '%.*s'\n",
+		       priv->id, (ptr->is_replier ? 'R' : 'L'),
+		       ptr->name_len, ptr->name);
+
+		if (!ptr->is_replier)
+			continue;
+
+		new_msg = kbus_new_synthetic_bind_message(ptr->bound_to, true,
+						  ptr->name_len, ptr->name);
+		if (new_msg == NULL)
+			return -ENOMEM;
+
+		/*
+		 * It is perhaps a bit inefficient to check this per binding,
+		 * but it saves us doing two passes through the list.
+		 */
+		if (kbus_queue_is_full(priv, "limpet", false)) {
+			/* Giving up is probably the best we can do */
+			kbus_free_message(new_msg);
+			return -EBUSY;
+		}
+
+		retval = kbus_push_message(priv, new_msg, NULL, false);
+
+		kbus_free_message(new_msg);
+		if (retval)
+			return retval;
+	}
+	return 0;
+}
+
+static int kbus_set_report_binds(struct kbus_private_data *priv,
+				 struct kbus_dev *dev, unsigned long arg)
+{
+	int retval = 0;
+	u32 report_replier_binds;
+	int old_value = priv->dev->report_replier_binds;
+
+	retval = __get_user(report_replier_binds, (u32 __user *) arg);
+	if (retval)
+		return retval;
+
+	kbus_maybe_dbg(priv->dev,
+		       "%u REPORTREPLIERBINDS requests %u (was %d)\n",
+		       priv->id, report_replier_binds, old_value);
+
+	switch (report_replier_binds) {
+	case 0:
+		priv->dev->report_replier_binds = false;
+		break;
+	case 1:
+		priv->dev->report_replier_binds = true;
+		/* And report the current state of bindings... */
+		retval = kbus_report_existing_binds(priv, dev);
+		if (retval)
+			return retval;
+		break;
+	case 0xFFFFFFFF:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return __put_user(old_value, (u32 __user *) arg);
+}
+
 static long kbus_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	int err = 0;
@@ -3549,6 +3914,17 @@ static long kbus_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		}
 		break;
 
+	case KBUS_IOC_REPORTREPLIERBINDS:
+		/*
+		 * Should we report Replier bind/unbind events?
+		 *
+		 * arg in: 0 (for no), 1 (for yes), 0xFFFFFFFF (for query)
+		 * arg out: the previous value, before we were called
+		 * return: 0 means OK, otherwise not OK
+		 */
+		retval = kbus_set_report_binds(priv, dev, arg);
+		break;
+
 	default:
 		/* *Should* be redundant, if we got our range checks right */
 		retval = -ENOTTY;
-- 
1.7.4.1


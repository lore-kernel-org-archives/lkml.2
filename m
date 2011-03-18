Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932508Ab1CRRq0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 13:46:26 -0400
Received: from mail6.webfaction.com ([74.55.86.74]:60480 "EHLO
	smtp.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757286Ab1CRRqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 13:46:03 -0400
From: Tony Ibbs <tibs@tonyibbs.co.uk>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Linux-embedded <linux-embedded@vger.kernel.org>,
        Tibs at Kynesim <tibs@kynesim.co.uk>,
        Richard Watts <rrw@kynesim.co.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        Tony Ibbs <tibs@tonyibbs.co.uk>
Subject: [PATCH 09/11] KBUS Replier Bind Event set-aside lists
Date: Fri, 18 Mar 2011 17:21:18 +0000
Message-Id: <c6d9cea99c649d41ae838838a0e8da3807b98e64.1300450604.git.tibs@tonyibbs.co.uk>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <100daf735e4bcf057ca5e84c391f04fa7dea1aaf.1300450604.git.tibs@tonyibbs.co.uk>
References: <cover.1300450604.git.tibs@tonyibbs.co.uk>
 <273ee9658cbcbe19adfa0d7b30082d8966e70afc.1300450604.git.tibs@tonyibbs.co.uk>
 <979f23cd5f8a9ac727f17ad359ee487cbccbf7f6.1300450604.git.tibs@tonyibbs.co.uk>
 <c28914a66ae5526f18c331475298e7ef05bf57c7.1300450604.git.tibs@tonyibbs.co.uk>
 <ffc9b735a3b61c51881c108235155384a6e6f56c.1300450604.git.tibs@tonyibbs.co.uk>
 <e1e0c80ed995eccd4881081f5a769acb148b267b.1300450604.git.tibs@tonyibbs.co.uk>
 <023b39071aff3abc8e63336be501742333ceeced.1300450604.git.tibs@tonyibbs.co.uk>
 <6038dbd7e203bc102bd5d33ad9f1aa4f204a3a2e.1300450604.git.tibs@tonyibbs.co.uk>
 <100daf735e4bcf057ca5e84c391f04fa7dea1aaf.1300450604.git.tibs@tonyibbs.co.uk>
In-Reply-To: <cover.1300450604.git.tibs@tonyibbs.co.uk>
References: <cover.1300450604.git.tibs@tonyibbs.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to make sending Replier Bind Events reliable, we need
to introduce set-aside message lists, in case a client that
wants to receive such events has a full list when the event
occurs (making bind/unbind depend on the recipient of the
event is not acceptable).

Signed-off-by: Tony Ibbs <tibs@tonyibbs.co.uk>
---
 include/linux/kbus_defns.h |    7 +
 ipc/kbus_internal.h        |   62 ++++++
 ipc/kbus_main.c            |  464 ++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 518 insertions(+), 15 deletions(-)

diff --git a/include/linux/kbus_defns.h b/include/linux/kbus_defns.h
index c646a1d..82779a6 100644
--- a/include/linux/kbus_defns.h
+++ b/include/linux/kbus_defns.h
@@ -482,12 +482,19 @@ struct kbus_replier_bind_event_data {
  *   bound as Replier closed.
  * * ErrorSending - an unexpected error occurred when trying to send a Request
  *   to its Replier whilst polling.
+ *
+ * Synthetic Announcements with no data
+ * ------------------------------------
+ * * UnbindEventsLost - sent (instead of a Replier Bind Event) when the unbind
+ *   events "set aside" list has filled up, and thus unbind events have been
+ *   lost.
  */
 #define KBUS_MSG_NAME_REPLIER_GONEAWAY		"$.KBUS.Replier.GoneAway"
 #define KBUS_MSG_NAME_REPLIER_IGNORED		"$.KBUS.Replier.Ignored"
 #define KBUS_MSG_NAME_REPLIER_UNBOUND		"$.KBUS.Replier.Unbound"
 #define KBUS_MSG_NAME_REPLIER_DISAPPEARED	"$.KBUS.Replier.Disappeared"
 #define KBUS_MSG_NAME_ERROR_SENDING		"$.KBUS.ErrorSending"
+#define KBUS_MSG_NAME_UNBIND_EVENTS_LOST	"$.KBUS.UnbindEventsLost"
 
 /*
  * Replier Bind Event
diff --git a/ipc/kbus_internal.h b/ipc/kbus_internal.h
index 13dc896..a24fcaf 100644
--- a/ipc/kbus_internal.h
+++ b/ipc/kbus_internal.h
@@ -414,6 +414,20 @@ struct kbus_write_msg {
 };
 
 /*
+ * The data for an unsent Replier Bind Event (in the unsent_unbind_msg_list)
+ *
+ * Note that 'binding' may theroretically be NULL (although I don't think this
+ * should ever actually happen).
+ */
+struct kbus_unsent_message_item {
+	struct list_head list;
+	struct kbus_private_data *send_to;	/* who we want to send it to */
+	u32 send_to_id;	/* but the id is often useful */
+	struct kbus_msg *msg;	/* the message itself */
+	struct kbus_message_binding *binding;	/* and why we remembered it */
+};
+
+/*
  * This is the data for an individual Ksock
  *
  * Each time we open /dev/kbus<n>, we need to remember a unique id for
@@ -564,6 +578,13 @@ struct kbus_private_data {
 	 * message pushed onto the queue. Which is much simpler.
 	 */
 	struct kbus_msg_id msg_id_just_pushed;
+
+	/*
+	 * If this flag is set, then we may have outstanding Replier Unbound
+	 * Event messages (kept on a list on our device). These must be read
+	 * before any "normal" messages (on our message_queue) get read.
+	 */
+	int maybe_got_unsent_unbind_msgs;
 };
 
 /* What is a sensible number for the default maximum number of messages? */
@@ -571,6 +592,18 @@ struct kbus_private_data {
 #define CONFIG_KBUS_DEF_MAX_MESSAGES	100
 #endif
 
+/*
+ * What about the maximum number of unsent unbind event messages?
+ * This may want to be quite large, to allow for Limpets with momentary
+ * network outages.
+ *
+ * The default value is probably too small, but experimantation is
+ * needed to determine a more sensible value.
+ */
+#ifndef CONFIG_KBUS_MAX_UNSENT_UNBIND_MESSAGES
+#define CONFIG_KBUS_MAX_UNSENT_UNBIND_MESSAGES 1000
+#endif
+
 /* Information belonging to each /dev/kbus<N> device */
 struct kbus_dev {
 	struct cdev cdev;	/* Character device data */
@@ -623,6 +656,35 @@ struct kbus_dev {
 	 * Are we wanting to send a synthetic message for each Replier
 	 * bind/unbind? */
 	u32 report_replier_binds;
+
+	/*
+	 * If Replier (un)bind events have been requested, then when
+	 * kbus_release is called, a message must be sent for each Replier that
+	 * is (of necessity) unbound from the Ksock being released. For a
+	 * normal unbound, if any of the Repliers doesn't have room in its
+	 * message queue for such an event, then the unbind fails with -EAGAIN.
+	 * This isn't acceptable for kbus_release (apart from anything else,
+	 * the release might be due to the original program falling over).
+	 * It's not acceptable to fail to send the messages (that's a general
+	 * KBUS principle).
+	 *
+	 * The only sensible solution seems to be to put the messages we'd
+	 * like to have sent onto a set-aside list, and mark each recipient
+	 * as having messages thereon. Then, each time a Ksock looks for a
+	 * new message, it should first check to see if it might have one
+	 * on the set-aside list, and if it does, read that instead.
+	 *
+	 * Once we're doing this, though, we need some limit on how big that
+	 * set-aside list may grow (to allow for user processes that keep
+	 * binding and falling over!). When the list gets "too long", we set a
+	 * "gone tragically wrong" flag, and instead of adding more unbind
+	 * events, we instead add a single "gone tragically wrong" message for
+	 * each Ksock. We don't revert to remembering unbind events again until
+	 * the list has been emptied.
+	 */
+	struct list_head unsent_unbind_msg_list;
+	u32 unsent_unbind_msg_count;
+	int unsent_unbind_is_tragic;
 };
 
 /*
diff --git a/ipc/kbus_main.c b/ipc/kbus_main.c
index 6372b40..296a1a1 100644
--- a/ipc/kbus_main.c
+++ b/ipc/kbus_main.c
@@ -88,6 +88,11 @@ static int kbus_write_to_recipients(struct kbus_private_data *priv,
 				    struct kbus_dev *dev,
 				    struct kbus_msg *msg);
 
+static void kbus_forget_unbound_unsent_unbind_msgs(struct kbus_private_data
+						   *priv,
+						   struct kbus_message_binding
+						   *binding);
+
 static int kbus_alloc_ref_data(struct kbus_private_data *priv,
 			       u32 data_len,
 			       struct kbus_data_ptr **ret_ref_data);
@@ -1803,6 +1808,13 @@ static int kbus_forget_binding(struct kbus_dev *dev,
 	kbus_forget_matching_messages(priv, binding);
 
 	/*
+	 * Maybe including any set-aside Replier Unbind Events...
+	 */
+	if (!strncmp(KBUS_MSG_NAME_REPLIER_BIND_EVENT, binding->name,
+		     binding->name_len))
+		kbus_forget_unbound_unsent_unbind_msgs(priv, binding);
+
+	/*
 	 * We carefully don't try to do anything about requests that
 	 * have already been read - the fact that the user has unbound
 	 * from receiving new messages with this name doesn't imply
@@ -1817,43 +1829,219 @@ static int kbus_forget_binding(struct kbus_dev *dev,
 	return 0;
 }
 
+/*
+ * Add a (copy of a) message to the "unsent Replier Unbind Event" list
+ *
+ * 'priv' is who we are trying to send to, 'msg' is the message we were
+ * trying to send.
+ *
+ * Returns 0 if all went well, a negative value if it did not.
+ */
+static int kbus_remember_unsent_unbind_event(struct kbus_dev *dev,
+					     struct kbus_private_data *priv,
+					     struct kbus_msg *msg,
+					     struct kbus_message_binding
+					     *binding)
+{
+	struct kbus_unsent_message_item *new;
+	struct kbus_msg *new_msg = NULL;
+
+	kbus_maybe_dbg(priv->dev,
+		       "  Remembering unsent unbind event "
+		       "%u '%.*s' to %u\n",
+		       dev->unsent_unbind_msg_count, msg->name_len,
+		       msg->name_ref->name, priv->id);
+
+	new = kmalloc(sizeof(*new), GFP_KERNEL);
+	if (!new)
+		return -ENOMEM;
+
+	new_msg = kbus_copy_message(dev, msg);
+	if (!new_msg) {
+		kfree(new);
+		return -EFAULT;
+	}
+
+	new->send_to = priv;
+	new->send_to_id = priv->id;	/* Useful shorthand? */
+	new->msg = new_msg;
+	new->binding = binding;
+
+	/*
+	 * The order should be the same as a normal message queue,
+	 * so add to the end...
+	 */
+	list_add_tail(&new->list, &dev->unsent_unbind_msg_list);
+	dev->unsent_unbind_msg_count++;
+	return 0;
+}
+
+/*
+ * Return true if this listener already has a "gone tragic" message.
+ *
+ * Look at the end of the unsent Replier Unbind Event message list, to see
+ * if the given listener already has a "gone tragic" message (since if it
+ * does, we will not want to add another).
+ */
+static int kbus_listener_already_got_tragic_msg(struct kbus_dev *dev,
+						struct kbus_private_data
+						*listener)
+{
+	struct kbus_unsent_message_item *ptr;
+	struct kbus_unsent_message_item *next;
+
+	kbus_maybe_dbg(dev,
+		       "  Checking for 'gone tragic' event for %u\n",
+		       listener->id);
+
+	list_for_each_entry_safe_reverse(ptr, next,
+					 &dev->unsent_unbind_msg_list, list) {
+
+		if (kbus_message_name_matches(
+					ptr->msg->name_ref->name,
+					ptr->msg->name_len,
+					KBUS_MSG_NAME_REPLIER_BIND_EVENT))
+			/*
+			 * If we get a Replier Bind Event, then we're past all
+			 * the "tragic world" messages
+			 */
+			break;
+		if (ptr->send_to_id == listener->id) {
+			kbus_maybe_dbg(dev, "  Found\n");
+			return true;
+		}
+	}
+
+	kbus_maybe_dbg(dev, "  Not found\n");
+	return false;
+}
 
 /*
- * Report a Replier Bind Event for unbinding from the given message name
+ * Report a Replier Bind Event for unbinding from the given message name,
+ * in such a way that we do not lose the message even if we can't send it
+ * right away.
  */
-static void kbus_report_unbinding(struct kbus_private_data *priv,
-				  u32 name_len, char *name)
+static void kbus_safe_report_unbinding(struct kbus_private_data *priv,
+				       u32 name_len, char *name)
 {
+	/* 1. Generate a new unbinding event message
+	 * 2. Try sending it to everyone who cares
+	 * 3. If that failed, then find out who *does* care
+	 * 4. Is there room for that many messages on the set-aside list?
+	 * 5. If there is, add (a copy of) the message for each
+	 * 6. If there is not, set the "tragic" flag, and add (a copy of)
+	 *    the "world gone tragic" message for each
+	 * 7. If we've added something to the set-aside list, then set
+	 *    the "maybe got something on the set-aside list" flag for
+	 *    each recipient. */
+
 	struct kbus_msg *msg;
-	int retval;
+	struct kbus_message_binding **listeners = NULL;
+	struct kbus_message_binding *replier = NULL;
+	int retval = 0;
+	int num_listeners;
+	int ii;
 
 	kbus_maybe_dbg(priv->dev,
 		       "  %u Safe report unbinding of '%.*s'\n",
 		       priv->id, name_len, name);
 
-	/* Generate the "X has unbound from Y" message */
+	/* Generate the message we'd *like* to send */
 	msg = kbus_new_synthetic_bind_message(priv, false, name_len, name);
 	if (msg == NULL)
 		return;	/* There is nothing sensible to do here */
 
-	/* ...and send it */
+	/* If we're lucky, we can just send it */
 	retval = kbus_write_to_recipients(priv, priv->dev, msg);
 	if (retval != -EBUSY)
 		goto done_sending;
 
 	/*
-	 * If someone who had bound to it wasn't able to take the message,
-	 * then there's not a lot we can do at this stage.
+	 * So at least one of the people we were trying to send to was not able
+	 * to take the message, presumably because their message queue is full.
+	 * Thus we need to put aside one copy of the message for each
+	 * recipient, to be delivered when it *can* be received.
 	 *
-	 * XXX This is, of course, unacceptable. Sorting it out will
-	 * XXX be done in the next tranch of code, though, since it
-	 * XXX is not terribly simple.
+	 * So before we do anything else, we need to know who those recipients
+	 * are.
 	 */
+
 	kbus_maybe_dbg(priv->dev,
-		       "  %u Someone was unable to receive message '%*s'\n",
-		       priv->id, name_len, name);
+		       "  %u Need to add messages to set-aside list\n",
+		       priv->id);
+
+	/*
+	 * We're expecting some listeners, but no replier.
+	 * Since this is a duplicate of what we did in kbus_write_to_recipients,
+	 * and since our ksock is locked whilst we're working, we can assume
+	 * that we should get the same result. For the sake of completeness,
+	 * check the error return anyway, but I'm not going to worry about
+	 * whether we suddenly have a replier popping up unexpectedly...
+	 */
+	num_listeners = kbus_find_listeners(priv->dev, &listeners, &replier,
+					    msg->name_len, msg->name_ref->name);
+	if (num_listeners < 0) {
+		kbus_maybe_dbg(priv->dev,
+			       "  Error %d finding listeners\n",
+			       num_listeners);
+		retval = num_listeners;
+		goto done_sending;
+	}
+
+	if (priv->dev->unsent_unbind_is_tragic ||
+	    (num_listeners + priv->dev->unsent_unbind_msg_count >
+	     CONFIG_KBUS_MAX_UNSENT_UNBIND_MESSAGES)) {
+		struct kbus_msg_id in_reply_to = { 0, 0 };	/* no-one */
+		/*
+		 * Either the list had already gone tragic, or we've
+		 * filled it up with "normal" unbind event messages
+		 */
+		priv->dev->unsent_unbind_is_tragic = true;
+
+		/* In which case we need a different message */
+		kbus_free_message(msg);
+		msg = kbus_build_kbus_message(priv->dev,
+					      KBUS_MSG_NAME_UNBIND_EVENTS_LOST,
+					      0, 0, in_reply_to);
+		if (msg == NULL)
+			goto done_sending;
+
+		for (ii = 0; ii < num_listeners; ii++) {
+			/*
+			 * We only want to add a "gone tragic" message if the
+			 * recipient does not already have such a message
+			 * stacked...
+			 */
+			if (kbus_listener_already_got_tragic_msg(priv->dev,
+						 listeners[ii]->bound_to))
+				continue;
+			retval = kbus_remember_unsent_unbind_event(priv->dev,
+					   listeners[ii]->bound_to,
+					   msg, listeners[ii]);
+			/* And remember that we've got something on the
+			 * set-aside list */
+			listeners[ii]->bound_to->maybe_got_unsent_unbind_msgs =
+			    true;
+			if (retval)
+				break;	/* No good choice here */
+		}
+	} else {
+		/* There's room to add these messages as-is */
+		for (ii = 0; ii < num_listeners; ii++) {
+			retval = kbus_remember_unsent_unbind_event(priv->dev,
+					   listeners[ii]->bound_to,
+					   msg, listeners[ii]);
+			/* And remember that we've got something on the
+			 * set-aside list */
+			listeners[ii]->bound_to->maybe_got_unsent_unbind_msgs =
+			    true;
+			if (retval)
+				break;	/* No good choice here */
+		}
+	}
 
 done_sending:
+	kfree(listeners);
 	/* Don't forget to free our copy of the message */
 	if (msg)
 		kbus_free_message(msg);
@@ -1861,6 +2049,196 @@ done_sending:
 }
 
 /*
+ * Return how many messages we have in the unsent Replier Unbind Event list.
+ */
+static u32 kbus_count_unsent_unbind_msgs(struct kbus_private_data *priv)
+{
+	struct kbus_dev *dev = priv->dev;
+
+	struct kbus_unsent_message_item *ptr;
+	struct kbus_unsent_message_item *next;
+
+	u32 count = 0;
+
+	kbus_maybe_dbg(dev, "%u Counting unsent unbind messages\n", priv->id);
+
+	list_for_each_entry_safe(ptr, next, &dev->unsent_unbind_msg_list,
+				 list) {
+		if (ptr->send_to_id == priv->id)
+			count++;
+	}
+	return count;
+}
+
+/*
+ * Maybe move an unsent Replier Unbind Event message to the main message list.
+ *
+ * Check if we have an unsent event on the set-aside list. If we do, move the
+ * first one across to our normal message queue.
+ *
+ * Returns 0 if all goes well, or a negative value if something went wrong.
+ */
+static int kbus_maybe_move_unsent_unbind_msg(struct kbus_private_data *priv)
+{
+	struct kbus_dev *dev = priv->dev;
+
+	struct kbus_unsent_message_item *ptr;
+	struct kbus_unsent_message_item *next;
+
+	kbus_maybe_dbg(dev,
+		       "%u Looking for an unsent unbind message\n", priv->id);
+
+	list_for_each_entry_safe(ptr, next, &dev->unsent_unbind_msg_list,
+				 list) {
+		int retval;
+
+		if (ptr->send_to_id != priv->id)
+			continue;
+
+		kbus_maybe_report_message(priv->dev, ptr->msg);
+		/*
+		 * Move the message into our normal message queue.
+		 *
+		 * We *must* use kbus_push_message() to do this, as
+		 * we wish to keep our promise that this shall be the
+		 * only way of adding a message to the queue.
+		 */
+		retval = kbus_push_message(priv, ptr->msg, ptr->binding, false);
+		if (retval)
+			return retval;	/* What else can we do? */
+
+		list_del(&ptr->list);
+		/* Mustn't forget to free *our* copy of the message */
+		kbus_free_message(ptr->msg);
+		kfree(ptr);
+		dev->unsent_unbind_msg_count--;
+		goto check_tragic;
+	}
+
+	/*
+	 * Since we didn't find anything, we can safely unset the flag that
+	 * says there might be something to find...
+	 */
+	priv->maybe_got_unsent_unbind_msgs = false;
+
+check_tragic:
+	/*
+	 * And if we've succeeded in emptying the list, we can unset the
+	 * "gone tragic" flag for it, too, if it was set.
+	 */
+	if (list_empty(&dev->unsent_unbind_msg_list))
+		dev->unsent_unbind_is_tragic = false;
+	return 0;
+}
+
+/*
+ * Forget any outstanding unsent Replier Unbind Event messages for this binding.
+ *
+ * Called from kbus_release.
+ */
+static void kbus_forget_unbound_unsent_unbind_msgs(
+					struct kbus_private_data *priv,
+					struct kbus_message_binding *binding)
+{
+	struct kbus_dev *dev = priv->dev;
+
+	struct kbus_unsent_message_item *ptr;
+	struct kbus_unsent_message_item *next;
+
+	u32 count = 0;
+
+	kbus_maybe_dbg(dev,
+		       " %u Forgetting unsent unbind messages for "
+		       "this binding\n", priv->id);
+
+	list_for_each_entry_safe(ptr, next, &dev->unsent_unbind_msg_list,
+			list) {
+		if (ptr->binding == binding) {
+			list_del(&ptr->list);
+			kbus_free_message(ptr->msg);
+			kfree(ptr);
+			dev->unsent_unbind_msg_count--;
+			count++;
+		}
+	}
+	kbus_maybe_dbg(dev, "%u Forgot %u unsent unbind messages\n",
+		       priv->id, count);
+	/*
+	 * And if we've succeeded in emptying the list, we can unset the
+	 * "gone tragic" flag for it, too, if it was set.
+	 */
+	if (list_empty(&dev->unsent_unbind_msg_list))
+		dev->unsent_unbind_is_tragic = false;
+}
+
+/*
+ * Forget any outstanding unsent Replier Unbind Event messages for this Replier.
+ *
+ * Called from kbus_release.
+ */
+static void kbus_forget_my_unsent_unbind_msgs(struct kbus_private_data *priv)
+{
+	struct kbus_dev *dev = priv->dev;
+
+	struct kbus_unsent_message_item *ptr;
+	struct kbus_unsent_message_item *next;
+
+	u32 count = 0;
+
+	kbus_maybe_dbg(dev,
+		       "%u Forgetting my unsent unbind messages\n", priv->id);
+
+	list_for_each_entry_safe(ptr, next, &dev->unsent_unbind_msg_list,
+			list) {
+		if (ptr->send_to_id == priv->id) {
+			list_del(&ptr->list);
+			kbus_free_message(ptr->msg);
+			kfree(ptr);
+			dev->unsent_unbind_msg_count--;
+			count++;
+		}
+	}
+	kbus_maybe_dbg(dev, "%u Forgot %u unsent unbind messages\n",
+		       priv->id, count);
+	/*
+	 * And if we've succeeded in emptying the list, we can unset the
+	 * "gone tragic" flag for it, too, if it was set.
+	 */
+	if (list_empty(&dev->unsent_unbind_msg_list))
+		dev->unsent_unbind_is_tragic = false;
+}
+
+/*
+ * Forget any outstanding unsent Replier Unbind Event messages.
+ *
+ * Assumed to be called because the device is closing, and thus doesn't lock,
+ * or worry about lost messages.
+ */
+static void kbus_forget_unsent_unbind_msgs(struct kbus_dev *dev)
+{
+	struct kbus_unsent_message_item *ptr;
+	struct kbus_unsent_message_item *next;
+
+	kbus_maybe_dbg(dev,
+		       "  Forgetting unsent unbind event messages\n");
+
+	list_for_each_entry_safe(ptr, next, &dev->unsent_unbind_msg_list,
+			list) {
+
+		if (!kbus_message_name_matches(
+					    ptr->msg->name_ref->name,
+					    ptr->msg->name_len,
+					    KBUS_MSG_NAME_REPLIER_BIND_EVENT))
+			kbus_maybe_report_message(dev, ptr->msg);
+
+		list_del(&ptr->list);
+		kbus_free_message(ptr->msg);
+		kfree(ptr);
+		dev->unsent_unbind_msg_count--;
+	}
+}
+
+/*
  * Remove all bindings for a particular listener.
  *
  * Called from kbus_release, which will itself handle removing messages
@@ -1885,8 +2263,8 @@ static void kbus_forget_my_bindings(struct kbus_private_data *priv)
 			       ptr->name_len, ptr->name);
 
 		if (ptr->is_replier && dev->report_replier_binds)
-			kbus_report_unbinding(priv, ptr->name_len,
-					      ptr->name);
+			kbus_safe_report_unbinding(priv, ptr->name_len,
+							 ptr->name);
 
 		list_del(&ptr->list);
 		kfree(ptr->name);
@@ -2088,6 +2466,8 @@ static int kbus_release(struct inode *inode __always_unused, struct file *filp)
 
 	kbus_empty_message_queue(priv);
 	kbus_forget_my_bindings(priv);
+	if (priv->maybe_got_unsent_unbind_msgs)
+		kbus_forget_my_unsent_unbind_msgs(priv);
 	kbus_empty_replies_unsent(priv);
 	retval2 = kbus_forget_open_ksock(dev, priv->id);
 	kfree(priv);
@@ -2933,6 +3313,7 @@ static int kbus_unbind(struct kbus_private_data *priv,
 	int retval = 0;
 	struct kbus_bind_request *bind;
 	char *name = NULL;
+	u32 old_message_count = priv->message_count;
 
 	bind = kmalloc(sizeof(*bind), GFP_KERNEL);
 	if (!bind)
@@ -2975,6 +3356,36 @@ static int kbus_unbind(struct kbus_private_data *priv,
 	retval = kbus_forget_binding(dev, priv,
 				     bind->is_replier, bind->name_len, name);
 
+	/*
+	 * If we're unbinding from $.KBUS.ReplierBindEvent, and there
+	 * are (or may be) any such kept for us on the unread Replier
+	 * Unbind Event list, then we need to remove them as well...
+	 *
+	 * NOTE that the following only checks for exact matchs to
+	 * $.KBUS.ReplierBindEvent, which should be sufficient...
+	 */
+	if (priv->maybe_got_unsent_unbind_msgs &&
+	    !strcmp(name, KBUS_MSG_NAME_REPLIER_BIND_EVENT))
+		kbus_forget_my_unsent_unbind_msgs(priv);
+
+	/*
+	 * If that removed any messages from the message queue, then we have
+	 * room to consider moving a message across from the unread Replier
+	 * Unbind Event list
+	 */
+	if (priv->message_count < old_message_count &&
+	    priv->maybe_got_unsent_unbind_msgs) {
+		int rv = kbus_maybe_move_unsent_unbind_msg(priv);
+		/* If this fails, we're probably stumped */
+		if (rv)
+			/* The best we can do is grumble gently. We still
+			 * want to return retval, not rv.
+			 */
+			dev_err(priv->dev->dev,
+			       "Failed to move unsent messages on "
+			       "unbind (error %d)\n", -rv);
+	}
+
 done:
 	kfree(name);
 	kfree(bind);
@@ -3140,6 +3551,21 @@ static int kbus_nextmsg(struct kbus_private_data *priv,
 			return retval;
 	}
 
+	/*
+	 * If we (maybe) have any unread Replier Unbind Event messages,
+	 * we now have room to copy one across to the message list
+	 */
+	kbus_maybe_dbg(priv->dev,
+		       "  ++ maybe_got_unsent_unbind_msgs %d\n",
+		       priv->maybe_got_unsent_unbind_msgs);
+
+	if (priv->maybe_got_unsent_unbind_msgs) {
+		retval = kbus_maybe_move_unsent_unbind_msg(priv);
+		/* If this fails, we're probably stumped */
+		if (retval)
+			return retval;
+	}
+
 	retval = __put_user(KBUS_ENTIRE_MSG_LEN(msg->name_len, msg->data_len),
 			    (u32 __user *) arg);
 	if (retval)
@@ -3567,6 +3993,12 @@ static int kbus_nummsgs(struct kbus_private_data *priv,
 {
 	u32 count = priv->message_count;
 
+	if (priv->maybe_got_unsent_unbind_msgs) {
+		kbus_maybe_dbg(dev, "%u NUMMSGS 'main' count %u\n",
+			       priv->id, count);
+		count += kbus_count_unsent_unbind_msgs(priv);
+	}
+
 	kbus_maybe_dbg(dev, "%u NUMMSGS %u\n", priv->id, count);
 
 	return __put_user(count, (u32 __user *) arg);
@@ -4059,6 +4491,7 @@ static void kbus_setup_cdev(struct kbus_dev *dev, int devno)
 	 */
 	INIT_LIST_HEAD(&dev->bound_message_list);
 	INIT_LIST_HEAD(&dev->open_ksock_list);
+	INIT_LIST_HEAD(&dev->unsent_unbind_msg_list);
 
 	init_waitqueue_head(&dev->write_wait);
 
@@ -4078,6 +4511,7 @@ static void kbus_teardown_cdev(struct kbus_dev *dev)
 {
 	kbus_forget_all_bindings(dev);
 	kbus_forget_all_open_ksocks(dev);
+	kbus_forget_unsent_unbind_msgs(dev);
 
 	cdev_del(&dev->cdev);
 }
-- 
1.7.4.1


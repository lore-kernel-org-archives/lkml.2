Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305Ab1CRRpq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 13:45:46 -0400
Received: from mail6.webfaction.com ([74.55.86.74]:60223 "EHLO
	smtp.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932253Ab1CRRpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 13:45:32 -0400
From: Tony Ibbs <tibs@tonyibbs.co.uk>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Linux-embedded <linux-embedded@vger.kernel.org>,
        Tibs at Kynesim <tibs@kynesim.co.uk>,
        Richard Watts <rrw@kynesim.co.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        Tony Ibbs <tibs@tonyibbs.co.uk>
Subject: [PATCH 06/11] KBUS add ability to receive messages only once
Date: Fri, 18 Mar 2011 17:21:15 +0000
Message-Id: <023b39071aff3abc8e63336be501742333ceeced.1300450604.git.tibs@tonyibbs.co.uk>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <e1e0c80ed995eccd4881081f5a769acb148b267b.1300450604.git.tibs@tonyibbs.co.uk>
References: <cover.1300450604.git.tibs@tonyibbs.co.uk>
 <273ee9658cbcbe19adfa0d7b30082d8966e70afc.1300450604.git.tibs@tonyibbs.co.uk>
 <979f23cd5f8a9ac727f17ad359ee487cbccbf7f6.1300450604.git.tibs@tonyibbs.co.uk>
 <c28914a66ae5526f18c331475298e7ef05bf57c7.1300450604.git.tibs@tonyibbs.co.uk>
 <ffc9b735a3b61c51881c108235155384a6e6f56c.1300450604.git.tibs@tonyibbs.co.uk>
 <e1e0c80ed995eccd4881081f5a769acb148b267b.1300450604.git.tibs@tonyibbs.co.uk>
In-Reply-To: <cover.1300450604.git.tibs@tonyibbs.co.uk>
References: <cover.1300450604.git.tibs@tonyibbs.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes a recipient has bound to a message name more than once,
but only wants to receive one copy of each message matching those
bindings.

Signed-off-by: Tony Ibbs <tibs@tonyibbs.co.uk>
---
 include/linux/kbus_defns.h |   18 +++++++---
 ipc/kbus_internal.h        |   30 ++++++++++++++++
 ipc/kbus_main.c            |   82 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 125 insertions(+), 5 deletions(-)

diff --git a/include/linux/kbus_defns.h b/include/linux/kbus_defns.h
index d43c498..9da72e4 100644
--- a/include/linux/kbus_defns.h
+++ b/include/linux/kbus_defns.h
@@ -581,13 +581,21 @@ struct kbus_replier_bind_event_data {
  * retval: 0 for success, negative for failure
  */
 #define KBUS_IOC_UNREPLIEDTO _IOR(KBUS_IOC_MAGIC, 13, char *)
-
 /*
- * IOCTL 14 is not used, because it is introduced in the next revision,
- * (obviously, in real history this was done in a different order) and
- * I don't want to alter the number for VERBOSE.
+ * MSGONLYONCE - should we receive a message only once?
+ *
+ * This IOCTL tells a Ksock whether it should only receive a particular message
+ * once, even if it is both a Replier and Listener for the message (in which
+ * case it will always get the message as Replier, if appropriate), or if it is
+ * registered as multiple Listeners for the message.
+ *
+ * arg(in): __u32, 1 to change to "only once", 0 to change to the default,
+ * 0xFFFFFFFF to just return the current/previous state.
+ * arg(out): __u32, the previous state.
+ * retval: 0 for success, negative for failure (-EINVAL if arg in was not one
+ * of the specified values)
  */
-
+#define KBUS_IOC_MSGONLYONCE  _IOWR(KBUS_IOC_MAGIC, 14, char *)
 /*
  * VERBOSE - should KBUS output verbose "printk" messages (for this device)?
  *
diff --git a/ipc/kbus_internal.h b/ipc/kbus_internal.h
index 2d9e737..28c153c 100644
--- a/ipc/kbus_internal.h
+++ b/ipc/kbus_internal.h
@@ -534,6 +534,36 @@ struct kbus_private_data {
 	 * In fact, the 'outstanding_requests' list is used, simply because
 	 * it was implemented first.
 	 */
+
+	/*
+	 * By default, if a Ksock binds to a message name as both Replier and
+	 * Listener (typically by binding to a specific message name as Replier
+	 * and to a wildcard including it as Listener), and a Reqest of that
+	 * name is sent to that Ksock, it will get the message once as Replier
+	 * (marked "WANT_YOU_TO_REPLY"), and once as listener.
+	 *
+	 * This is technically sensible, but can be irritating to the end user
+	 * who really often only wants to receive the message once.
+	 *
+	 * If "messages_only_once" is set, then when a message is about to be
+	 * put onto a Ksocks message queue, it will only be added if it (i.e.,
+	 * a message with the same id) has not already just been added. This
+	 * is safe because Requests to the specific Replier are always dealt
+	 * with first.
+	 *
+	 * As a side-effect, which I think also makes sense, this will also
+	 * mean that if a Listener has bound to the same message name multiple
+	 * times (as a Listener), then they will only get the message once.
+	 */
+	int messages_only_once;
+	/*
+	 * Messages can be added to either end of our message queue (i.e.,
+	 * depending on whether they're urgent or not). This means that the
+	 * "only once" mechanism needs to check both ends of the queue (which
+	 * is a pain). Or we can just remember the message id of the last
+	 * message pushed onto the queue. Which is much simpler.
+	 */
+	struct kbus_msg_id msg_id_just_pushed;
 };
 
 /* What is a sensible number for the default maximum number of messages? */
diff --git a/ipc/kbus_main.c b/ipc/kbus_main.c
index 944b60c..a75d2e1 100644
--- a/ipc/kbus_main.c
+++ b/ipc/kbus_main.c
@@ -851,6 +851,46 @@ static int kbus_push_message(struct kbus_private_data *priv,
 		       "  %u Pushing message onto queue (%s)\n",
 		       priv->id, for_replier ? "replier" : "listener");
 
+	/*
+	 * 1. Check to see if this Ksock has the "only one copy
+	 *    of a message" flag set.
+	 * 2. If it does, check if our message (id) is already on
+	 *    the queue, and if it is, just skip adding it.
+	 *
+	 * (this means if the Ksock was destined to get the message
+	 * several times, either as Replier and Listener, or as
+	 * multiple Listeners to the same message name, it will only
+	 * get it once, for this "push")
+	 *
+	 * If "for_replier" is set we necessarily push the message - see below.
+	 */
+	if (priv->messages_only_once && !for_replier) {
+		/*
+		 * 1. We've been asked to only send one copy of a message
+		 *    to each Ksock that should receive it.
+		 * 2. This is not a Reply (to our Ksock) or a Request (to
+		 *    our Ksock as Replier)
+		 *
+		 * So, given that, has a message with that id already been
+		 * added to the message queue?
+		 *
+		 * (Note that if a message would be included because of
+		 * multiple message name bindings, we do not say anything
+		 * about which binding we will actually add the message
+		 * for - so unbinding later on may or may not cause a
+		 * message to go away, in this case.)
+		 */
+		if (kbus_same_message_id(&priv->msg_id_just_pushed,
+					 msg->id.network_id,
+					 msg->id.serial_num)) {
+			kbus_maybe_dbg(priv->dev,
+				       "  %u Ignoring message "
+				       "under 'once only' rule\n",
+				       priv->id);
+			return 0;
+		}
+	}
+
 	new_msg = kbus_copy_message(priv->dev, msg);
 	if (!new_msg)
 		return -EFAULT;
@@ -898,6 +938,7 @@ static int kbus_push_message(struct kbus_private_data *priv,
 	}
 
 	priv->message_count++;
+	priv->msg_id_just_pushed = msg->id;
 
 	if (!kbus_same_message_id(&msg->in_reply_to, 0, 0)) {
 		/*
@@ -3243,6 +3284,36 @@ static int kbus_nummsgs(struct kbus_private_data *priv,
 	return __put_user(count, (u32 __user *) arg);
 }
 
+static int kbus_onlyonce(struct kbus_private_data *priv,
+			 unsigned long arg)
+{
+	int retval = 0;
+	u32 only_once;
+	int old_value = priv->messages_only_once;
+
+	retval = __get_user(only_once, (u32 __user *) arg);
+	if (retval)
+		return retval;
+
+	kbus_maybe_dbg(priv->dev, "%u ONLYONCE requests %u (was %d)\n",
+		       priv->id, only_once, old_value);
+
+	switch (only_once) {
+	case 0:
+		priv->messages_only_once = false;
+		break;
+	case 1:
+		priv->messages_only_once = true;
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
 static int kbus_set_verbosity(struct kbus_private_data *priv,
 			      unsigned long arg)
 {
@@ -3439,6 +3510,17 @@ static long kbus_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 				(u32 __user *) arg);
 		break;
 
+	case KBUS_IOC_MSGONLYONCE:
+		/*
+		 * Should we receive a given message only once?
+		 *
+		 * arg in: 0 (for no), 1 (for yes), 0xFFFFFFFF (for query)
+		 * arg out: the previous value, before we were called
+		 * return: 0 means OK, otherwise not OK
+		 */
+		retval = kbus_onlyonce(priv, arg);
+		break;
+
 	case KBUS_IOC_VERBOSE:
 		/*
 		 * Should we output verbose/debug messages?
-- 
1.7.4.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932369Ab1CRRpf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 13:45:35 -0400
Received: from mail6.webfaction.com ([74.55.86.74]:60088 "EHLO
	smtp.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757198Ab1CRRp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 13:45:27 -0400
X-Greylist: delayed 1436 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Mar 2011 13:45:27 EDT
From: Tony Ibbs <tibs@tonyibbs.co.uk>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Linux-embedded <linux-embedded@vger.kernel.org>,
        Tibs at Kynesim <tibs@kynesim.co.uk>,
        Richard Watts <rrw@kynesim.co.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        Tony Ibbs <tibs@tonyibbs.co.uk>
Subject: [PATCH 05/11] KBUS add support for messages
Date: Fri, 18 Mar 2011 17:21:14 +0000
Message-Id: <e1e0c80ed995eccd4881081f5a769acb148b267b.1300450604.git.tibs@tonyibbs.co.uk>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <ffc9b735a3b61c51881c108235155384a6e6f56c.1300450604.git.tibs@tonyibbs.co.uk>
References: <cover.1300450604.git.tibs@tonyibbs.co.uk>
 <273ee9658cbcbe19adfa0d7b30082d8966e70afc.1300450604.git.tibs@tonyibbs.co.uk>
 <979f23cd5f8a9ac727f17ad359ee487cbccbf7f6.1300450604.git.tibs@tonyibbs.co.uk>
 <c28914a66ae5526f18c331475298e7ef05bf57c7.1300450604.git.tibs@tonyibbs.co.uk>
 <ffc9b735a3b61c51881c108235155384a6e6f56c.1300450604.git.tibs@tonyibbs.co.uk>
In-Reply-To: <cover.1300450604.git.tibs@tonyibbs.co.uk>
References: <cover.1300450604.git.tibs@tonyibbs.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the code that actually allows KBUS to send
and receive messages.

Signed-off-by: Tony Ibbs <tibs@tonyibbs.co.uk>
---
 ipc/kbus_main.c | 2766 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 2743 insertions(+), 23 deletions(-)

diff --git a/ipc/kbus_main.c b/ipc/kbus_main.c
index 87c7506..944b60c 100644
--- a/ipc/kbus_main.c
+++ b/ipc/kbus_main.c
@@ -65,6 +65,10 @@ static int kbus_num_devices = CONFIG_KBUS_DEF_NUM_DEVICES;
 static int kbus_major;	/* 0 => We'll go for dynamic allocation */
 static int kbus_minor;	/* 0 => We're happy to start with device 0 */
 
+/* We can't need more than 8 characters of padding, by definition! */
+static char *static_zero_padding = "\0\0\0\0\0\0\0\0";
+static u32 static_end_guard = KBUS_MSG_END_GUARD;
+
 /* Our actual devices, 0 through kbus_num_devices-1 */
 static struct kbus_dev **kbus_devices;
 
@@ -72,9 +76,21 @@ static struct class *kbus_class_p;
 
 /* ========================================================================= */
 
+/* As few foreshadowings as I can get away with */
+static struct kbus_private_data *kbus_find_open_ksock(struct kbus_dev *dev,
+						      u32 id);
+
 /* I really want this function where it is in the code, so need to foreshadow */
 static int kbus_setup_new_device(int which);
 
+/* More or less ditto */
+static int kbus_write_to_recipients(struct kbus_private_data *priv,
+				    struct kbus_dev *dev,
+				    struct kbus_msg *msg);
+
+static int kbus_alloc_ref_data(struct kbus_private_data *priv,
+			       u32 data_len,
+			       struct kbus_data_ptr **ret_ref_data);
 /* ========================================================================= */
 
 /* What's the symbolic name of a replier type? */
@@ -93,6 +109,376 @@ static const char *kbus_replier_type_name(enum kbus_replier_type t)
 }
 
 /*
+ * Wrap a set of data pointers and lengths in a reference
+ */
+static struct kbus_data_ptr *kbus_wrap_data_in_ref(int as_pages,
+						   unsigned num_parts,
+						   unsigned long *parts,
+						   unsigned *lengths,
+						   unsigned last_page_len)
+{
+	struct kbus_data_ptr *new = NULL;
+
+	new = kmalloc(sizeof(*new), GFP_KERNEL);
+	if (!new)
+		return NULL;
+
+	new->as_pages = as_pages;
+	new->parts = parts;
+	new->lengths = lengths;
+	new->num_parts = num_parts;
+	new->last_page_len = last_page_len;
+
+	kref_init(&new->refcount);
+	return new;
+}
+
+/*
+ * Increment the reference count for our pointer.
+ *
+ * Returns the (same) reference, for convenience.
+ */
+static struct kbus_data_ptr *kbus_raise_data_ref(struct kbus_data_ptr *refdata)
+{
+	if (refdata != NULL)
+		kref_get(&refdata->refcount);
+	return refdata;
+}
+
+/*
+ * Data release callback for data reference pointers. Called when the reference
+ * count says to...
+ */
+static void kbus_release_data_ref(struct kref *ref)
+{
+	struct kbus_data_ptr *refdata = container_of(ref,
+						     struct kbus_data_ptr,
+						     refcount);
+	if (refdata->parts == NULL) {
+		/* Not that I think this can happen */
+		pr_err("kbus: Removing data reference,"
+		       " but data ptr already freed\n");
+	} else {
+		int jj;
+		if (refdata->as_pages)
+			for (jj = 0; jj < refdata->num_parts; jj++)
+				free_page((unsigned long)refdata->parts[jj]);
+		else
+			for (jj = 0; jj < refdata->num_parts; jj++)
+				kfree((void *)refdata->parts[jj]);
+		kfree(refdata->parts);
+		kfree(refdata->lengths);
+		refdata->parts = NULL;
+		refdata->lengths = NULL;
+	}
+	kfree(refdata);
+}
+
+/*
+ * Forget a reference to our pointer, and if no-one cares anymore, free it and
+ * its contents.
+ */
+static void kbus_lower_data_ref(struct kbus_data_ptr *refdata)
+{
+	if (refdata == NULL)
+		return;
+	kref_put(&refdata->refcount, kbus_release_data_ref);
+}
+
+/*
+ * Wrap a string in a reference. Does not take a copy of the string,
+ * but note that the release mechanism (triggered when there are no more
+ * references to the string) *will* free it.
+ */
+static struct kbus_name_ptr *kbus_wrap_name_in_ref(char *str)
+{
+	struct kbus_name_ptr *new = NULL;
+
+	new = kmalloc(sizeof(*new), GFP_KERNEL);
+	if (!new)
+		return NULL;
+
+	new->name = str;
+	kref_init(&new->refcount);
+	return new;
+}
+
+/*
+ * Increment the reference count for a string reference
+ *
+ * Returns the (same) reference, for convenience.
+ */
+static struct kbus_name_ptr *kbus_raise_name_ref(struct kbus_name_ptr *refname)
+{
+	if (refname != NULL)
+		kref_get(&refname->refcount);
+	return refname;
+}
+
+/*
+ * Data release callback for string reference pointers.
+ * Called when the reference count says to...
+ */
+static void kbus_release_name_ref(struct kref *ref)
+{
+	struct kbus_name_ptr *refname = container_of(ref,
+						     struct kbus_name_ptr,
+						     refcount);
+	if (refname->name == NULL) {
+		/* Not that I think this can happen */
+		pr_err("kbus: Removing name reference,"
+		       " but name ptr already freed\n");
+	} else {
+		kfree(refname->name);
+		refname->name = NULL;
+	}
+	kfree(refname);
+}
+
+/*
+ * Forget a reference to our string, and if no-one cares anymore, free it and
+ * its contents.
+ */
+static void kbus_lower_name_ref(struct kbus_name_ptr *refname)
+{
+	if (refname == NULL)
+		return;
+
+	kref_put(&refname->refcount, kbus_release_name_ref);
+}
+
+/*
+ * Return a stab at the next size for an array
+ */
+static u32 kbus_next_size(u32 old_size)
+{
+	if (old_size < 16)
+		/* For very small numbers, just double */
+		return old_size << 1;
+	/* Otherwise, try something like the mechanism used for Python
+	 * lists - doubling feels a bit over the top */
+	return old_size + (old_size >> 3);
+}
+
+/* Determine (and return) the next message serial number */
+static u32 kbus_next_serial_num(struct kbus_dev *dev)
+{
+	if (dev->next_msg_serial_num == 0)
+		dev->next_msg_serial_num++;
+	return dev->next_msg_serial_num++;
+}
+
+static int kbus_same_message_id(struct kbus_msg_id *msg_id,
+				u32 network_id, u32 serial_num)
+{
+	return msg_id->network_id == network_id &&
+	    msg_id->serial_num == serial_num;
+}
+
+static int kbus_init_msg_id_memory(struct kbus_private_data *priv)
+{
+	struct kbus_msg_id_mem *mem = &priv->outstanding_requests;
+	struct kbus_msg_id *ids;
+
+	ids = kmalloc(sizeof(*ids) * KBUS_INIT_MSG_ID_MEMSIZE, GFP_KERNEL);
+	if (!ids)
+		return -ENOMEM;
+
+	memset(ids, 0, sizeof(*ids) * KBUS_INIT_MSG_ID_MEMSIZE);
+
+	mem->count = 0;
+	mem->max_count = 0;
+	mem->ids = ids;
+	mem->size = KBUS_INIT_MSG_ID_MEMSIZE;
+	return 0;
+}
+
+static void kbus_empty_msg_id_memory(struct kbus_private_data *priv)
+{
+	struct kbus_msg_id_mem *mem = &priv->outstanding_requests;
+
+	if (mem->ids == NULL)
+		return;
+
+	kfree(mem->ids);
+	mem->ids = NULL;
+	mem->size = 0;
+	mem->max_count = 0;
+	mem->count = 0;
+}
+
+/*
+ * Note we don't worry about whether the id is already in there - if
+ * the user cares, that's up to them (I don't think I do)
+ */
+static int kbus_remember_msg_id(struct kbus_private_data *priv,
+				struct kbus_msg_id *id)
+{
+	struct kbus_msg_id_mem *mem = &priv->outstanding_requests;
+	int ii, which;
+
+	kbus_maybe_dbg(priv->dev, "  %u Remembering outstanding"
+		       " request %u:%u (count->%d)\n",
+		       priv->id, id->network_id, id->serial_num, mem->count+1);
+
+	/* First, try for an empty slot we can re-use */
+	for (ii = 0; ii < mem->size; ii++) {
+		if (kbus_same_message_id(&mem->ids[ii], 0, 0)) {
+			which = ii;
+			goto done;
+		}
+
+	}
+	/* Otherwise, give in and use a new one */
+	if (mem->count == mem->size) {
+		u32 old_size = mem->size;
+		u32 new_size = kbus_next_size(old_size);
+
+		kbus_maybe_dbg(priv->dev, "  %u XXX outstanding"
+			       " request array size %u -> %u\n",
+			       priv->id, old_size, new_size);
+
+		mem->ids = krealloc(mem->ids,
+				    new_size * sizeof(struct kbus_msg_id),
+				    GFP_KERNEL);
+		if (!mem->ids)
+			return -EFAULT;
+		for (ii = old_size; ii < new_size; ii++) {
+			mem->ids[ii].network_id = 0;
+			mem->ids[ii].serial_num = 0;
+		}
+		mem->size = new_size;
+		which = mem->count;
+	}
+	which = mem->count;
+done:
+	mem->ids[which] = *id;
+	mem->count++;
+	if (mem->count > mem->max_count)
+		mem->max_count = mem->count;
+	return 0;
+}
+
+/* Returns 0 if we found it, -1 if we couldn't find it */
+static int kbus_find_msg_id(struct kbus_private_data *priv,
+			    struct kbus_msg_id *id)
+{
+	struct kbus_msg_id_mem *mem = &priv->outstanding_requests;
+	int ii;
+	for (ii = 0; ii < mem->size; ii++) {
+		if (!kbus_same_message_id(&mem->ids[ii],
+					  id->network_id, id->serial_num))
+			continue;
+		kbus_maybe_dbg(priv->dev, "  %u Found outstanding "
+			       "request %u:%u (count=%d)\n",
+			       priv->id, id->network_id,
+			       id->serial_num, mem->count);
+		return 0;
+	}
+	kbus_maybe_dbg(priv->dev,
+		       "  %u Could not find outstanding "
+		       "request %u:%u (count=%d)\n",
+		       priv->id, id->network_id,
+		       id->serial_num, mem->count);
+	return -1;
+}
+
+/* Returns 0 if we found and forgot it, -1 if we couldn't find it */
+static int kbus_forget_msg_id(struct kbus_private_data *priv,
+			      struct kbus_msg_id *id)
+{
+	struct kbus_msg_id_mem *mem = &priv->outstanding_requests;
+	int ii;
+	for (ii = 0; ii < mem->size; ii++) {
+		if (!kbus_same_message_id(&mem->ids[ii],
+					 id->network_id, id->serial_num))
+			continue;
+
+		mem->ids[ii].network_id = 0;
+		mem->ids[ii].serial_num = 0;
+		mem->count--;
+		kbus_maybe_dbg(priv->dev,
+			       "  %u Forgot outstanding "
+			       "request %u:%u (count<-%d)\n",
+			       priv->id, id->network_id,
+			       id->serial_num, mem->count);
+
+		return 0;
+	}
+	kbus_maybe_dbg(priv->dev,
+		       "  %u Could not forget outstanding "
+		       "request %u:%u (count<-%d)\n",
+		       priv->id, id->network_id,
+		       id->serial_num, mem->count);
+	return -1;
+}
+
+/* A message is a reply iff 'in_reply_to' is non-zero */
+static int kbus_message_is_reply(struct kbus_msg *msg)
+{
+	return !kbus_same_message_id(&msg->in_reply_to, 0, 0);
+}
+
+/*
+ * Build a KBUS synthetic message/exception. We assume no data.
+ *
+ * The message built is a 'pointy' message.
+ *
+ * 'msg_name' is copied.
+ *
+ * Use kbus_free_message() to free this message when it is finished with.
+ */
+static struct kbus_msg
+*kbus_build_kbus_message(struct kbus_dev *dev,
+			 char *msg_name,
+			 u32 from,
+			 u32 to, struct kbus_msg_id in_reply_to)
+{
+	struct kbus_msg *new_msg;
+	struct kbus_name_ptr *name_ref;
+
+	size_t msg_name_len = strlen(msg_name);
+	char *msg_name_copy;
+
+	new_msg = kmalloc(sizeof(*new_msg), GFP_KERNEL);
+	if (!new_msg) {
+		dev_err(dev->dev, "Cannot kmalloc synthetic message\n");
+		return NULL;
+	}
+
+	msg_name_copy = kmalloc(msg_name_len + 1, GFP_KERNEL);
+	if (!msg_name_copy) {
+		dev_err(dev->dev, "Cannot kmalloc synthetic message's name\n");
+		kfree(new_msg);
+		return NULL;
+	}
+
+	strncpy(msg_name_copy, msg_name, msg_name_len);
+	msg_name_copy[msg_name_len] = '\0';
+
+	name_ref = kbus_wrap_name_in_ref(msg_name_copy);
+	if (!name_ref) {
+		dev_err(dev->dev, "Cannot kmalloc synthetic message's string ref\n");
+		kfree(new_msg);
+		kfree(msg_name_copy);
+		return NULL;
+	}
+
+	memset(new_msg, 0, sizeof(*new_msg));
+
+	new_msg->from = from;
+	new_msg->to = to;
+	new_msg->in_reply_to = in_reply_to;
+	new_msg->flags = KBUS_BIT_SYNTHETIC;
+	new_msg->name_ref = name_ref;
+	new_msg->name_len = msg_name_len;
+
+	new_msg->id.serial_num = kbus_next_serial_num(dev);
+
+	return new_msg;
+}
+
+/*
  * Given a message name, is it valid?
  *
  * We have nothing to say on maximum length.
@@ -130,6 +516,682 @@ static int kbus_bad_message_name(char *name, size_t name_len)
 }
 
 /*
+ * Is a message name wildcarded?
+ *
+ * We assume it is already checked to be a valid name
+ *
+ * Returns 1 if it is, 0 if not. In other words, returns 1
+ * if the name is not a valid destination.
+ */
+static int kbus_wildcarded_message_name(char *name, size_t name_len)
+{
+	return name[name_len - 1] == '*' || name[name_len - 1] == '%';
+}
+
+/*
+ * Is a message name legitimate for writing/sending?
+ *
+ * This is an omnibus call of the last two checks, with error output.
+ *
+ * Returns 0 if it's OK, 1 if it's naughty
+ */
+static int kbus_invalid_message_name(struct kbus_dev *dev,
+				     char *name, size_t name_len)
+{
+	if (kbus_bad_message_name(name, name_len)) {
+		dev_err(dev->dev, "pid %u [%s]"
+		       " (send) message name '%.*s' is not allowed\n",
+		       current->pid, current->comm, (int)name_len, name);
+		return 1;
+	}
+	if (kbus_wildcarded_message_name(name, name_len)) {
+		dev_err(dev->dev, "pid %u [%s]"
+		       " (send) sending to wildcards not allowed, "
+		       "message name '%.*s'\n",
+		       current->pid, current->comm, (int)name_len, name);
+		return 1;
+	}
+	return 0;
+}
+
+/*
+ * Does this message name match the given binding?
+ *
+ * The binding may be a normal message name, or a wildcard.
+ *
+ * We assume that both names are legitimate.
+ */
+static int kbus_message_name_matches(char *name, size_t name_len, char *other)
+{
+	size_t other_len = strlen(other);
+
+	if (other[other_len - 1] == '*' || other[other_len - 1] == '%') {
+		char *rest = name + other_len - 1;
+		size_t rest_len = name_len - other_len + 1;
+
+		/*
+		 * If we have '$.Fred.*', then we need at least '$.Fred.X'
+		 * to match
+		 */
+		if (name_len < other_len)
+			return false;
+		/*
+		 * Does the name match all of the wildcard except the
+		 * last character?
+		 */
+		if (strncmp(other, name, other_len - 1))
+			return false;
+
+		/* '*' matches anything at all, so we're done */
+		if (other[other_len - 1] == '*')
+			return true;
+
+		/* '%' only matches if we don't have another dot */
+		if (strnchr(rest, rest_len, '.'))
+			return false;
+		else
+			return true;
+	} else {
+		if (name_len != other_len)
+			return false;
+		else
+			return !strncmp(name, other, name_len);
+	}
+}
+
+/*
+ * Check if a message read by kbus_write() is well formed
+ *
+ * Return 0 if a message is well-formed, negative otherwise.
+ */
+static int kbus_check_message_written(struct kbus_dev *dev,
+				      struct kbus_write_msg *this)
+{
+	struct kbus_message_header *user_msg =
+	    (struct kbus_message_header *)&this->user_msg;
+
+	if (this == NULL) {
+		dev_err(dev->dev, "pid %u [%s]"
+		       " Tried to check NULL message\n",
+		       current->pid, current->comm);
+		return -EINVAL;
+	}
+
+	if (user_msg->start_guard != KBUS_MSG_START_GUARD) {
+		dev_err(dev->dev, "pid %u [%s]"
+		       " message start guard is %08x, not %08x",
+		       current->pid, current->comm,
+		       user_msg->start_guard, KBUS_MSG_START_GUARD);
+		return -EINVAL;
+	}
+	if (user_msg->end_guard != KBUS_MSG_END_GUARD) {
+		dev_err(dev->dev, "pid %u [%s]"
+		       " message end guard is %08x, not %08x\n",
+		       current->pid, current->comm,
+		       user_msg->end_guard, KBUS_MSG_END_GUARD);
+		return -EINVAL;
+	}
+
+	if (user_msg->name_len == 0) {
+		dev_err(dev->dev, "pid %u [%s]"
+		       " Message name length is 0\n",
+		       current->pid, current->comm);
+		return -EINVAL;
+	}
+	if (user_msg->name_len > KBUS_MAX_NAME_LEN) {
+		dev_err(dev->dev, "pid %u [%s]"
+		       " Message name length is %u, more than %u\n",
+		       current->pid, current->comm,
+		       user_msg->name_len, KBUS_MAX_NAME_LEN);
+		return -ENAMETOOLONG;
+	}
+
+	if (user_msg->name == NULL) {
+		if (user_msg->data != NULL) {
+			dev_err(dev->dev, "pid %u [%s]"
+			       " Message name is inline, data is not\n",
+			       current->pid, current->comm);
+			return -EINVAL;
+		}
+	} else {
+		if (user_msg->data == NULL && user_msg->data_len != 0) {
+			dev_err(dev->dev, "pid %u [%s]"
+			       " Message data is inline, name is not\n",
+			       current->pid, current->comm);
+			return -EINVAL;
+		}
+	}
+
+	if (user_msg->data_len == 0 && user_msg->data != NULL) {
+		dev_err(dev->dev, "pid %u [%s]"
+		       " Message data length is 0, but data pointer is set\n",
+		       current->pid, current->comm);
+		return -EINVAL;
+	}
+
+	/* It's not legal to set both ALL_OR_WAIT and ALL_OR_FAIL */
+	if ((user_msg->flags & KBUS_BIT_ALL_OR_WAIT) &&
+	    (user_msg->flags & KBUS_BIT_ALL_OR_FAIL)) {
+		dev_err(dev->dev, "pid %u [%s]"
+		       " Message cannot have both ALL_OR_WAIT and "
+		       "ALL_OR_FAIL set\n",
+		       current->pid, current->comm);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+/*
+ * Output a description of an in-kernel message
+ */
+static void kbus_maybe_report_message(struct kbus_dev *dev __maybe_unused,
+				      struct kbus_msg *msg __maybe_unused)
+{
+	if (msg->data_len) {
+		struct kbus_data_ptr *data_p = msg->data_ref;
+		uint8_t *part0 __maybe_unused = (uint8_t *) data_p->parts[0];
+		kbus_maybe_dbg(dev, "=== %u:%u '%.*s'"
+		       " to %u from %u in-reply-to %u:%u orig %u,%u "
+		       "final %u:%u flags %04x:%04x"
+		       " data/%u<in%u> %02x.%02x.%02x.%02x\n",
+		       msg->id.network_id, msg->id.serial_num,
+		       msg->name_len, msg->name_ref->name,
+		       msg->to, msg->from,
+		       msg->in_reply_to.network_id, msg->in_reply_to.serial_num,
+		       msg->orig_from.network_id, msg->orig_from.local_id,
+		       msg->final_to.network_id, msg->final_to.local_id,
+		       (msg->flags & 0xFFFF0000) >> 4,
+		       (msg->flags & 0x0000FFFF), msg->data_len,
+		       data_p->num_parts, part0[0], part0[1], part0[2],
+		       part0[3]);
+	} else {
+		kbus_maybe_dbg(dev, "=== %u:%u '%.*s'"
+		       " to %u from %u in-reply-to %u:%u orig %u,%u "
+		       "final %u,%u flags %04x:%04x\n",
+		       msg->id.network_id, msg->id.serial_num,
+		       msg->name_len, msg->name_ref->name,
+		       msg->to, msg->from,
+		       msg->in_reply_to.network_id, msg->in_reply_to.serial_num,
+		       msg->orig_from.network_id, msg->orig_from.local_id,
+		       msg->final_to.network_id, msg->final_to.local_id,
+		       (msg->flags & 0xFFFF0000) >> 4,
+		       (msg->flags & 0x0000FFFF));
+	}
+}
+
+/*
+ * Copy a message, doing whatever is deemed necessary.
+ *
+ * Copies the message header, and also copies the message name and any
+ * data. The message must be a 'pointy' message with reference counted
+ * name and data.
+ */
+static struct kbus_msg *kbus_copy_message(struct kbus_dev *dev,
+					  struct kbus_msg *old_msg)
+{
+	struct kbus_msg *new_msg;
+
+	new_msg = kmalloc(sizeof(*new_msg), GFP_KERNEL);
+	if (!new_msg) {
+		dev_err(dev->dev, "Cannot kmalloc copy of message header\n");
+		return NULL;
+	}
+	if (!memcpy(new_msg, old_msg, sizeof(*new_msg))) {
+		dev_err(dev->dev, "Cannot copy message header\n");
+		kfree(new_msg);
+		return NULL;
+	}
+
+	/* In case of error before we're finished... */
+	new_msg->name_ref = NULL;
+	new_msg->data_ref = NULL;
+
+	new_msg->name_ref = kbus_raise_name_ref(old_msg->name_ref);
+
+	if (new_msg->data_len)
+		/* Take a new reference to the data */
+		new_msg->data_ref = kbus_raise_data_ref(old_msg->data_ref);
+	return new_msg;
+}
+
+/*
+ * Free a message.
+ *
+ * Also dereferences the message name and any message data.
+ */
+static void kbus_free_message(struct kbus_msg *msg)
+{
+	if (msg->name_ref)
+		kbus_lower_name_ref(msg->name_ref);
+	msg->name_len = 0;
+	msg->name_ref = NULL;
+
+	if (msg->data_len && msg->data_ref)
+		kbus_lower_data_ref(msg->data_ref);
+
+	msg->data_len = 0;
+	msg->data_ref = NULL;
+	kfree(msg);
+}
+
+static void kbus_empty_read_msg(struct kbus_private_data *priv)
+{
+	struct kbus_read_msg *this = &(priv->read);
+	int ii;
+
+	if (this->msg) {
+		kbus_free_message(this->msg);
+		this->msg = NULL;
+	}
+
+	for (ii = 0; ii < KBUS_NUM_PARTS; ii++) {
+		this->parts[ii] = NULL;
+		this->lengths[ii] = 0;
+	}
+	this->which = 0;
+	this->pos = 0;
+	this->ref_data_index = 0;
+}
+
+static void kbus_empty_write_msg(struct kbus_private_data *priv)
+{
+	struct kbus_write_msg *this = &priv->write;
+	if (this->msg) {
+		kbus_free_message(this->msg);
+		this->msg = NULL;
+	}
+
+	if (this->ref_name) {
+		kbus_lower_name_ref(this->ref_name);
+		this->ref_name = NULL;
+	}
+
+	if (this->ref_data) {
+		kbus_lower_data_ref(this->ref_data);
+		this->ref_data = NULL;
+	}
+
+	this->is_finished = false;
+	this->pos = 0;
+	this->which = 0;
+}
+
+/*
+ * Copy the given message, and add it to the end of the queue.
+ *
+ * This is the *only* way of adding a message to a queue. It shall remain so.
+ *
+ * We assume the message has been checked for sanity.
+ *
+ * 'msg' is the message to add to the queue.
+ *
+ * 'binding' is a pointer to the KBUS message name binding that caused the
+ * message to be added.
+ *
+ * 'for_replier' is true if this particular message is being pushed to the
+ * message's replier's queue. Specifically, it's true if this is a Reply
+ * to this Ksock, or a Request aimed at this Ksock (as Replier).
+ *
+ * Returns 0 if all goes well, or -EFAULT/-ENOMEM if we can't allocate
+ * datastructures.
+ *
+ * May also return negative values if the message is mis-named or malformed,
+ * at least at the moment.
+ */
+static int kbus_push_message(struct kbus_private_data *priv,
+			     struct kbus_msg *msg,
+			     struct kbus_message_binding *binding,
+			     int for_replier)
+{
+	struct list_head *queue = &priv->message_queue;
+	struct kbus_msg *new_msg = NULL;
+	struct kbus_message_queue_item *item;
+
+	kbus_maybe_dbg(priv->dev,
+		       "  %u Pushing message onto queue (%s)\n",
+		       priv->id, for_replier ? "replier" : "listener");
+
+	new_msg = kbus_copy_message(priv->dev, msg);
+	if (!new_msg)
+		return -EFAULT;
+
+	item = kmalloc(sizeof(*item), GFP_KERNEL);
+	if (!item) {
+		dev_err(priv->dev->dev, "Cannot kmalloc new message item\n");
+		kbus_free_message(new_msg);
+		return -ENOMEM;
+	}
+	kbus_maybe_report_message(priv->dev, new_msg);
+
+	if (for_replier && (KBUS_BIT_WANT_A_REPLY & msg->flags)) {
+		/*
+		 * This message wants a reply, and is for the message's
+		 * replier, so they need to be told that they are to reply to
+		 * this message
+		 */
+		new_msg->flags |= KBUS_BIT_WANT_YOU_TO_REPLY;
+		kbus_maybe_dbg(priv->dev,
+			       "  Setting WANT_YOU_TO_REPLY, "
+			       "flags %08x\n",
+			       new_msg->flags);
+	} else {
+		/*
+		 * The recipient is *not* the replier for this message,
+		 * so it is not responsible for replying.
+		 */
+		new_msg->flags &= ~KBUS_BIT_WANT_YOU_TO_REPLY;
+	}
+
+	/* And join it up... */
+	item->msg = new_msg;
+	item->binding = binding;
+
+	/* By default, we're using the list as a FIFO, so we want to add our
+	 * new message to the end (just before the first item). However, if the
+	 * URGENT flag is set, then we instead want to add it to the start.
+	 */
+	if (msg->flags & KBUS_BIT_URGENT) {
+		kbus_maybe_dbg(priv->dev, "  Message is URGENT\n");
+		list_add(&item->list, queue);
+	} else {
+		list_add_tail(&item->list, queue);
+	}
+
+	priv->message_count++;
+
+	if (!kbus_same_message_id(&msg->in_reply_to, 0, 0)) {
+		/*
+		 * If it's a reply (and this will include a synthetic reply,
+		 * since we're checking the "in_reply_to" field) then the
+		 * original sender has now had its request satisfied.
+		 */
+		int retval = kbus_forget_msg_id(priv, &msg->in_reply_to);
+
+		if (retval)
+			/* But there's not much we can do about it */
+			dev_err(priv->dev->dev,
+			       "%u Error forgetting "
+			       "outstanding request %u:%u\n",
+			       priv->id, msg->in_reply_to.network_id,
+			       msg->in_reply_to.serial_num);
+	}
+
+	/* And indicate that there is something available to read */
+	wake_up_interruptible(&priv->read_wait);
+
+	kbus_maybe_dbg(priv->dev,
+		       "%u Leaving %d message%s in queue\n",
+		       priv->id, priv->message_count,
+		       priv->message_count == 1 ? "" : "s");
+
+	return 0;
+}
+
+/*
+ * Generate a synthetic message, and add it to the recipient's message queue.
+ *
+ * This is to be used when a Reply is not going to be generated
+ * by the intended Replier. Since we don't want KBUS itself to block on
+ * (trying to) SEND a message to someone not expecting it, I don't think
+ * there are any other occasions when it is useful.
+ *
+ * 'from' is the id of the recipient who has gone away, not received the
+ * message, or whatever.
+ *
+ * 'to' is the 'from' for the message we're bouncing (or whatever). This
+ * needs to be local (it cannot be on another network), so we don't specify
+ * the network id.
+ *
+ * 'in_reply_to' should be the message id of that same message.
+ *
+ * Note that the message is essentially a Reply, so it only goes to the
+ * original Sender.
+ *
+ * Doesn't return anything since I can't think of anything useful to do if it
+ * goes wrong.
+ */
+static void kbus_push_synthetic_message(struct kbus_dev *dev,
+					u32 from,
+					u32 to,
+					struct kbus_msg_id in_reply_to,
+					char *name)
+{
+	struct kbus_private_data *priv = NULL;
+	struct kbus_msg *new_msg;
+
+	/* Who *was* the original message to? */
+	priv = kbus_find_open_ksock(dev, to);
+	if (!priv) {
+		dev_err(dev->dev,
+		       "pid %u [%s] Cannot send synthetic reply to %u,"
+		       " as they are gone\n", current->pid, current->comm, to);
+		return;
+	}
+
+	kbus_maybe_dbg(priv->dev, "  Pushing synthetic message '%s'"
+		       " onto queue for %u\n", name, to);
+
+	/*
+	 * Note that we do not check if the destination queue is full
+	 * - we're going to trust that the "keep enough room in the
+	 * message queue for a reply to each request" mechanism does
+	 * it's job properly.
+	 */
+
+	new_msg = kbus_build_kbus_message(dev, name, from, to, in_reply_to);
+	if (!new_msg)
+		return;
+
+	(void)kbus_push_message(priv, new_msg, NULL, false);
+	/* ignore retval; we can't do anything useful if this goes wrong */
+
+	/* kbus_push_message takes a copy of our message */
+	kbus_free_message(new_msg);
+}
+
+/*
+ * Pop the next message off our queue.
+ *
+ * Returns a pointer to the message, or NULL if there is no next message.
+ */
+static struct kbus_msg *kbus_pop_message(struct kbus_private_data *priv)
+{
+	struct list_head *queue = &priv->message_queue;
+	struct kbus_message_queue_item *item;
+	struct kbus_msg *msg = NULL;
+
+	kbus_maybe_dbg(priv->dev, "  %u Popping message from queue\n",
+				   priv->id);
+
+	if (list_empty(queue))
+		return NULL;
+
+	/* Retrieve the next message */
+	item = list_first_entry(queue, struct kbus_message_queue_item, list);
+
+	/* And straightway remove it from the list */
+	list_del(&item->list);
+
+	priv->message_count--;
+
+	msg = item->msg;
+	kfree(item);
+
+	/* If doing that made us go from no-room to some-room, wake up */
+	if (priv->message_count == (priv->max_messages - 1))
+		wake_up_interruptible(&priv->dev->write_wait);
+
+	kbus_maybe_report_message(priv->dev, msg);
+	kbus_maybe_dbg(priv->dev,
+		       "  %u Leaving %d message%s in queue\n",
+		       priv->id, priv->message_count,
+		       priv->message_count == 1 ? "" : "s");
+
+	return msg;
+}
+
+/*
+ * Empty a message queue. Send synthetic messages for any outstanding
+ * request messages that are now not going to be delivered/replied to.
+ */
+static void kbus_empty_message_queue(struct kbus_private_data *priv)
+{
+	struct list_head *queue = &priv->message_queue;
+	struct kbus_message_queue_item *ptr;
+	struct kbus_message_queue_item *next;
+
+	kbus_maybe_dbg(priv->dev, "  %u Emptying message queue\n", priv->id);
+
+	list_for_each_entry_safe(ptr, next, queue, list) {
+		struct kbus_msg *msg = ptr->msg;
+		int is_OUR_request = (KBUS_BIT_WANT_YOU_TO_REPLY & msg->flags);
+
+		kbus_maybe_report_message(priv->dev, msg);
+
+		/*
+		 * If it wanted a reply (from us). let the sender know it's
+		 * going away (but take care not to send a message to
+		 * ourselves, by accident!)
+		 */
+		if (is_OUR_request && msg->to != priv->id)
+			kbus_push_synthetic_message(priv->dev, priv->id,
+					    msg->from, msg->id,
+					    KBUS_MSG_NAME_REPLIER_GONEAWAY);
+
+		list_del(&ptr->list);
+		kbus_free_message(ptr->msg);
+
+		priv->message_count--;
+	}
+
+	kbus_maybe_dbg(priv->dev,
+		       "  %u Leaving %d message%s in queue\n",
+		       priv->id, priv->message_count,
+		       priv->message_count == 1 ? "" : "s");
+}
+
+/*
+ * Add a message to the list of messages read by the replier, but still needing
+ * a reply.
+ */
+static int kbus_reply_needed(struct kbus_private_data *priv,
+			     struct kbus_msg *msg)
+{
+	struct list_head *queue = &priv->replies_unsent;
+	struct kbus_unreplied_item *item;
+
+	kbus_maybe_dbg(priv->dev,
+		       "  %u Adding message %u:%u to unsent "
+		       "replies list\n",
+		       priv->id, msg->id.network_id,
+		       msg->id.serial_num);
+
+	item = kmalloc(sizeof(*item), GFP_KERNEL);
+	if (!item) {
+		dev_err(priv->dev->dev, "Cannot kmalloc reply-needed item\n");
+		return -ENOMEM;
+	}
+
+	item->id = msg->id;
+	item->from = msg->from;
+	item->name_len = msg->name_len;
+	/*
+	 * It seems sensible to use a reference to the name. I believe
+	 * we are safe to do this because we have the message "in hand".
+	 */
+	item->name_ref = kbus_raise_name_ref(msg->name_ref);
+
+	list_add(&item->list, queue);
+
+	priv->num_replies_unsent++;
+
+	if (priv->num_replies_unsent > priv->max_replies_unsent)
+		priv->max_replies_unsent = priv->num_replies_unsent;
+
+	kbus_maybe_dbg(priv->dev,
+		       "  %u Leaving %d message%s unreplied-to\n",
+		       priv->id, priv->num_replies_unsent,
+		       priv->num_replies_unsent == 1 ? "" : "s");
+
+	return 0;
+}
+
+/*
+ * Remove a message from the list of (read) messages needing a reply
+ *
+ * Returns 0 on success, -1 if it could not find the message
+ */
+static int kbus_reply_now_sent(struct kbus_private_data *priv,
+			       struct kbus_msg_id *msg_id)
+{
+	struct list_head *queue = &priv->replies_unsent;
+	struct kbus_unreplied_item *ptr;
+	struct kbus_unreplied_item *next;
+
+	list_for_each_entry_safe(ptr, next, queue, list) {
+		if (!kbus_same_message_id(&ptr->id,
+					 msg_id->network_id,
+					 msg_id->serial_num))
+			continue;
+
+		kbus_maybe_dbg(priv->dev,
+		       "  %u Reply to %u:%u %.*s now sent\n",
+		       priv->id, msg_id->network_id,
+		       msg_id->serial_num, ptr->name_len, ptr->name_ref->name);
+
+		list_del(&ptr->list);
+		kbus_lower_name_ref(ptr->name_ref);
+		kfree(ptr);
+
+		priv->num_replies_unsent--;
+
+		kbus_maybe_dbg(priv->dev,
+		       "  %u Leaving %d message%s unreplied-to\n",
+		       priv->id, priv->num_replies_unsent,
+		       priv->num_replies_unsent == 1 ? "" : "s");
+
+		return 0;
+	}
+
+	dev_err(priv->dev->dev, "%u Could not find message %u:%u in unsent "
+	       "replies list\n",
+	       priv->id, msg_id->network_id, msg_id->serial_num);
+	return -1;
+}
+
+/*
+ * Empty our "replies unsent" queue. Send synthetic messages for any
+ * request messages that are now not going to be replied to.
+ */
+static void kbus_empty_replies_unsent(struct kbus_private_data *priv)
+{
+	struct list_head *queue = &priv->replies_unsent;
+	struct kbus_unreplied_item *ptr;
+	struct kbus_unreplied_item *next;
+
+	kbus_maybe_dbg(priv->dev,
+		       "  %u Emptying unreplied messages list\n", priv->id);
+
+	list_for_each_entry_safe(ptr, next, queue, list) {
+
+		kbus_push_synthetic_message(priv->dev, priv->id,
+					    ptr->from, ptr->id,
+					    KBUS_MSG_NAME_REPLIER_IGNORED);
+
+		list_del(&ptr->list);
+		kbus_lower_name_ref(ptr->name_ref);
+		kfree(ptr);
+
+		priv->num_replies_unsent--;
+	}
+
+	kbus_maybe_dbg(priv->dev,
+		       "  %u Leaving %d message%s unreplied-to\n",
+		       priv->id, priv->num_replies_unsent,
+		       priv->num_replies_unsent == 1 ? "" : "s");
+}
+
+/*
  * Find out who, if anyone, is bound as a replier to the given message name.
  *
  * Returns 1 if we found a replier, 0 if we did not (but all went well), and
@@ -156,12 +1218,139 @@ static int kbus_find_replier(struct kbus_dev *dev,
 		    strncmp(name, ptr->name, name_len))
 			continue;
 
-		kbus_maybe_dbg(dev, "  '%.*s' has replier %u\n",
-			       ptr->name_len, ptr->name, ptr->bound_to_id);
-		*bound_to = ptr->bound_to;
-		return 1;
+		kbus_maybe_dbg(dev, "  '%.*s' has replier %u\n",
+			       ptr->name_len, ptr->name, ptr->bound_to_id);
+		*bound_to = ptr->bound_to;
+		return 1;
+	}
+	return 0;
+}
+
+/*
+ * Find out who, if anyone, is bound as listener/replier to this message name.
+ *
+ * 'listeners' is an array of (pointers to) listener bindings. It may be NULL
+ * (if there are no listeners or if there was an error). It is up to the caller
+ * to free it. It does not include (pointers to) any replier binding.
+ *
+ * If there is also a replier for this message, then 'replier' will be (a
+ * pointer to) its binding, otherwise it will be NULL. The replier will not be
+ * in the 'listeners' array, so the caller must check both.
+ *
+ * Note that a particular listener may be present more than once, if that
+ * particular listener has bound to the message more than once (but no
+ * *binding* will be represented more than once).
+ *
+ * Returns the number of listeners found (i.e., the length of the array), or a
+ * negative value if something went wrong. This is a bit clumsy, because the
+ * caller needs to check the return value *and* the 'replier' value, but there
+ * is only one caller, so...
+ */
+static int kbus_find_listeners(struct kbus_dev *dev,
+			       struct kbus_message_binding **listeners[],
+			       struct kbus_message_binding **replier,
+			       u32 name_len, char *name)
+{
+	int count = 0;
+	int array_size = KBUS_INIT_LISTENER_ARRAY_SIZE;
+	struct kbus_message_binding *ptr;
+	struct kbus_message_binding *next;
+
+	enum kbus_replier_type replier_type = UNSET;
+	enum kbus_replier_type new_replier_type = UNSET;
+
+	kbus_maybe_dbg(dev,
+		       "  Looking for listeners/repliers for '%.*s'\n",
+		       name_len, name);
+
+	*listeners =
+	    kmalloc(array_size * sizeof(struct kbus_message_binding *),
+		    GFP_KERNEL);
+	if (!(*listeners))
+		return -ENOMEM;
+
+	*replier = NULL;
+
+	list_for_each_entry_safe(ptr, next, &dev->bound_message_list, list) {
+
+		if (!kbus_message_name_matches(name, name_len, ptr->name))
+			continue;
+
+		kbus_maybe_dbg(dev, "     Name '%.*s' matches "
+			       "'%s' for %s %u\n",
+			       name_len, name, ptr->name,
+			       ptr->is_replier ? "replier" : "listener",
+			       ptr->bound_to_id);
+
+		if (ptr->is_replier) {
+			/* It *may* be the replier for this message */
+			size_t last_char = strlen(ptr->name) - 1;
+			if (ptr->name[last_char] == '*')
+				new_replier_type = WILD_STAR;
+			else if (ptr->name[last_char] == '%')
+				new_replier_type = WILD_PERCENT;
+			else
+				new_replier_type = SPECIFIC;
+
+			kbus_maybe_dbg(dev,
+				"     ..previous replier was %u "
+				"(%s), looking at %u (%s)\n",
+				((*replier) == NULL ? 0 :
+					(*replier)->bound_to_id),
+				kbus_replier_type_name(replier_type),
+				ptr->bound_to_id,
+				kbus_replier_type_name(new_replier_type));
+
+			/*
+			 * If this is the first replier, just remember
+			 * it. Otherwise, if it's more specific than
+			 * our previous replier, remember it instead.
+			 */
+			if (*replier == NULL ||
+			    new_replier_type > replier_type) {
+
+				if (*replier)
+					kbus_maybe_dbg(dev,
+					   "     ..new replier %u (%s)\n",
+					   ptr->bound_to_id,
+					   kbus_replier_type_name(
+					   new_replier_type));
+
+				*replier = ptr;
+				replier_type = new_replier_type;
+			} else {
+			    if (*replier)
+				kbus_maybe_dbg(dev,
+				       "     ..keeping replier %u (%s)\n",
+				       (*replier)->bound_to_id,
+				       kbus_replier_type_name(replier_type));
+			}
+		} else {
+			/* It is a listener */
+			if (count == array_size) {
+				u32 new_size = kbus_next_size(array_size);
+
+				kbus_maybe_dbg(dev, "     XXX listener "
+				       "array size %d -> %d\n",
+				       array_size, new_size);
+
+				array_size = new_size;
+				*listeners = krealloc(*listeners,
+				      sizeof(**listeners) * array_size,
+				      GFP_KERNEL);
+				if (!(*listeners))
+					return -EFAULT;
+			}
+			(*listeners)[count++] = ptr;
+		}
 	}
-	return 0;
+
+	kbus_maybe_dbg(dev, "     Found %d listener%s%s for '%.*s'\n",
+		       count, (count == 1 ? "" : "s"),
+		       (*replier == NULL ? "" : " and a replier"),
+		       name_len, name);
+
+	return count;
 }
 
 /*
@@ -248,6 +1437,69 @@ static struct kbus_message_binding
 }
 
 /*
+ * Forget any messages (in our queue) that were only in the queue because of
+ * the binding we're removing.
+ *
+ * If the message was a request (needing a reply) generate an appropriate
+ * synthetic message.
+ */
+static void kbus_forget_matching_messages(struct kbus_private_data *priv,
+					  struct kbus_message_binding *binding)
+{
+	struct list_head *queue = &priv->message_queue;
+	struct kbus_message_queue_item *ptr;
+	struct kbus_message_queue_item *next;
+
+	kbus_maybe_dbg(priv->dev,
+		       "  %u Forgetting matching messages\n", priv->id);
+
+	list_for_each_entry_safe(ptr, next, queue, list) {
+		struct kbus_msg *msg = ptr->msg;
+		int is_OUR_request = (KBUS_BIT_WANT_YOU_TO_REPLY & msg->flags);
+
+		/*
+		 * If this message was not added to the queue because of this
+		 * binding, then we are not interested in it...
+		 */
+		if (ptr->binding != binding)
+			continue;
+
+		kbus_maybe_dbg(priv->dev,
+				"  Deleting message from queue\n");
+		kbus_maybe_report_message(priv->dev, msg);
+
+		/*
+		 * If it wanted a reply (from us). let the sender know it's
+		 * going away (but take care not to send a message to
+		 * ourselves, by accident!)
+		 */
+		if (is_OUR_request && msg->to != priv->id) {
+
+			kbus_maybe_dbg(priv->dev, "  >>> is_OUR_request,"
+				       " sending fake reply\n");
+			kbus_maybe_report_message(priv->dev, msg);
+			kbus_push_synthetic_message(priv->dev, priv->id,
+					    msg->from, msg->id,
+					    KBUS_MSG_NAME_REPLIER_UNBOUND);
+		}
+
+		list_del(&ptr->list);
+		kbus_free_message(ptr->msg);
+
+		priv->message_count--;
+
+		/* If that made us go from no-room to some-room, wake up */
+		if (priv->message_count == (priv->max_messages - 1))
+			wake_up_interruptible(&priv->dev->write_wait);
+	}
+
+	kbus_maybe_dbg(priv->dev,
+		       "  %u Leaving %d message%s in queue\n",
+		       priv->id, priv->message_count,
+		       priv->message_count == 1 ? "" : "s");
+}
+
+/*
  * Remove an existing binding.
  *
  * Returns 0 if all went well, a negative value if it did not.
@@ -273,9 +1525,15 @@ static int kbus_forget_binding(struct kbus_dev *dev,
 		       (binding->is_replier ? 'R' : 'L'),
 		       binding->name_len, binding->name);
 
+	/* And forget any messages we now shouldn't receive */
+	kbus_forget_matching_messages(priv, binding);
+
 	/*
-	 * If we supported sending messages (yet), we'd need to forget
-	 * any messages in our queue that match this binding.
+	 * We carefully don't try to do anything about requests that
+	 * have already been read - the fact that the user has unbound
+	 * from receiving new messages with this name doesn't imply
+	 * anything about whether they're going to reply to requests
+	 * (with that name) which they've already read.
 	 */
 
 	/* And remove the binding once that has been done. */
@@ -358,6 +1616,27 @@ static int kbus_remember_open_ksock(struct kbus_dev *dev,
 }
 
 /*
+ * Retrieve the pointer to an open file's data
+ *
+ * Return NULL if we can't find it.
+ */
+static struct kbus_private_data *kbus_find_open_ksock(struct kbus_dev *dev,
+						      u32 id)
+{
+	struct kbus_private_data *ptr;
+	struct kbus_private_data *next;
+
+	list_for_each_entry_safe(ptr, next, &dev->open_ksock_list, list) {
+		if (id == ptr->id) {
+			kbus_maybe_dbg(dev, "  Found open Ksock %u\n", id);
+			return ptr;
+		}
+	}
+	kbus_maybe_dbg(dev, "  Could not find open Ksock %u\n", id);
+	return NULL;
+}
+
+/*
  * Remove an open file remembrance.
  *
  * Returns 0 if all went well, -EINVAL if we couldn't find the open Ksock
@@ -446,38 +1725,820 @@ static int kbus_open(struct inode *inode, struct file *filp)
 	priv->num_replies_unsent = 0;
 	priv->max_replies_unsent = 0;
 
+	if (kbus_init_msg_id_memory(priv)) {
+		kbus_empty_read_msg(priv);
+		kfree(priv);
+		return -EFAULT;
+	}
 	INIT_LIST_HEAD(&priv->message_queue);
 	INIT_LIST_HEAD(&priv->replies_unsent);
 
-	(void)kbus_remember_open_ksock(dev, priv);
+	init_waitqueue_head(&priv->read_wait);
+
+	/* Note that we immediately have a space available for a message */
+	wake_up_interruptible(&dev->write_wait);
+
+	(void)kbus_remember_open_ksock(dev, priv);
+
+	filp->private_data = priv;
+
+	mutex_unlock(&dev->mux);
+
+	kbus_maybe_dbg(dev, "%u OPEN\n", priv->id);
+
+	return 0;
+}
+
+static int kbus_release(struct inode *inode __always_unused, struct file *filp)
+{
+	int retval2 = 0;
+	struct kbus_private_data *priv = filp->private_data;
+	struct kbus_dev *dev = priv->dev;
+
+	if (mutex_lock_interruptible(&dev->mux))
+		return -ERESTARTSYS;
+
+	kbus_maybe_dbg(dev, "%u RELEASE\n", priv->id);
+
+	kbus_empty_read_msg(priv);
+	kbus_empty_write_msg(priv);
+
+	kbus_empty_msg_id_memory(priv);
+
+	kbus_empty_message_queue(priv);
+	kbus_forget_my_bindings(priv);
+	kbus_empty_replies_unsent(priv);
+	retval2 = kbus_forget_open_ksock(dev, priv->id);
+	kfree(priv);
+
+	mutex_unlock(&dev->mux);
+
+	return retval2;
+}
+
+/*
+ * Determine the private data for the given listener/replier id.
+ *
+ * Return NULL if we can't find it.
+ */
+static struct kbus_private_data
+*kbus_find_private_data(struct kbus_private_data *our_priv,
+			struct kbus_dev *dev, u32 id)
+{
+	struct kbus_private_data *l_priv;
+	if (id == our_priv->id) {
+		/* Heh, it's us, we know who we are! */
+		kbus_maybe_dbg(dev, "  -- Id %u is us\n", id);
+
+		l_priv = our_priv;
+	} else {
+		/* OK, look it up */
+		kbus_maybe_dbg(dev, "  -- Looking up id %u\n", id);
+
+		l_priv = kbus_find_open_ksock(dev, id);
+	}
+	return l_priv;
+}
+
+/*
+ * Determine if the specified recipient has room for a message in their queue
+ *
+ * - 'priv' is the recipient
+ * - 'what' is a string describing them (e.g., "sender", "replier"), just
+ *   for use in debugging/grumbling
+ * - if 'is_reply' is true, then we're checking for a Reply message,
+ *   which we already know is expected by the specified recipient.
+ */
+static int kbus_queue_is_full(struct kbus_private_data *priv,
+			      char *what __maybe_unused, int is_reply)
+{
+	/*
+	 * When figuring out how "full" the message queue is, we need
+	 * to take account of the messages already in the queue (!),
+	 * and also the replies that still need to be written to the
+	 * queue.
+	 *
+	 * Of course, if we're checking because we want to send one
+	 * of the Replies that we are keeping room for, we need to
+	 * remember to account for that!
+	 */
+	int already_accounted_for = priv->message_count +
+	    priv->outstanding_requests.count;
+
+	if (is_reply)
+		already_accounted_for--;
+
+	kbus_maybe_dbg(priv->dev,
+		       "  %u Message queue: count %d + "
+		       "outstanding %d %s= %d, max %d\n",
+		       priv->id, priv->message_count,
+		       priv->outstanding_requests.count,
+		       (is_reply ? "-1 " : ""), already_accounted_for,
+		       priv->max_messages);
+
+	if (already_accounted_for < priv->max_messages) {
+		return false;
+	} else {
+		kbus_maybe_dbg(priv->dev,
+			       "  Message queue for %s %u is full"
+			       " (%u+%u%s > %u messages)\n", what, priv->id,
+			       priv->message_count,
+			       priv->outstanding_requests.count,
+			       (is_reply ? "-1" : ""), priv->max_messages);
+		return true;
+	}
+}
+
+/*
+ * Actually write to anyone interested in this message.
+ *
+ * Remember that the caller is going to free the message data after
+ * calling us, on the assumption that we're taking a copy...
+ *
+ * Returns 0 on success.
+ *
+ * If the message is a Request, and there is no replier for it, then we return
+ * -EADDRNOTAVAIL.
+ *
+ * If the message is a Reply, and the is sender is no longer connected (it has
+ * released its Ksock), then we return -EADDRNOTAVAIL.
+ *
+ * If the message couldn't be sent because some of the targets (those that we
+ * *have* to deliver to) had full queues, then it will return -EAGAIN or
+ * -EBUSY. If -EAGAIN is returned, then the caller should try again later, if
+ * -EBUSY then it should not.
+ *
+ * Otherwise, it returns a negative value for error.
+ */
+static int kbus_write_to_recipients(struct kbus_private_data *priv,
+				    struct kbus_dev *dev,
+				    struct kbus_msg *msg)
+{
+	struct kbus_message_binding **listeners = NULL;
+	struct kbus_message_binding *replier = NULL;
+	struct kbus_private_data *reply_to = NULL;
+	ssize_t retval = 0;
+	int num_listeners;
+	int ii;
+	int num_sent = 0;	/* # successfully "sent" */
+
+	int all_or_fail = msg->flags & KBUS_BIT_ALL_OR_FAIL;
+	int all_or_wait = msg->flags & KBUS_BIT_ALL_OR_WAIT;
+
+	kbus_maybe_dbg(priv->dev, "  all_or_fail %d, all_or_wait %d\n",
+		       all_or_fail, all_or_wait);
+
+	/*
+	 * Remember that
+	 * (a) a listener may occur more than once in our array, and
+	 * (b) we have 0 or 1 repliers, but
+	 * (c) the replier is *not* one of the listeners.
+	 */
+	num_listeners = kbus_find_listeners(dev, &listeners, &replier,
+					    msg->name_len, msg->name_ref->name);
+	if (num_listeners < 0) {
+		kbus_maybe_dbg(priv->dev,
+			       "  Error %d finding listeners\n",
+			       num_listeners);
+
+		retval = num_listeners;
+		goto done_sending;
+	}
+
+	/*
+	 * In general, we don't mind if no-one is listening, but
+	 *
+	 * a. If we want a reply, we want there to be a replier
+	 * b. If we *are* a reply, we want there to be an original sender
+	 * c. If we have the "to" field set, and we want a reply, then we
+	 *    want that specific replier to exist
+	 *
+	 * We can check the first of those immediately.
+	 */
+
+	if (msg->flags & KBUS_BIT_WANT_A_REPLY && replier == NULL) {
+		kbus_maybe_dbg(priv->dev,
+			       "  Message wants a reply, "
+			       "but no replier\n");
+		retval = -EADDRNOTAVAIL;
+		goto done_sending;
+	}
+
+	/* And we need to add it to the queue for each interested party */
+
+	/*
+	 * ===================================================================
+	 * Check if the proposed recipients *can* receive
+	 * ===================================================================
+	 */
+
+	/*
+	 * Are we replying to a sender's request?
+	 * Replies are unusual in that the recipient will not normally have
+	 * bound to the appropriate message name.
+	 */
+	if (kbus_message_is_reply(msg)) {
+		kbus_maybe_dbg(priv->dev,
+			       "  Considering sender-of-request %u\n",
+			       msg->to);
+
+		reply_to = kbus_find_private_data(priv, dev, msg->to);
+		if (reply_to == NULL) {
+			kbus_maybe_dbg(priv->dev,
+				       "  Can't find sender-of-request"
+				       " %u\n", msg->to);
+
+			/* We can't find the original Sender */
+			retval = -EADDRNOTAVAIL;
+			goto done_sending;
+		}
+
+		/* Are they expecting this reply? */
+		if (kbus_find_msg_id(reply_to, &msg->in_reply_to)) {
+			/* No, so we aren't allowed to send it */
+			retval = -ECONNREFUSED;
+			goto done_sending;
+		}
+
+		if (kbus_queue_is_full(reply_to, "sender-of-request", true)) {
+			if (all_or_wait)
+				retval = -EAGAIN;	/* try again later */
+			else
+				retval = -EBUSY;
+			goto done_sending;
+		}
+	}
+
+	/* Repliers only get request messages */
+	if (replier && !(msg->flags & KBUS_BIT_WANT_A_REPLY))
+		replier = NULL;
+
+	/*
+	 * And even then, only if they have room in their queue
+	 * Note that it is *always* fatal (to this send) if we can't
+	 * add a Request to a Replier's queue -- we just need to figure
+	 * out what sort of error to return
+	 */
+	if (replier) {
+		kbus_maybe_dbg(priv->dev, "  Considering replier %u\n",
+			       replier->bound_to_id);
+		/*
+		 * If the 'to' field was set, then we only want to send it if
+		 * it is *that* specific replier (and otherwise we want to fail
+		 * with "that's the wrong person for this (stateful) request").
+		 */
+		if (msg->to && (replier->bound_to_id != msg->to)) {
+
+			kbus_maybe_dbg(priv->dev, "  ..Request to %u,"
+				       " but replier is %u\n", msg->to,
+				       replier->bound_to_id);
+
+			retval = -EPIPE;	/* Well, sort of */
+			goto done_sending;
+		}
+
+		if (kbus_queue_is_full(replier->bound_to, "replier", false)) {
+			if (all_or_wait)
+				retval = -EAGAIN;	/* try again later */
+			else
+				retval = -EBUSY;
+			goto done_sending;
+		}
+	}
+
+	for (ii = 0; ii < num_listeners; ii++) {
+
+		kbus_maybe_dbg(priv->dev, "  Considering listener %u\n",
+			       listeners[ii]->bound_to_id);
+
+		if (kbus_queue_is_full
+		    (listeners[ii]->bound_to, "listener", false)) {
+			if (all_or_wait) {
+				retval = -EAGAIN;	/* try again later */
+				goto done_sending;
+			} else if (all_or_fail) {
+				retval = -EBUSY;
+				goto done_sending;
+			} else {
+				/* For now, just ignore *this* listener */
+				listeners[ii] = NULL;
+				continue;
+			}
+		}
+	}
+
+	/*
+	 * ===================================================================
+	 * Actually send the messages
+	 * ===================================================================
+	 */
+
+	/*
+	 * Remember that kbus_push_message takes a copy of the message for us.
+	 *
+	 * This is inefficient, since otherwise we could keep a single copy of
+	 * the message (or at least the message header) and just bump a
+	 * reference count for each "use" of the message name/data.
+	 *
+	 * However, it also allows us to easily set the "needs a reply" flag
+	 * (and associated data) when sending a "needs a reply" message to a
+	 * replier, and *unset* the same when sending said message to "just"
+	 * listeners...
+	 *
+	 * Be careful if altering this...
+	 */
+
+	/*
+	 * We know that kbus_push_message() can return 0 or -EFAULT.
+	 * It seems sensible to treat that latter as a "local" error, as it
+	 * means that our internals have gone wrong. Thus we don't need to
+	 * generate a message for it.
+	 */
+
+	/* If it's a reply message and we've got someone to reply to, send it */
+	if (reply_to) {
+		retval = kbus_push_message(reply_to, msg, NULL, true);
+		if (retval == 0) {
+			num_sent++;
+			/*
+			 * In which case, we *have* sent this reply,
+			 * and can forget about needing to do so
+			 * (there's not much we can do with an error
+			 * in this, so just ignore it)
+			 */
+			(void)kbus_reply_now_sent(priv, &msg->in_reply_to);
+		} else {
+			goto done_sending;
+		}
+	}
+
+	/* If it's a request, and we've got a replier for it, send it */
+	if (replier) {
+		retval =
+		    kbus_push_message(replier->bound_to, msg, replier, true);
+		if (retval)
+			goto done_sending;
+
+		num_sent++;
+		/* And we'll need a reply for that, thank you */
+		retval = kbus_remember_msg_id(priv, &msg->id);
+		if (retval)
+			/*
+			 * Out of memory - what *can* we do?
+			 * (basically, nothing, it's all gone horribly
+			 * wrong)
+			 */
+			goto done_sending;
+	}
+
+	/* For each listener, if they're still interested, send it */
+	for (ii = 0; ii < num_listeners; ii++) {
+		struct kbus_message_binding *listener = listeners[ii];
+		if (listener) {
+			retval = kbus_push_message(listener->bound_to, msg,
+						   listener, false);
+			if (retval == 0)
+				num_sent++;
+			else
+				goto done_sending;
+		}
+	}
+
+	retval = 0;
+
+done_sending:
+	kfree(listeners);
+	return retval;
+}
+
+/*
+ * Handle moving over the next chunk of data bytes from the user.
+ */
+static int kbus_write_data_parts(struct kbus_private_data *priv,
+				 const char __user *buf,
+				 size_t buf_pos, size_t bytes_to_use)
+{
+	struct kbus_write_msg *this = &(priv->write);
+
+	u32 num_parts = this->ref_data->num_parts;
+	size_t local_count = bytes_to_use;
+	size_t local_buf_pos = 0;
+
+	while (local_count) {
+		unsigned ii = this->ref_data_index;
+		unsigned this_part_len;
+		size_t sofar, needed, to_use;
+
+		unsigned *lengths = this->ref_data->lengths;
+		unsigned long *parts = this->ref_data->parts;
+
+		if (ii == num_parts - 1)
+			this_part_len = this->ref_data->last_page_len;
+		else
+			this_part_len = KBUS_PART_LEN;
+
+		sofar = lengths[ii];
+
+		needed = this_part_len - sofar;
+		to_use = min(needed, local_count);
+
+		if (copy_from_user((char *)parts[ii] + sofar,
+				   buf + buf_pos + local_buf_pos, to_use)) {
+			dev_err(priv->dev->dev, "copy from data failed"
+			       " (part %d: %u of %u to %p + %u)\n",
+			       this->ref_data_index,
+			       (unsigned)to_use, (unsigned)local_count,
+			       (void *)parts[ii], (unsigned)sofar);
+			return -EFAULT;
+		}
+
+		lengths[ii] += to_use;
+		local_count -= to_use;
+		local_buf_pos += to_use;
+
+		if (lengths[ii] == this_part_len) {
+			/* This part is full */
+			this->ref_data_index++;
+		}
+	}
+	return 0;
+}
+
+/*
+ * Handle moving over the next chunk of bytes from the user to our message.
+ *
+ * 'buf' is the buffer of data the user gave us.
+ *
+ * 'buf_pos' is the offset in that buffer from which we are to take bytes.
+ * We alter that by how many bytes we do take.
+ *
+ * 'count' is the number of bytes we're still to take from 'buf'. We also
+ * alter 'count' by how many bytes we do take (downwards).
+ */
+static int kbus_write_parts(struct kbus_private_data *priv,
+			    const char __user *buf,
+			    size_t *buf_pos, size_t *count)
+{
+	struct kbus_write_msg *this = &(priv->write);
+	ssize_t retval = 0;
+
+	size_t bytes_needed;	/* ...to fill the current part */
+	size_t bytes_to_use;	/* ...from the user's data */
+
+	struct kbus_msg *msg = this->msg;
+	struct kbus_message_header *user_msg =
+	    (struct kbus_message_header *)&this->user_msg;
+
+	if (this->is_finished) {
+		dev_err(priv->dev->dev, "pid %u [%s]"
+		       " Attempt to write data after the end guard in a"
+		       " message (%u extra byte%s) - did you forget to"
+		       " 'send'?\n",
+		       current->pid, current->comm,
+		       (unsigned)*count, *count == 1 ? "" : "s");
+		return -EMSGSIZE;
+	}
+
+	switch (this->which) {
+
+	case KBUS_PART_HDR:
+		bytes_needed = sizeof(*user_msg) - this->pos;
+		bytes_to_use = min(bytes_needed, *count);
+
+		if (copy_from_user((char *)user_msg + this->pos,
+				   buf + *buf_pos, bytes_to_use)) {
+			dev_err(priv->dev->dev,
+			       "copy from user failed (msg hdr: "
+			       "%u of %u to %p + %u)\n",
+			       (unsigned)bytes_to_use, (unsigned)*count, msg,
+			       this->pos);
+			return -EFAULT;
+		}
+		if (bytes_needed == bytes_to_use) {
+			/*
+			 * At this point, we can check the message header makes
+			 * sense
+			 */
+			retval = kbus_check_message_written(priv->dev, this);
+			if (retval)
+				return retval;
+
+			msg->id = user_msg->id;
+			msg->in_reply_to = user_msg->in_reply_to;
+			msg->to = user_msg->to;
+			msg->from = user_msg->from;
+			msg->orig_from = user_msg->orig_from;
+			msg->final_to = user_msg->final_to;
+			msg->extra = user_msg->extra;
+			msg->flags = user_msg->flags;
+			msg->name_len = user_msg->name_len;
+			msg->data_len = user_msg->data_len;
+			/* Leaving msg->name|data_ref still unset */
+
+			this->user_name_ptr = user_msg->name;
+			this->user_data_ptr = user_msg->data;
+
+			if (user_msg->name)
+				/*
+				 * If we're reading a "pointy" message header,
+				 * then that's all we need - we shan't try to
+				 * copy the message name and any data until the
+				 * user says to SEND.
+				 */
+				this->is_finished = true;
+			else
+				this->pointers_are_local = true;
+		}
+		break;
+
+	case KBUS_PART_NAME:
+		if (this->ref_name == NULL) {
+			char *name = kmalloc(msg->name_len + 1, GFP_KERNEL);
+			if (!name) {
+				dev_err(priv->dev->dev,
+					"Cannot kmalloc message name\n");
+				return -ENOMEM;
+			}
+			name[msg->name_len] = 0;	/* always */
+			name[0] = 0;	/* we don't know the name yet */
+			this->ref_name = kbus_wrap_name_in_ref(name);
+			if (!this->ref_name) {
+				kfree(name);
+				dev_err(priv->dev->dev,
+					"Cannot kmalloc ref to message name\n");
+				return -ENOMEM;
+			}
+		}
+		bytes_needed = msg->name_len - this->pos;
+		bytes_to_use = min(bytes_needed, *count);
+
+		if (copy_from_user(this->ref_name->name + this->pos,
+				   buf + *buf_pos, bytes_to_use)) {
+			dev_err(priv->dev->dev, "copy from user failed"
+			       " (name: %d of %d to %p + %u)\n",
+			       (unsigned)bytes_to_use, (unsigned)*count,
+			       this->ref_name->name, this->pos);
+			return -EFAULT;
+		}
+		if (bytes_needed == bytes_to_use) {
+			/*
+			 * We can check the name now it is in kernel space - we
+			 * want to do this before we sort out the data, since
+			 * that can involve a *lot* of copying...
+			 */
+			if (kbus_invalid_message_name(priv->dev,
+						      this->ref_name->name,
+						      msg->name_len))
+				return -EBADMSG;
+
+			this->msg->name_ref = this->ref_name;
+			this->ref_name = NULL;
+		}
+		break;
+
+	case KBUS_PART_NPAD:
+		bytes_needed = KBUS_PADDED_NAME_LEN(msg->name_len) -
+		    msg->name_len - this->pos;
+		bytes_to_use = min(bytes_needed, *count);
+		break;
+
+	case KBUS_PART_DATA:
+		if (msg->data_len == 0) {
+			bytes_needed = 0;
+			bytes_to_use = 0;
+			break;
+		}
+		if (this->ref_data == NULL) {
+			if (kbus_alloc_ref_data(priv, msg->data_len,
+						&this->ref_data))
+				return -ENOMEM;
+			this->ref_data_index = 0;	/* current part index */
+		}
+		/* Overall, how far are we through the message's data? */
+		bytes_needed = msg->data_len - this->pos;
+		bytes_to_use = min(bytes_needed, *count);
+		/* So let's add 'bytes_to_use' bytes to our message data */
+		retval = kbus_write_data_parts(priv, buf, *buf_pos,
+					       bytes_to_use);
+		if (retval) {
+			kbus_lower_data_ref(this->ref_data);
+			this->ref_data = NULL;
+			return retval;
+		}
+		if (bytes_needed == bytes_to_use) {
+			/* Hooray - we've finished our data */
+			this->msg->data_ref = this->ref_data;
+			this->ref_data = NULL;
+		}
+		break;
+
+	case KBUS_PART_DPAD:
+		bytes_needed = KBUS_PADDED_DATA_LEN(msg->data_len) -
+		    msg->data_len - this->pos;
+		bytes_to_use = min(bytes_needed, *count);
+		break;
+
+	case KBUS_PART_FINAL_GUARD:
+		bytes_needed = 4 - this->pos;
+		bytes_to_use = min(bytes_needed, *count);
+		if (copy_from_user((char *)(&this->guard) + this->pos,
+				   buf + *buf_pos, bytes_to_use)) {
+			dev_err(priv->dev->dev, "copy from user failed"
+			       " (final guard: %u of %u to %p + %u)\n",
+			       (unsigned)bytes_to_use, (unsigned)*count,
+			       &this->guard, this->pos);
+			return -EFAULT;
+		}
+		if (bytes_needed == bytes_to_use) {
+			if (this->guard != KBUS_MSG_END_GUARD) {
+				dev_err(priv->dev->dev, "pid %u [%s]"
+				       " (entire) message end guard is "
+				       "%08x, not %08x\n",
+				       current->pid, current->comm,
+				       this->guard, KBUS_MSG_END_GUARD);
+				return -EINVAL;
+			}
+			this->is_finished = true;
+		}
+		break;
+
+	default:
+		dev_err(priv->dev->dev, "Internal error in write: unexpected"
+		       " message part %d\n", this->which);
+		return -EFAULT;	/* what *should* it be? */
+	}
+
+	*count -= bytes_to_use;
+	*buf_pos += bytes_to_use;
+
+	if (bytes_needed == bytes_to_use) {
+		this->which++;
+		this->pos = 0;
+	} else {
+		this->pos += bytes_to_use;
+	}
+	return 0;
+}
+
+static ssize_t kbus_write(struct file *filp, const char __user *buf,
+			  size_t count, loff_t *f_pos __maybe_unused)
+{
+	struct kbus_private_data *priv = filp->private_data;
+	struct kbus_dev *dev = priv->dev;
+	ssize_t retval = 0;
+	size_t bytes_left = count;
+	size_t buf_pos = 0;
+
+	struct kbus_write_msg *this = &priv->write;
+
+	if (mutex_lock_interruptible(&dev->mux))
+		return -EAGAIN;
+
+	kbus_maybe_dbg(priv->dev, "%u WRITE count %u, pos %d\n",
+				   priv->id, (unsigned)count, (int)*f_pos);
+
+	/*
+	 * If we've already started to try sending a message, we don't
+	 * want to continue appending to it
+	 */
+	if (priv->sending) {
+		retval = -EALREADY;
+		goto done;
+	}
+
+	if (this->msg == NULL) {
+		/* Clearly, the start of a new message */
+		memset(this, 0, sizeof(*this));
 
-	filp->private_data = priv;
+		/* This is the new (internal) message we're preparing */
+		this->msg = kmalloc(sizeof(*(this->msg)), GFP_KERNEL);
+		if (!this->msg) {
+			retval = -ENOMEM;
+			goto done;
+		}
+		memset(this->msg, 0, sizeof(*(this->msg)));
+	}
 
-	mutex_unlock(&dev->mux);
+	while (bytes_left) {
+		retval = kbus_write_parts(priv, buf, &buf_pos, &bytes_left);
+		if (retval)
+			goto done;
+	}
 
-	kbus_maybe_dbg(dev, "%u OPEN\n", priv->id);
+done:
+	kbus_maybe_dbg(priv->dev, "%u WRITE ends with retval %d\n",
+		       priv->id, (int)retval);
 
-	return 0;
+	if (retval)
+		kbus_empty_write_msg(priv);
+	mutex_unlock(&dev->mux);
+	if (retval)
+		return retval;
+	else
+		return count;
 }
 
-static int kbus_release(struct inode *inode __always_unused, struct file *filp)
+static ssize_t kbus_read(struct file *filp, char __user *buf, size_t count,
+			 loff_t *f_pos __maybe_unused)
 {
-	int retval2 = 0;
 	struct kbus_private_data *priv = filp->private_data;
 	struct kbus_dev *dev = priv->dev;
+	struct kbus_read_msg *this = &(priv->read);
+	ssize_t retval = 0;
+	u32 len, left;
+	u32 which = this->which;
 
 	if (mutex_lock_interruptible(&dev->mux))
-		return -ERESTARTSYS;
+		return -EAGAIN;	/* Just try again later */
 
-	kbus_maybe_dbg(dev, "%u RELEASE\n", priv->id);
+	kbus_maybe_dbg(priv->dev, "%u READ count %u, pos %d\n",
+		       priv->id, (unsigned)count, (int)*f_pos);
 
-	kbus_forget_my_bindings(priv);
-	retval2 = kbus_forget_open_ksock(dev, priv->id);
-	kfree(priv);
+	if (this->msg == NULL) {
+		/* No message to read at the moment */
+		kbus_maybe_dbg(priv->dev, "  Nothing to read\n");
+		retval = 0;
+		goto done;
+	}
 
-	mutex_unlock(&dev->mux);
+	/*
+	 * Read each of the parts of a message until we're read 'count'
+	 * characters, or run off the end of the message.
+	 */
+	while (which < KBUS_NUM_PARTS && count > 0) {
+		if (this->lengths[which] == 0) {
+			kbus_maybe_dbg(priv->dev,
+				       "  xx which %d, read_len[%d] %u\n",
+				       which, which, this->lengths[which]);
+			this->pos = 0;
+			which++;
+			continue;
+		}
 
-	return retval2;
+		if (which == KBUS_PART_DATA) {
+			struct kbus_data_ptr *dp = this->msg->data_ref;
+
+			left = dp->lengths[this->ref_data_index] - this->pos;
+			len = min(left, (u32) count);
+			if (len) {
+				if (copy_to_user(buf,
+						 (void *)
+						 dp->parts[this->ref_data_index]
+							 + this->pos, len)) {
+					dev_err(priv->dev->dev,
+					       "error reading from %u\n",
+					       priv->id);
+					retval = -EFAULT;
+					goto done;
+				}
+				buf += len;
+				retval += len;
+				count -= len;
+				this->pos += len;
+			}
+
+			if (this->pos == dp->lengths[this->ref_data_index]) {
+				this->pos = 0;
+				this->ref_data_index++;
+			}
+			if (this->ref_data_index == dp->num_parts) {
+				this->pos = 0;
+				which++;
+			}
+		} else {
+			left = this->lengths[which] - this->pos;
+			len = min(left, (u32) count);
+			if (len) {
+				if (copy_to_user(buf,
+						 this->parts[which] + this->pos,
+						 len)) {
+					dev_err(priv->dev->dev,
+					       "error reading from %u\n",
+					       priv->id);
+					retval = -EFAULT;
+					goto done;
+				}
+				buf += len;
+				retval += len;
+				count -= len;
+				this->pos += len;
+			}
+
+			if (this->pos == this->lengths[which]) {
+				this->pos = 0;
+				which++;
+			}
+		}
+	}
+
+	if (which < KBUS_NUM_PARTS)
+		this->which = which;
+	else
+		kbus_empty_read_msg(priv);
+
+done:
+	mutex_unlock(&dev->mux);
+	return retval;
 }
 
 static int kbus_bind(struct kbus_private_data *priv,
@@ -651,12 +2712,507 @@ done:
 	return retval;
 }
 
+/*
+ * Make the next message ready for reading by the user.
+ *
+ * Returns 0 if there is no next message, 1 if there is, and a negative value
+ * if there's an error.
+ */
+static int kbus_nextmsg(struct kbus_private_data *priv,
+			unsigned long arg)
+{
+	int retval = 0;
+	struct kbus_msg *msg;
+	struct kbus_read_msg *this = &(priv->read);
+	struct kbus_message_header *user_msg;
+
+	kbus_maybe_dbg(priv->dev, "%u NEXTMSG\n", priv->id);
+
+	/* If we were partway through a message, lose it */
+	if (this->msg) {
+		kbus_maybe_dbg(priv->dev, "  Dropping partial message\n");
+		kbus_empty_read_msg(priv);
+	}
+
+	/* Have we got a next message? */
+	msg = kbus_pop_message(priv);
+	if (msg == NULL) {
+		kbus_maybe_dbg(priv->dev, "  No next message\n");
+		/*
+		 * A return value of 0 means no message, and that's
+		 * what __put_user returns for success.
+		 */
+		return __put_user(0, (u32 __user *) arg);
+	}
+
+	user_msg = (struct kbus_message_header *)&this->user_hdr;
+	user_msg->start_guard = KBUS_MSG_START_GUARD;
+	user_msg->id = msg->id;
+	user_msg->in_reply_to = msg->in_reply_to;
+	user_msg->to = msg->to;
+	user_msg->from = msg->from;
+	user_msg->orig_from = msg->orig_from;
+	user_msg->final_to = msg->final_to;
+	user_msg->extra = msg->extra;
+	user_msg->flags = msg->flags;
+	user_msg->name_len = msg->name_len;
+	user_msg->data_len = msg->data_len;
+	user_msg->name = NULL;
+	user_msg->data = NULL;
+	user_msg->end_guard = KBUS_MSG_END_GUARD;
+
+	this->msg = msg;	/* Remember it so we can free it later */
+
+	this->parts[KBUS_PART_HDR] = (char *)user_msg;
+	this->parts[KBUS_PART_NAME] = msg->name_ref->name;
+	/* direct to the string */
+
+	this->parts[KBUS_PART_NPAD] = static_zero_padding;
+
+	/* The data is treated specially - see kbus_read() */
+	this->parts[KBUS_PART_DATA] = (char *)msg->data_ref;
+
+	this->parts[KBUS_PART_DPAD] = static_zero_padding;
+	this->parts[KBUS_PART_FINAL_GUARD] = (char *)&static_end_guard;
+
+	this->lengths[KBUS_PART_HDR] = sizeof(*user_msg);
+	this->lengths[KBUS_PART_NAME] = msg->name_len;
+	this->lengths[KBUS_PART_NPAD] =
+	    KBUS_PADDED_NAME_LEN(msg->name_len) - msg->name_len;
+
+	/* The data is treated specially - see kbus_read() */
+	this->lengths[KBUS_PART_DATA] = msg->data_len;
+	this->lengths[KBUS_PART_DPAD] =
+	    KBUS_PADDED_DATA_LEN(msg->data_len) - msg->data_len;
+
+	this->lengths[KBUS_PART_FINAL_GUARD] = 4;
+
+	/* And we'll be starting by writing out the first thing first */
+	this->which = 0;
+	this->pos = 0;
+	this->ref_data_index = 0;
+
+	/*
+	 * If the message is a request (to us), then this is the approriate
+	 * point to add it to our list of "requests we've read but not yet
+	 * replied to" -- although that *sounds* as if we should be doing it in
+	 * kbus_read, we might never get round to reading the content of the
+	 * message (we might call NEXTMSG again, or DISCARD), and also
+	 * kbus_read can get called multiple times for a single message body.
+	 * If we do our remembering here, then we guarantee to get one memory
+	 * for each request, as it leaves the message queue and is (in whatever
+	 * way) dealt with.
+	 */
+	if (msg->flags & KBUS_BIT_WANT_YOU_TO_REPLY) {
+		retval = kbus_reply_needed(priv, msg);
+		/* If it couldn't malloc, there's not much we can do,
+		 * it's fairly fatal */
+		if (retval)
+			return retval;
+	}
+
+	retval = __put_user(KBUS_ENTIRE_MSG_LEN(msg->name_len, msg->data_len),
+			    (u32 __user *) arg);
+	if (retval)
+		return retval;
+	return 1;	/* We had a message */
+}
+
 /* How much of the current message is left to read? */
 extern u32 kbus_lenleft(struct kbus_private_data *priv)
 {
+	struct kbus_read_msg *this = &(priv->read);
+	if (this->msg) {
+		int ii, jj;
+		u32 sofar = 0;
+		u32 total = KBUS_ENTIRE_MSG_LEN(this->msg->name_len,
+						     this->msg->data_len);
+		/* Add up the items we're read all of, so far */
+		for (ii = 0; ii < this->which; ii++) {
+			if (this->which == KBUS_PART_DATA &&
+			    this->msg->data_len > 0) {
+				struct kbus_data_ptr *dp = this->msg->data_ref;
+				for (jj = 0; jj < this->ref_data_index; jj++)
+					sofar += dp->lengths[jj];
+				if (this->ref_data_index < dp->num_parts)
+					sofar += this->pos;
+			} else {
+				sofar += this->lengths[ii];
+			}
+		}
+		/* Plus what we're read of the last one */
+		if (this->which < KBUS_NUM_PARTS) {
+			if (this->which == KBUS_PART_DATA &&
+			    this->msg->data_len > 0) {
+				struct kbus_data_ptr *dp = this->msg->data_ref;
+				for (jj = 0; jj < this->ref_data_index; jj++)
+					sofar += dp->lengths[jj];
+				if (this->ref_data_index < dp->num_parts)
+					sofar += this->pos;
+			} else {
+				sofar += this->pos;
+			}
+		}
+		return total - sofar;
+	}
 	return 0; /* no message => nothing to read */
 }
 
+/*
+ * Allocate the data arrays we need to hold reference-counted data, possibly
+ * spread over multiple pages. 'data_len' is from the message header.
+ *
+ * Note that the 'lengths[n]' field to each page 'n' will be set to zero.
+ */
+static int kbus_alloc_ref_data(struct kbus_private_data *priv __maybe_unused,
+			       u32 data_len,
+			       struct kbus_data_ptr **ret_ref_data)
+{
+	int num_parts = 0;
+	unsigned long *parts = NULL;
+	unsigned *lengths = NULL;
+	unsigned last_page_len = 0;
+	struct kbus_data_ptr *ref_data = NULL;
+	int as_pages;
+	int ii;
+
+	*ret_ref_data = NULL;
+
+	num_parts = (data_len + KBUS_PART_LEN - 1) / KBUS_PART_LEN;
+
+	/*
+	 * To save recalculating the length of the last page every time
+	 * we're interested, get it right once and for all.
+	 */
+	last_page_len = data_len - (num_parts - 1) * KBUS_PART_LEN;
+
+	kbus_maybe_dbg(priv->dev,
+		       "%u Allocate ref data: part=%lu, "
+		       "threshold=%lu, data_len %u -> num_parts %d\n",
+		       priv->id, KBUS_PART_LEN,
+		       KBUS_PAGE_THRESHOLD, data_len, num_parts);
+
+	parts = kmalloc(sizeof(*parts) * num_parts, GFP_KERNEL);
+	if (!parts)
+		return -ENOMEM;
+	lengths = kmalloc(sizeof(*lengths) * num_parts, GFP_KERNEL);
+	if (!lengths) {
+		kfree(parts);
+		return -ENOMEM;
+	}
+
+	if (num_parts == 1 && data_len < KBUS_PAGE_THRESHOLD) {
+		/* A single part in "simple" memory */
+		as_pages = false;
+		parts[0] = (unsigned long)kmalloc(data_len, GFP_KERNEL);
+		if (!parts[0]) {
+			kfree(lengths);
+			kfree(parts);
+			return -ENOMEM;
+		}
+		lengths[0] = 0;
+	} else {
+		/*
+		 * One or more pages
+		 *
+		 * For simplicity, we make all of our pages be full pages.
+		 * In theory, we could use the same rules for the last page
+		 * as we do if we only have a single page - but for the
+		 * moment, we're not bothering.
+		 *
+		 * This means that the 'last_page_len' is strictly theoretical
+		 * for the moment...
+		 */
+		as_pages = true;
+		for (ii = 0; ii < num_parts; ii++) {
+			parts[ii] = __get_free_page(GFP_KERNEL);
+			if (!parts[ii]) {
+				int jj;
+				for (jj = 0; jj < ii; jj++)
+					free_page(parts[jj]);
+				kfree(lengths);
+				kfree(parts);
+				return -ENOMEM;
+			}
+			lengths[ii] = 0;
+		}
+	}
+	ref_data = kbus_wrap_data_in_ref(as_pages, num_parts, parts, lengths,
+					 last_page_len);
+	if (!ref_data) {
+		int jj;
+		if (as_pages)
+			for (jj = 0; jj < num_parts; jj++)
+				free_page(parts[jj]);
+		else
+			kfree((void *)parts[0]);
+		kfree(lengths);
+		kfree(parts);
+		return -ENOMEM;
+	}
+	*ret_ref_data = ref_data;
+	return 0;
+}
+
+/*
+ * Does what it says on the box - take the user data and promote it to kernel
+ * space, as a reference counted quantity, possibly spread over multiple pages.
+ */
+static int kbus_wrap_user_data(struct kbus_private_data *priv,
+			       u32 data_len,
+			       void *user_data_ptr,
+			       struct kbus_data_ptr **new_data)
+{
+	struct kbus_data_ptr *ref_data = NULL;
+	int num_parts;
+	unsigned long *parts;
+	unsigned *lengths;
+	int ii;
+	uint8_t __user *data_ptr;
+
+	int retval = kbus_alloc_ref_data(priv, data_len, &ref_data);
+	if (retval)
+		return retval;
+
+	num_parts = ref_data->num_parts;
+	lengths = ref_data->lengths;
+	parts = ref_data->parts;
+
+	kbus_maybe_dbg(priv->dev, "  @@ copying %s\n",
+		       ref_data->as_pages ? "as pages" : "as kmalloc'ed data");
+
+	/* Given all of the *space* for our data, populate it */
+	data_ptr = (void __user *) user_data_ptr;
+	for (ii = 0; ii < num_parts; ii++) {
+		unsigned len;
+		if (ii == num_parts - 1)
+			len = ref_data->last_page_len;
+		else
+			len = KBUS_PART_LEN;
+
+		kbus_maybe_dbg(priv->dev,
+			       "  @@ %d: copy %d bytes "
+			       "from user address %lu\n",
+			       ii, len, parts[ii]);
+
+		if (copy_from_user((void *)parts[ii], data_ptr, len)) {
+			kbus_lower_data_ref(ref_data);
+			return -EFAULT;
+		}
+		lengths[ii] = len;
+		data_ptr += len;
+	}
+	*new_data = ref_data;
+	return 0;
+}
+
+/*
+ * Given a "pointy" message header, copy the message name and data from
+ * user space into kernel space.
+ *
+ * The message name is copied as a reference-counted string.
+ *
+ * The message data (if any) is copied as reference-counted data.
+ *
+ * Also checks the legality of the message name, since we need the name in
+ * kernel space to do that, but prefer to do the check before copying any
+ * data (which can be expensive).
+ */
+static int kbus_copy_pointy_parts(struct kbus_private_data *priv,
+				  struct kbus_write_msg *this)
+{
+	struct kbus_msg *msg = this->msg;
+	char *new_name = NULL;
+	struct kbus_name_ptr *name_ref;
+	struct kbus_data_ptr *new_data = NULL;
+
+	/* First, let's deal with the name */
+	new_name = kmalloc(msg->name_len + 1, GFP_KERNEL);
+	if (!new_name)
+		return -ENOMEM;
+	if (copy_from_user
+	    (new_name, (void __user *)this->user_name_ptr, msg->name_len + 1)) {
+		kfree(new_name);
+		return -EFAULT;
+	}
+
+	/*
+	 * We can check the name now it is in kernel space - we want
+	 * to do this before we sort out the data, since that can involve
+	 * a *lot* of copying...
+	 */
+	if (kbus_invalid_message_name(priv->dev, new_name, msg->name_len)) {
+		kfree(new_name);
+		return -EBADMSG;
+	}
+	name_ref = kbus_wrap_name_in_ref(new_name);
+	if (!name_ref) {
+		kfree(new_name);
+		return -ENOMEM;
+	}
+
+	/* Now for the data. */
+	if (msg->data_len) {
+		int retval = kbus_wrap_user_data(priv, msg->data_len,
+						 this->user_data_ptr,
+						 &new_data);
+		if (retval) {
+			kbus_lower_name_ref(name_ref);
+			return retval;
+		}
+	}
+
+	kbus_maybe_dbg(priv->dev, "  'pointy' message normalised\n");
+
+	msg->name_ref = name_ref;
+	msg->data_ref = new_data;
+
+	this->user_name_ptr = NULL;
+	this->user_data_ptr = NULL;
+	this->pointers_are_local = true;
+
+	return 0;
+}
+
+static void kbus_discard(struct kbus_private_data *priv)
+{
+	kbus_empty_write_msg(priv);
+	priv->sending = false;
+}
+
+/*
+ * Returns 0 for success, and a negative value if there's an error.
+ */
+static int kbus_send(struct kbus_private_data *priv,
+		     struct kbus_dev *dev, unsigned long arg)
+{
+	ssize_t retval = 0;
+	struct kbus_msg *msg = priv->write.msg;
+
+	kbus_maybe_dbg(priv->dev, "%u SEND\n", priv->id);
+
+	if (priv->write.msg == NULL)
+		return -ENOMSG;
+
+	if (!priv->write.is_finished) {
+		dev_err(priv->dev->dev, "pid %u [%s]"
+		       " message not finished (in part %d of message)\n",
+		       current->pid, current->comm, priv->write.which);
+		retval = -EINVAL;
+		goto done;
+	}
+
+	/*
+	 * Users are not allowed to send messages marked as "synthetic"
+	 * (since, after all, if the user sends it, it is not). However,
+	 * it's possible that, in good faith, they re-sent a synthetic
+	 * message that they received earlier, so we shall take care to
+	 * unset the bit, if necessary.
+	 */
+	if (KBUS_BIT_SYNTHETIC & msg->flags)
+		msg->flags &= ~KBUS_BIT_SYNTHETIC;
+
+	/*
+	 * The "extra" field is reserved for future expansion, so for the
+	 * moment we always zero it (this stops anyone from trying to take
+	 * advantage of it, and getting caught out when we decide WE want it)
+	 */
+	msg->extra = 0;
+
+	/*
+	 * The message header is already in kernel space (thanks to kbus_write),
+	 * but if it's a "pointy" message, the name and data are not. So let's
+	 * fix that.
+	 *
+	 * Note that we *always* end up with a message header containing
+	 * pointers to (copies of) the name and (if given) data, and the
+	 * data reference counted, and maybe split over multiple pages.
+	 *
+	 *     Note that if this is a message we already tried to send
+	 *     earlier, any "pointy" parts would have been copied earlier,
+	 *     hence the check we actually make.
+	 */
+	if (!priv->write.pointers_are_local) {
+		retval = kbus_copy_pointy_parts(priv, &priv->write);
+		if (retval)
+			goto done;
+	}
+
+	/* ================================================================= */
+	/*
+	 * If this message is a Request, then we can't send it until/unless
+	 * we've got room in our message queue to receive the Reply.
+	 *
+	 * We do this check here, rather than in kbus_write_to_recipients,
+	 * because:
+	 *
+	 * a) kbus_write_to_recipients gets (re)called by the POLL interface,
+	 *    and at that stage KBUS *knows* that there is room for the
+	 *    message concerned (so the checking code would need to know not
+	 *    to check)
+	 *
+	 * b) If the check fails, we do not want to consider ourselves in
+	 *    "sending" state, since we can't afford to block, because it's
+	 *    *this Ksock* that needs to do some reading to clear the relevant
+	 *    queue, and it can't do that if it's blocking. So we'd either
+	 *    need to handle that (somehow), or just do the check here.
+	 *
+	 * Similarly, we don't finalise the message (put in its "from" and "id"
+	 * fields) until we pass this test.
+	 */
+	if ((msg->flags & KBUS_BIT_WANT_A_REPLY) &&
+	    kbus_queue_is_full(priv, "sender", false)) {
+		dev_err(priv->dev->dev, "%u Unable to send Request becausei"
+			" no room for a Reply in sender's message queue\n",
+			priv->id);
+		retval = -ENOLCK;
+		goto done;
+	}
+	/* ================================================================= */
+
+	/* So, we're actually ready to SEND! */
+
+	/* The message needs to say it is from us */
+	msg->from = priv->id;
+
+	/*
+	 * If we've already tried to send this message earlier (and
+	 * presumably failed with -EAGAIN), then we don't need to give
+	 * it a message id, because it already has one...
+	 */
+	if (!priv->sending) {
+		/* The message seems well formed, give it an id if necessary */
+		if (msg->id.network_id == 0)
+			msg->id.serial_num = kbus_next_serial_num(dev);
+	}
+
+	/* Also, remember this as the "message we last (tried to) send" */
+	priv->last_msg_id_sent = msg->id;
+
+	/*
+	 * Figure out who should receive this message, and write it to them
+	 */
+	retval = kbus_write_to_recipients(priv, dev, msg);
+
+done:
+	/*
+	 * -EAGAIN means we were blocked from sending, and the caller
+	 *  should try again (as one might expect).
+	 */
+	if (retval == -EAGAIN)
+		/* Remember we're still trying to send this message */
+		priv->sending = true;
+	else
+		/* We've now finished with our copy of the message header */
+		kbus_discard(priv);
+
+	if (retval == 0 || retval == -EAGAIN)
+		if (copy_to_user((void __user *)arg, &priv->last_msg_id_sent,
+				 sizeof(priv->last_msg_id_sent)))
+			retval = -EFAULT;
+	return retval;
+}
+
 static int kbus_maxmsgs(struct kbus_private_data *priv,
 			unsigned long arg)
 {
@@ -800,6 +3356,60 @@ static long kbus_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		retval = kbus_replier(priv, dev, arg);
 		break;
 
+	case KBUS_IOC_NEXTMSG:
+		/*
+		 * Get the next message ready to be read, and return its
+		 * length.
+		 *
+		 * arg in:  none
+		 * arg out: number of bytes in next message
+		 * retval:  0 if no next message, 1 if there is a next message,
+		 *          negative value if there's an error.
+		 */
+		retval = kbus_nextmsg(priv, arg);
+		break;
+
+	case KBUS_IOC_LENLEFT:
+		/* How many bytes are left to read in the current message? */
+		{
+			u32 left = kbus_lenleft(priv);
+			kbus_maybe_dbg(priv->dev, "%u LENLEFT %u\n",
+				       id, left);
+			retval = __put_user(left, (u32 __user *) arg);
+		}
+		break;
+
+	case KBUS_IOC_SEND:
+		/*
+		 * Send the curent message, we've finished writing it.
+		 *
+		 * arg in: <ignored>
+		 * arg out: the message id of said message
+		 * retval: negative for bad message, etc., 0 otherwise
+		 */
+		retval = kbus_send(priv, dev, arg);
+		break;
+
+	case KBUS_IOC_DISCARD:
+		/* Throw away the message we're currently writing. */
+		kbus_maybe_dbg(priv->dev, "%u DISCARD\n", id);
+		kbus_discard(priv);
+		break;
+
+	case KBUS_IOC_LASTSENT:
+		/*
+		 * What was the message id of the last message written to this
+		 * file descriptor? Before any messages have been written to
+		 * this file descriptor, this ioctl will return {0,0).
+		 */
+		kbus_maybe_dbg(priv->dev, "%u LASTSENT %u:%u\n", id,
+			       priv->last_msg_id_sent.network_id,
+			       priv->last_msg_id_sent.serial_num);
+		if (copy_to_user((void __user *)arg, &priv->last_msg_id_sent,
+					sizeof(priv->last_msg_id_sent)))
+			retval = -EFAULT;
+		break;
+
 	case KBUS_IOC_MAXMSGS:
 		/*
 		 * Set (and/or query) maximum number of messages in this
@@ -821,6 +3431,14 @@ static long kbus_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		retval = kbus_nummsgs(priv, dev, arg);
 		break;
 
+	case KBUS_IOC_UNREPLIEDTO:
+		/* How many Requests (to us) do we still owe Replies to? */
+		kbus_maybe_dbg(priv->dev, "%u UNREPLIEDTO %d\n",
+			       id, priv->num_replies_unsent);
+		retval = __put_user(priv->num_replies_unsent,
+				(u32 __user *) arg);
+		break;
+
 	case KBUS_IOC_VERBOSE:
 		/*
 		 * Should we output verbose/debug messages?
@@ -842,10 +3460,110 @@ static long kbus_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	return retval;
 }
 
+/*
+ * Try sending the (current waiting to be sent) message
+ *
+ * Returns true if the message has either been successfully sent, or an error
+ * occcurred (which has been dealt with) and there is no longer a current
+ * message.
+ *
+ * Returns false if we hit EAGAIN (again) and we're still trying to send the
+ * current message.
+ */
+static int kbus_poll_try_send_again(struct kbus_private_data *priv,
+				    struct kbus_dev *dev)
+{
+	int retval;
+	struct kbus_msg *msg = priv->write.msg;
+
+	retval = kbus_write_to_recipients(priv, dev, msg);
+
+	switch (-retval) {
+	case 0:		/* All is well, nothing to do */
+		break;
+	case EAGAIN:		/* Still blocked by *someone* - nowt to do */
+		break;
+	case EADDRNOTAVAIL:
+		/*
+		 * It's a Request and there's no Replier (presumably there was
+		 * when the initial SEND was done, but now they've gone away).
+		 * A Request *needs* a Reply...
+		 */
+		kbus_push_synthetic_message(dev, 0, msg->from, msg->id,
+					    KBUS_MSG_NAME_REPLIER_DISAPPEARED);
+		retval = 0;
+		break;
+	default:
+		/*
+		 * Send *failed* - what can we do?
+		 * Not much, perhaps, but we must ensure that a Request gets
+		 * (some sort of) reply
+		 */
+		if (msg->flags & KBUS_BIT_WANT_A_REPLY)
+			kbus_push_synthetic_message(dev, 0, msg->from, msg->id,
+					    KBUS_MSG_NAME_ERROR_SENDING);
+		retval = 0;
+		break;
+	}
+
+	if (retval == 0) {
+		kbus_discard(priv);
+		return true;
+	}
+	return false;
+}
+
+static unsigned int kbus_poll(struct file *filp, poll_table * wait)
+{
+	struct kbus_private_data *priv = filp->private_data;
+	struct kbus_dev *dev = priv->dev;
+	unsigned mask = 0;
+
+	mutex_lock(&dev->mux);
+
+	kbus_maybe_dbg(priv->dev, "%u POLL\n", priv->id);
+
+	/*
+	 * Did I wake up because there's a message available to be read?
+	 */
+	if (priv->message_count != 0)
+		mask |= POLLIN | POLLRDNORM;	/* readable */
+
+	/*
+	 * Did I wake up because someone said they had space for a message on
+	 * their message queue (where there wasn't space before)?
+	 *
+	 * And if that is the case, if we're opened for write and have a
+	 * message waiting to be sent, can we now send it?
+	 *
+	 * The simplest way to find out is just to try again.
+	 */
+	if (filp->f_mode & FMODE_WRITE) {
+		int writable = true;
+		if (priv->sending)
+			writable = kbus_poll_try_send_again(priv, dev);
+		if (writable)
+			mask |= POLLOUT | POLLWRNORM;
+	}
+
+	/* Wait until someone has a message waiting to be read */
+	poll_wait(filp, &priv->read_wait, wait);
+
+	/* Wait until someone has a space into which a message can be pushed */
+	if (priv->sending)
+		poll_wait(filp, &dev->write_wait, wait);
+
+	mutex_unlock(&dev->mux);
+	return mask;
+}
+
 /* File operations for /dev/kbus<n> */
 static const struct file_operations kbus_fops = {
 	.owner = THIS_MODULE,
+	.read = kbus_read,
+	.write = kbus_write,
 	.unlocked_ioctl = kbus_ioctl,
+	.poll = kbus_poll,
 	.open = kbus_open,
 	.release = kbus_release,
 };
@@ -867,6 +3585,8 @@ static void kbus_setup_cdev(struct kbus_dev *dev, int devno)
 	INIT_LIST_HEAD(&dev->bound_message_list);
 	INIT_LIST_HEAD(&dev->open_ksock_list);
 
+	init_waitqueue_head(&dev->write_wait);
+
 	dev->next_ksock_id = 0;
 	dev->next_msg_serial_num = 0;
 
-- 
1.7.4.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073Ab2JPAiu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 20:38:50 -0400
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:43213 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755324Ab2JPAhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 20:37:55 -0400
Subject: [PATCH 05/10] VMCI: event handling implementation.
To: linux-kernel@vger.kernel.org, georgezhang@vmware.com,
        virtualization@lists.linux-foundation.org
From: George Zhang <georgezhang@vmware.com>
Cc: pv-drivers@vmware.com, vm-crosstalk@vmware.com, gregkh@linuxfoundation.org
Date: Mon, 15 Oct 2012 17:28:59 -0700
Message-ID: <20121016002852.26205.19738.stgit@promb-2n-dhcp175.eng.vmware.com>
In-Reply-To: <20121016002550.26205.67037.stgit@promb-2n-dhcp175.eng.vmware.com>
References: <20121016002550.26205.67037.stgit@promb-2n-dhcp175.eng.vmware.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VMCI event code that manages event handlers and handles callbacks when specific events fire.


Signed-off-by: George Zhang <georgezhang@vmware.com>
---
 drivers/misc/vmw_vmci/vmci_event.c |  415 ++++++++++++++++++++++++++++++++++++
 drivers/misc/vmw_vmci/vmci_event.h |   25 ++
 2 files changed, 440 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/vmw_vmci/vmci_event.c
 create mode 100644 drivers/misc/vmw_vmci/vmci_event.h

diff --git a/drivers/misc/vmw_vmci/vmci_event.c b/drivers/misc/vmw_vmci/vmci_event.c
new file mode 100644
index 0000000..977550d
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmci_event.c
@@ -0,0 +1,415 @@
+/*
+ * VMware VMCI Driver
+ *
+ * Copyright (C) 2012 VMware, Inc. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation version 2 and no later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
+ * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ * for more details.
+ */
+
+#include <linux/vmw_vmci_defs.h>
+#include <linux/vmw_vmci_api.h>
+#include <linux/completion.h>
+#include <linux/kref.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+
+#include "vmci_driver.h"
+#include "vmci_event.h"
+
+#define EVENT_MAGIC 0xEABE0000
+#define VMCI_EVENT_MAX_ATTEMPTS 10
+
+struct vmci_subscription {
+	u32 id;
+	u32 event;
+	struct kref kref;
+	struct completion done;	/* unregistered, ready to be freed */
+	vmci_event_cb callback;
+	void *callback_data;
+	struct list_head node;	/* on one of subscriber lists */
+	bool run_delayed;
+};
+
+static struct list_head subscriber_array[VMCI_EVENT_MAX];
+static DEFINE_MUTEX(subscriber_mutex);
+
+struct delayed_event_info {
+	struct work_struct work;
+	struct vmci_subscription *sub;
+	u8 event_payload[sizeof(struct vmci_event_data_max)];
+};
+
+struct event_ref {
+	struct vmci_subscription *sub;
+	struct list_head list_item;
+};
+
+int __init vmci_event_init(void)
+{
+	int i;
+
+	for (i = 0; i < VMCI_EVENT_MAX; i++)
+		INIT_LIST_HEAD(&subscriber_array[i]);
+
+	return VMCI_SUCCESS;
+}
+
+void vmci_event_exit(void)
+{
+	int e;
+
+	/* We free all memory at exit. */
+	for (e = 0; e < VMCI_EVENT_MAX; e++) {
+		struct vmci_subscription *cur, *p2;
+		list_for_each_entry_safe(cur, p2, &subscriber_array[e], node) {
+
+			/*
+			 * We should never get here because all events
+			 * should have been unregistered before we try
+			 * to unload the driver module.  Also, delayed
+			 * callbacks could still be firing so this
+			 * cleanup would not be safe.  Still it is
+			 * better to free the memory than not ... so
+			 * we leave this code in just in case....
+			 */
+			pr_warn("Unexpected free events occuring.");
+			kfree(cur);
+		}
+	}
+
+}
+
+/*
+ * Gets a reference to the given VMCISubscription.
+ */
+static struct vmci_subscription *event_get(struct vmci_subscription *entry)
+{
+	kref_get(&entry->kref);
+
+	return entry;
+}
+
+static void event_signal_destroy(struct kref *kref)
+{
+	struct vmci_subscription *entry =
+			container_of(kref, struct vmci_subscription, kref);
+
+	complete(&entry->done);
+}
+
+/*
+ * Releases the given VMCISubscription.
+ * Fires the destroy event if the reference count has gone to zero.
+ */
+static void event_release(struct vmci_subscription *entry)
+{
+	kref_put(&entry->kref, event_signal_destroy);
+}
+
+/*
+ * Find entry. Assumes lock is held.
+ */
+static struct vmci_subscription *event_find(u32 sub_id)
+{
+	int e;
+
+	for (e = 0; e < VMCI_EVENT_MAX; e++) {
+		struct vmci_subscription *cur;
+		list_for_each_entry(cur, &subscriber_array[e], node) {
+			if (cur->id == sub_id)
+				return cur;
+		}
+	}
+	return NULL;
+}
+
+/*
+ * Calls the specified callback in a delayed context.
+ */
+static void event_delayed_dispatch(struct work_struct *work)
+{
+	struct delayed_event_info *event_info =
+			container_of(work, struct delayed_event_info, work);
+	struct vmci_subscription *sub = event_info->sub;
+	struct vmci_event_data *ed;
+
+	BUG_ON(!sub);
+
+	ed = (struct vmci_event_data *)event_info->event_payload;
+
+	sub->callback(sub->id, ed, sub->callback_data);
+	event_release(sub);
+
+	kfree(event_info);
+}
+
+/*
+ * Actually delivers the events to the subscribers.
+ * The callback function for each subscriber is invoked.
+ */
+static int event_deliver(struct vmci_event_msg *event_msg)
+{
+	int err = VMCI_SUCCESS;
+	struct vmci_subscription *cur;
+	struct list_head *subscriber_list;
+	struct list_head no_delay_list;
+	struct vmci_event_data *ed;
+	struct event_ref *event_ref, *p2;
+
+	ASSERT(event_msg);
+
+	INIT_LIST_HEAD(&no_delay_list);
+
+	rcu_read_lock();
+	subscriber_list = &subscriber_array[event_msg->event_data.event];
+	list_for_each_entry_rcu(cur, subscriber_list, node) {
+		ASSERT(cur && cur->event == event_msg->event_data.event);
+
+		if (cur->run_delayed) {
+			struct delayed_event_info *event_info;
+
+			event_info = kzalloc(sizeof(*event_info), GFP_ATOMIC);
+			if (!event_info) {
+				err = VMCI_ERROR_NO_MEM;
+				goto out;
+			}
+
+			INIT_WORK(&event_info->work, event_delayed_dispatch);
+			event_info->sub = event_get(cur);
+			memcpy(event_info->event_payload,
+			       VMCI_DG_PAYLOAD(event_msg),
+			       (size_t) event_msg->hdr.payload_size);
+
+			schedule_work(&event_info->work);
+
+		} else {
+			/*
+			 * To avoid possible lock rank voilation when holding
+			 * subscriber_lock, we construct a local list of
+			 * subscribers and release subscriber_lock before
+			 * invokes the callbacks. This is similar to delayed
+			 * callbacks, but callbacks is invoked right away here.
+			 */
+			event_ref = kmalloc(sizeof(*event_ref), GFP_ATOMIC);
+			if (!event_ref) {
+				err = VMCI_ERROR_NO_MEM;
+				goto out;
+			}
+
+			event_ref->sub = event_get(cur);
+			INIT_LIST_HEAD(&event_ref->list_item);
+			list_add(&event_ref->list_item, &no_delay_list);
+		}
+	}
+
+ out:
+	rcu_read_unlock();
+
+	list_for_each_entry_safe(event_ref, p2, &no_delay_list, list_item) {
+		u8 event_payload[sizeof(struct vmci_event_data_max)] = { 0 };
+
+		/*
+		 * We set event data before each callback to ensure
+		 * isolation.
+		 */
+		memcpy(event_payload, VMCI_DG_PAYLOAD(event_msg),
+		       (size_t) event_msg->hdr.payload_size);
+		ed = (struct vmci_event_data *)event_payload;
+		cur = event_ref->sub;
+		cur->callback(cur->id, ed, cur->callback_data);
+		event_release(cur);
+
+		kfree(event_ref);
+	}
+
+	return err;
+}
+
+/*
+ * Dispatcher for the VMCI_EVENT_RECEIVE datagrams. Calls all
+ * subscribers for given event.
+ */
+int vmci_event_dispatch(struct vmci_datagram *msg)
+{
+	struct vmci_event_msg *event_msg = (struct vmci_event_msg *)msg;
+
+	ASSERT(msg &&
+	       msg->src.context == VMCI_HYPERVISOR_CONTEXT_ID &&
+	       msg->dst.resource == VMCI_EVENT_HANDLER);
+
+	if (msg->payload_size < sizeof(u32) ||
+	    msg->payload_size > sizeof(struct vmci_event_data_max))
+		return VMCI_ERROR_INVALID_ARGS;
+
+	if (!VMCI_EVENT_VALID(event_msg->event_data.event))
+		return VMCI_ERROR_EVENT_UNKNOWN;
+
+	event_deliver(event_msg);
+	return VMCI_SUCCESS;
+}
+
+/*
+ * Initialize and add subscription to subscriber list.
+ */
+static int event_register_subscription(struct vmci_subscription *sub,
+				       u32 event,
+				       u32 flags,
+				       vmci_event_cb callback,
+				       void *callback_data)
+{
+	static u32 subscription_id;
+	int attempts;
+	int result;
+	bool success = false;
+
+	ASSERT(sub);
+
+	if (!VMCI_EVENT_VALID(event) || callback == NULL) {
+		pr_devel("Failed to subscribe to event (type=%d) "
+			 "(callback=%p) (data=%p).", event,
+			 callback, callback_data);
+		return VMCI_ERROR_INVALID_ARGS;
+	}
+
+	sub->run_delayed = flags & VMCI_FLAG_EVENT_DELAYED_CB;
+	sub->event = event;
+	sub->callback = callback;
+	sub->callback_data = callback_data;
+	kref_init(&sub->kref);
+	init_completion(&sub->done);
+	INIT_LIST_HEAD(&sub->node);
+
+	mutex_lock(&subscriber_mutex);
+
+	/* Creation of a new event is always allowed. */
+	for (attempts = 0; attempts < VMCI_EVENT_MAX_ATTEMPTS; attempts++) {
+		struct vmci_subscription *existing_sub = NULL;
+
+		/*
+		 * We try to get an id a couple of time before
+		 * claiming we are out of resources.
+		 */
+		sub->id = ++subscription_id;
+
+		/* Test for duplicate id. */
+		existing_sub = event_find(sub->id);
+		if (!existing_sub) {
+			success = true;
+			break;
+		}
+	}
+
+	if (success) {
+		list_add_rcu(&sub->node, &subscriber_array[event]);
+		result = VMCI_SUCCESS;
+	} else {
+		result = VMCI_ERROR_NO_RESOURCES;
+	}
+
+	mutex_unlock(&subscriber_mutex);
+	return result;
+}
+
+/*
+ * Remove subscription from subscriber list.
+ */
+static struct vmci_subscription *event_unregister_subscription(u32 sub_id)
+{
+	struct vmci_subscription *s;
+
+	mutex_lock(&subscriber_mutex);
+	s = event_find(sub_id);
+	if (s)
+		list_del_rcu(&s->node);
+	mutex_unlock(&subscriber_mutex);
+
+	if (s) {
+		synchronize_rcu();
+		event_release(s);
+		wait_for_completion(&s->done);
+	}
+
+	return s;
+}
+
+/*
+ * vmci_event_subscribe() - Subscribe to a given event.
+ * @event:      The event to subscribe to.
+ * @flags:      Event flags.  VMCI_FLAG_EVENT_*
+ * @callback:   The callback to invoke upon the event.
+ * @callback_data:      Data to pass to the callback.
+ * @subscription_id:    ID used to track subscription.  Used with
+ *              vmci_event_unscribe()
+ *
+ * Subscribes to the provided event.  The callback specified can be fired
+ * in different contexts depending on what flag is specified while
+ * registering. If flags contains VMCI_FLAG_EVENT_NONE then the
+ * callback is fired with the subscriber lock held (and BH context
+ * on the guest). If flags contain VMCI_FLAG_EVENT_DELAYED_CB then
+ * the callback is fired with no locks held in thread context.
+ * This is useful because other VMCIEvent functions can be called,
+ * but it also increases the chances that an event will be dropped.
+ */
+int vmci_event_subscribe(u32 event,
+			 u32 flags,
+			 vmci_event_cb callback,
+			 void *callback_data,
+			 u32 *subscription_id)
+{
+	int retval;
+	struct vmci_subscription *s = NULL;
+
+	if (subscription_id == NULL) {
+		pr_devel("Invalid subscription (NULL).");
+		return VMCI_ERROR_INVALID_ARGS;
+	}
+
+	s = kmalloc(sizeof(*s), GFP_KERNEL);
+	if (s == NULL)
+		return VMCI_ERROR_NO_MEM;
+
+	retval = event_register_subscription(s, event, flags,
+					     callback, callback_data);
+	if (retval < VMCI_SUCCESS) {
+		kfree(s);
+		return retval;
+	}
+
+	*subscription_id = s->id;
+	return retval;
+}
+EXPORT_SYMBOL(vmci_event_subscribe);
+
+/*
+ * vmci_event_unsubscribe() - Unsubscribe to an event.
+ * @sub_id:     A subscription ID ad provided by vmci_event_subscribe()
+ *
+ * Unsubscribe to given event. Removes it from list and frees it.
+ * Will return callback_data if requested by caller.
+ */
+int vmci_event_unsubscribe(u32 sub_id)
+{
+	struct vmci_subscription *s;
+
+	/*
+	 * Return subscription. At this point we know noone else is accessing
+	 * the subscription so we can free it.
+	 */
+	s = event_unregister_subscription(sub_id);
+	if (s == NULL)
+		return VMCI_ERROR_NOT_FOUND;
+
+	kfree(s);
+
+	return VMCI_SUCCESS;
+}
+EXPORT_SYMBOL(vmci_event_unsubscribe);
diff --git a/drivers/misc/vmw_vmci/vmci_event.h b/drivers/misc/vmw_vmci/vmci_event.h
new file mode 100644
index 0000000..7df9b1c
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmci_event.h
@@ -0,0 +1,25 @@
+/*
+ * VMware VMCI Driver
+ *
+ * Copyright (C) 2012 VMware, Inc. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation version 2 and no later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
+ * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ * for more details.
+ */
+
+#ifndef __VMCI_EVENT_H__
+#define __VMCI_EVENT_H__
+
+#include <linux/vmw_vmci_api.h>
+
+int vmci_event_init(void);
+void vmci_event_exit(void);
+int vmci_event_dispatch(struct vmci_datagram *msg);
+
+#endif /*__VMCI_EVENT_H__ */


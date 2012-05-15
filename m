Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933172Ab2EOPJP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 11:09:15 -0400
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:55158 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933089Ab2EOPH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 11:07:28 -0400
From: "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>
To: linux-kernel@vger.kernel.org
Cc: acking@vmware.com, dtor@vmware.com, dsouders@vmware.com,
        cschamp@vmware.com, gregkh@linuxfoundation.org,
        akpm@linux-foundation.org, virtualization@lists.linux-foundation.org,
        "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>
Subject: [vmw_vmci RFC 05/11] Apply VMCI event code
Date: Tue, 15 May 2012 08:07:02 -0700
Message-Id: <1337094428-20453-6-git-send-email-astiegmann@vmware.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1337094428-20453-1-git-send-email-astiegmann@vmware.com>
References: <1337094428-20453-1-git-send-email-astiegmann@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Code that manages event handlers and handles callbacks when
specific events fire.

Signed-off-by: Andrew Stiegmann (stieg) <astiegmann@vmware.com>
---
 drivers/misc/vmw_vmci/vmci_event.c |  614 ++++++++++++++++++++++++++++++++++++
 drivers/misc/vmw_vmci/vmci_event.h |   29 ++
 2 files changed, 643 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/vmw_vmci/vmci_event.c
 create mode 100644 drivers/misc/vmw_vmci/vmci_event.h

diff --git a/drivers/misc/vmw_vmci/vmci_event.c b/drivers/misc/vmw_vmci/vmci_event.c
new file mode 100644
index 0000000..7335c9e
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmci_event.c
@@ -0,0 +1,614 @@
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
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
+ */
+
+#include <linux/module.h>
+#include <linux/list.h>
+#include <linux/sched.h>
+#include <linux/vmw_vmci_api.h>
+#include <linux/vmw_vmci_defs.h>
+
+#include "vmci_event.h"
+#include "vmci_driver.h"
+
+#define EVENT_MAGIC 0xEABE0000
+#define VMCI_EVENT_MAX_ATTEMPTS 10
+
+struct vmci_subscription {
+	uint32_t id;
+	int refCount;
+	bool runDelayed;
+	wait_queue_head_t destroyEvent;
+	uint32_t event;
+	VMCI_EventCB callback;
+	void *callbackData;
+	struct list_head subscriberListItem;
+};
+
+static struct list_head subscriberArray[VMCI_EVENT_MAX];
+static spinlock_t subscriberLock;
+
+struct delayed_event_info {
+	struct vmci_subscription *sub;
+	uint8_t eventPayload[sizeof(struct vmci_event_data_max)];
+};
+
+struct event_ref {
+	struct vmci_subscription *sub;
+	struct list_head listItem;
+};
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * vmci_event_init --
+ *
+ *      General init code.
+ *
+ * Results:
+ *      VMCI_SUCCESS on success, appropriate error code otherwise.
+ *
+ * Side effects:
+ *      None.
+ *
+ *----------------------------------------------------------------------
+ */
+
+int __init vmci_event_init(void)
+{
+	int i;
+
+	for (i = 0; i < VMCI_EVENT_MAX; i++)
+		INIT_LIST_HEAD(&subscriberArray[i]);
+
+	spin_lock_init(&subscriberLock);
+	return VMCI_SUCCESS;
+}
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * vmci_event_exit --
+ *
+ *      General exit code.
+ *
+ * Results:
+ *      None.
+ *
+ * Side effects:
+ *      None.
+ *
+ *----------------------------------------------------------------------
+ */
+
+void vmci_event_exit(void)
+{
+	int e;
+
+	/* We free all memory at exit. */
+	for (e = 0; e < VMCI_EVENT_MAX; e++) {
+		struct vmci_subscription *cur, *p2;
+		list_for_each_entry_safe(cur, p2, &subscriberArray[e],
+					 subscriberListItem) {
+
+			/*
+			 * We should never get here because all events should have been
+			 * unregistered before we try to unload the driver module.
+			 * Also, delayed callbacks could still be firing so this cleanup
+			 * would not be safe.
+			 * Still it is better to free the memory than not ... so we
+			 * leave this code in just in case....
+			 */
+			pr_warn("Unexpected free events occuring.");
+			kfree(cur);
+		}
+	}
+
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * event_get --
+ *
+ *      Gets a reference to the given VMCISubscription.
+ *
+ * Results:
+ *      None.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static void event_get(struct vmci_subscription *entry)	// IN
+{
+	ASSERT(entry);
+
+	entry->refCount++;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * event_release --
+ *
+ *      Releases the given VMCISubscription.
+ *
+ * Results:
+ *      None.
+ *
+ * Side effects:
+ *      Fires the destroy event if the reference count has gone to zero.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static void event_release(struct vmci_subscription *entry)	// IN
+{
+	ASSERT(entry);
+	ASSERT(entry->refCount > 0);
+
+	entry->refCount--;
+	if (entry->refCount == 0)
+		wake_up(&entry->destroyEvent);
+}
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ *  event_release_cb --
+ *
+ *     Callback to release the event entry reference. It is called by the
+ *     VMCI_WaitOnEvent function before it blocks.
+ *
+ *  Result:
+ *     None.
+ *
+ *  Side effects:
+ *     None.
+ *
+ *------------------------------------------------------------------------------
+ */
+
+static int event_release_cb(void *clientData)	// IN
+{
+	struct vmci_subscription *sub = (struct vmci_subscription *)clientData;
+
+	ASSERT(sub);
+
+	spin_lock_bh(&subscriberLock);
+	event_release(sub);
+	spin_unlock_bh(&subscriberLock);
+
+	return 0;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * event_find --
+ *
+ *      Find entry. Assumes lock is held.
+ *
+ * Results:
+ *      Entry if found, NULL if not.
+ *
+ * Side effects:
+ *      Increments the VMCISubscription refcount if an entry is found.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static struct vmci_subscription *event_find(uint32_t subID)	// IN
+{
+	int e;
+
+	for (e = 0; e < VMCI_EVENT_MAX; e++) {
+		struct vmci_subscription *cur;
+		list_for_each_entry(cur, &subscriberArray[e],
+				    subscriberListItem) {
+			if (cur->id == subID) {
+				event_get(cur);
+				return cur;
+			}
+		}
+	}
+	return NULL;
+}
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * event_delayed_dispatch_cb --
+ *
+ *      Calls the specified callback in a delayed context.
+ *
+ * Results:
+ *      None.
+ *
+ * Side effects:
+ *      None.
+ *
+ *----------------------------------------------------------------------
+ */
+
+static void event_delayed_dispatch_cb(void *data)	// IN
+{
+	struct delayed_event_info *eventInfo;
+	struct vmci_subscription *sub;
+	struct vmci_event_data *ed;
+
+	eventInfo = data;
+
+	ASSERT(eventInfo);
+	ASSERT(eventInfo->sub);
+
+	sub = eventInfo->sub;
+	ed = (struct vmci_event_data *)eventInfo->eventPayload;
+
+	sub->callback(sub->id, ed, sub->callbackData);
+
+	spin_lock_bh(&subscriberLock);
+	event_release(sub);
+	spin_unlock_bh(&subscriberLock);
+
+	kfree(eventInfo);
+}
+
+/*
+ *----------------------------------------------------------------------------
+ *
+ * event_deliver --
+ *
+ *      Actually delivers the events to the subscribers.
+ *
+ * Results:
+ *      None.
+ *
+ * Side effects:
+ *      The callback function for each subscriber is invoked.
+ *
+ *----------------------------------------------------------------------------
+ */
+
+static int event_deliver(struct vmci_event_msg *eventMsg)	// IN
+{
+	int err = VMCI_SUCCESS;
+	struct vmci_subscription *cur;
+	struct list_head noDelayList;
+	struct vmci_event_data *ed;
+	struct event_ref *eventRef, *p2;
+
+	ASSERT(eventMsg);
+
+	INIT_LIST_HEAD(&noDelayList);
+
+	spin_lock_bh(&subscriberLock);
+	list_for_each_entry(cur, &subscriberArray[eventMsg->eventData.event],
+			    subscriberListItem) {
+		ASSERT(cur && cur->event == eventMsg->eventData.event);
+
+		if (cur->runDelayed) {
+			struct delayed_event_info *eventInfo;
+			eventInfo = kzalloc(sizeof *eventInfo, GFP_ATOMIC);
+			if (!eventInfo) {
+				err = VMCI_ERROR_NO_MEM;
+				goto out;
+			}
+
+			event_get(cur);
+			memcpy(eventInfo->eventPayload,
+			       VMCI_DG_PAYLOAD(eventMsg),
+			       (size_t) eventMsg->hdr.payloadSize);
+			eventInfo->sub = cur;
+			err =
+				vmci_drv_schedule_delayed_work(event_delayed_dispatch_cb,
+							       eventInfo);
+			if (err != VMCI_SUCCESS) {
+				event_release(cur);
+				kfree(eventInfo);
+				goto out;
+			}
+
+		} else {
+			struct event_ref *eventRef;
+
+			/*
+			 * To avoid possible lock rank voilation when holding
+			 * subscriberLock, we construct a local list of
+			 * subscribers and release subscriberLock before
+			 * invokes the callbacks. This is similar to delayed
+			 * callbacks, but callbacks is invoked right away here.
+			 */
+			if ((eventRef =
+			     kzalloc(sizeof *eventRef,
+				     GFP_ATOMIC)) == NULL) {
+				err = VMCI_ERROR_NO_MEM;
+				goto out;
+			}
+
+			event_get(cur);
+			eventRef->sub = cur;
+			INIT_LIST_HEAD(&eventRef->listItem);
+			list_add(&eventRef->listItem, &noDelayList);
+		}
+	}
+
+out:
+	spin_unlock_bh(&subscriberLock);
+
+	list_for_each_entry_safe(eventRef, p2, &noDelayList, listItem) {
+		struct vmci_subscription *cur = eventRef->sub;
+		uint8_t eventPayload[sizeof(struct vmci_event_data_max)] =
+			{ 0 };
+
+		/* We set event data before each callback to ensure isolation. */
+		memcpy(eventPayload, VMCI_DG_PAYLOAD(eventMsg),
+		       (size_t) eventMsg->hdr.payloadSize);
+		ed = (struct vmci_event_data *)eventPayload;
+		cur->callback(cur->id, ed, cur->callbackData);
+
+		spin_lock_bh(&subscriberLock);
+		event_release(cur);
+		spin_unlock_bh(&subscriberLock);
+		kfree(eventRef);
+	}
+
+	return err;
+}
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * vmci_event_dispatch --
+ *
+ *      Dispatcher for the VMCI_EVENT_RECEIVE datagrams. Calls all
+ *      subscribers for given event.
+ *
+ * Results:
+ *      VMCI_SUCCESS on success, error code otherwise.
+ *
+ * Side effects:
+ *      None.
+ *
+ *----------------------------------------------------------------------
+ */
+
+int vmci_event_dispatch(struct vmci_dg *msg)	// IN
+{
+	struct vmci_event_msg *eventMsg = (struct vmci_event_msg *)msg;
+
+	ASSERT(msg &&
+	       msg->src.context == VMCI_HYPERVISOR_CONTEXT_ID &&
+	       msg->dst.resource == VMCI_EVENT_HANDLER);
+
+	if (msg->payloadSize < sizeof(uint32_t) ||
+	    msg->payloadSize > sizeof(struct vmci_event_data_max))
+		return VMCI_ERROR_INVALID_ARGS;
+
+	if (!VMCI_EVENT_VALID(eventMsg->eventData.event))
+		return VMCI_ERROR_EVENT_UNKNOWN;
+
+	event_deliver(eventMsg);
+	return VMCI_SUCCESS;
+}
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * event_register_subscription --
+ *
+ *      Initialize and add subscription to subscriber list.
+ *
+ * Results:
+ *      VMCI_SUCCESS on success, error code otherwise.
+ *
+ * Side effects:
+ *      None.
+ *
+ *----------------------------------------------------------------------
+ */
+
+static int event_register_subscription(struct vmci_subscription *sub,	// IN
+				       uint32_t event,	// IN
+				       uint32_t flags,	// IN
+				       VMCI_EventCB callback,	// IN
+				       void *callbackData)	// IN
+{
+	static uint32_t subscriptionID = 0;
+	uint32_t attempts = 0;
+	int result;
+	bool success;
+
+	ASSERT(sub);
+
+	if (!VMCI_EVENT_VALID(event) || callback == NULL) {
+		pr_devel("Failed to subscribe to event (type=%d) "
+			 "(callback=%p) (data=%p).", event,
+			 callback, callbackData);
+		return VMCI_ERROR_INVALID_ARGS;
+	}
+
+	sub->runDelayed = (flags & VMCI_FLAG_EVENT_DELAYED_CB) ? true : false;
+	sub->refCount = 1;
+	sub->event = event;
+	sub->callback = callback;
+	sub->callbackData = callbackData;
+	INIT_LIST_HEAD(&sub->subscriberListItem);
+
+	spin_lock_bh(&subscriberLock);
+
+	/* Creation of a new event is always allowed. */
+	for (success = false, attempts = 0;
+	     success == false && attempts < VMCI_EVENT_MAX_ATTEMPTS;
+	     attempts++) {
+		struct vmci_subscription *existingSub = NULL;
+
+		/*
+		 * We try to get an id a couple of time before claiming we are out of
+		 * resources.
+		 */
+		sub->id = ++subscriptionID;
+
+		/* Test for duplicate id. */
+		existingSub = event_find(sub->id);
+		if (existingSub == NULL)
+			/* We succeeded if we didn't find a duplicate. */
+			success = true;
+		else
+			event_release(existingSub);
+	}
+
+	if (success) {
+		init_waitqueue_head(&sub->destroyEvent);
+		list_add(&sub->subscriberListItem, &subscriberArray[event]);
+		result = VMCI_SUCCESS;
+	} else {
+		result = VMCI_ERROR_NO_RESOURCES;
+	}
+
+	spin_unlock_bh(&subscriberLock);
+	return result;
+}
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * event_unregister_subscription --
+ *
+ *      Remove subscription from subscriber list.
+ *
+ * Results:
+ *      VMCISubscription when found, NULL otherwise.
+ *
+ * Side effects:
+ *      None.
+ *
+ *----------------------------------------------------------------------
+ */
+
+static struct vmci_subscription *event_unregister_subscription(uint32_t subID)	// IN
+{
+	struct vmci_subscription *s;
+
+	spin_lock_bh(&subscriberLock);
+	s = event_find(subID);
+	if (s != NULL) {
+		event_release(s);
+		list_del(&s->subscriberListItem);
+	}
+	spin_unlock_bh(&subscriberLock);
+
+	if (s != NULL)
+		vmci_drv_wait_on_event_intr(&s->destroyEvent,
+					    event_release_cb, s);
+
+	return s;
+}
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * VMCIEvent_Subscribe --
+ *
+ *      Subscribe to given event. The callback specified can be fired
+ *      in different contexts depending on what flag is specified while
+ *      registering. If flags contains VMCI_FLAG_EVENT_NONE then the
+ *      callback is fired with the subscriber lock held (and BH context
+ *      on the guest). If flags contain VMCI_FLAG_EVENT_DELAYED_CB then
+ *      the callback is fired with no locks held in thread context.
+ *      This is useful because other VMCIEvent functions can be called,
+ *      but it also increases the chances that an event will be dropped.
+ *
+ * Results:
+ *      VMCI_SUCCESS on success, error code otherwise.
+ *
+ * Side effects:
+ *      None.
+ *
+ *----------------------------------------------------------------------
+ */
+
+int VMCIEvent_Subscribe(uint32_t event,	// IN
+			uint32_t flags,	// IN
+			VMCI_EventCB callback,	// IN
+			void *callbackData,	// IN
+			uint32_t * subscriptionID)	// OUT
+{
+	int retval;
+	struct vmci_subscription *s = NULL;
+
+	if (subscriptionID == NULL) {
+		pr_devel("Invalid subscription (NULL).");
+		return VMCI_ERROR_INVALID_ARGS;
+	}
+
+	s = kmalloc(sizeof *s, GFP_KERNEL);
+	if (s == NULL)
+		return VMCI_ERROR_NO_MEM;
+
+	retval = event_register_subscription(s, event, flags,
+					     callback, callbackData);
+	if (retval < VMCI_SUCCESS) {
+		kfree(s);
+		return retval;
+	}
+
+	*subscriptionID = s->id;
+	return retval;
+}
+
+EXPORT_SYMBOL(VMCIEvent_Subscribe);
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * VMCIEvent_Unsubscribe --
+ *
+ *      Unsubscribe to given event. Removes it from list and frees it.
+ *      Will return callbackData if requested by caller.
+ *
+ * Results:
+ *      VMCI_SUCCESS on success, error code otherwise.
+ *
+ * Side effects:
+ *      None.
+ *
+ *----------------------------------------------------------------------
+ */
+
+int VMCIEvent_Unsubscribe(uint32_t subID)	// IN
+{
+	struct vmci_subscription *s;
+
+	/*
+	 * Return subscription. At this point we know noone else is accessing
+	 * the subscription so we can free it.
+	 */
+	s = event_unregister_subscription(subID);
+	if (s == NULL)
+		return VMCI_ERROR_NOT_FOUND;
+
+	kfree(s);
+
+	return VMCI_SUCCESS;
+}
+
+EXPORT_SYMBOL(VMCIEvent_Unsubscribe);
diff --git a/drivers/misc/vmw_vmci/vmci_event.h b/drivers/misc/vmw_vmci/vmci_event.h
new file mode 100644
index 0000000..776b404
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmci_event.h
@@ -0,0 +1,29 @@
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
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
+ */
+
+#ifndef __VMCI_EVENT_H__
+#define __VMCI_EVENT_H__
+
+#include <linux/vmw_vmci_api.h>
+
+int vmci_event_init(void);
+void vmci_event_exit(void);
+int vmci_event_dispatch(struct vmci_dg *msg);
+
+#endif				//__VMCI_EVENT_H__
-- 
1.7.0.4


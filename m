Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761507Ab2BOBO6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 20:14:58 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:43567 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761448Ab2BOBOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 20:14:07 -0500
From: "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>
To: linux-kernel@vger.kernel.org
Cc: vm-crosstalk@vmware.com, dtor@vmware.com, cschamp@vmware.com,
        "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>
Subject: [PATCH 05/14] Add vmciEvent.*
Date: Tue, 14 Feb 2012 17:05:46 -0800
Message-Id: <1329267955-32367-6-git-send-email-astiegmann@vmware.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1329267955-32367-1-git-send-email-astiegmann@vmware.com>
References: <1329267955-32367-1-git-send-email-astiegmann@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/misc/vmw_vmci/vmciEvent.c |  648 +++++++++++++++++++++++++++++++++++++
 drivers/misc/vmw_vmci/vmciEvent.h |   32 ++
 2 files changed, 680 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/vmw_vmci/vmciEvent.c
 create mode 100644 drivers/misc/vmw_vmci/vmciEvent.h

diff --git a/drivers/misc/vmw_vmci/vmciEvent.c b/drivers/misc/vmw_vmci/vmciEvent.c
new file mode 100644
index 0000000..50b1c23
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmciEvent.c
@@ -0,0 +1,648 @@
+/*
+ *
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
+
+#include "vmci_defs.h"
+#include "vmci_infrastructure.h"
+#include "vmciEvent.h"
+#include "vmciKernelAPI.h"
+#include "vmciDriver.h"
+
+#define LGPFX "VMCIEvent: "
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
+ * VMCIEvent_Init --
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
+int VMCIEvent_Init(void)
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
+ * VMCIEvent_Exit --
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
+void VMCIEvent_Exit(void)
+{
+	uint32_t e;
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
+			pr_warning("Unexpected free events occuring in %s",
+				   __func__);
+			kfree(cur);
+	  }
+	}
+
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIEvent_Sync --
+ *
+ *      Use this as a synchronization point when setting globals, for example,
+ *      during device shutdown.
+ *
+ * Results:
+ *      true.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+void VMCIEvent_Sync(void)
+{
+	spin_lock_bh(&subscriberLock);
+	spin_unlock_bh(&subscriberLock);
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIEventGet --
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
+static void VMCIEventGet(struct vmci_subscription *entry)	// IN
+{
+	ASSERT(entry);
+
+	entry->refCount++;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIEventRelease --
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
+static void VMCIEventRelease(struct vmci_subscription *entry)	// IN
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
+ *  EventReleaseCB --
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
+static int EventReleaseCB(void *clientData)	// IN
+{
+	struct vmci_subscription *sub = (struct vmci_subscription *)clientData;
+
+	ASSERT(sub);
+
+	spin_lock_bh(&subscriberLock);
+	VMCIEventRelease(sub);
+	spin_unlock_bh(&subscriberLock);
+
+	return 0;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIEventFind --
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
+static struct vmci_subscription *VMCIEventFind(uint32_t subID)	// IN
+{
+	uint32_t e;
+
+	for (e = 0; e < VMCI_EVENT_MAX; e++) {
+		struct vmci_subscription *cur;
+		list_for_each_entry(cur, &subscriberArray[e],
+				    subscriberListItem) {
+			if (cur->id == subID) {
+				VMCIEventGet(cur);
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
+ * VMCIEventDelayedDispatchCB --
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
+static void VMCIEventDelayedDispatchCB(void *data)	// IN
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
+	VMCIEventRelease(sub);
+	spin_unlock_bh(&subscriberLock);
+
+	kfree(eventInfo);
+}
+
+/*
+ *----------------------------------------------------------------------------
+ *
+ * VMCIEventDeliver --
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
+static int VMCIEventDeliver(struct vmci_event_msg *eventMsg)	// IN
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
+			eventInfo = kcalloc(sizeof *eventInfo, 1, GFP_ATOMIC);
+			if (!eventInfo) {
+				err = VMCI_ERROR_NO_MEM;
+				goto out;
+			}
+
+			VMCIEventGet(cur);
+
+			memset(eventInfo, 0, sizeof *eventInfo);
+			memcpy(eventInfo->eventPayload,
+			       VMCI_DG_PAYLOAD(eventMsg),
+			       (size_t) eventMsg->hdr.payloadSize);
+			eventInfo->sub = cur;
+			err = VMCI_ScheduleDelayedWork(VMCIEventDelayedDispatchCB,
+						       eventInfo);
+			if (err != VMCI_SUCCESS) {
+				VMCIEventRelease(cur);
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
+			     kcalloc(sizeof *eventRef, 1, GFP_ATOMIC)) == NULL) {
+				err = VMCI_ERROR_NO_MEM;
+				goto out;
+			}
+
+			VMCIEventGet(cur);
+			eventRef->sub = cur;
+			INIT_LIST_HEAD(&eventRef->listItem);
+			list_add(&eventRef->listItem, &noDelayList);
+		}
+	}
+
+ out:
+	spin_unlock_bh(&subscriberLock);
+
+	list_for_each_entry_safe(eventRef, p2, &noDelayList, listItem) {
+		struct vmci_subscription *cur = eventRef->sub;
+		uint8_t
+			eventPayload[sizeof(struct vmci_event_data_max)];
+
+		/* We set event data before each callback to ensure isolation. */
+		memset(eventPayload, 0, sizeof eventPayload);
+		memcpy(eventPayload, VMCI_DG_PAYLOAD(eventMsg),
+		       (size_t) eventMsg->hdr.payloadSize);
+		ed = (struct vmci_event_data *)eventPayload;
+		cur->callback(cur->id, ed, cur->callbackData);
+
+		spin_lock_bh(&subscriberLock);
+		VMCIEventRelease(cur);
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
+ * VMCIEvent_Dispatch --
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
+int VMCIEvent_Dispatch(struct vmci_datagram *msg)	// IN
+{
+	struct vmci_event_msg *eventMsg = (struct vmci_event_msg *)msg;
+
+	ASSERT(msg &&
+	       msg->src.context == VMCI_HYPERVISOR_CONTEXT_ID &&
+	       msg->dst.resource == VMCI_EVENT_HANDLER);
+
+	if (msg->payloadSize < sizeof(uint32_t) ||
+	    msg->payloadSize > sizeof(struct vmci_event_data_max)) {
+		return VMCI_ERROR_INVALID_ARGS;
+	}
+
+	if (!VMCI_EVENT_VALID(eventMsg->eventData.event)) {
+		return VMCI_ERROR_EVENT_UNKNOWN;
+	}
+
+	VMCIEventDeliver(eventMsg);
+
+	return VMCI_SUCCESS;
+}
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * VMCIEventRegisterSubscription --
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
+static int VMCIEventRegisterSubscription(struct vmci_subscription *sub,	// IN
+					 uint32_t event,	// IN
+					 uint32_t flags,	// IN
+					 VMCI_EventCB callback,	// IN
+					 void *callbackData)	// IN
+{
+	static uint32_t subscriptionID = 0;
+	uint32_t attempts = 0;
+	int result;
+	bool success;
+
+	ASSERT(sub);
+
+	if (!VMCI_EVENT_VALID(event) || callback == NULL) {
+		VMCI_DEBUG_LOG(4,
+			       (LGPFX
+				"Failed to subscribe to event (type=%d) "
+				"(callback=%p) (data=%p).\n", event,
+				callback, callbackData));
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
+		existingSub = VMCIEventFind(sub->id);
+		if (existingSub == NULL) {
+			/* We succeeded if we didn't find a duplicate. */
+			success = true;
+		} else {
+			VMCIEventRelease(existingSub);
+		}
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
+ * VMCIEventUnregisterSubscription --
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
+static struct vmci_subscription *VMCIEventUnregisterSubscription(uint32_t subID)	// IN
+{
+	struct vmci_subscription *s;
+
+	spin_lock_bh(&subscriberLock);
+	s = VMCIEventFind(subID);
+	if (s != NULL) {
+		VMCIEventRelease(s);
+		list_del(&s->subscriberListItem);
+	}
+	spin_unlock_bh(&subscriberLock);
+
+	if (s != NULL) {
+		VMCI_WaitOnEvent(&s->destroyEvent, EventReleaseCB, s);
+	}
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
+		VMCI_DEBUG_LOG(4, (LGPFX "Invalid subscription (NULL).\n"));
+		return VMCI_ERROR_INVALID_ARGS;
+	}
+
+	s = kmalloc(sizeof *s, GFP_KERNEL);
+	if (s == NULL)
+		return VMCI_ERROR_NO_MEM;
+
+	retval = VMCIEventRegisterSubscription(s, event, flags,
+					       callback, callbackData);
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
+	s = VMCIEventUnregisterSubscription(subID);
+	if (s == NULL)
+		return VMCI_ERROR_NOT_FOUND;
+
+	kfree(s);
+
+	return VMCI_SUCCESS;
+}
+
+EXPORT_SYMBOL(VMCIEvent_Unsubscribe);
diff --git a/drivers/misc/vmw_vmci/vmciEvent.h b/drivers/misc/vmw_vmci/vmciEvent.h
new file mode 100644
index 0000000..575bff0
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmciEvent.h
@@ -0,0 +1,32 @@
+/*
+ *
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
+#include "vmci_defs.h"
+#include "vmci_call_defs.h"
+
+int VMCIEvent_Init(void);
+void VMCIEvent_Exit(void);
+void VMCIEvent_Sync(void);
+int VMCIEvent_Dispatch(struct vmci_datagram *msg);
+
+#endif				//__VMCI_EVENT_H__
-- 
1.7.0.4


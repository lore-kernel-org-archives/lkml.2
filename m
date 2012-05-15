Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933144Ab2EOPHn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 11:07:43 -0400
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:37294 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933109Ab2EOPHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 11:07:33 -0400
From: "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>
To: linux-kernel@vger.kernel.org
Cc: acking@vmware.com, dtor@vmware.com, dsouders@vmware.com,
        cschamp@vmware.com, gregkh@linuxfoundation.org,
        akpm@linux-foundation.org, virtualization@lists.linux-foundation.org,
        "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>
Subject: [vmw_vmci RFC 10/11] Apply vmci routing code
Date: Tue, 15 May 2012 08:07:07 -0700
Message-Id: <1337094428-20453-11-git-send-email-astiegmann@vmware.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1337094428-20453-1-git-send-email-astiegmann@vmware.com>
References: <1337094428-20453-1-git-send-email-astiegmann@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code is responsible for routing between various hosts/guests as
well as routing in nested scenarios.

Signed-off-by: Andrew Stiegmann (stieg) <astiegmann@vmware.com>
---
 drivers/misc/vmw_vmci/vmci_route.c |  234 ++++++++++++++++++++++++++++++++++++
 drivers/misc/vmw_vmci/vmci_route.h |   34 +++++
 2 files changed, 268 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/vmw_vmci/vmci_route.c
 create mode 100644 drivers/misc/vmw_vmci/vmci_route.h

diff --git a/drivers/misc/vmw_vmci/vmci_route.c b/drivers/misc/vmw_vmci/vmci_route.c
new file mode 100644
index 0000000..4c9183c
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmci_route.c
@@ -0,0 +1,234 @@
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
+#include <linux/vmw_vmci_api.h>
+#include <linux/vmw_vmci_defs.h>
+
+#include "vmci_common_int.h"
+#include "vmci_context.h"
+#include "vmci_driver.h"
+#include "vmci_route.h"
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ *  vmci_route --
+ *
+ *     Make a routing decision for the given source and destination handles.
+ *     This will try to determine the route using the handles and the available
+ *     devices.
+ *
+ *  Result:
+ *     A VMCIRoute value.
+ *
+ *  Side effects:
+ *     Sets the source context if it is invalid.
+ *
+ *------------------------------------------------------------------------------
+ */
+
+int vmci_route(struct vmci_handle *src,	// IN/OUT
+	       const struct vmci_handle *dst,	// IN
+	       bool fromGuest,	// IN
+	       enum vmci_route *route)	// OUT
+{
+	bool hasHostDevice = vmci_host_code_active();
+	bool hasGuestDevice = vmci_guest_code_active();
+
+	ASSERT(src);
+	ASSERT(dst);
+	ASSERT(route);
+
+	*route = VMCI_ROUTE_NONE;
+
+	/*
+	 * "fromGuest" is only ever set to true by IOCTL_VMCI_DATAGRAM_SEND (or by
+	 * the vmkernel equivalent), which comes from the VMX, so we know it is
+	 * coming from a guest.
+	 *
+	 * To avoid inconsistencies, test these once.  We will test them again
+	 * when we do the actual send to ensure that we do not touch a non-existent
+	 * device.
+	 */
+
+	/* Must have a valid destination context. */
+	if (VMCI_INVALID_ID == dst->context)
+		return VMCI_ERROR_INVALID_ARGS;
+
+	/* Anywhere to hypervisor. */
+	if (VMCI_HYPERVISOR_CONTEXT_ID == dst->context) {
+
+		/*
+		 * If this message already came from a guest then we cannot send it
+		 * to the hypervisor.  It must come from a local client.
+		 */
+		if (fromGuest)
+			return VMCI_ERROR_DST_UNREACHABLE;
+
+		/* We must be acting as a guest in order to send to the hypervisor. */
+		if (!hasGuestDevice)
+			return VMCI_ERROR_DEVICE_NOT_FOUND;
+
+		/* And we cannot send if the source is the host context. */
+		if (VMCI_HOST_CONTEXT_ID == src->context)
+			return VMCI_ERROR_INVALID_ARGS;
+
+		/*
+		 * If the client passed the ANON source handle then respect it (both
+		 * context and resource are invalid).  However, if they passed only
+		 * an invalid context, then they probably mean ANY, in which case we
+		 * should set the real context here before passing it down.
+		 */
+		if (VMCI_INVALID_ID == src->context && VMCI_INVALID_ID != src->resource)
+			src->context = VMCI_GetContextID();
+
+		/* Send from local client down to the hypervisor. */
+		*route = VMCI_ROUTE_AS_GUEST;
+		return VMCI_SUCCESS;
+	}
+
+	/* Anywhere to local client on host. */
+	if (VMCI_HOST_CONTEXT_ID == dst->context) {
+		/*
+		 * If it is not from a guest but we are acting as a guest, then we need
+		 * to send it down to the host.  Note that if we are also acting as a
+		 * host then this will prevent us from sending from local client to
+		 * local client, but we accept that restriction as a way to remove
+		 * any ambiguity from the host context.
+		 */
+		if (src->context == VMCI_HYPERVISOR_CONTEXT_ID) {
+			/*
+			 * If the hypervisor is the source, this is host local
+			 * communication. The hypervisor may send vmci event
+			 * datagrams to the host itself, but it will never send
+			 * datagrams to an "outer host" through the guest device.
+			 */
+
+			if (hasHostDevice) {
+				*route = VMCI_ROUTE_AS_HOST;
+				return VMCI_SUCCESS;
+			} else {
+				return VMCI_ERROR_DEVICE_NOT_FOUND;
+			}
+		}
+
+		if (!fromGuest && hasGuestDevice) {
+			/* If no source context then use the current. */
+			if (VMCI_INVALID_ID == src->context)
+				src->context = VMCI_GetContextID();
+
+			/* Send it from local client down to the host. */
+			*route = VMCI_ROUTE_AS_GUEST;
+			return VMCI_SUCCESS;
+		}
+
+		/*
+		 * Otherwise we already received it from a guest and it is destined
+		 * for a local client on this host, or it is from another local client
+		 * on this host.  We must be acting as a host to service it.
+		 */
+		if (!hasHostDevice)
+			return VMCI_ERROR_DEVICE_NOT_FOUND;
+
+		if (VMCI_INVALID_ID == src->context) {
+			/*
+			 * If it came from a guest then it must have a valid context.
+			 * Otherwise we can use the host context.
+			 */
+
+			if (fromGuest)
+				return VMCI_ERROR_INVALID_ARGS;
+
+			src->context = VMCI_HOST_CONTEXT_ID;
+		}
+
+		/* Route to local client. */
+		*route = VMCI_ROUTE_AS_HOST;
+		return VMCI_SUCCESS;
+	}
+
+	/* If we are acting as a host then this might be destined for a guest. */
+	if (hasHostDevice) {
+		/* It will have a context if it is meant for a guest. */
+		if (vmci_ctx_exists(dst->context)) {
+			if (VMCI_INVALID_ID == src->context) {
+				/*
+				 * If it came from a guest then it must have a valid context.
+				 * Otherwise we can use the host context.
+				 */
+
+				if (fromGuest)
+					return VMCI_ERROR_INVALID_ARGS;
+
+				src->context = VMCI_HOST_CONTEXT_ID;
+			} else if (VMCI_CONTEXT_IS_VM(src->context) &&
+				   src->context != dst->context) {
+				/*
+				 * VM to VM communication is not allowed. Since we catch
+				 * all communication destined for the host above, this
+				 * must be destined for a VM since there is a valid
+				 * context.
+				 */
+
+				ASSERT(VMCI_CONTEXT_IS_VM(dst->context));
+
+				return VMCI_ERROR_DST_UNREACHABLE;
+			}
+
+			/* Pass it up to the guest. */
+			*route = VMCI_ROUTE_AS_HOST;
+			return VMCI_SUCCESS;
+		} else if (!hasGuestDevice) {
+			/*
+			 * The host is attempting to reach a CID without an active context, and
+			 * we can't send it down, since we have no guest device.
+			 */
+
+			return VMCI_ERROR_DST_UNREACHABLE;
+		}
+	}
+
+	/*
+	 * We must be a guest trying to send to another guest, which means
+	 * we need to send it down to the host. We do not filter out VM to
+	 * VM communication here, since we want to be able to use the guest
+	 * driver on older versions that do support VM to VM communication.
+	 */
+	if (!hasGuestDevice) {
+		/*
+		 * Ending up here means we have neither guest nor host device. That
+		 * shouldn't happen, since any VMCI client in the kernel should have done
+		 * a successful VMCI_DeviceGet.
+		 */
+
+		ASSERT(false);
+		return VMCI_ERROR_DEVICE_NOT_FOUND;
+	}
+
+	/* If no source context then use the current context. */
+	if (VMCI_INVALID_ID == src->context)
+		src->context = VMCI_GetContextID();
+
+	/*
+	 * Send it from local client down to the host, which will route it to
+	 * the other guest for us.
+	 */
+	*route = VMCI_ROUTE_AS_GUEST;
+	return VMCI_SUCCESS;
+}
diff --git a/drivers/misc/vmw_vmci/vmci_route.h b/drivers/misc/vmw_vmci/vmci_route.h
new file mode 100644
index 0000000..c53f86e
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmci_route.h
@@ -0,0 +1,34 @@
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
+#ifndef _VMCI_ROUTE_H_
+#define _VMCI_ROUTE_H_
+
+#include <linux/vmw_vmci_defs.h>
+
+enum vmci_route {
+	VMCI_ROUTE_NONE,
+	VMCI_ROUTE_AS_HOST,
+	VMCI_ROUTE_AS_GUEST,
+};
+
+int vmci_route(struct vmci_handle *src, const struct vmci_handle *dst,
+	       bool fromGuest, enum vmci_route *route);
+
+#endif				// _VMCI_ROUTE_H_
-- 
1.7.0.4


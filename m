Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155Ab1CUNls (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 09:41:48 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:15896 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab1CUNln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 09:41:43 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmxtMZ80VwmRRL9Bl7Rx0=
X-RZG-CLASS-ID: mo00
Date: Mon, 21 Mar 2011 14:41:37 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Hank Janssen <hjanssen@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] hv: use sync_bitops when interacting with the hypervisor
Message-ID: <20110321134137.GA29305@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Locking is required when tweaking bits located in a shared page, use the
sync_ version of bitops. Without this change vmbus_on_event() will miss
events and as a result, vmbus_isr() will not schedule the receive tasklet.

Signed-off-by: Olaf Hering <olaf@aepfle.de>

---
 drivers/staging/hv/channel.c       |    8 ++++----
 drivers/staging/hv/connection.c    |    4 ++--
 drivers/staging/hv/vmbus_drv.c     |    2 +-
 drivers/staging/hv/vmbus_private.h |    1 +
 4 files changed, 8 insertions(+), 7 deletions(-)

Index: linux-2.6/drivers/staging/hv/channel.c
===================================================================
--- linux-2.6.orig/drivers/staging/hv/channel.c
+++ linux-2.6/drivers/staging/hv/channel.c
@@ -81,14 +81,14 @@ static void vmbus_setevent(struct vmbus_
 
 	if (channel->offermsg.monitor_allocated) {
 		/* Each u32 represents 32 channels */
-		set_bit(channel->offermsg.child_relid & 31,
+		sync_set_bit(channel->offermsg.child_relid & 31,
 			(unsigned long *) vmbus_connection.send_int_page +
 			(channel->offermsg.child_relid >> 5));
 
 		monitorpage = vmbus_connection.monitor_pages;
 		monitorpage++; /* Get the child to parent monitor page */
 
-		set_bit(channel->monitor_bit,
+		sync_set_bit(channel->monitor_bit,
 			(unsigned long *)&monitorpage->trigger_group
 					[channel->monitor_grp].pending);
 
@@ -104,7 +104,7 @@ static void VmbusChannelClearEvent(struc
 
 	if (Channel->offermsg.monitor_allocated) {
 		/* Each u32 represents 32 channels */
-		clear_bit(Channel->offermsg.child_relid & 31,
+		sync_clear_bit(Channel->offermsg.child_relid & 31,
 			  (unsigned long *)vmbus_connection.send_int_page +
 			  (Channel->offermsg.child_relid >> 5));
 
@@ -112,7 +112,7 @@ static void VmbusChannelClearEvent(struc
 			vmbus_connection.monitor_pages;
 		monitorPage++; /* Get the child to parent monitor page */
 
-		clear_bit(Channel->monitor_bit,
+		sync_clear_bit(Channel->monitor_bit,
 			  (unsigned long *)&monitorPage->trigger_group
 					[Channel->monitor_grp].Pending);
 	}
Index: linux-2.6/drivers/staging/hv/connection.c
===================================================================
--- linux-2.6.orig/drivers/staging/hv/connection.c
+++ linux-2.6/drivers/staging/hv/connection.c
@@ -296,7 +296,7 @@ void vmbus_on_event(unsigned long data)
 		for (dword = 0; dword < maxdword; dword++) {
 			if (recv_int_page[dword]) {
 				for (bit = 0; bit < 32; bit++) {
-					if (test_and_clear_bit(bit,
+					if (sync_test_and_clear_bit(bit,
 						(unsigned long *)
 						&recv_int_page[dword])) {
 						relid = (dword << 5) + bit;
@@ -338,7 +338,7 @@ int vmbus_post_msg(void *buffer, size_t
 int vmbus_set_event(u32 child_relid)
 {
 	/* Each u32 represents 32 channels */
-	set_bit(child_relid & 31,
+	sync_set_bit(child_relid & 31,
 		(unsigned long *)vmbus_connection.send_int_page +
 		(child_relid >> 5));
 
Index: linux-2.6/drivers/staging/hv/vmbus_drv.c
===================================================================
--- linux-2.6.orig/drivers/staging/hv/vmbus_drv.c
+++ linux-2.6/drivers/staging/hv/vmbus_drv.c
@@ -254,7 +254,7 @@ static int vmbus_on_isr(void)
 	event = (union hv_synic_event_flags *)page_addr + VMBUS_MESSAGE_SINT;
 
 	/* Since we are a child, we only need to check bit 0 */
-	if (test_and_clear_bit(0, (unsigned long *) &event->flags32[0])) {
+	if (sync_test_and_clear_bit(0, (unsigned long *) &event->flags32[0])) {
 		DPRINT_DBG(VMBUS, "received event %d", event->flags32[0]);
 		ret |= 0x2;
 	}
Index: linux-2.6/drivers/staging/hv/vmbus_private.h
===================================================================
--- linux-2.6.orig/drivers/staging/hv/vmbus_private.h
+++ linux-2.6/drivers/staging/hv/vmbus_private.h
@@ -31,6 +31,7 @@
 #include "channel_mgmt.h"
 #include "ring_buffer.h"
 #include <linux/list.h>
+#include <asm/sync_bitops.h>
 
 
 /*

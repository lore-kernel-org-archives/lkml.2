Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758631Ab1DZVNm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:13:42 -0400
Received: from mga14.intel.com ([143.182.124.37]:19033 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758483Ab1DZVNe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:13:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="425950825"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: olaf@aepfle.de, haiyangz@microsoft.com, hjanssen@microsoft.com,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [7/106] staging: hv: use sync_bitops when interacting with the hypervisor
Message-Id: <20110426211245.218663E1887@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:12:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Olaf Hering <olaf@aepfle.de>

commit 22356585712d1ff08fbfed152edd8b386873b238 upstream.

Locking is required when tweaking bits located in a shared page, use the
sync_ version of bitops. Without this change vmbus_on_event() will miss
events and as a result, vmbus_isr() will not schedule the receive tasklet.

[Backported to 2.6.32 stable kernel by Haiyang Zhang <haiyangz@microsoft.com>]

Signed-off-by: Olaf Hering <olaf@aepfle.de>
Acked-by: Haiyang Zhang <haiyangz@microsoft.com>
Acked-by: Hank Janssen <hjanssen@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/staging/hv/Channel.c      |    8 ++++----
 drivers/staging/hv/Connection.c   |    6 ++++--
 drivers/staging/hv/Vmbus.c        |    2 +-
 drivers/staging/hv/VmbusPrivate.h |    1 +
 4 files changed, 10 insertions(+), 7 deletions(-)

Index: linux-2.6.35.y/drivers/staging/hv/channel.c
===================================================================
--- linux-2.6.35.y.orig/drivers/staging/hv/channel.c
+++ linux-2.6.35.y/drivers/staging/hv/channel.c
@@ -78,14 +78,14 @@ static void VmbusChannelSetEvent(struct 
 
 	if (Channel->OfferMsg.MonitorAllocated) {
 		/* Each u32 represents 32 channels */
-		set_bit(Channel->OfferMsg.ChildRelId & 31,
+		sync_set_bit(Channel->OfferMsg.ChildRelId & 31,
 			(unsigned long *) gVmbusConnection.SendInterruptPage +
 			(Channel->OfferMsg.ChildRelId >> 5));
 
 		monitorPage = gVmbusConnection.MonitorPages;
 		monitorPage++; /* Get the child to parent monitor page */
 
-		set_bit(Channel->MonitorBit,
+		sync_set_bit(Channel->MonitorBit,
 			(unsigned long *)&monitorPage->TriggerGroup
 					[Channel->MonitorGroup].Pending);
 
@@ -105,7 +105,7 @@ static void VmbusChannelClearEvent(struc
 
 	if (Channel->OfferMsg.MonitorAllocated) {
 		/* Each u32 represents 32 channels */
-		clear_bit(Channel->OfferMsg.ChildRelId & 31,
+		sync_clear_bit(Channel->OfferMsg.ChildRelId & 31,
 			  (unsigned long *)gVmbusConnection.SendInterruptPage +
 			  (Channel->OfferMsg.ChildRelId >> 5));
 
@@ -113,7 +113,7 @@ static void VmbusChannelClearEvent(struc
 			(struct hv_monitor_page *)gVmbusConnection.MonitorPages;
 		monitorPage++; /* Get the child to parent monitor page */
 
-		clear_bit(Channel->MonitorBit,
+		sync_clear_bit(Channel->MonitorBit,
 			  (unsigned long *)&monitorPage->TriggerGroup
 					[Channel->MonitorGroup].Pending);
 	}
Index: linux-2.6.35.y/drivers/staging/hv/connection.c
===================================================================
--- linux-2.6.35.y.orig/drivers/staging/hv/connection.c
+++ linux-2.6.35.y/drivers/staging/hv/connection.c
@@ -292,7 +292,9 @@ void VmbusOnEvents(void)
 		for (dword = 0; dword < maxdword; dword++) {
 			if (recvInterruptPage[dword]) {
 				for (bit = 0; bit < 32; bit++) {
-					if (test_and_clear_bit(bit, (unsigned long *)&recvInterruptPage[dword])) {
+					if (sync_test_and_clear_bit(bit,
+						(unsigned long *)
+						&recvInterruptPage[dword])) {
 						relid = (dword << 5) + bit;
 						DPRINT_DBG(VMBUS, "event detected for relid - %d", relid);
 
@@ -337,7 +339,7 @@ int VmbusSetEvent(u32 childRelId)
 	DPRINT_ENTER(VMBUS);
 
 	/* Each u32 represents 32 channels */
-	set_bit(childRelId & 31,
+	sync_set_bit(childRelId & 31,
 		(unsigned long *)gVmbusConnection.SendInterruptPage +
 		(childRelId >> 5));
 
Index: linux-2.6.35.y/drivers/staging/hv/vmbus.c
===================================================================
--- linux-2.6.35.y.orig/drivers/staging/hv/vmbus.c
+++ linux-2.6.35.y/drivers/staging/hv/vmbus.c
@@ -254,7 +254,7 @@ static int VmbusOnISR(struct hv_driver *
 	event = (union hv_synic_event_flags *)page_addr + VMBUS_MESSAGE_SINT;
 
 	/* Since we are a child, we only need to check bit 0 */
-	if (test_and_clear_bit(0, (unsigned long *) &event->Flags32[0])) {
+	if (sync_test_and_clear_bit(0, (unsigned long *) &event->Flags32[0])) {
 		DPRINT_DBG(VMBUS, "received event %d", event->Flags32[0]);
 		ret |= 0x2;
 	}
Index: linux-2.6.35.y/drivers/staging/hv/vmbus_private.h
===================================================================
--- linux-2.6.35.y.orig/drivers/staging/hv/vmbus_private.h
+++ linux-2.6.35.y/drivers/staging/hv/vmbus_private.h
@@ -32,6 +32,7 @@
 #include "channel_interface.h"
 #include "ring_buffer.h"
 #include <linux/list.h>
+#include <asm/sync_bitops.h>
 
 
 /*

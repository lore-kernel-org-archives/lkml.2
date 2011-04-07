Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756480Ab1DGWiu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 18:38:50 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:45390
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756174Ab1DGWit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 18:38:49 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, kys@microsoft.com,
        v-abkane@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Cc: Olaf Hering <olaf@aepfle.de>, stable <stable@kernel.org>
Subject: [PATCH] staging: hv: use sync_bitops when interacting with the hypervisor
Date: Thu,  7 Apr 2011 15:49:58 -0700
Message-Id: <1302216598-686-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Olaf Hering <olaf@aepfle.de>

Locking is required when tweaking bits located in a shared page, use the
sync_ version of bitops. Without this change vmbus_on_event() will miss
events and as a result, vmbus_isr() will not schedule the receive tasklet.

Backported to 2.6.32 stable kernel by Haiyang Zhang <haiyangz@microsoft.com>

Signed-off-by: Olaf Hering <olaf@aepfle.de>
Cc: stable <stable@kernel.org>
Acked-by: Haiyang Zhang <haiyangz@microsoft.com>
Acked-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/Channel.c      |    8 ++++----
 drivers/staging/hv/Connection.c   |    6 ++++--
 drivers/staging/hv/Vmbus.c        |    2 +-
 drivers/staging/hv/VmbusPrivate.h |    1 +
 4 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/hv/Channel.c b/drivers/staging/hv/Channel.c
index 746370e..366dc95 100644
--- a/drivers/staging/hv/Channel.c
+++ b/drivers/staging/hv/Channel.c
@@ -75,14 +75,14 @@ static void VmbusChannelSetEvent(struct vmbus_channel *Channel)
 
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
 
@@ -102,7 +102,7 @@ static void VmbusChannelClearEvent(struct vmbus_channel *channel)
 
 	if (Channel->OfferMsg.MonitorAllocated) {
 		/* Each u32 represents 32 channels */
-		clear_bit(Channel->OfferMsg.ChildRelId & 31,
+		sync_clear_bit(Channel->OfferMsg.ChildRelId & 31,
 			  (unsigned long *)gVmbusConnection.SendInterruptPage +
 			  (Channel->OfferMsg.ChildRelId >> 5));
 
@@ -110,7 +110,7 @@ static void VmbusChannelClearEvent(struct vmbus_channel *channel)
 			(struct hv_monitor_page *)gVmbusConnection.MonitorPages;
 		monitorPage++; /* Get the child to parent monitor page */
 
-		clear_bit(Channel->MonitorBit,
+		sync_clear_bit(Channel->MonitorBit,
 			  (unsigned long *)&monitorPage->TriggerGroup
 					[Channel->MonitorGroup].Pending);
 	}
diff --git a/drivers/staging/hv/Connection.c b/drivers/staging/hv/Connection.c
index 43c2e68..c8d073a 100644
--- a/drivers/staging/hv/Connection.c
+++ b/drivers/staging/hv/Connection.c
@@ -284,7 +284,9 @@ void VmbusOnEvents(void)
 		for (dword = 0; dword < maxdword; dword++) {
 			if (recvInterruptPage[dword]) {
 				for (bit = 0; bit < 32; bit++) {
-					if (test_and_clear_bit(bit, (unsigned long *)&recvInterruptPage[dword])) {
+					if (sync_test_and_clear_bit(bit,
+						(unsigned long *)
+						&recvInterruptPage[dword])) {
 						relid = (dword << 5) + bit;
 						DPRINT_DBG(VMBUS, "event detected for relid - %d", relid);
 
@@ -329,7 +331,7 @@ int VmbusSetEvent(u32 childRelId)
 	DPRINT_ENTER(VMBUS);
 
 	/* Each u32 represents 32 channels */
-	set_bit(childRelId & 31,
+	sync_set_bit(childRelId & 31,
 		(unsigned long *)gVmbusConnection.SendInterruptPage +
 		(childRelId >> 5));
 
diff --git a/drivers/staging/hv/Vmbus.c b/drivers/staging/hv/Vmbus.c
index 35a023e..2a4ba03 100644
--- a/drivers/staging/hv/Vmbus.c
+++ b/drivers/staging/hv/Vmbus.c
@@ -254,7 +254,7 @@ static int VmbusOnISR(struct hv_driver *drv)
 	event = (union hv_synic_event_flags *)page_addr + VMBUS_MESSAGE_SINT;
 
 	/* Since we are a child, we only need to check bit 0 */
-	if (test_and_clear_bit(0, (unsigned long *) &event->Flags32[0])) {
+	if (sync_test_and_clear_bit(0, (unsigned long *) &event->Flags32[0])) {
 		DPRINT_DBG(VMBUS, "received event %d", event->Flags32[0]);
 		ret |= 0x2;
 	}
diff --git a/drivers/staging/hv/VmbusPrivate.h b/drivers/staging/hv/VmbusPrivate.h
index 05ad2c9..5a37cce 100644
--- a/drivers/staging/hv/VmbusPrivate.h
+++ b/drivers/staging/hv/VmbusPrivate.h
@@ -32,6 +32,7 @@
 #include "ChannelInterface.h"
 #include "RingBuffer.h"
 #include <linux/list.h>
+#include <asm/sync_bitops.h>
 
 
 /*
-- 
1.7.4.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758231Ab2CMARz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:17:55 -0400
Received: from mail.windriver.com ([147.11.1.11]:46692 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758007Ab2CMARr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:17:47 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Olaf Hering <olaf@aepfle.de>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 020/196] staging: hv: use sync_bitops when interacting with the hypervisor
Date: Mon, 12 Mar 2012 20:12:28 -0400
Message-Id: <1331597724-31358-21-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Olaf Hering <olaf@aepfle.de>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 22356585712d1ff08fbfed152edd8b386873b238 upstream.

Locking is required when tweaking bits located in a shared page, use the
sync_ version of bitops. Without this change vmbus_on_event() will miss
events and as a result, vmbus_isr() will not schedule the receive tasklet.

Signed-off-by: Olaf Hering <olaf@aepfle.de>
Acked-by: Haiyang Zhang <haiyangz@microsoft.com>
Acked-by: Hank Janssen <hjanssen@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/staging/hv/Channel.c      |    8 ++++----
 drivers/staging/hv/Connection.c   |    4 ++--
 drivers/staging/hv/Vmbus.c        |    2 +-
 drivers/staging/hv/VmbusPrivate.h |    1 +
 4 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/hv/Channel.c b/drivers/staging/hv/Channel.c
index e69e9ee..d0b435e 100644
--- a/drivers/staging/hv/Channel.c
+++ b/drivers/staging/hv/Channel.c
@@ -76,14 +76,14 @@ static void VmbusChannelSetEvent(struct vmbus_channel *Channel)
 
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
 
@@ -103,7 +103,7 @@ static void VmbusChannelClearEvent(struct vmbus_channel *channel)
 
 	if (Channel->OfferMsg.MonitorAllocated) {
 		/* Each u32 represents 32 channels */
-		clear_bit(Channel->OfferMsg.ChildRelId & 31,
+		sync_clear_bit(Channel->OfferMsg.ChildRelId & 31,
 			  (unsigned long *)gVmbusConnection.SendInterruptPage +
 			  (Channel->OfferMsg.ChildRelId >> 5));
 
@@ -111,7 +111,7 @@ static void VmbusChannelClearEvent(struct vmbus_channel *channel)
 			(struct hv_monitor_page *)gVmbusConnection.MonitorPages;
 		monitorPage++; /* Get the child to parent monitor page */
 
-		clear_bit(Channel->MonitorBit,
+		sync_clear_bit(Channel->MonitorBit,
 			  (unsigned long *)&monitorPage->TriggerGroup
 					[Channel->MonitorGroup].Pending);
 	}
diff --git a/drivers/staging/hv/Connection.c b/drivers/staging/hv/Connection.c
index e0ea9cf..e39d422 100644
--- a/drivers/staging/hv/Connection.c
+++ b/drivers/staging/hv/Connection.c
@@ -285,7 +285,7 @@ void VmbusOnEvents(void)
 		for (dword = 0; dword < maxdword; dword++) {
 			if (recvInterruptPage[dword]) {
 				for (bit = 0; bit < 32; bit++) {
-					if (test_and_clear_bit(bit, (unsigned long *)&recvInterruptPage[dword])) {
+					if (sync_test_and_clear_bit(bit, (unsigned long *)&recvInterruptPage[dword])) {
 						relid = (dword << 5) + bit;
 						DPRINT_DBG(VMBUS, "event detected for relid - %d", relid);
 
@@ -330,7 +330,7 @@ int VmbusSetEvent(u32 childRelId)
 	DPRINT_ENTER(VMBUS);
 
 	/* Each u32 represents 32 channels */
-	set_bit(childRelId & 31,
+	sync_set_bit(childRelId & 31,
 		(unsigned long *)gVmbusConnection.SendInterruptPage +
 		(childRelId >> 5));
 
diff --git a/drivers/staging/hv/Vmbus.c b/drivers/staging/hv/Vmbus.c
index 2f84bf7..0680868 100644
--- a/drivers/staging/hv/Vmbus.c
+++ b/drivers/staging/hv/Vmbus.c
@@ -255,7 +255,7 @@ static int VmbusOnISR(struct hv_driver *drv)
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
1.7.9.3


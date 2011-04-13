Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932901Ab1DMQ1j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:27:39 -0400
Received: from kroah.org ([198.145.64.141]:52772 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932786Ab1DMQMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:12:47 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Apr 13 09:10:44 2011
Message-Id: <20110413161044.160569247@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 13 Apr 2011 09:09:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Olaf Hering <olaf@aepfle.de>, Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [16/71] staging: hv: use sync_bitops when interacting with the hypervisor
In-Reply-To: <20110413161106.GA20405@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

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
---
 drivers/staging/hv/Channel.c      |    8 ++++----
 drivers/staging/hv/Connection.c   |    6 ++++--
 drivers/staging/hv/Vmbus.c        |    2 +-
 drivers/staging/hv/VmbusPrivate.h |    1 +
 4 files changed, 10 insertions(+), 7 deletions(-)

--- a/drivers/staging/hv/Channel.c
+++ b/drivers/staging/hv/Channel.c
@@ -75,14 +75,14 @@ static void VmbusChannelSetEvent(struct
 
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
 
@@ -102,7 +102,7 @@ static void VmbusChannelClearEvent(struc
 
 	if (Channel->OfferMsg.MonitorAllocated) {
 		/* Each u32 represents 32 channels */
-		clear_bit(Channel->OfferMsg.ChildRelId & 31,
+		sync_clear_bit(Channel->OfferMsg.ChildRelId & 31,
 			  (unsigned long *)gVmbusConnection.SendInterruptPage +
 			  (Channel->OfferMsg.ChildRelId >> 5));
 
@@ -110,7 +110,7 @@ static void VmbusChannelClearEvent(struc
 			(struct hv_monitor_page *)gVmbusConnection.MonitorPages;
 		monitorPage++; /* Get the child to parent monitor page */
 
-		clear_bit(Channel->MonitorBit,
+		sync_clear_bit(Channel->MonitorBit,
 			  (unsigned long *)&monitorPage->TriggerGroup
 					[Channel->MonitorGroup].Pending);
 	}
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
 
--- a/drivers/staging/hv/Vmbus.c
+++ b/drivers/staging/hv/Vmbus.c
@@ -254,7 +254,7 @@ static int VmbusOnISR(struct hv_driver *
 	event = (union hv_synic_event_flags *)page_addr + VMBUS_MESSAGE_SINT;
 
 	/* Since we are a child, we only need to check bit 0 */
-	if (test_and_clear_bit(0, (unsigned long *) &event->Flags32[0])) {
+	if (sync_test_and_clear_bit(0, (unsigned long *) &event->Flags32[0])) {
 		DPRINT_DBG(VMBUS, "received event %d", event->Flags32[0]);
 		ret |= 0x2;
 	}
--- a/drivers/staging/hv/VmbusPrivate.h
+++ b/drivers/staging/hv/VmbusPrivate.h
@@ -32,6 +32,7 @@
 #include "ChannelInterface.h"
 #include "RingBuffer.h"
 #include <linux/list.h>
+#include <asm/sync_bitops.h>
 
 
 /*



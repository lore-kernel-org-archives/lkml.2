Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab2LAO24 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 09:28:56 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:55490
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472Ab2LAO2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 09:28:40 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 24/28] Drivers: hv: Add a check to deal with spurious interrupts
Date: Sat,  1 Dec 2012 06:46:55 -0800
Message-Id: <1354373219-31374-24-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1354373219-31374-1-git-send-email-kys@microsoft.com>
References: <1354373160-31332-1-git-send-email-kys@microsoft.com>
 <1354373219-31374-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We establish the handler before we have fully initialized the VMBUS state.
Deal with spurious interrupts.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/hv/vmbus_drv.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index e066d41..797142c 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -454,6 +454,12 @@ static irqreturn_t vmbus_isr(int irq, void *dev_id)
 	union hv_synic_event_flags *event;
 	bool handled = false;
 
+	page_addr = hv_context.synic_event_page[cpu];
+	if (page_addr == NULL)
+		return IRQ_NONE;
+
+	event = (union hv_synic_event_flags *)page_addr +
+					 VMBUS_MESSAGE_SINT;
 	/*
 	 * Check for events before checking for messages. This is the order
 	 * in which events and messages are checked in Windows guests on
@@ -463,10 +469,6 @@ static irqreturn_t vmbus_isr(int irq, void *dev_id)
 	if ((vmbus_proto_version == VERSION_WS2008) ||
 		(vmbus_proto_version == VERSION_WIN7)) {
 
-		page_addr = hv_context.synic_event_page[cpu];
-		event = (union hv_synic_event_flags *)page_addr +
-					 VMBUS_MESSAGE_SINT;
-
 		/* Since we are a child, we only need to check bit 0 */
 		if (sync_test_and_clear_bit(0,
 			(unsigned long *) &event->flags32[0])) {
-- 
1.7.4.1


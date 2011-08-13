Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954Ab1HMD5J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 23:57:09 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:44639 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab1HMD5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 23:57:07 -0400
MIME-Version: 1.0
In-Reply-To: <1312824486.1539.42.camel@vkoul-udesk3>
References: <CAJd=RBDqKoqozsOg9GYicLMh4QELu-yESjNZJk8e--=QPzKVoQ@mail.gmail.com>
	<1312824486.1539.42.camel@vkoul-udesk3>
Date: Sat, 13 Aug 2011 11:57:05 +0800
Message-ID: <CAJd=RBB8RBzS6LUWH3TS-7v3X7b695Bb92wyHqEYYBJQ19xAog@mail.gmail.com>
Subject: [RFC patch resend] DMA engine/Langwell: process pending descriptors
From: Hillf Danton <dhillf@gmail.com>
To: "Koul, Vinod" <vinod.koul@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Descriptors could be added onto the queue list, though pending descriptors are
checked in intel_mid_dma_issue_pending(), they are not processed by scanning
the queue list. Now it is added.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/drivers/dma/intel_mid_dma.c	Sat Aug 13 11:44:46 2011
+++ intel_mid_dma.c	Sat Aug 13 11:52:35 2011
@@ -338,8 +338,12 @@ static void midc_scan_descriptors(struct
 		if (desc->status == DMA_IN_PROGRESS)
 			midc_descriptor_complete(midc, desc);
 	}
-	return;
+	list_for_each_entry_safe(desc, _desc, &midc->queue, desc_node) {
+		if (desc->status == DMA_IN_PROGRESS)
+			midc_descriptor_complete(midc, desc);
 	}
+}
+
 /**
  * midc_lli_fill_sg -		Helper function to convert
  *				SG list to Linked List Items.

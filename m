Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438Ab1G0NYy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 09:24:54 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39150 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754382Ab1G0NYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 09:24:52 -0400
MIME-Version: 1.0
Date: Wed, 27 Jul 2011 21:24:51 +0800
Message-ID: <CAJd=RBDqKoqozsOg9GYicLMh4QELu-yESjNZJk8e--=QPzKVoQ@mail.gmail.com>
Subject: [RFC patch] DMA engine/Langwell: process pending descriptors
From: Hillf Danton <dhillf@gmail.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Descriptors could be added onto the queue list, though pending descriptors are
checked in intel_mid_dma_issue_pending(), they are not processed by scanning
the queue list.
In this work scanning the queue list is added in midc_scan_descriptors().

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---
 drivers/dma/intel_mid_dma.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/intel_mid_dma.c b/drivers/dma/intel_mid_dma.c
index f653517..a176fb9 100644
--- a/drivers/dma/intel_mid_dma.c
+++ b/drivers/dma/intel_mid_dma.c
@@ -338,8 +338,11 @@ static void midc_scan_descriptors(struct
middma_device *mid,
 		if (desc->status == DMA_IN_PROGRESS)
 			midc_descriptor_complete(midc, desc);
 	}
-	return;
+	list_for_each_entry_safe(desc, _desc, &midc->queue, desc_node) {
+		if (desc->status == DMA_IN_PROGRESS)
+			midc_descriptor_complete(midc, desc);
 	}
+}
 /**
  * midc_lli_fill_sg -		Helper function to convert
  *				SG list to Linked List Items.

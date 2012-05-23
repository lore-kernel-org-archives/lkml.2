Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907Ab2EWGhU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 02:37:20 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:34470 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965145Ab2EWGez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 02:34:55 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 04/11] PCI: Make sure assign same align with large size resource at first
Date: Tue, 22 May 2012 23:34:30 -0700
Message-Id: <1337754877-19759-5-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1337754877-19759-1-git-send-email-yinghai@kernel.org>
References: <1337754877-19759-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When sorting them, put the one with large size before small size.


Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/setup-bus.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 64d478f..0568f29 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -128,7 +128,7 @@ static void pdev_sort_resources(struct pci_dev *dev, struct list_head *head)
 	for (i = 0; i < PCI_NUM_RESOURCES; i++) {
 		struct resource *r;
 		struct pci_dev_resource *dev_res, *tmp;
-		resource_size_t r_align;
+		resource_size_t r_align, r_size;
 		struct list_head *n;
 
 		r = &dev->resource[i];
@@ -145,6 +145,7 @@ static void pdev_sort_resources(struct pci_dev *dev, struct list_head *head)
 				 i, r);
 			continue;
 		}
+		r_size = resource_size(r);
 
 		tmp = kzalloc(sizeof(*tmp), GFP_KERNEL);
 		if (!tmp)
@@ -161,7 +162,9 @@ static void pdev_sort_resources(struct pci_dev *dev, struct list_head *head)
 			align = pci_resource_alignment(dev_res->dev,
 							 dev_res->res);
 
-			if (r_align > align) {
+			if (r_align > align ||
+			    (r_align == align &&
+			     r_size > resource_size(dev_res->res))) {
 				n = &dev_res->list;
 				break;
 			}
-- 
1.7.7


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044Ab2IOAuM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 20:50:12 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:40947 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055Ab2IOAsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 20:48:55 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, x86@kernel.org
Subject: [PATCH] PCI, x86: clear initial value for root info resources
Date: Fri, 14 Sep 2012 17:48:42 -0700
Message-Id: <1347670122-25824-3-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1347670122-25824-1-git-send-email-yinghai@kernel.org>
References: <1347670122-25824-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found one system one root bus hot remove get panic.
Panic happens when try to release hostbridge resource.

It turns out that resource get reject during put into resource tree
because of conflicts.
Also that resource parent pointer have random value.

That invalid value cause it pass through check __release_pci_root_info
and panic in release_resource.

Try to use kzalloc instead.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: x86@kernel.org

---
 arch/x86/pci/acpi.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux-2.6/arch/x86/pci/acpi.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/acpi.c
+++ linux-2.6/arch/x86/pci/acpi.c
@@ -305,7 +305,6 @@ setup_resource(struct acpi_resource *acp
 	res->flags = flags;
 	res->start = start;
 	res->end = end;
-	res->child = NULL;
 
 	if (!pci_use_crs) {
 		dev_printk(KERN_DEBUG, &info->bridge->dev,
@@ -434,7 +433,7 @@ probe_pci_root_info(struct pci_root_info
 
 	size = sizeof(*info->res) * info->res_num;
 	info->res_num = 0;
-	info->res = kmalloc(size, GFP_KERNEL);
+	info->res = kzalloc(size, GFP_KERNEL);
 	if (!info->res)
 		return;
 

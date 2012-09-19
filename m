Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940Ab2ISSzW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 14:55:22 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:47776 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587Ab2ISSzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 14:55:12 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, x86 <x86@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 02/40] PCI, x86: clear initial value for root info resources
Date: Wed, 19 Sep 2012 11:54:16 -0700
Message-Id: <1348080894-23412-3-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1348080894-23412-1-git-send-email-yinghai@kernel.org>
References: <CAE9FiQWFcVNKMnV1qaHchwCXfZuMpyxf_f7GQy3FZid9YuLD3w@mail.gmail.com>
 <1348080894-23412-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
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
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index 505acdd..192397c 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -305,7 +305,6 @@ setup_resource(struct acpi_resource *acpi_res, void *data)
 	res->flags = flags;
 	res->start = start;
 	res->end = end;
-	res->child = NULL;
 
 	if (!pci_use_crs) {
 		dev_printk(KERN_DEBUG, &info->bridge->dev,
@@ -434,7 +433,7 @@ probe_pci_root_info(struct pci_root_info *info, struct acpi_device *device,
 
 	size = sizeof(*info->res) * info->res_num;
 	info->res_num = 0;
-	info->res = kmalloc(size, GFP_KERNEL);
+	info->res = kzalloc(size, GFP_KERNEL);
 	if (!info->res)
 		return;
 
-- 
1.7.7


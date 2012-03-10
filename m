Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932726Ab2CJHFm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 02:05:42 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:39380 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932620Ab2CJHC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 02:02:58 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org
Subject: [PATCH v2 27/37] PCI, pci_root_hp: Use acpi_hp_work
Date: Fri,  9 Mar 2012 23:00:27 -0800
Message-Id: <1331362837-10740-28-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1331362837-10740-1-git-send-email-yinghai@kernel.org>
References: <1331362837-10740-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090205.4F5AFC9F.00AC,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove local copy: acpi_root_hp_work

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org
---
 drivers/acpi/pci_root_hp.c |   34 +++-------------------------------
 1 files changed, 3 insertions(+), 31 deletions(-)

diff --git a/drivers/acpi/pci_root_hp.c b/drivers/acpi/pci_root_hp.c
index f5585f5..b453181 100644
--- a/drivers/acpi/pci_root_hp.c
+++ b/drivers/acpi/pci_root_hp.c
@@ -79,34 +79,6 @@ static void remove_acpi_root_bridge(struct acpi_root_bridge *bridge)
 	kfree(bridge);
 }
 
-struct acpi_root_hp_work {
-	struct work_struct work;
-	acpi_handle handle;
-	u32 type;
-	void *context;
-};
-
-static void alloc_acpi_root_hp_work(acpi_handle handle, u32 type,
-					void *context,
-					void (*func)(struct work_struct *work))
-{
-	struct acpi_root_hp_work *hp_work;
-	int ret;
-
-	hp_work = kmalloc(sizeof(*hp_work), GFP_KERNEL);
-	if (!hp_work)
-		return;
-
-	hp_work->handle = handle;
-	hp_work->type = type;
-	hp_work->context = context;
-
-	INIT_WORK(&hp_work->work, func);
-	ret = queue_work(kacpi_hotplug_wq, &hp_work->work);
-	if (!ret)
-		kfree(hp_work);
-}
-
 /* Program resources in newly inserted bridge */
 static void acpi_root_configure_bridge(acpi_handle handle)
 {
@@ -203,11 +175,11 @@ static void _handle_hotplug_event_root(struct work_struct *work)
 	char objname[64];
 	struct acpi_buffer buffer = { .length = sizeof(objname),
 				      .pointer = objname };
-	struct acpi_root_hp_work *hp_work;
+	struct acpi_hp_work *hp_work;
 	acpi_handle handle;
 	u32 type;
 
-	hp_work = container_of(work, struct acpi_root_hp_work, work);
+	hp_work = container_of(work, struct acpi_hp_work, work);
 	handle = hp_work->handle;
 	type = hp_work->type;
 
@@ -255,7 +227,7 @@ static void _handle_hotplug_event_root(struct work_struct *work)
 static void handle_hotplug_event_root(acpi_handle handle, u32 type,
 					void *context)
 {
-	alloc_acpi_root_hp_work(handle, type, context,
+	alloc_acpi_hp_work(handle, type, context,
 				_handle_hotplug_event_root);
 }
 
-- 
1.7.7


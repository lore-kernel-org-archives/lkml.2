Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966Ab2LMPbV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 10:31:21 -0500
Received: from mga02.intel.com ([134.134.136.20]:15922 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755811Ab2LMPbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 10:31:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,274,1355126400"; 
   d="scan'208";a="233501395"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Miles J Penner <miles.j.penner@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Tushar N Dave <tushar.n.dave@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Amos Kong <kongjianjun@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] PCI Hotplug: convert acpiphp_hp_work to use delayed work
Date: Thu, 13 Dec 2012 17:31:47 +0200
Message-Id: <1355412708-20046-3-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1355412708-20046-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1355412708-20046-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

Some broken ACPI PCI Hotplug implementations notify OS about hotplug
before devices ready to be enumerated.

Let's convert acpiphp_hp_work to delayed work. It will allow to delay
enumeration on broken hardware to workaround the issue.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 drivers/pci/hotplug/acpiphp_glue.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index 3d6d4fd..1a2b3ca 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -1191,7 +1191,7 @@ check_sub_bridges(acpi_handle handle, u32 lvl, void *context, void **rv)
 }
 
 struct acpiphp_hp_work {
-	struct work_struct work;
+	struct delayed_work work;
 	acpi_handle handle;
 	u32 type;
 	void *context;
@@ -1199,7 +1199,8 @@ struct acpiphp_hp_work {
 
 static void alloc_acpiphp_hp_work(acpi_handle handle, u32 type,
 				  void *context,
-				  void (*func)(struct work_struct *work))
+				  void (*func)(struct work_struct *work),
+				  unsigned long delay)
 {
 	struct acpiphp_hp_work *hp_work;
 	int ret;
@@ -1212,8 +1213,8 @@ static void alloc_acpiphp_hp_work(acpi_handle handle, u32 type,
 	hp_work->type = type;
 	hp_work->context = context;
 
-	INIT_WORK(&hp_work->work, func);
-	ret = queue_work(kacpi_hotplug_wq, &hp_work->work);
+	INIT_DELAYED_WORK(&hp_work->work, func);
+	ret = queue_delayed_work(kacpi_hotplug_wq, &hp_work->work, delay);
 	if (!ret)
 		kfree(hp_work);
 }
@@ -1230,7 +1231,8 @@ static void _handle_hotplug_event_bridge(struct work_struct *work)
 	acpi_handle handle;
 	u32 type;
 
-	hp_work = container_of(work, struct acpiphp_hp_work, work);
+	hp_work = container_of(to_delayed_work(work),
+			struct acpiphp_hp_work, work);
 	handle = hp_work->handle;
 	type = hp_work->type;
 
@@ -1334,7 +1336,7 @@ static void handle_hotplug_event_bridge(acpi_handle handle, u32 type,
 	 * don't deadlock on hotplug actions.
 	 */
 	alloc_acpiphp_hp_work(handle, type, context,
-			      _handle_hotplug_event_bridge);
+			      _handle_hotplug_event_bridge, 0);
 }
 
 static void _handle_hotplug_event_func(struct work_struct *work)
@@ -1348,7 +1350,8 @@ static void _handle_hotplug_event_func(struct work_struct *work)
 	u32 type;
 	void *context;
 
-	hp_work = container_of(work, struct acpiphp_hp_work, work);
+	hp_work = container_of(to_delayed_work(work),
+			struct acpiphp_hp_work, work);
 	handle = hp_work->handle;
 	type = hp_work->type;
 	context = hp_work->context;
@@ -1410,7 +1413,7 @@ static void handle_hotplug_event_func(acpi_handle handle, u32 type,
 	 * don't deadlock on hotplug actions.
 	 */
 	alloc_acpiphp_hp_work(handle, type, context,
-			      _handle_hotplug_event_func);
+			      _handle_hotplug_event_func, 0);
 }
 
 static acpi_status
-- 
1.7.10.4


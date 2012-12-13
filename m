Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088Ab2LMPbY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 10:31:24 -0500
Received: from mga02.intel.com ([134.134.136.20]:15922 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755811Ab2LMPbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 10:31:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,274,1355126400"; 
   d="scan'208";a="233501415"
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
Subject: [PATCH 3/3] PCI Hotplug: workaround for Thunderbolt on Intel DZ77RE-75K motherboard
Date: Thu, 13 Dec 2012 17:31:48 +0200
Message-Id: <1355412708-20046-4-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1355412708-20046-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1355412708-20046-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

BIOS on Intel DZ77RE-75K motherboard notifies OS about Thunderbolt
hotplug before devices behind Thunderbolt are ready to be enumerated.

Let's delay enumeration by 2 seconds.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 drivers/pci/hotplug/acpiphp_glue.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index 1a2b3ca..165987a 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -49,6 +49,7 @@
 #include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/acpi.h>
+#include <linux/dmi.h>
 
 #include "../pci.h"
 #include "acpiphp.h"
@@ -1327,6 +1328,19 @@ out:
 static void handle_hotplug_event_bridge(acpi_handle handle, u32 type,
 					void *context)
 {
+	unsigned long delay = 0;
+	const char *board_name;
+
+	board_name = dmi_get_system_info(DMI_BOARD_NAME);
+	/*
+	 * BIOS on Intel DZ77RE-75K motherboard notifies OS about Thunderbolt
+	 * hotplug before devices behind Thunderbolt are ready to be
+	 * enumerated.
+	 * Let's delay enumeration by 2 seconds.
+	 */
+	if (board_name && !strcmp(board_name, "DZ77RE-75K"))
+		delay = 2 * HZ;
+
 	/*
 	 * Currently the code adds all hotplug events to the kacpid_wq
 	 * queue when it should add hotplug events to the kacpi_hotplug_wq.
@@ -1336,7 +1350,7 @@ static void handle_hotplug_event_bridge(acpi_handle handle, u32 type,
 	 * don't deadlock on hotplug actions.
 	 */
 	alloc_acpiphp_hp_work(handle, type, context,
-			      _handle_hotplug_event_bridge, 0);
+			      _handle_hotplug_event_bridge, delay);
 }
 
 static void _handle_hotplug_event_func(struct work_struct *work)
-- 
1.7.10.4


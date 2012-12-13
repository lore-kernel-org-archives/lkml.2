Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809Ab2LMPbS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 10:31:18 -0500
Received: from mga02.intel.com ([134.134.136.20]:15922 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753597Ab2LMPbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 10:31:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,274,1355126400"; 
   d="scan'208";a="233501350"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Miles J Penner <miles.j.penner@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Tushar N Dave <tushar.n.dave@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Mauro Carvalho Chehab <mchehab@redhat.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] PCI Hotplug: workaround for Thunderbolt on Acer Aspire S5
Date: Thu, 13 Dec 2012 17:31:46 +0200
Message-Id: <1355412708-20046-2-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1355412708-20046-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1355412708-20046-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

Correct ACPI PCI hotplug imeplementation should have _RMV method in a
PCI slot (device under pci bridge). In Acer Aspire S5 case we have it
deeper in hierarchy:

Device (RP05)
{
   // ...
   Device (HRUP)
   {
       // ...
       Device (HRDN)
       {
           // ...
           Device (EPUP)
           {
               // ...
               Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
               {
                   Return (One)
               }
           }
       }
   }
}

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 drivers/pci/hotplug/acpi_pcihp.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/pci/hotplug/acpi_pcihp.c b/drivers/pci/hotplug/acpi_pcihp.c
index 2a47e82..d92ebfb 100644
--- a/drivers/pci/hotplug/acpi_pcihp.c
+++ b/drivers/pci/hotplug/acpi_pcihp.c
@@ -422,6 +422,19 @@ static int pcihp_is_ejectable(acpi_handle handle)
 	status = acpi_evaluate_integer(handle, "_RMV", NULL, &removable);
 	if (ACPI_SUCCESS(status) && removable)
 		return 1;
+
+	/*
+	 * Workaround for Thunderbolt implementation on Acer Aspire S5.
+	 *
+	 * Correct ACPI PCI hotplug imeplementation has _RMV method in a PCI
+	 * slot (device under pci bridge). In Acer Aspire S5 case we have it
+	 * deeper in hierarchy.
+	 */
+	status = acpi_evaluate_integer(handle, "HRDN.EPUP._RMV", NULL,
+			&removable);
+	if (ACPI_SUCCESS(status) && removable)
+		return 1;
+
 	return 0;
 }
 
-- 
1.7.10.4


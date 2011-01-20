Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab1ATU6D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 15:58:03 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35023 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754276Ab1ATU6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 15:58:01 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Subject: Re: [PATCH 0/11] ACPI: Fixes and cleanups related to iomaps management
Date: Thu, 20 Jan 2011 21:57:16 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc1+; KDE/4.4.4; x86_64; ; )
Cc: Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
References: <201101201226.41021.rjw@sisk.pl> <AANLkTikVRHfu2KhH4yi2VerkRXBdCODedCDORmpEzRXO@mail.gmail.com>
In-Reply-To: <AANLkTikVRHfu2KhH4yi2VerkRXBdCODedCDORmpEzRXO@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101202157.16813.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 20, 2011, Jeff Chua wrote:
> On Thu, Jan 20, 2011 at 7:26 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > [10/11] - Make the NVS code use existing iomaps if possible.
> 
> Seems ok.
> 
> > [11/11] - (cleanup) Remove an unnecessary field from struct nvs_page.
> 
> This seems to have an issue. Notebook tries to suspend ... then resume
> immediately.

That's unexpected.  Please apply the debug patch below in addition to the
whole series and send a dmesg output containing a (failing) suspend attempt
(with the patch applied).

Thanks,
Rafael


---
 drivers/acpi/nvs.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/acpi/nvs.c
===================================================================
--- linux-2.6.orig/drivers/acpi/nvs.c
+++ linux-2.6/drivers/acpi/nvs.c
@@ -87,9 +87,15 @@ void suspend_nvs_free(void)
 			entry->data = NULL;
 			if (entry->kaddr) {
 				if (entry->unmap) {
+					pr_info("%s: Unmapping %p\n", __func__,
+						entry->kaddr);
+
 					iounmap(entry->kaddr);
 					entry->unmap = false;
 				} else {
+					pr_info("%s: Dropping %p\n", __func__,
+						entry->kaddr);
+
 					acpi_os_unmap_memory(entry->kaddr,
 							     entry->size);
 				}
@@ -139,9 +145,17 @@ int suspend_nvs_save(void)
 			if (!entry->kaddr) {
 				suspend_nvs_free();
 				return -EIO;
+			} else {
+				pr_info("%s: Mapped %p\n", __func__,
+					entry->kaddr);
 			}
 			entry->unmap = true;
+		} else {
+			pr_info("%s: Got address %p\n", __func__, entry->kaddr);
 		}
+		pr_info("%s: Saving %p <- %p\n", __func__,
+			entry->data, entry->kaddr);
+
 		memcpy(entry->data, entry->kaddr, entry->size);
 
 		page_addr += PAGE_SIZE;
@@ -164,6 +178,10 @@ void suspend_nvs_restore(void)
 	printk(KERN_INFO "PM: Restoring platform NVS memory\n");
 
 	list_for_each_entry(entry, &nvs_list, node)
-		if (entry->data)
+		if (entry->data) {
+			pr_info("%s: Restoring %p -> %p\n", __func__,
+				entry->data, entry->kaddr);
+
 			memcpy(entry->kaddr, entry->data, entry->size);
+		}
 }

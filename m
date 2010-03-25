Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985Ab0CYP2f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 11:28:35 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:25760 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754914Ab0CYP2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 11:28:30 -0400
Subject: [PATCH 2/2] x86/PCI: truncate _CRS windows with _LEN > _MAX - _MIN + 1
To: Jesse Barnes <jbarnes@virtuousgeek.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Yanko Kaneti <yaneti@declera.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Renninger <trenn@suse.de>, maciej.rutecki@gmail.com
Date: Thu, 25 Mar 2010 09:28:30 -0600
Message-ID: <20100325152829.10117.91511.stgit@bob.kio>
In-Reply-To: <20100325152750.10117.81615.stgit@bob.kio>
References: <20100325152750.10117.81615.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Yanko's GA-MA78GM-S2H (BIOS F11) reports the following resource in a PCI
host bridge _CRS:

    [07] 32-Bit DWORD Address Space Resource
         Min Relocatability : MinFixed
         Max Relocatability : MaxFixed
            Address Minimum : CFF00000  (_MIN)
            Address Maximum : FEBFFFFF  (_MAX)
             Address Length : 3EE10000  (_LEN)

This is invalid per spec (ACPI 4.0, 6.4.3.5) because it's a fixed size,
fixed location descriptor, but _LEN != _MAX - _MIN + 1.

Based on https://bugzilla.kernel.org/show_bug.cgi?id=15480#c15, I think
Windows handles this by truncating the window so it fits between _MIN and
_MAX.  I also verified this by modifying the SeaBIOS DSDT and booting
Windows 2008 R2 with qemu.

This patch makes Linux truncate the window, too, which fixes:
    http://bugzilla.kernel.org/show_bug.cgi?id=15480

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Tested-by: Yanko Kaneti <yaneti@declera.com>
---

 arch/x86/pci/acpi.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)


diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index 75ac3f8..e311602 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -123,7 +123,7 @@ setup_resource(struct acpi_resource *acpi_res, void *data)
 	acpi_status status;
 	unsigned long flags;
 	struct resource *root, *conflict;
-	u64 start, end;
+	u64 start, end, max_len;
 
 	status = resource_to_addr(acpi_res, &addr);
 	if (!ACPI_SUCCESS(status))
@@ -140,6 +140,17 @@ setup_resource(struct acpi_resource *acpi_res, void *data)
 	} else
 		return AE_OK;
 
+	max_len = addr.maximum - addr.minimum + 1;
+	if (addr.address_length > max_len) {
+		dev_printk(KERN_DEBUG, &info->bridge->dev,
+			   "host bridge window length %#llx doesn't fit in "
+			   "%#llx-%#llx, trimming\n",
+			   (unsigned long long) addr.address_length,
+			   (unsigned long long) addr.minimum,
+			   (unsigned long long) addr.maximum);
+		addr.address_length = max_len;
+	}
+
 	start = addr.minimum + addr.translation_offset;
 	end = start + addr.address_length - 1;
 


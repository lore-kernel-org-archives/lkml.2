Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052Ab2KHC44 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 21:56:56 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:57886 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754998Ab2KHC4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 21:56:54 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Hurley <peter@hurleysoftware.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH 4/5] x86: acpi: Print warning for malformed host bridge resources
Date: Wed,  7 Nov 2012 21:55:55 -0500
Message-Id: <1352343356-4006-5-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.7.12.3
In-Reply-To: <1352343356-4006-1-git-send-email-peter@hurleysoftware.com>
References: <1352343356-4006-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An incorrectly specified host bridge window may prevent
other devices from claiming assigned resources. For example,
this flawed _CRS resource descriptor from a Dell T5400:
     DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, NonCacheable, ReadWrite,
     	 0x00000000,         // Granularity
         0xF0000000,         // Range Minimum
         0xFE000000,         // Range Maximum
         0x00000000,         // Translation Offset
         0x0E000000,         // Length
         ,, , AddressRangeMemory, TypeStatic)
prevents the adjacent device from claiming [mem 0xfe0000000-0xfe01ffff]

Sanity check that the resource at least conforms to a valid
PCI BAR; if not, emit a diagnostic warning.

Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: x86@kernel.org
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 arch/x86/pci/acpi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index 192397c..3468d16 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -298,6 +298,10 @@ setup_resource(struct acpi_resource *acpi_res, void *data)
 			"host bridge window [%#llx-%#llx] "
 			"([%#llx-%#llx] ignored, not CPU addressable)\n", 
 			start, orig_end, end + 1, orig_end);
+	} else if (flags & IORESOURCE_MEM && (start & 0x0f || ~end & 0x0f)) {
+		dev_warn(&info->bridge->dev,
+			 "invalid host bridge window [%#llx-%#llx]\n",
+			 start, end);
 	}
 
 	res = &info->res[info->res_num];
-- 
1.7.12.3


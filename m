Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756471Ab2AXCnl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 21:43:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50073 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756323Ab2AXCni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:43:38 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:26 2012
Message-Id: <20120124023926.859888923@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:34:13 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Gary Hade <garyhade@us.ibm.com>,
        Thomas Renninger <trenn@novell.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [033/129] x86/PCI: Ignore CPU non-addressable _CRS reserved memory resources
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 1988
Lines: 58

From: Gary Hade <garyhade@us.ibm.com>

commit ae5cd86455381282ece162966183d3f208c6fad7 upstream.

This assures that a _CRS reserved host bridge window or window region is
not used if it is not addressable by the CPU.  The new code either trims
the window to exclude the non-addressable portion or totally ignores the
window if the entire window is non-addressable.

The current code has been shown to be problematic with 32-bit non-PAE
kernels on systems where _CRS reserves resources above 4GB.

Signed-off-by: Gary Hade <garyhade@us.ibm.com>
Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: Thomas Renninger <trenn@novell.com>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/pci/acpi.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -149,7 +149,7 @@ setup_resource(struct acpi_resource *acp
 	struct acpi_resource_address64 addr;
 	acpi_status status;
 	unsigned long flags;
-	u64 start, end;
+	u64 start, orig_end, end;
 
 	status = resource_to_addr(acpi_res, &addr);
 	if (!ACPI_SUCCESS(status))
@@ -165,7 +165,21 @@ setup_resource(struct acpi_resource *acp
 		return AE_OK;
 
 	start = addr.minimum + addr.translation_offset;
-	end = addr.maximum + addr.translation_offset;
+	orig_end = end = addr.maximum + addr.translation_offset;
+
+	/* Exclude non-addressable range or non-addressable portion of range */
+	end = min(end, (u64)iomem_resource.end);
+	if (end <= start) {
+		dev_info(&info->bridge->dev,
+			"host bridge window [%#llx-%#llx] "
+			"(ignored, not CPU addressable)\n", start, orig_end);
+		return AE_OK;
+	} else if (orig_end != end) {
+		dev_info(&info->bridge->dev,
+			"host bridge window [%#llx-%#llx] "
+			"([%#llx-%#llx] ignored, not CPU addressable)\n",
+			start, orig_end, end + 1, orig_end);
+	}
 
 	res = &info->res[info->res_num];
 	res->name = info->name;



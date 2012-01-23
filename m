Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199Ab2AWX6R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 18:58:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42705 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754142Ab2AWXuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 18:50:05 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 15:40:28 2012
Message-Id: <20120123234028.864385528@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 15:39:56 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, x86@kernel.org,
        Kurt Garloff <kurt@garloff.de>, Len Brown <len.brown@intel.com>
Subject: [70/90] ACPI, x86: Use SRAT table rev to use 8bit or 32bit PXM fields (x86/x86-64)
In-Reply-To: <20120123234211.GA19504@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kurt Garloff <kurt@garloff.de>

commit cd298f60a2451a16e0f077404bf69b62ec868733 upstream.

In SRAT v1, we had 8bit proximity domain (PXM) fields; SRAT v2 provides
32bits for these. The new fields were reserved before.
According to the ACPI spec, the OS must disregrard reserved fields.

x86/x86-64 was rather inconsistent prior to this patch; it used 8 bits
for the pxm field in cpu_affinity, but 32 bits in mem_affinity.
This patch makes it consistent: Either use 8 bits consistently (SRAT
rev 1 or lower) or 32 bits (SRAT rev 2 or higher).

cc: x86@kernel.org
Signed-off-by: Kurt Garloff <kurt@garloff.de>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/mm/srat.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/x86/mm/srat.c
+++ b/arch/x86/mm/srat.c
@@ -104,6 +104,8 @@ acpi_numa_processor_affinity_init(struct
 	if ((pa->flags & ACPI_SRAT_CPU_ENABLED) == 0)
 		return;
 	pxm = pa->proximity_domain_lo;
+	if (acpi_srat_revision >= 2)
+		pxm |= *((unsigned int*)pa->proximity_domain_hi) << 8;
 	node = setup_node(pxm);
 	if (node < 0) {
 		printk(KERN_ERR "SRAT: Too many proximity domains %x\n", pxm);
@@ -155,6 +157,8 @@ acpi_numa_memory_affinity_init(struct ac
 	start = ma->base_address;
 	end = start + ma->length;
 	pxm = ma->proximity_domain;
+	if (acpi_srat_revision <= 1)
+		pxm &= 0xff;
 	node = setup_node(pxm);
 	if (node < 0) {
 		printk(KERN_ERR "SRAT: Too many proximity domains.\n");



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933001Ab2AXCvx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 21:51:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50699 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932927Ab2AXCtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:49:11 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:32 2012
Message-Id: <20120124023932.853710963@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:35:20 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Kurt Garloff <kurt@garloff.de>,
        Len Brown <len.brown@intel.com>
Subject: [100/129] ACPI: Store SRAT table revision
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 1721
Lines: 58

From: Kurt Garloff <kurt@garloff.de>

commit 8df0eb7c9d96f9e82f233ee8b74e0f0c8471f868 upstream.

In SRAT v1, we had 8bit proximity domain (PXM) fields; SRAT v2 provides
32bits for these. The new fields were reserved before.
According to the ACPI spec, the OS must disregrard reserved fields.
In order to know whether or not, we must know what version the SRAT
table has.

This patch stores the SRAT table revision for later consumption
by arch specific __init functions.

Signed-off-by: Kurt Garloff <kurt@garloff.de>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/numa.c      |    6 ++++++
 include/acpi/acpi_numa.h |    1 +
 2 files changed, 7 insertions(+)

--- a/drivers/acpi/numa.c
+++ b/drivers/acpi/numa.c
@@ -45,6 +45,8 @@ static int pxm_to_node_map[MAX_PXM_DOMAI
 static int node_to_pxm_map[MAX_NUMNODES]
 			= { [0 ... MAX_NUMNODES - 1] = PXM_INVAL };
 
+unsigned char acpi_srat_revision __initdata;
+
 int pxm_to_node(int pxm)
 {
 	if (pxm < 0)
@@ -255,9 +257,13 @@ acpi_parse_memory_affinity(struct acpi_s
 
 static int __init acpi_parse_srat(struct acpi_table_header *table)
 {
+	struct acpi_table_srat *srat;
 	if (!table)
 		return -EINVAL;
 
+	srat = (struct acpi_table_srat *)table;
+	acpi_srat_revision = srat->header.revision;
+
 	/* Real work done in acpi_table_parse_srat below. */
 
 	return 0;
--- a/include/acpi/acpi_numa.h
+++ b/include/acpi/acpi_numa.h
@@ -15,6 +15,7 @@ extern int pxm_to_node(int);
 extern int node_to_pxm(int);
 extern void __acpi_map_pxm_to_node(int, int);
 extern int acpi_map_pxm_to_node(int);
+extern unsigned char acpi_srat_revision;
 
 #endif				/* CONFIG_ACPI_NUMA */
 #endif				/* __ACP_NUMA_H */



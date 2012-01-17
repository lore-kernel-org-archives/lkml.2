Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016Ab2AQM1P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 07:27:15 -0500
Received: from vms173007pub.verizon.net ([206.46.173.7]:43854 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681Ab2AQMWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 07:22:18 -0500
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: Kurt Garloff <kurt@garloff.de>, Len Brown <len.brown@intel.com>
Subject: [PATCH 36/50] ACPI: Store SRAT table revision
Date: Tue, 17 Jan 2012 07:21:28 -0500
Message-id: <8df0eb7c9d96f9e82f233ee8b74e0f0c8471f868.1326802230.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.9.rc1
In-reply-to: <1326802902-21583-1-git-send-email-lenb@kernel.org>
References: <1326802902-21583-1-git-send-email-lenb@kernel.org>
In-reply-to: <553575f1ae048aa44682b46b3c51929a0b3ad337.1326802228.git.len.brown@intel.com>
References: <553575f1ae048aa44682b46b3c51929a0b3ad337.1326802228.git.len.brown@intel.com>
Reply-to: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kurt Garloff <kurt@garloff.de>

In SRAT v1, we had 8bit proximity domain (PXM) fields; SRAT v2 provides
32bits for these. The new fields were reserved before.
According to the ACPI spec, the OS must disregrard reserved fields.
In order to know whether or not, we must know what version the SRAT
table has.

This patch stores the SRAT table revision for later consumption
by arch specific __init functions.

Signed-off-by: Kurt Garloff <kurt@garloff.de>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/numa.c      |    6 ++++++
 include/acpi/acpi_numa.h |    1 +
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/numa.c b/drivers/acpi/numa.c
index 3b5c318..e56f3be 100644
--- a/drivers/acpi/numa.c
+++ b/drivers/acpi/numa.c
@@ -45,6 +45,8 @@ static int pxm_to_node_map[MAX_PXM_DOMAINS]
 static int node_to_pxm_map[MAX_NUMNODES]
 			= { [0 ... MAX_NUMNODES - 1] = PXM_INVAL };
 
+unsigned char acpi_srat_revision __initdata;
+
 int pxm_to_node(int pxm)
 {
 	if (pxm < 0)
@@ -255,9 +257,13 @@ acpi_parse_memory_affinity(struct acpi_subtable_header * header,
 
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
diff --git a/include/acpi/acpi_numa.h b/include/acpi/acpi_numa.h
index 1739726..451823c 100644
--- a/include/acpi/acpi_numa.h
+++ b/include/acpi/acpi_numa.h
@@ -15,6 +15,7 @@ extern int pxm_to_node(int);
 extern int node_to_pxm(int);
 extern void __acpi_map_pxm_to_node(int, int);
 extern int acpi_map_pxm_to_node(int);
+extern unsigned char acpi_srat_revision;
 
 #endif				/* CONFIG_ACPI_NUMA */
 #endif				/* __ACP_NUMA_H */
-- 
1.7.9.rc1


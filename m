Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903Ab0HQA40 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 20:56:26 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57407 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753753Ab0HQA4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 20:56:24 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.5.1
Message-ID: <4C69DE4B.4090904@np.css.fujitsu.com>
Date: Tue, 17 Aug 2010 09:56:43 +0900
From: Jin Dongming <jin.dongming@np.css.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; ja; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andi Kleen <andi@firstfloor.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        ACPI <linux-acpi@vger.kernel.org>, LKLM <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] [Patch-next] ACPI, APEI, EINJ Fix the wrong checking
 of Injection Header's length
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

header_length in struct acpi_table_einj is not the length of struct
acpi_table_einj, but the length of Injection Header.

In einj_check_table(), header_length is used for checking the length
of struct acpi_table_einj. So I think it is wrong.

This patch fixed it and I confirmed it on x86_64 next-tree.

Signed-off-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
---
 drivers/acpi/apei/einj.c |   15 +++++++++------
 include/acpi/actbl1.h    |   17 ++++++++++++-----
 2 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/drivers/acpi/apei/einj.c b/drivers/acpi/apei/einj.c
index 465c885..5fe876c 100644
--- a/drivers/acpi/apei/einj.c
+++ b/drivers/acpi/apei/einj.c
@@ -104,7 +104,8 @@ static struct einj_parameter *einj_param;
 static void einj_exec_ctx_init(struct apei_exec_context *ctx)
 {
 	apei_exec_ctx_init(ctx, einj_ins_type, ARRAY_SIZE(einj_ins_type),
-			   EINJ_TAB_ENTRY(einj_tab), einj_tab->entries);
+			   EINJ_TAB_ENTRY(einj_tab),
+			   einj_tab->inje_header.entries);
 }
 
 static int __einj_get_available_error_type(u32 *type)
@@ -153,7 +154,7 @@ static u64 einj_get_parameter_address(void)
 	struct acpi_whea_header *entry;
 
 	entry = EINJ_TAB_ENTRY(einj_tab);
-	for (i = 0; i < einj_tab->entries; i++) {
+	for (i = 0; i < einj_tab->inje_header.entries; i++) {
 		if (entry->action == ACPI_EINJ_SET_ERROR_TYPE &&
 		    entry->instruction == ACPI_EINJ_WRITE_REGISTER &&
 		    entry->register_region.space_id ==
@@ -426,12 +427,14 @@ DEFINE_SIMPLE_ATTRIBUTE(error_inject_fops, NULL,
 
 static int einj_check_table(struct acpi_table_einj *einj_tab)
 {
-	if (einj_tab->header_length != sizeof(struct acpi_table_einj))
+	if (einj_tab->common_header.length < sizeof(struct acpi_table_einj))
 		return -EINVAL;
-	if (einj_tab->header.length < sizeof(struct acpi_table_einj))
+
+	if (einj_tab->inje_header.length != sizeof(struct acpi_einj_header))
 		return -EINVAL;
-	if (einj_tab->entries !=
-	    (einj_tab->header.length - sizeof(struct acpi_table_einj)) /
+
+	if (einj_tab->inje_header.entries !=
+	    (einj_tab->common_header.length - sizeof(struct acpi_table_einj)) /
 	    sizeof(struct acpi_einj_entry))
 		return -EINVAL;
 
diff --git a/include/acpi/actbl1.h b/include/acpi/actbl1.h
index 821f8ac..e586c30 100644
--- a/include/acpi/actbl1.h
+++ b/include/acpi/actbl1.h
@@ -199,14 +199,21 @@ struct acpi_table_ecdt {
  *
  ******************************************************************************/
 
-struct acpi_table_einj {
-	struct acpi_table_header header;	/* Common ACPI table header */
-	u32 header_length;
-	u8 flags;
-	u8 reserved[3];
+/* EINJ Injection Header */
+struct acpi_einj_header {
+	u32 length;
+	u8  flags;
+	u8  reserved[3];
 	u32 entries;
 };
 
+/* EINJ Header */
+
+struct acpi_table_einj {
+	struct acpi_table_header common_header;	/* Common ACPI table header */
+	struct acpi_einj_header inje_header;	/* Injection Header */
+};
+
 /* EINJ Injection Instruction Entries (actions) */
 
 struct acpi_einj_entry {
-- 
1.7.1.1



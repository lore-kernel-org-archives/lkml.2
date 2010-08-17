Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670Ab0HQAx6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 20:53:58 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57266 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068Ab0HQAxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 20:53:53 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.5.1
Message-ID: <4C69DDB5.6060103@np.css.fujitsu.com>
Date: Tue, 17 Aug 2010 09:54:13 +0900
From: Jin Dongming <jin.dongming@np.css.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; ja; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andi Kleen <andi@firstfloor.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        ACPI <linux-acpi@vger.kernel.org>, LKLM <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/4] [Patch-next] ACPI, APEI, ERST Fix the wrong checking
 of Serialization Header's length
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

header_length in struct acpi_table_erst is not the length of struct
acpi_table_erst, but the length of Serialization Header.

In erst_check_table(), header_length is used for checking the length
of struct acpi_table_erst. So I think it is wrong.

This patch fixed it and I confirmed it on x86_64 next-tree.

Signed-off-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
---
 drivers/acpi/apei/erst.c |   13 ++++++++-----
 include/acpi/actbl1.h    |   14 +++++++++++---
 2 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/acpi/apei/erst.c b/drivers/acpi/apei/erst.c
index 864dd46..28a5caf 100644
--- a/drivers/acpi/apei/erst.c
+++ b/drivers/acpi/apei/erst.c
@@ -358,7 +358,8 @@ static struct apei_exec_ins_type erst_ins_type[] = {
 static inline void erst_exec_ctx_init(struct apei_exec_context *ctx)
 {
 	apei_exec_ctx_init(ctx, erst_ins_type, ARRAY_SIZE(erst_ins_type),
-			   ERST_TAB_ENTRY(erst_tab), erst_tab->entries);
+			   ERST_TAB_ENTRY(erst_tab),
+			   erst_tab->seri_header.entries);
 }
 
 static int erst_get_erange(struct erst_erange *range)
@@ -749,12 +750,14 @@ __setup("erst_disable", setup_erst_disable);
 
 static int erst_check_table(struct acpi_table_erst *erst_tab)
 {
-	if (erst_tab->header_length != sizeof(struct acpi_table_erst))
+	if (erst_tab->common_header.length < sizeof(struct acpi_table_erst))
 		return -EINVAL;
-	if (erst_tab->header.length < sizeof(struct acpi_table_erst))
+
+	if (erst_tab->seri_header.length != sizeof(struct acpi_erst_header))
 		return -EINVAL;
-	if (erst_tab->entries !=
-	    (erst_tab->header.length - sizeof(struct acpi_table_erst)) /
+
+	if (erst_tab->seri_header.entries !=
+	    (erst_tab->common_header.length - sizeof(struct acpi_table_erst)) /
 	    sizeof(struct acpi_erst_entry))
 		return -EINVAL;
 
diff --git a/include/acpi/actbl1.h b/include/acpi/actbl1.h
index c637b75..821f8ac 100644
--- a/include/acpi/actbl1.h
+++ b/include/acpi/actbl1.h
@@ -283,13 +283,21 @@ enum acpi_einj_command_status {
  *
  ******************************************************************************/
 
-struct acpi_table_erst {
-	struct acpi_table_header header;	/* Common ACPI table header */
-	u32 header_length;
+/* ERST Serialization Header */
+
+struct acpi_erst_header {
+	u32 length;
 	u32 reserved;
 	u32 entries;
 };
 
+/* ERST Header */
+
+struct acpi_table_erst {
+	struct acpi_table_header common_header;	/* Common ACPI table header */
+	struct acpi_erst_header seri_header;	/* ERST Serialization Header */
+};
+
 /* ERST Serialization Entries (actions) */
 
 struct acpi_erst_entry {
-- 
1.7.1.1



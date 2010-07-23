Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177Ab0GWRkX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 13:40:23 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:40390 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644Ab0GWRkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 13:40:21 -0400
Message-ID: <4C49D3C5.4000007@kernel.org>
Date: Fri, 23 Jul 2010 10:39:17 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>, Huang Ying <ying.huang@intel.com>,
        Andi Kleen <ak@linux.intel.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, Tejun Heo <tj@kernel.org>,
        Daniel J Blueman <daniel.blueman@gmail.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] acpi: fix apei related table size checking
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4C49D3CF.00E2,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


also check if we can find right action in apei.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/acpi/apei/apei-base.c |    5 +++++
 drivers/acpi/apei/einj.c      |    3 ++-
 drivers/acpi/apei/erst.c      |    3 ++-
 3 files changed, 9 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/acpi/apei/einj.c
===================================================================
--- linux-2.6.orig/drivers/acpi/apei/einj.c
+++ linux-2.6/drivers/acpi/apei/einj.c
@@ -426,7 +426,8 @@ DEFINE_SIMPLE_ATTRIBUTE(error_inject_fop
 
 static int einj_check_table(struct acpi_table_einj *einj_tab)
 {
-	if (einj_tab->header_length != sizeof(struct acpi_table_einj))
+	if (einj_tab->header_length !=
+	    (sizeof(struct acpi_table_einj) - sizeof(einj_tab->header)))
 		return -EINVAL;
 	if (einj_tab->header.length < sizeof(struct acpi_table_einj))
 		return -EINVAL;
Index: linux-2.6/drivers/acpi/apei/erst.c
===================================================================
--- linux-2.6.orig/drivers/acpi/apei/erst.c
+++ linux-2.6/drivers/acpi/apei/erst.c
@@ -749,7 +749,8 @@ __setup("erst_disable", setup_erst_disab
 
 static int erst_check_table(struct acpi_table_erst *erst_tab)
 {
-	if (erst_tab->header_length != sizeof(struct acpi_table_erst))
+	if (erst_tab->header_length !=
+	    (sizeof(struct acpi_table_erst) - sizeof(erst_tab->header)))
 		return -EINVAL;
 	if (erst_tab->header.length < sizeof(struct acpi_table_erst))
 		return -EINVAL;
Index: linux-2.6/drivers/acpi/apei/apei-base.c
===================================================================
--- linux-2.6.orig/drivers/acpi/apei/apei-base.c
+++ linux-2.6/drivers/acpi/apei/apei-base.c
@@ -163,6 +163,7 @@ int apei_exec_run(struct apei_exec_conte
 	u32 i, ip;
 	struct acpi_whea_header *entry;
 	apei_exec_ins_func_t run;
+	bool found_action = false;
 
 	ctx->ip = 0;
 
@@ -178,6 +179,7 @@ rewind:
 		entry = &ctx->action_table[i];
 		if (entry->action != action)
 			continue;
+		found_action = true;
 		if (ip == ctx->ip) {
 			if (entry->instruction >= ctx->instructions ||
 			    !ctx->ins_table[entry->instruction].run) {
@@ -198,6 +200,9 @@ rewind:
 			goto rewind;
 	}
 
+	if (!found_action)
+		return -ENODEV;
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(apei_exec_run);

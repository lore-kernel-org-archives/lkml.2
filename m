Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618Ab0EJJYr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 05:24:47 -0400
Received: from mga14.intel.com ([143.182.124.37]:62721 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752582Ab0EJJYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 05:24:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,361,1270450800"; 
   d="scan'208";a="275209072"
Subject: [BUGFIX] ACPI, APEI, Fix building of APEI EINJ and GHES
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>, Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 May 2010 17:24:42 +0800
Message-ID: <1273483482.3344.65.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy reported building warnings and errors for APEI EINJ and GHES as follow:

drivers/acpi/apei/einj.c:127:error: implicit declaration of function 'ndelay'

ghes.c:(.text+0x119e71): undefined reference to `apei_mce_report_mem_error'
CONFIG_X86_MCE is not enabled

This patch fixes these two bugs.

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 drivers/acpi/apei/einj.c |    1 +
 drivers/acpi/apei/ghes.c |    2 ++
 2 files changed, 3 insertions(+)

--- a/drivers/acpi/apei/einj.c
+++ b/drivers/acpi/apei/einj.c
@@ -29,6 +29,7 @@
 #include <linux/init.h>
 #include <linux/io.h>
 #include <linux/debugfs.h>
+#include <linux/delay.h>
 #include <linux/seq_file.h>
 #include <linux/nmi.h>
 #include <acpi/acpi.h>
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -242,6 +242,7 @@ static void ghes_do_proc(struct ghes *gh
 
 	ser = ghes_severity(ghes->estatus->error_severity);
 	apei_estatus_for_each_section(ghes->estatus, gdata) {
+#ifdef CONFIG_X86_MCE
 		if (!uuid_le_cmp(*(uuid_le *)gdata->section_type,
 				 CPER_SEC_PLATFORM_MEM)) {
 			apei_mce_report_mem_error(
@@ -249,6 +250,7 @@ static void ghes_do_proc(struct ghes *gh
 				(struct cper_sec_mem_err *)(gdata+1));
 			processed = 1;
 		}
+#endif
 	}
 
 	if (!processed && printk_ratelimit())



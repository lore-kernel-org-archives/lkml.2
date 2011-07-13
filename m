Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964869Ab1GMFRr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 01:17:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:9791 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751713Ab1GMFOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 01:14:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,523,1304319600"; 
   d="scan'208";a="27048181"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Tony Luck <tony.luck@intel.com>, ying.huang@intel.com,
        linux-acpi@vger.kernel.org, Thomas Renninger <trenn@novell.com>
Subject: [PATCH 05/17] ACPI, APEI, Add apei_exec_run_optional
Date: Wed, 13 Jul 2011 13:14:16 +0800
Message-Id: <1310534068-30547-6-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1310534068-30547-1-git-send-email-ying.huang@intel.com>
References: <1310534068-30547-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some actions in APEI ERST and EINJ tables are optional, for example,
ACPI_EINJ_BEGIN_OPERATION action is used to do some preparation for
error injection, and firmware may choose to do nothing here.  While
some other actions are mandatory, for example, firmware must provide
ACPI_EINJ_GET_ERROR_TYPE implementation.

Original implementation treats all actions as optional (that is, can
have no instructions), that may cause issue if firmware does not
provide some mandatory actions.  To fix this, this patch adds
apei_exec_run_optional, which should be used for optional actions.
The original apei_exec_run should be used for mandatory actions.

Cc: Thomas Renninger <trenn@novell.com>
Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 drivers/acpi/apei/apei-base.c     |    9 +++++----
 drivers/acpi/apei/apei-internal.h |   13 ++++++++++++-
 2 files changed, 17 insertions(+), 5 deletions(-)

--- a/drivers/acpi/apei/apei-base.c
+++ b/drivers/acpi/apei/apei-base.c
@@ -157,9 +157,10 @@ EXPORT_SYMBOL_GPL(apei_exec_noop);
  * Interpret the specified action. Go through whole action table,
  * execute all instructions belong to the action.
  */
-int apei_exec_run(struct apei_exec_context *ctx, u8 action)
+int __apei_exec_run(struct apei_exec_context *ctx, u8 action,
+		    bool optional)
 {
-	int rc;
+	int rc = -ENOENT;
 	u32 i, ip;
 	struct acpi_whea_header *entry;
 	apei_exec_ins_func_t run;
@@ -198,9 +199,9 @@ rewind:
 			goto rewind;
 	}
 
-	return 0;
+	return !optional && rc < 0 ? rc : 0;
 }
-EXPORT_SYMBOL_GPL(apei_exec_run);
+EXPORT_SYMBOL_GPL(__apei_exec_run);
 
 typedef int (*apei_exec_entry_func_t)(struct apei_exec_context *ctx,
 				      struct acpi_whea_header *entry,
--- a/drivers/acpi/apei/apei-internal.h
+++ b/drivers/acpi/apei/apei-internal.h
@@ -50,7 +50,18 @@ static inline u64 apei_exec_ctx_get_outp
 	return ctx->value;
 }
 
-int apei_exec_run(struct apei_exec_context *ctx, u8 action);
+int __apei_exec_run(struct apei_exec_context *ctx, u8 action, bool optional);
+
+static inline int apei_exec_run(struct apei_exec_context *ctx, u8 action)
+{
+	return __apei_exec_run(ctx, action, 0);
+}
+
+/* It is optional whether the firmware provides the action */
+static inline int apei_exec_run_optional(struct apei_exec_context *ctx, u8 action)
+{
+	return __apei_exec_run(ctx, action, 1);
+}
 
 /* Common instruction implementation */
 

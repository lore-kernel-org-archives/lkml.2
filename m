Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab1HBWP2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 18:15:28 -0400
Received: from vms173019pub.verizon.net ([206.46.173.19]:41610 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755579Ab1HBWPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 18:15:21 -0400
From: Len Brown <lenb@kernel.org>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Cc: Huang Ying <ying.huang@intel.com>, Thomas Renninger <trenn@novell.com>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 04/19] ACPI, APEI, Add apei_exec_run_optional
Date: Tue, 02 Aug 2011 18:14:37 -0400
Message-id: <eecf2f7124834dd1cad21807526a8ea031ba8217.1312323131.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.6.396.ge0613
In-reply-to: <1312323292-2986-1-git-send-email-lenb@kernel.org>
References: <1312323292-2986-1-git-send-email-lenb@kernel.org>
In-reply-to: <ca7cc5110a313a609da40ae948978a585352564b.1312323131.git.len.brown@intel.com>
References: <ca7cc5110a313a609da40ae948978a585352564b.1312323131.git.len.brown@intel.com>
X-Patchwork-Hint: ignore
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huang Ying <ying.huang@intel.com>

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
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/apei/apei-base.c     |    9 +++++----
 drivers/acpi/apei/apei-internal.h |   13 ++++++++++++-
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/apei/apei-base.c b/drivers/acpi/apei/apei-base.c
index 4a904a4..0714194 100644
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
diff --git a/drivers/acpi/apei/apei-internal.h b/drivers/acpi/apei/apei-internal.h
index ef0581f..f286cf7 100644
--- a/drivers/acpi/apei/apei-internal.h
+++ b/drivers/acpi/apei/apei-internal.h
@@ -50,7 +50,18 @@ static inline u64 apei_exec_ctx_get_output(struct apei_exec_context *ctx)
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
 
-- 
1.7.6.396.ge0613


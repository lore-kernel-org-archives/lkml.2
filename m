Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933857Ab1DNSKE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:10:04 -0400
Received: from mail.windriver.com ([147.11.1.11]:42124 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964828Ab1DNR6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:58:34 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Bob Moore <robert.moore@intel.com>,
        Lin Ming <ming.m.lin@intel.com>, Len Brown <len.brown@intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 171/209] Subject: [PATCH] ACPICA: Fix Scope() op in module level code
Date: Thu, 14 Apr 2011 13:55:29 -0400
Message-Id: <1302803767-9715-58-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
 <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Moore <robert.moore@intel.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit 8df3fc981dc12d9fdcaef4100a2193b605024d7a upstream.

Some Panasonic Toughbooks create nodes in module level code.
Module level code is the executable AML code outside of control method,
for example, below AML code creates a node \_SB.PCI0.GFX0.DD02.CUBL

        If (\_OSI ("Windows 2006"))
        {
            Scope (\_SB.PCI0.GFX0.DD02)
            {
                Name (CUBL, Ones)
                ...
            }
        }

Scope() op does not actually create a new object, it refers to an
existing object(\_SB.PCI0.GFX0.DD02 in above example). However, for
Scope(), we want to indeed open a new scope, so the child nodes(CUBL in
above example) can be created correctly under it.

https://bugzilla.kernel.org/show_bug.cgi?id=19462

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/acpi/acpica/dswexec.c |   19 +++++++++++++++++--
 1 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/acpica/dswexec.c b/drivers/acpi/acpica/dswexec.c
index 6b76c48..30839ba 100644
--- a/drivers/acpi/acpica/dswexec.c
+++ b/drivers/acpi/acpica/dswexec.c
@@ -300,10 +300,25 @@ acpi_ds_exec_begin_op(struct acpi_walk_state *walk_state,
 			 * we must enter this object into the namespace.  The created
 			 * object is temporary and will be deleted upon completion of
 			 * the execution of this method.
+			 *
+			 * Note 10/2010: Except for the Scope() op. This opcode does
+			 * not actually create a new object, it refers to an existing
+			 * object. However, for Scope(), we want to indeed open a
+			 * new scope.
 			 */
-			status = acpi_ds_load2_begin_op(walk_state, NULL);
+			if (op->common.aml_opcode != AML_SCOPE_OP) {
+				status =
+				    acpi_ds_load2_begin_op(walk_state, NULL);
+			} else {
+				status =
+				    acpi_ds_scope_stack_push(op->named.node,
+							     op->named.node->
+							     type, walk_state);
+				if (ACPI_FAILURE(status)) {
+					return_ACPI_STATUS(status);
+				}
+			}
 		}
-
 		break;
 
 	case AML_CLASS_EXECUTE:
-- 
1.7.4.4


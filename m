Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354Ab1BBA5x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:57:53 -0500
Received: from mga09.intel.com ([134.134.136.24]:33759 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753482Ab1BBAo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:44:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="598622473"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: robert.moore@intel.com, ming.m.lin@intel.com, len.brown@intel.com,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH] [75/139] ACPICA: Fix Scope() op in module level code
Message-Id: <20110202004432.47A5C3E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:44:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Bob Moore <robert.moore@intel.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/acpi/acpica/dswexec.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/drivers/acpi/acpica/dswexec.c
===================================================================
--- linux-2.6.35.y.orig/drivers/acpi/acpica/dswexec.c
+++ linux-2.6.35.y/drivers/acpi/acpica/dswexec.c
@@ -300,10 +300,25 @@ acpi_ds_exec_begin_op(struct acpi_walk_s
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

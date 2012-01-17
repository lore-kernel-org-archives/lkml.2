Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202Ab2AQMWP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 07:22:15 -0500
Received: from vms173013pub.verizon.net ([206.46.173.13]:39447 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066Ab2AQMWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 07:22:03 -0500
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: Lin Ming <ming.m.lin@intel.com>, Bob Moore <robert.moore@intel.com>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 04/50] ACPICA: Fix to allow region arguments to reference other
 scopes
Date: Tue, 17 Jan 2012 07:20:56 -0500
Message-id: <8931d9ea78848b073bf299594f148b83abde4a5e.1326802229.git.len.brown@intel.com>
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

From: Lin Ming <ming.m.lin@intel.com>

Allow referenced objects to be in a different scope.

http://www.acpica.org/bugzilla/show_bug.cgi?id=937
http://marc.info/?l=linux-acpi&m=131636632718222&w=2

ACPI Error: [RAMB] Namespace lookup failure, AE_NOT_FOUND (20110112/psargs-359)
ACPI Exception: AE_NOT_FOUND, Could not execute arguments for [RAMW] (Region) (20110112/nsinit-349)

    Scope (_SB)
    {
        Name (RAMB, 0xDF5A1018)
        OperationRegion (\RAMW, SystemMemory, RAMB, 0x00010000)
    }

For above ASL code, we need to save scope node(\_SB) to lookup
the argument node(\_SB.RAMB).

Reported-by: Jim Green <student.northwestern@gmail.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/acpica/acobject.h |    1 +
 drivers/acpi/acpica/dsargs.c   |    2 +-
 drivers/acpi/acpica/excreate.c |    6 ++++++
 3 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/acpica/acobject.h b/drivers/acpi/acpica/acobject.h
index 1055769..6d276c2 100644
--- a/drivers/acpi/acpica/acobject.h
+++ b/drivers/acpi/acpica/acobject.h
@@ -358,6 +358,7 @@ typedef enum {
  */
 struct acpi_object_extra {
 	ACPI_OBJECT_COMMON_HEADER struct acpi_namespace_node *method_REG;	/* _REG method for this region (if any) */
+	struct acpi_namespace_node *scope_node;
 	void *region_context;	/* Region-specific data */
 	u8 *aml_start;
 	u32 aml_length;
diff --git a/drivers/acpi/acpica/dsargs.c b/drivers/acpi/acpica/dsargs.c
index 42163d8..d69e4a5 100644
--- a/drivers/acpi/acpica/dsargs.c
+++ b/drivers/acpi/acpica/dsargs.c
@@ -384,7 +384,7 @@ acpi_status acpi_ds_get_region_arguments(union acpi_operand_object *obj_desc)
 
 	/* Execute the argument AML */
 
-	status = acpi_ds_execute_arguments(node, node->parent,
+	status = acpi_ds_execute_arguments(node, extra_desc->extra.scope_node,
 					   extra_desc->extra.aml_length,
 					   extra_desc->extra.aml_start);
 	if (ACPI_FAILURE(status)) {
diff --git a/drivers/acpi/acpica/excreate.c b/drivers/acpi/acpica/excreate.c
index 110711a..8a06dc5 100644
--- a/drivers/acpi/acpica/excreate.c
+++ b/drivers/acpi/acpica/excreate.c
@@ -330,6 +330,12 @@ acpi_ex_create_region(u8 * aml_start,
 	region_obj2 = obj_desc->common.next_object;
 	region_obj2->extra.aml_start = aml_start;
 	region_obj2->extra.aml_length = aml_length;
+	if (walk_state->scope_info) {
+		region_obj2->extra.scope_node =
+		    walk_state->scope_info->scope.node;
+	} else {
+		region_obj2->extra.scope_node = node;
+	}
 
 	/* Init the region from the operands */
 
-- 
1.7.9.rc1


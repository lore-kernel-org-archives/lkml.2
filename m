Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965236Ab2DSVRu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:17:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37406 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965220Ab2DSVRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:17:45 -0400
Message-Id: <20120419210823.330819467@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:09:13 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jim Green <student.northwestern@gmail.com>,
        Lin Ming <ming.m.lin@intel.com>, Bob Moore <robert.moore@intel.com>,
        Len Brown <len.brown@intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [ 55/68] ACPICA: Fix to allow region arguments to reference other scopes
In-Reply-To: <20120419210923.GA18589@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lin Ming <ming.m.lin@intel.com>

commit 8931d9ea78848b073bf299594f148b83abde4a5e upstream.

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
Cc: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/acpica/acobject.h |    1 +
 drivers/acpi/acpica/dsargs.c   |    2 +-
 drivers/acpi/acpica/excreate.c |    6 ++++++
 3 files changed, 8 insertions(+), 1 deletion(-)

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
--- a/drivers/acpi/acpica/dsargs.c
+++ b/drivers/acpi/acpica/dsargs.c
@@ -384,7 +384,7 @@ acpi_status acpi_ds_get_region_arguments
 
 	/* Execute the argument AML */
 
-	status = acpi_ds_execute_arguments(node, node->parent,
+	status = acpi_ds_execute_arguments(node, extra_desc->extra.scope_node,
 					   extra_desc->extra.aml_length,
 					   extra_desc->extra.aml_start);
 	if (ACPI_FAILURE(status)) {
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
 



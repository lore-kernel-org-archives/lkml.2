Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167Ab1I1XNm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 19:13:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54300 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932649Ab1I1WoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:44:17 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:35 2011
Message-Id: <20110928220135.032739599@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:00:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Fenghua Yu <fenghua.yu@intel.com>, Bob Moore <robert.moore@intel.com>,
        Lin Ming <ming.m.lin@intel.com>, Len Brown <len.brown@intel.com>
Subject: [092/244] ACPICA: Do not repair _TSS return package if _PSS is present
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Fenghua Yu <fenghua.yu@intel.com>

commit 8f9c91273e36e5762c617c23e4fd48d5172e0dac upstream.

We can only sort the _TSS return package if there is no _PSS
in the same scope. This is because if _PSS is present, the ACPI
specification dictates that the _TSS Power Dissipation field is
to be ignored, and therefore some BIOSs leave garbage values in
the _TSS Power field(s).  In this case, it is best to just return
the _TSS package as-is.

Reported-by: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/acpica/aclocal.h   |    1 +
 drivers/acpi/acpica/nspredef.c  |    1 +
 drivers/acpi/acpica/nsrepair2.c |   15 +++++++++++++++
 3 files changed, 17 insertions(+)

--- a/drivers/acpi/acpica/aclocal.h
+++ b/drivers/acpi/acpica/aclocal.h
@@ -357,6 +357,7 @@ struct acpi_predefined_data {
 	char *pathname;
 	const union acpi_predefined_info *predefined;
 	union acpi_operand_object *parent_package;
+	struct acpi_namespace_node *node;
 	u32 flags;
 	u8 node_flags;
 };
--- a/drivers/acpi/acpica/nspredef.c
+++ b/drivers/acpi/acpica/nspredef.c
@@ -212,6 +212,7 @@ acpi_ns_check_predefined_names(struct ac
 		goto cleanup;
 	}
 	data->predefined = predefined;
+	data->node = node;
 	data->node_flags = node->flags;
 	data->pathname = pathname;
 
--- a/drivers/acpi/acpica/nsrepair2.c
+++ b/drivers/acpi/acpica/nsrepair2.c
@@ -503,6 +503,21 @@ acpi_ns_repair_TSS(struct acpi_predefine
 {
 	union acpi_operand_object *return_object = *return_object_ptr;
 	acpi_status status;
+	struct acpi_namespace_node *node;
+
+	/*
+	 * We can only sort the _TSS return package if there is no _PSS in the
+	 * same scope. This is because if _PSS is present, the ACPI specification
+	 * dictates that the _TSS Power Dissipation field is to be ignored, and
+	 * therefore some BIOSs leave garbage values in the _TSS Power field(s).
+	 * In this case, it is best to just return the _TSS package as-is.
+	 * (May, 2011)
+	 */
+	status =
+	    acpi_ns_get_node(data->node, "^_PSS", ACPI_NS_NO_UPSEARCH, &node);
+	if (ACPI_SUCCESS(status)) {
+		return (AE_OK);
+	}
 
 	status = acpi_ns_check_sorted_list(data, return_object, 5, 1,
 					   ACPI_SORT_DESCENDING,



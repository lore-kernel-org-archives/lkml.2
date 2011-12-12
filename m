Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461Ab1LLWDx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 17:03:53 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64127 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300Ab1LLWCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 17:02:24 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: Mike Turquette <mturquette@ti.com>, Sascha Hauer <kernel@pengutronix.de>,
        Rob Herring <rob.herring@calxeda.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [RFC v2 3/9] of: Add of_property_match_string() to find index into a string list
Date: Mon, 12 Dec 2011 15:02:03 -0700
Message-Id: <1323727329-4989-3-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323727329-4989-1-git-send-email-grant.likely@secretlab.ca>
References: <1323727329-4989-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a helper function for finding the index of a string in a string
list property.  This helper is useful for bindings that use a separate
*-name property for attaching names to tuples in another property such
as 'reg' or 'gpios'.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 arch/arm/boot/dts/testcases/tests-phandle.dtsi |    2 +
 drivers/of/base.c                              |   36 ++++++++++++++++++++++++
 drivers/of/selftest.c                          |   29 +++++++++++++++++++
 include/linux/of.h                             |    3 ++
 4 files changed, 70 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/testcases/tests-phandle.dtsi b/arch/arm/boot/dts/testcases/tests-phandle.dtsi
index ec0c4e6..0007d3c 100644
--- a/arch/arm/boot/dts/testcases/tests-phandle.dtsi
+++ b/arch/arm/boot/dts/testcases/tests-phandle.dtsi
@@ -31,6 +31,8 @@
 				phandle-list-bad-phandle = <12345678 0 0>;
 				phandle-list-bad-args = <&provider2 1 0>,
 							<&provider3 0>;
+				empty-property;
+				unterminated-string = [40 41 42 43];
 			};
 		};
 	};
diff --git a/drivers/of/base.c b/drivers/of/base.c
index c6db9ab..ff3c1fb 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -761,6 +761,42 @@ int of_property_read_string_index(struct device_node *np, const char *propname,
 }
 EXPORT_SYMBOL_GPL(of_property_read_string_index);
 
+/**
+ * of_property_match_string() - Find string in a list and return index
+ * @np: pointer to node containing string list property
+ * @propname: string list property name
+ * @string: pointer to string to search for in string list
+ *
+ * This function searches a string list property and returns the index
+ * of a specific string value.
+ */
+int of_property_match_string(struct device_node *np, const char *propname,
+			     const char *string)
+{
+	struct property *prop = of_find_property(np, propname, NULL);
+	size_t l;
+	int i;
+	const char *p, *end;
+
+	if (!prop)
+		return -EINVAL;
+	if (!prop->value)
+		return -ENODATA;
+
+	p = prop->value;
+	end = p + prop->length;
+
+	for (i = 0; p < end; i++, p += l) {
+		l = strlen(p) + 1;
+		if (p + l > end)
+			return -EILSEQ;
+		pr_debug("comparing %s with %s\n", string, p);
+		if (strcmp(string, p) == 0)
+			return i; /* Found it; return index */
+	}
+	return -ENODATA;
+}
+EXPORT_SYMBOL_GPL(of_property_match_string);
 
 /**
  * of_property_count_strings - Find and return the number of strings from a
diff --git a/drivers/of/selftest.c b/drivers/of/selftest.c
index 9d2b480..f24ffd7 100644
--- a/drivers/of/selftest.c
+++ b/drivers/of/selftest.c
@@ -120,6 +120,34 @@ static void __init of_selftest_parse_phandle_with_args(void)
 	pr_info("end - %s\n", passed_all ? "PASS" : "FAIL");
 }
 
+static void __init of_selftest_property_match_string(void)
+{
+	struct device_node *np;
+	int rc;
+
+	pr_info("start\n");
+	np = of_find_node_by_path("/testcase-data/phandle-tests/consumer-a");
+	if (!np) {
+		pr_err("No testcase data in device tree\n");
+		return;
+	}
+
+	rc = of_property_match_string(np, "phandle-list-names", "first");
+	selftest(rc == 0, "first expected:0 got:%i\n", rc);
+	rc = of_property_match_string(np, "phandle-list-names", "second");
+	selftest(rc == 1, "second expected:0 got:%i\n", rc);
+	rc = of_property_match_string(np, "phandle-list-names", "third");
+	selftest(rc == 2, "third expected:0 got:%i\n", rc);
+	rc = of_property_match_string(np, "phandle-list-names", "fourth");
+	selftest(rc == -ENODATA, "unmatched string; rc=%i", rc);
+	rc = of_property_match_string(np, "missing-property", "blah");
+	selftest(rc == -EINVAL, "missing property; rc=%i", rc);
+	rc = of_property_match_string(np, "empty-property", "blah");
+	selftest(rc == -ENODATA, "empty property; rc=%i", rc);
+	rc = of_property_match_string(np, "unterminated-string", "blah");
+	selftest(rc == -EILSEQ, "unterminated string; rc=%i", rc);
+}
+
 static int __init of_selftest(void)
 {
 	struct device_node *np;
@@ -133,6 +161,7 @@ static int __init of_selftest(void)
 
 	pr_info("start of selftest - you will see error messages\n");
 	of_selftest_parse_phandle_with_args();
+	of_selftest_property_match_string();
 	pr_info("end of selftest - %s\n", selftest_passed ? "PASS" : "FAIL");
 	return 0;
 }
diff --git a/include/linux/of.h b/include/linux/of.h
index ea44fd7..f02794e 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -218,6 +218,9 @@ extern int of_property_read_string(struct device_node *np,
 extern int of_property_read_string_index(struct device_node *np,
 					 const char *propname,
 					 int index, const char **output);
+extern int of_property_match_string(struct device_node *np,
+				    const char *propname,
+				    const char *string);
 extern int of_property_count_strings(struct device_node *np,
 				     const char *propname);
 extern int of_device_is_compatible(const struct device_node *device,
-- 
1.7.5.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574Ab1KIBXo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 20:23:44 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:37513 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137Ab1KIBXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 20:23:42 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        Sascha Hauer <kernel@pengutronix.de>,
        Rob Herring <rob.herring@calxeda.com>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>
Subject: [RFC 5/8] of: Add of_property_match_string() to find index into a string list
Date: Tue,  8 Nov 2011 18:19:40 -0700
Message-Id: <1320801583-12774-6-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1320801583-12774-1-git-send-email-grant.likely@secretlab.ca>
References: <1320801583-12774-1-git-send-email-grant.likely@secretlab.ca>
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
index d26fe99..a464e48 100644
--- a/arch/arm/boot/dts/testcases/tests-phandle.dtsi
+++ b/arch/arm/boot/dts/testcases/tests-phandle.dtsi
@@ -26,6 +26,8 @@
 				phandle-list-bad-phandle = <12345678 0 0>;
 				phandle-list-bad-args = <&provider2 1 0>,
 							<&provider3 0>;
+				empty-property;
+				unterminated-string = [40 41 42 43];
 			};
 		};
 	};
diff --git a/drivers/of/base.c b/drivers/of/base.c
index 7fe8397..7d4f8b9 100644
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
index dc3b215..851e0cd 100644
--- a/drivers/of/selftest.c
+++ b/drivers/of/selftest.c
@@ -118,10 +118,39 @@ static void __init of_selftest_parse_phandle_with_args(void)
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
 	pr_info("start of selftest\n");
 	of_selftest_parse_phandle_with_args();
+	of_selftest_property_match_string();
 	pr_info("end of selftest - %s\n", selftest_passed ? "PASS" : "FAIL");
 	return 0;
 }
diff --git a/include/linux/of.h b/include/linux/of.h
index 566deab..7bdfc15 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -211,6 +211,9 @@ extern int of_property_read_string(struct device_node *np,
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


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945965Ab2I1V0Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:26:25 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:60883 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031557Ab2I1V0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 17:26:10 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Michal Marek <mmarek@suse.cz>
Cc: David Gibson <david@gibson.dropbear.id.au>, Jon Loeliger <jdl@jdl.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] dtc: import latest upstream dtc
Date: Fri, 28 Sep 2012 15:25:59 -0600
Message-Id: <1348867559-2495-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

This updates scripts/dtc to commit 317a5d9 "dtc: zero out new label
objects" from git://git.jdl.com/software/dtc.git.

This adds features such as:
* /bits/ syntax for cell data.
* Math expressions within cell data.
* The ability to delete properties or nodes.
* Support for #line directives in the input file, which allows the use of
  cpp on *.dts.
* -i command-line option (/include/ path)
* -W/-E command-line options for error/warning control.
* Removal of spew to STDOUT containing the filename being compiled.
* Many additions to the libfdt API.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
Notes:
* I compiled all *.dts files in the kernel before and after this change,
  and all md5sums were identical.
* This is a straight copy of the dtc source; no merge with any in-kernel-
  only changes was performed. Hopefully there is no issue here, since I
  see no functional regressions nor new warnings.
* My system appears to have Bison 2.4.1, whereas the grammer was
  previously generated using Bison 2.4.3. Again, this doesn't appear to
  cause any issues.
* I have posted some patches to kbuild that depend on this; see:
  https://lists.ozlabs.org/pipermail/devicetree-discuss/2012-September/020393.html
  Hopefully this patch and that series can go through the same tree.

 scripts/dtc/Makefile.dtc             |   13 +-
 scripts/dtc/checks.c                 |  203 +++++++---
 scripts/dtc/data.c                   |  124 ++----
 scripts/dtc/dtc-lexer.l              |   65 +++-
 scripts/dtc/dtc-lexer.lex.c_shipped  |  503 ++++++++++++++++------
 scripts/dtc/dtc-parser.tab.c_shipped |  780 +++++++++++++++++++++++++++-------
 scripts/dtc/dtc-parser.tab.h_shipped |   47 ++-
 scripts/dtc/dtc-parser.y             |  255 ++++++++++--
 scripts/dtc/dtc.c                    |   21 +-
 scripts/dtc/dtc.h                    |   51 +++-
 scripts/dtc/fdtdump.c                |  162 +++++++
 scripts/dtc/fdtget.c                 |  366 ++++++++++++++++
 scripts/dtc/fdtput.c                 |  362 ++++++++++++++++
 scripts/dtc/flattree.c               |    3 +
 scripts/dtc/libfdt/Makefile.libfdt   |    6 +-
 scripts/dtc/libfdt/fdt.c             |   61 ++-
 scripts/dtc/libfdt/fdt_empty_tree.c  |   84 ++++
 scripts/dtc/libfdt/fdt_ro.c          |  275 +++++++++----
 scripts/dtc/libfdt/fdt_rw.c          |   29 ++
 scripts/dtc/libfdt/fdt_sw.c          |   11 +-
 scripts/dtc/libfdt/fdt_wip.c         |   41 +--
 scripts/dtc/libfdt/libfdt.h          |  440 ++++++++++++++++++-
 scripts/dtc/libfdt/libfdt_env.h      |   16 +-
 scripts/dtc/libfdt/libfdt_internal.h |    2 +-
 scripts/dtc/livetree.c               |  128 +++++-
 scripts/dtc/srcpos.c                 |   98 ++++-
 scripts/dtc/srcpos.h                 |   31 ++
 scripts/dtc/treesource.c             |    2 +
 scripts/dtc/util.c                   |  272 ++++++++++++
 scripts/dtc/util.h                   |   97 +++++
 30 files changed, 3847 insertions(+), 701 deletions(-)
 create mode 100644 scripts/dtc/fdtdump.c
 create mode 100644 scripts/dtc/fdtget.c
 create mode 100644 scripts/dtc/fdtput.c
 create mode 100644 scripts/dtc/libfdt/fdt_empty_tree.c

diff --git a/scripts/dtc/Makefile.dtc b/scripts/dtc/Makefile.dtc
index 6ddf9ec..bece49b 100644
--- a/scripts/dtc/Makefile.dtc
+++ b/scripts/dtc/Makefile.dtc
@@ -3,7 +3,16 @@
 # This is not a complete Makefile of itself.  Instead, it is designed to
 # be easily embeddable into other systems of Makefiles.
 #
-DTC_SRCS = dtc.c flattree.c fstree.c data.c livetree.c treesource.c srcpos.c \
-	checks.c
+DTC_SRCS = \
+	checks.c \
+	data.c \
+	dtc.c \
+	flattree.c \
+	fstree.c \
+	livetree.c \
+	srcpos.c \
+	treesource.c \
+	util.c
+
 DTC_GEN_SRCS = dtc-lexer.lex.c dtc-parser.tab.c
 DTC_OBJS = $(DTC_SRCS:%.c=%.o) $(DTC_GEN_SRCS:%.c=%.o)
diff --git a/scripts/dtc/checks.c b/scripts/dtc/checks.c
index a662a00..ee96a25 100644
--- a/scripts/dtc/checks.c
+++ b/scripts/dtc/checks.c
@@ -31,12 +31,6 @@
 #define TRACE(c, fmt, ...)	do { } while (0)
 #endif
 
-enum checklevel {
-	IGNORE = 0,
-	WARN = 1,
-	ERROR = 2,
-};
-
 enum checkstatus {
 	UNCHECKED = 0,
 	PREREQ,
@@ -57,14 +51,14 @@ struct check {
 	node_check_fn node_fn;
 	prop_check_fn prop_fn;
 	void *data;
-	enum checklevel level;
+	bool warn, error;
 	enum checkstatus status;
 	int inprogress;
 	int num_prereqs;
 	struct check **prereq;
 };
 
-#define CHECK(nm, tfn, nfn, pfn, d, lvl, ...) \
+#define CHECK_ENTRY(nm, tfn, nfn, pfn, d, w, e, ...)	       \
 	static struct check *nm##_prereqs[] = { __VA_ARGS__ }; \
 	static struct check nm = { \
 		.name = #nm, \
@@ -72,20 +66,37 @@ struct check {
 		.node_fn = (nfn), \
 		.prop_fn = (pfn), \
 		.data = (d), \
-		.level = (lvl), \
+		.warn = (w), \
+		.error = (e), \
 		.status = UNCHECKED, \
 		.num_prereqs = ARRAY_SIZE(nm##_prereqs), \
 		.prereq = nm##_prereqs, \
 	};
-
-#define TREE_CHECK(nm, d, lvl, ...) \
-	CHECK(nm, check_##nm, NULL, NULL, d, lvl, __VA_ARGS__)
-#define NODE_CHECK(nm, d, lvl, ...) \
-	CHECK(nm, NULL, check_##nm, NULL, d, lvl, __VA_ARGS__)
-#define PROP_CHECK(nm, d, lvl, ...) \
-	CHECK(nm, NULL, NULL, check_##nm, d, lvl, __VA_ARGS__)
-#define BATCH_CHECK(nm, lvl, ...) \
-	CHECK(nm, NULL, NULL, NULL, NULL, lvl, __VA_ARGS__)
+#define WARNING(nm, tfn, nfn, pfn, d, ...) \
+	CHECK_ENTRY(nm, tfn, nfn, pfn, d, true, false, __VA_ARGS__)
+#define ERROR(nm, tfn, nfn, pfn, d, ...) \
+	CHECK_ENTRY(nm, tfn, nfn, pfn, d, false, true, __VA_ARGS__)
+#define CHECK(nm, tfn, nfn, pfn, d, ...) \
+	CHECK_ENTRY(nm, tfn, nfn, pfn, d, false, false, __VA_ARGS__)
+
+#define TREE_WARNING(nm, d, ...) \
+	WARNING(nm, check_##nm, NULL, NULL, d, __VA_ARGS__)
+#define TREE_ERROR(nm, d, ...) \
+	ERROR(nm, check_##nm, NULL, NULL, d, __VA_ARGS__)
+#define TREE_CHECK(nm, d, ...) \
+	CHECK(nm, check_##nm, NULL, NULL, d, __VA_ARGS__)
+#define NODE_WARNING(nm, d, ...) \
+	WARNING(nm, NULL, check_##nm, NULL, d,  __VA_ARGS__)
+#define NODE_ERROR(nm, d, ...) \
+	ERROR(nm, NULL, check_##nm, NULL, d, __VA_ARGS__)
+#define NODE_CHECK(nm, d, ...) \
+	CHECK(nm, NULL, check_##nm, NULL, d, __VA_ARGS__)
+#define PROP_WARNING(nm, d, ...) \
+	WARNING(nm, NULL, NULL, check_##nm, d, __VA_ARGS__)
+#define PROP_ERROR(nm, d, ...) \
+	ERROR(nm, NULL, NULL, check_##nm, d, __VA_ARGS__)
+#define PROP_CHECK(nm, d, ...) \
+	CHECK(nm, NULL, NULL, check_##nm, d, __VA_ARGS__)
 
 #ifdef __GNUC__
 static inline void check_msg(struct check *c, const char *fmt, ...) __attribute__((format (printf, 2, 3)));
@@ -95,13 +106,13 @@ static inline void check_msg(struct check *c, const char *fmt, ...)
 	va_list ap;
 	va_start(ap, fmt);
 
-	if ((c->level < WARN) || (c->level <= quiet))
-		return; /* Suppress message */
-
-	fprintf(stderr, "%s (%s): ",
-		(c->level == ERROR) ? "ERROR" : "Warning", c->name);
-	vfprintf(stderr, fmt, ap);
-	fprintf(stderr, "\n");
+	if ((c->warn && (quiet < 1))
+	    || (c->error && (quiet < 2))) {
+		fprintf(stderr, "%s (%s): ",
+			(c->error) ? "ERROR" : "Warning", c->name);
+		vfprintf(stderr, fmt, ap);
+		fprintf(stderr, "\n");
+	}
 }
 
 #define FAIL(c, ...) \
@@ -167,7 +178,7 @@ static int run_check(struct check *c, struct node *dt)
 
 out:
 	c->inprogress = 0;
-	if ((c->status != PASSED) && (c->level == ERROR))
+	if ((c->status != PASSED) && (c->error))
 		error = 1;
 	return error;
 }
@@ -176,6 +187,13 @@ out:
  * Utility check functions
  */
 
+/* A check which always fails, for testing purposes only */
+static inline void check_always_fail(struct check *c, struct node *dt)
+{
+	FAIL(c, "always_fail check");
+}
+TREE_CHECK(always_fail, NULL);
+
 static void check_is_string(struct check *c, struct node *root,
 			    struct node *node)
 {
@@ -190,8 +208,10 @@ static void check_is_string(struct check *c, struct node *root,
 		FAIL(c, "\"%s\" property in %s is not a string",
 		     propname, node->fullpath);
 }
-#define CHECK_IS_STRING(nm, propname, lvl) \
-	CHECK(nm, NULL, check_is_string, NULL, (propname), (lvl))
+#define WARNING_IF_NOT_STRING(nm, propname) \
+	WARNING(nm, NULL, check_is_string, NULL, (propname))
+#define ERROR_IF_NOT_STRING(nm, propname) \
+	ERROR(nm, NULL, check_is_string, NULL, (propname))
 
 static void check_is_cell(struct check *c, struct node *root,
 			  struct node *node)
@@ -207,8 +227,10 @@ static void check_is_cell(struct check *c, struct node *root,
 		FAIL(c, "\"%s\" property in %s is not a single cell",
 		     propname, node->fullpath);
 }
-#define CHECK_IS_CELL(nm, propname, lvl) \
-	CHECK(nm, NULL, check_is_cell, NULL, (propname), (lvl))
+#define WARNING_IF_NOT_CELL(nm, propname) \
+	WARNING(nm, NULL, check_is_cell, NULL, (propname))
+#define ERROR_IF_NOT_CELL(nm, propname) \
+	ERROR(nm, NULL, check_is_cell, NULL, (propname))
 
 /*
  * Structural check functions
@@ -227,20 +249,24 @@ static void check_duplicate_node_names(struct check *c, struct node *dt,
 				FAIL(c, "Duplicate node name %s",
 				     child->fullpath);
 }
-NODE_CHECK(duplicate_node_names, NULL, ERROR);
+NODE_ERROR(duplicate_node_names, NULL);
 
 static void check_duplicate_property_names(struct check *c, struct node *dt,
 					   struct node *node)
 {
 	struct property *prop, *prop2;
 
-	for_each_property(node, prop)
-		for (prop2 = prop->next; prop2; prop2 = prop2->next)
+	for_each_property(node, prop) {
+		for (prop2 = prop->next; prop2; prop2 = prop2->next) {
+			if (prop2->deleted)
+				continue;
 			if (streq(prop->name, prop2->name))
 				FAIL(c, "Duplicate property name %s in %s",
 				     prop->name, node->fullpath);
+		}
+	}
 }
-NODE_CHECK(duplicate_property_names, NULL, ERROR);
+NODE_ERROR(duplicate_property_names, NULL);
 
 #define LOWERCASE	"abcdefghijklmnopqrstuvwxyz"
 #define UPPERCASE	"ABCDEFGHIJKLMNOPQRSTUVWXYZ"
@@ -256,7 +282,7 @@ static void check_node_name_chars(struct check *c, struct node *dt,
 		FAIL(c, "Bad character '%c' in node %s",
 		     node->name[n], node->fullpath);
 }
-NODE_CHECK(node_name_chars, PROPNODECHARS "@", ERROR);
+NODE_ERROR(node_name_chars, PROPNODECHARS "@");
 
 static void check_node_name_format(struct check *c, struct node *dt,
 				   struct node *node)
@@ -265,7 +291,7 @@ static void check_node_name_format(struct check *c, struct node *dt,
 		FAIL(c, "Node %s has multiple '@' characters in name",
 		     node->fullpath);
 }
-NODE_CHECK(node_name_format, NULL, ERROR, &node_name_chars);
+NODE_ERROR(node_name_format, NULL, &node_name_chars);
 
 static void check_property_name_chars(struct check *c, struct node *dt,
 				      struct node *node, struct property *prop)
@@ -276,7 +302,7 @@ static void check_property_name_chars(struct check *c, struct node *dt,
 		FAIL(c, "Bad character '%c' in property name \"%s\", node %s",
 		     prop->name[n], prop->name, node->fullpath);
 }
-PROP_CHECK(property_name_chars, PROPNODECHARS, ERROR);
+PROP_ERROR(property_name_chars, PROPNODECHARS);
 
 #define DESCLABEL_FMT	"%s%s%s%s%s"
 #define DESCLABEL_ARGS(node,prop,mark)		\
@@ -331,8 +357,8 @@ static void check_duplicate_label_prop(struct check *c, struct node *dt,
 	for_each_marker_of_type(m, LABEL)
 		check_duplicate_label(c, dt, m->ref, node, prop, m);
 }
-CHECK(duplicate_label, NULL, check_duplicate_label_node,
-      check_duplicate_label_prop, NULL, ERROR);
+ERROR(duplicate_label, NULL, check_duplicate_label_node,
+      check_duplicate_label_prop, NULL);
 
 static void check_explicit_phandles(struct check *c, struct node *root,
 				    struct node *node, struct property *prop)
@@ -391,7 +417,7 @@ static void check_explicit_phandles(struct check *c, struct node *root,
 
 	node->phandle = phandle;
 }
-PROP_CHECK(explicit_phandles, NULL, ERROR);
+PROP_ERROR(explicit_phandles, NULL);
 
 static void check_name_properties(struct check *c, struct node *root,
 				  struct node *node)
@@ -420,8 +446,8 @@ static void check_name_properties(struct check *c, struct node *root,
 		free(prop);
 	}
 }
-CHECK_IS_STRING(name_is_string, "name", ERROR);
-NODE_CHECK(name_properties, NULL, ERROR, &name_is_string);
+ERROR_IF_NOT_STRING(name_is_string, "name");
+NODE_ERROR(name_properties, NULL, &name_is_string);
 
 /*
  * Reference fixup functions
@@ -448,7 +474,7 @@ static void fixup_phandle_references(struct check *c, struct node *dt,
 		*((cell_t *)(prop->val.val + m->offset)) = cpu_to_fdt32(phandle);
 	}
 }
-CHECK(phandle_references, NULL, NULL, fixup_phandle_references, NULL, ERROR,
+ERROR(phandle_references, NULL, NULL, fixup_phandle_references, NULL,
       &duplicate_node_names, &explicit_phandles);
 
 static void fixup_path_references(struct check *c, struct node *dt,
@@ -473,19 +499,19 @@ static void fixup_path_references(struct check *c, struct node *dt,
 						  strlen(path) + 1);
 	}
 }
-CHECK(path_references, NULL, NULL, fixup_path_references, NULL, ERROR,
+ERROR(path_references, NULL, NULL, fixup_path_references, NULL,
       &duplicate_node_names);
 
 /*
  * Semantic checks
  */
-CHECK_IS_CELL(address_cells_is_cell, "#address-cells", WARN);
-CHECK_IS_CELL(size_cells_is_cell, "#size-cells", WARN);
-CHECK_IS_CELL(interrupt_cells_is_cell, "#interrupt-cells", WARN);
+WARNING_IF_NOT_CELL(address_cells_is_cell, "#address-cells");
+WARNING_IF_NOT_CELL(size_cells_is_cell, "#size-cells");
+WARNING_IF_NOT_CELL(interrupt_cells_is_cell, "#interrupt-cells");
 
-CHECK_IS_STRING(device_type_is_string, "device_type", WARN);
-CHECK_IS_STRING(model_is_string, "model", WARN);
-CHECK_IS_STRING(status_is_string, "status", WARN);
+WARNING_IF_NOT_STRING(device_type_is_string, "device_type");
+WARNING_IF_NOT_STRING(model_is_string, "model");
+WARNING_IF_NOT_STRING(status_is_string, "status");
 
 static void fixup_addr_size_cells(struct check *c, struct node *dt,
 				  struct node *node)
@@ -503,8 +529,8 @@ static void fixup_addr_size_cells(struct check *c, struct node *dt,
 	if (prop)
 		node->size_cells = propval_cell(prop);
 }
-CHECK(addr_size_cells, NULL, fixup_addr_size_cells, NULL, NULL, WARN,
-      &address_cells_is_cell, &size_cells_is_cell);
+WARNING(addr_size_cells, NULL, fixup_addr_size_cells, NULL, NULL,
+	&address_cells_is_cell, &size_cells_is_cell);
 
 #define node_addr_cells(n) \
 	(((n)->addr_cells == -1) ? 2 : (n)->addr_cells)
@@ -538,7 +564,7 @@ static void check_reg_format(struct check *c, struct node *dt,
 		     "(#address-cells == %d, #size-cells == %d)",
 		     node->fullpath, prop->val.len, addr_cells, size_cells);
 }
-NODE_CHECK(reg_format, NULL, WARN, &addr_size_cells);
+NODE_WARNING(reg_format, NULL, &addr_size_cells);
 
 static void check_ranges_format(struct check *c, struct node *dt,
 				struct node *node)
@@ -579,7 +605,7 @@ static void check_ranges_format(struct check *c, struct node *dt,
 		     p_addr_cells, c_addr_cells, c_size_cells);
 	}
 }
-NODE_CHECK(ranges_format, NULL, WARN, &addr_size_cells);
+NODE_WARNING(ranges_format, NULL, &addr_size_cells);
 
 /*
  * Style checks
@@ -606,7 +632,7 @@ static void check_avoid_default_addr_size(struct check *c, struct node *dt,
 		FAIL(c, "Relying on default #size-cells value for %s",
 		     node->fullpath);
 }
-NODE_CHECK(avoid_default_addr_size, NULL, WARN, &addr_size_cells);
+NODE_WARNING(avoid_default_addr_size, NULL, &addr_size_cells);
 
 static void check_obsolete_chosen_interrupt_controller(struct check *c,
 						       struct node *dt)
@@ -623,7 +649,7 @@ static void check_obsolete_chosen_interrupt_controller(struct check *c,
 		FAIL(c, "/chosen has obsolete \"interrupt-controller\" "
 		     "property");
 }
-TREE_CHECK(obsolete_chosen_interrupt_controller, NULL, WARN);
+TREE_WARNING(obsolete_chosen_interrupt_controller, NULL);
 
 static struct check *check_table[] = {
 	&duplicate_node_names, &duplicate_property_names,
@@ -642,8 +668,71 @@ static struct check *check_table[] = {
 
 	&avoid_default_addr_size,
 	&obsolete_chosen_interrupt_controller,
+
+	&always_fail,
 };
 
+static void enable_warning_error(struct check *c, bool warn, bool error)
+{
+	int i;
+
+	/* Raising level, also raise it for prereqs */
+	if ((warn && !c->warn) || (error && !c->error))
+		for (i = 0; i < c->num_prereqs; i++)
+			enable_warning_error(c->prereq[i], warn, error);
+
+	c->warn = c->warn || warn;
+	c->error = c->error || error;
+}
+
+static void disable_warning_error(struct check *c, bool warn, bool error)
+{
+	int i;
+
+	/* Lowering level, also lower it for things this is the prereq
+	 * for */
+	if ((warn && c->warn) || (error && c->error)) {
+		for (i = 0; i < ARRAY_SIZE(check_table); i++) {
+			struct check *cc = check_table[i];
+			int j;
+
+			for (j = 0; j < cc->num_prereqs; j++)
+				if (cc->prereq[j] == c)
+					disable_warning_error(cc, warn, error);
+		}
+	}
+
+	c->warn = c->warn && !warn;
+	c->error = c->error && !error;
+}
+
+void parse_checks_option(bool warn, bool error, const char *optarg)
+{
+	int i;
+	const char *name = optarg;
+	bool enable = true;
+
+	if ((strncmp(optarg, "no-", 3) == 0)
+	    || (strncmp(optarg, "no_", 3) == 0)) {
+		name = optarg + 3;
+		enable = false;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(check_table); i++) {
+		struct check *c = check_table[i];
+
+		if (streq(c->name, name)) {
+			if (enable)
+				enable_warning_error(c, warn, error);
+			else
+				disable_warning_error(c, warn, error);
+			return;
+		}
+	}
+
+	die("Unrecognized check name \"%s\"\n", name);
+}
+
 void process_checks(int force, struct boot_info *bi)
 {
 	struct node *dt = bi->dt;
@@ -653,7 +742,7 @@ void process_checks(int force, struct boot_info *bi)
 	for (i = 0; i < ARRAY_SIZE(check_table); i++) {
 		struct check *c = check_table[i];
 
-		if (c->level != IGNORE)
+		if (c->warn || c->error)
 			error = error || run_check(c, dt);
 	}
 
diff --git a/scripts/dtc/data.c b/scripts/dtc/data.c
index fe555e8..4a40c5b 100644
--- a/scripts/dtc/data.c
+++ b/scripts/dtc/data.c
@@ -68,40 +68,6 @@ struct data data_copy_mem(const char *mem, int len)
 	return d;
 }
 
-static char get_oct_char(const char *s, int *i)
-{
-	char x[4];
-	char *endx;
-	long val;
-
-	x[3] = '\0';
-	strncpy(x, s + *i, 3);
-
-	val = strtol(x, &endx, 8);
-
-	assert(endx > x);
-
-	(*i) += endx - x;
-	return val;
-}
-
-static char get_hex_char(const char *s, int *i)
-{
-	char x[3];
-	char *endx;
-	long val;
-
-	x[2] = '\0';
-	strncpy(x, s + *i, 2);
-
-	val = strtol(x, &endx, 16);
-	if (!(endx  > x))
-		die("\\x used with no following hex digits\n");
-
-	(*i) += endx - x;
-	return val;
-}
-
 struct data data_copy_escape_string(const char *s, int len)
 {
 	int i = 0;
@@ -114,53 +80,10 @@ struct data data_copy_escape_string(const char *s, int len)
 	while (i < len) {
 		char c = s[i++];
 
-		if (c != '\\') {
-			q[d.len++] = c;
-			continue;
-		}
-
-		c = s[i++];
-		assert(c);
-		switch (c) {
-		case 'a':
-			q[d.len++] = '\a';
-			break;
-		case 'b':
-			q[d.len++] = '\b';
-			break;
-		case 't':
-			q[d.len++] = '\t';
-			break;
-		case 'n':
-			q[d.len++] = '\n';
-			break;
-		case 'v':
-			q[d.len++] = '\v';
-			break;
-		case 'f':
-			q[d.len++] = '\f';
-			break;
-		case 'r':
-			q[d.len++] = '\r';
-			break;
-		case '0':
-		case '1':
-		case '2':
-		case '3':
-		case '4':
-		case '5':
-		case '6':
-		case '7':
-			i--; /* need to re-read the first digit as
-			      * part of the octal value */
-			q[d.len++] = get_oct_char(s, &i);
-			break;
-		case 'x':
-			q[d.len++] = get_hex_char(s, &i);
-			break;
-		default:
-			q[d.len++] = c;
-		}
+		if (c == '\\')
+			c = get_escape_char(s, &i);
+
+		q[d.len++] = c;
 	}
 
 	q[d.len++] = '\0';
@@ -245,11 +168,33 @@ struct data data_merge(struct data d1, struct data d2)
 	return d;
 }
 
-struct data data_append_cell(struct data d, cell_t word)
+struct data data_append_integer(struct data d, uint64_t value, int bits)
 {
-	cell_t beword = cpu_to_fdt32(word);
-
-	return data_append_data(d, &beword, sizeof(beword));
+	uint8_t value_8;
+	uint16_t value_16;
+	uint32_t value_32;
+	uint64_t value_64;
+
+	switch (bits) {
+	case 8:
+		value_8 = value;
+		return data_append_data(d, &value_8, 1);
+
+	case 16:
+		value_16 = cpu_to_fdt16(value);
+		return data_append_data(d, &value_16, 2);
+
+	case 32:
+		value_32 = cpu_to_fdt32(value);
+		return data_append_data(d, &value_32, 4);
+
+	case 64:
+		value_64 = cpu_to_fdt64(value);
+		return data_append_data(d, &value_64, 8);
+
+	default:
+		die("Invalid literal size (%d)\n", bits);
+	}
 }
 
 struct data data_append_re(struct data d, const struct fdt_reserve_entry *re)
@@ -262,11 +207,14 @@ struct data data_append_re(struct data d, const struct fdt_reserve_entry *re)
 	return data_append_data(d, &bere, sizeof(bere));
 }
 
-struct data data_append_addr(struct data d, uint64_t addr)
+struct data data_append_cell(struct data d, cell_t word)
 {
-	uint64_t beaddr = cpu_to_fdt64(addr);
+	return data_append_integer(d, word, sizeof(word) * 8);
+}
 
-	return data_append_data(d, &beaddr, sizeof(beaddr));
+struct data data_append_addr(struct data d, uint64_t addr)
+{
+	return data_append_integer(d, addr, sizeof(addr) * 8);
 }
 
 struct data data_append_byte(struct data d, uint8_t byte)
diff --git a/scripts/dtc/dtc-lexer.l b/scripts/dtc/dtc-lexer.l
index e866ea5..254d5af 100644
--- a/scripts/dtc/dtc-lexer.l
+++ b/scripts/dtc/dtc-lexer.l
@@ -29,6 +29,7 @@ PROPNODECHAR	[a-zA-Z0-9,._+*#?@-]
 PATHCHAR	({PROPNODECHAR}|[/])
 LABEL		[a-zA-Z_][a-zA-Z0-9_]*
 STRING		\"([^\\"]|\\.)*\"
+CHAR_LITERAL	'([^']|\\')*'
 WS		[[:space:]]
 COMMENT		"/*"([^*]|\*+[^*/])*\*+"/"
 LINECOMMENT	"//".*\n
@@ -70,6 +71,27 @@ static int pop_input_file(void);
 			push_input_file(name);
 		}
 
+<*>^"#"(line)?{WS}+[0-9]+{WS}+{STRING}({WS}+[0-9]+)? {
+			char *line, *tmp, *fn;
+			/* skip text before line # */
+			line = yytext;
+			while (!isdigit(*line))
+				line++;
+			/* skip digits in line # */
+			tmp = line;
+			while (!isspace(*tmp))
+				tmp++;
+			/* "NULL"-terminate line # */
+			*tmp = '\0';
+			/* start of filename */
+			fn = strchr(tmp + 1, '"') + 1;
+			/* strip trailing " from filename */
+			tmp = strchr(fn, '"');
+			*tmp = 0;
+			/* -1 since #line is the number of the next line */
+			srcpos_set_line(xstrdup(fn), atoi(line) - 1);
+		}
+
 <*><<EOF>>		{
 			if (!pop_input_file()) {
 				yyterminate();
@@ -96,6 +118,26 @@ static int pop_input_file(void);
 			return DT_MEMRESERVE;
 		}
 
+<*>"/bits/"	{
+			DPRINT("Keyword: /bits/\n");
+			BEGIN_DEFAULT();
+			return DT_BITS;
+		}
+
+<*>"/delete-property/"	{
+			DPRINT("Keyword: /delete-property/\n");
+			DPRINT("<PROPNODENAME>\n");
+			BEGIN(PROPNODENAME);
+			return DT_DEL_PROP;
+		}
+
+<*>"/delete-node/"	{
+			DPRINT("Keyword: /delete-node/\n");
+			DPRINT("<PROPNODENAME>\n");
+			BEGIN(PROPNODENAME);
+			return DT_DEL_NODE;
+		}
+
 <*>{LABEL}:	{
 			DPRINT("Label: %s\n", yytext);
 			yylval.labelref = xstrdup(yytext);
@@ -103,12 +145,19 @@ static int pop_input_file(void);
 			return DT_LABEL;
 		}
 
-<V1>[0-9]+|0[xX][0-9a-fA-F]+      {
+<V1>([0-9]+|0[xX][0-9a-fA-F]+)(U|L|UL|LL|ULL)? {
 			yylval.literal = xstrdup(yytext);
 			DPRINT("Literal: '%s'\n", yylval.literal);
 			return DT_LITERAL;
 		}
 
+<*>{CHAR_LITERAL}	{
+			yytext[yyleng-1] = '\0';
+			yylval.literal = xstrdup(yytext+1);
+			DPRINT("Character literal: %s\n", yylval.literal);
+			return DT_CHAR_LITERAL;
+		}
+
 <*>\&{LABEL}	{	/* label reference */
 			DPRINT("Ref: %s\n", yytext+1);
 			yylval.labelref = xstrdup(yytext+1);
@@ -134,9 +183,10 @@ static int pop_input_file(void);
 			return ']';
 		}
 
-<PROPNODENAME>{PROPNODECHAR}+ {
+<PROPNODENAME>\\?{PROPNODECHAR}+ {
 			DPRINT("PropNodeName: %s\n", yytext);
-			yylval.propnodename = xstrdup(yytext);
+			yylval.propnodename = xstrdup((yytext[0] == '\\') ?
+							yytext + 1 : yytext);
 			BEGIN_DEFAULT();
 			return DT_PROPNODENAME;
 		}
@@ -150,6 +200,15 @@ static int pop_input_file(void);
 <*>{COMMENT}+	/* eat C-style comments */
 <*>{LINECOMMENT}+ /* eat C++-style comments */
 
+<*>"<<"		{ return DT_LSHIFT; };
+<*>">>"		{ return DT_RSHIFT; };
+<*>"<="		{ return DT_LE; };
+<*>">="		{ return DT_GE; };
+<*>"=="		{ return DT_EQ; };
+<*>"!="		{ return DT_NE; };
+<*>"&&"		{ return DT_AND; };
+<*>"||"		{ return DT_OR; };
+
 <*>.		{
 			DPRINT("Char: %c (\\x%02x)\n", yytext[0],
 				(unsigned)yytext[0]);
diff --git a/scripts/dtc/dtc-lexer.lex.c_shipped b/scripts/dtc/dtc-lexer.lex.c_shipped
index 8bbe128..a6c5fcd 100644
--- a/scripts/dtc/dtc-lexer.lex.c_shipped
+++ b/scripts/dtc/dtc-lexer.lex.c_shipped
@@ -1,5 +1,6 @@
+#line 2 "dtc-lexer.lex.c"
 
-#line 3 "scripts/dtc/dtc-lexer.lex.c_shipped"
+#line 4 "dtc-lexer.lex.c"
 
 #define  YY_INT_ALIGNED short int
 
@@ -53,7 +54,6 @@ typedef int flex_int32_t;
 typedef unsigned char flex_uint8_t; 
 typedef unsigned short int flex_uint16_t;
 typedef unsigned int flex_uint32_t;
-#endif /* ! C99 */
 
 /* Limits of integral types. */
 #ifndef INT8_MIN
@@ -84,6 +84,8 @@ typedef unsigned int flex_uint32_t;
 #define UINT32_MAX             (4294967295U)
 #endif
 
+#endif /* ! C99 */
+
 #endif /* ! FLEXINT_H */
 
 #ifdef __cplusplus
@@ -140,7 +142,15 @@ typedef unsigned int flex_uint32_t;
 
 /* Size of default input buffer. */
 #ifndef YY_BUF_SIZE
+#ifdef __ia64__
+/* On IA-64, the buffer size is 16k, not 8k.
+ * Moreover, YY_BUF_SIZE is 2*YY_READ_BUF_SIZE in the general case.
+ * Ditto for the __ia64__ case accordingly.
+ */
+#define YY_BUF_SIZE 32768
+#else
 #define YY_BUF_SIZE 16384
+#endif /* __ia64__ */
 #endif
 
 /* The state buf must be large enough to hold one state per character in the main buffer.
@@ -362,8 +372,8 @@ static void yy_fatal_error (yyconst char msg[]  );
 	*yy_cp = '\0'; \
 	(yy_c_buf_p) = yy_cp;
 
-#define YY_NUM_RULES 17
-#define YY_END_OF_BUFFER 18
+#define YY_NUM_RULES 30
+#define YY_END_OF_BUFFER 31
 /* This struct is not used in this scanner,
    but its presence is necessary. */
 struct yy_trans_info
@@ -371,19 +381,25 @@ struct yy_trans_info
 	flex_int32_t yy_verify;
 	flex_int32_t yy_nxt;
 	};
-static yyconst flex_int16_t yy_accept[94] =
+static yyconst flex_int16_t yy_accept[161] =
     {   0,
         0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
-       18,   16,   13,   13,   16,   16,   16,   16,   16,   16,
-       16,   10,   11,   11,    6,    6,   13,    0,    2,    0,
-        7,    0,    0,    0,    0,    0,    0,    0,    5,    0,
-        9,    9,   11,   11,    6,    0,    7,    0,    0,    0,
-        0,   15,    0,    0,    0,    0,    6,    0,   14,    0,
-        0,    0,    0,    0,    8,    0,    0,    0,    0,    0,
-        0,    0,    0,    0,    0,    0,    0,    0,    3,   12,
-        0,    0,    0,    0,    0,    0,    0,    0,    1,    0,
-        0,    4,    0
-
+       31,   29,   18,   18,   29,   29,   29,   29,   29,   29,
+       29,   29,   29,   29,   29,   29,   29,   29,   15,   16,
+       16,   29,   16,   10,   10,   18,   26,    0,    3,    0,
+       27,   12,    0,    0,   11,    0,    0,    0,    0,    0,
+        0,    0,   21,   23,   25,   24,   22,    0,    9,   28,
+        0,    0,    0,   14,   14,   16,   16,   16,   10,   10,
+       10,    0,   12,    0,   11,    0,    0,    0,   20,    0,
+        0,    0,    0,    0,    0,    0,    0,   16,   10,   10,
+       10,    0,   19,    0,    0,    0,    0,    0,    0,    0,
+
+        0,    0,   16,   13,    0,    0,    0,    0,    0,    0,
+        0,    0,    0,   16,    6,    0,    0,    0,    0,    0,
+        0,    2,    0,    0,    0,    0,    0,    0,    0,    0,
+        4,   17,    0,    0,    2,    0,    0,    0,    0,    0,
+        0,    0,    0,    0,    0,    0,    0,    1,    0,    0,
+        0,    0,    5,    8,    0,    0,    0,    0,    7,    0
     } ;
 
 static yyconst flex_int32_t yy_ec[256] =
@@ -391,17 +407,17 @@ static yyconst flex_int32_t yy_ec[256] =
         1,    1,    1,    1,    1,    1,    1,    1,    2,    3,
         2,    2,    2,    1,    1,    1,    1,    1,    1,    1,
         1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
-        1,    2,    1,    4,    5,    1,    1,    6,    1,    1,
-        1,    7,    5,    5,    8,    5,    9,   10,   11,   12,
-       12,   12,   12,   12,   12,   12,   12,   13,    1,    1,
-        1,    1,    5,    5,   14,   14,   14,   14,   14,   14,
-       15,   15,   15,   15,   15,   15,   15,   15,   15,   15,
-       15,   15,   15,   15,   15,   15,   15,   16,   15,   15,
-        1,   17,   18,    1,   15,    1,   14,   19,   20,   21,
-
-       22,   14,   15,   15,   23,   15,   15,   24,   25,   26,
-       15,   15,   15,   27,   28,   29,   30,   31,   15,   16,
-       15,   15,   32,    1,   33,    1,    1,    1,    1,    1,
+        1,    2,    4,    5,    6,    1,    1,    7,    8,    1,
+        1,    9,   10,   10,   11,   10,   12,   13,   14,   15,
+       15,   15,   15,   15,   15,   15,   15,   16,    1,   17,
+       18,   19,   10,   10,   20,   20,   20,   20,   20,   20,
+       21,   21,   21,   21,   21,   22,   21,   21,   21,   21,
+       21,   21,   21,   21,   23,   21,   21,   24,   21,   21,
+        1,   25,   26,    1,   21,    1,   20,   27,   28,   29,
+
+       30,   20,   21,   21,   31,   21,   21,   32,   33,   34,
+       35,   36,   21,   37,   38,   39,   40,   41,   21,   24,
+       42,   21,   43,   44,   45,    1,    1,    1,    1,    1,
         1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
         1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
         1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
@@ -418,112 +434,163 @@ static yyconst flex_int32_t yy_ec[256] =
         1,    1,    1,    1,    1
     } ;
 
-static yyconst flex_int32_t yy_meta[34] =
+static yyconst flex_int32_t yy_meta[46] =
     {   0,
-        1,    1,    1,    1,    2,    1,    2,    2,    3,    4,
-        4,    4,    5,    6,    7,    7,    1,    1,    6,    6,
-        6,    6,    7,    7,    7,    7,    7,    7,    7,    7,
-        7,    8,    1
+        1,    1,    1,    1,    1,    2,    3,    1,    2,    2,
+        2,    4,    5,    5,    5,    6,    1,    1,    1,    7,
+        8,    8,    8,    8,    1,    1,    7,    7,    7,    7,
+        8,    8,    8,    8,    8,    8,    8,    8,    8,    8,
+        8,    8,    3,    1,    1
     } ;
 
-static yyconst flex_int16_t yy_base[106] =
+static yyconst flex_int16_t yy_base[175] =
     {   0,
-        0,    0,  237,  236,   25,    0,   47,    0,   30,   71,
-      244,  247,   82,   84,   84,  211,   95,  229,  218,    0,
-      111,  247,    0,   84,   83,   95,  106,   86,  247,  237,
-        0,  230,  231,  234,  207,  209,  212,  220,  247,  206,
-      247,  218,    0,  106,  116,    0,    0,    0,  223,   89,
-      226,  219,  199,  206,  200,  204,    0,  190,  213,  212,
-      202,   91,  178,  161,  247,  172,  144,  150,  140,  130,
-      140,  124,  128,  120,  138,  137,  123,  122,  247,  247,
-      134,  114,  132,   86,  135,  125,   90,  136,  247,   97,
-       29,  247,  247,  153,  156,  161,  165,  170,  176,  180,
-
-      187,  195,  200,  205,  212
+        0,  388,  381,   40,   41,  386,   71,  385,   34,   44,
+      390,  395,   60,   62,  371,  112,  111,  111,  111,  104,
+      370,  106,  371,  342,  124,  119,    0,  144,  395,    0,
+      123,    0,  159,  153,  165,  167,  395,  130,  395,  382,
+      395,    0,  372,  122,  395,  157,  374,  379,  350,   21,
+      346,  349,  395,  395,  395,  395,  395,  362,  395,  395,
+      181,  346,  342,  395,  359,    0,  191,  343,  190,  351,
+      350,    0,    0,    0,  173,  362,  177,  367,  357,  329,
+      335,  328,  337,  331,  206,  329,  334,  327,  395,  338,
+      170,  314,  346,  345,  318,  325,  343,  158,  316,  212,
+
+      322,  319,  320,  395,  340,  336,  308,  305,  314,  304,
+      295,  138,  208,  220,  395,  292,  305,  265,  264,  254,
+      201,  222,  285,  275,  273,  270,  236,  235,  225,  115,
+      395,  395,  252,  216,  216,  217,  214,  230,  209,  220,
+      213,  239,  211,  217,  216,  209,  229,  395,  240,  225,
+      206,  169,  395,  395,  116,  106,   99,   54,  395,  395,
+      254,  260,  268,  272,  276,  282,  289,  293,  301,  309,
+      313,  319,  327,  335
     } ;
 
-static yyconst flex_int16_t yy_def[106] =
+static yyconst flex_int16_t yy_def[175] =
     {   0,
-       93,    1,    1,    1,    1,    5,   93,    7,    1,    1,
-       93,   93,   93,   93,   94,   95,   93,   96,   17,   97,
-       96,   93,   98,   99,   93,   93,   93,   94,   93,   94,
-      100,   93,  101,  102,   93,   93,   93,   96,   93,   93,
-       93,   96,   98,   99,   93,  103,  100,  104,  101,  101,
-      102,   93,   93,   93,   93,   93,  103,  104,   93,   93,
-       93,   93,   93,   93,   93,   93,   93,   93,   93,   93,
-       93,   93,   93,   93,   93,   93,   93,   93,   93,   93,
-       93,   93,   93,   93,   93,  105,   93,  105,   93,  105,
-       93,   93,    0,   93,   93,   93,   93,   93,   93,   93,
-
-       93,   93,   93,   93,   93
+      160,    1,    1,    1,    1,    5,  160,    7,    1,    1,
+      160,  160,  160,  160,  160,  161,  162,  163,  160,  160,
+      160,  160,  164,  160,  160,  160,  165,  164,  160,  166,
+      167,  166,  166,  160,  160,  160,  160,  161,  160,  161,
+      160,  168,  160,  163,  160,  163,  169,  170,  160,  160,
+      160,  160,  160,  160,  160,  160,  160,  164,  160,  160,
+      160,  160,  160,  160,  164,  166,  167,  166,  160,  160,
+      160,  171,  168,  172,  163,  169,  169,  170,  160,  160,
+      160,  160,  160,  160,  160,  160,  160,  166,  160,  160,
+      171,  172,  160,  160,  160,  160,  160,  160,  160,  160,
+
+      160,  160,  166,  160,  160,  160,  160,  160,  160,  160,
+      160,  173,  160,  166,  160,  160,  160,  160,  160,  160,
+      173,  160,  173,  160,  160,  160,  160,  160,  160,  160,
+      160,  160,  160,  160,  160,  160,  160,  160,  160,  160,
+      160,  160,  174,  160,  160,  160,  174,  160,  174,  160,
+      160,  160,  160,  160,  160,  160,  160,  160,  160,    0,
+      160,  160,  160,  160,  160,  160,  160,  160,  160,  160,
+      160,  160,  160,  160
     } ;
 
-static yyconst flex_int16_t yy_nxt[281] =
+static yyconst flex_int16_t yy_nxt[441] =
     {   0,
-       12,   13,   14,   15,   12,   16,   12,   12,   17,   12,
-       12,   12,   12,   18,   18,   18,   12,   12,   18,   18,
-       18,   18,   18,   18,   18,   18,   18,   18,   18,   18,
-       18,   12,   12,   19,   20,   20,   20,   92,   21,   25,
-       26,   26,   22,   21,   21,   21,   21,   12,   13,   14,
-       15,   23,   16,   23,   23,   19,   23,   23,   23,   12,
-       24,   24,   24,   12,   12,   24,   24,   24,   24,   24,
-       24,   24,   24,   24,   24,   24,   24,   24,   12,   12,
-       25,   26,   26,   27,   27,   27,   27,   29,   43,   29,
-       43,   43,   45,   45,   45,   50,   39,   59,   46,   93,
-
-       30,   33,   30,   34,   45,   45,   45,   27,   27,   68,
-       43,   91,   43,   43,   69,   35,   87,   36,   39,   37,
-       42,   42,   42,   39,   42,   45,   45,   45,   89,   42,
-       42,   42,   42,   85,   85,   86,   85,   85,   86,   89,
-       84,   90,   83,   82,   81,   80,   79,   78,   77,   76,
-       75,   74,   90,   28,   28,   28,   28,   28,   28,   28,
-       28,   31,   31,   31,   38,   38,   38,   38,   41,   73,
-       41,   43,   72,   43,   71,   43,   43,   44,   33,   44,
-       44,   44,   44,   47,   69,   47,   47,   49,   49,   49,
-       49,   49,   49,   49,   49,   51,   51,   51,   51,   51,
-
-       51,   51,   51,   57,   70,   57,   58,   58,   58,   67,
-       58,   58,   88,   88,   88,   88,   88,   88,   88,   88,
-       34,   66,   65,   64,   63,   62,   61,   60,   52,   50,
-       39,   56,   39,   55,   54,   53,   52,   50,   48,   93,
-       40,   39,   32,   93,   19,   19,   11,   93,   93,   93,
-       93,   93,   93,   93,   93,   93,   93,   93,   93,   93,
-       93,   93,   93,   93,   93,   93,   93,   93,   93,   93,
-       93,   93,   93,   93,   93,   93,   93,   93,   93,   93
+       12,   13,   14,   15,   16,   12,   17,   18,   12,   12,
+       12,   19,   12,   12,   12,   12,   20,   21,   22,   23,
+       23,   23,   23,   23,   12,   12,   23,   23,   23,   23,
+       23,   23,   23,   23,   23,   23,   23,   23,   23,   23,
+       23,   23,   12,   24,   12,   25,   34,   35,   35,   25,
+       81,   26,   26,   27,   27,   27,   34,   35,   35,   82,
+       28,   36,   36,   36,   36,  159,   29,   28,   28,   28,
+       28,   12,   13,   14,   15,   16,   30,   17,   18,   30,
+       30,   30,   26,   30,   30,   30,   12,   20,   21,   22,
+       31,   31,   31,   31,   31,   32,   12,   31,   31,   31,
+
+       31,   31,   31,   31,   31,   31,   31,   31,   31,   31,
+       31,   31,   31,   12,   24,   12,   39,   41,   45,   47,
+       53,   54,   48,   56,   57,   61,   61,   47,   66,   45,
+       48,   66,   66,   66,   39,   46,   40,   49,   59,   50,
+      158,   51,  122,   52,  157,   49,   46,   50,  136,   63,
+      137,   52,  156,   43,   40,   62,   65,   65,   65,   59,
+       61,   61,  123,   65,   75,   69,   69,   69,   36,   36,
+       65,   65,   65,   65,   70,   71,   72,   69,   69,   69,
+       45,   46,   61,   61,  109,   77,   70,   71,   93,  110,
+       68,   70,   71,   85,   85,   85,   66,   46,  155,   66,
+
+       66,   66,   69,   69,   69,  122,   59,  100,  100,   61,
+       61,   70,   71,  100,  100,  148,  112,  154,   85,   85,
+       85,   61,   61,  129,  129,  123,  129,  129,  135,  135,
+      135,  142,  142,  148,  143,  149,  153,  135,  135,  135,
+      142,  142,  160,  143,  152,  151,  150,  146,  145,  144,
+      141,  140,  139,  149,   38,   38,   38,   38,   38,   38,
+       38,   38,   42,  138,  134,  133,   42,   42,   44,   44,
+       44,   44,   44,   44,   44,   44,   58,   58,   58,   58,
+       64,  132,   64,   66,  131,  130,   66,  160,   66,   66,
+       67,  128,  127,   67,   67,   67,   67,   73,  126,   73,
+
+       73,   76,   76,   76,   76,   76,   76,   76,   76,   78,
+       78,   78,   78,   78,   78,   78,   78,   91,  125,   91,
+       92,  124,   92,   92,  120,   92,   92,  121,  121,  121,
+      121,  121,  121,  121,  121,  147,  147,  147,  147,  147,
+      147,  147,  147,  119,  118,  117,  116,  115,   47,  114,
+      110,  113,  111,  108,  107,  106,   48,  105,  104,   89,
+      103,  102,  101,   99,   98,   97,   96,   95,   94,   79,
+       77,   90,   89,   88,   59,   87,   86,   59,   84,   83,
+       80,   79,   77,   74,  160,   60,   59,   55,   37,  160,
+       33,   25,   26,   25,   11,  160,  160,  160,  160,  160,
+
+      160,  160,  160,  160,  160,  160,  160,  160,  160,  160,
+      160,  160,  160,  160,  160,  160,  160,  160,  160,  160,
+      160,  160,  160,  160,  160,  160,  160,  160,  160,  160,
+      160,  160,  160,  160,  160,  160,  160,  160,  160,  160
     } ;
 
-static yyconst flex_int16_t yy_chk[281] =
+static yyconst flex_int16_t yy_chk[441] =
     {   0,
         1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
         1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
         1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
-        1,    1,    1,    5,    5,    5,    5,   91,    5,    9,
-        9,    9,    5,    5,    5,    5,    5,    7,    7,    7,
+        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
+        1,    1,    1,    1,    1,    4,    9,    9,    9,   10,
+       50,    4,    5,    5,    5,    5,   10,   10,   10,   50,
+        5,   13,   13,   14,   14,  158,    5,    5,    5,    5,
+        5,    7,    7,    7,    7,    7,    7,    7,    7,    7,
         7,    7,    7,    7,    7,    7,    7,    7,    7,    7,
         7,    7,    7,    7,    7,    7,    7,    7,    7,    7,
+
         7,    7,    7,    7,    7,    7,    7,    7,    7,    7,
-       10,   10,   10,   13,   13,   14,   14,   15,   24,   28,
-       24,   24,   25,   25,   25,   50,   24,   50,   25,   90,
-
-       15,   17,   28,   17,   26,   26,   26,   27,   27,   62,
-       44,   87,   44,   44,   62,   17,   84,   17,   44,   17,
-       21,   21,   21,   21,   21,   45,   45,   45,   86,   21,
-       21,   21,   21,   83,   83,   83,   85,   85,   85,   88,
-       82,   86,   81,   78,   77,   76,   75,   74,   73,   72,
-       71,   70,   88,   94,   94,   94,   94,   94,   94,   94,
-       94,   95,   95,   95,   96,   96,   96,   96,   97,   69,
-       97,   98,   68,   98,   67,   98,   98,   99,   66,   99,
-       99,   99,   99,  100,   64,  100,  100,  101,  101,  101,
-      101,  101,  101,  101,  101,  102,  102,  102,  102,  102,
-
-      102,  102,  102,  103,   63,  103,  104,  104,  104,   61,
-      104,  104,  105,  105,  105,  105,  105,  105,  105,  105,
-       60,   59,   58,   56,   55,   54,   53,   52,   51,   49,
-       42,   40,   38,   37,   36,   35,   34,   33,   32,   30,
-       19,   18,   16,   11,    4,    3,   93,   93,   93,   93,
-       93,   93,   93,   93,   93,   93,   93,   93,   93,   93,
-       93,   93,   93,   93,   93,   93,   93,   93,   93,   93,
-       93,   93,   93,   93,   93,   93,   93,   93,   93,   93
+        7,    7,    7,    7,    7,    7,   16,   17,   18,   19,
+       20,   20,   19,   22,   22,   25,   25,   26,   31,   44,
+       26,   31,   31,   31,   38,   18,   16,   19,   31,   19,
+      157,   19,  112,   19,  156,   26,   44,   26,  130,   26,
+      130,   26,  155,   17,   38,   25,   28,   28,   28,   28,
+       33,   33,  112,   28,   46,   34,   34,   34,   36,   36,
+       28,   28,   28,   28,   34,   34,   34,   35,   35,   35,
+       75,   46,   61,   61,   98,   77,   35,   35,   77,   98,
+       33,   91,   91,   61,   61,   61,   67,   75,  152,   67,
+
+       67,   67,   69,   69,   69,  121,   67,   85,   85,  113,
+      113,   69,   69,  100,  100,  143,  100,  151,   85,   85,
+       85,  114,  114,  122,  122,  121,  129,  129,  135,  135,
+      135,  138,  138,  147,  138,  143,  150,  129,  129,  129,
+      142,  142,  149,  142,  146,  145,  144,  141,  140,  139,
+      137,  136,  134,  147,  161,  161,  161,  161,  161,  161,
+      161,  161,  162,  133,  128,  127,  162,  162,  163,  163,
+      163,  163,  163,  163,  163,  163,  164,  164,  164,  164,
+      165,  126,  165,  166,  125,  124,  166,  123,  166,  166,
+      167,  120,  119,  167,  167,  167,  167,  168,  118,  168,
+
+      168,  169,  169,  169,  169,  169,  169,  169,  169,  170,
+      170,  170,  170,  170,  170,  170,  170,  171,  117,  171,
+      172,  116,  172,  172,  111,  172,  172,  173,  173,  173,
+      173,  173,  173,  173,  173,  174,  174,  174,  174,  174,
+      174,  174,  174,  110,  109,  108,  107,  106,  105,  103,
+      102,  101,   99,   97,   96,   95,   94,   93,   92,   90,
+       88,   87,   86,   84,   83,   82,   81,   80,   79,   78,
+       76,   71,   70,   68,   65,   63,   62,   58,   52,   51,
+       49,   48,   47,   43,   40,   24,   23,   21,   15,   11,
+        8,    6,    3,    2,  160,  160,  160,  160,  160,  160,
+
+      160,  160,  160,  160,  160,  160,  160,  160,  160,  160,
+      160,  160,  160,  160,  160,  160,  160,  160,  160,  160,
+      160,  160,  160,  160,  160,  160,  160,  160,  160,  160,
+      160,  160,  160,  160,  160,  160,  160,  160,  160,  160
     } ;
 
 static yy_state_type yy_last_accepting_state;
@@ -540,6 +607,7 @@ int yy_flex_debug = 0;
 #define YY_MORE_ADJ 0
 #define YY_RESTORE_YY_MORE_OFFSET
 char *yytext;
+#line 1 "dtc-lexer.l"
 /*
  * (C) Copyright David Gibson <dwg@au1.ibm.com>, IBM Corporation.  2005.
  *
@@ -561,6 +629,10 @@ char *yytext;
  */
 #define YY_NO_INPUT 1
 
+
+
+
+#line 38 "dtc-lexer.l"
 #include "dtc.h"
 #include "srcpos.h"
 #include "dtc-parser.tab.h"
@@ -588,6 +660,7 @@ static int dts_version = 1;
 
 static void push_input_file(const char *filename);
 static int pop_input_file(void);
+#line 664 "dtc-lexer.lex.c"
 
 #define INITIAL 0
 #define INCLUDE 1
@@ -670,7 +743,12 @@ static int input (void );
 
 /* Amount of stuff to slurp up with each read. */
 #ifndef YY_READ_BUF_SIZE
+#ifdef __ia64__
+/* On IA-64, the buffer size is 16k, not 8k */
+#define YY_READ_BUF_SIZE 16384
+#else
 #define YY_READ_BUF_SIZE 8192
+#endif /* __ia64__ */
 #endif
 
 /* Copy whatever the last rule matched to the standard output. */
@@ -689,7 +767,7 @@ static int input (void );
 	if ( YY_CURRENT_BUFFER_LVALUE->yy_is_interactive ) \
 		{ \
 		int c = '*'; \
-		unsigned n; \
+		size_t n; \
 		for ( n = 0; n < max_size && \
 			     (c = getc( yyin )) != EOF && c != '\n'; ++n ) \
 			buf[n] = (char) c; \
@@ -761,6 +839,9 @@ extern int yylex (void);
 #endif
 
 #define YY_RULE_SETUP \
+	if ( yyleng > 0 ) \
+		YY_CURRENT_BUFFER_LVALUE->yy_at_bol = \
+				(yytext[yyleng - 1] == '\n'); \
 	YY_USER_ACTION
 
 /** The main scanner function which does all the work.
@@ -771,6 +852,10 @@ YY_DECL
 	register char *yy_cp, *yy_bp;
 	register int yy_act;
     
+#line 67 "dtc-lexer.l"
+
+#line 858 "dtc-lexer.lex.c"
+
 	if ( !(yy_init) )
 		{
 		(yy_init) = 1;
@@ -810,6 +895,7 @@ YY_DECL
 		yy_bp = yy_cp;
 
 		yy_current_state = (yy_start);
+		yy_current_state += YY_AT_BOL();
 yy_match:
 		do
 			{
@@ -822,13 +908,13 @@ yy_match:
 			while ( yy_chk[yy_base[yy_current_state] + yy_c] != yy_current_state )
 				{
 				yy_current_state = (int) yy_def[yy_current_state];
-				if ( yy_current_state >= 94 )
+				if ( yy_current_state >= 161 )
 					yy_c = yy_meta[(unsigned int) yy_c];
 				}
 			yy_current_state = yy_nxt[yy_base[yy_current_state] + (unsigned int) yy_c];
 			++yy_cp;
 			}
-		while ( yy_current_state != 93 );
+		while ( yy_current_state != 160 );
 		yy_cp = (yy_last_accepting_cpos);
 		yy_current_state = (yy_last_accepting_state);
 
@@ -851,26 +937,54 @@ do_action:	/* This label is used only to access EOF actions. */
 case 1:
 /* rule 1 can match eol */
 YY_RULE_SETUP
+#line 68 "dtc-lexer.l"
 {
 			char *name = strchr(yytext, '\"') + 1;
 			yytext[yyleng-1] = '\0';
 			push_input_file(name);
 		}
 	YY_BREAK
+case 2:
+/* rule 2 can match eol */
+YY_RULE_SETUP
+#line 74 "dtc-lexer.l"
+{
+			char *line, *tmp, *fn;
+			/* skip text before line # */
+			line = yytext;
+			while (!isdigit(*line))
+				line++;
+			/* skip digits in line # */
+			tmp = line;
+			while (!isspace(*tmp))
+				tmp++;
+			/* "NULL"-terminate line # */
+			*tmp = '\0';
+			/* start of filename */
+			fn = strchr(tmp + 1, '"') + 1;
+			/* strip trailing " from filename */
+			tmp = strchr(fn, '"');
+			*tmp = 0;
+			/* -1 since #line is the number of the next line */
+			srcpos_set_line(xstrdup(fn), atoi(line) - 1);
+		}
+	YY_BREAK
 case YY_STATE_EOF(INITIAL):
 case YY_STATE_EOF(INCLUDE):
 case YY_STATE_EOF(BYTESTRING):
 case YY_STATE_EOF(PROPNODENAME):
 case YY_STATE_EOF(V1):
+#line 95 "dtc-lexer.l"
 {
 			if (!pop_input_file()) {
 				yyterminate();
 			}
 		}
 	YY_BREAK
-case 2:
-/* rule 2 can match eol */
+case 3:
+/* rule 3 can match eol */
 YY_RULE_SETUP
+#line 101 "dtc-lexer.l"
 {
 			DPRINT("String: %s\n", yytext);
 			yylval.data = data_copy_escape_string(yytext+1,
@@ -878,8 +992,9 @@ YY_RULE_SETUP
 			return DT_STRING;
 		}
 	YY_BREAK
-case 3:
+case 4:
 YY_RULE_SETUP
+#line 108 "dtc-lexer.l"
 {
 			DPRINT("Keyword: /dts-v1/\n");
 			dts_version = 1;
@@ -887,16 +1002,47 @@ YY_RULE_SETUP
 			return DT_V1;
 		}
 	YY_BREAK
-case 4:
+case 5:
 YY_RULE_SETUP
+#line 115 "dtc-lexer.l"
 {
 			DPRINT("Keyword: /memreserve/\n");
 			BEGIN_DEFAULT();
 			return DT_MEMRESERVE;
 		}
 	YY_BREAK
-case 5:
+case 6:
+YY_RULE_SETUP
+#line 121 "dtc-lexer.l"
+{
+			DPRINT("Keyword: /bits/\n");
+			BEGIN_DEFAULT();
+			return DT_BITS;
+		}
+	YY_BREAK
+case 7:
 YY_RULE_SETUP
+#line 127 "dtc-lexer.l"
+{
+			DPRINT("Keyword: /delete-property/\n");
+			DPRINT("<PROPNODENAME>\n");
+			BEGIN(PROPNODENAME);
+			return DT_DEL_PROP;
+		}
+	YY_BREAK
+case 8:
+YY_RULE_SETUP
+#line 134 "dtc-lexer.l"
+{
+			DPRINT("Keyword: /delete-node/\n");
+			DPRINT("<PROPNODENAME>\n");
+			BEGIN(PROPNODENAME);
+			return DT_DEL_NODE;
+		}
+	YY_BREAK
+case 9:
+YY_RULE_SETUP
+#line 141 "dtc-lexer.l"
 {
 			DPRINT("Label: %s\n", yytext);
 			yylval.labelref = xstrdup(yytext);
@@ -904,24 +1050,38 @@ YY_RULE_SETUP
 			return DT_LABEL;
 		}
 	YY_BREAK
-case 6:
+case 10:
 YY_RULE_SETUP
+#line 148 "dtc-lexer.l"
 {
 			yylval.literal = xstrdup(yytext);
 			DPRINT("Literal: '%s'\n", yylval.literal);
 			return DT_LITERAL;
 		}
 	YY_BREAK
-case 7:
+case 11:
+/* rule 11 can match eol */
+YY_RULE_SETUP
+#line 154 "dtc-lexer.l"
+{
+			yytext[yyleng-1] = '\0';
+			yylval.literal = xstrdup(yytext+1);
+			DPRINT("Character literal: %s\n", yylval.literal);
+			return DT_CHAR_LITERAL;
+		}
+	YY_BREAK
+case 12:
 YY_RULE_SETUP
+#line 161 "dtc-lexer.l"
 {	/* label reference */
 			DPRINT("Ref: %s\n", yytext+1);
 			yylval.labelref = xstrdup(yytext+1);
 			return DT_REF;
 		}
 	YY_BREAK
-case 8:
+case 13:
 YY_RULE_SETUP
+#line 167 "dtc-lexer.l"
 {	/* new-style path reference */
 			yytext[yyleng-1] = '\0';
 			DPRINT("Ref: %s\n", yytext+2);
@@ -929,55 +1089,104 @@ YY_RULE_SETUP
 			return DT_REF;
 		}
 	YY_BREAK
-case 9:
+case 14:
 YY_RULE_SETUP
+#line 174 "dtc-lexer.l"
 {
 			yylval.byte = strtol(yytext, NULL, 16);
 			DPRINT("Byte: %02x\n", (int)yylval.byte);
 			return DT_BYTE;
 		}
 	YY_BREAK
-case 10:
+case 15:
 YY_RULE_SETUP
+#line 180 "dtc-lexer.l"
 {
 			DPRINT("/BYTESTRING\n");
 			BEGIN_DEFAULT();
 			return ']';
 		}
 	YY_BREAK
-case 11:
+case 16:
 YY_RULE_SETUP
+#line 186 "dtc-lexer.l"
 {
 			DPRINT("PropNodeName: %s\n", yytext);
-			yylval.propnodename = xstrdup(yytext);
+			yylval.propnodename = xstrdup((yytext[0] == '\\') ?
+							yytext + 1 : yytext);
 			BEGIN_DEFAULT();
 			return DT_PROPNODENAME;
 		}
 	YY_BREAK
-case 12:
+case 17:
 YY_RULE_SETUP
+#line 194 "dtc-lexer.l"
 {
 			DPRINT("Binary Include\n");
 			return DT_INCBIN;
 		}
 	YY_BREAK
-case 13:
-/* rule 13 can match eol */
+case 18:
+/* rule 18 can match eol */
 YY_RULE_SETUP
+#line 199 "dtc-lexer.l"
 /* eat whitespace */
 	YY_BREAK
-case 14:
-/* rule 14 can match eol */
+case 19:
+/* rule 19 can match eol */
 YY_RULE_SETUP
+#line 200 "dtc-lexer.l"
 /* eat C-style comments */
 	YY_BREAK
-case 15:
-/* rule 15 can match eol */
+case 20:
+/* rule 20 can match eol */
 YY_RULE_SETUP
+#line 201 "dtc-lexer.l"
 /* eat C++-style comments */
 	YY_BREAK
-case 16:
+case 21:
 YY_RULE_SETUP
+#line 203 "dtc-lexer.l"
+{ return DT_LSHIFT; };
+	YY_BREAK
+case 22:
+YY_RULE_SETUP
+#line 204 "dtc-lexer.l"
+{ return DT_RSHIFT; };
+	YY_BREAK
+case 23:
+YY_RULE_SETUP
+#line 205 "dtc-lexer.l"
+{ return DT_LE; };
+	YY_BREAK
+case 24:
+YY_RULE_SETUP
+#line 206 "dtc-lexer.l"
+{ return DT_GE; };
+	YY_BREAK
+case 25:
+YY_RULE_SETUP
+#line 207 "dtc-lexer.l"
+{ return DT_EQ; };
+	YY_BREAK
+case 26:
+YY_RULE_SETUP
+#line 208 "dtc-lexer.l"
+{ return DT_NE; };
+	YY_BREAK
+case 27:
+YY_RULE_SETUP
+#line 209 "dtc-lexer.l"
+{ return DT_AND; };
+	YY_BREAK
+case 28:
+YY_RULE_SETUP
+#line 210 "dtc-lexer.l"
+{ return DT_OR; };
+	YY_BREAK
+case 29:
+YY_RULE_SETUP
+#line 212 "dtc-lexer.l"
 {
 			DPRINT("Char: %c (\\x%02x)\n", yytext[0],
 				(unsigned)yytext[0]);
@@ -993,10 +1202,12 @@ YY_RULE_SETUP
 			return yytext[0];
 		}
 	YY_BREAK
-case 17:
+case 30:
 YY_RULE_SETUP
+#line 227 "dtc-lexer.l"
 ECHO;
 	YY_BREAK
+#line 1211 "dtc-lexer.lex.c"
 
 	case YY_END_OF_BUFFER:
 		{
@@ -1275,6 +1486,7 @@ static int yy_get_next_buffer (void)
 	register char *yy_cp;
     
 	yy_current_state = (yy_start);
+	yy_current_state += YY_AT_BOL();
 
 	for ( yy_cp = (yytext_ptr) + YY_MORE_ADJ; yy_cp < (yy_c_buf_p); ++yy_cp )
 		{
@@ -1287,7 +1499,7 @@ static int yy_get_next_buffer (void)
 		while ( yy_chk[yy_base[yy_current_state] + yy_c] != yy_current_state )
 			{
 			yy_current_state = (int) yy_def[yy_current_state];
-			if ( yy_current_state >= 94 )
+			if ( yy_current_state >= 161 )
 				yy_c = yy_meta[(unsigned int) yy_c];
 			}
 		yy_current_state = yy_nxt[yy_base[yy_current_state] + (unsigned int) yy_c];
@@ -1315,11 +1527,11 @@ static int yy_get_next_buffer (void)
 	while ( yy_chk[yy_base[yy_current_state] + yy_c] != yy_current_state )
 		{
 		yy_current_state = (int) yy_def[yy_current_state];
-		if ( yy_current_state >= 94 )
+		if ( yy_current_state >= 161 )
 			yy_c = yy_meta[(unsigned int) yy_c];
 		}
 	yy_current_state = yy_nxt[yy_base[yy_current_state] + (unsigned int) yy_c];
-	yy_is_jam = (yy_current_state == 93);
+	yy_is_jam = (yy_current_state == 160);
 
 	return yy_is_jam ? 0 : yy_current_state;
 }
@@ -1394,6 +1606,8 @@ static int yy_get_next_buffer (void)
 	*(yy_c_buf_p) = '\0';	/* preserve yytext */
 	(yy_hold_char) = *++(yy_c_buf_p);
 
+	YY_CURRENT_BUFFER_LVALUE->yy_at_bol = (c == '\n');
+
 	return c;
 }
 #endif	/* ifndef YY_NO_INPUT */
@@ -1712,8 +1926,8 @@ YY_BUFFER_STATE yy_scan_string (yyconst char * yystr )
 
 /** Setup the input buffer state to scan the given bytes. The next call to yylex() will
  * scan from a @e copy of @a bytes.
- * @param bytes the byte buffer to scan
- * @param len the number of bytes in the buffer pointed to by @a bytes.
+ * @param yybytes the byte buffer to scan
+ * @param _yybytes_len the number of bytes in the buffer pointed to by @a bytes.
  * 
  * @return the newly allocated buffer state object.
  */
@@ -1952,6 +2166,10 @@ void yyfree (void * ptr )
 
 #define YYTABLES_NAME "yytables"
 
+#line 227 "dtc-lexer.l"
+
+
+
 static void push_input_file(const char *filename)
 {
 	assert(filename);
@@ -1963,6 +2181,7 @@ static void push_input_file(const char *filename)
 	yypush_buffer_state(yy_create_buffer(yyin,YY_BUF_SIZE));
 }
 
+
 static int pop_input_file(void)
 {
 	if (srcfile_pop() == 0)
diff --git a/scripts/dtc/dtc-parser.tab.c_shipped b/scripts/dtc/dtc-parser.tab.c_shipped
index b05921e..4af5590 100644
--- a/scripts/dtc/dtc-parser.tab.c_shipped
+++ b/scripts/dtc/dtc-parser.tab.c_shipped
@@ -1,9 +1,10 @@
-/* A Bison parser, made by GNU Bison 2.4.3.  */
+
+/* A Bison parser, made by GNU Bison 2.4.1.  */
 
 /* Skeleton implementation for Bison's Yacc-like parsers in C
    
-      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006,
-   2009, 2010 Free Software Foundation, Inc.
+      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
+   Free Software Foundation, Inc.
    
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
@@ -45,7 +46,7 @@
 #define YYBISON 1
 
 /* Bison version.  */
-#define YYBISON_VERSION "2.4.3"
+#define YYBISON_VERSION "2.4.1"
 
 /* Skeleton name.  */
 #define YYSKELETON_NAME "yacc.c"
@@ -66,6 +67,8 @@
 
 /* Copy the first part of user declarations.  */
 
+/* Line 189 of yacc.c  */
+#line 21 "dtc-parser.y"
 
 #include <stdio.h>
 
@@ -82,12 +85,15 @@ extern struct boot_info *the_boot_info;
 extern int treesource_error;
 
 static unsigned long long eval_literal(const char *s, int base, int bits);
+static unsigned char eval_char_literal(const char *s);
 
 
+/* Line 189 of yacc.c  */
+#line 93 "dtc-parser.tab.c"
 
 /* Enabling traces.  */
 #ifndef YYDEBUG
-# define YYDEBUG 1
+# define YYDEBUG 0
 #endif
 
 /* Enabling verbose error messages.  */
@@ -112,14 +118,26 @@ static unsigned long long eval_literal(const char *s, int base, int bits);
    enum yytokentype {
      DT_V1 = 258,
      DT_MEMRESERVE = 259,
-     DT_PROPNODENAME = 260,
-     DT_LITERAL = 261,
-     DT_BASE = 262,
-     DT_BYTE = 263,
-     DT_STRING = 264,
-     DT_LABEL = 265,
-     DT_REF = 266,
-     DT_INCBIN = 267
+     DT_LSHIFT = 260,
+     DT_RSHIFT = 261,
+     DT_LE = 262,
+     DT_GE = 263,
+     DT_EQ = 264,
+     DT_NE = 265,
+     DT_AND = 266,
+     DT_OR = 267,
+     DT_BITS = 268,
+     DT_DEL_PROP = 269,
+     DT_DEL_NODE = 270,
+     DT_PROPNODENAME = 271,
+     DT_LITERAL = 272,
+     DT_CHAR_LITERAL = 273,
+     DT_BASE = 274,
+     DT_BYTE = 275,
+     DT_STRING = 276,
+     DT_LABEL = 277,
+     DT_REF = 278,
+     DT_INCBIN = 279
    };
 #endif
 
@@ -129,6 +147,8 @@ static unsigned long long eval_literal(const char *s, int base, int bits);
 typedef union YYSTYPE
 {
 
+/* Line 214 of yacc.c  */
+#line 40 "dtc-parser.y"
 
 	char *propnodename;
 	char *literal;
@@ -137,16 +157,22 @@ typedef union YYSTYPE
 	uint8_t byte;
 	struct data data;
 
-	uint64_t addr;
-	cell_t cell;
+	struct {
+		struct data	data;
+		int		bits;
+	} array;
+
 	struct property *prop;
 	struct property *proplist;
 	struct node *node;
 	struct node *nodelist;
 	struct reserve_info *re;
+	uint64_t integer;
 
 
 
+/* Line 214 of yacc.c  */
+#line 176 "dtc-parser.tab.c"
 } YYSTYPE;
 # define YYSTYPE_IS_TRIVIAL 1
 # define yystype YYSTYPE /* obsolescent; will be withdrawn */
@@ -157,6 +183,8 @@ typedef union YYSTYPE
 /* Copy the second part of user declarations.  */
 
 
+/* Line 264 of yacc.c  */
+#line 188 "dtc-parser.tab.c"
 
 #ifdef short
 # undef short
@@ -206,7 +234,7 @@ typedef short int yytype_int16;
 #define YYSIZE_MAXIMUM ((YYSIZE_T) -1)
 
 #ifndef YY_
-# if defined YYENABLE_NLS && YYENABLE_NLS
+# if YYENABLE_NLS
 #  if ENABLE_NLS
 #   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
 #   define YY_(msgid) dgettext ("bison-runtime", msgid)
@@ -371,20 +399,20 @@ union yyalloc
 /* YYFINAL -- State number of the termination state.  */
 #define YYFINAL  4
 /* YYLAST -- Last index in YYTABLE.  */
-#define YYLAST   56
+#define YYLAST   133
 
 /* YYNTOKENS -- Number of terminals.  */
-#define YYNTOKENS  25
+#define YYNTOKENS  48
 /* YYNNTS -- Number of nonterminals.  */
-#define YYNNTS  16
+#define YYNNTS  28
 /* YYNRULES -- Number of rules.  */
-#define YYNRULES  39
+#define YYNRULES  79
 /* YYNRULES -- Number of states.  */
-#define YYNSTATES  67
+#define YYNSTATES  141
 
 /* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
 #define YYUNDEFTOK  2
-#define YYMAXUTOK   267
+#define YYMAXUTOK   279
 
 #define YYTRANSLATE(YYX)						\
   ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)
@@ -395,16 +423,16 @@ static const yytype_uint8 yytranslate[] =
        0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
        2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
        2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
-       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
-      22,    24,     2,     2,    23,     2,     2,    14,     2,     2,
-       2,     2,     2,     2,     2,     2,     2,     2,     2,    13,
-      18,    17,    19,     2,     2,     2,     2,     2,     2,     2,
+       2,     2,     2,    47,     2,     2,     2,    45,    41,     2,
+      33,    35,    44,    42,    34,    43,     2,    26,     2,     2,
+       2,     2,     2,     2,     2,     2,     2,     2,    38,    25,
+      36,    29,    30,    37,     2,     2,     2,     2,     2,     2,
        2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
        2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
-       2,    20,     2,    21,     2,     2,     2,     2,     2,     2,
+       2,    31,     2,    32,    40,     2,     2,     2,     2,     2,
        2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
        2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
-       2,     2,     2,    15,     2,    16,     2,     2,     2,     2,
+       2,     2,     2,    27,    39,    28,    46,     2,     2,     2,
        2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
        2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
        2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
@@ -418,45 +446,68 @@ static const yytype_uint8 yytranslate[] =
        2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
        2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
        2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
-       5,     6,     7,     8,     9,    10,    11,    12
+       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
+      15,    16,    17,    18,    19,    20,    21,    22,    23,    24
 };
 
 #if YYDEBUG
 /* YYPRHS[YYN] -- Index of the first RHS symbol of rule number YYN in
    YYRHS.  */
-static const yytype_uint8 yyprhs[] =
+static const yytype_uint16 yyprhs[] =
 {
-       0,     0,     3,     8,     9,    12,    17,    20,    22,    25,
-      29,    33,    39,    40,    43,    48,    51,    54,    57,    62,
-      67,    70,    80,    86,    89,    90,    93,    96,    97,   100,
-     103,   106,   108,   109,   112,   115,   116,   119,   122,   125
+       0,     0,     3,     8,     9,    12,    17,    20,    23,    27,
+      31,    36,    42,    43,    46,    51,    54,    58,    61,    64,
+      68,    73,    76,    86,    92,    95,    96,    99,   102,   106,
+     108,   111,   114,   117,   119,   121,   125,   127,   129,   135,
+     137,   141,   143,   147,   149,   153,   155,   159,   161,   165,
+     167,   171,   175,   177,   181,   185,   189,   193,   197,   201,
+     203,   207,   211,   213,   217,   221,   225,   227,   229,   232,
+     235,   238,   239,   242,   245,   246,   249,   252,   255,   259
 };
 
 /* YYRHS -- A `-1'-separated list of the rules' RHS.  */
 static const yytype_int8 yyrhs[] =
 {
-      26,     0,    -1,     3,    13,    27,    30,    -1,    -1,    28,
-      27,    -1,     4,    29,    29,    13,    -1,    10,    28,    -1,
-       6,    -1,    14,    31,    -1,    30,    14,    31,    -1,    30,
-      11,    31,    -1,    15,    32,    39,    16,    13,    -1,    -1,
-      32,    33,    -1,     5,    17,    34,    13,    -1,     5,    13,
-      -1,    10,    33,    -1,    35,     9,    -1,    35,    18,    36,
-      19,    -1,    35,    20,    38,    21,    -1,    35,    11,    -1,
-      35,    12,    22,     9,    23,    29,    23,    29,    24,    -1,
-      35,    12,    22,     9,    24,    -1,    34,    10,    -1,    -1,
-      34,    23,    -1,    35,    10,    -1,    -1,    36,    37,    -1,
-      36,    11,    -1,    36,    10,    -1,     6,    -1,    -1,    38,
-       8,    -1,    38,    10,    -1,    -1,    40,    39,    -1,    40,
-      33,    -1,     5,    31,    -1,    10,    40,    -1
+      49,     0,    -1,     3,    25,    50,    52,    -1,    -1,    51,
+      50,    -1,     4,    59,    59,    25,    -1,    22,    51,    -1,
+      26,    53,    -1,    52,    26,    53,    -1,    52,    23,    53,
+      -1,    52,    15,    23,    25,    -1,    27,    54,    74,    28,
+      25,    -1,    -1,    54,    55,    -1,    16,    29,    56,    25,
+      -1,    16,    25,    -1,    14,    16,    25,    -1,    22,    55,
+      -1,    57,    21,    -1,    57,    58,    30,    -1,    57,    31,
+      73,    32,    -1,    57,    23,    -1,    57,    24,    33,    21,
+      34,    59,    34,    59,    35,    -1,    57,    24,    33,    21,
+      35,    -1,    56,    22,    -1,    -1,    56,    34,    -1,    57,
+      22,    -1,    13,    17,    36,    -1,    36,    -1,    58,    59,
+      -1,    58,    23,    -1,    58,    22,    -1,    17,    -1,    18,
+      -1,    33,    60,    35,    -1,    61,    -1,    62,    -1,    62,
+      37,    60,    38,    61,    -1,    63,    -1,    62,    12,    63,
+      -1,    64,    -1,    63,    11,    64,    -1,    65,    -1,    64,
+      39,    65,    -1,    66,    -1,    65,    40,    66,    -1,    67,
+      -1,    66,    41,    67,    -1,    68,    -1,    67,     9,    68,
+      -1,    67,    10,    68,    -1,    69,    -1,    68,    36,    69,
+      -1,    68,    30,    69,    -1,    68,     7,    69,    -1,    68,
+       8,    69,    -1,    69,     5,    70,    -1,    69,     6,    70,
+      -1,    70,    -1,    70,    42,    71,    -1,    70,    43,    71,
+      -1,    71,    -1,    71,    44,    72,    -1,    71,    26,    72,
+      -1,    71,    45,    72,    -1,    72,    -1,    59,    -1,    43,
+      72,    -1,    46,    72,    -1,    47,    72,    -1,    -1,    73,
+      20,    -1,    73,    22,    -1,    -1,    75,    74,    -1,    75,
+      55,    -1,    16,    53,    -1,    15,    16,    25,    -1,    22,
+      75,    -1
 };
 
 /* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
 static const yytype_uint16 yyrline[] =
 {
-       0,    86,    86,    95,    98,   105,   109,   117,   124,   128,
-     132,   145,   153,   156,   163,   167,   171,   179,   183,   187,
-     191,   195,   212,   222,   230,   233,   237,   245,   248,   252,
-     257,   264,   272,   275,   279,   287,   290,   294,   302,   306
+       0,   109,   109,   118,   121,   128,   132,   140,   144,   148,
+     158,   172,   180,   183,   190,   194,   198,   202,   210,   214,
+     218,   222,   226,   243,   253,   261,   264,   268,   275,   290,
+     295,   315,   329,   336,   340,   344,   351,   355,   356,   360,
+     361,   365,   366,   370,   371,   375,   376,   380,   381,   385,
+     386,   387,   391,   392,   393,   394,   395,   399,   400,   401,
+     405,   406,   407,   411,   412,   413,   414,   418,   419,   420,
+     421,   426,   429,   433,   441,   444,   448,   456,   460,   464
 };
 #endif
 
@@ -465,13 +516,19 @@ static const yytype_uint16 yyrline[] =
    First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
 static const char *const yytname[] =
 {
-  "$end", "error", "$undefined", "DT_V1", "DT_MEMRESERVE",
-  "DT_PROPNODENAME", "DT_LITERAL", "DT_BASE", "DT_BYTE", "DT_STRING",
-  "DT_LABEL", "DT_REF", "DT_INCBIN", "';'", "'/'", "'{'", "'}'", "'='",
-  "'<'", "'>'", "'['", "']'", "'('", "','", "')'", "$accept", "sourcefile",
-  "memreserves", "memreserve", "addr", "devicetree", "nodedef", "proplist",
-  "propdef", "propdata", "propdataprefix", "celllist", "cellval",
-  "bytestring", "subnodes", "subnode", 0
+  "$end", "error", "$undefined", "DT_V1", "DT_MEMRESERVE", "DT_LSHIFT",
+  "DT_RSHIFT", "DT_LE", "DT_GE", "DT_EQ", "DT_NE", "DT_AND", "DT_OR",
+  "DT_BITS", "DT_DEL_PROP", "DT_DEL_NODE", "DT_PROPNODENAME", "DT_LITERAL",
+  "DT_CHAR_LITERAL", "DT_BASE", "DT_BYTE", "DT_STRING", "DT_LABEL",
+  "DT_REF", "DT_INCBIN", "';'", "'/'", "'{'", "'}'", "'='", "'>'", "'['",
+  "']'", "'('", "','", "')'", "'<'", "'?'", "':'", "'|'", "'^'", "'&'",
+  "'+'", "'-'", "'*'", "'%'", "'~'", "'!'", "$accept", "sourcefile",
+  "memreserves", "memreserve", "devicetree", "nodedef", "proplist",
+  "propdef", "propdata", "propdataprefix", "arrayprefix", "integer_prim",
+  "integer_expr", "integer_trinary", "integer_or", "integer_and",
+  "integer_bitor", "integer_bitxor", "integer_bitand", "integer_eq",
+  "integer_rela", "integer_shift", "integer_add", "integer_mul",
+  "integer_unary", "bytestring", "subnodes", "subnode", 0
 };
 #endif
 
@@ -481,27 +538,37 @@ static const char *const yytname[] =
 static const yytype_uint16 yytoknum[] =
 {
        0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
-     265,   266,   267,    59,    47,   123,   125,    61,    60,    62,
-      91,    93,    40,    44,    41
+     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
+     275,   276,   277,   278,   279,    59,    47,   123,   125,    61,
+      62,    91,    93,    40,    44,    41,    60,    63,    58,   124,
+      94,    38,    43,    45,    42,    37,   126,    33
 };
 # endif
 
 /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
 static const yytype_uint8 yyr1[] =
 {
-       0,    25,    26,    27,    27,    28,    28,    29,    30,    30,
-      30,    31,    32,    32,    33,    33,    33,    34,    34,    34,
-      34,    34,    34,    34,    35,    35,    35,    36,    36,    36,
-      36,    37,    38,    38,    38,    39,    39,    39,    40,    40
+       0,    48,    49,    50,    50,    51,    51,    52,    52,    52,
+      52,    53,    54,    54,    55,    55,    55,    55,    56,    56,
+      56,    56,    56,    56,    56,    57,    57,    57,    58,    58,
+      58,    58,    58,    59,    59,    59,    60,    61,    61,    62,
+      62,    63,    63,    64,    64,    65,    65,    66,    66,    67,
+      67,    67,    68,    68,    68,    68,    68,    69,    69,    69,
+      70,    70,    70,    71,    71,    71,    71,    72,    72,    72,
+      72,    73,    73,    73,    74,    74,    74,    75,    75,    75
 };
 
 /* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
 static const yytype_uint8 yyr2[] =
 {
-       0,     2,     4,     0,     2,     4,     2,     1,     2,     3,
-       3,     5,     0,     2,     4,     2,     2,     2,     4,     4,
-       2,     9,     5,     2,     0,     2,     2,     0,     2,     2,
-       2,     1,     0,     2,     2,     0,     2,     2,     2,     2
+       0,     2,     4,     0,     2,     4,     2,     2,     3,     3,
+       4,     5,     0,     2,     4,     2,     3,     2,     2,     3,
+       4,     2,     9,     5,     2,     0,     2,     2,     3,     1,
+       2,     2,     2,     1,     1,     3,     1,     1,     5,     1,
+       3,     1,     3,     1,     3,     1,     3,     1,     3,     1,
+       3,     3,     1,     3,     3,     3,     3,     3,     3,     1,
+       3,     3,     1,     3,     3,     3,     1,     1,     2,     2,
+       2,     0,     2,     2,     0,     2,     2,     2,     3,     2
 };
 
 /* YYDEFACT[STATE-NAME] -- Default rule to reduce with in state
@@ -509,41 +576,59 @@ static const yytype_uint8 yyr2[] =
    means the default is an error.  */
 static const yytype_uint8 yydefact[] =
 {
-       0,     0,     0,     3,     1,     0,     0,     0,     3,     7,
-       0,     6,     0,     2,     4,     0,    12,     8,     0,     0,
-       5,    35,    10,     9,     0,     0,    13,     0,    35,    15,
-      24,    38,    16,    39,     0,    37,    36,     0,     0,    11,
-      23,    14,    25,    17,    26,    20,     0,    27,    32,     0,
-       0,     0,     0,    31,    30,    29,    18,    28,    33,    34,
-      19,     0,    22,     0,     0,     0,    21
+       0,     0,     0,     3,     1,     0,     0,     0,     3,    33,
+      34,     0,     0,     6,     0,     2,     4,     0,     0,     0,
+      67,     0,    36,    37,    39,    41,    43,    45,    47,    49,
+      52,    59,    62,    66,     0,    12,     7,     0,     0,     0,
+      68,    69,    70,    35,     0,     0,     0,     0,     0,     0,
+       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
+       0,     0,     0,     5,    74,     0,     9,     8,    40,     0,
+      42,    44,    46,    48,    50,    51,    55,    56,    54,    53,
+      57,    58,    60,    61,    64,    63,    65,     0,     0,     0,
+       0,    13,     0,    74,    10,     0,     0,     0,    15,    25,
+      77,    17,    79,     0,    76,    75,    38,    16,    78,     0,
+       0,    11,    24,    14,    26,     0,    18,    27,    21,     0,
+      71,    29,     0,     0,     0,     0,    32,    31,    19,    30,
+      28,     0,    72,    73,    20,     0,    23,     0,     0,     0,
+      22
 };
 
 /* YYDEFGOTO[NTERM-NUM].  */
 static const yytype_int8 yydefgoto[] =
 {
-      -1,     2,     7,     8,    10,    13,    17,    21,    26,    37,
-      38,    50,    57,    51,    27,    28
+      -1,     2,     7,     8,    15,    36,    64,    91,   109,   110,
+     122,    20,    21,    22,    23,    24,    25,    26,    27,    28,
+      29,    30,    31,    32,    33,   125,    92,    93
 };
 
 /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
    STATE-NUM.  */
-#define YYPACT_NINF -12
+#define YYPACT_NINF -78
 static const yytype_int8 yypact[] =
 {
-      10,   -11,    18,    -1,   -12,    22,    -1,    15,    -1,   -12,
-      22,   -12,    20,     1,   -12,    17,   -12,   -12,    20,    20,
-     -12,     6,   -12,   -12,    21,     6,   -12,    23,     6,   -12,
-     -12,   -12,   -12,   -12,    28,   -12,   -12,    -6,    13,   -12,
-     -12,   -12,   -12,   -12,   -12,   -12,    24,   -12,   -12,    33,
-      -5,     0,    -4,   -12,   -12,   -12,   -12,   -12,   -12,   -12,
-     -12,    22,   -12,    25,    22,    19,   -12
+      22,    11,    51,    10,   -78,    23,    10,     2,    10,   -78,
+     -78,    -9,    23,   -78,    30,    38,   -78,    -9,    -9,    -9,
+     -78,    35,   -78,    -6,    52,    29,    48,    49,    33,     3,
+      71,    36,     0,   -78,    64,   -78,   -78,    68,    30,    30,
+     -78,   -78,   -78,   -78,    -9,    -9,    -9,    -9,    -9,    -9,
+      -9,    -9,    -9,    -9,    -9,    -9,    -9,    -9,    -9,    -9,
+      -9,    -9,    -9,   -78,    44,    67,   -78,   -78,    52,    55,
+      29,    48,    49,    33,     3,     3,    71,    71,    71,    71,
+      36,    36,     0,     0,   -78,   -78,   -78,    78,    79,    42,
+      44,   -78,    69,    44,   -78,    -9,    73,    74,   -78,   -78,
+     -78,   -78,   -78,    75,   -78,   -78,   -78,   -78,   -78,    -7,
+      -1,   -78,   -78,   -78,   -78,    84,   -78,   -78,   -78,    63,
+     -78,   -78,    32,    66,    82,    -3,   -78,   -78,   -78,   -78,
+     -78,    46,   -78,   -78,   -78,    23,   -78,    70,    23,    72,
+     -78
 };
 
 /* YYPGOTO[NTERM-NUM].  */
 static const yytype_int8 yypgoto[] =
 {
-     -12,   -12,    36,    39,   -10,   -12,     8,   -12,    12,   -12,
-     -12,   -12,   -12,   -12,    27,    31
+     -78,   -78,    97,   100,   -78,   -37,   -78,   -77,   -78,   -78,
+     -78,    -5,    65,    13,   -78,    76,    77,    62,    80,    83,
+      34,    20,    26,    28,   -14,   -78,    18,    24
 };
 
 /* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
@@ -553,35 +638,59 @@ static const yytype_int8 yypgoto[] =
 #define YYTABLE_NINF -1
 static const yytype_uint8 yytable[] =
 {
-      15,    53,     3,     5,    40,    54,    55,    41,    58,     6,
-      59,    24,    18,     1,    56,    19,    25,    42,     4,    61,
-      62,    60,    43,    44,    45,    46,    22,    23,     9,    12,
-      20,    47,    31,    48,    29,    16,    16,    32,    30,    34,
-      35,    39,    52,    66,    14,    11,    49,     0,    64,     0,
-       0,    63,     0,     0,    65,    36,    33
+      12,    66,    67,    40,    41,    42,    44,    34,     9,    10,
+      52,    53,   115,   101,     5,   112,   104,   132,   113,   133,
+     116,   117,   118,   119,    11,     1,    60,   114,    14,   134,
+     120,    45,     6,    54,    17,   121,     3,    18,    19,    55,
+       9,    10,    50,    51,    61,    62,    84,    85,    86,     9,
+      10,     4,   100,    37,   126,   127,    11,    35,    87,    88,
+      89,    38,   128,    46,    39,    11,    90,    98,    47,    35,
+      43,    99,    76,    77,    78,    79,    56,    57,    58,    59,
+     135,   136,    80,    81,    74,    75,    82,    83,    48,    63,
+      49,    65,    94,    95,    96,    97,   124,   103,   107,   108,
+     111,   123,   130,   131,   138,    16,    13,   140,   106,    71,
+      69,   105,     0,     0,   102,     0,     0,   129,     0,     0,
+      68,     0,     0,    70,     0,     0,     0,     0,    72,     0,
+     137,     0,    73,   139
 };
 
-static const yytype_int8 yycheck[] =
+static const yytype_int16 yycheck[] =
 {
-      10,     6,    13,     4,    10,    10,    11,    13,     8,    10,
-      10,     5,    11,     3,    19,    14,    10,    23,     0,    23,
-      24,    21,     9,    10,    11,    12,    18,    19,     6,    14,
-      13,    18,    24,    20,    13,    15,    15,    25,    17,    16,
-      28,    13,     9,    24,     8,     6,    22,    -1,    23,    -1,
-      -1,    61,    -1,    -1,    64,    28,    25
+       5,    38,    39,    17,    18,    19,    12,    12,    17,    18,
+       7,     8,    13,    90,     4,    22,    93,    20,    25,    22,
+      21,    22,    23,    24,    33,     3,    26,    34,    26,    32,
+      31,    37,    22,    30,    43,    36,    25,    46,    47,    36,
+      17,    18,     9,    10,    44,    45,    60,    61,    62,    17,
+      18,     0,    89,    15,    22,    23,    33,    27,    14,    15,
+      16,    23,    30,    11,    26,    33,    22,    25,    39,    27,
+      35,    29,    52,    53,    54,    55,     5,     6,    42,    43,
+      34,    35,    56,    57,    50,    51,    58,    59,    40,    25,
+      41,    23,    25,    38,    16,    16,    33,    28,    25,    25,
+      25,    17,    36,    21,    34,     8,     6,    35,    95,    47,
+      45,    93,    -1,    -1,    90,    -1,    -1,   122,    -1,    -1,
+      44,    -1,    -1,    46,    -1,    -1,    -1,    -1,    48,    -1,
+     135,    -1,    49,   138
 };
 
 /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
    symbol of state STATE-NUM.  */
 static const yytype_uint8 yystos[] =
 {
-       0,     3,    26,    13,     0,     4,    10,    27,    28,     6,
-      29,    28,    14,    30,    27,    29,    15,    31,    11,    14,
-      13,    32,    31,    31,     5,    10,    33,    39,    40,    13,
-      17,    31,    33,    40,    16,    33,    39,    34,    35,    13,
-      10,    13,    23,     9,    10,    11,    12,    18,    20,    22,
-      36,    38,     9,     6,    10,    11,    19,    37,     8,    10,
-      21,    23,    24,    29,    23,    29,    24
+       0,     3,    49,    25,     0,     4,    22,    50,    51,    17,
+      18,    33,    59,    51,    26,    52,    50,    43,    46,    47,
+      59,    60,    61,    62,    63,    64,    65,    66,    67,    68,
+      69,    70,    71,    72,    59,    27,    53,    15,    23,    26,
+      72,    72,    72,    35,    12,    37,    11,    39,    40,    41,
+       9,    10,     7,     8,    30,    36,     5,     6,    42,    43,
+      26,    44,    45,    25,    54,    23,    53,    53,    63,    60,
+      64,    65,    66,    67,    68,    68,    69,    69,    69,    69,
+      70,    70,    71,    71,    72,    72,    72,    14,    15,    16,
+      22,    55,    74,    75,    25,    38,    16,    16,    25,    29,
+      53,    55,    75,    28,    55,    74,    61,    25,    25,    56,
+      57,    25,    22,    25,    34,    13,    21,    22,    23,    24,
+      31,    36,    58,    17,    33,    73,    22,    23,    30,    59,
+      36,    21,    20,    22,    32,    34,    35,    59,    34,    59,
+      35
 };
 
 #define yyerrok		(yyerrstatus = 0)
@@ -596,18 +705,9 @@ static const yytype_uint8 yystos[] =
 
 /* Like YYERROR except do call yyerror.  This remains here temporarily
    to ease the transition to the new meaning of YYERROR, for GCC.
-   Once GCC version 2 has supplanted version 1, this can go.  However,
-   YYFAIL appears to be in use.  Nevertheless, it is formally deprecated
-   in Bison 2.4.2's NEWS entry, where a plan to phase it out is
-   discussed.  */
+   Once GCC version 2 has supplanted version 1, this can go.  */
 
 #define YYFAIL		goto yyerrlab
-#if defined YYFAIL
-  /* This is here to suppress warnings from the GCC cpp's
-     -Wunused-macros.  Normally we don't worry about that warning, but
-     some users do, and we want to make it easy for users to remove
-     YYFAIL uses, which will produce warnings from Bison 2.5.  */
-#endif
 
 #define YYRECOVERING()  (!!yyerrstatus)
 
@@ -664,7 +764,7 @@ while (YYID (0))
    we won't break user code: when these are the locations we know.  */
 
 #ifndef YY_LOCATION_PRINT
-# if defined YYLTYPE_IS_TRIVIAL && YYLTYPE_IS_TRIVIAL
+# if YYLTYPE_IS_TRIVIAL
 #  define YY_LOCATION_PRINT(File, Loc)			\
      fprintf (File, "%d.%d-%d.%d",			\
 	      (Loc).first_line, (Loc).first_column,	\
@@ -1403,6 +1503,8 @@ yyreduce:
     {
         case 2:
 
+/* Line 1455 of yacc.c  */
+#line 110 "dtc-parser.y"
     {
 			the_boot_info = build_boot_info((yyvsp[(3) - (4)].re), (yyvsp[(4) - (4)].node),
 							guess_boot_cpuid((yyvsp[(4) - (4)].node)));
@@ -1411,6 +1513,8 @@ yyreduce:
 
   case 3:
 
+/* Line 1455 of yacc.c  */
+#line 118 "dtc-parser.y"
     {
 			(yyval.re) = NULL;
 		;}
@@ -1418,6 +1522,8 @@ yyreduce:
 
   case 4:
 
+/* Line 1455 of yacc.c  */
+#line 122 "dtc-parser.y"
     {
 			(yyval.re) = chain_reserve_entry((yyvsp[(1) - (2)].re), (yyvsp[(2) - (2)].re));
 		;}
@@ -1425,13 +1531,17 @@ yyreduce:
 
   case 5:
 
+/* Line 1455 of yacc.c  */
+#line 129 "dtc-parser.y"
     {
-			(yyval.re) = build_reserve_entry((yyvsp[(2) - (4)].addr), (yyvsp[(3) - (4)].addr));
+			(yyval.re) = build_reserve_entry((yyvsp[(2) - (4)].integer), (yyvsp[(3) - (4)].integer));
 		;}
     break;
 
   case 6:
 
+/* Line 1455 of yacc.c  */
+#line 133 "dtc-parser.y"
     {
 			add_label(&(yyvsp[(2) - (2)].re)->labels, (yyvsp[(1) - (2)].labelref));
 			(yyval.re) = (yyvsp[(2) - (2)].re);
@@ -1440,40 +1550,57 @@ yyreduce:
 
   case 7:
 
+/* Line 1455 of yacc.c  */
+#line 141 "dtc-parser.y"
     {
-			(yyval.addr) = eval_literal((yyvsp[(1) - (1)].literal), 0, 64);
+			(yyval.node) = name_node((yyvsp[(2) - (2)].node), "");
 		;}
     break;
 
   case 8:
 
+/* Line 1455 of yacc.c  */
+#line 145 "dtc-parser.y"
     {
-			(yyval.node) = name_node((yyvsp[(2) - (2)].node), "");
+			(yyval.node) = merge_nodes((yyvsp[(1) - (3)].node), (yyvsp[(3) - (3)].node));
 		;}
     break;
 
   case 9:
 
+/* Line 1455 of yacc.c  */
+#line 149 "dtc-parser.y"
     {
-			(yyval.node) = merge_nodes((yyvsp[(1) - (3)].node), (yyvsp[(3) - (3)].node));
+			struct node *target = get_node_by_ref((yyvsp[(1) - (3)].node), (yyvsp[(2) - (3)].labelref));
+
+			if (target)
+				merge_nodes(target, (yyvsp[(3) - (3)].node));
+			else
+				print_error("label or path, '%s', not found", (yyvsp[(2) - (3)].labelref));
+			(yyval.node) = (yyvsp[(1) - (3)].node);
 		;}
     break;
 
   case 10:
 
+/* Line 1455 of yacc.c  */
+#line 159 "dtc-parser.y"
     {
-			struct node *target = get_node_by_ref((yyvsp[(1) - (3)].node), (yyvsp[(2) - (3)].labelref));
+			struct node *target = get_node_by_ref((yyvsp[(1) - (4)].node), (yyvsp[(3) - (4)].labelref));
 
-			if (target)
-				merge_nodes(target, (yyvsp[(3) - (3)].node));
+			if (!target)
+				print_error("label or path, '%s', not found", (yyvsp[(3) - (4)].labelref));
 			else
-				print_error("label or path, '%s', not found", (yyvsp[(2) - (3)].labelref));
-			(yyval.node) = (yyvsp[(1) - (3)].node);
+				delete_node(target);
+
+			(yyval.node) = (yyvsp[(1) - (4)].node);
 		;}
     break;
 
   case 11:
 
+/* Line 1455 of yacc.c  */
+#line 173 "dtc-parser.y"
     {
 			(yyval.node) = build_node((yyvsp[(2) - (5)].proplist), (yyvsp[(3) - (5)].nodelist));
 		;}
@@ -1481,6 +1608,8 @@ yyreduce:
 
   case 12:
 
+/* Line 1455 of yacc.c  */
+#line 180 "dtc-parser.y"
     {
 			(yyval.proplist) = NULL;
 		;}
@@ -1488,6 +1617,8 @@ yyreduce:
 
   case 13:
 
+/* Line 1455 of yacc.c  */
+#line 184 "dtc-parser.y"
     {
 			(yyval.proplist) = chain_property((yyvsp[(2) - (2)].prop), (yyvsp[(1) - (2)].proplist));
 		;}
@@ -1495,6 +1626,8 @@ yyreduce:
 
   case 14:
 
+/* Line 1455 of yacc.c  */
+#line 191 "dtc-parser.y"
     {
 			(yyval.prop) = build_property((yyvsp[(1) - (4)].propnodename), (yyvsp[(3) - (4)].data));
 		;}
@@ -1502,6 +1635,8 @@ yyreduce:
 
   case 15:
 
+/* Line 1455 of yacc.c  */
+#line 195 "dtc-parser.y"
     {
 			(yyval.prop) = build_property((yyvsp[(1) - (2)].propnodename), empty_data);
 		;}
@@ -1509,62 +1644,85 @@ yyreduce:
 
   case 16:
 
+/* Line 1455 of yacc.c  */
+#line 199 "dtc-parser.y"
     {
-			add_label(&(yyvsp[(2) - (2)].prop)->labels, (yyvsp[(1) - (2)].labelref));
-			(yyval.prop) = (yyvsp[(2) - (2)].prop);
+			(yyval.prop) = build_property_delete((yyvsp[(2) - (3)].propnodename));
 		;}
     break;
 
   case 17:
 
+/* Line 1455 of yacc.c  */
+#line 203 "dtc-parser.y"
     {
-			(yyval.data) = data_merge((yyvsp[(1) - (2)].data), (yyvsp[(2) - (2)].data));
+			add_label(&(yyvsp[(2) - (2)].prop)->labels, (yyvsp[(1) - (2)].labelref));
+			(yyval.prop) = (yyvsp[(2) - (2)].prop);
 		;}
     break;
 
   case 18:
 
+/* Line 1455 of yacc.c  */
+#line 211 "dtc-parser.y"
     {
-			(yyval.data) = data_merge((yyvsp[(1) - (4)].data), (yyvsp[(3) - (4)].data));
+			(yyval.data) = data_merge((yyvsp[(1) - (2)].data), (yyvsp[(2) - (2)].data));
 		;}
     break;
 
   case 19:
 
+/* Line 1455 of yacc.c  */
+#line 215 "dtc-parser.y"
     {
-			(yyval.data) = data_merge((yyvsp[(1) - (4)].data), (yyvsp[(3) - (4)].data));
+			(yyval.data) = data_merge((yyvsp[(1) - (3)].data), (yyvsp[(2) - (3)].array).data);
 		;}
     break;
 
   case 20:
 
+/* Line 1455 of yacc.c  */
+#line 219 "dtc-parser.y"
     {
-			(yyval.data) = data_add_marker((yyvsp[(1) - (2)].data), REF_PATH, (yyvsp[(2) - (2)].labelref));
+			(yyval.data) = data_merge((yyvsp[(1) - (4)].data), (yyvsp[(3) - (4)].data));
 		;}
     break;
 
   case 21:
 
+/* Line 1455 of yacc.c  */
+#line 223 "dtc-parser.y"
+    {
+			(yyval.data) = data_add_marker((yyvsp[(1) - (2)].data), REF_PATH, (yyvsp[(2) - (2)].labelref));
+		;}
+    break;
+
+  case 22:
+
+/* Line 1455 of yacc.c  */
+#line 227 "dtc-parser.y"
     {
 			FILE *f = srcfile_relative_open((yyvsp[(4) - (9)].data).val, NULL);
 			struct data d;
 
-			if ((yyvsp[(6) - (9)].addr) != 0)
-				if (fseek(f, (yyvsp[(6) - (9)].addr), SEEK_SET) != 0)
+			if ((yyvsp[(6) - (9)].integer) != 0)
+				if (fseek(f, (yyvsp[(6) - (9)].integer), SEEK_SET) != 0)
 					print_error("Couldn't seek to offset %llu in \"%s\": %s",
-						     (unsigned long long)(yyvsp[(6) - (9)].addr),
+						     (unsigned long long)(yyvsp[(6) - (9)].integer),
 						     (yyvsp[(4) - (9)].data).val,
 						     strerror(errno));
 
-			d = data_copy_file(f, (yyvsp[(8) - (9)].addr));
+			d = data_copy_file(f, (yyvsp[(8) - (9)].integer));
 
 			(yyval.data) = data_merge((yyvsp[(1) - (9)].data), d);
 			fclose(f);
 		;}
     break;
 
-  case 22:
+  case 23:
 
+/* Line 1455 of yacc.c  */
+#line 244 "dtc-parser.y"
     {
 			FILE *f = srcfile_relative_open((yyvsp[(4) - (5)].data).val, NULL);
 			struct data d = empty_data;
@@ -1576,122 +1734,383 @@ yyreduce:
 		;}
     break;
 
-  case 23:
-
-    {
-			(yyval.data) = data_add_marker((yyvsp[(1) - (2)].data), LABEL, (yyvsp[(2) - (2)].labelref));
-		;}
-    break;
-
   case 24:
 
+/* Line 1455 of yacc.c  */
+#line 254 "dtc-parser.y"
     {
-			(yyval.data) = empty_data;
+			(yyval.data) = data_add_marker((yyvsp[(1) - (2)].data), LABEL, (yyvsp[(2) - (2)].labelref));
 		;}
     break;
 
   case 25:
 
+/* Line 1455 of yacc.c  */
+#line 261 "dtc-parser.y"
     {
-			(yyval.data) = (yyvsp[(1) - (2)].data);
+			(yyval.data) = empty_data;
 		;}
     break;
 
   case 26:
 
+/* Line 1455 of yacc.c  */
+#line 265 "dtc-parser.y"
     {
-			(yyval.data) = data_add_marker((yyvsp[(1) - (2)].data), LABEL, (yyvsp[(2) - (2)].labelref));
+			(yyval.data) = (yyvsp[(1) - (2)].data);
 		;}
     break;
 
   case 27:
 
+/* Line 1455 of yacc.c  */
+#line 269 "dtc-parser.y"
     {
-			(yyval.data) = empty_data;
+			(yyval.data) = data_add_marker((yyvsp[(1) - (2)].data), LABEL, (yyvsp[(2) - (2)].labelref));
 		;}
     break;
 
   case 28:
 
+/* Line 1455 of yacc.c  */
+#line 276 "dtc-parser.y"
     {
-			(yyval.data) = data_append_cell((yyvsp[(1) - (2)].data), (yyvsp[(2) - (2)].cell));
+			(yyval.array).data = empty_data;
+			(yyval.array).bits = eval_literal((yyvsp[(2) - (3)].literal), 0, 7);
+
+			if (((yyval.array).bits !=  8) &&
+			    ((yyval.array).bits != 16) &&
+			    ((yyval.array).bits != 32) &&
+			    ((yyval.array).bits != 64))
+			{
+				print_error("Only 8, 16, 32 and 64-bit elements"
+					    " are currently supported");
+				(yyval.array).bits = 32;
+			}
 		;}
     break;
 
   case 29:
 
+/* Line 1455 of yacc.c  */
+#line 291 "dtc-parser.y"
     {
-			(yyval.data) = data_append_cell(data_add_marker((yyvsp[(1) - (2)].data), REF_PHANDLE,
-							      (yyvsp[(2) - (2)].labelref)), -1);
+			(yyval.array).data = empty_data;
+			(yyval.array).bits = 32;
 		;}
     break;
 
   case 30:
 
+/* Line 1455 of yacc.c  */
+#line 296 "dtc-parser.y"
     {
-			(yyval.data) = data_add_marker((yyvsp[(1) - (2)].data), LABEL, (yyvsp[(2) - (2)].labelref));
+			if ((yyvsp[(1) - (2)].array).bits < 64) {
+				uint64_t mask = (1ULL << (yyvsp[(1) - (2)].array).bits) - 1;
+				/*
+				 * Bits above mask must either be all zero
+				 * (positive within range of mask) or all one
+				 * (negative and sign-extended). The second
+				 * condition is true if when we set all bits
+				 * within the mask to one (i.e. | in the
+				 * mask), all bits are one.
+				 */
+				if (((yyvsp[(2) - (2)].integer) > mask) && (((yyvsp[(2) - (2)].integer) | mask) != -1ULL))
+					print_error(
+						"integer value out of range "
+						"%016lx (%d bits)", (yyvsp[(1) - (2)].array).bits);
+			}
+
+			(yyval.array).data = data_append_integer((yyvsp[(1) - (2)].array).data, (yyvsp[(2) - (2)].integer), (yyvsp[(1) - (2)].array).bits);
 		;}
     break;
 
   case 31:
 
+/* Line 1455 of yacc.c  */
+#line 316 "dtc-parser.y"
     {
-			(yyval.cell) = eval_literal((yyvsp[(1) - (1)].literal), 0, 32);
+			uint64_t val = ~0ULL >> (64 - (yyvsp[(1) - (2)].array).bits);
+
+			if ((yyvsp[(1) - (2)].array).bits == 32)
+				(yyvsp[(1) - (2)].array).data = data_add_marker((yyvsp[(1) - (2)].array).data,
+							  REF_PHANDLE,
+							  (yyvsp[(2) - (2)].labelref));
+			else
+				print_error("References are only allowed in "
+					    "arrays with 32-bit elements.");
+
+			(yyval.array).data = data_append_integer((yyvsp[(1) - (2)].array).data, val, (yyvsp[(1) - (2)].array).bits);
 		;}
     break;
 
   case 32:
 
+/* Line 1455 of yacc.c  */
+#line 330 "dtc-parser.y"
     {
-			(yyval.data) = empty_data;
+			(yyval.array).data = data_add_marker((yyvsp[(1) - (2)].array).data, LABEL, (yyvsp[(2) - (2)].labelref));
 		;}
     break;
 
   case 33:
 
+/* Line 1455 of yacc.c  */
+#line 337 "dtc-parser.y"
     {
-			(yyval.data) = data_append_byte((yyvsp[(1) - (2)].data), (yyvsp[(2) - (2)].byte));
+			(yyval.integer) = eval_literal((yyvsp[(1) - (1)].literal), 0, 64);
 		;}
     break;
 
   case 34:
 
+/* Line 1455 of yacc.c  */
+#line 341 "dtc-parser.y"
     {
-			(yyval.data) = data_add_marker((yyvsp[(1) - (2)].data), LABEL, (yyvsp[(2) - (2)].labelref));
+			(yyval.integer) = eval_char_literal((yyvsp[(1) - (1)].literal));
 		;}
     break;
 
   case 35:
 
+/* Line 1455 of yacc.c  */
+#line 345 "dtc-parser.y"
+    {
+			(yyval.integer) = (yyvsp[(2) - (3)].integer);
+		;}
+    break;
+
+  case 38:
+
+/* Line 1455 of yacc.c  */
+#line 356 "dtc-parser.y"
+    { (yyval.integer) = (yyvsp[(1) - (5)].integer) ? (yyvsp[(3) - (5)].integer) : (yyvsp[(5) - (5)].integer); ;}
+    break;
+
+  case 40:
+
+/* Line 1455 of yacc.c  */
+#line 361 "dtc-parser.y"
+    { (yyval.integer) = (yyvsp[(1) - (3)].integer) || (yyvsp[(3) - (3)].integer); ;}
+    break;
+
+  case 42:
+
+/* Line 1455 of yacc.c  */
+#line 366 "dtc-parser.y"
+    { (yyval.integer) = (yyvsp[(1) - (3)].integer) && (yyvsp[(3) - (3)].integer); ;}
+    break;
+
+  case 44:
+
+/* Line 1455 of yacc.c  */
+#line 371 "dtc-parser.y"
+    { (yyval.integer) = (yyvsp[(1) - (3)].integer) | (yyvsp[(3) - (3)].integer); ;}
+    break;
+
+  case 46:
+
+/* Line 1455 of yacc.c  */
+#line 376 "dtc-parser.y"
+    { (yyval.integer) = (yyvsp[(1) - (3)].integer) ^ (yyvsp[(3) - (3)].integer); ;}
+    break;
+
+  case 48:
+
+/* Line 1455 of yacc.c  */
+#line 381 "dtc-parser.y"
+    { (yyval.integer) = (yyvsp[(1) - (3)].integer) & (yyvsp[(3) - (3)].integer); ;}
+    break;
+
+  case 50:
+
+/* Line 1455 of yacc.c  */
+#line 386 "dtc-parser.y"
+    { (yyval.integer) = (yyvsp[(1) - (3)].integer) == (yyvsp[(3) - (3)].integer); ;}
+    break;
+
+  case 51:
+
+/* Line 1455 of yacc.c  */
+#line 387 "dtc-parser.y"
+    { (yyval.integer) = (yyvsp[(1) - (3)].integer) != (yyvsp[(3) - (3)].integer); ;}
+    break;
+
+  case 53:
+
+/* Line 1455 of yacc.c  */
+#line 392 "dtc-parser.y"
+    { (yyval.integer) = (yyvsp[(1) - (3)].integer) < (yyvsp[(3) - (3)].integer); ;}
+    break;
+
+  case 54:
+
+/* Line 1455 of yacc.c  */
+#line 393 "dtc-parser.y"
+    { (yyval.integer) = (yyvsp[(1) - (3)].integer) > (yyvsp[(3) - (3)].integer); ;}
+    break;
+
+  case 55:
+
+/* Line 1455 of yacc.c  */
+#line 394 "dtc-parser.y"
+    { (yyval.integer) = (yyvsp[(1) - (3)].integer) <= (yyvsp[(3) - (3)].integer); ;}
+    break;
+
+  case 56:
+
+/* Line 1455 of yacc.c  */
+#line 395 "dtc-parser.y"
+    { (yyval.integer) = (yyvsp[(1) - (3)].integer) >= (yyvsp[(3) - (3)].integer); ;}
+    break;
+
+  case 57:
+
+/* Line 1455 of yacc.c  */
+#line 399 "dtc-parser.y"
+    { (yyval.integer) = (yyvsp[(1) - (3)].integer) << (yyvsp[(3) - (3)].integer); ;}
+    break;
+
+  case 58:
+
+/* Line 1455 of yacc.c  */
+#line 400 "dtc-parser.y"
+    { (yyval.integer) = (yyvsp[(1) - (3)].integer) >> (yyvsp[(3) - (3)].integer); ;}
+    break;
+
+  case 60:
+
+/* Line 1455 of yacc.c  */
+#line 405 "dtc-parser.y"
+    { (yyval.integer) = (yyvsp[(1) - (3)].integer) + (yyvsp[(3) - (3)].integer); ;}
+    break;
+
+  case 61:
+
+/* Line 1455 of yacc.c  */
+#line 406 "dtc-parser.y"
+    { (yyval.integer) = (yyvsp[(1) - (3)].integer) - (yyvsp[(3) - (3)].integer); ;}
+    break;
+
+  case 63:
+
+/* Line 1455 of yacc.c  */
+#line 411 "dtc-parser.y"
+    { (yyval.integer) = (yyvsp[(1) - (3)].integer) * (yyvsp[(3) - (3)].integer); ;}
+    break;
+
+  case 64:
+
+/* Line 1455 of yacc.c  */
+#line 412 "dtc-parser.y"
+    { (yyval.integer) = (yyvsp[(1) - (3)].integer) / (yyvsp[(3) - (3)].integer); ;}
+    break;
+
+  case 65:
+
+/* Line 1455 of yacc.c  */
+#line 413 "dtc-parser.y"
+    { (yyval.integer) = (yyvsp[(1) - (3)].integer) % (yyvsp[(3) - (3)].integer); ;}
+    break;
+
+  case 68:
+
+/* Line 1455 of yacc.c  */
+#line 419 "dtc-parser.y"
+    { (yyval.integer) = -(yyvsp[(2) - (2)].integer); ;}
+    break;
+
+  case 69:
+
+/* Line 1455 of yacc.c  */
+#line 420 "dtc-parser.y"
+    { (yyval.integer) = ~(yyvsp[(2) - (2)].integer); ;}
+    break;
+
+  case 70:
+
+/* Line 1455 of yacc.c  */
+#line 421 "dtc-parser.y"
+    { (yyval.integer) = !(yyvsp[(2) - (2)].integer); ;}
+    break;
+
+  case 71:
+
+/* Line 1455 of yacc.c  */
+#line 426 "dtc-parser.y"
+    {
+			(yyval.data) = empty_data;
+		;}
+    break;
+
+  case 72:
+
+/* Line 1455 of yacc.c  */
+#line 430 "dtc-parser.y"
+    {
+			(yyval.data) = data_append_byte((yyvsp[(1) - (2)].data), (yyvsp[(2) - (2)].byte));
+		;}
+    break;
+
+  case 73:
+
+/* Line 1455 of yacc.c  */
+#line 434 "dtc-parser.y"
+    {
+			(yyval.data) = data_add_marker((yyvsp[(1) - (2)].data), LABEL, (yyvsp[(2) - (2)].labelref));
+		;}
+    break;
+
+  case 74:
+
+/* Line 1455 of yacc.c  */
+#line 441 "dtc-parser.y"
     {
 			(yyval.nodelist) = NULL;
 		;}
     break;
 
-  case 36:
+  case 75:
 
+/* Line 1455 of yacc.c  */
+#line 445 "dtc-parser.y"
     {
 			(yyval.nodelist) = chain_node((yyvsp[(1) - (2)].node), (yyvsp[(2) - (2)].nodelist));
 		;}
     break;
 
-  case 37:
+  case 76:
 
+/* Line 1455 of yacc.c  */
+#line 449 "dtc-parser.y"
     {
 			print_error("syntax error: properties must precede subnodes");
 			YYERROR;
 		;}
     break;
 
-  case 38:
+  case 77:
 
+/* Line 1455 of yacc.c  */
+#line 457 "dtc-parser.y"
     {
 			(yyval.node) = name_node((yyvsp[(2) - (2)].node), (yyvsp[(1) - (2)].propnodename));
 		;}
     break;
 
-  case 39:
+  case 78:
+
+/* Line 1455 of yacc.c  */
+#line 461 "dtc-parser.y"
+    {
+			(yyval.node) = name_node(build_node_delete(), (yyvsp[(2) - (3)].propnodename));
+		;}
+    break;
+
+  case 79:
 
+/* Line 1455 of yacc.c  */
+#line 465 "dtc-parser.y"
     {
 			add_label(&(yyvsp[(2) - (2)].node)->labels, (yyvsp[(1) - (2)].labelref));
 			(yyval.node) = (yyvsp[(2) - (2)].node);
@@ -1700,6 +2119,8 @@ yyreduce:
 
 
 
+/* Line 1455 of yacc.c  */
+#line 2124 "dtc-parser.tab.c"
       default: break;
     }
   YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);
@@ -1910,6 +2331,8 @@ yyreturn:
 
 
 
+/* Line 1675 of yacc.c  */
+#line 471 "dtc-parser.y"
 
 
 void print_error(char const *fmt, ...)
@@ -1934,9 +2357,12 @@ static unsigned long long eval_literal(const char *s, int base, int bits)
 
 	errno = 0;
 	val = strtoull(s, &e, base);
-	if (*e)
-		print_error("bad characters in literal");
-	else if ((errno == ERANGE)
+	if (*e) {
+		size_t uls = strspn(e, "UL");
+		if (e[uls])
+			print_error("bad characters in literal");
+	}
+	if ((errno == ERANGE)
 		 || ((bits < 64) && (val >= (1ULL << bits))))
 		print_error("literal out of range");
 	else if (errno != 0)
@@ -1944,3 +2370,29 @@ static unsigned long long eval_literal(const char *s, int base, int bits)
 	return val;
 }
 
+static unsigned char eval_char_literal(const char *s)
+{
+	int i = 1;
+	char c = s[0];
+
+	if (c == '\0')
+	{
+		print_error("empty character literal");
+		return 0;
+	}
+
+	/*
+	 * If the first character in the character literal is a \ then process
+	 * the remaining characters as an escape encoding. If the first
+	 * character is neither an escape or a terminator it should be the only
+	 * character in the literal and will be returned.
+	 */
+	if (c == '\\')
+		c = get_escape_char(s, &i);
+
+	if (s[i] != '\0')
+		print_error("malformed character literal");
+
+	return c;
+}
+
diff --git a/scripts/dtc/dtc-parser.tab.h_shipped b/scripts/dtc/dtc-parser.tab.h_shipped
index 4ee682b..9d2dce4 100644
--- a/scripts/dtc/dtc-parser.tab.h_shipped
+++ b/scripts/dtc/dtc-parser.tab.h_shipped
@@ -1,9 +1,10 @@
-/* A Bison parser, made by GNU Bison 2.4.3.  */
+
+/* A Bison parser, made by GNU Bison 2.4.1.  */
 
 /* Skeleton interface for Bison's Yacc-like parsers in C
    
-      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006,
-   2009, 2010 Free Software Foundation, Inc.
+      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
+   Free Software Foundation, Inc.
    
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
@@ -40,14 +41,26 @@
    enum yytokentype {
      DT_V1 = 258,
      DT_MEMRESERVE = 259,
-     DT_PROPNODENAME = 260,
-     DT_LITERAL = 261,
-     DT_BASE = 262,
-     DT_BYTE = 263,
-     DT_STRING = 264,
-     DT_LABEL = 265,
-     DT_REF = 266,
-     DT_INCBIN = 267
+     DT_LSHIFT = 260,
+     DT_RSHIFT = 261,
+     DT_LE = 262,
+     DT_GE = 263,
+     DT_EQ = 264,
+     DT_NE = 265,
+     DT_AND = 266,
+     DT_OR = 267,
+     DT_BITS = 268,
+     DT_DEL_PROP = 269,
+     DT_DEL_NODE = 270,
+     DT_PROPNODENAME = 271,
+     DT_LITERAL = 272,
+     DT_CHAR_LITERAL = 273,
+     DT_BASE = 274,
+     DT_BYTE = 275,
+     DT_STRING = 276,
+     DT_LABEL = 277,
+     DT_REF = 278,
+     DT_INCBIN = 279
    };
 #endif
 
@@ -57,6 +70,8 @@
 typedef union YYSTYPE
 {
 
+/* Line 1676 of yacc.c  */
+#line 40 "dtc-parser.y"
 
 	char *propnodename;
 	char *literal;
@@ -65,16 +80,22 @@ typedef union YYSTYPE
 	uint8_t byte;
 	struct data data;
 
-	uint64_t addr;
-	cell_t cell;
+	struct {
+		struct data	data;
+		int		bits;
+	} array;
+
 	struct property *prop;
 	struct property *proplist;
 	struct node *node;
 	struct node *nodelist;
 	struct reserve_info *re;
+	uint64_t integer;
 
 
 
+/* Line 1676 of yacc.c  */
+#line 99 "dtc-parser.tab.h"
 } YYSTYPE;
 # define YYSTYPE_IS_TRIVIAL 1
 # define yystype YYSTYPE /* obsolescent; will be withdrawn */
diff --git a/scripts/dtc/dtc-parser.y b/scripts/dtc/dtc-parser.y
index 5e84a67..f412460 100644
--- a/scripts/dtc/dtc-parser.y
+++ b/scripts/dtc/dtc-parser.y
@@ -34,6 +34,7 @@ extern struct boot_info *the_boot_info;
 extern int treesource_error;
 
 static unsigned long long eval_literal(const char *s, int base, int bits);
+static unsigned char eval_char_literal(const char *s);
 %}
 
 %union {
@@ -44,19 +45,28 @@ static unsigned long long eval_literal(const char *s, int base, int bits);
 	uint8_t byte;
 	struct data data;
 
-	uint64_t addr;
-	cell_t cell;
+	struct {
+		struct data	data;
+		int		bits;
+	} array;
+
 	struct property *prop;
 	struct property *proplist;
 	struct node *node;
 	struct node *nodelist;
 	struct reserve_info *re;
+	uint64_t integer;
 }
 
 %token DT_V1
 %token DT_MEMRESERVE
+%token DT_LSHIFT DT_RSHIFT DT_LE DT_GE DT_EQ DT_NE DT_AND DT_OR
+%token DT_BITS
+%token DT_DEL_PROP
+%token DT_DEL_NODE
 %token <propnodename> DT_PROPNODENAME
 %token <literal> DT_LITERAL
+%token <literal> DT_CHAR_LITERAL
 %token <cbase> DT_BASE
 %token <byte> DT_BYTE
 %token <data> DT_STRING
@@ -68,9 +78,7 @@ static unsigned long long eval_literal(const char *s, int base, int bits);
 %type <data> propdataprefix
 %type <re> memreserve
 %type <re> memreserves
-%type <addr> addr
-%type <data> celllist
-%type <cell> cellval
+%type <array> arrayprefix
 %type <data> bytestring
 %type <prop> propdef
 %type <proplist> proplist
@@ -80,6 +88,21 @@ static unsigned long long eval_literal(const char *s, int base, int bits);
 %type <node> subnode
 %type <nodelist> subnodes
 
+%type <integer> integer_prim
+%type <integer> integer_unary
+%type <integer> integer_mul
+%type <integer> integer_add
+%type <integer> integer_shift
+%type <integer> integer_rela
+%type <integer> integer_eq
+%type <integer> integer_bitand
+%type <integer> integer_bitxor
+%type <integer> integer_bitor
+%type <integer> integer_and
+%type <integer> integer_or
+%type <integer> integer_trinary
+%type <integer> integer_expr
+
 %%
 
 sourcefile:
@@ -102,7 +125,7 @@ memreserves:
 	;
 
 memreserve:
-	  DT_MEMRESERVE addr addr ';'
+	  DT_MEMRESERVE integer_prim integer_prim ';'
 		{
 			$$ = build_reserve_entry($2, $3);
 		}
@@ -113,13 +136,6 @@ memreserve:
 		}
 	;
 
-addr:
-	  DT_LITERAL
-		{
-			$$ = eval_literal($1, 0, 64);
-		}
-	  ;
-
 devicetree:
 	  '/' nodedef
 		{
@@ -139,6 +155,17 @@ devicetree:
 				print_error("label or path, '%s', not found", $2);
 			$$ = $1;
 		}
+	| devicetree DT_DEL_NODE DT_REF ';'
+		{
+			struct node *target = get_node_by_ref($1, $3);
+
+			if (!target)
+				print_error("label or path, '%s', not found", $3);
+			else
+				delete_node(target);
+
+			$$ = $1;
+		}
 	;
 
 nodedef:
@@ -168,6 +195,10 @@ propdef:
 		{
 			$$ = build_property($1, empty_data);
 		}
+	| DT_DEL_PROP DT_PROPNODENAME ';'
+		{
+			$$ = build_property_delete($2);
+		}
 	| DT_LABEL propdef
 		{
 			add_label(&$2->labels, $1);
@@ -180,9 +211,9 @@ propdata:
 		{
 			$$ = data_merge($1, $2);
 		}
-	| propdataprefix '<' celllist '>'
+	| propdataprefix arrayprefix '>'
 		{
-			$$ = data_merge($1, $3);
+			$$ = data_merge($1, $2.data);
 		}
 	| propdataprefix '[' bytestring ']'
 		{
@@ -192,7 +223,7 @@ propdata:
 		{
 			$$ = data_add_marker($1, REF_PATH, $2);
 		}
-	| propdataprefix DT_INCBIN '(' DT_STRING ',' addr ',' addr ')'
+	| propdataprefix DT_INCBIN '(' DT_STRING ',' integer_prim ',' integer_prim ')'
 		{
 			FILE *f = srcfile_relative_open($4.val, NULL);
 			struct data d;
@@ -240,31 +271,154 @@ propdataprefix:
 		}
 	;
 
-celllist:
-	  /* empty */
+arrayprefix:
+	DT_BITS DT_LITERAL '<'
+		{
+			$$.data = empty_data;
+			$$.bits = eval_literal($2, 0, 7);
+
+			if (($$.bits !=  8) &&
+			    ($$.bits != 16) &&
+			    ($$.bits != 32) &&
+			    ($$.bits != 64))
+			{
+				print_error("Only 8, 16, 32 and 64-bit elements"
+					    " are currently supported");
+				$$.bits = 32;
+			}
+		}
+	| '<'
+		{
+			$$.data = empty_data;
+			$$.bits = 32;
+		}
+	| arrayprefix integer_prim
+		{
+			if ($1.bits < 64) {
+				uint64_t mask = (1ULL << $1.bits) - 1;
+				/*
+				 * Bits above mask must either be all zero
+				 * (positive within range of mask) or all one
+				 * (negative and sign-extended). The second
+				 * condition is true if when we set all bits
+				 * within the mask to one (i.e. | in the
+				 * mask), all bits are one.
+				 */
+				if (($2 > mask) && (($2 | mask) != -1ULL))
+					print_error(
+						"integer value out of range "
+						"%016lx (%d bits)", $1.bits);
+			}
+
+			$$.data = data_append_integer($1.data, $2, $1.bits);
+		}
+	| arrayprefix DT_REF
+		{
+			uint64_t val = ~0ULL >> (64 - $1.bits);
+
+			if ($1.bits == 32)
+				$1.data = data_add_marker($1.data,
+							  REF_PHANDLE,
+							  $2);
+			else
+				print_error("References are only allowed in "
+					    "arrays with 32-bit elements.");
+
+			$$.data = data_append_integer($1.data, val, $1.bits);
+		}
+	| arrayprefix DT_LABEL
 		{
-			$$ = empty_data;
+			$$.data = data_add_marker($1.data, LABEL, $2);
 		}
-	| celllist cellval
+	;
+
+integer_prim:
+	  DT_LITERAL
 		{
-			$$ = data_append_cell($1, $2);
+			$$ = eval_literal($1, 0, 64);
 		}
-	| celllist DT_REF
+	| DT_CHAR_LITERAL
 		{
-			$$ = data_append_cell(data_add_marker($1, REF_PHANDLE,
-							      $2), -1);
+			$$ = eval_char_literal($1);
 		}
-	| celllist DT_LABEL
+	| '(' integer_expr ')'
 		{
-			$$ = data_add_marker($1, LABEL, $2);
+			$$ = $2;
 		}
 	;
 
-cellval:
-	  DT_LITERAL
-		{
-			$$ = eval_literal($1, 0, 32);
-		}
+integer_expr:
+	integer_trinary
+	;
+
+integer_trinary:
+	  integer_or
+	| integer_or '?' integer_expr ':' integer_trinary { $$ = $1 ? $3 : $5; }
+	;
+
+integer_or:
+	  integer_and
+	| integer_or DT_OR integer_and { $$ = $1 || $3; }
+	;
+
+integer_and:
+	  integer_bitor
+	| integer_and DT_AND integer_bitor { $$ = $1 && $3; }
+	;
+
+integer_bitor:
+	  integer_bitxor
+	| integer_bitor '|' integer_bitxor { $$ = $1 | $3; }
+	;
+
+integer_bitxor:
+	  integer_bitand
+	| integer_bitxor '^' integer_bitand { $$ = $1 ^ $3; }
+	;
+
+integer_bitand:
+	  integer_eq
+	| integer_bitand '&' integer_eq { $$ = $1 & $3; }
+	;
+
+integer_eq:
+	  integer_rela
+	| integer_eq DT_EQ integer_rela { $$ = $1 == $3; }
+	| integer_eq DT_NE integer_rela { $$ = $1 != $3; }
+	;
+
+integer_rela:
+	  integer_shift
+	| integer_rela '<' integer_shift { $$ = $1 < $3; }
+	| integer_rela '>' integer_shift { $$ = $1 > $3; }
+	| integer_rela DT_LE integer_shift { $$ = $1 <= $3; }
+	| integer_rela DT_GE integer_shift { $$ = $1 >= $3; }
+	;
+
+integer_shift:
+	  integer_shift DT_LSHIFT integer_add { $$ = $1 << $3; }
+	| integer_shift DT_RSHIFT integer_add { $$ = $1 >> $3; }
+	| integer_add
+	;
+
+integer_add:
+	  integer_add '+' integer_mul { $$ = $1 + $3; }
+	| integer_add '-' integer_mul { $$ = $1 - $3; }
+	| integer_mul
+	;
+
+integer_mul:
+	  integer_mul '*' integer_unary { $$ = $1 * $3; }
+	| integer_mul '/' integer_unary { $$ = $1 / $3; }
+	| integer_mul '%' integer_unary { $$ = $1 % $3; }
+	| integer_unary
+	;
+
+integer_unary:
+	  integer_prim
+	| '-' integer_unary { $$ = -$2; }
+	| '~' integer_unary { $$ = ~$2; }
+	| '!' integer_unary { $$ = !$2; }
 	;
 
 bytestring:
@@ -303,6 +457,10 @@ subnode:
 		{
 			$$ = name_node($2, $1);
 		}
+	| DT_DEL_NODE DT_PROPNODENAME ';'
+		{
+			$$ = name_node(build_node_delete(), $2);
+		}
 	| DT_LABEL subnode
 		{
 			add_label(&$2->labels, $1);
@@ -334,12 +492,41 @@ static unsigned long long eval_literal(const char *s, int base, int bits)
 
 	errno = 0;
 	val = strtoull(s, &e, base);
-	if (*e)
-		print_error("bad characters in literal");
-	else if ((errno == ERANGE)
+	if (*e) {
+		size_t uls = strspn(e, "UL");
+		if (e[uls])
+			print_error("bad characters in literal");
+	}
+	if ((errno == ERANGE)
 		 || ((bits < 64) && (val >= (1ULL << bits))))
 		print_error("literal out of range");
 	else if (errno != 0)
 		print_error("bad literal");
 	return val;
 }
+
+static unsigned char eval_char_literal(const char *s)
+{
+	int i = 1;
+	char c = s[0];
+
+	if (c == '\0')
+	{
+		print_error("empty character literal");
+		return 0;
+	}
+
+	/*
+	 * If the first character in the character literal is a \ then process
+	 * the remaining characters as an escape encoding. If the first
+	 * character is neither an escape or a terminator it should be the only
+	 * character in the literal and will be returned.
+	 */
+	if (c == '\\')
+		c = get_escape_char(s, &i);
+
+	if (s[i] != '\0')
+		print_error("malformed character literal");
+
+	return c;
+}
diff --git a/scripts/dtc/dtc.c b/scripts/dtc/dtc.c
index 2ef5e2e..a375683 100644
--- a/scripts/dtc/dtc.c
+++ b/scripts/dtc/dtc.c
@@ -82,6 +82,8 @@ static void  __attribute__ ((noreturn)) usage(void)
 	fprintf(stderr, "\t\tSet the physical boot cpu\n");
 	fprintf(stderr, "\t-f\n");
 	fprintf(stderr, "\t\tForce - try to produce output even if the input tree has errors\n");
+	fprintf(stderr, "\t-i\n");
+	fprintf(stderr, "\t\tAdd a path to search for include files\n");
 	fprintf(stderr, "\t-s\n");
 	fprintf(stderr, "\t\tSort nodes and properties before outputting (only useful for\n\t\tcomparing trees)\n");
 	fprintf(stderr, "\t-v\n");
@@ -91,6 +93,9 @@ static void  __attribute__ ((noreturn)) usage(void)
 	fprintf(stderr, "\t\t\tlegacy - \"linux,phandle\" properties only\n");
 	fprintf(stderr, "\t\t\tepapr - \"phandle\" properties only\n");
 	fprintf(stderr, "\t\t\tboth - Both \"linux,phandle\" and \"phandle\" properties\n");
+	fprintf(stderr, "\t-W [no-]<checkname>\n");
+	fprintf(stderr, "\t-E [no-]<checkname>\n");
+	fprintf(stderr, "\t\t\tenable or disable warnings and errors\n");
 	exit(3);
 }
 
@@ -113,7 +118,7 @@ int main(int argc, char *argv[])
 	minsize    = 0;
 	padsize    = 0;
 
-	while ((opt = getopt(argc, argv, "hI:O:o:V:d:R:S:p:fcqb:vH:s"))
+	while ((opt = getopt(argc, argv, "hI:O:o:V:d:R:S:p:fqb:i:vH:sW:E:"))
 			!= EOF) {
 		switch (opt) {
 		case 'I':
@@ -149,6 +154,9 @@ int main(int argc, char *argv[])
 		case 'b':
 			cmdline_boot_cpuid = strtoll(optarg, NULL, 0);
 			break;
+		case 'i':
+			srcfile_add_search_path(optarg);
+			break;
 		case 'v':
 			printf("Version: %s\n", DTC_VERSION);
 			exit(0);
@@ -168,6 +176,14 @@ int main(int argc, char *argv[])
 			sort = 1;
 			break;
 
+		case 'W':
+			parse_checks_option(true, false, optarg);
+			break;
+
+		case 'E':
+			parse_checks_option(false, true, optarg);
+			break;
+
 		case 'h':
 		default:
 			usage();
@@ -188,9 +204,6 @@ int main(int argc, char *argv[])
 	if (minsize)
 		fprintf(stderr, "DTC: Use of \"-S\" is deprecated; it will be removed soon, use \"-p\" instead\n");
 
-	fprintf(stderr, "DTC: %s->%s  on file \"%s\"\n",
-		inform, outform, arg);
-
 	if (depname) {
 		depfile = fopen(depname, "w");
 		if (!depfile)
diff --git a/scripts/dtc/dtc.h b/scripts/dtc/dtc.h
index f37c97e..d501c86 100644
--- a/scripts/dtc/dtc.h
+++ b/scripts/dtc/dtc.h
@@ -25,6 +25,7 @@
 #include <string.h>
 #include <stdlib.h>
 #include <stdint.h>
+#include <stdbool.h>
 #include <stdarg.h>
 #include <assert.h>
 #include <ctype.h>
@@ -109,6 +110,7 @@ struct data data_insert_at_marker(struct data d, struct marker *m,
 				  const void *p, int len);
 struct data data_merge(struct data d1, struct data d2);
 struct data data_append_cell(struct data d, cell_t word);
+struct data data_append_integer(struct data d, uint64_t word, int bits);
 struct data data_append_re(struct data d, const struct fdt_reserve_entry *re);
 struct data data_append_addr(struct data d, uint64_t addr);
 struct data data_append_byte(struct data d, uint8_t byte);
@@ -126,11 +128,13 @@ int data_is_one_string(struct data d);
 
 /* Live trees */
 struct label {
+	int deleted;
 	char *label;
 	struct label *next;
 };
 
 struct property {
+	int deleted;
 	char *name;
 	struct data val;
 
@@ -140,6 +144,7 @@ struct property {
 };
 
 struct node {
+	int deleted;
 	char *name;
 	struct property *proplist;
 	struct node *children;
@@ -156,28 +161,71 @@ struct node {
 	struct label *labels;
 };
 
+static inline struct label *for_each_label_next(struct label *l)
+{
+	do {
+		l = l->next;
+	} while (l && l->deleted);
+
+	return l;
+}
+
 #define for_each_label(l0, l) \
+	for ((l) = (l0); (l); (l) = for_each_label_next(l))
+
+#define for_each_label_withdel(l0, l) \
 	for ((l) = (l0); (l); (l) = (l)->next)
 
+static inline struct property *for_each_property_next(struct property *p)
+{
+	do {
+		p = p->next;
+	} while (p && p->deleted);
+
+	return p;
+}
+
 #define for_each_property(n, p) \
+	for ((p) = (n)->proplist; (p); (p) = for_each_property_next(p))
+
+#define for_each_property_withdel(n, p) \
 	for ((p) = (n)->proplist; (p); (p) = (p)->next)
 
-#define for_each_child(n, c)	\
+static inline struct node *for_each_child_next(struct node *c)
+{
+	do {
+		c = c->next_sibling;
+	} while (c && c->deleted);
+
+	return c;
+}
+
+#define for_each_child(n, c) \
+	for ((c) = (n)->children; (c); (c) = for_each_child_next(c))
+
+#define for_each_child_withdel(n, c) \
 	for ((c) = (n)->children; (c); (c) = (c)->next_sibling)
 
 void add_label(struct label **labels, char *label);
+void delete_labels(struct label **labels);
 
 struct property *build_property(char *name, struct data val);
+struct property *build_property_delete(char *name);
 struct property *chain_property(struct property *first, struct property *list);
 struct property *reverse_properties(struct property *first);
 
 struct node *build_node(struct property *proplist, struct node *children);
+struct node *build_node_delete(void);
 struct node *name_node(struct node *node, char *name);
 struct node *chain_node(struct node *first, struct node *list);
 struct node *merge_nodes(struct node *old_node, struct node *new_node);
 
 void add_property(struct node *node, struct property *prop);
+void delete_property_by_name(struct node *node, char *name);
+void delete_property(struct property *prop);
 void add_child(struct node *parent, struct node *child);
+void delete_node_by_name(struct node *parent, char *name);
+void delete_node(struct node *node);
 
 const char *get_unitname(struct node *node);
 struct property *get_property(struct node *node, const char *propname);
@@ -224,6 +272,7 @@ void sort_tree(struct boot_info *bi);
 
 /* Checks */
 
+void parse_checks_option(bool warn, bool error, const char *optarg);
 void process_checks(int force, struct boot_info *bi);
 
 /* Flattened trees */
diff --git a/scripts/dtc/fdtdump.c b/scripts/dtc/fdtdump.c
new file mode 100644
index 0000000..207a46d
--- /dev/null
+++ b/scripts/dtc/fdtdump.c
@@ -0,0 +1,162 @@
+/*
+ * fdtdump.c - Contributed by Pantelis Antoniou <pantelis.antoniou AT gmail.com>
+ */
+
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <ctype.h>
+
+#include <fdt.h>
+#include <libfdt_env.h>
+
+#include "util.h"
+
+#define ALIGN(x, a)	(((x) + ((a) - 1)) & ~((a) - 1))
+#define PALIGN(p, a)	((void *)(ALIGN((unsigned long)(p), (a))))
+#define GET_CELL(p)	(p += 4, *((const uint32_t *)(p-4)))
+
+static void print_data(const char *data, int len)
+{
+	int i;
+	const char *p = data;
+
+	/* no data, don't print */
+	if (len == 0)
+		return;
+
+	if (util_is_printable_string(data, len)) {
+		printf(" = \"%s\"", (const char *)data);
+	} else if ((len % 4) == 0) {
+		printf(" = <");
+		for (i = 0; i < len; i += 4)
+			printf("0x%08x%s", fdt32_to_cpu(GET_CELL(p)),
+			       i < (len - 4) ? " " : "");
+		printf(">");
+	} else {
+		printf(" = [");
+		for (i = 0; i < len; i++)
+			printf("%02x%s", *p++, i < len - 1 ? " " : "");
+		printf("]");
+	}
+}
+
+static void dump_blob(void *blob)
+{
+	struct fdt_header *bph = blob;
+	uint32_t off_mem_rsvmap = fdt32_to_cpu(bph->off_mem_rsvmap);
+	uint32_t off_dt = fdt32_to_cpu(bph->off_dt_struct);
+	uint32_t off_str = fdt32_to_cpu(bph->off_dt_strings);
+	struct fdt_reserve_entry *p_rsvmap =
+		(struct fdt_reserve_entry *)((char *)blob + off_mem_rsvmap);
+	const char *p_struct = (const char *)blob + off_dt;
+	const char *p_strings = (const char *)blob + off_str;
+	uint32_t version = fdt32_to_cpu(bph->version);
+	uint32_t totalsize = fdt32_to_cpu(bph->totalsize);
+	uint32_t tag;
+	const char *p, *s, *t;
+	int depth, sz, shift;
+	int i;
+	uint64_t addr, size;
+
+	depth = 0;
+	shift = 4;
+
+	printf("/dts-v1/;\n");
+	printf("// magic:\t\t0x%x\n", fdt32_to_cpu(bph->magic));
+	printf("// totalsize:\t\t0x%x (%d)\n", totalsize, totalsize);
+	printf("// off_dt_struct:\t0x%x\n", off_dt);
+	printf("// off_dt_strings:\t0x%x\n", off_str);
+	printf("// off_mem_rsvmap:\t0x%x\n", off_mem_rsvmap);
+	printf("// version:\t\t%d\n", version);
+	printf("// last_comp_version:\t%d\n",
+	       fdt32_to_cpu(bph->last_comp_version));
+	if (version >= 2)
+		printf("// boot_cpuid_phys:\t0x%x\n",
+		       fdt32_to_cpu(bph->boot_cpuid_phys));
+
+	if (version >= 3)
+		printf("// size_dt_strings:\t0x%x\n",
+		       fdt32_to_cpu(bph->size_dt_strings));
+	if (version >= 17)
+		printf("// size_dt_struct:\t0x%x\n",
+		       fdt32_to_cpu(bph->size_dt_struct));
+	printf("\n");
+
+	for (i = 0; ; i++) {
+		addr = fdt64_to_cpu(p_rsvmap[i].address);
+		size = fdt64_to_cpu(p_rsvmap[i].size);
+		if (addr == 0 && size == 0)
+			break;
+
+		printf("/memreserve/ %llx %llx;\n",
+		       (unsigned long long)addr, (unsigned long long)size);
+	}
+
+	p = p_struct;
+	while ((tag = fdt32_to_cpu(GET_CELL(p))) != FDT_END) {
+
+		/* printf("tag: 0x%08x (%d)\n", tag, p - p_struct); */
+
+		if (tag == FDT_BEGIN_NODE) {
+			s = p;
+			p = PALIGN(p + strlen(s) + 1, 4);
+
+			if (*s == '\0')
+				s = "/";
+
+			printf("%*s%s {\n", depth * shift, "", s);
+
+			depth++;
+			continue;
+		}
+
+		if (tag == FDT_END_NODE) {
+			depth--;
+
+			printf("%*s};\n", depth * shift, "");
+			continue;
+		}
+
+		if (tag == FDT_NOP) {
+			printf("%*s// [NOP]\n", depth * shift, "");
+			continue;
+		}
+
+		if (tag != FDT_PROP) {
+			fprintf(stderr, "%*s ** Unknown tag 0x%08x\n", depth * shift, "", tag);
+			break;
+		}
+		sz = fdt32_to_cpu(GET_CELL(p));
+		s = p_strings + fdt32_to_cpu(GET_CELL(p));
+		if (version < 16 && sz >= 8)
+			p = PALIGN(p, 8);
+		t = p;
+
+		p = PALIGN(p + sz, 4);
+
+		printf("%*s%s", depth * shift, "", s);
+		print_data(t, sz);
+		printf(";\n");
+	}
+}
+
+
+int main(int argc, char *argv[])
+{
+	char *buf;
+
+	if (argc < 2) {
+		fprintf(stderr, "supply input filename\n");
+		return 5;
+	}
+
+	buf = utilfdt_read(argv[1]);
+	if (buf)
+		dump_blob(buf);
+	else
+		return 10;
+
+	return 0;
+}
diff --git a/scripts/dtc/fdtget.c b/scripts/dtc/fdtget.c
new file mode 100644
index 0000000..c2fbab2
--- /dev/null
+++ b/scripts/dtc/fdtget.c
@@ -0,0 +1,366 @@
+/*
+ * Copyright (c) 2011 The Chromium OS Authors. All rights reserved.
+ *
+ * Portions from U-Boot cmd_fdt.c (C) Copyright 2007
+ * Gerald Van Baren, Custom IDEAS, vanbaren@cideas.com
+ * Based on code written by:
+ *   Pantelis Antoniou <pantelis.antoniou@gmail.com> and
+ *   Matthew McClintock <msm@freescale.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of
+ * the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
+ * MA 02111-1307 USA
+ */
+
+#include <assert.h>
+#include <ctype.h>
+#include <getopt.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include <libfdt.h>
+
+#include "util.h"
+
+enum display_mode {
+	MODE_SHOW_VALUE,	/* show values for node properties */
+	MODE_LIST_PROPS,	/* list the properties for a node */
+	MODE_LIST_SUBNODES,	/* list the subnodes of a node */
+};
+
+/* Holds information which controls our output and options */
+struct display_info {
+	int type;		/* data type (s/i/u/x or 0 for default) */
+	int size;		/* data size (1/2/4) */
+	enum display_mode mode;	/* display mode that we are using */
+	const char *default_val; /* default value if node/property not found */
+};
+
+static void report_error(const char *where, int err)
+{
+	fprintf(stderr, "Error at '%s': %s\n", where, fdt_strerror(err));
+}
+
+/**
+ * Displays data of a given length according to selected options
+ *
+ * If a specific data type is provided in disp, then this is used. Otherwise
+ * we try to guess the data type / size from the contents.
+ *
+ * @param disp		Display information / options
+ * @param data		Data to display
+ * @param len		Maximum length of buffer
+ * @return 0 if ok, -1 if data does not match format
+ */
+static int show_data(struct display_info *disp, const char *data, int len)
+{
+	int i, size;
+	const uint8_t *p = (const uint8_t *)data;
+	const char *s;
+	int value;
+	int is_string;
+	char fmt[3];
+
+	/* no data, don't print */
+	if (len == 0)
+		return 0;
+
+	is_string = (disp->type) == 's' ||
+		(!disp->type && util_is_printable_string(data, len));
+	if (is_string) {
+		if (data[len - 1] != '\0') {
+			fprintf(stderr, "Unterminated string\n");
+			return -1;
+		}
+		for (s = data; s - data < len; s += strlen(s) + 1) {
+			if (s != data)
+				printf(" ");
+			printf("%s", (const char *)s);
+		}
+		return 0;
+	}
+	size = disp->size;
+	if (size == -1) {
+		size = (len % 4) == 0 ? 4 : 1;
+	} else if (len % size) {
+		fprintf(stderr, "Property length must be a multiple of "
+				"selected data size\n");
+		return -1;
+	}
+	fmt[0] = '%';
+	fmt[1] = disp->type ? disp->type : 'd';
+	fmt[2] = '\0';
+	for (i = 0; i < len; i += size, p += size) {
+		if (i)
+			printf(" ");
+		value = size == 4 ? fdt32_to_cpu(*(const uint32_t *)p) :
+			size == 2 ? (*p << 8) | p[1] : *p;
+		printf(fmt, value);
+	}
+	return 0;
+}
+
+/**
+ * List all properties in a node, one per line.
+ *
+ * @param blob		FDT blob
+ * @param node		Node to display
+ * @return 0 if ok, or FDT_ERR... if not.
+ */
+static int list_properties(const void *blob, int node)
+{
+	const struct fdt_property *data;
+	const char *name;
+	int prop;
+
+	prop = fdt_first_property_offset(blob, node);
+	do {
+		/* Stop silently when there are no more properties */
+		if (prop < 0)
+			return prop == -FDT_ERR_NOTFOUND ? 0 : prop;
+		data = fdt_get_property_by_offset(blob, prop, NULL);
+		name = fdt_string(blob, fdt32_to_cpu(data->nameoff));
+		if (name)
+			puts(name);
+		prop = fdt_next_property_offset(blob, prop);
+	} while (1);
+}
+
+#define MAX_LEVEL	32		/* how deeply nested we will go */
+
+/**
+ * List all subnodes in a node, one per line
+ *
+ * @param blob		FDT blob
+ * @param node		Node to display
+ * @return 0 if ok, or FDT_ERR... if not.
+ */
+static int list_subnodes(const void *blob, int node)
+{
+	int nextoffset;		/* next node offset from libfdt */
+	uint32_t tag;		/* current tag */
+	int level = 0;		/* keep track of nesting level */
+	const char *pathp;
+	int depth = 1;		/* the assumed depth of this node */
+
+	while (level >= 0) {
+		tag = fdt_next_tag(blob, node, &nextoffset);
+		switch (tag) {
+		case FDT_BEGIN_NODE:
+			pathp = fdt_get_name(blob, node, NULL);
+			if (level <= depth) {
+				if (pathp == NULL)
+					pathp = "/* NULL pointer error */";
+				if (*pathp == '\0')
+					pathp = "/";	/* root is nameless */
+				if (level == 1)
+					puts(pathp);
+			}
+			level++;
+			if (level >= MAX_LEVEL) {
+				printf("Nested too deep, aborting.\n");
+				return 1;
+			}
+			break;
+		case FDT_END_NODE:
+			level--;
+			if (level == 0)
+				level = -1;		/* exit the loop */
+			break;
+		case FDT_END:
+			return 1;
+		case FDT_PROP:
+			break;
+		default:
+			if (level <= depth)
+				printf("Unknown tag 0x%08X\n", tag);
+			return 1;
+		}
+		node = nextoffset;
+	}
+	return 0;
+}
+
+/**
+ * Show the data for a given node (and perhaps property) according to the
+ * display option provided.
+ *
+ * @param blob		FDT blob
+ * @param disp		Display information / options
+ * @param node		Node to display
+ * @param property	Name of property to display, or NULL if none
+ * @return 0 if ok, -ve on error
+ */
+static int show_data_for_item(const void *blob, struct display_info *disp,
+		int node, const char *property)
+{
+	const void *value = NULL;
+	int len, err = 0;
+
+	switch (disp->mode) {
+	case MODE_LIST_PROPS:
+		err = list_properties(blob, node);
+		break;
+
+	case MODE_LIST_SUBNODES:
+		err = list_subnodes(blob, node);
+		break;
+
+	default:
+		assert(property);
+		value = fdt_getprop(blob, node, property, &len);
+		if (value) {
+			if (show_data(disp, value, len))
+				err = -1;
+			else
+				printf("\n");
+		} else if (disp->default_val) {
+			puts(disp->default_val);
+		} else {
+			report_error(property, len);
+			err = -1;
+		}
+		break;
+	}
+
+	return err;
+}
+
+/**
+ * Run the main fdtget operation, given a filename and valid arguments
+ *
+ * @param disp		Display information / options
+ * @param filename	Filename of blob file
+ * @param arg		List of arguments to process
+ * @param arg_count	Number of arguments
+ * @param return 0 if ok, -ve on error
+ */
+static int do_fdtget(struct display_info *disp, const char *filename,
+		     char **arg, int arg_count, int args_per_step)
+{
+	char *blob;
+	const char *prop;
+	int i, node;
+
+	blob = utilfdt_read(filename);
+	if (!blob)
+		return -1;
+
+	for (i = 0; i + args_per_step <= arg_count; i += args_per_step) {
+		node = fdt_path_offset(blob, arg[i]);
+		if (node < 0) {
+			if (disp->default_val) {
+				puts(disp->default_val);
+				continue;
+			} else {
+				report_error(arg[i], node);
+				return -1;
+			}
+		}
+		prop = args_per_step == 1 ? NULL : arg[i + 1];
+
+		if (show_data_for_item(blob, disp, node, prop))
+			return -1;
+	}
+	return 0;
+}
+
+static const char *usage_msg =
+	"fdtget - read values from device tree\n"
+	"\n"
+	"Each value is printed on a new line.\n\n"
+	"Usage:\n"
+	"	fdtget <options> <dt file> [<node> <property>]...\n"
+	"	fdtget -p <options> <dt file> [<node> ]...\n"
+	"Options:\n"
+	"\t-t <type>\tType of data\n"
+	"\t-p\t\tList properties for each node\n"
+	"\t-l\t\tList subnodes for each node\n"
+	"\t-d\t\tDefault value to display when the property is "
+			"missing\n"
+	"\t-h\t\tPrint this help\n\n"
+	USAGE_TYPE_MSG;
+
+static void usage(const char *msg)
+{
+	if (msg)
+		fprintf(stderr, "Error: %s\n\n", msg);
+
+	fprintf(stderr, "%s", usage_msg);
+	exit(2);
+}
+
+int main(int argc, char *argv[])
+{
+	char *filename = NULL;
+	struct display_info disp;
+	int args_per_step = 2;
+
+	/* set defaults */
+	memset(&disp, '\0', sizeof(disp));
+	disp.size = -1;
+	disp.mode = MODE_SHOW_VALUE;
+	for (;;) {
+		int c = getopt(argc, argv, "d:hlpt:");
+		if (c == -1)
+			break;
+
+		switch (c) {
+		case 'h':
+		case '?':
+			usage(NULL);
+
+		case 't':
+			if (utilfdt_decode_type(optarg, &disp.type,
+					&disp.size))
+				usage("Invalid type string");
+			break;
+
+		case 'p':
+			disp.mode = MODE_LIST_PROPS;
+			args_per_step = 1;
+			break;
+
+		case 'l':
+			disp.mode = MODE_LIST_SUBNODES;
+			args_per_step = 1;
+			break;
+
+		case 'd':
+			disp.default_val = optarg;
+			break;
+		}
+	}
+
+	if (optind < argc)
+		filename = argv[optind++];
+	if (!filename)
+		usage("Missing filename");
+
+	argv += optind;
+	argc -= optind;
+
+	/* Allow no arguments, and silently succeed */
+	if (!argc)
+		return 0;
+
+	/* Check for node, property arguments */
+	if (args_per_step == 2 && (argc % 2))
+		usage("Must have an even number of arguments");
+
+	if (do_fdtget(&disp, filename, argv, argc, args_per_step))
+		return 1;
+	return 0;
+}
diff --git a/scripts/dtc/fdtput.c b/scripts/dtc/fdtput.c
new file mode 100644
index 0000000..f2197f5
--- /dev/null
+++ b/scripts/dtc/fdtput.c
@@ -0,0 +1,362 @@
+/*
+ * Copyright (c) 2011 The Chromium OS Authors. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of
+ * the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
+ * MA 02111-1307 USA
+ */
+
+#include <assert.h>
+#include <ctype.h>
+#include <getopt.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include <libfdt.h>
+
+#include "util.h"
+
+/* These are the operations we support */
+enum oper_type {
+	OPER_WRITE_PROP,		/* Write a property in a node */
+	OPER_CREATE_NODE,		/* Create a new node */
+};
+
+struct display_info {
+	enum oper_type oper;	/* operation to perform */
+	int type;		/* data type (s/i/u/x or 0 for default) */
+	int size;		/* data size (1/2/4) */
+	int verbose;		/* verbose output */
+	int auto_path;		/* automatically create all path components */
+};
+
+
+/**
+ * Report an error with a particular node.
+ *
+ * @param name		Node name to report error on
+ * @param namelen	Length of node name, or -1 to use entire string
+ * @param err		Error number to report (-FDT_ERR_...)
+ */
+static void report_error(const char *name, int namelen, int err)
+{
+	if (namelen == -1)
+		namelen = strlen(name);
+	fprintf(stderr, "Error at '%1.*s': %s\n", namelen, name,
+		fdt_strerror(err));
+}
+
+/**
+ * Encode a series of arguments in a property value.
+ *
+ * @param disp		Display information / options
+ * @param arg		List of arguments from command line
+ * @param arg_count	Number of arguments (may be 0)
+ * @param valuep	Returns buffer containing value
+ * @param *value_len	Returns length of value encoded
+ */
+static int encode_value(struct display_info *disp, char **arg, int arg_count,
+			char **valuep, int *value_len)
+{
+	char *value = NULL;	/* holding area for value */
+	int value_size = 0;	/* size of holding area */
+	char *ptr;		/* pointer to current value position */
+	int len;		/* length of this cell/string/byte */
+	int ival;
+	int upto;	/* the number of bytes we have written to buf */
+	char fmt[3];
+
+	upto = 0;
+
+	if (disp->verbose)
+		fprintf(stderr, "Decoding value:\n");
+
+	fmt[0] = '%';
+	fmt[1] = disp->type ? disp->type : 'd';
+	fmt[2] = '\0';
+	for (; arg_count > 0; arg++, arg_count--, upto += len) {
+		/* assume integer unless told otherwise */
+		if (disp->type == 's')
+			len = strlen(*arg) + 1;
+		else
+			len = disp->size == -1 ? 4 : disp->size;
+
+		/* enlarge our value buffer by a suitable margin if needed */
+		if (upto + len > value_size) {
+			value_size = (upto + len) + 500;
+			value = realloc(value, value_size);
+			if (!value) {
+				fprintf(stderr, "Out of mmory: cannot alloc "
+					"%d bytes\n", value_size);
+				return -1;
+			}
+		}
+
+		ptr = value + upto;
+		if (disp->type == 's') {
+			memcpy(ptr, *arg, len);
+			if (disp->verbose)
+				fprintf(stderr, "\tstring: '%s'\n", ptr);
+		} else {
+			int *iptr = (int *)ptr;
+			sscanf(*arg, fmt, &ival);
+			if (len == 4)
+				*iptr = cpu_to_fdt32(ival);
+			else
+				*ptr = (uint8_t)ival;
+			if (disp->verbose) {
+				fprintf(stderr, "\t%s: %d\n",
+					disp->size == 1 ? "byte" :
+					disp->size == 2 ? "short" : "int",
+					ival);
+			}
+		}
+	}
+	*value_len = upto;
+	*valuep = value;
+	if (disp->verbose)
+		fprintf(stderr, "Value size %d\n", upto);
+	return 0;
+}
+
+static int store_key_value(void *blob, const char *node_name,
+		const char *property, const char *buf, int len)
+{
+	int node;
+	int err;
+
+	node = fdt_path_offset(blob, node_name);
+	if (node < 0) {
+		report_error(node_name, -1, node);
+		return -1;
+	}
+
+	err = fdt_setprop(blob, node, property, buf, len);
+	if (err) {
+		report_error(property, -1, err);
+		return -1;
+	}
+	return 0;
+}
+
+/**
+ * Create paths as needed for all components of a path
+ *
+ * Any components of the path that do not exist are created. Errors are
+ * reported.
+ *
+ * @param blob		FDT blob to write into
+ * @param in_path	Path to process
+ * @return 0 if ok, -1 on error
+ */
+static int create_paths(void *blob, const char *in_path)
+{
+	const char *path = in_path;
+	const char *sep;
+	int node, offset = 0;
+
+	/* skip leading '/' */
+	while (*path == '/')
+		path++;
+
+	for (sep = path; *sep; path = sep + 1, offset = node) {
+		/* equivalent to strchrnul(), but it requires _GNU_SOURCE */
+		sep = strchr(path, '/');
+		if (!sep)
+			sep = path + strlen(path);
+
+		node = fdt_subnode_offset_namelen(blob, offset, path,
+				sep - path);
+		if (node == -FDT_ERR_NOTFOUND) {
+			node = fdt_add_subnode_namelen(blob, offset, path,
+						       sep - path);
+		}
+		if (node < 0) {
+			report_error(path, sep - path, node);
+			return -1;
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * Create a new node in the fdt.
+ *
+ * This will overwrite the node_name string. Any error is reported.
+ *
+ * TODO: Perhaps create fdt_path_offset_namelen() so we don't need to do this.
+ *
+ * @param blob		FDT blob to write into
+ * @param node_name	Name of node to create
+ * @return new node offset if found, or -1 on failure
+ */
+static int create_node(void *blob, const char *node_name)
+{
+	int node = 0;
+	char *p;
+
+	p = strrchr(node_name, '/');
+	if (!p) {
+		report_error(node_name, -1, -FDT_ERR_BADPATH);
+		return -1;
+	}
+	*p = '\0';
+
+	if (p > node_name) {
+		node = fdt_path_offset(blob, node_name);
+		if (node < 0) {
+			report_error(node_name, -1, node);
+			return -1;
+		}
+	}
+
+	node = fdt_add_subnode(blob, node, p + 1);
+	if (node < 0) {
+		report_error(p + 1, -1, node);
+		return -1;
+	}
+
+	return 0;
+}
+
+static int do_fdtput(struct display_info *disp, const char *filename,
+		    char **arg, int arg_count)
+{
+	char *value;
+	char *blob;
+	int len, ret = 0;
+
+	blob = utilfdt_read(filename);
+	if (!blob)
+		return -1;
+
+	switch (disp->oper) {
+	case OPER_WRITE_PROP:
+		/*
+		 * Convert the arguments into a single binary value, then
+		 * store them into the property.
+		 */
+		assert(arg_count >= 2);
+		if (disp->auto_path && create_paths(blob, *arg))
+			return -1;
+		if (encode_value(disp, arg + 2, arg_count - 2, &value, &len) ||
+			store_key_value(blob, *arg, arg[1], value, len))
+			ret = -1;
+		break;
+	case OPER_CREATE_NODE:
+		for (; ret >= 0 && arg_count--; arg++) {
+			if (disp->auto_path)
+				ret = create_paths(blob, *arg);
+			else
+				ret = create_node(blob, *arg);
+		}
+		break;
+	}
+	if (ret >= 0)
+		ret = utilfdt_write(filename, blob);
+
+	free(blob);
+	return ret;
+}
+
+static const char *usage_msg =
+	"fdtput - write a property value to a device tree\n"
+	"\n"
+	"The command line arguments are joined together into a single value.\n"
+	"\n"
+	"Usage:\n"
+	"	fdtput <options> <dt file> <node> <property> [<value>...]\n"
+	"	fdtput -c <options> <dt file> [<node>...]\n"
+	"Options:\n"
+	"\t-c\t\tCreate nodes if they don't already exist\n"
+	"\t-p\t\tAutomatically create nodes as needed for the node path\n"
+	"\t-t <type>\tType of data\n"
+	"\t-v\t\tVerbose: display each value decoded from command line\n"
+	"\t-h\t\tPrint this help\n\n"
+	USAGE_TYPE_MSG;
+
+static void usage(const char *msg)
+{
+	if (msg)
+		fprintf(stderr, "Error: %s\n\n", msg);
+
+	fprintf(stderr, "%s", usage_msg);
+	exit(2);
+}
+
+int main(int argc, char *argv[])
+{
+	struct display_info disp;
+	char *filename = NULL;
+
+	memset(&disp, '\0', sizeof(disp));
+	disp.size = -1;
+	disp.oper = OPER_WRITE_PROP;
+	for (;;) {
+		int c = getopt(argc, argv, "chpt:v");
+		if (c == -1)
+			break;
+
+		/*
+		 * TODO: add options to:
+		 * - delete property
+		 * - delete node (optionally recursively)
+		 * - rename node
+		 * - pack fdt before writing
+		 * - set amount of free space when writing
+		 * - expand fdt if value doesn't fit
+		 */
+		switch (c) {
+		case 'c':
+			disp.oper = OPER_CREATE_NODE;
+			break;
+		case 'h':
+		case '?':
+			usage(NULL);
+		case 'p':
+			disp.auto_path = 1;
+			break;
+		case 't':
+			if (utilfdt_decode_type(optarg, &disp.type,
+					&disp.size))
+				usage("Invalid type string");
+			break;
+
+		case 'v':
+			disp.verbose = 1;
+			break;
+		}
+	}
+
+	if (optind < argc)
+		filename = argv[optind++];
+	if (!filename)
+		usage("Missing filename");
+
+	argv += optind;
+	argc -= optind;
+
+	if (disp.oper == OPER_WRITE_PROP) {
+		if (argc < 1)
+			usage("Missing node");
+		if (argc < 2)
+			usage("Missing property");
+	}
+
+	if (do_fdtput(&disp, filename, argv, argc))
+		return 1;
+	return 0;
+}
diff --git a/scripts/dtc/flattree.c b/scripts/dtc/flattree.c
index 28d0b23..665dad7 100644
--- a/scripts/dtc/flattree.c
+++ b/scripts/dtc/flattree.c
@@ -263,6 +263,9 @@ static void flatten_tree(struct node *tree, struct emitter *emit,
 	struct node *child;
 	int seen_name_prop = 0;
 
+	if (tree->deleted)
+		return;
+
 	emit->beginnode(etarget, tree->labels);
 
 	if (vi->flags & FTF_FULLPATH)
diff --git a/scripts/dtc/libfdt/Makefile.libfdt b/scripts/dtc/libfdt/Makefile.libfdt
index 6c42acf..91126c0 100644
--- a/scripts/dtc/libfdt/Makefile.libfdt
+++ b/scripts/dtc/libfdt/Makefile.libfdt
@@ -3,6 +3,8 @@
 # This is not a complete Makefile of itself.  Instead, it is designed to
 # be easily embeddable into other systems of Makefiles.
 #
-LIBFDT_INCLUDES = fdt.h libfdt.h
-LIBFDT_SRCS = fdt.c fdt_ro.c fdt_wip.c fdt_sw.c fdt_rw.c fdt_strerror.c
+LIBFDT_soname = libfdt.$(SHAREDLIB_EXT).1
+LIBFDT_INCLUDES = fdt.h libfdt.h libfdt_env.h
+LIBFDT_VERSION = version.lds
+LIBFDT_SRCS = fdt.c fdt_ro.c fdt_wip.c fdt_sw.c fdt_rw.c fdt_strerror.c fdt_empty_tree.c
 LIBFDT_OBJS = $(LIBFDT_SRCS:%.c=%.o)
diff --git a/scripts/dtc/libfdt/fdt.c b/scripts/dtc/libfdt/fdt.c
index 2acaec5..e56833a 100644
--- a/scripts/dtc/libfdt/fdt.c
+++ b/scripts/dtc/libfdt/fdt.c
@@ -74,7 +74,7 @@ int fdt_check_header(const void *fdt)
 	return 0;
 }
 
-const void *fdt_offset_ptr(const void *fdt, int offset, int len)
+const void *fdt_offset_ptr(const void *fdt, int offset, unsigned int len)
 {
 	const char *p;
 
@@ -90,42 +90,53 @@ const void *fdt_offset_ptr(const void *fdt, int offset, int len)
 	return p;
 }
 
-uint32_t fdt_next_tag(const void *fdt, int offset, int *nextoffset)
+uint32_t fdt_next_tag(const void *fdt, int startoffset, int *nextoffset)
 {
 	const uint32_t *tagp, *lenp;
 	uint32_t tag;
+	int offset = startoffset;
 	const char *p;
 
-	if (offset % FDT_TAGSIZE)
-		return -1;
-
+	*nextoffset = -FDT_ERR_TRUNCATED;
 	tagp = fdt_offset_ptr(fdt, offset, FDT_TAGSIZE);
-	if (! tagp)
+	if (!tagp)
 		return FDT_END; /* premature end */
 	tag = fdt32_to_cpu(*tagp);
 	offset += FDT_TAGSIZE;
 
+	*nextoffset = -FDT_ERR_BADSTRUCTURE;
 	switch (tag) {
 	case FDT_BEGIN_NODE:
 		/* skip name */
 		do {
 			p = fdt_offset_ptr(fdt, offset++, 1);
 		} while (p && (*p != '\0'));
-		if (! p)
-			return FDT_END;
+		if (!p)
+			return FDT_END; /* premature end */
 		break;
+
 	case FDT_PROP:
 		lenp = fdt_offset_ptr(fdt, offset, sizeof(*lenp));
-		if (! lenp)
-			return FDT_END;
-		/* skip name offset, length and value */
-		offset += 2*FDT_TAGSIZE + fdt32_to_cpu(*lenp);
+		if (!lenp)
+			return FDT_END; /* premature end */
+		/* skip-name offset, length and value */
+		offset += sizeof(struct fdt_property) - FDT_TAGSIZE
+			+ fdt32_to_cpu(*lenp);
+		break;
+
+	case FDT_END:
+	case FDT_END_NODE:
+	case FDT_NOP:
 		break;
+
+	default:
+		return FDT_END;
 	}
 
-	if (nextoffset)
-		*nextoffset = FDT_TAGALIGN(offset);
+	if (!fdt_offset_ptr(fdt, startoffset, offset - startoffset))
+		return FDT_END; /* premature end */
 
+	*nextoffset = FDT_TAGALIGN(offset);
 	return tag;
 }
 
@@ -138,6 +149,15 @@ int _fdt_check_node_offset(const void *fdt, int offset)
 	return offset;
 }
 
+int _fdt_check_prop_offset(const void *fdt, int offset)
+{
+	if ((offset < 0) || (offset % FDT_TAGSIZE)
+	    || (fdt_next_tag(fdt, offset, &offset) != FDT_PROP))
+		return -FDT_ERR_BADOFFSET;
+
+	return offset;
+}
+
 int fdt_next_node(const void *fdt, int offset, int *depth)
 {
 	int nextoffset = 0;
@@ -162,15 +182,16 @@ int fdt_next_node(const void *fdt, int offset, int *depth)
 			break;
 
 		case FDT_END_NODE:
-			if (depth)
-				(*depth)--;
+			if (depth && ((--(*depth)) < 0))
+				return nextoffset;
 			break;
 
 		case FDT_END:
-			return -FDT_ERR_NOTFOUND;
-
-		default:
-			return -FDT_ERR_BADSTRUCTURE;
+			if ((nextoffset >= 0)
+			    || ((nextoffset == -FDT_ERR_TRUNCATED) && !depth))
+				return -FDT_ERR_NOTFOUND;
+			else
+				return nextoffset;
 		}
 	} while (tag != FDT_BEGIN_NODE);
 
diff --git a/scripts/dtc/libfdt/fdt_empty_tree.c b/scripts/dtc/libfdt/fdt_empty_tree.c
new file mode 100644
index 0000000..f72d13b
--- /dev/null
+++ b/scripts/dtc/libfdt/fdt_empty_tree.c
@@ -0,0 +1,84 @@
+/*
+ * libfdt - Flat Device Tree manipulation
+ * Copyright (C) 2012 David Gibson, IBM Corporation.
+ *
+ * libfdt is dual licensed: you can use it either under the terms of
+ * the GPL, or the BSD license, at your option.
+ *
+ *  a) This library is free software; you can redistribute it and/or
+ *     modify it under the terms of the GNU General Public License as
+ *     published by the Free Software Foundation; either version 2 of the
+ *     License, or (at your option) any later version.
+ *
+ *     This library is distributed in the hope that it will be useful,
+ *     but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *     GNU General Public License for more details.
+ *
+ *     You should have received a copy of the GNU General Public
+ *     License along with this library; if not, write to the Free
+ *     Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston,
+ *     MA 02110-1301 USA
+ *
+ * Alternatively,
+ *
+ *  b) Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *     1. Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *     2. Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ *     THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
+ *     CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
+ *     INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
+ *     MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
+ *     DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
+ *     CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ *     SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
+ *     NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
+ *     LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ *     HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
+ *     CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
+ *     OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
+ *     EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+#include "libfdt_env.h"
+
+#include <fdt.h>
+#include <libfdt.h>
+
+#include "libfdt_internal.h"
+
+int fdt_create_empty_tree(void *buf, int bufsize)
+{
+	int err;
+
+	err = fdt_create(buf, bufsize);
+	if (err)
+		return err;
+
+	err = fdt_finish_reservemap(buf);
+	if (err)
+		return err;
+
+	err = fdt_begin_node(buf, "");
+	if (err)
+		return err;
+
+	err =  fdt_end_node(buf);
+	if (err)
+		return err;
+
+	err = fdt_finish(buf);
+	if (err)
+		return err;
+
+	return fdt_open_into(buf, buf, bufsize);
+}
+
diff --git a/scripts/dtc/libfdt/fdt_ro.c b/scripts/dtc/libfdt/fdt_ro.c
index 22e6929..02b6d68 100644
--- a/scripts/dtc/libfdt/fdt_ro.c
+++ b/scripts/dtc/libfdt/fdt_ro.c
@@ -80,6 +80,14 @@ const char *fdt_string(const void *fdt, int stroffset)
 	return (const char *)fdt + fdt_off_dt_strings(fdt) + stroffset;
 }
 
+static int _fdt_string_eq(const void *fdt, int stroffset,
+			  const char *s, int len)
+{
+	const char *p = fdt_string(fdt, stroffset);
+
+	return (strlen(p) == len) && (memcmp(p, s, len) == 0);
+}
+
 int fdt_get_mem_rsv(const void *fdt, int n, uint64_t *address, uint64_t *size)
 {
 	FDT_CHECK_HEADER(fdt);
@@ -97,6 +105,30 @@ int fdt_num_mem_rsv(const void *fdt)
 	return i;
 }
 
+static int _nextprop(const void *fdt, int offset)
+{
+	uint32_t tag;
+	int nextoffset;
+
+	do {
+		tag = fdt_next_tag(fdt, offset, &nextoffset);
+
+		switch (tag) {
+		case FDT_END:
+			if (nextoffset >= 0)
+				return -FDT_ERR_BADSTRUCTURE;
+			else
+				return nextoffset;
+
+		case FDT_PROP:
+			return offset;
+		}
+		offset = nextoffset;
+	} while (tag == FDT_NOP);
+
+	return -FDT_ERR_NOTFOUND;
+}
+
 int fdt_subnode_offset_namelen(const void *fdt, int offset,
 			       const char *name, int namelen)
 {
@@ -104,20 +136,16 @@ int fdt_subnode_offset_namelen(const void *fdt, int offset,
 
 	FDT_CHECK_HEADER(fdt);
 
-	for (depth = 0, offset = fdt_next_node(fdt, offset, &depth);
-	     (offset >= 0) && (depth > 0);
-	     offset = fdt_next_node(fdt, offset, &depth)) {
-		if (depth < 0)
-			return -FDT_ERR_NOTFOUND;
-		else if ((depth == 1)
-			 && _fdt_nodename_eq(fdt, offset, name, namelen))
+	for (depth = 0;
+	     (offset >= 0) && (depth >= 0);
+	     offset = fdt_next_node(fdt, offset, &depth))
+		if ((depth == 1)
+		    && _fdt_nodename_eq(fdt, offset, name, namelen))
 			return offset;
-	}
 
-	if (offset < 0)
-		return offset; /* error */
-	else
+	if (depth < 0)
 		return -FDT_ERR_NOTFOUND;
+	return offset; /* error */
 }
 
 int fdt_subnode_offset(const void *fdt, int parentoffset,
@@ -134,8 +162,20 @@ int fdt_path_offset(const void *fdt, const char *path)
 
 	FDT_CHECK_HEADER(fdt);
 
-	if (*path != '/')
-		return -FDT_ERR_BADPATH;
+	/* see if we have an alias */
+	if (*path != '/') {
+		const char *q = strchr(path, '/');
+
+		if (!q)
+			q = end;
+
+		p = fdt_get_alias_namelen(fdt, p, q - p);
+		if (!p)
+			return -FDT_ERR_BADPATH;
+		offset = fdt_path_offset(fdt, p);
+
+		p = q;
+	}
 
 	while (*p) {
 		const char *q;
@@ -178,93 +218,142 @@ const char *fdt_get_name(const void *fdt, int nodeoffset, int *len)
 	return NULL;
 }
 
-const struct fdt_property *fdt_get_property(const void *fdt,
-					    int nodeoffset,
-					    const char *name, int *lenp)
+int fdt_first_property_offset(const void *fdt, int nodeoffset)
+{
+	int offset;
+
+	if ((offset = _fdt_check_node_offset(fdt, nodeoffset)) < 0)
+		return offset;
+
+	return _nextprop(fdt, offset);
+}
+
+int fdt_next_property_offset(const void *fdt, int offset)
+{
+	if ((offset = _fdt_check_prop_offset(fdt, offset)) < 0)
+		return offset;
+
+	return _nextprop(fdt, offset);
+}
+
+const struct fdt_property *fdt_get_property_by_offset(const void *fdt,
+						      int offset,
+						      int *lenp)
 {
-	uint32_t tag;
-	const struct fdt_property *prop;
-	int namestroff;
-	int offset, nextoffset;
 	int err;
+	const struct fdt_property *prop;
 
-	if (((err = fdt_check_header(fdt)) != 0)
-	    || ((err = _fdt_check_node_offset(fdt, nodeoffset)) < 0))
-			goto fail;
+	if ((err = _fdt_check_prop_offset(fdt, offset)) < 0) {
+		if (lenp)
+			*lenp = err;
+		return NULL;
+	}
 
-	nextoffset = err;
-	do {
-		offset = nextoffset;
+	prop = _fdt_offset_ptr(fdt, offset);
 
-		tag = fdt_next_tag(fdt, offset, &nextoffset);
-		switch (tag) {
-		case FDT_END:
-			err = -FDT_ERR_TRUNCATED;
-			goto fail;
+	if (lenp)
+		*lenp = fdt32_to_cpu(prop->len);
 
-		case FDT_BEGIN_NODE:
-		case FDT_END_NODE:
-		case FDT_NOP:
-			break;
+	return prop;
+}
 
-		case FDT_PROP:
-			err = -FDT_ERR_BADSTRUCTURE;
-			prop = fdt_offset_ptr(fdt, offset, sizeof(*prop));
-			if (! prop)
-				goto fail;
-			namestroff = fdt32_to_cpu(prop->nameoff);
-			if (strcmp(fdt_string(fdt, namestroff), name) == 0) {
-				/* Found it! */
-				int len = fdt32_to_cpu(prop->len);
-				prop = fdt_offset_ptr(fdt, offset,
-						      sizeof(*prop)+len);
-				if (! prop)
-					goto fail;
-
-				if (lenp)
-					*lenp = len;
-
-				return prop;
-			}
-			break;
+const struct fdt_property *fdt_get_property_namelen(const void *fdt,
+						    int offset,
+						    const char *name,
+						    int namelen, int *lenp)
+{
+	for (offset = fdt_first_property_offset(fdt, offset);
+	     (offset >= 0);
+	     (offset = fdt_next_property_offset(fdt, offset))) {
+		const struct fdt_property *prop;
 
-		default:
-			err = -FDT_ERR_BADSTRUCTURE;
-			goto fail;
+		if (!(prop = fdt_get_property_by_offset(fdt, offset, lenp))) {
+			offset = -FDT_ERR_INTERNAL;
+			break;
 		}
-	} while ((tag != FDT_BEGIN_NODE) && (tag != FDT_END_NODE));
+		if (_fdt_string_eq(fdt, fdt32_to_cpu(prop->nameoff),
+				   name, namelen))
+			return prop;
+	}
 
-	err = -FDT_ERR_NOTFOUND;
- fail:
 	if (lenp)
-		*lenp = err;
+		*lenp = offset;
 	return NULL;
 }
 
-const void *fdt_getprop(const void *fdt, int nodeoffset,
-		  const char *name, int *lenp)
+const struct fdt_property *fdt_get_property(const void *fdt,
+					    int nodeoffset,
+					    const char *name, int *lenp)
+{
+	return fdt_get_property_namelen(fdt, nodeoffset, name,
+					strlen(name), lenp);
+}
+
+const void *fdt_getprop_namelen(const void *fdt, int nodeoffset,
+				const char *name, int namelen, int *lenp)
 {
 	const struct fdt_property *prop;
 
-	prop = fdt_get_property(fdt, nodeoffset, name, lenp);
+	prop = fdt_get_property_namelen(fdt, nodeoffset, name, namelen, lenp);
 	if (! prop)
 		return NULL;
 
 	return prop->data;
 }
 
+const void *fdt_getprop_by_offset(const void *fdt, int offset,
+				  const char **namep, int *lenp)
+{
+	const struct fdt_property *prop;
+
+	prop = fdt_get_property_by_offset(fdt, offset, lenp);
+	if (!prop)
+		return NULL;
+	if (namep)
+		*namep = fdt_string(fdt, fdt32_to_cpu(prop->nameoff));
+	return prop->data;
+}
+
+const void *fdt_getprop(const void *fdt, int nodeoffset,
+			const char *name, int *lenp)
+{
+	return fdt_getprop_namelen(fdt, nodeoffset, name, strlen(name), lenp);
+}
+
 uint32_t fdt_get_phandle(const void *fdt, int nodeoffset)
 {
 	const uint32_t *php;
 	int len;
 
-	php = fdt_getprop(fdt, nodeoffset, "linux,phandle", &len);
-	if (!php || (len != sizeof(*php)))
-		return 0;
+	/* FIXME: This is a bit sub-optimal, since we potentially scan
+	 * over all the properties twice. */
+	php = fdt_getprop(fdt, nodeoffset, "phandle", &len);
+	if (!php || (len != sizeof(*php))) {
+		php = fdt_getprop(fdt, nodeoffset, "linux,phandle", &len);
+		if (!php || (len != sizeof(*php)))
+			return 0;
+	}
 
 	return fdt32_to_cpu(*php);
 }
 
+const char *fdt_get_alias_namelen(const void *fdt,
+				  const char *name, int namelen)
+{
+	int aliasoffset;
+
+	aliasoffset = fdt_path_offset(fdt, "/aliases");
+	if (aliasoffset < 0)
+		return NULL;
+
+	return fdt_getprop_namelen(fdt, aliasoffset, name, namelen, NULL);
+}
+
+const char *fdt_get_alias(const void *fdt, const char *name)
+{
+	return fdt_get_alias_namelen(fdt, name, strlen(name));
+}
+
 int fdt_get_path(const void *fdt, int nodeoffset, char *buf, int buflen)
 {
 	int pdepth = 0, p = 0;
@@ -279,9 +368,6 @@ int fdt_get_path(const void *fdt, int nodeoffset, char *buf, int buflen)
 	for (offset = 0, depth = 0;
 	     (offset >= 0) && (offset <= nodeoffset);
 	     offset = fdt_next_node(fdt, offset, &depth)) {
-		if (pdepth < depth)
-			continue; /* overflowed buffer */
-
 		while (pdepth > depth) {
 			do {
 				p--;
@@ -289,14 +375,16 @@ int fdt_get_path(const void *fdt, int nodeoffset, char *buf, int buflen)
 			pdepth--;
 		}
 
-		name = fdt_get_name(fdt, offset, &namelen);
-		if (!name)
-			return namelen;
-		if ((p + namelen + 1) <= buflen) {
-			memcpy(buf + p, name, namelen);
-			p += namelen;
-			buf[p++] = '/';
-			pdepth++;
+		if (pdepth >= depth) {
+			name = fdt_get_name(fdt, offset, &namelen);
+			if (!name)
+				return namelen;
+			if ((p + namelen + 1) <= buflen) {
+				memcpy(buf + p, name, namelen);
+				p += namelen;
+				buf[p++] = '/';
+				pdepth++;
+			}
 		}
 
 		if (offset == nodeoffset) {
@@ -306,7 +394,7 @@ int fdt_get_path(const void *fdt, int nodeoffset, char *buf, int buflen)
 			if (p > 1) /* special case so that root path is "/", not "" */
 				p--;
 			buf[p] = '\0';
-			return p;
+			return 0;
 		}
 	}
 
@@ -404,14 +492,31 @@ int fdt_node_offset_by_prop_value(const void *fdt, int startoffset,
 
 int fdt_node_offset_by_phandle(const void *fdt, uint32_t phandle)
 {
+	int offset;
+
 	if ((phandle == 0) || (phandle == -1))
 		return -FDT_ERR_BADPHANDLE;
-	phandle = cpu_to_fdt32(phandle);
-	return fdt_node_offset_by_prop_value(fdt, -1, "linux,phandle",
-					     &phandle, sizeof(phandle));
+
+	FDT_CHECK_HEADER(fdt);
+
+	/* FIXME: The algorithm here is pretty horrible: we
+	 * potentially scan each property of a node in
+	 * fdt_get_phandle(), then if that didn't find what
+	 * we want, we scan over them again making our way to the next
+	 * node.  Still it's the easiest to implement approach;
+	 * performance can come later. */
+	for (offset = fdt_next_node(fdt, -1, NULL);
+	     offset >= 0;
+	     offset = fdt_next_node(fdt, offset, NULL)) {
+		if (fdt_get_phandle(fdt, offset) == phandle)
+			return offset;
+	}
+
+	return offset; /* error from fdt_next_node() */
 }
 
-static int _stringlist_contains(const char *strlist, int listlen, const char *str)
+static int _fdt_stringlist_contains(const char *strlist, int listlen,
+				    const char *str)
 {
 	int len = strlen(str);
 	const char *p;
@@ -437,7 +542,7 @@ int fdt_node_check_compatible(const void *fdt, int nodeoffset,
 	prop = fdt_getprop(fdt, nodeoffset, "compatible", &len);
 	if (!prop)
 		return len;
-	if (_stringlist_contains(prop, len, compatible))
+	if (_fdt_stringlist_contains(prop, len, compatible))
 		return 0;
 	else
 		return 1;
diff --git a/scripts/dtc/libfdt/fdt_rw.c b/scripts/dtc/libfdt/fdt_rw.c
index 8e7ec4c..24437df 100644
--- a/scripts/dtc/libfdt/fdt_rw.c
+++ b/scripts/dtc/libfdt/fdt_rw.c
@@ -289,6 +289,33 @@ int fdt_setprop(void *fdt, int nodeoffset, const char *name,
 	return 0;
 }
 
+int fdt_appendprop(void *fdt, int nodeoffset, const char *name,
+		   const void *val, int len)
+{
+	struct fdt_property *prop;
+	int err, oldlen, newlen;
+
+	FDT_RW_CHECK_HEADER(fdt);
+
+	prop = fdt_get_property_w(fdt, nodeoffset, name, &oldlen);
+	if (prop) {
+		newlen = len + oldlen;
+		err = _fdt_splice_struct(fdt, prop->data,
+					 FDT_TAGALIGN(oldlen),
+					 FDT_TAGALIGN(newlen));
+		if (err)
+			return err;
+		prop->len = cpu_to_fdt32(newlen);
+		memcpy(prop->data + oldlen, val, len);
+	} else {
+		err = _fdt_add_property(fdt, nodeoffset, name, len, &prop);
+		if (err)
+			return err;
+		memcpy(prop->data, val, len);
+	}
+	return 0;
+}
+
 int fdt_delprop(void *fdt, int nodeoffset, const char *name)
 {
 	struct fdt_property *prop;
@@ -406,6 +433,8 @@ int fdt_open_into(const void *fdt, void *buf, int bufsize)
 		struct_size = 0;
 		while (fdt_next_tag(fdt, struct_size, &struct_size) != FDT_END)
 			;
+		if (struct_size < 0)
+			return struct_size;
 	}
 
 	if (!_fdt_blocks_misordered(fdt, mem_rsv_size, struct_size)) {
diff --git a/scripts/dtc/libfdt/fdt_sw.c b/scripts/dtc/libfdt/fdt_sw.c
index 698329e..55ebebf 100644
--- a/scripts/dtc/libfdt/fdt_sw.c
+++ b/scripts/dtc/libfdt/fdt_sw.c
@@ -70,7 +70,7 @@ static int _fdt_sw_check_header(void *fdt)
 			return err; \
 	}
 
-static void *_fdt_grab_space(void *fdt, int len)
+static void *_fdt_grab_space(void *fdt, size_t len)
 {
 	int offset = fdt_size_dt_struct(fdt);
 	int spaceleft;
@@ -82,7 +82,7 @@ static void *_fdt_grab_space(void *fdt, int len)
 		return NULL;
 
 	fdt_set_size_dt_struct(fdt, offset + len);
-	return fdt_offset_ptr_w(fdt, offset, len);
+	return _fdt_offset_ptr_w(fdt, offset);
 }
 
 int fdt_create(void *buf, int bufsize)
@@ -237,18 +237,17 @@ int fdt_finish(void *fdt)
 	while ((tag = fdt_next_tag(fdt, offset, &nextoffset)) != FDT_END) {
 		if (tag == FDT_PROP) {
 			struct fdt_property *prop =
-				fdt_offset_ptr_w(fdt, offset, sizeof(*prop));
+				_fdt_offset_ptr_w(fdt, offset);
 			int nameoff;
 
-			if (! prop)
-				return -FDT_ERR_BADSTRUCTURE;
-
 			nameoff = fdt32_to_cpu(prop->nameoff);
 			nameoff += fdt_size_dt_strings(fdt);
 			prop->nameoff = cpu_to_fdt32(nameoff);
 		}
 		offset = nextoffset;
 	}
+	if (nextoffset < 0)
+		return nextoffset;
 
 	/* Finally, adjust the header */
 	fdt_set_totalsize(fdt, newstroffset + fdt_size_dt_strings(fdt));
diff --git a/scripts/dtc/libfdt/fdt_wip.c b/scripts/dtc/libfdt/fdt_wip.c
index a4652c6..6025fa1 100644
--- a/scripts/dtc/libfdt/fdt_wip.c
+++ b/scripts/dtc/libfdt/fdt_wip.c
@@ -94,41 +94,14 @@ int fdt_nop_property(void *fdt, int nodeoffset, const char *name)
 	return 0;
 }
 
-int _fdt_node_end_offset(void *fdt, int nodeoffset)
+int _fdt_node_end_offset(void *fdt, int offset)
 {
-	int level = 0;
-	uint32_t tag;
-	int offset, nextoffset;
-
-	tag = fdt_next_tag(fdt, nodeoffset, &nextoffset);
-	if (tag != FDT_BEGIN_NODE)
-		return -FDT_ERR_BADOFFSET;
-	do {
-		offset = nextoffset;
-		tag = fdt_next_tag(fdt, offset, &nextoffset);
-
-		switch (tag) {
-		case FDT_END:
-			return offset;
-
-		case FDT_BEGIN_NODE:
-			level++;
-			break;
-
-		case FDT_END_NODE:
-			level--;
-			break;
-
-		case FDT_PROP:
-		case FDT_NOP:
-			break;
-
-		default:
-			return -FDT_ERR_BADSTRUCTURE;
-		}
-	} while (level >= 0);
-
-	return nextoffset;
+	int depth = 0;
+
+	while ((offset >= 0) && (depth >= 0))
+		offset = fdt_next_node(fdt, offset, &depth);
+
+	return offset;
 }
 
 int fdt_nop_node(void *fdt, int nodeoffset)
diff --git a/scripts/dtc/libfdt/libfdt.h b/scripts/dtc/libfdt/libfdt.h
index ff6246f..73f4975 100644
--- a/scripts/dtc/libfdt/libfdt.h
+++ b/scripts/dtc/libfdt/libfdt.h
@@ -61,7 +61,7 @@
 #define FDT_ERR_NOTFOUND	1
 	/* FDT_ERR_NOTFOUND: The requested node or property does not exist */
 #define FDT_ERR_EXISTS		2
-	/* FDT_ERR_EXISTS: Attempted to create a node or property which
+	/* FDT_ERR_EXISTS: Attemped to create a node or property which
 	 * already exists */
 #define FDT_ERR_NOSPACE		3
 	/* FDT_ERR_NOSPACE: Operation needed to expand the device
@@ -122,7 +122,7 @@
 /* Low-level functions (you probably don't need these)                */
 /**********************************************************************/
 
-const void *fdt_offset_ptr(const void *fdt, int offset, int checklen);
+const void *fdt_offset_ptr(const void *fdt, int offset, unsigned int checklen);
 static inline void *fdt_offset_ptr_w(void *fdt, int offset, int checklen)
 {
 	return (void *)(uintptr_t)fdt_offset_ptr(fdt, offset, checklen);
@@ -156,7 +156,7 @@ int fdt_next_node(const void *fdt, int offset, int *depth);
 #define __fdt_set_hdr(name) \
 	static inline void fdt_set_##name(void *fdt, uint32_t val) \
 	{ \
-		struct fdt_header *fdth = fdt; \
+		struct fdt_header *fdth = (struct fdt_header*)fdt; \
 		fdth->name = cpu_to_fdt32(val); \
 	}
 __fdt_set_hdr(magic);
@@ -343,6 +343,91 @@ int fdt_path_offset(const void *fdt, const char *path);
 const char *fdt_get_name(const void *fdt, int nodeoffset, int *lenp);
 
 /**
+ * fdt_first_property_offset - find the offset of a node's first property
+ * @fdt: pointer to the device tree blob
+ * @nodeoffset: structure block offset of a node
+ *
+ * fdt_first_property_offset() finds the first property of the node at
+ * the given structure block offset.
+ *
+ * returns:
+ *	structure block offset of the property (>=0), on success
+ *	-FDT_ERR_NOTFOUND, if the requested node has no properties
+ *	-FDT_ERR_BADOFFSET, if nodeoffset did not point to an FDT_BEGIN_NODE tag
+ *      -FDT_ERR_BADMAGIC,
+ *	-FDT_ERR_BADVERSION,
+ *	-FDT_ERR_BADSTATE,
+ *	-FDT_ERR_BADSTRUCTURE,
+ *	-FDT_ERR_TRUNCATED, standard meanings.
+ */
+int fdt_first_property_offset(const void *fdt, int nodeoffset);
+
+/**
+ * fdt_next_property_offset - step through a node's properties
+ * @fdt: pointer to the device tree blob
+ * @offset: structure block offset of a property
+ *
+ * fdt_next_property_offset() finds the property immediately after the
+ * one at the given structure block offset.  This will be a property
+ * of the same node as the given property.
+ *
+ * returns:
+ *	structure block offset of the next property (>=0), on success
+ *	-FDT_ERR_NOTFOUND, if the given property is the last in its node
+ *	-FDT_ERR_BADOFFSET, if nodeoffset did not point to an FDT_PROP tag
+ *      -FDT_ERR_BADMAGIC,
+ *	-FDT_ERR_BADVERSION,
+ *	-FDT_ERR_BADSTATE,
+ *	-FDT_ERR_BADSTRUCTURE,
+ *	-FDT_ERR_TRUNCATED, standard meanings.
+ */
+int fdt_next_property_offset(const void *fdt, int offset);
+
+/**
+ * fdt_get_property_by_offset - retrieve the property at a given offset
+ * @fdt: pointer to the device tree blob
+ * @offset: offset of the property to retrieve
+ * @lenp: pointer to an integer variable (will be overwritten) or NULL
+ *
+ * fdt_get_property_by_offset() retrieves a pointer to the
+ * fdt_property structure within the device tree blob at the given
+ * offset.  If lenp is non-NULL, the length of the property value is
+ * also returned, in the integer pointed to by lenp.
+ *
+ * returns:
+ *	pointer to the structure representing the property
+ *		if lenp is non-NULL, *lenp contains the length of the property
+ *		value (>=0)
+ *	NULL, on error
+ *		if lenp is non-NULL, *lenp contains an error code (<0):
+ *		-FDT_ERR_BADOFFSET, nodeoffset did not point to FDT_PROP tag
+ *		-FDT_ERR_BADMAGIC,
+ *		-FDT_ERR_BADVERSION,
+ *		-FDT_ERR_BADSTATE,
+ *		-FDT_ERR_BADSTRUCTURE,
+ *		-FDT_ERR_TRUNCATED, standard meanings
+ */
+const struct fdt_property *fdt_get_property_by_offset(const void *fdt,
+						      int offset,
+						      int *lenp);
+
+/**
+ * fdt_get_property_namelen - find a property based on substring
+ * @fdt: pointer to the device tree blob
+ * @nodeoffset: offset of the node whose property to find
+ * @name: name of the property to find
+ * @namelen: number of characters of name to consider
+ * @lenp: pointer to an integer variable (will be overwritten) or NULL
+ *
+ * Identical to fdt_get_property_namelen(), but only examine the first
+ * namelen characters of name for matching the property name.
+ */
+const struct fdt_property *fdt_get_property_namelen(const void *fdt,
+						    int nodeoffset,
+						    const char *name,
+						    int namelen, int *lenp);
+
+/**
  * fdt_get_property - find a given property in a given node
  * @fdt: pointer to the device tree blob
  * @nodeoffset: offset of the node whose property to find
@@ -380,6 +465,54 @@ static inline struct fdt_property *fdt_get_property_w(void *fdt, int nodeoffset,
 }
 
 /**
+ * fdt_getprop_by_offset - retrieve the value of a property at a given offset
+ * @fdt: pointer to the device tree blob
+ * @ffset: offset of the property to read
+ * @namep: pointer to a string variable (will be overwritten) or NULL
+ * @lenp: pointer to an integer variable (will be overwritten) or NULL
+ *
+ * fdt_getprop_by_offset() retrieves a pointer to the value of the
+ * property at structure block offset 'offset' (this will be a pointer
+ * to within the device blob itself, not a copy of the value).  If
+ * lenp is non-NULL, the length of the property value is also
+ * returned, in the integer pointed to by lenp.  If namep is non-NULL,
+ * the property's namne will also be returned in the char * pointed to
+ * by namep (this will be a pointer to within the device tree's string
+ * block, not a new copy of the name).
+ *
+ * returns:
+ *	pointer to the property's value
+ *		if lenp is non-NULL, *lenp contains the length of the property
+ *		value (>=0)
+ *		if namep is non-NULL *namep contiains a pointer to the property
+ *		name.
+ *	NULL, on error
+ *		if lenp is non-NULL, *lenp contains an error code (<0):
+ *		-FDT_ERR_BADOFFSET, nodeoffset did not point to FDT_PROP tag
+ *		-FDT_ERR_BADMAGIC,
+ *		-FDT_ERR_BADVERSION,
+ *		-FDT_ERR_BADSTATE,
+ *		-FDT_ERR_BADSTRUCTURE,
+ *		-FDT_ERR_TRUNCATED, standard meanings
+ */
+const void *fdt_getprop_by_offset(const void *fdt, int offset,
+				  const char **namep, int *lenp);
+
+/**
+ * fdt_getprop_namelen - get property value based on substring
+ * @fdt: pointer to the device tree blob
+ * @nodeoffset: offset of the node whose property to find
+ * @name: name of the property to find
+ * @namelen: number of characters of name to consider
+ * @lenp: pointer to an integer variable (will be overwritten) or NULL
+ *
+ * Identical to fdt_getprop(), but only examine the first namelen
+ * characters of name for matching the property name.
+ */
+const void *fdt_getprop_namelen(const void *fdt, int nodeoffset,
+				const char *name, int namelen, int *lenp);
+
+/**
  * fdt_getprop - retrieve the value of a given property
  * @fdt: pointer to the device tree blob
  * @nodeoffset: offset of the node whose property to find
@@ -429,6 +562,32 @@ static inline void *fdt_getprop_w(void *fdt, int nodeoffset,
 uint32_t fdt_get_phandle(const void *fdt, int nodeoffset);
 
 /**
+ * fdt_get_alias_namelen - get alias based on substring
+ * @fdt: pointer to the device tree blob
+ * @name: name of the alias th look up
+ * @namelen: number of characters of name to consider
+ *
+ * Identical to fdt_get_alias(), but only examine the first namelen
+ * characters of name for matching the alias name.
+ */
+const char *fdt_get_alias_namelen(const void *fdt,
+				  const char *name, int namelen);
+
+/**
+ * fdt_get_alias - retreive the path referenced by a given alias
+ * @fdt: pointer to the device tree blob
+ * @name: name of the alias th look up
+ *
+ * fdt_get_alias() retrieves the value of a given alias.  That is, the
+ * value of the property named 'name' in the node /aliases.
+ *
+ * returns:
+ *	a pointer to the expansion of the alias named 'name', of it exists
+ *	NULL, if the given alias or the /aliases node does not exist
+ */
+const char *fdt_get_alias(const void *fdt, const char *name);
+
+/**
  * fdt_get_path - determine the full path of a node
  * @fdt: pointer to the device tree blob
  * @nodeoffset: offset of the node whose path to find
@@ -693,17 +852,17 @@ int fdt_setprop_inplace(void *fdt, int nodeoffset, const char *name,
 			const void *val, int len);
 
 /**
- * fdt_setprop_inplace_cell - change the value of a single-cell property
+ * fdt_setprop_inplace_u32 - change the value of a 32-bit integer property
  * @fdt: pointer to the device tree blob
  * @nodeoffset: offset of the node whose property to change
  * @name: name of the property to change
- * @val: cell (32-bit integer) value to replace the property with
+ * @val: 32-bit integer value to replace the property with
  *
- * fdt_setprop_inplace_cell() replaces the value of a given property
- * with the 32-bit integer cell value in val, converting val to
- * big-endian if necessary.  This function cannot change the size of a
- * property, and so will only work if the property already exists and
- * has length 4.
+ * fdt_setprop_inplace_u32() replaces the value of a given property
+ * with the 32-bit integer value in val, converting val to big-endian
+ * if necessary.  This function cannot change the size of a property,
+ * and so will only work if the property already exists and has length
+ * 4.
  *
  * This function will alter only the bytes in the blob which contain
  * the given property value, and will not alter or move any other part
@@ -712,7 +871,7 @@ int fdt_setprop_inplace(void *fdt, int nodeoffset, const char *name,
  * returns:
  *	0, on success
  *	-FDT_ERR_NOSPACE, if the property's length is not equal to 4
-  *	-FDT_ERR_NOTFOUND, node does not have the named property
+ *	-FDT_ERR_NOTFOUND, node does not have the named property
  *	-FDT_ERR_BADOFFSET, nodeoffset did not point to FDT_BEGIN_NODE tag
  *	-FDT_ERR_BADMAGIC,
  *	-FDT_ERR_BADVERSION,
@@ -720,14 +879,60 @@ int fdt_setprop_inplace(void *fdt, int nodeoffset, const char *name,
  *	-FDT_ERR_BADSTRUCTURE,
  *	-FDT_ERR_TRUNCATED, standard meanings
  */
-static inline int fdt_setprop_inplace_cell(void *fdt, int nodeoffset,
-					   const char *name, uint32_t val)
+static inline int fdt_setprop_inplace_u32(void *fdt, int nodeoffset,
+					  const char *name, uint32_t val)
 {
 	val = cpu_to_fdt32(val);
 	return fdt_setprop_inplace(fdt, nodeoffset, name, &val, sizeof(val));
 }
 
 /**
+ * fdt_setprop_inplace_u64 - change the value of a 64-bit integer property
+ * @fdt: pointer to the device tree blob
+ * @nodeoffset: offset of the node whose property to change
+ * @name: name of the property to change
+ * @val: 64-bit integer value to replace the property with
+ *
+ * fdt_setprop_inplace_u64() replaces the value of a given property
+ * with the 64-bit integer value in val, converting val to big-endian
+ * if necessary.  This function cannot change the size of a property,
+ * and so will only work if the property already exists and has length
+ * 8.
+ *
+ * This function will alter only the bytes in the blob which contain
+ * the given property value, and will not alter or move any other part
+ * of the tree.
+ *
+ * returns:
+ *	0, on success
+ *	-FDT_ERR_NOSPACE, if the property's length is not equal to 8
+ *	-FDT_ERR_NOTFOUND, node does not have the named property
+ *	-FDT_ERR_BADOFFSET, nodeoffset did not point to FDT_BEGIN_NODE tag
+ *	-FDT_ERR_BADMAGIC,
+ *	-FDT_ERR_BADVERSION,
+ *	-FDT_ERR_BADSTATE,
+ *	-FDT_ERR_BADSTRUCTURE,
+ *	-FDT_ERR_TRUNCATED, standard meanings
+ */
+static inline int fdt_setprop_inplace_u64(void *fdt, int nodeoffset,
+					  const char *name, uint64_t val)
+{
+	val = cpu_to_fdt64(val);
+	return fdt_setprop_inplace(fdt, nodeoffset, name, &val, sizeof(val));
+}
+
+/**
+ * fdt_setprop_inplace_cell - change the value of a single-cell property
+ *
+ * This is an alternative name for fdt_setprop_inplace_u32()
+ */
+static inline int fdt_setprop_inplace_cell(void *fdt, int nodeoffset,
+					   const char *name, uint32_t val)
+{
+	return fdt_setprop_inplace_u32(fdt, nodeoffset, name, val);
+}
+
+/**
  * fdt_nop_property - replace a property with nop tags
  * @fdt: pointer to the device tree blob
  * @nodeoffset: offset of the node whose property to nop
@@ -786,11 +991,20 @@ int fdt_add_reservemap_entry(void *fdt, uint64_t addr, uint64_t size);
 int fdt_finish_reservemap(void *fdt);
 int fdt_begin_node(void *fdt, const char *name);
 int fdt_property(void *fdt, const char *name, const void *val, int len);
-static inline int fdt_property_cell(void *fdt, const char *name, uint32_t val)
+static inline int fdt_property_u32(void *fdt, const char *name, uint32_t val)
 {
 	val = cpu_to_fdt32(val);
 	return fdt_property(fdt, name, &val, sizeof(val));
 }
+static inline int fdt_property_u64(void *fdt, const char *name, uint64_t val)
+{
+	val = cpu_to_fdt64(val);
+	return fdt_property(fdt, name, &val, sizeof(val));
+}
+static inline int fdt_property_cell(void *fdt, const char *name, uint32_t val)
+{
+	return fdt_property_u32(fdt, name, val);
+}
 #define fdt_property_string(fdt, name, str) \
 	fdt_property(fdt, name, str, strlen(str)+1)
 int fdt_end_node(void *fdt);
@@ -800,6 +1014,7 @@ int fdt_finish(void *fdt);
 /* Read-write functions                                               */
 /**********************************************************************/
 
+int fdt_create_empty_tree(void *buf, int bufsize);
 int fdt_open_into(const void *fdt, void *buf, int bufsize);
 int fdt_pack(void *fdt);
 
@@ -909,14 +1124,14 @@ int fdt_setprop(void *fdt, int nodeoffset, const char *name,
 		const void *val, int len);
 
 /**
- * fdt_setprop_cell - set a property to a single cell value
+ * fdt_setprop_u32 - set a property to a 32-bit integer
  * @fdt: pointer to the device tree blob
  * @nodeoffset: offset of the node whose property to change
  * @name: name of the property to change
  * @val: 32-bit integer value for the property (native endian)
  *
- * fdt_setprop_cell() sets the value of the named property in the
- * given node to the given cell value (converting to big-endian if
+ * fdt_setprop_u32() sets the value of the named property in the given
+ * node to the given 32-bit integer value (converting to big-endian if
  * necessary), or creates a new property with that value if it does
  * not already exist.
  *
@@ -936,14 +1151,60 @@ int fdt_setprop(void *fdt, int nodeoffset, const char *name,
  *	-FDT_ERR_BADLAYOUT,
  *	-FDT_ERR_TRUNCATED, standard meanings
  */
-static inline int fdt_setprop_cell(void *fdt, int nodeoffset, const char *name,
-				   uint32_t val)
+static inline int fdt_setprop_u32(void *fdt, int nodeoffset, const char *name,
+				  uint32_t val)
 {
 	val = cpu_to_fdt32(val);
 	return fdt_setprop(fdt, nodeoffset, name, &val, sizeof(val));
 }
 
 /**
+ * fdt_setprop_u64 - set a property to a 64-bit integer
+ * @fdt: pointer to the device tree blob
+ * @nodeoffset: offset of the node whose property to change
+ * @name: name of the property to change
+ * @val: 64-bit integer value for the property (native endian)
+ *
+ * fdt_setprop_u64() sets the value of the named property in the given
+ * node to the given 64-bit integer value (converting to big-endian if
+ * necessary), or creates a new property with that value if it does
+ * not already exist.
+ *
+ * This function may insert or delete data from the blob, and will
+ * therefore change the offsets of some existing nodes.
+ *
+ * returns:
+ *	0, on success
+ *	-FDT_ERR_NOSPACE, there is insufficient free space in the blob to
+ *		contain the new property value
+ *	-FDT_ERR_BADOFFSET, nodeoffset did not point to FDT_BEGIN_NODE tag
+ *	-FDT_ERR_BADLAYOUT,
+ *	-FDT_ERR_BADMAGIC,
+ *	-FDT_ERR_BADVERSION,
+ *	-FDT_ERR_BADSTATE,
+ *	-FDT_ERR_BADSTRUCTURE,
+ *	-FDT_ERR_BADLAYOUT,
+ *	-FDT_ERR_TRUNCATED, standard meanings
+ */
+static inline int fdt_setprop_u64(void *fdt, int nodeoffset, const char *name,
+				  uint64_t val)
+{
+	val = cpu_to_fdt64(val);
+	return fdt_setprop(fdt, nodeoffset, name, &val, sizeof(val));
+}
+
+/**
+ * fdt_setprop_cell - set a property to a single cell value
+ *
+ * This is an alternative name for fdt_setprop_u32()
+ */
+static inline int fdt_setprop_cell(void *fdt, int nodeoffset, const char *name,
+				   uint32_t val)
+{
+	return fdt_setprop_u32(fdt, nodeoffset, name, val);
+}
+
+/**
  * fdt_setprop_string - set a property to a string value
  * @fdt: pointer to the device tree blob
  * @nodeoffset: offset of the node whose property to change
@@ -975,6 +1236,147 @@ static inline int fdt_setprop_cell(void *fdt, int nodeoffset, const char *name,
 	fdt_setprop((fdt), (nodeoffset), (name), (str), strlen(str)+1)
 
 /**
+ * fdt_appendprop - append to or create a property
+ * @fdt: pointer to the device tree blob
+ * @nodeoffset: offset of the node whose property to change
+ * @name: name of the property to append to
+ * @val: pointer to data to append to the property value
+ * @len: length of the data to append to the property value
+ *
+ * fdt_appendprop() appends the value to the named property in the
+ * given node, creating the property if it does not already exist.
+ *
+ * This function may insert data into the blob, and will therefore
+ * change the offsets of some existing nodes.
+ *
+ * returns:
+ *	0, on success
+ *	-FDT_ERR_NOSPACE, there is insufficient free space in the blob to
+ *		contain the new property value
+ *	-FDT_ERR_BADOFFSET, nodeoffset did not point to FDT_BEGIN_NODE tag
+ *	-FDT_ERR_BADLAYOUT,
+ *	-FDT_ERR_BADMAGIC,
+ *	-FDT_ERR_BADVERSION,
+ *	-FDT_ERR_BADSTATE,
+ *	-FDT_ERR_BADSTRUCTURE,
+ *	-FDT_ERR_BADLAYOUT,
+ *	-FDT_ERR_TRUNCATED, standard meanings
+ */
+int fdt_appendprop(void *fdt, int nodeoffset, const char *name,
+		   const void *val, int len);
+
+/**
+ * fdt_appendprop_u32 - append a 32-bit integer value to a property
+ * @fdt: pointer to the device tree blob
+ * @nodeoffset: offset of the node whose property to change
+ * @name: name of the property to change
+ * @val: 32-bit integer value to append to the property (native endian)
+ *
+ * fdt_appendprop_u32() appends the given 32-bit integer value
+ * (converting to big-endian if necessary) to the value of the named
+ * property in the given node, or creates a new property with that
+ * value if it does not already exist.
+ *
+ * This function may insert data into the blob, and will therefore
+ * change the offsets of some existing nodes.
+ *
+ * returns:
+ *	0, on success
+ *	-FDT_ERR_NOSPACE, there is insufficient free space in the blob to
+ *		contain the new property value
+ *	-FDT_ERR_BADOFFSET, nodeoffset did not point to FDT_BEGIN_NODE tag
+ *	-FDT_ERR_BADLAYOUT,
+ *	-FDT_ERR_BADMAGIC,
+ *	-FDT_ERR_BADVERSION,
+ *	-FDT_ERR_BADSTATE,
+ *	-FDT_ERR_BADSTRUCTURE,
+ *	-FDT_ERR_BADLAYOUT,
+ *	-FDT_ERR_TRUNCATED, standard meanings
+ */
+static inline int fdt_appendprop_u32(void *fdt, int nodeoffset,
+				     const char *name, uint32_t val)
+{
+	val = cpu_to_fdt32(val);
+	return fdt_appendprop(fdt, nodeoffset, name, &val, sizeof(val));
+}
+
+/**
+ * fdt_appendprop_u64 - append a 64-bit integer value to a property
+ * @fdt: pointer to the device tree blob
+ * @nodeoffset: offset of the node whose property to change
+ * @name: name of the property to change
+ * @val: 64-bit integer value to append to the property (native endian)
+ *
+ * fdt_appendprop_u64() appends the given 64-bit integer value
+ * (converting to big-endian if necessary) to the value of the named
+ * property in the given node, or creates a new property with that
+ * value if it does not already exist.
+ *
+ * This function may insert data into the blob, and will therefore
+ * change the offsets of some existing nodes.
+ *
+ * returns:
+ *	0, on success
+ *	-FDT_ERR_NOSPACE, there is insufficient free space in the blob to
+ *		contain the new property value
+ *	-FDT_ERR_BADOFFSET, nodeoffset did not point to FDT_BEGIN_NODE tag
+ *	-FDT_ERR_BADLAYOUT,
+ *	-FDT_ERR_BADMAGIC,
+ *	-FDT_ERR_BADVERSION,
+ *	-FDT_ERR_BADSTATE,
+ *	-FDT_ERR_BADSTRUCTURE,
+ *	-FDT_ERR_BADLAYOUT,
+ *	-FDT_ERR_TRUNCATED, standard meanings
+ */
+static inline int fdt_appendprop_u64(void *fdt, int nodeoffset,
+				     const char *name, uint64_t val)
+{
+	val = cpu_to_fdt64(val);
+	return fdt_appendprop(fdt, nodeoffset, name, &val, sizeof(val));
+}
+
+/**
+ * fdt_appendprop_cell - append a single cell value to a property
+ *
+ * This is an alternative name for fdt_appendprop_u32()
+ */
+static inline int fdt_appendprop_cell(void *fdt, int nodeoffset,
+				      const char *name, uint32_t val)
+{
+	return fdt_appendprop_u32(fdt, nodeoffset, name, val);
+}
+
+/**
+ * fdt_appendprop_string - append a string to a property
+ * @fdt: pointer to the device tree blob
+ * @nodeoffset: offset of the node whose property to change
+ * @name: name of the property to change
+ * @str: string value to append to the property
+ *
+ * fdt_appendprop_string() appends the given string to the value of
+ * the named property in the given node, or creates a new property
+ * with that value if it does not already exist.
+ *
+ * This function may insert data into the blob, and will therefore
+ * change the offsets of some existing nodes.
+ *
+ * returns:
+ *	0, on success
+ *	-FDT_ERR_NOSPACE, there is insufficient free space in the blob to
+ *		contain the new property value
+ *	-FDT_ERR_BADOFFSET, nodeoffset did not point to FDT_BEGIN_NODE tag
+ *	-FDT_ERR_BADLAYOUT,
+ *	-FDT_ERR_BADMAGIC,
+ *	-FDT_ERR_BADVERSION,
+ *	-FDT_ERR_BADSTATE,
+ *	-FDT_ERR_BADSTRUCTURE,
+ *	-FDT_ERR_BADLAYOUT,
+ *	-FDT_ERR_TRUNCATED, standard meanings
+ */
+#define fdt_appendprop_string(fdt, nodeoffset, name, str) \
+	fdt_appendprop((fdt), (nodeoffset), (name), (str), strlen(str)+1)
+
+/**
  * fdt_delprop - delete a property
  * @fdt: pointer to the device tree blob
  * @nodeoffset: offset of the node whose property to nop
diff --git a/scripts/dtc/libfdt/libfdt_env.h b/scripts/dtc/libfdt/libfdt_env.h
index 449bf60..213d7fb 100644
--- a/scripts/dtc/libfdt/libfdt_env.h
+++ b/scripts/dtc/libfdt/libfdt_env.h
@@ -5,19 +5,25 @@
 #include <stdint.h>
 #include <string.h>
 
-#define _B(n)	((unsigned long long)((uint8_t *)&x)[n])
+#define EXTRACT_BYTE(n)	((unsigned long long)((uint8_t *)&x)[n])
+static inline uint16_t fdt16_to_cpu(uint16_t x)
+{
+	return (EXTRACT_BYTE(0) << 8) | EXTRACT_BYTE(1);
+}
+#define cpu_to_fdt16(x) fdt16_to_cpu(x)
+
 static inline uint32_t fdt32_to_cpu(uint32_t x)
 {
-	return (_B(0) << 24) | (_B(1) << 16) | (_B(2) << 8) | _B(3);
+	return (EXTRACT_BYTE(0) << 24) | (EXTRACT_BYTE(1) << 16) | (EXTRACT_BYTE(2) << 8) | EXTRACT_BYTE(3);
 }
 #define cpu_to_fdt32(x) fdt32_to_cpu(x)
 
 static inline uint64_t fdt64_to_cpu(uint64_t x)
 {
-	return (_B(0) << 56) | (_B(1) << 48) | (_B(2) << 40) | (_B(3) << 32)
-		| (_B(4) << 24) | (_B(5) << 16) | (_B(6) << 8) | _B(7);
+	return (EXTRACT_BYTE(0) << 56) | (EXTRACT_BYTE(1) << 48) | (EXTRACT_BYTE(2) << 40) | (EXTRACT_BYTE(3) << 32)
+		| (EXTRACT_BYTE(4) << 24) | (EXTRACT_BYTE(5) << 16) | (EXTRACT_BYTE(6) << 8) | EXTRACT_BYTE(7);
 }
 #define cpu_to_fdt64(x) fdt64_to_cpu(x)
-#undef _B
+#undef EXTRACT_BYTE
 
 #endif /* _LIBFDT_ENV_H */
diff --git a/scripts/dtc/libfdt/libfdt_internal.h b/scripts/dtc/libfdt/libfdt_internal.h
index 46eb93e..381133b 100644
--- a/scripts/dtc/libfdt/libfdt_internal.h
+++ b/scripts/dtc/libfdt/libfdt_internal.h
@@ -62,8 +62,8 @@
 			return err; \
 	}
 
-uint32_t _fdt_next_tag(const void *fdt, int startoffset, int *nextoffset);
 int _fdt_check_node_offset(const void *fdt, int offset);
+int _fdt_check_prop_offset(const void *fdt, int offset);
 const char *_fdt_find_string(const char *strtab, int tabsize, const char *s);
 int _fdt_node_end_offset(void *fdt, int nodeoffset);
 
diff --git a/scripts/dtc/livetree.c b/scripts/dtc/livetree.c
index 26d0e1e..b61465f 100644
--- a/scripts/dtc/livetree.c
+++ b/scripts/dtc/livetree.c
@@ -29,16 +29,27 @@ void add_label(struct label **labels, char *label)
 	struct label *new;
 
 	/* Make sure the label isn't already there */
-	for_each_label(*labels, new)
-		if (streq(new->label, label))
+	for_each_label_withdel(*labels, new)
+		if (streq(new->label, label)) {
+			new->deleted = 0;
 			return;
+		}
 
 	new = xmalloc(sizeof(*new));
+	memset(new, 0, sizeof(*new));
 	new->label = label;
 	new->next = *labels;
 	*labels = new;
 }
 
+void delete_labels(struct label **labels)
+{
+	struct label *label;
+
+	for_each_label(*labels, label)
+		label->deleted = 1;
+}
+
 struct property *build_property(char *name, struct data val)
 {
 	struct property *new = xmalloc(sizeof(*new));
@@ -51,6 +62,18 @@ struct property *build_property(char *name, struct data val)
 	return new;
 }
 
+struct property *build_property_delete(char *name)
+{
+	struct property *new = xmalloc(sizeof(*new));
+
+	memset(new, 0, sizeof(*new));
+
+	new->name = name;
+	new->deleted = 1;
+
+	return new;
+}
+
 struct property *chain_property(struct property *first, struct property *list)
 {
 	assert(first->next == NULL);
@@ -91,6 +114,17 @@ struct node *build_node(struct property *proplist, struct node *children)
 	return new;
 }
 
+struct node *build_node_delete(void)
+{
+	struct node *new = xmalloc(sizeof(*new));
+
+	memset(new, 0, sizeof(*new));
+
+	new->deleted = 1;
+
+	return new;
+}
+
 struct node *name_node(struct node *node, char *name)
 {
 	assert(node->name == NULL);
@@ -106,8 +140,10 @@ struct node *merge_nodes(struct node *old_node, struct node *new_node)
 	struct node *new_child, *old_child;
 	struct label *l;
 
+	old_node->deleted = 0;
+
 	/* Add new node labels to old node */
-	for_each_label(new_node->labels, l)
+	for_each_label_withdel(new_node->labels, l)
 		add_label(&old_node->labels, l->label);
 
 	/* Move properties from the new node to the old node.  If there
@@ -118,14 +154,21 @@ struct node *merge_nodes(struct node *old_node, struct node *new_node)
 		new_node->proplist = new_prop->next;
 		new_prop->next = NULL;
 
+		if (new_prop->deleted) {
+			delete_property_by_name(old_node, new_prop->name);
+			free(new_prop);
+			continue;
+		}
+
 		/* Look for a collision, set new value if there is */
-		for_each_property(old_node, old_prop) {
+		for_each_property_withdel(old_node, old_prop) {
 			if (streq(old_prop->name, new_prop->name)) {
 				/* Add new labels to old property */
-				for_each_label(new_prop->labels, l)
+				for_each_label_withdel(new_prop->labels, l)
 					add_label(&old_prop->labels, l->label);
 
 				old_prop->val = new_prop->val;
+				old_prop->deleted = 0;
 				free(new_prop);
 				new_prop = NULL;
 				break;
@@ -146,8 +189,14 @@ struct node *merge_nodes(struct node *old_node, struct node *new_node)
 		new_child->parent = NULL;
 		new_child->next_sibling = NULL;
 
+		if (new_child->deleted) {
+			delete_node_by_name(old_node, new_child->name);
+			free(new_child);
+			continue;
+		}
+
 		/* Search for a collision.  Merge if there is */
-		for_each_child(old_node, old_child) {
+		for_each_child_withdel(old_node, old_child) {
 			if (streq(old_child->name, new_child->name)) {
 				merge_nodes(old_child, new_child);
 				new_child = NULL;
@@ -155,7 +204,7 @@ struct node *merge_nodes(struct node *old_node, struct node *new_node)
 			}
 		}
 
-		/* if no collision occurred, add child to the old node. */
+		/* if no collision occured, add child to the old node. */
 		if (new_child)
 			add_child(old_node, new_child);
 	}
@@ -188,6 +237,25 @@ void add_property(struct node *node, struct property *prop)
 	*p = prop;
 }
 
+void delete_property_by_name(struct node *node, char *name)
+{
+	struct property *prop = node->proplist;
+
+	while (prop) {
+		if (!strcmp(prop->name, name)) {
+			delete_property(prop);
+			return;
+		}
+		prop = prop->next;
+	}
+}
+
+void delete_property(struct property *prop)
+{
+	prop->deleted = 1;
+	delete_labels(&prop->labels);
+}
+
 void add_child(struct node *parent, struct node *child)
 {
 	struct node **p;
@@ -202,6 +270,32 @@ void add_child(struct node *parent, struct node *child)
 	*p = child;
 }
 
+void delete_node_by_name(struct node *parent, char *name)
+{
+	struct node *node = parent->children;
+
+	while (node) {
+		if (!strcmp(node->name, name)) {
+			delete_node(node);
+			return;
+		}
+		node = node->next_sibling;
+	}
+}
+
+void delete_node(struct node *node)
+{
+	struct property *prop;
+	struct node *child;
+
+	node->deleted = 1;
+	for_each_child(node, child)
+		delete_node(child);
+	for_each_property(node, prop)
+		delete_property(prop);
+	delete_labels(&node->labels);
+}
+
 struct reserve_info *build_reserve_entry(uint64_t address, uint64_t size)
 {
 	struct reserve_info *new = xmalloc(sizeof(*new));
@@ -353,8 +447,11 @@ struct node *get_node_by_path(struct node *tree, const char *path)
 	const char *p;
 	struct node *child;
 
-	if (!path || ! (*path))
+	if (!path || ! (*path)) {
+		if (tree->deleted)
+			return NULL;
 		return tree;
+	}
 
 	while (path[0] == '/')
 		path++;
@@ -397,8 +494,11 @@ struct node *get_node_by_phandle(struct node *tree, cell_t phandle)
 
 	assert((phandle != 0) && (phandle != -1));
 
-	if (tree->phandle == phandle)
+	if (tree->phandle == phandle) {
+		if (tree->deleted)
+			return NULL;
 		return tree;
+	}
 
 	for_each_child(tree, child) {
 		node = get_node_by_phandle(child, phandle);
@@ -535,7 +635,7 @@ static void sort_properties(struct node *node)
 	int n = 0, i = 0;
 	struct property *prop, **tbl;
 
-	for_each_property(node, prop)
+	for_each_property_withdel(node, prop)
 		n++;
 
 	if (n == 0)
@@ -543,7 +643,7 @@ static void sort_properties(struct node *node)
 
 	tbl = xmalloc(n * sizeof(*tbl));
 
-	for_each_property(node, prop)
+	for_each_property_withdel(node, prop)
 		tbl[i++] = prop;
 
 	qsort(tbl, n, sizeof(*tbl), cmp_prop);
@@ -571,7 +671,7 @@ static void sort_subnodes(struct node *node)
 	int n = 0, i = 0;
 	struct node *subnode, **tbl;
 
-	for_each_child(node, subnode)
+	for_each_child_withdel(node, subnode)
 		n++;
 
 	if (n == 0)
@@ -579,7 +679,7 @@ static void sort_subnodes(struct node *node)
 
 	tbl = xmalloc(n * sizeof(*tbl));
 
-	for_each_child(node, subnode)
+	for_each_child_withdel(node, subnode)
 		tbl[i++] = subnode;
 
 	qsort(tbl, n, sizeof(*tbl), cmp_subnode);
@@ -598,7 +698,7 @@ static void sort_node(struct node *node)
 
 	sort_properties(node);
 	sort_subnodes(node);
-	for_each_child(node, c)
+	for_each_child_withdel(node, c)
 		sort_node(c);
 }
 
diff --git a/scripts/dtc/srcpos.c b/scripts/dtc/srcpos.c
index 36a38e9..246ab4b 100644
--- a/scripts/dtc/srcpos.c
+++ b/scripts/dtc/srcpos.c
@@ -24,6 +24,15 @@
 #include "dtc.h"
 #include "srcpos.h"
 
+/* A node in our list of directories to search for source/include files */
+struct search_path {
+	struct search_path *next;	/* next node in list, NULL for end */
+	const char *dirname;		/* name of directory to search */
+};
+
+/* This is the list of directories that we search for source files */
+static struct search_path *search_path_head, **search_path_tail;
+
 
 static char *dirname(const char *path)
 {
@@ -47,6 +56,64 @@ struct srcfile_state *current_srcfile; /* = NULL */
 #define MAX_SRCFILE_DEPTH     (100)
 static int srcfile_depth; /* = 0 */
 
+
+/**
+ * Try to open a file in a given directory.
+ *
+ * If the filename is an absolute path, then dirname is ignored. If it is a
+ * relative path, then we look in that directory for the file.
+ *
+ * @param dirname	Directory to look in, or NULL for none
+ * @param fname		Filename to look for
+ * @param fp		Set to NULL if file did not open
+ * @return allocated filename on success (caller must free), NULL on failure
+ */
+static char *try_open(const char *dirname, const char *fname, FILE **fp)
+{
+	char *fullname;
+
+	if (!dirname || fname[0] == '/')
+		fullname = xstrdup(fname);
+	else
+		fullname = join_path(dirname, fname);
+
+	*fp = fopen(fullname, "r");
+	if (!*fp) {
+		free(fullname);
+		fullname = NULL;
+	}
+
+	return fullname;
+}
+
+/**
+ * Open a file for read access
+ *
+ * If it is a relative filename, we search the full search path for it.
+ *
+ * @param fname	Filename to open
+ * @param fp	Returns pointer to opened FILE, or NULL on failure
+ * @return pointer to allocated filename, which caller must free
+ */
+static char *fopen_any_on_path(const char *fname, FILE **fp)
+{
+	const char *cur_dir = NULL;
+	struct search_path *node;
+	char *fullname;
+
+	/* Try current directory first */
+	assert(fp);
+	if (current_srcfile)
+		cur_dir = current_srcfile->dir;
+	fullname = try_open(cur_dir, fname, fp);
+
+	/* Failing that, try each search path in turn */
+	for (node = search_path_head; !*fp && node; node = node->next)
+		fullname = try_open(node->dirname, fname, fp);
+
+	return fullname;
+}
+
 FILE *srcfile_relative_open(const char *fname, char **fullnamep)
 {
 	FILE *f;
@@ -56,13 +123,7 @@ FILE *srcfile_relative_open(const char *fname, char **fullnamep)
 		f = stdin;
 		fullname = xstrdup("<stdin>");
 	} else {
-		if (!current_srcfile || !current_srcfile->dir
-		    || (fname[0] == '/'))
-			fullname = xstrdup(fname);
-		else
-			fullname = join_path(current_srcfile->dir, fname);
-
-		f = fopen(fullname, "r");
+		fullname = fopen_any_on_path(fname, &f);
 		if (!f)
 			die("Couldn't open \"%s\": %s\n", fname,
 			    strerror(errno));
@@ -119,6 +180,23 @@ int srcfile_pop(void)
 	return current_srcfile ? 1 : 0;
 }
 
+void srcfile_add_search_path(const char *dirname)
+{
+	struct search_path *node;
+
+	/* Create the node */
+	node = xmalloc(sizeof(*node));
+	node->next = NULL;
+	node->dirname = xstrdup(dirname);
+
+	/* Add to the end of our list */
+	if (search_path_tail)
+		*search_path_tail = node;
+	else
+		search_path_head = node;
+	search_path_tail = &node->next;
+}
+
 /*
  * The empty source position.
  */
@@ -250,3 +328,9 @@ srcpos_warn(struct srcpos *pos, char const *fmt, ...)
 
 	va_end(va);
 }
+
+void srcpos_set_line(char *f, int l)
+{
+	current_srcfile->name = f;
+	current_srcfile->lineno = l;
+}
diff --git a/scripts/dtc/srcpos.h b/scripts/dtc/srcpos.h
index ce980ca..93a2712 100644
--- a/scripts/dtc/srcpos.h
+++ b/scripts/dtc/srcpos.h
@@ -33,10 +33,39 @@ struct srcfile_state {
 extern FILE *depfile; /* = NULL */
 extern struct srcfile_state *current_srcfile; /* = NULL */
 
+/**
+ * Open a source file.
+ *
+ * If the source file is a relative pathname, then it is searched for in the
+ * current directory (the directory of the last source file read) and after
+ * that in the search path.
+ *
+ * We work through the search path in order from the first path specified to
+ * the last.
+ *
+ * If the file is not found, then this function does not return, but calls
+ * die().
+ *
+ * @param fname		Filename to search
+ * @param fullnamep	If non-NULL, it is set to the allocated filename of the
+ *			file that was opened. The caller is then responsible
+ *			for freeing the pointer.
+ * @return pointer to opened FILE
+ */
 FILE *srcfile_relative_open(const char *fname, char **fullnamep);
+
 void srcfile_push(const char *fname);
 int srcfile_pop(void);
 
+/**
+ * Add a new directory to the search path for input files
+ *
+ * The new path is added at the end of the list.
+ *
+ * @param dirname	Directory to add
+ */
+void srcfile_add_search_path(const char *dirname);
+
 struct srcpos {
     int first_line;
     int first_column;
@@ -84,4 +113,6 @@ extern void srcpos_error(struct srcpos *pos, char const *, ...)
 extern void srcpos_warn(struct srcpos *pos, char const *, ...)
      __attribute__((format(printf, 2, 3)));
 
+extern void srcpos_set_line(char *f, int l);
+
 #endif /* _SRCPOS_H_ */
diff --git a/scripts/dtc/treesource.c b/scripts/dtc/treesource.c
index c09aafa..33eeba5 100644
--- a/scripts/dtc/treesource.c
+++ b/scripts/dtc/treesource.c
@@ -23,6 +23,7 @@
 
 extern FILE *yyin;
 extern int yyparse(void);
+extern YYLTYPE yylloc;
 
 struct boot_info *the_boot_info;
 int treesource_error;
@@ -34,6 +35,7 @@ struct boot_info *dt_from_source(const char *fname)
 
 	srcfile_push(fname);
 	yyin = current_srcfile->f;
+	yylloc.file = current_srcfile;
 
 	if (yyparse() != 0)
 		die("Unable to parse input tree\n");
diff --git a/scripts/dtc/util.c b/scripts/dtc/util.c
index d7ac27d..2422c34 100644
--- a/scripts/dtc/util.c
+++ b/scripts/dtc/util.c
@@ -1,6 +1,10 @@
 /*
+ * Copyright 2011 The Chromium Authors, All Rights Reserved.
  * Copyright 2008 Jon Loeliger, Freescale Semiconductor, Inc.
  *
+ * util_is_printable_string contributed by
+ *	Pantelis Antoniou <pantelis.antoniou AT gmail.com>
+ *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License as
  * published by the Free Software Foundation; either version 2 of the
@@ -17,11 +21,18 @@
  *                                                                   USA
  */
 
+#include <ctype.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <stdarg.h>
 #include <string.h>
+#include <assert.h>
+
+#include <errno.h>
+#include <fcntl.h>
+#include <unistd.h>
 
+#include "libfdt.h"
 #include "util.h"
 
 char *xstrdup(const char *s)
@@ -57,3 +68,264 @@ char *join_path(const char *path, const char *name)
 	memcpy(str+lenp, name, lenn+1);
 	return str;
 }
+
+int util_is_printable_string(const void *data, int len)
+{
+	const char *s = data;
+	const char *ss;
+
+	/* zero length is not */
+	if (len == 0)
+		return 0;
+
+	/* must terminate with zero */
+	if (s[len - 1] != '\0')
+		return 0;
+
+	ss = s;
+	while (*s && isprint(*s))
+		s++;
+
+	/* not zero, or not done yet */
+	if (*s != '\0' || (s + 1 - ss) < len)
+		return 0;
+
+	return 1;
+}
+
+/*
+ * Parse a octal encoded character starting at index i in string s.  The
+ * resulting character will be returned and the index i will be updated to
+ * point at the character directly after the end of the encoding, this may be
+ * the '\0' terminator of the string.
+ */
+static char get_oct_char(const char *s, int *i)
+{
+	char x[4];
+	char *endx;
+	long val;
+
+	x[3] = '\0';
+	strncpy(x, s + *i, 3);
+
+	val = strtol(x, &endx, 8);
+
+	assert(endx > x);
+
+	(*i) += endx - x;
+	return val;
+}
+
+/*
+ * Parse a hexadecimal encoded character starting at index i in string s.  The
+ * resulting character will be returned and the index i will be updated to
+ * point at the character directly after the end of the encoding, this may be
+ * the '\0' terminator of the string.
+ */
+static char get_hex_char(const char *s, int *i)
+{
+	char x[3];
+	char *endx;
+	long val;
+
+	x[2] = '\0';
+	strncpy(x, s + *i, 2);
+
+	val = strtol(x, &endx, 16);
+	if (!(endx  > x))
+		die("\\x used with no following hex digits\n");
+
+	(*i) += endx - x;
+	return val;
+}
+
+char get_escape_char(const char *s, int *i)
+{
+	char	c = s[*i];
+	int	j = *i + 1;
+	char	val;
+
+	assert(c);
+	switch (c) {
+	case 'a':
+		val = '\a';
+		break;
+	case 'b':
+		val = '\b';
+		break;
+	case 't':
+		val = '\t';
+		break;
+	case 'n':
+		val = '\n';
+		break;
+	case 'v':
+		val = '\v';
+		break;
+	case 'f':
+		val = '\f';
+		break;
+	case 'r':
+		val = '\r';
+		break;
+	case '0':
+	case '1':
+	case '2':
+	case '3':
+	case '4':
+	case '5':
+	case '6':
+	case '7':
+		j--; /* need to re-read the first digit as
+		      * part of the octal value */
+		val = get_oct_char(s, &j);
+		break;
+	case 'x':
+		val = get_hex_char(s, &j);
+		break;
+	default:
+		val = c;
+	}
+
+	(*i) = j;
+	return val;
+}
+
+int utilfdt_read_err(const char *filename, char **buffp)
+{
+	int fd = 0;	/* assume stdin */
+	char *buf = NULL;
+	off_t bufsize = 1024, offset = 0;
+	int ret = 0;
+
+	*buffp = NULL;
+	if (strcmp(filename, "-") != 0) {
+		fd = open(filename, O_RDONLY);
+		if (fd < 0)
+			return errno;
+	}
+
+	/* Loop until we have read everything */
+	buf = malloc(bufsize);
+	do {
+		/* Expand the buffer to hold the next chunk */
+		if (offset == bufsize) {
+			bufsize *= 2;
+			buf = realloc(buf, bufsize);
+			if (!buf) {
+				ret = ENOMEM;
+				break;
+			}
+		}
+
+		ret = read(fd, &buf[offset], bufsize - offset);
+		if (ret < 0) {
+			ret = errno;
+			break;
+		}
+		offset += ret;
+	} while (ret != 0);
+
+	/* Clean up, including closing stdin; return errno on error */
+	close(fd);
+	if (ret)
+		free(buf);
+	else
+		*buffp = buf;
+	return ret;
+}
+
+char *utilfdt_read(const char *filename)
+{
+	char *buff;
+	int ret = utilfdt_read_err(filename, &buff);
+
+	if (ret) {
+		fprintf(stderr, "Couldn't open blob from '%s': %s\n", filename,
+			strerror(ret));
+		return NULL;
+	}
+	/* Successful read */
+	return buff;
+}
+
+int utilfdt_write_err(const char *filename, const void *blob)
+{
+	int fd = 1;	/* assume stdout */
+	int totalsize;
+	int offset;
+	int ret = 0;
+	const char *ptr = blob;
+
+	if (strcmp(filename, "-") != 0) {
+		fd = open(filename, O_WRONLY | O_CREAT | O_TRUNC, 0666);
+		if (fd < 0)
+			return errno;
+	}
+
+	totalsize = fdt_totalsize(blob);
+	offset = 0;
+
+	while (offset < totalsize) {
+		ret = write(fd, ptr + offset, totalsize - offset);
+		if (ret < 0) {
+			ret = -errno;
+			break;
+		}
+		offset += ret;
+	}
+	/* Close the file/stdin; return errno on error */
+	if (fd != 1)
+		close(fd);
+	return ret < 0 ? -ret : 0;
+}
+
+
+int utilfdt_write(const char *filename, const void *blob)
+{
+	int ret = utilfdt_write_err(filename, blob);
+
+	if (ret) {
+		fprintf(stderr, "Couldn't write blob to '%s': %s\n", filename,
+			strerror(ret));
+	}
+	return ret ? -1 : 0;
+}
+
+int utilfdt_decode_type(const char *fmt, int *type, int *size)
+{
+	int qualifier = 0;
+
+	if (!*fmt)
+		return -1;
+
+	/* get the conversion qualifier */
+	*size = -1;
+	if (strchr("hlLb", *fmt)) {
+		qualifier = *fmt++;
+		if (qualifier == *fmt) {
+			switch (*fmt++) {
+/* TODO:		case 'l': qualifier = 'L'; break;*/
+			case 'h':
+				qualifier = 'b';
+				break;
+			}
+		}
+	}
+
+	/* we should now have a type */
+	if ((*fmt == '\0') || !strchr("iuxs", *fmt))
+		return -1;
+
+	/* convert qualifier (bhL) to byte size */
+	if (*fmt != 's')
+		*size = qualifier == 'b' ? 1 :
+				qualifier == 'h' ? 2 :
+				qualifier == 'l' ? 4 : -1;
+	*type = *fmt++;
+
+	/* that should be it! */
+	if (*fmt)
+		return -1;
+	return 0;
+}
diff --git a/scripts/dtc/util.h b/scripts/dtc/util.h
index 9cead84..c8eb45d 100644
--- a/scripts/dtc/util.h
+++ b/scripts/dtc/util.h
@@ -1,7 +1,10 @@
 #ifndef _UTIL_H
 #define _UTIL_H
 
+#include <stdarg.h>
+
 /*
+ * Copyright 2011 The Chromium Authors, All Rights Reserved.
  * Copyright 2008 Jon Loeliger, Freescale Semiconductor, Inc.
  *
  * This program is free software; you can redistribute it and/or
@@ -53,4 +56,98 @@ static inline void *xrealloc(void *p, size_t len)
 extern char *xstrdup(const char *s);
 extern char *join_path(const char *path, const char *name);
 
+/**
+ * Check a string of a given length to see if it is all printable and
+ * has a valid terminator.
+ *
+ * @param data	The string to check
+ * @param len	The string length including terminator
+ * @return 1 if a valid printable string, 0 if not */
+int util_is_printable_string(const void *data, int len);
+
+/*
+ * Parse an escaped character starting at index i in string s.  The resulting
+ * character will be returned and the index i will be updated to point at the
+ * character directly after the end of the encoding, this may be the '\0'
+ * terminator of the string.
+ */
+char get_escape_char(const char *s, int *i);
+
+/**
+ * Read a device tree file into a buffer. This will report any errors on
+ * stderr.
+ *
+ * @param filename	The filename to read, or - for stdin
+ * @return Pointer to allocated buffer containing fdt, or NULL on error
+ */
+char *utilfdt_read(const char *filename);
+
+/**
+ * Read a device tree file into a buffer. Does not report errors, but only
+ * returns them. The value returned can be passed to strerror() to obtain
+ * an error message for the user.
+ *
+ * @param filename	The filename to read, or - for stdin
+ * @param buffp		Returns pointer to buffer containing fdt
+ * @return 0 if ok, else an errno value representing the error
+ */
+int utilfdt_read_err(const char *filename, char **buffp);
+
+
+/**
+ * Write a device tree buffer to a file. This will report any errors on
+ * stderr.
+ *
+ * @param filename	The filename to write, or - for stdout
+ * @param blob		Poiner to buffer containing fdt
+ * @return 0 if ok, -1 on error
+ */
+int utilfdt_write(const char *filename, const void *blob);
+
+/**
+ * Write a device tree buffer to a file. Does not report errors, but only
+ * returns them. The value returned can be passed to strerror() to obtain
+ * an error message for the user.
+ *
+ * @param filename	The filename to write, or - for stdout
+ * @param blob		Poiner to buffer containing fdt
+ * @return 0 if ok, else an errno value representing the error
+ */
+int utilfdt_write_err(const char *filename, const void *blob);
+
+/**
+ * Decode a data type string. The purpose of this string
+ *
+ * The string consists of an optional character followed by the type:
+ *	Modifier characters:
+ *		hh or b	1 byte
+ *		h	2 byte
+ *		l	4 byte, default
+ *
+ *	Type character:
+ *		s	string
+ *		i	signed integer
+ *		u	unsigned integer
+ *		x	hex
+ *
+ * TODO: Implement ll modifier (8 bytes)
+ * TODO: Implement o type (octal)
+ *
+ * @param fmt		Format string to process
+ * @param type		Returns type found(s/d/u/x), or 0 if none
+ * @param size		Returns size found(1,2,4,8) or 4 if none
+ * @return 0 if ok, -1 on error (no type given, or other invalid format)
+ */
+int utilfdt_decode_type(const char *fmt, int *type, int *size);
+
+/*
+ * This is a usage message fragment for the -t option. It is the format
+ * supported by utilfdt_decode_type.
+ */
+
+#define USAGE_TYPE_MSG \
+	"<type>\ts=string, i=int, u=unsigned, x=hex\n" \
+	"\tOptional modifier prefix:\n" \
+	"\t\thh or b=byte, h=2 byte, l=4 byte (default)\n";
+
 #endif /* _UTIL_H */
-- 
1.7.0.4


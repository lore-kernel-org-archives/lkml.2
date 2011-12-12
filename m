Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113Ab1LLUOj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 15:14:39 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:36520 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430Ab1LLUOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 15:14:34 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.olzabs.org
Cc: microblaze-uclinux@itee.uq.edu.au,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 3/4] of: create of_phandle_args to simplify return of phandle parsing data
Date: Mon, 12 Dec 2011 13:14:11 -0700
Message-Id: <1323720852-26311-4-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323720852-26311-1-git-send-email-grant.likely@secretlab.ca>
References: <1323720852-26311-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_parse_phandle_with_args() needs to return quite a bit of data.  Rather
than making each datum a separate **out_ argument, this patch creates
struct of_phandle_args to contain all the returned data and reworks the
user of the function.  This patch also enables of_parse_phandle_with_args()
to return the device node pointer for the phandle node.

This patch also ends up being fairly major surgery to
of_parse_handle_with_args().  The existing structure didn't work well
when extending to use of_phandle_args, and I discovered bugs during testing.
I also took the opportunity to rename the function to be like the
existing of_parse_phandle().

v2: - moved declaration of of_phandle_args to fix compile on non-DT builds
    - fixed incorrect index in example usage
    - fixed incorrect return code handling for empty entries

Reviewed-by: Shawn Guo <shawn.guo@freescale.com>
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/of/base.c          |  146 ++++++++++++++++++++++---------------------
 drivers/of/gpio.c          |   43 ++++++-------
 include/asm-generic/gpio.h |    5 +-
 include/linux/of.h         |   11 +++-
 include/linux/of_gpio.h    |   10 ++-
 5 files changed, 112 insertions(+), 103 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 9b6588e..c6db9ab 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -824,17 +824,19 @@ of_parse_phandle(struct device_node *np, const char *phandle_name, int index)
 EXPORT_SYMBOL(of_parse_phandle);
 
 /**
- * of_parse_phandles_with_args - Find a node pointed by phandle in a list
+ * of_parse_phandle_with_args() - Find a node pointed by phandle in a list
  * @np:		pointer to a device tree node containing a list
  * @list_name:	property name that contains a list
  * @cells_name:	property name that specifies phandles' arguments count
  * @index:	index of a phandle to parse out
- * @out_node:	optional pointer to device_node struct pointer (will be filled)
- * @out_args:	optional pointer to arguments pointer (will be filled)
+ * @out_args:	optional pointer to output arguments structure (will be filled)
  *
  * This function is useful to parse lists of phandles and their arguments.
- * Returns 0 on success and fills out_node and out_args, on error returns
- * appropriate errno value.
+ * Returns 0 on success and fills out_args, on error returns appropriate
+ * errno value.
+ *
+ * Caller is responsible to call of_node_put() on the returned out_args->node
+ * pointer.
  *
  * Example:
  *
@@ -851,94 +853,96 @@ EXPORT_SYMBOL(of_parse_phandle);
  * }
  *
  * To get a device_node of the `node2' node you may call this:
- * of_parse_phandles_with_args(node3, "list", "#list-cells", 2, &node2, &args);
+ * of_parse_phandle_with_args(node3, "list", "#list-cells", 1, &args);
  */
-int of_parse_phandles_with_args(struct device_node *np, const char *list_name,
+int of_parse_phandle_with_args(struct device_node *np, const char *list_name,
 				const char *cells_name, int index,
-				struct device_node **out_node,
-				const void **out_args)
+				struct of_phandle_args *out_args)
 {
-	int ret = -EINVAL;
-	const __be32 *list;
-	const __be32 *list_end;
-	int size;
-	int cur_index = 0;
+	const __be32 *list, *list_end;
+	int size, cur_index = 0;
+	uint32_t count = 0;
 	struct device_node *node = NULL;
-	const void *args = NULL;
+	phandle phandle;
 
+	/* Retrieve the phandle list property */
 	list = of_get_property(np, list_name, &size);
-	if (!list) {
-		ret = -ENOENT;
-		goto err0;
-	}
+	if (!list)
+		return -EINVAL;
 	list_end = list + size / sizeof(*list);
 
+	/* Loop over the phandles until all the requested entry is found */
 	while (list < list_end) {
-		const __be32 *cells;
-		phandle phandle;
+		count = 0;
 
+		/*
+		 * If phandle is 0, then it is an empty entry with no
+		 * arguments.  Skip forward to the next entry.
+		 */
 		phandle = be32_to_cpup(list++);
-		args = list;
-
-		/* one cell hole in the list = <>; */
-		if (!phandle)
-			goto next;
-
-		node = of_find_node_by_phandle(phandle);
-		if (!node) {
-			pr_debug("%s: could not find phandle\n",
-				 np->full_name);
-			goto err0;
-		}
+		if (phandle) {
+			/*
+			 * Find the provider node and parse the #*-cells
+			 * property to determine the argument length
+			 */
+			node = of_find_node_by_phandle(phandle);
+			if (!node) {
+				pr_err("%s: could not find phandle\n",
+					 np->full_name);
+				break;
+			}
+			if (of_property_read_u32(node, cells_name, &count)) {
+				pr_err("%s: could not get %s for %s\n",
+					 np->full_name, cells_name,
+					 node->full_name);
+				break;
+			}
 
-		cells = of_get_property(node, cells_name, &size);
-		if (!cells || size != sizeof(*cells)) {
-			pr_debug("%s: could not get %s for %s\n",
-				 np->full_name, cells_name, node->full_name);
-			goto err1;
+			/*
+			 * Make sure that the arguments actually fit in the
+			 * remaining property data length
+			 */
+			if (list + count > list_end) {
+				pr_err("%s: arguments longer than property\n",
+					 np->full_name);
+				break;
+			}
 		}
 
-		list += be32_to_cpup(cells);
-		if (list > list_end) {
-			pr_debug("%s: insufficient arguments length\n",
-				 np->full_name);
-			goto err1;
+		/*
+		 * All of the error cases above bail out of the loop, so at
+		 * this point, the parsing is successful. If the requested
+		 * index matches, then fill the out_args structure and return,
+		 * or return -ENOENT for an empty entry.
+		 */
+		if (cur_index == index) {
+			if (!phandle)
+				return -ENOENT;
+
+			if (out_args) {
+				int i;
+				if (WARN_ON(count > MAX_PHANDLE_ARGS))
+					count = MAX_PHANDLE_ARGS;
+				out_args->np = node;
+				out_args->args_count = count;
+				for (i = 0; i < count; i++)
+					out_args->args[i] = be32_to_cpup(list++);
+			}
+			return 0;
 		}
-next:
-		if (cur_index == index)
-			break;
 
 		of_node_put(node);
 		node = NULL;
-		args = NULL;
+		list += count;
 		cur_index++;
 	}
 
-	if (!node) {
-		/*
-		 * args w/o node indicates that the loop above has stopped at
-		 * the 'hole' cell. Report this differently.
-		 */
-		if (args)
-			ret = -EEXIST;
-		else
-			ret = -ENOENT;
-		goto err0;
-	}
-
-	if (out_node)
-		*out_node = node;
-	if (out_args)
-		*out_args = args;
-
-	return 0;
-err1:
-	of_node_put(node);
-err0:
-	pr_debug("%s failed with status %d\n", __func__, ret);
-	return ret;
+	/* Loop exited without finding a valid entry; return an error */
+	if (node)
+		of_node_put(node);
+	return -EINVAL;
 }
-EXPORT_SYMBOL(of_parse_phandles_with_args);
+EXPORT_SYMBOL(of_parse_phandle_with_args);
 
 /**
  * prom_add_property - Add a property to a node
diff --git a/drivers/of/gpio.c b/drivers/of/gpio.c
index ef0105f..244a2b0 100644
--- a/drivers/of/gpio.c
+++ b/drivers/of/gpio.c
@@ -35,32 +35,27 @@ int of_get_named_gpio_flags(struct device_node *np, const char *propname,
                            int index, enum of_gpio_flags *flags)
 {
 	int ret;
-	struct device_node *gpio_np;
 	struct gpio_chip *gc;
-	int size;
-	const void *gpio_spec;
-	const __be32 *gpio_cells;
+	struct of_phandle_args gpiospec;
 
-	ret = of_parse_phandles_with_args(np, propname, "#gpio-cells", index,
-					  &gpio_np, &gpio_spec);
+	ret = of_parse_phandle_with_args(np, propname, "#gpio-cells", index,
+					 &gpiospec);
 	if (ret) {
 		pr_debug("%s: can't parse gpios property\n", __func__);
 		goto err0;
 	}
 
-	gc = of_node_to_gpiochip(gpio_np);
+	gc = of_node_to_gpiochip(gpiospec.np);
 	if (!gc) {
 		pr_debug("%s: gpio controller %s isn't registered\n",
-			 np->full_name, gpio_np->full_name);
+			 np->full_name, gpiospec.np->full_name);
 		ret = -ENODEV;
 		goto err1;
 	}
 
-	gpio_cells = of_get_property(gpio_np, "#gpio-cells", &size);
-	if (!gpio_cells || size != sizeof(*gpio_cells) ||
-			be32_to_cpup(gpio_cells) != gc->of_gpio_n_cells) {
+	if (gpiospec.args_count != gc->of_gpio_n_cells) {
 		pr_debug("%s: wrong #gpio-cells for %s\n",
-			 np->full_name, gpio_np->full_name);
+			 np->full_name, gpiospec.np->full_name);
 		ret = -EINVAL;
 		goto err1;
 	}
@@ -69,13 +64,13 @@ int of_get_named_gpio_flags(struct device_node *np, const char *propname,
 	if (flags)
 		*flags = 0;
 
-	ret = gc->of_xlate(gc, np, gpio_spec, flags);
+	ret = gc->of_xlate(gc, &gpiospec, flags);
 	if (ret < 0)
 		goto err1;
 
 	ret += gc->base;
 err1:
-	of_node_put(gpio_np);
+	of_node_put(gpiospec.np);
 err0:
 	pr_debug("%s exited with status %d\n", __func__, ret);
 	return ret;
@@ -105,8 +100,8 @@ unsigned int of_gpio_count(struct device_node *np)
 	do {
 		int ret;
 
-		ret = of_parse_phandles_with_args(np, "gpios", "#gpio-cells",
-						  cnt, NULL, NULL);
+		ret = of_parse_phandle_with_args(np, "gpios", "#gpio-cells",
+						 cnt, NULL);
 		/* A hole in the gpios = <> counts anyway. */
 		if (ret < 0 && ret != -EEXIST)
 			break;
@@ -127,12 +122,9 @@ EXPORT_SYMBOL(of_gpio_count);
  * gpio chips. This function performs only one sanity check: whether gpio
  * is less than ngpios (that is specified in the gpio_chip).
  */
-int of_gpio_simple_xlate(struct gpio_chip *gc, struct device_node *np,
-			 const void *gpio_spec, u32 *flags)
+int of_gpio_simple_xlate(struct gpio_chip *gc,
+			 const struct of_phandle_args *gpiospec, u32 *flags)
 {
-	const __be32 *gpio = gpio_spec;
-	const u32 n = be32_to_cpup(gpio);
-
 	/*
 	 * We're discouraging gpio_cells < 2, since that way you'll have to
 	 * write your own xlate function (that will have to retrive the GPIO
@@ -144,13 +136,16 @@ int of_gpio_simple_xlate(struct gpio_chip *gc, struct device_node *np,
 		return -EINVAL;
 	}
 
-	if (n > gc->ngpio)
+	if (WARN_ON(gpiospec->args_count < gc->of_gpio_n_cells))
+		return -EINVAL;
+
+	if (gpiospec->args[0] > gc->ngpio)
 		return -EINVAL;
 
 	if (flags)
-		*flags = be32_to_cpu(gpio[1]);
+		*flags = gpiospec->args[1];
 
-	return n;
+	return gpiospec->args[0];
 }
 EXPORT_SYMBOL(of_gpio_simple_xlate);
 
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index 6b10bdc..d466c8d 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -4,6 +4,7 @@
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/errno.h>
+#include <linux/of.h>
 
 #ifdef CONFIG_GPIOLIB
 
@@ -128,8 +129,8 @@ struct gpio_chip {
 	 */
 	struct device_node *of_node;
 	int of_gpio_n_cells;
-	int (*of_xlate)(struct gpio_chip *gc, struct device_node *np,
-		        const void *gpio_spec, u32 *flags);
+	int (*of_xlate)(struct gpio_chip *gc,
+		        const struct of_phandle_args *gpiospec, u32 *flags);
 #endif
 };
 
diff --git a/include/linux/of.h b/include/linux/of.h
index 4948552..ea44fd7 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -65,6 +65,13 @@ struct device_node {
 #endif
 };
 
+#define MAX_PHANDLE_ARGS 8
+struct of_phandle_args {
+	struct device_node *np;
+	int args_count;
+	uint32_t args[MAX_PHANDLE_ARGS];
+};
+
 #ifdef CONFIG_OF
 
 /* Pointer for first entry in chain of all nodes. */
@@ -230,9 +237,9 @@ extern int of_modalias_node(struct device_node *node, char *modalias, int len);
 extern struct device_node *of_parse_phandle(struct device_node *np,
 					    const char *phandle_name,
 					    int index);
-extern int of_parse_phandles_with_args(struct device_node *np,
+extern int of_parse_phandle_with_args(struct device_node *np,
 	const char *list_name, const char *cells_name, int index,
-	struct device_node **out_node, const void **out_args);
+	struct of_phandle_args *out_args);
 
 extern void of_alias_scan(void * (*dt_alloc)(u64 size, u64 align));
 extern int of_alias_get_id(struct device_node *np, const char *stem);
diff --git a/include/linux/of_gpio.h b/include/linux/of_gpio.h
index 52280a2..b254052 100644
--- a/include/linux/of_gpio.h
+++ b/include/linux/of_gpio.h
@@ -18,6 +18,7 @@
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/gpio.h>
+#include <linux/of.h>
 
 struct device_node;
 
@@ -57,8 +58,9 @@ extern int of_mm_gpiochip_add(struct device_node *np,
 extern void of_gpiochip_add(struct gpio_chip *gc);
 extern void of_gpiochip_remove(struct gpio_chip *gc);
 extern struct gpio_chip *of_node_to_gpiochip(struct device_node *np);
-extern int of_gpio_simple_xlate(struct gpio_chip *gc, struct device_node *np,
-				const void *gpio_spec, u32 *flags);
+extern int of_gpio_simple_xlate(struct gpio_chip *gc,
+				const struct of_phandle_args *gpiospec,
+				u32 *flags);
 
 #else /* CONFIG_OF_GPIO */
 
@@ -75,8 +77,8 @@ static inline unsigned int of_gpio_count(struct device_node *np)
 }
 
 static inline int of_gpio_simple_xlate(struct gpio_chip *gc,
-				       struct device_node *np,
-				       const void *gpio_spec, u32 *flags)
+				       const struct of_phandle_args *gpiospec,
+				       u32 *flags)
 {
 	return -ENOSYS;
 }
-- 
1.7.5.4


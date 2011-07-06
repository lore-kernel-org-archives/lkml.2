Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209Ab1GFUnL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 16:43:11 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48657 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756106Ab1GFUnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 16:43:10 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-arm-kernel@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>, linux@arm.linux.org.uk,
        Barry Song <21cnbao@gmail.com>, workgroup.linux@csr.com,
        Olof Johansson <olof@lixom.net>, tglx@linutronix.de,
        weizeng.he@csr.com, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH v4 2/2] ARM: l2x0: Add OF based initialization
Date: Wed,  6 Jul 2011 15:42:59 -0500
Message-Id: <1309984979-8847-2-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309984979-8847-1-git-send-email-robherring2@gmail.com>
References: <1309984979-8847-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

This adds probing for ARM L2x0 cache controllers via device tree. Support
includes the L210, L220, and PL310 controllers. The binding allows setting
up cache RAM latencies and filter addresses (PL310 only).

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
---
Changes in v4:
- Documentation fixes
- Add "arm," prefix to bindings
- Change filter-ranges binding values to <start length>
- Refactor l2x0 and pl310 init into separate functions
- Use new OF helpers to read u32 binding values.

 Documentation/devicetree/bindings/arm/l2cc.txt |   43 ++++++++++
 arch/arm/include/asm/hardware/cache-l2x0.h     |   17 ++++
 arch/arm/mm/cache-l2x0.c                       |  103 ++++++++++++++++++++++++
 3 files changed, 163 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/l2cc.txt

diff --git a/Documentation/devicetree/bindings/arm/l2cc.txt b/Documentation/devicetree/bindings/arm/l2cc.txt
new file mode 100644
index 0000000..ab5b3f0
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/l2cc.txt
@@ -0,0 +1,43 @@
+* ARM L2 Cache Controller
+
+ARM cores often have a separate level 2 cache controller. There are various
+implementations of the L2 cache controller with compatible programming models.
+The ARM L2 cache representation in the device tree should be done as follows:
+
+Required properties:
+
+- compatible : should be one of:
+	"arm,pl310-cache"
+	"arm,l220-cache"
+	"arm,l210-cache"
+- cache-unified : Specifies the cache is a unified cache.
+- cache-level : Should be set to 2 for a level 2 cache.
+- reg : Physical base address and size of cache controller's memory mapped
+  registers.
+
+Optional properties:
+
+- arm,data-latency : Cycles of latency for Data RAM accesses. Specifies 3 cells of
+  read, write and setup latencies. Minimum valid values are 1. Controllers
+  without setup latency control should use a value of 0.
+- arm,tag-latency : Cycles of latency for Tag RAM accesses. Specifies 3 cells of
+  read, write and setup latencies. Controllers without setup latency control
+  should use 0. Controllers without separate read and write Tag RAM latency
+  values should only use the first cell.
+- arm,dirty-latency : Cycles of latency for Dirty RAMs. This is a single cell.
+- arm,filter-ranges : <start length> Starting address and length of window to
+  filter. Addresses in the filter window are directed to the M1 port. Other
+  addresses will go to the M0 port.
+
+Example:
+
+L2: cache-controller {
+        compatible = "arm,pl310-cache";
+        reg = <0xfff12000 0x1000>;
+        arm,data-latency = <1 1 1>;
+        arm,tag-latency = <2 2 2>;
+        arm,filter-latency = <0x80000000 0x8000000>;
+        cache-unified;
+        cache-level = <2>;
+};
+
diff --git a/arch/arm/include/asm/hardware/cache-l2x0.h b/arch/arm/include/asm/hardware/cache-l2x0.h
index 16bd480..8fe149f 100644
--- a/arch/arm/include/asm/hardware/cache-l2x0.h
+++ b/arch/arm/include/asm/hardware/cache-l2x0.h
@@ -47,6 +47,8 @@
 #define L2X0_CLEAN_INV_WAY		0x7FC
 #define L2X0_LOCKDOWN_WAY_D		0x900
 #define L2X0_LOCKDOWN_WAY_I		0x904
+#define L2X0_ADDR_FILTER_START		0xC00
+#define L2X0_ADDR_FILTER_END		0xC04
 #define L2X0_TEST_OPERATION		0xF00
 #define L2X0_LINE_DATA			0xF10
 #define L2X0_LINE_TAG			0xF30
@@ -62,6 +64,14 @@
 #define L2X0_CACHE_ID_PART_L310		(3 << 6)
 
 #define L2X0_AUX_CTRL_MASK			0xc0000fff
+#define L2X0_AUX_CTRL_DATA_RD_LATENCY_SHIFT	0
+#define L2X0_AUX_CTRL_DATA_RD_LATENCY_MASK	0x7
+#define L2X0_AUX_CTRL_DATA_WR_LATENCY_SHIFT	3
+#define L2X0_AUX_CTRL_DATA_WR_LATENCY_MASK	(0x7 << 3)
+#define L2X0_AUX_CTRL_TAG_LATENCY_SHIFT		6
+#define L2X0_AUX_CTRL_TAG_LATENCY_MASK		(0x7 << 6)
+#define L2X0_AUX_CTRL_DIRTY_LATENCY_SHIFT	9
+#define L2X0_AUX_CTRL_DIRTY_LATENCY_MASK	(0x7 << 9)
 #define L2X0_AUX_CTRL_ASSOCIATIVITY_SHIFT	16
 #define L2X0_AUX_CTRL_WAY_SIZE_SHIFT		17
 #define L2X0_AUX_CTRL_WAY_SIZE_MASK		(0x3 << 17)
@@ -72,8 +82,15 @@
 #define L2X0_AUX_CTRL_INSTR_PREFETCH_SHIFT	29
 #define L2X0_AUX_CTRL_EARLY_BRESP_SHIFT		30
 
+#define L2X0_LATENCY_CTRL_SETUP_SHIFT	0
+#define L2X0_LATENCY_CTRL_RD_SHIFT	4
+#define L2X0_LATENCY_CTRL_WR_SHIFT	8
+
+#define L2X0_ADDR_FILTER_EN		1
+
 #ifndef __ASSEMBLY__
 extern void __init l2x0_init(void __iomem *base, __u32 aux_val, __u32 aux_mask);
+extern int l2x0_of_init(__u32 aux_val, __u32 aux_mask);
 #endif
 
 #endif
diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
index ef59099..274dc54 100644
--- a/arch/arm/mm/cache-l2x0.c
+++ b/arch/arm/mm/cache-l2x0.c
@@ -16,9 +16,12 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
+#include <linux/err.h>
 #include <linux/init.h>
 #include <linux/spinlock.h>
 #include <linux/io.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
 
 #include <asm/cacheflush.h>
 #include <asm/hardware/cache-l2x0.h>
@@ -344,3 +347,103 @@ void __init l2x0_init(void __iomem *base, __u32 aux_val, __u32 aux_mask)
 	printk(KERN_INFO "l2x0: %d ways, CACHE_ID 0x%08x, AUX_CTRL 0x%08x, Cache size: %d B\n",
 			ways, cache_id, aux, l2x0_size);
 }
+
+#ifdef CONFIG_OF
+static void __init l2x0_of_setup(const struct device_node *np,
+				 __u32 *aux_val, __u32 *aux_mask)
+{
+	u32 data[2] = { 0, 0 };
+	u32 tag = 0;
+	u32 dirty = 0;
+	u32 val = 0, mask = 0;
+
+	of_property_read_u32(np, "arm,tag-latency", &tag);
+	if (tag) {
+		mask |= L2X0_AUX_CTRL_TAG_LATENCY_MASK;
+		val |= (tag - 1) << L2X0_AUX_CTRL_TAG_LATENCY_SHIFT;
+	}
+
+	of_property_read_u32_array(np, "arm,data-latency",
+				   data, ARRAY_SIZE(data));
+	if (data[0] && data[1]) {
+		mask |= L2X0_AUX_CTRL_DATA_RD_LATENCY_MASK |
+			L2X0_AUX_CTRL_DATA_WR_LATENCY_MASK;
+		val |= ((data[0] - 1) << L2X0_AUX_CTRL_DATA_RD_LATENCY_SHIFT) |
+		       ((data[1] - 1) << L2X0_AUX_CTRL_DATA_WR_LATENCY_SHIFT);
+	}
+
+	of_property_read_u32(np, "arm,dirty-latency", &dirty);
+	if (dirty) {
+		mask |= L2X0_AUX_CTRL_DIRTY_LATENCY_MASK;
+		val |= (dirty - 1) << L2X0_AUX_CTRL_DIRTY_LATENCY_SHIFT;
+	}
+
+	*aux_val &= ~mask;
+	*aux_val |= val;
+	*aux_mask &= ~mask;
+}
+
+static void __init pl310_of_setup(const struct device_node *np,
+				  __u32 *aux_val, __u32 *aux_mask)
+{
+	u32 data[3] = { 0, 0, 0 };
+	u32 tag[3] = { 0, 0, 0 };
+	u32 filter[2] = { 0, 0 };
+
+	of_property_read_u32_array(np, "arm,tag-latency", tag, ARRAY_SIZE(tag));
+	if (tag[0] && tag[1] && tag[2])
+		writel_relaxed(
+			((tag[0] - 1) << L2X0_LATENCY_CTRL_RD_SHIFT) |
+			((tag[1] - 1) << L2X0_LATENCY_CTRL_WR_SHIFT) |
+			((tag[2] - 1) << L2X0_LATENCY_CTRL_SETUP_SHIFT),
+			l2x0_base + L2X0_TAG_LATENCY_CTRL);
+
+	of_property_read_u32_array(np, "arm,data-latency",
+				   data, ARRAY_SIZE(data));
+	if (data[0] && data[1] && data[2])
+		writel_relaxed(
+			((data[0] - 1) << L2X0_LATENCY_CTRL_RD_SHIFT) |
+			((data[1] - 1) << L2X0_LATENCY_CTRL_WR_SHIFT) |
+			((data[2] - 1) << L2X0_LATENCY_CTRL_SETUP_SHIFT),
+			l2x0_base + L2X0_DATA_LATENCY_CTRL);
+
+	of_property_read_u32_array(np, "arm,filter-ranges",
+				   filter, ARRAY_SIZE(filter));
+	if (filter[0] && filter[1]) {
+		writel_relaxed(ALIGN(filter[0] + filter[1], SZ_1M),
+			       l2x0_base + L2X0_ADDR_FILTER_END);
+		writel_relaxed((filter[0] & ~(SZ_1M - 1)) | L2X0_ADDR_FILTER_EN,
+			       l2x0_base + L2X0_ADDR_FILTER_START);
+	}
+}
+
+static const struct of_device_id l2x0_ids[] __initconst = {
+	{ .compatible = "arm,pl310-cache", .data = pl310_of_setup },
+	{ .compatible = "arm,l220-cache", .data = l2x0_of_setup },
+	{ .compatible = "arm,l210-cache", .data = l2x0_of_setup },
+	{}
+};
+
+int __init l2x0_of_init(__u32 aux_val, __u32 aux_mask)
+{
+	struct device_node *np;
+	void (*l2_setup)(const struct device_node *np,
+		__u32 *aux_val, __u32 *aux_mask);
+
+	np = of_find_matching_node(NULL, l2x0_ids);
+	if (!np)
+		return -ENODEV;
+	l2x0_base = of_iomap(np, 0);
+	if (!l2x0_base)
+		return -ENOMEM;
+
+	/* L2 configuration can only be changed if the cache is disabled */
+	if (!(readl_relaxed(l2x0_base + L2X0_CTRL) & 1)) {
+		l2_setup = of_match_node(l2x0_ids, np)->data;
+		if (l2_setup)
+			l2_setup(np, &aux_val, &aux_mask);
+	}
+	l2x0_init(l2x0_base, aux_val, aux_mask);
+	return 0;
+}
+#endif
-- 
1.7.4.1


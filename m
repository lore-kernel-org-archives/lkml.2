Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700Ab0DVT3Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:29:16 -0400
Received: from kroah.org ([198.145.64.141]:41100 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756635Ab0DVT3C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:29:02 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:17 2010
Message-Id: <20100422190917.648360441@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:09:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Borislav Petkov <borislav.petkov@amd.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [115/197] x86, cacheinfo: Enable L3 CID only on AMD
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Borislav Petkov <borislav.petkov@amd.com>

commit cb19060abfdecac0d1eb2d2f0e7d6b7a3f8bc4f4 upstream.

Final stage linking can fail with

 arch/x86/built-in.o: In function `store_cache_disable':
 intel_cacheinfo.c:(.text+0xc509): undefined reference to `amd_get_nb_id'
 arch/x86/built-in.o: In function `show_cache_disable':
 intel_cacheinfo.c:(.text+0xc7d3): undefined reference to `amd_get_nb_id'

when CONFIG_CPU_SUP_AMD is not enabled because the amd_get_nb_id
helper is defined in AMD-specific code but also used in generic code
(intel_cacheinfo.c). Reorganize the L3 cache index disable code under
CONFIG_CPU_SUP_AMD since it is AMD-only anyway.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
LKML-Reference: <20100218184210.GF20473@aftab>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/cpu/intel_cacheinfo.c |  186 +++++++++++++++++-----------------
 1 file changed, 98 insertions(+), 88 deletions(-)

--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -293,6 +293,13 @@ amd_cpuid4(int leaf, union _cpuid4_leaf_
 		(ebx->split.ways_of_associativity + 1) - 1;
 }
 
+struct _cache_attr {
+	struct attribute attr;
+	ssize_t (*show)(struct _cpuid4_info *, char *);
+	ssize_t (*store)(struct _cpuid4_info *, const char *, size_t count);
+};
+
+#ifdef CONFIG_CPU_SUP_AMD
 static unsigned int __cpuinit amd_calc_l3_indices(void)
 {
 	/*
@@ -303,7 +310,7 @@ static unsigned int __cpuinit amd_calc_l
 	int node = cpu_to_node(cpu);
 	struct pci_dev *dev = node_to_k8_nb_misc(node);
 	unsigned int sc0, sc1, sc2, sc3;
-	u32 val;
+	u32 val = 0;
 
 	pci_read_config_dword(dev, 0x1C4, &val);
 
@@ -335,6 +342,94 @@ amd_check_l3_disable(int index, struct _
 	this_leaf->l3_indices  = amd_calc_l3_indices();
 }
 
+static ssize_t show_cache_disable(struct _cpuid4_info *this_leaf, char *buf,
+				  unsigned int index)
+{
+	int cpu = cpumask_first(to_cpumask(this_leaf->shared_cpu_map));
+	int node = amd_get_nb_id(cpu);
+	struct pci_dev *dev = node_to_k8_nb_misc(node);
+	unsigned int reg = 0;
+
+	if (!this_leaf->can_disable)
+		return -EINVAL;
+
+	if (!dev)
+		return -EINVAL;
+
+	pci_read_config_dword(dev, 0x1BC + index * 4, &reg);
+	return sprintf(buf, "0x%08x\n", reg);
+}
+
+#define SHOW_CACHE_DISABLE(index)					\
+static ssize_t								\
+show_cache_disable_##index(struct _cpuid4_info *this_leaf, char *buf)	\
+{									\
+	return show_cache_disable(this_leaf, buf, index);		\
+}
+SHOW_CACHE_DISABLE(0)
+SHOW_CACHE_DISABLE(1)
+
+static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
+	const char *buf, size_t count, unsigned int index)
+{
+	int cpu = cpumask_first(to_cpumask(this_leaf->shared_cpu_map));
+	int node = amd_get_nb_id(cpu);
+	struct pci_dev *dev = node_to_k8_nb_misc(node);
+	unsigned long val = 0;
+
+#define SUBCACHE_MASK	(3UL << 20)
+#define SUBCACHE_INDEX	0xfff
+
+	if (!this_leaf->can_disable)
+		return -EINVAL;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (!dev)
+		return -EINVAL;
+
+	if (strict_strtoul(buf, 10, &val) < 0)
+		return -EINVAL;
+
+	/* do not allow writes outside of allowed bits */
+	if ((val & ~(SUBCACHE_MASK | SUBCACHE_INDEX)) ||
+	    ((val & SUBCACHE_INDEX) > this_leaf->l3_indices))
+		return -EINVAL;
+
+	val |= BIT(30);
+	pci_write_config_dword(dev, 0x1BC + index * 4, val);
+	/*
+	 * We need to WBINVD on a core on the node containing the L3 cache which
+	 * indices we disable therefore a simple wbinvd() is not sufficient.
+	 */
+	wbinvd_on_cpu(cpu);
+	pci_write_config_dword(dev, 0x1BC + index * 4, val | BIT(31));
+	return count;
+}
+
+#define STORE_CACHE_DISABLE(index)					\
+static ssize_t								\
+store_cache_disable_##index(struct _cpuid4_info *this_leaf,		\
+			    const char *buf, size_t count)		\
+{									\
+	return store_cache_disable(this_leaf, buf, count, index);	\
+}
+STORE_CACHE_DISABLE(0)
+STORE_CACHE_DISABLE(1)
+
+static struct _cache_attr cache_disable_0 = __ATTR(cache_disable_0, 0644,
+		show_cache_disable_0, store_cache_disable_0);
+static struct _cache_attr cache_disable_1 = __ATTR(cache_disable_1, 0644,
+		show_cache_disable_1, store_cache_disable_1);
+
+#else	/* CONFIG_CPU_SUP_AMD */
+static void __cpuinit
+amd_check_l3_disable(int index, struct _cpuid4_info_regs *this_leaf)
+{
+};
+#endif /* CONFIG_CPU_SUP_AMD */
+
 static int
 __cpuinit cpuid4_cache_lookup_regs(int index,
 				   struct _cpuid4_info_regs *this_leaf)
@@ -755,88 +850,6 @@ static ssize_t show_type(struct _cpuid4_
 #define to_object(k)	container_of(k, struct _index_kobject, kobj)
 #define to_attr(a)	container_of(a, struct _cache_attr, attr)
 
-static ssize_t show_cache_disable(struct _cpuid4_info *this_leaf, char *buf,
-				  unsigned int index)
-{
-	int cpu = cpumask_first(to_cpumask(this_leaf->shared_cpu_map));
-	int node = amd_get_nb_id(cpu);
-	struct pci_dev *dev = node_to_k8_nb_misc(node);
-	unsigned int reg = 0;
-
-	if (!this_leaf->can_disable)
-		return -EINVAL;
-
-	if (!dev)
-		return -EINVAL;
-
-	pci_read_config_dword(dev, 0x1BC + index * 4, &reg);
-	return sprintf(buf, "0x%08x\n", reg);
-}
-
-#define SHOW_CACHE_DISABLE(index)					\
-static ssize_t								\
-show_cache_disable_##index(struct _cpuid4_info *this_leaf, char *buf)	\
-{									\
-	return show_cache_disable(this_leaf, buf, index);		\
-}
-SHOW_CACHE_DISABLE(0)
-SHOW_CACHE_DISABLE(1)
-
-static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
-	const char *buf, size_t count, unsigned int index)
-{
-	int cpu = cpumask_first(to_cpumask(this_leaf->shared_cpu_map));
-	int node = amd_get_nb_id(cpu);
-	struct pci_dev *dev = node_to_k8_nb_misc(node);
-	unsigned long val = 0;
-
-#define SUBCACHE_MASK	(3UL << 20)
-#define SUBCACHE_INDEX	0xfff
-
-	if (!this_leaf->can_disable)
-		return -EINVAL;
-
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
-
-	if (!dev)
-		return -EINVAL;
-
-	if (strict_strtoul(buf, 10, &val) < 0)
-		return -EINVAL;
-
-	/* do not allow writes outside of allowed bits */
-	if ((val & ~(SUBCACHE_MASK | SUBCACHE_INDEX)) ||
-	    ((val & SUBCACHE_INDEX) > this_leaf->l3_indices))
-		return -EINVAL;
-
-	val |= BIT(30);
-	pci_write_config_dword(dev, 0x1BC + index * 4, val);
-	/*
-	 * We need to WBINVD on a core on the node containing the L3 cache which
-	 * indices we disable therefore a simple wbinvd() is not sufficient.
-	 */
-	wbinvd_on_cpu(cpu);
-	pci_write_config_dword(dev, 0x1BC + index * 4, val | BIT(31));
-	return count;
-}
-
-#define STORE_CACHE_DISABLE(index)					\
-static ssize_t								\
-store_cache_disable_##index(struct _cpuid4_info *this_leaf,		\
-			    const char *buf, size_t count)		\
-{									\
-	return store_cache_disable(this_leaf, buf, count, index);	\
-}
-STORE_CACHE_DISABLE(0)
-STORE_CACHE_DISABLE(1)
-
-struct _cache_attr {
-	struct attribute attr;
-	ssize_t (*show)(struct _cpuid4_info *, char *);
-	ssize_t (*store)(struct _cpuid4_info *, const char *, size_t count);
-};
-
 #define define_one_ro(_name) \
 static struct _cache_attr _name = \
 	__ATTR(_name, 0444, show_##_name, NULL)
@@ -851,11 +864,6 @@ define_one_ro(size);
 define_one_ro(shared_cpu_map);
 define_one_ro(shared_cpu_list);
 
-static struct _cache_attr cache_disable_0 = __ATTR(cache_disable_0, 0644,
-		show_cache_disable_0, store_cache_disable_0);
-static struct _cache_attr cache_disable_1 = __ATTR(cache_disable_1, 0644,
-		show_cache_disable_1, store_cache_disable_1);
-
 #define DEFAULT_SYSFS_CACHE_ATTRS	\
 	&type.attr,			\
 	&level.attr,			\
@@ -874,8 +882,10 @@ static struct attribute *default_attrs[]
 
 static struct attribute *default_l3_attrs[] = {
 	DEFAULT_SYSFS_CACHE_ATTRS,
+#ifdef CONFIG_CPU_SUP_AMD
 	&cache_disable_0.attr,
 	&cache_disable_1.attr,
+#endif
 	NULL
 };
 



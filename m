Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757205Ab0DVTs2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:48:28 -0400
Received: from kroah.org ([198.145.64.141]:41076 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756557Ab0DVT27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:28:59 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:17 2010
Message-Id: <20100422190917.380978149@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:09:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Borislav Petkov <borislav.petkov@amd.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [112/197] x86, cacheinfo: Add cache index disable sysfs attrs only to L3 caches
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Borislav Petkov <borislav.petkov@amd.com>

commit 897de50e08937663912c86fb12ad7f708af2386c upstream.

The cache_disable_[01] attribute in

/sys/devices/system/cpu/cpu?/cache/index[0-3]/

is enabled on all cache levels although only L3 supports it. Add it only
to the cache level that actually supports it.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
LKML-Reference: <1264172467-25155-5-git-send-email-bp@amd64.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/cpu/intel_cacheinfo.c |   35 +++++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 9 deletions(-)

--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -829,16 +829,24 @@ static struct _cache_attr cache_disable_
 static struct _cache_attr cache_disable_1 = __ATTR(cache_disable_1, 0644,
 		show_cache_disable_1, store_cache_disable_1);
 
+#define DEFAULT_SYSFS_CACHE_ATTRS	\
+	&type.attr,			\
+	&level.attr,			\
+	&coherency_line_size.attr,	\
+	&physical_line_partition.attr,	\
+	&ways_of_associativity.attr,	\
+	&number_of_sets.attr,		\
+	&size.attr,			\
+	&shared_cpu_map.attr,		\
+	&shared_cpu_list.attr
+
 static struct attribute *default_attrs[] = {
-	&type.attr,
-	&level.attr,
-	&coherency_line_size.attr,
-	&physical_line_partition.attr,
-	&ways_of_associativity.attr,
-	&number_of_sets.attr,
-	&size.attr,
-	&shared_cpu_map.attr,
-	&shared_cpu_list.attr,
+	DEFAULT_SYSFS_CACHE_ATTRS,
+	NULL
+};
+
+static struct attribute *default_l3_attrs[] = {
+	DEFAULT_SYSFS_CACHE_ATTRS,
 	&cache_disable_0.attr,
 	&cache_disable_1.attr,
 	NULL
@@ -931,6 +939,7 @@ static int __cpuinit cache_add_dev(struc
 	unsigned int cpu = sys_dev->id;
 	unsigned long i, j;
 	struct _index_kobject *this_object;
+	struct _cpuid4_info   *this_leaf;
 	int retval;
 
 	retval = cpuid4_cache_sysfs_init(cpu);
@@ -949,6 +958,14 @@ static int __cpuinit cache_add_dev(struc
 		this_object = INDEX_KOBJECT_PTR(cpu, i);
 		this_object->cpu = cpu;
 		this_object->index = i;
+
+		this_leaf = CPUID4_INFO_IDX(cpu, i);
+
+		if (this_leaf->can_disable)
+			ktype_cache.default_attrs = default_l3_attrs;
+		else
+			ktype_cache.default_attrs = default_attrs;
+
 		retval = kobject_init_and_add(&(this_object->kobj),
 					      &ktype_cache,
 					      per_cpu(cache_kobject, cpu),



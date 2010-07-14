Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338Ab0GNIe4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 04:34:56 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49329 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124Ab0GNIes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 04:34:48 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 14 Jul 2010 17:30:05 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Nathan Fontenot <nfont@austin.ibm.com>, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/7] Allow sysfs memory directories to be split
Message-Id: <20100714173005.41950c92.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100714122503.74f746a2.kamezawa.hiroyu@jp.fujitsu.com>
References: <4C3B3446.5090302@austin.ibm.com>
	<4C3B3895.3040209@austin.ibm.com>
	<20100713152854.ec1f4d6a.kamezawa.hiroyu@jp.fujitsu.com>
	<4C3C8B9E.7000208@austin.ibm.com>
	<20100714093550.40036034.kamezawa.hiroyu@jp.fujitsu.com>
	<4C3D2C6B.3050203@austin.ibm.com>
	<20100714122503.74f746a2.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jul 2010 12:25:03 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Tue, 13 Jul 2010 22:18:03 -0500
> Nathan Fontenot <nfont@austin.ibm.com> wrote:
> 
> > On 07/13/2010 07:35 PM, KAMEZAWA Hiroyuki wrote:
> > > On Tue, 13 Jul 2010 10:51:58 -0500
> > > Nathan Fontenot <nfont@austin.ibm.com> wrote:
> > > 
> > >>>
> > >>> And for what purpose this interface is ? Does this split memory block into 2 pieces
> > >>> of the same size ?? sounds __very__ strange interface to me.
> > >>
> > >> Yes, this splits the memory_block into two blocks of the same size.  This was
> > >> suggested as something we may want to do.  From ppc perspective I am not sure we
> > >> would use this.
> > >>
> > >> The split functionality is not required.  The main goal of the patch set is to
> > >> reduce the number of memory sysfs directories created.  From a ppc perspective
> > >> the split functionality is not really needed.
> > >>
> > > 
> > > Okay, this is an offer from me.
> > > 
> > >   1. I think you can add an boot option as "don't create memory sysfs".
> > >      please do.
> > 
> > I posted a patch to do that a week or so ago, it didn't go over very well.
> > 
> > > 
> > >   2. I'd like to write a configfs module for handling memory hotplug even when
> > >      sysfs directroy is not created.
> > >      Because configfs support rmdir/mkdir, the user (ppc's daemon?) has to do
> > >      
> > >      When offlining section X.
> > >      # insmod configfs_memory.ko
> > >      # mount -t configfs none /configfs
> > >      # mkdir /configfs/memoryX
> > >      # echo offline > /configfs/memoryX/state
> > >      # rmdir /configfs/memoryX
> > > 
> > >   And making this operation as the default bahavior for all arch's memory hotplug may
> > >   be better...
> > > 
> > > Dave, how do you think ? Because ppc guys uses "probe" interface already,
> > > this can be handled... no ?
> > 
> > ppc would still require the existance of the 'probe' interface.
> > 
> > Are you objecting to the 'split' functionality? 
> yes.
> 
> > If so I do not see any reason from ppc
> > perspective that it is needed.  This was something Dave suggested, unless I am missing
> > something.
> > 
> > Since ppc needs the 'probe' interface in sysfs, and for ppc having mutliple 
> > memory_block_sections reside under a single memory_block makes memory hotplug
> > simpler.  On ppc we do emory hotplug operations on an LMB size basis.  With my
> > patches this now lets us set each memory_block to span an LMB's worth of
> > memory.  Now we could do emory hotplug in a single operation instead of multiple
> > operations to offline/online all of the memory sections in an LMB.
> > 
> 
> Why per-section memory offlining is provided is for allowing good success-rate of
> memory offlining. Because memory-hotplug has to "migrate or free" all used page
> under a section, possibility of memory unplug depends on usage of memory.
> If a section contains unmovable page(kernel page), we can't offline sectin.
> 
> For example, comparing
>   1. offlining 128MB of memory at once
>   2. offlining 8 chunks of 16MB memory
> "2" can get very good possibility and system-busy time can be much reduced.
> 
> IIUC, ppc's 1st requirement is "resizing" not "hot-removing some memory device",
> "2" is much welcomed. So, some fine-grained interface to section_size is
> appreciated. So, "multiple operations" is much better than single operation.
> 
> As I posted show/hide patch, I'm writing it in configfs. I think it meets IBM's
> requirements.
> _But_, it's IBM's issue not Fujitsu's. So, final decistion will depend on you guys.
> 
> Anyway, I don't like a too fancy interface as "split".
> 

This is a sample configfs for handling memory hotplug.
I wrote this just for my fun and study. code-duplication was not as
big as expected...most of codes are for configfs management.

you can ignore this. but please avoid changing existing interace in fancy way.

==
[root@bluextal kamezawa]# mount -t configfs none /configfs/
[root@bluextal kamezawa]# mkdir /configfs/memory/72
[root@bluextal kamezawa]# cat /configfs/memory/72/phys_index
00000048
[root@bluextal kamezawa]# cat /sys/devices/system/memory/memory72/phys_index
00000048
[root@bluextal kamezawa]# echo offline > /configfs/memory/72/state
[root@bluextal kamezawa]# cat /configfs/memory/72/state
offline
[root@bluextal kamezawa]# cat /sys/devices/system/memory/memory72/state
offline
[root@bluextal kamezawa]# echo online > /configfs/memory/72/state
[root@bluextal kamezawa]# cat /sys/devices/system/memory/memory72/state
online

No sign.

---
 drivers/base/Makefile        |    2 
 drivers/base/memory.c        |   87 +++++++++++++++++--
 drivers/base/memory_config.c |  192 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/memory.h       |   10 ++
 mm/Kconfig                   |    1 
 5 files changed, 280 insertions(+), 12 deletions(-)

Index: mmotm-2.6.35-0701/drivers/base/memory.c
===================================================================
--- mmotm-2.6.35-0701.orig/drivers/base/memory.c
+++ mmotm-2.6.35-0701/drivers/base/memory.c
@@ -23,12 +23,15 @@
 #include <linux/mutex.h>
 #include <linux/stat.h>
 #include <linux/slab.h>
+#include <linux/radix-tree.h>
 
 #include <asm/atomic.h>
 #include <asm/uaccess.h>
 
 #define MEMORY_CLASS_NAME	"memory"
 
+
+
 static struct sysdev_class memory_sysdev_class = {
 	.name = MEMORY_CLASS_NAME,
 };
@@ -104,17 +107,57 @@ unregister_memory(struct memory_block *m
 	sysdev_unregister(&memory->sysdev);
 }
 
+/* routine for remember memory's status when configs is not used. */
+
+RADIX_TREE(hidden_mems, GFP_KERNEL);
+DEFINE_MUTEX(hidden_mems_mutex);
+int record_memory_state(unsigned long section_nr, int status)
+{
+	int ret = -ENOMEM;
+	long lstat = status << 8; /* for avoid radix'trees special handling */
+	mutex_lock(&hidden_mems_mutex);
+	radix_tree_delete(&hidden_mems, section_nr);
+	if (radix_tree_preload(GFP_KERNEL))
+		goto out;
+	ret = radix_tree_insert(&hidden_mems, section_nr, (void*)lstat);
+	radix_tree_preload_end();
+out:
+	mutex_unlock(&hidden_mems_mutex);
+	return ret;
+}
+
+int lookup_memory_state(unsigned long section_nr)
+{
+	void *ptr;
+	/* we already have big mutex */
+	ptr= radix_tree_lookup(&hidden_mems, section_nr);
+	/* treate not-recorded mems'state as ONLINE...? */
+	return ((long)ptr) >> 8;
+}
+
+void forget_memory_state(unsigned long section_nr)
+{
+	radix_tree_delete(&hidden_mems, section_nr);
+}
+
+
 /*
  * use this as the physical section index that this memsection
  * uses.
  */
 
+ssize_t show_memoryblock_phys_index(struct memory_block *mem,
+	char *buf)
+{
+	return sprintf(buf, "%08lx\n", mem->phys_index);
+}
+
 static ssize_t show_mem_phys_index(struct sys_device *dev,
 			struct sysdev_attribute *attr, char *buf)
 {
 	struct memory_block *mem =
 		container_of(dev, struct memory_block, sysdev);
-	return sprintf(buf, "%08lx\n", mem->phys_index);
+	return show_memoryblock_phys_index(mem, buf);
 }
 
 /*
@@ -136,11 +179,8 @@ static ssize_t show_mem_removable(struct
 /*
  * online, offline, going offline, etc.
  */
-static ssize_t show_mem_state(struct sys_device *dev,
-			struct sysdev_attribute *attr, char *buf)
+ssize_t show_memoryblock_state(struct memory_block *mem, char *buf)
 {
-	struct memory_block *mem =
-		container_of(dev, struct memory_block, sysdev);
 	ssize_t len = 0;
 
 	/*
@@ -167,6 +207,15 @@ static ssize_t show_mem_state(struct sys
 	return len;
 }
 
+ssize_t show_mem_state(struct sys_device *dev,
+		struct sysdev_attribute *attr, char *buf)
+{
+	struct memory_block *mem =
+		container_of(dev, struct memory_block, sysdev);
+	mem->state = lookup_memory_state(mem->phys_index);
+	return show_memoryblock_state(mem, buf);
+}
+
 int memory_notify(unsigned long val, void *v)
 {
 	return blocking_notifier_call_chain(&memory_chain, val, v);
@@ -218,11 +267,14 @@ memory_block_action(struct memory_block 
 			break;
 		case MEM_OFFLINE:
 			mem->state = MEM_GOING_OFFLINE;
+			record_memory_state(mem->phys_index, mem->state);
 			start_paddr = page_to_pfn(first_page) << PAGE_SHIFT;
 			ret = remove_memory(start_paddr,
 					    PAGES_PER_SECTION << PAGE_SHIFT);
 			if (ret) {
 				mem->state = old_state;
+				record_memory_state(mem->phys_index,
+					mem->state);
 				break;
 			}
 			break;
@@ -241,6 +293,8 @@ static int memory_block_change_state(str
 	int ret = 0;
 	mutex_lock(&mem->state_mutex);
 
+	mem->state = lookup_memory_state(mem->phys_index);
+
 	if (mem->state != from_state_req) {
 		ret = -EINVAL;
 		goto out;
@@ -249,21 +303,18 @@ static int memory_block_change_state(str
 	ret = memory_block_action(mem, to_state);
 	if (!ret)
 		mem->state = to_state;
-
+	record_memory_state(mem->phys_index, mem->state);
 out:
 	mutex_unlock(&mem->state_mutex);
 	return ret;
 }
 
-static ssize_t
-store_mem_state(struct sys_device *dev,
-		struct sysdev_attribute *attr, const char *buf, size_t count)
+ssize_t store_memoryblock_state(struct memory_block *mem,
+				const char *buf, size_t count)
 {
-	struct memory_block *mem;
 	unsigned int phys_section_nr;
 	int ret = -EINVAL;
 
-	mem = container_of(dev, struct memory_block, sysdev);
 	phys_section_nr = mem->phys_index;
 
 	if (!present_section_nr(phys_section_nr))
@@ -279,6 +330,16 @@ out:
 	return count;
 }
 
+static ssize_t
+store_mem_state(struct sys_device *dev,
+		struct sysdev_attribute *attr, const char *buf, size_t count)
+{
+	struct memory_block *mem;
+
+	mem = container_of(dev, struct memory_block, sysdev);
+	return store_memoryblock_state(mem, buf, count);
+}
+
 /*
  * phys_device is a bad name for this.  What I really want
  * is a way to differentiate between memory ranges that
@@ -451,6 +512,8 @@ static int add_memory_block(int nid, str
 	start_pfn = section_nr_to_pfn(mem->phys_index);
 	mem->phys_device = arch_get_memory_phys_device(start_pfn);
 
+	record_memory_state(mem->phys_index, state);
+
 	ret = register_memory(mem, section);
 	if (!ret)
 		ret = mem_create_simple_file(mem, phys_index);
@@ -505,6 +568,7 @@ int remove_memory_block(unsigned long no
 	struct memory_block *mem;
 
 	mem = find_memory_block(section);
+	forget_memory_state(mem->phys_index);
 	unregister_mem_sect_under_nodes(mem);
 	mem_remove_simple_file(mem, phys_index);
 	mem_remove_simple_file(mem, state);
@@ -573,3 +637,4 @@ out:
 		printk(KERN_ERR "%s() failed: %d\n", __func__, ret);
 	return ret;
 }
+
Index: mmotm-2.6.35-0701/drivers/base/memory_config.c
===================================================================
--- /dev/null
+++ mmotm-2.6.35-0701/drivers/base/memory_config.c
@@ -0,0 +1,192 @@
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/mm.h>
+#include <linux/memory.h>
+#include <linux/slab.h>
+#include <linux/radix-tree.h>
+#include <linux/configfs.h>
+
+
+
+struct memory_hp_block {
+	struct config_group group;
+	struct memory_block mb;
+};
+struct memory_hp_attribute {
+	struct configfs_attribute attr;
+	ssize_t (*show)(struct memory_hp_block *, char *);
+	ssize_t (*store)(struct memory_hp_block *, const char *);
+};
+
+static struct memory_hp_block *to_mhp_block(struct config_item *item)
+{
+	if (!item)
+		return NULL;
+	return container_of(to_config_group(item),
+		struct memory_hp_block, group);
+}
+
+static ssize_t
+memory_hp_phys_index_read(struct memory_hp_block *mhb, char *page)
+{
+        return show_memoryblock_phys_index(&mhb->mb, page);
+}
+
+static struct memory_hp_attribute memory_hp_phys_index = {
+	.attr = { .ca_owner = THIS_MODULE,
+		  .ca_name = "phys_index",
+		  .ca_mode = S_IRUGO },
+	.show = memory_hp_phys_index_read,
+};
+
+static ssize_t
+memory_hp_state_read(struct memory_hp_block *mhb, char *page)
+{
+	/* synchronize */
+	printk("lookup section %ld\n", mhb->mb.phys_index);
+	mhb->mb.state = lookup_memory_state(mhb->mb.phys_index);
+	return show_memoryblock_state(&mhb->mb, page);
+}
+
+static ssize_t
+memory_hp_state_store(struct memory_hp_block *mhb, const char *page)
+{
+	int len = strnlen(page, 8);
+	printk("length %d str %s\n", len, page);
+	if (len > 8) /* online/offline */
+		return -EINVAL;
+	/* synchronize */
+	mhb->mb.state = lookup_memory_state(mhb->mb.phys_index);
+	return store_memoryblock_state(&mhb->mb, page, len);
+}
+
+static struct memory_hp_attribute memory_hp_state = {
+	.attr = { .ca_owner = THIS_MODULE,
+		  .ca_name = "state",
+		  .ca_mode = S_IRUGO|S_IWUSR },
+	.show = memory_hp_state_read,
+	.store = memory_hp_state_store,
+};
+
+static struct configfs_attribute *memory_hp_attrs[] = {
+	&memory_hp_phys_index.attr,
+	&memory_hp_state.attr,
+	NULL,
+};
+
+static ssize_t memory_hp_attr_show(struct config_item *item,
+		struct configfs_attribute *attr,
+		char *page)
+{
+	struct memory_hp_block *mhb = to_mhp_block(item);
+	struct memory_hp_attribute *memhp_attr =
+		container_of(attr, struct memory_hp_attribute, attr);
+	ssize_t ret = 0;
+
+	if (memhp_attr->show)
+		ret = memhp_attr->show(mhb, page);
+	return ret;
+}
+
+static ssize_t memory_hp_attr_store(struct config_item *item,
+		struct configfs_attribute *attr,
+		const char *page, size_t count)
+{
+	struct memory_hp_block *mhb = to_mhp_block(item);
+	struct memory_hp_attribute *memhp_attr =
+		container_of(attr, struct memory_hp_attribute, attr);
+	ssize_t ret = 0;
+
+	if (memhp_attr->store)
+		ret = memhp_attr->store(mhb, page);
+	else
+		ret = -EINVAL;
+	return ret;
+}
+
+static struct configfs_item_operations memory_hp_item_ops = {
+	.show_attribute = memory_hp_attr_show,
+	.store_attribute = memory_hp_attr_store,
+};
+
+static struct  config_item_type memory_hp_type = {
+	.ct_item_ops    = &memory_hp_item_ops,
+	.ct_attrs       = memory_hp_attrs,
+	.ct_owner       = THIS_MODULE,
+};
+
+static struct config_group *
+memory_hp_make_group(struct config_group *group, const char *name)
+{
+	struct memory_hp_block *mhb;
+	unsigned long long section_id;
+
+
+	if (strict_strtoull(name, 10, &section_id))
+		return ERR_PTR(-EINVAL);
+
+	if (!valid_section_nr(section_id))
+		return ERR_PTR(-EINVAL);
+
+	mhb = kzalloc(sizeof(*mhb), GFP_KERNEL);
+	if (!mhb)
+		return NULL;
+
+	config_group_init_type_name(&mhb->group, name, &memory_hp_type);
+
+	mhb->mb.phys_index = section_id;
+	mutex_init(&mhb->mb.state_mutex);
+	mhb->mb.state = lookup_memory_state(section_id);
+
+	return &mhb->group;
+}
+
+static void memory_hp_drop_item(struct config_group *group,
+		struct config_item *item)
+{
+	struct memory_hp_block *mhb;
+
+	mhb = container_of(group, struct memory_hp_block, group);
+	config_item_put(item);
+}
+
+static struct configfs_group_operations memory_hp_group_ops = {
+        .make_group     = memory_hp_make_group,
+	.drop_item	= memory_hp_drop_item,
+};
+
+static struct config_item_type memory_hp_subsys_type = {
+	.ct_group_ops = &memory_hp_group_ops,
+	.ct_owner = THIS_MODULE,
+};
+
+static struct configfs_subsystem memory_hp_subsys = {
+	.su_group = {
+		.cg_item = {
+			.ci_namebuf = "memory",
+			.ci_type = &memory_hp_subsys_type,
+		},
+	},
+};
+
+static int __init memory_config_init(void)
+{
+	int ret;
+
+	config_group_init(&memory_hp_subsys.su_group);
+	mutex_init(&memory_hp_subsys.su_mutex);
+	ret =  configfs_register_subsystem(&memory_hp_subsys);
+	if (ret) {
+		printk(KERN_ERR "Error %d while registering memory configfs\n", ret);
+		return ret;
+	}
+	return 0;
+}
+
+#if 0
+static void __exit memory_config_exit(void)
+{
+	configfs_unregister_subsystem(&memory_hp_subsys);
+}
+#endif
+late_initcall(memory_config_init);
Index: mmotm-2.6.35-0701/drivers/base/Makefile
===================================================================
--- mmotm-2.6.35-0701.orig/drivers/base/Makefile
+++ mmotm-2.6.35-0701/drivers/base/Makefile
@@ -11,7 +11,7 @@ obj-$(CONFIG_HAVE_GENERIC_DMA_COHERENT) 
 obj-$(CONFIG_ISA)	+= isa.o
 obj-$(CONFIG_FW_LOADER)	+= firmware_class.o
 obj-$(CONFIG_NUMA)	+= node.o
-obj-$(CONFIG_MEMORY_HOTPLUG_SPARSE) += memory.o
+obj-$(CONFIG_MEMORY_HOTPLUG_SPARSE) += memory.o memory_config.o
 obj-$(CONFIG_SMP)	+= topology.o
 obj-$(CONFIG_IOMMU_API) += iommu.o
 ifeq ($(CONFIG_SYSFS),y)
Index: mmotm-2.6.35-0701/mm/Kconfig
===================================================================
--- mmotm-2.6.35-0701.orig/mm/Kconfig
+++ mmotm-2.6.35-0701/mm/Kconfig
@@ -138,6 +138,7 @@ config MEMORY_HOTPLUG
 config MEMORY_HOTPLUG_SPARSE
 	def_bool y
 	depends on SPARSEMEM && MEMORY_HOTPLUG
+	select CONFIGFS_FS
 
 config MEMORY_HOTREMOVE
 	bool "Allow for memory hot remove"
Index: mmotm-2.6.35-0701/include/linux/memory.h
===================================================================
--- mmotm-2.6.35-0701.orig/include/linux/memory.h
+++ mmotm-2.6.35-0701/include/linux/memory.h
@@ -68,6 +68,16 @@ struct memory_isolate_notify {
 struct notifier_block;
 struct mem_section;
 
+
+ssize_t show_memoryblock_phys_index(struct memory_block *mb, char *buf);
+ssize_t show_memoryblock_state(struct memory_block *mb, char *buf);
+ssize_t store_memoryblock_state(struct memory_block *mb,
+			const char *buf, size_t count);
+
+int record_memory_state(unsigned long section, int state);
+int lookup_memory_state(unsigned long section);
+void forget_memory_state(unsigned long section);
+
 /*
  * Priorities for the hotplug memory callback routines (stored in decreasing
  * order in the callback chain)






Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab0GAFUW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 01:20:22 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50025 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381Ab0GAFUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 01:20:21 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 1 Jul 2010 14:15:42 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Greg KH <gregkh@suse.de>, Dave Hansen <dave@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nathan Fontenot <nfont@austin.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] memory hotplug disable boot option
Message-Id: <20100701141542.2ebd5845.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100701093130.c5e2b564.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100628154455.GA13918@suse.de>
	<1277769867.8354.531.camel@nimitz>
	<20100629115232.38BC.A69D9226@jp.fujitsu.com>
	<1277827384.8354.3413.camel@nimitz>
	<20100629180415.GB1240@suse.de>
	<20100630093251.a30ed1e0.kamezawa.hiroyu@jp.fujitsu.com>
	<20100630154755.GB12158@suse.de>
	<20100701093130.c5e2b564.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Jul 2010 09:31:30 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> I think this change is not very difficult technically but can this kind of
> interface be allowed ?
> 
Here is a patch.

But I'm not a specialist of memory hotplug in these days. So, please
modify this as required even when you like this.
This patch is onto mmotm but will not hunk with mainline, I hope.
If nonsense, sorry for noise ;)

-Kame
==

Memory hotplug has interfaces for offlining memory per section.
With large memory/small section machine, we tend to have too many
sysfs directory as
  /sys/devices/system/memory/memoryXXX/ (XXX is section name)
But this interface is only necessary when we do hotplug.

This patch adds 2 new interfaces as
  /sys/devieces/system/memory/hide
  /sys/devieces/system/memory/show

'hide' will remove sysfs directroy of given number's section.
'show' will create sysfs directroy of given number's section.

  # echo 120 > /sys/devices/system/memory/hide
    ....memory120 will be removed.

This patch also adds hidememorysysfs boot option to hide
all sysfs for memory section at boot time.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 Documentation/kernel-parameters.txt |    2 
 Documentation/memory-hotplug.txt    |   25 +++++
 drivers/base/memory.c               |  165 +++++++++++++++++++++++++++++++++---
 drivers/base/node.c                 |    2 
 4 files changed, 184 insertions(+), 10 deletions(-)

Index: mmotm-2.6.35-0611/drivers/base/memory.c
===================================================================
--- mmotm-2.6.35-0611.orig/drivers/base/memory.c
+++ mmotm-2.6.35-0611/drivers/base/memory.c
@@ -23,10 +23,12 @@
 #include <linux/mutex.h>
 #include <linux/stat.h>
 #include <linux/slab.h>
+#include <linux/radix-tree.h>
 
 #include <asm/atomic.h>
 #include <asm/uaccess.h>
 
+DEFINE_MUTEX(mem_sysfs_lock);
 #define MEMORY_CLASS_NAME	"memory"
 
 static struct sysdev_class memory_sysdev_class = {
@@ -324,6 +326,8 @@ static int block_size_init(void)
 				&attr_block_size_bytes.attr);
 }
 
+
+
 /*
  * Some architectures will have custom drivers to do this, and
  * will not need to do it from userspace.  The fake hot-add code
@@ -363,6 +367,7 @@ static inline int memory_probe_init(void
 }
 #endif
 
+
 #ifdef CONFIG_MEMORY_FAILURE
 /*
  * Support for offlining pages of memory
@@ -505,13 +510,14 @@ int remove_memory_block(unsigned long no
 	struct memory_block *mem;
 
 	mem = find_memory_block(section);
+	if (!mem) /* already hidden ? */
+		return 0;
 	unregister_mem_sect_under_nodes(mem);
 	mem_remove_simple_file(mem, phys_index);
 	mem_remove_simple_file(mem, state);
 	mem_remove_simple_file(mem, phys_device);
 	mem_remove_simple_file(mem, removable);
 	unregister_memory(mem, section);
-
 	return 0;
 }
 
@@ -521,20 +527,142 @@ int remove_memory_block(unsigned long no
  */
 int register_new_memory(int nid, struct mem_section *section)
 {
-	return add_memory_block(nid, section, MEM_OFFLINE, HOTPLUG);
+	int ret;
+
+	mutex_lock(&mem_sysfs_lock);
+	ret = add_memory_block(nid, section, MEM_OFFLINE, HOTPLUG);
+	mutex_unlock(&mem_sysfs_lock);
+	return ret;
 }
 
 int unregister_memory_section(struct mem_section *section)
 {
+	int ret;
+
 	if (!present_section(section))
 		return -EINVAL;
+	mutex_lock(&mem_sysfs_lock);
+	ret = remove_memory_block(0, section, 0);
+	mutex_unlock(&mem_sysfs_lock);
+	return ret;
+}
+
+/* Remember memory online/offline status for _hidden_ memory */
+
+RADIX_TREE(hidden_mems, GFP_KERNEL);
+static int record_mem_status(unsigned long section_nr, int status)
+{
+	int ret;
+	long lstat = status+1;
+	if (radix_tree_preload(GFP_KERNEL))
+		return -ENOMEM;
+	ret = radix_tree_insert(&hidden_mems, section_nr, (void*)lstat);
+	radix_tree_preload_end();
+	return ret;
+}
+
+static int lookup_mem_status(unsigned long section_nr)
+{
+	void *ptr;
+	/* we already have big mutex */
+	ptr= radix_tree_lookup(&hidden_mems, section_nr);
+	/* treate not-recorded mems'state as ONLINE */
+	if (!ptr)
+		return MEM_ONLINE;
+	return (long)ptr - 1;
+}
+
+static void forget_mem_status(unsigned long section_nr)
+{
+	radix_tree_delete(&hidden_mems, section_nr);
+}
+
+static ssize_t
+memory_show_store(struct class *class, struct class_attribute *attr,
+		   const char *buf, size_t count)
+{
+	struct mem_section *section;
+	unsigned long section_nr;
+	int nid, status;
+	ssize_t ret;
+
+	section_nr = simple_strtoull(buf, NULL, 0);
+	if (!present_section_nr(section_nr))
+		return -EINVAL;
+	section = __nr_to_section(section_nr);
+	VM_BUG_ON(!section);
+
+	mutex_lock(&mem_sysfs_lock);
+
+	if (find_memory_block(section)) {
+		ret = -EEXIST;
+		goto out;
+	}
+
+	nid = pfn_to_nid(section_nr_to_pfn(section_nr));
+
+	status = lookup_mem_status(section_nr);
+	ret = add_memory_block(nid, section, status, HOTPLUG);
+	if (ret)
+		goto out;
+	forget_mem_status(section_nr);
+	ret = count;
+out:
+	mutex_unlock(&mem_sysfs_lock);
+	return ret;
+}
 
-	return remove_memory_block(0, section, 0);
+static CLASS_ATTR(show, S_IWUSR, NULL, memory_show_store);
+static inline int memory_show_init(void)
+{
+	return sysfs_create_file(&memory_sysdev_class.kset.kobj,
+				&class_attr_show.attr);
 }
 
+static ssize_t
+memory_hide_store(struct class *class, struct class_attribute *attr,
+		   const char *buf, size_t count)
+{
+	struct mem_section *section;
+	struct memory_block *mem;
+	unsigned long section_nr;
+	ssize_t ret = -EINVAL;
+
+	section_nr = simple_strtoull(buf, NULL, 0);
+	if (!present_section_nr(section_nr))
+		return ret;
+	section = __nr_to_section(section_nr);
+	VM_BUG_ON(!section);
+
+	mutex_lock(&mem_sysfs_lock);
+	mem = find_memory_block(section);
+	if (!mem)
+		goto out;
+	record_mem_status(section_nr, mem->state);
+	unregister_mem_sect_under_nodes(mem);
+	mem_remove_simple_file(mem, phys_index);
+	mem_remove_simple_file(mem, state);
+	mem_remove_simple_file(mem, phys_device);
+	mem_remove_simple_file(mem, removable);
+	unregister_memory(mem, section);
+	mutex_unlock(&mem_sysfs_lock);
+	ret = count;
+out:
+	return ret;
+}
+
+static CLASS_ATTR(hide, S_IWUSR, NULL, memory_hide_store);
+static inline int memory_hide_init(void)
+{
+	return sysfs_create_file(&memory_sysdev_class.kset.kobj,
+				&class_attr_hide.attr);
+}
+
+
 /*
  * Initialize the sysfs support for memory devices...
  */
+static int hide_memory_sysfs __initdata;
 int __init memory_dev_init(void)
 {
 	unsigned int i;
@@ -550,13 +678,16 @@ int __init memory_dev_init(void)
 	 * Create entries for memory sections that were found
 	 * during boot and have been initialized
 	 */
-	for (i = 0; i < NR_MEM_SECTIONS; i++) {
-		if (!present_section_nr(i))
-			continue;
-		err = add_memory_block(0, __nr_to_section(i), MEM_ONLINE,
-				       BOOT);
-		if (!ret)
-			ret = err;
+	if (!hide_memory_sysfs){
+		for (i = 0; i < NR_MEM_SECTIONS; i++) {
+			if (!present_section_nr(i))
+				continue;
+			err = add_memory_block(0, __nr_to_section(i),
+					MEM_ONLINE,
+				        BOOT);
+			if (!ret)
+				ret = err;
+		}
 	}
 
 	err = memory_probe_init();
@@ -568,8 +699,22 @@ int __init memory_dev_init(void)
 	err = block_size_init();
 	if (!ret)
 		ret = err;
+	err = memory_show_init();
+	if (!ret)
+		ret = err;
+	err = memory_hide_init();
+	if (!ret)
+		ret = err;
 out:
 	if (ret)
 		printk(KERN_ERR "%s() failed: %d\n", __func__, ret);
 	return ret;
 }
+
+static int __init  hidememorysysfs(char *s)
+{
+	hide_memory_sysfs = 1;
+	return 1;
+}
+__setup("hidememorysysfs", hidememorysysfs);
+
Index: mmotm-2.6.35-0611/drivers/base/node.c
===================================================================
--- mmotm-2.6.35-0611.orig/drivers/base/node.c
+++ mmotm-2.6.35-0611/drivers/base/node.c
@@ -421,6 +421,8 @@ static int link_mem_sections(int nid)
 			continue;
 		mem_sect = __nr_to_section(section_nr);
 		mem_blk = find_memory_block(mem_sect);
+		if (!mem_blk) /* hidden ? */
+			continue;
 		ret = register_mem_sect_under_node(mem_blk, nid);
 		if (!err)
 			err = ret;
Index: mmotm-2.6.35-0611/Documentation/memory-hotplug.txt
===================================================================
--- mmotm-2.6.35-0611.orig/Documentation/memory-hotplug.txt
+++ mmotm-2.6.35-0611/Documentation/memory-hotplug.txt
@@ -15,6 +15,7 @@ be changed often.
   1.3. Unit of Memory online/offline operation
 2. Kernel Configuration
 3. sysfs files for memory hotplug
+  3.1 hide and show sysfs
 4. Physical memory hot-add phase
   4.1 Hardware(Firmware) Support
   4.2 Notify memory hot-add event by hand
@@ -169,6 +170,30 @@ For example:
 A backlink will also be created:
 /sys/devices/system/memory/memory9/node0 -> ../../node/node0
 
+3.1 Hide and Show for sysfs.
+
+On some big memory system, memory syfs may contain too much sysfs
+directory and consume kernel resource too much. To handle that,
+memory sysfs has hide and show interface.
+
+hide : remove memoryXXX directory on demand.
+       A user can remove sysfs entry by writing memory section number.
+
+echo 120 > /sys/devices/system/memory/hide
+...then, memory120 disappears.
+
+show : create memory XXX directroy on demand.
+       A user can add sysfs entry by writing memory section number.
+       If memory doesn't exit, this fails.
+
+echo 120 > /sys/dev/ices/system/memory/show
+...then, memory120 directory is available.
+
+And we have boot option as "hidememorysysfs". This makes all
+memoryXXX sysfs at boot to be hidden. All hot-added sections
+will be visible automatically. Users can make memoryXXX sysfs
+entries by 'show' interface.
+
 --------------------------------
 4. Physical memory hot-add phase
 --------------------------------
Index: mmotm-2.6.35-0611/Documentation/kernel-parameters.txt
===================================================================
--- mmotm-2.6.35-0611.orig/Documentation/kernel-parameters.txt
+++ mmotm-2.6.35-0611/Documentation/kernel-parameters.txt
@@ -853,6 +853,8 @@ and is between 256 and 4096 characters. 
 			corresponding firmware-first mode error processing
 			logic will be disabled.
 
+	hidememorysyfs  [KNL, BOOT] hides memoryXXX directory in sysfs at BOOT.
+
 	highmem=nn[KMG]	[KNL,BOOT] forces the highmem zone to have an exact
 			size of <nn>. This works even on boxes that have no
 			highmem otherwise. This also works to reduce highmem


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936212Ab1KJD6d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:58:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45049 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936110Ab1KJDrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:47:39 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:32:06 2011
Message-Id: <20111109213206.141931102@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:34:42 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [235/264] powerpc: Fix oops when echoing bad values to /sys/devices/system/memory/probe
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Blanchard <anton@samba.org>

commit a11940978bd598e65996b4f807cf4904793f7025 upstream.

If we echo an address the hypervisor doesn't like to
/sys/devices/system/memory/probe we oops the box:

# echo 0x10000000000 > /sys/devices/system/memory/probe

kernel BUG at arch/powerpc/mm/hash_utils_64.c:541!

The backtrace is:

create_section_mapping
arch_add_memory
add_memory
memory_probe_store
sysdev_class_store
sysfs_write_file
vfs_write
SyS_write

In create_section_mapping we BUG if htab_bolt_mapping returned
an error. A better approach is to return an error which will
propagate back to userspace.

Rerunning the test with this patch applied:

# echo 0x10000000000 > /sys/devices/system/memory/probe
-bash: echo: write error: Invalid argument

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/include/asm/sparsemem.h |    2 +-
 arch/powerpc/mm/hash_utils_64.c      |    6 +++---
 arch/powerpc/mm/mem.c                |    3 ++-
 3 files changed, 6 insertions(+), 5 deletions(-)

--- a/arch/powerpc/include/asm/sparsemem.h
+++ b/arch/powerpc/include/asm/sparsemem.h
@@ -16,7 +16,7 @@
 #endif /* CONFIG_SPARSEMEM */
 
 #ifdef CONFIG_MEMORY_HOTPLUG
-extern void create_section_mapping(unsigned long start, unsigned long end);
+extern int create_section_mapping(unsigned long start, unsigned long end);
 extern int remove_section_mapping(unsigned long start, unsigned long end);
 #ifdef CONFIG_NUMA
 extern int hot_add_scn_to_nid(unsigned long scn_addr);
--- a/arch/powerpc/mm/hash_utils_64.c
+++ b/arch/powerpc/mm/hash_utils_64.c
@@ -534,11 +534,11 @@ static unsigned long __init htab_get_tab
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG
-void create_section_mapping(unsigned long start, unsigned long end)
+int create_section_mapping(unsigned long start, unsigned long end)
 {
-	BUG_ON(htab_bolt_mapping(start, end, __pa(start),
+	return htab_bolt_mapping(start, end, __pa(start),
 				 pgprot_val(PAGE_KERNEL), mmu_linear_psize,
-				 mmu_kernel_ssize));
+				 mmu_kernel_ssize);
 }
 
 int remove_section_mapping(unsigned long start, unsigned long end)
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -123,7 +123,8 @@ int arch_add_memory(int nid, u64 start,
 	pgdata = NODE_DATA(nid);
 
 	start = (unsigned long)__va(start);
-	create_section_mapping(start, start + size);
+	if (create_section_mapping(start, start + size))
+		return -EINVAL;
 
 	/* this should work for most non-highmem platforms */
 	zone = pgdata->node_zones;



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301Ab2HNPh0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 11:37:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63225 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755750Ab2HNPhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 11:37:21 -0400
Date: Tue, 14 Aug 2012 12:25:42 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 00/12] KVM: introduce readonly memslot
Message-ID: <20120814152542.GB14582@amt.cnet>
References: <5020E423.9080004@linux.vnet.ibm.com>
 <20120810181422.GA14892@amt.cnet>
 <5025D334.9070503@linux.vnet.ibm.com>
 <20120813173900.GA25268@amt.cnet>
 <5029BEBF.4030709@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="OgqxwSJOaUobr8KG"
Content-Disposition: inline
In-Reply-To: <5029BEBF.4030709@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 14, 2012 at 10:58:07AM +0800, Xiao Guangrong wrote:
> On 08/14/2012 01:39 AM, Marcelo Tosatti wrote:
> > On Sat, Aug 11, 2012 at 11:36:20AM +0800, Xiao Guangrong wrote:
> >> On 08/11/2012 02:14 AM, Marcelo Tosatti wrote:
> >>> On Tue, Aug 07, 2012 at 05:47:15PM +0800, Xiao Guangrong wrote:
> >>>> Changelog:
> >>>> - introduce KVM_PFN_ERR_RO_FAULT instead of dummy page
> >>>> - introduce KVM_HVA_ERR_BAD and optimize error hva indicators
> >>>>
> >>>> The test case can be found at:
> >>>> http://lkml.indiana.edu/hypermail/linux/kernel/1207.2/00819/migrate-perf.tar.bz2
> >>>>
> >>>> In current code, if we map a readonly memory space from host to guest
> >>>> and the page is not currently mapped in the host, we will get a fault-pfn
> >>>> and async is not allowed, then the vm will crash.
> >>>>
> >>>> As Avi's suggestion, We introduce readonly memory region to map ROM/ROMD
> >>>> to the guest, read access is happy for readonly memslot, write access on
> >>>> readonly memslot will cause KVM_EXIT_MMIO exit.
> >>>
> >>> Memory slots whose QEMU mapping is write protected is supported
> >>> today, as long as there are no write faults.
> >>>
> >>> What prevents the use of mmap(!MAP_WRITE) to handle read-only memslots
> >>> again?
> >>>
> >>
> >> It is happy to map !write host memory space to the readonly memslot,
> >> and they can coexist as well.
> >>
> >> readonly memslot checks the write-permission by seeing slot->flags and
> >> !write memory checks the write-permission in hva_to_pfn() function
> >> which checks vma->flags. It is no conflict.
> > 
> > Yes, there is no conflict. The point is, if you can use the
> > mmap(PROT_READ) interface (supporting read faults on read-only slots)
> > for this behavior, what is the advantage of a new memslot flag?
> > 
> 
> You can get the discussion at:
> https://lkml.org/lkml/2012/5/22/228
> 
> > I'm not saying mmap(PROT_READ) is the best interface, i am just asking
> > why it is not.
> 
> My fault. :(
> 
> > 
> >>> The initial objective was to fix a vm crash, can you explain that
> >>> initial problem?
> >>>
> >>
> >> The issue was trigged by this code:
> >>
> >>                 } else {
> >>                         if (async && (vma->vm_flags & VM_WRITE))
> >>                                 *async = true;
> >>                         pfn = KVM_PFN_ERR_FAULT;
> >>                 }
> >>
> >> If the host memory region is readonly (!vma->vm_flags & VM_WRITE) and
> >> its physical page is swapped out (or the file data does not be read in),
> >> get_user_page_nowait will fail, above code reject to set async,
> >> then we will get a fault pfn and async=false.
> >>
> >> I guess this issue also exists in "QEMU write protected mapping" as
> >> you mentioned above.
> > 
> > Yes, it does. As far as i understand, what that check does from a high
> > level pov is:
> > 
> > - Did get_user_pages_nowait() fail due to a swapped out page (in which 
> > case we should try to swappin the page asynchronously), or due to 
> > another reason (for which case an error should be returned).
> > 
> > Using vma->vm_flags VM_WRITE for that is trying to guess why
> > get_user_pages_nowait() failed, because it (gup_nowait return values) 
> > does not provide sufficient information by itself.
> > 
> 
> That is exactly what i did in the first version. :)
> 
> You can see it and the reason why it switched to the new way (readonly memslot)
> in the above website (the first message in thread).

Userspace can create multiple mappings for the same memory region, for
example via shared memory (shm_open), and have different protections for
the two (or more) regions. I had old patch doing this, its attached.

> > Can't that be fixed separately? 
> > 
> > Another issue which is also present with the mmap(PROT_READ) scheme is
> > interaction with reexecute_instruction. That is, unless i am mistaken,
> > reexecute_instruction can succeed (return true) on a region that is
> > write protected. This breaks the "write faults on read-only slots exit
> > to userspace via EXIT_MMIO" behaviour.
> 
> Sorry, Why? After re-entry to the guest, it can not generate a correct MMIO?

reexecute_instruction validates presence of GPA by looking at registered
memslots. But if the access is a write, and userspace memory map is
read-only, reexecute_instruction should exit via MMIO.

That is, reexecute_instruction must validate GPA using registered
memslots AND additionaly userspace map permission, not only registered
memslot.
 

--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=qemukvm-guest-mapping

Index: qemu-kvm-gpage-cache/cpu-common.h
===================================================================
--- qemu-kvm-gpage-cache.orig/cpu-common.h
+++ qemu-kvm-gpage-cache/cpu-common.h
@@ -33,6 +33,7 @@ ram_addr_t qemu_ram_alloc(ram_addr_t);
 void qemu_ram_free(ram_addr_t addr);
 /* This should only be used for ram local to a device.  */
 void *qemu_get_ram_ptr(ram_addr_t addr);
+void *qemu_get_ram_ptr_guest(ram_addr_t addr);
 /* This should not be used by devices.  */
 int do_qemu_ram_addr_from_host(void *ptr, ram_addr_t *ram_addr);
 ram_addr_t qemu_ram_addr_from_host(void *ptr);
Index: qemu-kvm-gpage-cache/exec.c
===================================================================
--- qemu-kvm-gpage-cache.orig/exec.c
+++ qemu-kvm-gpage-cache/exec.c
@@ -35,6 +35,7 @@
 #include "exec-all.h"
 #include "qemu-common.h"
 #include "cache-utils.h"
+#include "sysemu.h"
 
 #if !defined(TARGET_IA64)
 #include "tcg.h"
@@ -124,6 +125,7 @@ static int in_migration;
 
 typedef struct RAMBlock {
     uint8_t *host;
+    uint8_t *guest;
     ram_addr_t offset;
     ram_addr_t length;
     struct RAMBlock *next;
@@ -2450,7 +2452,8 @@ static long gethugepagesize(const char *
     return fs.f_bsize;
 }
 
-static void *file_ram_alloc(ram_addr_t memory, const char *path)
+static void *file_ram_alloc(ram_addr_t memory, const char *path,
+                            RAMBlock *block)
 {
     char *filename;
     void *area;
@@ -2507,7 +2510,12 @@ static void *file_ram_alloc(ram_addr_t m
      * MAP_PRIVATE is requested.  For mem_prealloc we mmap as MAP_SHARED
      * to sidestep this quirk.
      */
-    flags = mem_prealloc ? MAP_POPULATE|MAP_SHARED : MAP_PRIVATE;
+    if (mem_guest_map)
+        flags = MAP_SHARED;
+    else if (mem_prealloc)
+        flags = MAP_POPULATE|MAP_SHARED;
+    else
+        flags = MAP_PRIVATE;
     area = mmap(0, memory, PROT_READ|PROT_WRITE, flags, fd, 0);
 #else
     area = mmap(0, memory, PROT_READ|PROT_WRITE, MAP_PRIVATE, fd, 0);
@@ -2517,12 +2525,22 @@ static void *file_ram_alloc(ram_addr_t m
 	close(fd);
 	return (NULL);
     }
+    if (mem_guest_map) {
+        block->guest = mmap(0, memory, PROT_READ|PROT_WRITE, flags, fd, 0);
+        if (block->guest == MAP_FAILED) {
+            perror("alloc_mem_area: can't mmap guest map");
+            munmap(area, memory);
+            close(fd);
+            return NULL;
+        }
+    }
     return area;
 }
 
 #else
 
-static void *file_ram_alloc(ram_addr_t memory, const char *path)
+static void *file_ram_alloc(ram_addr_t memory, const char *path,
+                            RAMBlock *block)
 {
     return NULL;
 }
@@ -2538,7 +2556,7 @@ ram_addr_t qemu_ram_alloc(ram_addr_t siz
     size = TARGET_PAGE_ALIGN(size);
     new_block = qemu_malloc(sizeof(*new_block));
 
-    new_block->host = file_ram_alloc(size, mem_path);
+    new_block->host = file_ram_alloc(size, mem_path, new_block);
     if (!new_block->host) {
 #if defined(TARGET_S390X) && defined(CONFIG_KVM)
     /* XXX S390 KVM requires the topmost vma of the RAM to be < 256GB */
@@ -2584,7 +2602,8 @@ void qemu_ram_free(ram_addr_t addr)
    It should not be used for general purpose DMA.
    Use cpu_physical_memory_map/cpu_physical_memory_rw instead.
  */
-void *qemu_get_ram_ptr(ram_addr_t addr)
+
+static void *__qemu_get_ram_ptr(ram_addr_t addr)
 {
     RAMBlock *prev;
     RAMBlock **prevp;
@@ -2610,9 +2629,27 @@ void *qemu_get_ram_ptr(ram_addr_t addr)
         block->next = *prevp;
         *prevp = block;
     }
+    return block;
+}
+
+void *qemu_get_ram_ptr(ram_addr_t addr)
+{
+    RAMBlock *block = __qemu_get_ram_ptr(addr);
+
     return block->host + (addr - block->offset);
 }
 
+void *qemu_get_ram_ptr_guest(ram_addr_t addr)
+{
+    RAMBlock *block;
+
+    if (!mem_guest_map)
+        return qemu_get_ram_ptr(addr);
+
+    block =  __qemu_get_ram_ptr(addr);
+    return block->guest + (addr - block->offset);
+}
+
 int do_qemu_ram_addr_from_host(void *ptr, ram_addr_t *ram_addr)
 {
     RAMBlock *prev;
Index: qemu-kvm-gpage-cache/qemu-kvm.c
===================================================================
--- qemu-kvm-gpage-cache.orig/qemu-kvm.c
+++ qemu-kvm-gpage-cache/qemu-kvm.c
@@ -2327,7 +2327,7 @@ void kvm_set_phys_mem(target_phys_addr_t
 #endif
 
     r = kvm_register_phys_mem(kvm_context, start_addr,
-                              qemu_get_ram_ptr(phys_offset), size, 0);
+                              qemu_get_ram_ptr_guest(phys_offset), size, 0);
     if (r < 0) {
         printf("kvm_cpu_register_physical_memory: failed\n");
         exit(1);
Index: qemu-kvm-gpage-cache/sysemu.h
===================================================================
--- qemu-kvm-gpage-cache.orig/sysemu.h
+++ qemu-kvm-gpage-cache/sysemu.h
@@ -15,6 +15,7 @@
 
 /* vl.c */
 extern const char *bios_name;
+extern int mem_guest_map;
 
 #define QEMU_FILE_TYPE_BIOS   0
 #define QEMU_FILE_TYPE_KEYMAP 1
Index: qemu-kvm-gpage-cache/vl.c
===================================================================
--- qemu-kvm-gpage-cache.orig/vl.c
+++ qemu-kvm-gpage-cache/vl.c
@@ -248,6 +248,7 @@ const char *mem_path = NULL;
 #ifdef MAP_POPULATE
 int mem_prealloc = 1;	/* force preallocation of physical target memory */
 #endif
+int mem_guest_map = 1; /* separate qemu/guest mappings for RAM */
 #ifdef TARGET_ARM
 int old_param = 0;
 #endif

--OgqxwSJOaUobr8KG--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153Ab2LUBgR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 20:36:17 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53596 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824Ab2LUBgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 20:36:07 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Date: Fri, 21 Dec 2012 10:35:19 +0900 (JST)
Message-Id: <20121221.103519.171458326.d.hatayama@jp.fujitsu.com>
To: cpw@sgi.com
Cc: kexec@lists.infradead.org, ptesarik@suse.cz, linux-kernel@vger.kernel.org,
        kumagai-atsushi@mxc.nes.nec.co.jp, vgoyal@redhat.com
Subject: Re: [PATCH] makedumpfile: request the kernel do page scans
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
In-Reply-To: <20121220155147.GA2048@sgi.com>
References: <20121210153614.GA9037@sgi.com>
	<20121220.122214.503837449.d.hatayama@jp.fujitsu.com>
	<20121220155147.GA2048@sgi.com>
X-Mailer: Mew version 6.3 on Emacs 24.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Wickman <cpw@sgi.com>
Subject: Re: [PATCH] makedumpfile: request the kernel do page scans
Date: Thu, 20 Dec 2012 09:51:47 -0600

> On Thu, Dec 20, 2012 at 12:22:14PM +0900, HATAYAMA Daisuke wrote:
>> From: Cliff Wickman <cpw@sgi.com>
>> Subject: Re: [PATCH] makedumpfile: request the kernel do page scans
>> Date: Mon, 10 Dec 2012 09:36:14 -0600
>> > On Mon, Dec 10, 2012 at 09:59:29AM +0900, HATAYAMA Daisuke wrote:
>> >> From: Cliff Wickman <cpw@sgi.com>
>> >> Subject: Re: [PATCH] makedumpfile: request the kernel do page scans
>> >> Date: Mon, 19 Nov 2012 12:07:10 -0600
>> >> 
>> >> > On Fri, Nov 16, 2012 at 03:39:44PM -0500, Vivek Goyal wrote:
>> >> >> On Thu, Nov 15, 2012 at 04:52:40PM -0600, Cliff Wickman wrote:
>> > 
>> > Hi Hatayama,
>> > 
>> > If ioremap/iounmap is the bottleneck then perhaps you could do what
>> > my patch does: it consolidates all the ranges of physical addresses
>> > where the boot kernel's page structures reside (see make_kernel_mmap())
>> > and passes them to the kernel, which then does a handfull of ioremaps's to
>> > cover all of them.  Then /proc/vmcore could look up the already-mapped
>> > virtual address.
>> > (also note a kludge in get_mm_sparsemem() that verifies that each section
>> > of the mem_map spans contiguous ranges of page structures.  I had
>> > trouble with some sections when I made that assumption)
>> > 
>> > I'm attaching 3 patches that might be useful in your testing:
>> > - 121210.proc_vmcore2  my current patch that applies to the released
>> >   makedumpfile 1.5.1
>> > - 121207.vmcore_pagescans.sles applies to a 3.0.13 kernel
>> > - 121207.vmcore_pagescans.rhel applies to a 2.6.32 kernel
>> > 
>> 
>> I used the same patch set on the benchmark.
>> 
>> BTW, I have continuously reservation issue, so I think I cannot use
>> terabyte memory machine at least in this year.
>> 
>> Also, your patch set is doing ioremap per a chunk of memory map,
>> i.e. a number of consequtive pages at the same time. On your terabyte
>> machines, how large they are? We have memory consumption issue on the
>> 2nd kernel so we must decrease amount of memory used. But looking into
>> ioremap code quickly, it looks not using 2MB or 1GB pages to
>> remap. This means more than tera bytes page table is generated. Or
>> have you probably already investigated this?
>> 
>> BTW, my idea to solve this issue are two:
>> 
>> 1) make linear direct mapping for old memory, and acess the old memory
>> via the linear direct mapping, not by ioremap.
>> 
>>   - adding remap code in vmcore, or passing the regions that need to
>>     be remapped using memmap= kernel option to tell the 2nd kenrel to
>>     map them in addition.
> 
> Good point.  It would take over 30G of memory to map 16TB with 4k pages.
> I recently tried to dump such a memory and ran out of kernel memory --
> no wonder!
> 

One question. Now, on terabyte memory machine, your patch set always
goes into out of kernel memory and panic when writing pages, right?
Only scanning mem_map array can complete.

> Do you have a patch for doing a linear direct mapping?  Or can you name
> existing kernel infrastructure to do such mapping?  I'm just looking for
> a jumpstart to enhance the patch.

I have a prototype patch only. See the patch at the end of this mail,
which tries to creates linear direct mapping using
init_memory_mapping() which supports 2MB and 1GB pages. We can see
what kind of pages are used from dmesg:

$ dmesg
...
initial memory mapped: [mem 0x00000000-0x1fffffff]
Base memory trampoline at [ffff880000094000] 94000 size 28672
Using GB pages for direct mapping
init_memory_mapping: [mem 0x00000000-0x7b00cfff]               <-- here
 [mem 0x00000000-0x3fffffff] page 1G
 [mem 0x40000000-0x7affffff] page 2M
 [mem 0x7b000000-0x7b00cfff] page 4k
kernel direct mapping tables up to 0x7b00cfff @ [mem 0x1fffd000-0x1fffffff]
init_memory_mapping: [mem 0x100000000-0x87fffffff]             <-- here
 [mem 0x100000000-0x87fffffff] page 1G
kernel direct mapping tables up to 0x87fffffff @ [mem 0x7b00c000-0x7b00cfff]
RAMDISK: [mem 0x37406000-0x37feffff]
Reserving 256MB of memory at 624MB for crashkernel (System RAM: 32687MB)

The source of memory mapping information is PT_LOAD entries of
/proc/vmcore, which is in vmcore_list defined in vmcore.c. This is
"adding remap code in vmcore" idea above. Still existing
copy_old_memory() is being left to read ELF headers.

Unfortunately, this patch is still really buggy. I saw the dump was
generated correctly on my small 1GB kvm guest machine, but some
scheduler bug occurred on the 32GB native machine which is the same as
I used for profiling your patch set.

The second idea passing memmap= kernel option is just like below.

kexec passes specific memory map information to the 2nd kenrel using
memmap= kernel parameter; maybe, only '#' is being used in
kexec. Different delimitor means different manings. '@' means System
RAM, '#' means ACPI Table and '$' means "don't use this memory".

        memmap=nn[KMG]@ss[KMG]
                        [KNL] Force usage of a specific region of memory
                        Region of memory to be used, from ss to ss+nn.

        memmap=nn[KMG]#ss[KMG]
                        [KNL,ACPI] Mark specific memory as ACPI data.
                        Region of memory to be used, from ss to ss+nn.

        memmap=nn[KMG]$ss[KMG]
                        [KNL,ACPI] Mark specific memory as reserved.
                        Region of memory to be used, from ss to ss+nn.
                        Example: Exclude memory from 0x18690000-0x1869ffff
                                 memmap=64K$0x18690000
                                 or
                                 memmap=0x10000$0x18690000

Like this, why not introducing another memmap to tell the 2nd kenrel
to make linear mapping address on boot. Or maybe it's sufficient for
this issue to use any of the above three kinds of memmap=.

Thanks.
HATAYAMA, Daisuke


>From a840d882a5fbef56e9c335dd74ce9a6fe858cfc1 Mon Sep 17 00:00:00 2001
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Date: Sat, 15 Dec 2012 22:49:31 +0900
Subject: [PATCH] kdump, vmcore: create linear direct mapping for old memory

[Warning: This is very experimental buggy patch!]

On the current implementation of /proc/vmcore, memory on the 2nd
kernel, called old memory in the code around, is read through ioremap
per pages, which is causing big performance impact on terabyte class
machines.

To address the issue, it's not enough to change of ioremap unit size
from a page to larger one since ioremap doesn't use 1GB or 2MB pages
on mapping --- I guess vast majority of ioremap users doesn't need to
map such a large memory. On giga byte memory machine, this leads to
giga byte page table.

Instead, this patch makes linear direct address for the old memory,
which supports 1GB and 2MB pages. There's less risk than ioremap due
to page table memory consumption.

Note:

Currently, I confirmed this patch worked weell only on small 1GB
memory kvm guest machine. On 32GB memory machine, I encountered some
kind of scheduler BUG during the boot of 2nd kernel. Obviously, I
guess my code is doing some wrong things around init_memory_mapping.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
---
 fs/proc/vmcore.c |   68 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 66 insertions(+), 2 deletions(-)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index 0d5071d..739bd04 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -116,6 +116,49 @@ static ssize_t read_from_oldmem(char *buf, size_t count,
 	return read;
 }
 
+/* Reads a page from the oldmem device from given offset. */
+static ssize_t read_from_oldmem_noioremap(char *buf, size_t count,
+					  u64 *ppos, int userbuf)
+{
+	unsigned long pfn, offset;
+	size_t nr_bytes;
+	ssize_t read = 0;
+
+	if (!count)
+		return 0;
+
+	offset = (unsigned long)(*ppos % PAGE_SIZE);
+	pfn = (unsigned long)(*ppos / PAGE_SIZE);
+
+	do {
+		if (count > (PAGE_SIZE - offset))
+			nr_bytes = PAGE_SIZE - offset;
+		else
+			nr_bytes = count;
+
+		/* If pfn is not ram, return zeros for sparse dump files */
+		if (pfn_is_ram(pfn) == 0)
+			memset(buf, 0, nr_bytes);
+		else {
+			void *vaddr = pfn_to_kaddr(pfn);
+
+			if (userbuf) {
+				if (copy_to_user(buf, vaddr + offset, nr_bytes))
+					return -EFAULT;
+			} else
+				memcpy(buf, vaddr + offset, nr_bytes);
+		}
+		*ppos += nr_bytes;
+		count -= nr_bytes;
+		buf += nr_bytes;
+		read += nr_bytes;
+		++pfn;
+		offset = 0;
+	} while (count);
+
+	return read;
+}
+
 /* Maps vmcore file offset to respective physical address in memroy. */
 static u64 map_offset_to_paddr(loff_t offset, struct list_head *vc_list,
 					struct vmcore **m_ptr)
@@ -137,6 +180,22 @@ static u64 map_offset_to_paddr(loff_t offset, struct list_head *vc_list,
 	return 0;
 }
 
+static void init_memory_mapping_oldmem(struct list_head *vc_list)
+{
+	struct vmcore *m;
+
+	list_for_each_entry(m, vc_list, list) {
+		unsigned long last_mapped_pfn;
+
+		last_mapped_pfn = init_memory_mapping(m->paddr,
+						      m->paddr + m->size);
+		if (last_mapped_pfn > max_pfn_mapped)
+			max_pfn_mapped = last_mapped_pfn;
+		printk("vmcore: map %016llx-%016llx\n",
+		       m->paddr, m->paddr + m->size - 1);
+	}
+}
+
 /* Read from the ELF header and then the crash dump. On error, negative value is
  * returned otherwise number of bytes read are returned.
  */
@@ -184,9 +243,11 @@ static ssize_t read_vmcore(struct file *file, char __user *buffer,
 		tsz = nr_bytes;
 
 	while (buflen) {
-		tmp = read_from_oldmem(buffer, tsz, &start, 1);
-		if (tmp < 0)
+		tmp = read_from_oldmem_noioremap(buffer, tsz, &start, 1);
+		if (tmp < 0) {
+			printk("vmcore: failed to read oldmem: %016llx\n", start);
 			return tmp;
+		}
 		buflen -= tsz;
 		*fpos += tsz;
 		buffer += tsz;
@@ -677,6 +738,9 @@ static int __init parse_crash_elf_headers(void)
 					" sane\n");
 		return -EINVAL;
 	}
+
+	init_memory_mapping_oldmem(&vmcore_list);
+
 	return 0;
 }
 
-- 
1.7.7.6



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760259Ab0I0WYd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 18:24:33 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:49347 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab0I0WYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 18:24:32 -0400
Message-ID: <4CA11918.7050708@kernel.org>
Date: Mon, 27 Sep 2010 15:22:16 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: caiqian@redhat.com
CC: Ingo Molnar <mingo@elte.hu>, kexec <kexec@lists.infradead.org>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: kexec load failure introduced by "x86, memblock: Replace e820_/_early
 string with memblock_"
References: <632974489.2046131285586512527.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <632974489.2046131285586512527.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
Content-Type: multipart/mixed;
 boundary="------------010001080501070701010608"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010001080501070701010608
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 09/27/2010 04:21 AM, caiqian@redhat.com wrote:
> 
> ----- "CAI Qian" <caiqian@redhat.com> wrote:
> 
>> ----- "Yinghai Lu" <yinghai@kernel.org> wrote:
>>
>>> Please check this one on top of tip or next.
>> This failed for both trees.
>> [root@localhost linux-next]# patch -Np1 <memblock.patch
>> patching file arch/x86/kernel/setup.c
>> Hunk #1 FAILED at 516.
>> 1 out of 1 hunk FAILED -- saving rejects to file
>> arch/x86/kernel/setup.c.rej
> After manually applied the patch on the top of the latest mmotm tree, now there was no /proc/vmcore exported to the second kernel anymore. It could be the results of other recent commits in mmotm though. It said,
> 
> Warning: Core image elf header is notsane
> Kdump: vmcore not initialized
> 
> Here is the dmesg from the second kernel,
> 
> Initializing cgroup subsys cpuset
> Linux version 2.6.36-rc5-mm1+ (root@localhost.localdomain) (gcc version 4.4.4 20100726 (Red Hat 4.4.4-13) (GCC) ) #6 SMP Mon Sep 27 07:00:15 EDT 2010
> Command line: ro root=/dev/mapper/VolGroup-lv_root rd_LVM_LV=VolGroup/lv_root rd_LVM_LV=VolGroup/lv_swap rd_NO_LUKS rd_NO_MD rd_NO_DM LANG=en_US.UTF-8 SYSFONT=latarcyrheb-sun16 KEYBOARDTYPE=pc KEYTABLE=us rhgb quiet console=tty0 console=ttyS0,115200 crashkernel=128M irqpoll maxcpus=1 reset_devices cgroup_disable=memory  memmap=exactmap memmap=640K@0K memmap=130408K@32768K elfcorehdr=163176K kexec_jump_back_entry=0x000000000232f063
> BIOS-provided physical RAM map:
>  BIOS-e820: 0000000000000100 - 000000000009f400 (usable)
>  BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
>  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
>  BIOS-e820: 0000000000100000 - 00000000dfffb000 (usable)
>  BIOS-e820: 00000000dfffb000 - 00000000e0000000 (reserved)
>  BIOS-e820: 00000000fffbc000 - 0000000100000000 (reserved)
>  BIOS-e820: 0000000100000000 - 0000000ca0000000 (usable)
> last_pfn = 0xca0000 max_arch_pfn = 0x400000000
> NX (Execute Disable) protection: active
> user-defined physical RAM map:
>  user: 0000000000000000 - 00000000000a0000 (usable)
>  user: 0000000002000000 - 0000000009f5a000 (usable)
...

> Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> Warning: Core image elf header is notsane
> Kdump: vmcore not initialized
> 
>>

it should work on tip..., I tested on RHEL 6.0 beta.
with
/etc/init.d/kdump restart

BTW, second kernel is not supposed to take crashkernel=128M again.
/etc/init.d/kdump scripts remove that while using /proc/cmdline.

please refer
http://people.redhat.com/mingo/tip.git/readme.txt
to get tip/master

and apply attached patch
cat crashkernel_limit.patch | patch -p1

Thanks

Yinghai


--------------010001080501070701010608
Content-Type: text/x-patch;
 name="crashkernel_limit.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="crashkernel_limit.patch"

[PATCH -v2] x86, memblock: Fix crashkernel allocation

Cai Qian found crashkernel is broken with x86 memblock changes
1. crashkernel=128M@32M always reported that range is used, even first kernel is small
   no one use that range
2. always get following report when using "kexec -p"
	Could not find a free area of memory of a000 bytes...
	locate_hole failed

The root cause is that generic memblock_find_in_range() will try to get range from top_down.
But crashkernel do need from low and specified range.

Let's limit the target range with rash_base + crash_size to make sure that
We get range from bottom.

-v2: don't limit it with 0xffffffff, in case kexec will use bzImage 64bit entry or vmlinux,
     and try to allocate huge area for crashkernel.

Reported-and-Bisected-by: CAI Qian <caiqian@redhat.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/setup.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -516,19 +516,28 @@ static void __init reserve_crashkernel(v
 
 	/* 0 means: find the address automatically */
 	if (crash_base <= 0) {
+		unsigned long long start = 0;
 		const unsigned long long alignment = 16<<20;	/* 16M */
 
-		crash_base = memblock_find_in_range(alignment, ULONG_MAX, crash_size,
-				 alignment);
-		if (crash_base == MEMBLOCK_ERROR) {
+		crash_base = alignment;
+		while ((crash_base + crash_size) <= total_mem) {
+			start = memblock_find_in_range(crash_base,
+				crash_base + crash_size, crash_size, alignment);
+
+			if (start == crash_base)
+				break;
+
+			crash_base += alignment;
+		}
+		if (start != crash_base) {
 			pr_info("crashkernel reservation failed - No suitable area found.\n");
 			return;
 		}
 	} else {
 		unsigned long long start;
 
-		start = memblock_find_in_range(crash_base, ULONG_MAX, crash_size,
-				 1<<20);
+		start = memblock_find_in_range(crash_base,
+				 crash_base + crash_size, crash_size, 1<<20);
 		if (start != crash_base) {
 			pr_info("crashkernel reservation failed - memory is in use.\n");
 			return;

--------------010001080501070701010608--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922Ab1JCHHz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 03:07:55 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:58475 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873Ab1JCHHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 03:07:47 -0400
Date: Mon, 3 Oct 2011 12:37:35 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, crash-utility@redhat.com,
        kexec@lists.infradead.org
Cc: Vivek Goyal <vgoyal@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, anderson@redhat.com,
        tachibana@mxm.nes.nec.co.jp, oomichi@mxs.nes.nec.co.jp
Subject: [Patch 0/4] Slimdump framework using NT_NOCOREDUMP elf-note
Message-ID: <20111003070735.GJ2223@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,
	Please find a set of patches that introduce a 'slimdump'
framework. Details as described below.

Problem
--------
A system configured with kdump, captures the kernel memory
for all types of crashes even when it doesn't make much sense to do so.
For instance, system crashes triggered due to hardware errors don't need
a complete dump of the memory for investigation.

In the case of crashes triggered by fatal machine check exceptions (MCE)
due to unrecoverable memory errors, it is even dangerous to read the
crashing kernel's memory. When the kexec kernel reads the crashing
kernel's memory, it 'consumes' the data from the faulty memory location,
potentially causing a recursion of faults.

This problem was previously discussed in the kernel community, with a
proposal to leave out kernel memory regions from /proc/vmcore (refer:
mail threads pertaining to
http://article.gmane.org/gmane.linux.kernel/1148266). However there were
suggestions against making this behaviour a kernel policy.

Solution
---------
Since capturing of crashing kernel's memory for hardware error induced
crashes isn't required or is dangerous, we introduce a mechanism to
generate 'slimdump'.

Basically, a new elf-note of type NT_NOCOREDUMP type is added by the
kernel to the vmcore, which is recognised by all tools in the kdump chain
to generate and save a 'slimdump' that contains only elf-headers and the
elf-note section. The elf-note section may be used to add description
about the cause of the error.

The enclosed set of patches make changes to kernel, kexec, makedumpfile
and crash tool to make them recognise the NT_NOCOREDUMP elf-note and
generate a 'slimdump'. Also, fatal MCEs in the kernel is turned into a
consumer of the slimdump mechanism to prevent collection of normal
kdump.

Alternatively, the user has an option (through suitable makedumpfile or
kdump configuration options) to collect the complete vmcore or to
extract the 'dmesg' from /proc/vmcore.

Screen logs
-------------
# mce-inject ~/mce/mce-test/cases/soft-inj/panic_ucr/data/srar_over
[ 4934.748416] [Hardware Error]: CPU 0: Machine Check Exception: 6 Bank
2: f580000000000000
[ 4934.749079] [Hardware Error]: RIP 73:<000000001eadbabe> 
[ 4934.749079] [Hardware Error]: TSC ef029a23417 ADDR 1234 
[ 4934.749079] [Hardware Error]: PROCESSOR 0:663 TIME 1317149322 SOCKET
0 APIC 0
[ 4934.749079] [Hardware Error]: Run the above through 'mcelog --ascii'
[ 4934.749079] [Hardware Error]: Machine check: Overflowed uncorrected
[ 4934.749079] Kernel panic - not syncing: Fatal machine check on
current CPU
[ 4934.749079] Pid: 1379, comm: mce-inject Tainted: G   M
3.1.0-rc4.slimdump+ #34
[ 4934.749079] Call Trace:
[ 4934.749079]  [<ffffffff81084922>] panic+0xbc/0x1cf
[ 4934.749079]  [<ffffffff810858ff>] ? printk+0x6c/0x6e
[ 4934.749079]  [<ffffffff8104c43b>] mce_panic+0x187/0x1a4
[ 4934.749079]  [<ffffffff8104d525>] do_machine_check+0x5ec/0x6c3
[ 4934.749079]  [<ffffffff8104e4e1>] raise_exception+0x5c/0x84
[ 4934.749079]  [<ffffffff8104e5e9>] raise_local+0x5a/0xcc
[ 4934.749079]  [<ffffffff8104e8ee>] mce_write+0x218/0x24e
[ 4934.749079]  [<ffffffff8115abee>] vfs_write+0xb0/0x108
[ 4934.749079]  [<ffffffff8115ad0a>] sys_write+0x4c/0x71
[ 4934.749079]  [<ffffffff815bf12b>] system_call_fastpath+0x16/0x1b
[    0.817861] kvm: no hardware support
..............
................
.................
# ls
vmcore
# ls -lh vmcore
-r-------- 1 root root 1.8G Sep 27 13:20 vmcore
# ~/makedumpfile.slimdump/makedumpfile vmcore vmcore.makedumpfile.review
The kernel version is not supported.
The created dumpfile may be incomplete.
Copying data                       : [100 %] 

The dumpfile is saved to vmcore.makedumpfile.review.

makedumpfile Completed.
# ls -lh vmcore.makedumpfile.review
-rw------- 1 root root 3.9K Sep 28 01:40 vmcore.makedumpfile.review
# eu-readelf -n
vmcore.makedumpfile.review

Note segment of 3592 bytes at offset 0x158:
  Owner          Data size  Type
  CORE                 336  PRSTATUS
    info.si_signo: 0, info.si_code: 0, info.si_errno: 0, cursig: 0
    sigpend: <>
..........
.............
.........
    NUMBER(PG_private)=11
    NUMBER(PG_swapcache)=16
    SYMBOL(phys_base)=ffffffff81a0e010
    SYMBOL(init_level4_pgt)=ffffffff81a06000
    SYMBOL(node_data)=ffffffff81b70b80
    LENGTH(node_data)=512
    CRASHTIME=1317621133

  PANIC_MCE             49  <unknown>: 21
# crash -S ~/linux-2.6.slimdump/System.map ~/linux-2.6.slimdump/vmlinux vmcore.makedumpfile.review

crash 5.1.8
Copyright (C) 2002-2011  Red Hat, Inc.
Copyright (C) 2004, 2005, 2006  IBM Corporation
Copyright (C) 1999-2006  Hewlett-Packard Co
Copyright (C) 2005, 2006  Fujitsu Limited
Copyright (C) 2006, 2007  VA Linux Systems Japan K.K.
Copyright (C) 2005  NEC Corporation
Copyright (C) 1999, 2002, 2007  Silicon Graphics, Inc.
Copyright (C) 1999, 2000, 2001, 2002  Mission Critical Linux, Inc.
This program is free software, covered by the GNU General Public
License,
and you are welcome to change it and/or distribute copies of it under
certain conditions.  Enter "help copying" to see the conditions.
This program has absolutely no warranty.  Enter "help warranty" for
details.
 
crash: overriding /boot/System.map with
/home/prasadkr/linux-2.6.slimdump/System.map
"System crashed due to a hardware memory error. No coredump available."
Nocoredump Reason: PANIC_MCE
crash: Elf64_Phdr pointer: 1c46170  ELF header end: 1c46130

-------
Thanks,
K.Prasad


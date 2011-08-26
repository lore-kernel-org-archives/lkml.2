Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469Ab1HZSAF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 14:00:05 -0400
Received: from mail.linode.com ([67.18.92.99]:58271 "EHLO www.linode.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753251Ab1HZSAB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 14:00:01 -0400
X-Greylist: delayed 1021 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Aug 2011 14:00:00 EDT
From: Peter Sandin <psandin@linode.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: 3.0.0 Xen pv guest - BUG: Unable to handle kernel paging request in swap_count_continued
Date: Fri, 26 Aug 2011 13:42:54 -0400
Message-Id: <9CAEB881-07FE-437C-8A6B-DB7B690CEABE@linode.com>
Cc: xen-devel@lists.xensource.com
To: LKML <linux-kernel@vger.kernel.org>
Mime-Version: 1.0 (Apple Message framework v1084)
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have a number of virtualized Linux instances running under Xen that have been hitting a bug. This issue first cropped up in the 2.6.38 release and we're still seeing cases with the 3.0.0 kernel. On average we're receiving reports of about one instance per day crashing due to this issue. The affected 2.6.39 and 3.0.0 kernels are vanilla kernel.org kernels, the .config file and binary for the affected 3.0.0 kernel can be found at:

http://thesandins.net/xen/3.0.0/

This issue has happened on multiple separate physical machine and different distributions, so it's not a hardware or distribution specific issue. The Apache httpd server seems to be the most likely process to trigger this issue. Someone else opened a bug with Apache about this issue, but that bug was closed as not being an Apache issue, that report can be found at:

https://issues.apache.org/bugzilla/show_bug.cgi?id=51325

We inquired about this issue with the Xen-devel list when we first ran in to it, that thread can be found at:

http://lists.xensource.com/archives/html/xen-devel/2011-04/msg00230.html

If anyone has any ideas on why this is happening and what we need to do to prevent it from happening in the future please let us know. The issue has only manifested in customer instances so we don't have access to other logs from these incidents, however if anyone has suggestions on tests or methods for replicating this issue I'd be glad to give those a try on a test instance. The console output from the error is included below:

BUG: unable to handle kernel paging request at f57a63be
IP: [<c01ab854>] swap_count_continued+0x104/0x180
*pdpt = 0000000029d01027 *pde = 00000000008d4067 *pte = 0000000000000000 
Oops: 0000 [#1] SMP 
Modules linked in:

Pid: 2206, comm: apache2 Not tainted 3.0.0-linode35 #1  
EIP: 0061:[<c01ab854>] EFLAGS: 00010246 CPU: 1
EIP is at swap_count_continued+0x104/0x180
EAX: f57a63be EBX: eb9fc4e0 ECX: f57a6000 EDX: 000000be
ESI: ed3d7cc0 EDI: 000000be EBP: 000003be ESP: ea3bddb0
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0069
Process apache2 (pid: 2206, ti=ea3bc000 task=eaca6410 task.ti=ea3bc000)
Stack:
 ea76dcc0 000013be 000000be ffffffea c01abe22 35a34067 c01040fb 0002a5cb
 40f40067 000013be ea5cb2e0 000277c0 bfc5c000 c01abee4 00000000 c01a068b
 bfc40000 80000007 00000000 00000000 000013be 0000001c e7f402e0 00100173
Call Trace:
 [<c01abe22>] ? __swap_duplicate+0xc2/0x160
 [<c01040fb>] ? pte_mfn_to_pfn+0x8b/0xe0
 [<c01abee4>] ? swap_duplicate+0x14/0x40
 [<c01a068b>] ? copy_pte_range+0x45b/0x500
 [<c01a08c5>] ? copy_page_range+0x195/0x200
 [<c0132756>] ? dup_mmap+0x1c6/0x2c0
 [<c0132b88>] ? dup_mm+0xa8/0x130
 [<c01335fa>] ? copy_process+0x98a/0xb30
 [<c01337ef>] ? do_fork+0x4f/0x280
 [<c010f780>] ? sys_clone+0x30/0x40
 [<c06c000d>] ? ptregs_clone+0x15/0x48
 [<c06bf6f1>] ? syscall_call+0x7/0xb
 [<c06b0000>] ? sctp_backlog_rcv+0xf0/0x100
Code: de 75 dc b8 01 00 00 00 5b 5e 5f 5d c3 66 90 e8 d3 7c f7 ff 8b 5b 18 83 eb 18 39 de 0f 84 7f 00 00 00 89 d8 e8 fe 7e f7 ff 01 e8 <0f> b
6 10 80 fa ff 74 dc 80 fa 7f 74 28 83 c2 01 88 10 eb 0c 89 
EIP: [<c01ab854>] swap_count_continued+0x104/0x180 SS:ESP 0069:ea3bddb0
CR2: 00000000f57a63be
---[ end trace aa46a9340a0a4bc6 ]---
note: apache2[2206] exited with preempt_count 1
BUG: scheduling while atomic: apache2/2206/0x00000001
Modules linked in:
Pid: 2206, comm: apache2 Tainted: G      D     3.0.0-linode35 #1
Call Trace:
 [<c06bda6a>] ? schedule+0x60a/0x6f0
 [<c0106404>] ? check_events+0x8/0xc
 [<c01063fb>] ? xen_restore_fl_direct_reloc+0x4/0x4
 [<c01775fe>] ? rcu_enter_nohz+0x2e/0xb0
 [<c0139921>] ? irq_exit+0x31/0xa0
 [<c0477bed>] ? xen_evtchn_do_upcall+0x1d/0x30
 [<c0101227>] ? hypercall_page+0x227/0x1000
 [<c0105c27>] ? xen_force_evtchn_callback+0x17/0x30
 [<c0106404>] ? check_events+0x8/0xc
 [<c06bf28d>] ? rwsem_down_failed_common+0x9d/0x110
 [<c06bf353>] ? call_rwsem_down_read_failed+0x7/0xc
 [<c06bea6a>] ? down_read+0xa/0x10
 [<c01683f5>] ? acct_collect+0x35/0x160
 [<c0137fbd>] ? do_exit+0x27d/0x350
 [<c011f170>] ? mm_fault_error+0x130/0x130
 [<c010b7e1>] ? oops_end+0x71/0xa0
 [<c011ef8f>] ? bad_area_nosemaphore+0xf/0x20
 [<c011f3bf>] ? do_page_fault+0x24f/0x3a0
 [<c0105c27>] ? xen_force_evtchn_callback+0x17/0x30
 [<c0106404>] ? check_events+0x8/0xc
 [<c01063fb>] ? xen_restore_fl_direct_reloc+0x4/0x4
 [<c011f170>] ? mm_fault_error+0x130/0x130
 [<c06bfc66>] ? error_code+0x5a/0x60
 [<c012007b>] ? try_preserve_large_page+0x7b/0x340
 [<c011f170>] ? mm_fault_error+0x130/0x130
 [<c01ab854>] ? swap_count_continued+0x104/0x180
 [<c01abe22>] ? __swap_duplicate+0xc2/0x160
 [<c01040fb>] ? pte_mfn_to_pfn+0x8b/0xe0
 [<c01abee4>] ? swap_duplicate+0x14/0x40
 [<c01a068b>] ? copy_pte_range+0x45b/0x500
 [<c01a08c5>] ? copy_page_range+0x195/0x200
 [<c0132756>] ? dup_mmap+0x1c6/0x2c0
 [<c0132b88>] ? dup_mm+0xa8/0x130
 [<c01335fa>] ? copy_process+0x98a/0xb30
 [<c01337ef>] ? do_fork+0x4f/0x280
 [<c010f780>] ? sys_clone+0x30/0x40
 [<c06c000d>] ? ptregs_clone+0x15/0x48
 [<c06bf6f1>] ? syscall_call+0x7/0xb
 [<c06b0000>] ? sctp_backlog_rcv+0xf0/0x100
INFO: rcu_sched_state detected stall on CPU 2 (t=60000 jiffies)

Regards,
Peter
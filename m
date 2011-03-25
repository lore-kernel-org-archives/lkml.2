Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab1CYUfa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 16:35:30 -0400
Received: from mga03.intel.com ([143.182.124.21]:23261 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754538Ab1CYUf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 16:35:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,245,1299484800"; 
   d="scan'208";a="408827392"
From: "Luck, Tony" <tony.luck@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Aaro Koskinen <aaro.koskinen@nokia.com>, Stephen Wilson <wilsons@start.ca>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Dave Hansen <dave@linux.vnet.ibm.com>
Subject: possible race in /proc/{pid}/maps
Date: Fri, 25 Mar 2011 13:35:28 -0700
Message-Id: <4d8cfc90149574244a@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cc: list = people that touched fs/proc/task_mmu.c recently]

I built the kernel from Linus' tree this morning
(HEAD=d39dd11c3e6a7af5c20bfac40594db36cf270f42)

Saw this once during boot (have tried to reproduce,
but not seen it since).  System is not a monster SMP,
this one only has 2 * single core cpus, no HT.

mingetty[5113]: error during unaligned kernel access
 -1 [1]
Modules linked in: mptctl

Pid: 5113, CPU 1, comm:             mingetty
psr : 0000101008526030 ifs : 8000000000000307 ip  : [<a0000001002237b0>]    Not tainted (2.6.38-zx1-smp-8184-gd39dd11)
ip is at m_stop+0x50/0xe0
unat: 0000000000000000 pfs : 0000000000000915 rsc : 0000000000000003
rnat: 000000004d8cc301 bsps: 000000000821faf6 pr  : 000000000019a699
ldrs: 0000000000000000 ccv : 0000000000000000 fpsr: 0009804c0270033f
csd : 0000000000000000 ssd : 0000000000000000
b0  : a0000001001ceb90 b6  : a000000100223760 b7  : a00000010000fff0
f6  : 0ffff8000000000000000 f7  : 000000000000000000000
f8  : 000000000000000000000 f9  : 000000000000000000000
f10 : 000000000000000000000 f11 : 000000000000000000000
r1  : a000000101392670 r2  : e00000406050cd50 r3  : e000004063579b80
r8  : fffffffffffffffd r9  : 0000000000000000 r10 : 0000000000000000
r11 : 00000000001919d9 r12 : e0000040664b7e10 r13 : e0000040664b0000
r14 : 0000000000000000 r15 : 0000000000000000 r16 : 0000000000000048
r17 : 2000000000438048 r18 : 2000000000438049 r19 : e0000040613f4480
r20 : 2000000000438080 r21 : 0000000000000008 r22 : e0000040664b0bc0
r23 : 0a6f732e312e3131 r24 : 0000000000438000 r25 : 00000fffffffbfff
r26 : 000000000000000d r27 : e00000406b257aa0 r28 : 0000000000000448
r29 : e00000406b257a90 r30 : 0000000000000400 r31 : 0000000000000000

Call Trace:
 [<a000000100014cb0>] show_stack+0x50/0xa0
                                sp=e0000040664b7700 bsp=e0000040664b1118
 [<a000000100015520>] show_regs+0x820/0x860
                                sp=e0000040664b78d0 bsp=e0000040664b10c0
 [<a00000010003aa80>] die+0x1a0/0x300
                                sp=e0000040664b78d0 bsp=e0000040664b1080
 [<a00000010003ac30>] die_if_kernel+0x50/0x80
                                sp=e0000040664b78d0 bsp=e0000040664b1050
 [<a00000010003fc40>] ia64_handle_unaligned+0xd20/0xe00
                                sp=e0000040664b78d0 bsp=e0000040664b0fb8
 [<a00000010000c230>] ia64_prepare_handle_unaligned+0x30/0x60
                                sp=e0000040664b7a30 bsp=e0000040664b0fb8
 [<a00000010000bc80>] ia64_native_leave_kernel+0x0/0x270
                                sp=e0000040664b7c40 bsp=e0000040664b0fb8
 [<a0000001002237b0>] m_stop+0x50/0xe0
                                sp=e0000040664b7e10 bsp=e0000040664b0f80
 [<a0000001001ceb90>] seq_read+0x630/0xa40
                                sp=e0000040664b7e10 bsp=e0000040664b0ef0
 [<a000000100187330>] vfs_read+0x1b0/0x300
                                sp=e0000040664b7e20 bsp=e0000040664b0eb0
 [<a000000100187620>] sys_read+0x80/0x100
                                sp=e0000040664b7e20 bsp=e0000040664b0e38
 [<a00000010000bb00>] ia64_ret_from_syscall+0x0/0x20
                                sp=e0000040664b7e30 bsp=e0000040664b0e38

cscope said that there are four "m_stop()" functions - but looking at the
disassessbly, it is clear that this error came from this one:

"fs/proc/task_mmu.c"

static void m_stop(struct seq_file *m, void *v)
{
        struct proc_maps_private *priv = m->private;
        struct vm_area_struct *vma = v;

        vma_stop(priv, vma);
        if (priv->task)
                put_task_struct(priv->task);
}

vma_stop() call was inlined ... code looks like this:

static void vma_stop(struct proc_maps_private *priv, struct vm_area_struct *vma)
{
        if (vma && vma != priv->tail_vma) {
# Arrive here ... vma != 0, priv->tail_vma == 0 (r14 in register dump)
                struct mm_struct *mm = vma->vm_mm;
# Get unaligned access here while dereferencing "vma".
                up_read(&mm->mmap_sem);
                mmput(mm);
        }
}

Sadly the register dump doesn't include the "stacked" registers, so I can't
see what value "vma" had ... but clearly it was bogus (should not have been
misaligned).

Given that this isn't easy to reproduce - I'm guessing that there is a race
and we are looking at some stale structures here. Perhaps things might have
been worse if "vma" pointed someplace totally invalid?

-Tony

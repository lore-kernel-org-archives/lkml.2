Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759248Ab0JZKXO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 06:23:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19007 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753830Ab0JZKXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 06:23:12 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4CC69B22.2050708@kernel.org>
References: <4CC69B22.2050708@kernel.org> <20101025224111.7798.38960.stgit@warthog.procyon.org.uk>
To: Tejun Heo <tj@kernel.org>
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@linux-foundation.org,
        linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
        Akira Takeuchi <takeuchi.akr@jp.panasonic.com>,
        Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH] MN10300: Fix the PERCPU() alignment to allow for workqueues
Date: Tue, 26 Oct 2010 11:22:22 +0100
Message-ID: <12101.1288088542@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> wrote:

> Ah, okay, but I'm not quite sure how that would affect the alignment
> of dynamically allocated percpu memory.  Is this SMP or UP build?

It is definitely SMP.

> Can you please double check the bug doesn't trigger with the section
> alignment updated?

It can be made to trigger consistently without the change, and simply updating
that alignment makes it go away.  It seems unlikely that it's affecting
subsequent stuff in the final link since the PERCPU() is immediately followed
by an alignment to PAGE_SIZE:

	PERCPU(PAGE_SIZE)
	. = ALIGN(PAGE_SIZE);

I've attached the kernel log below.  CPUID is 0 indicating this happened on
CPU 0 (the boot CPU).

> That said, I think it might be better to just remove the alignment parameter
> from the macro and force align to PAGE_SIZE.

That's not necessarily good.  Two arches to note:

	arch/x86/kernel/vmlinux.lds.S:  PERCPU(THREAD_SIZE)

which may be bigger than PAGE_SIZE and:

	arch/frv/kernel/vmlinux.lds.S:  PERCPU(4096)

FRV's page size is 16KB, so on that we really don't want it to be PAGE_SIZE.

David
---
Linux version 2.6.36-rc7-01208-g3e148cd (takeuchi@shampoo.scd.mei.co.jp) (gcc version 4.2.1 20100927 (GNUPro 07r1) (Based on: GCC 4.2, BINUTILS 2.17, GDB 6.6)) #3 SMP PREEMPT Fri Oct 22 16:37:22 JST 2010
Panasonic am34-2, rev 1
DDR2-SDRAM: 384MB/512MB memory available @0x84000000.
On node 0 totalpages: 16384
free_area_init_node: node 0, pgdat 9025cf80, node_mem_map 902c5000
  Normal zone: 128 pages used for memmap
  Normal zone: 0 pages reserved
  Normal zone: 16256 pages, LIFO batch:3
PERCPU: Embedded 7 pages/cpu @90348000 s6176 r8192 d14304 u65536
pcpu-alloc: s6176 r8192 d14304 u65536 alloc=16*4096
pcpu-alloc: [0] 0 [0] 1
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 16256
Kernel command line: root=/dev/nfs rw console=ttySM0,115200 nfsroot=192.168.10.1:/home/takeuchi/AM-Linux-2.6/nfsroot init=/bin/sh -l ip=192.168.10.72:192.168.10.1:192.168.10.1:255.255.255.0:iar-takeuchi:eth0:off debug mem=64M
PID hash table entries: 256 (order: -2, 1024 bytes)
Dentry cache hash table entries: 8192 (order: 3, 32768 bytes)
Inode-cache hash table entries: 4096 (order: 2, 16384 bytes)
Memory: 62072k/65536k available (1859k kernel code, 3464k reserved, 557k data, 96k init, 0k highmem)
Hierarchical RCU implementation.
        RCU-based detection of stalled CPUs is disabled.
        Verbose stalled-CPUs detection is disabled.
NR_IRQS:197
timestamp counter I/O clock running at 100.00 (calibrated against RTC)
console [ttySM0] enabled
Calibrating delay loop... 162.30 BogoMIPS (lpj=324608)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 512
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
CPU#0 : ioclk speed: 100.00MHz : bogomips : 162.30
Booting CPU#1
Initializing CPU#1
CPU#1 : ioclk speed: 100.00MHz : bogomips : 162.30
------------[ cut here ]------------
Kernel BUG at 9002a159 [verbose debug info unavailable]

An unsupported syscall insn was used by the kernel
: 0378
PC:  9002a157 EPSW:  00000f00  SSP: 93c25ec4 mode: Super
d0:  902776e0   d1:  000000e0   d2: 90217fec   d3: 93c16c60
a0:  902776e0   a1:  902538ec   a2: 93c1ef60   a3: 93c1ef60
e0:  00000002   e1:  00000000   e2: 00000000   e3: 00000002
e4:  00000000   e5:  9002ab90   e6: 00000100   e7: 93c1ef68
lar: 900ed2d8   lir: 41f00ef1  mdr: 901cf10d  usp: 00000000
cvf: 00000000   crl: 00000000  crh: 00000000  drq: 00000000
threadinfo=93c24000 task=93c22be0)
Process swapper (pid: 1)
CPUID:  00000000
CPUP:   0080
TBR:    900002a0
DEAR:   6f9f2709
sISR:   04000000
NMICR:  0000
BCBERR: 00000000
BCBEAR: 4c00050c
MMUFCR: 00000000
IPTEU : 08063c00  IPTEL2: 00000200
DPTEU:  300fa000  DPTEL2: 00000200

Stack:
  9002a037 00000001 9002ab90 902b695c 90011805 902b5740 00000002 93c16c60
  00000000 00000004 00000001 9002ab90 902b573c 902617c6 90217fec 90019280
  00000000 00000000 00000000 90261628 9027365c 00000000 00000000 00000000

Call Trace: [<9002a037>] __alloc_workqueue_key+0xa7/0x370
 [<9002ab90>] idle_worker_timeout+0x0/0x68
 [<90011805>] wake_up_process+0x11/0x18
 [<9002ab90>] idle_worker_timeout+0x0/0x68
 [<902617c6>] init_workqueues+0x19e/0x2b4
 [<90019280>] cpu_maps_update_done+0x10/0x14
 [<90261628>] init_workqueues+0x0/0x2b4
 [<9000149a>] do_one_initcall+0x116/0x1f0
 [<9025e431>] kernel_init+0x65/0x224
 [<9025e3cc>] kernel_init+0x0/0x224
 [<9001b188>] do_exit+0x0/0x714
 [<9000108c>] loop_set_secondary_icr+0x7c/0x8e


Kernel panic - not syncing: Attempted to kill init!

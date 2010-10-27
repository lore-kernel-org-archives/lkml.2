Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761154Ab0J0Mv7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 08:51:59 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59997 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756250Ab0J0Mv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 08:51:56 -0400
Date: Wed, 27 Oct 2010 08:51:54 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org
Subject: another potentioal kmap rework issue
Message-ID: <20101027125154.GA23679@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I haven't tracked it down to the kmap_atomic rework but it seems
rather likely:

[ 2111.896469] ------------[ cut here ]------------
[ 2111.898408] kernel BUG at /home/hch/work/linux-2.6/arch/x86/mm/highmem_32.c:46!
[ 2111.900385] invalid opcode: 0000 [#1] SMP 
[ 2111.900385] last sysfs file: /sys/devices/virtio-pci/virtio1/block/vdb/removable
[ 2111.900385] Modules linked in:
[ 2111.900385] 
[ 2111.900385] Pid: 10286, comm: aio-stress Not tainted 2.6.36+ #32 /Bochs
[ 2111.900385] EIP: 0060:[<c0158e5c>] EFLAGS: 00010006 CPU: 0
[ 2111.900385] EIP is at kmap_atomic_prot+0xec/0xf0
[ 2111.900385] EAX: f75df040 EBX: 00000001 ECX: 3c6d7163 EDX: 00000163
[ 2111.900385] ESI: fffffffc EDI: 00000001 EBP: f6801e5c ESP: f6801e4c
[ 2111.900385]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[ 2111.900385] Process aio-stress (pid: 10286, ti=f6800000 task=f13c8280task.ti=f1356000)
[ 2111.900385] Stack:
[ 2111.900385]  fffff000 f2840ef0 f20ac690 00010000 f6801e64 c0158e6e f6801e9c c024ee0d
[ 2111.900385] <0> ffffffff 00000000 f6801eac 00000046 f13c870c 00000002 00000000 00000096
[ 2111.900385] <0> f20ac6d8 d4c23950 00010000 00000000 f6801ed0 c0244be7 d4c23a24 00000096
[ 2111.900385] Call Trace:
[ 2111.900385]  [<c0158e6e>] ? __kmap_atomic+0xe/0x10
[ 2111.900385]  [<c024ee0d>] ? aio_complete+0xdd/0x1a0
[ 2111.900385]  [<c0244be7>] ? dio_complete+0x107/0x110
[ 2111.900385]  [<c0244c35>] ? dio_bio_end_aio+0x45/0xa0
[ 2111.900385]  [<c0244c5b>] ? dio_bio_end_aio+0x6b/0xa0
[ 2111.900385]  [<c02407a5>] ? bio_endio+0x15/0x30
[ 2111.900385]  [<c071b4c2>] ? req_bio_endio+0xa2/0x100
[ 2111.900385]  [<c071bdfe>] ? blk_update_request+0x17e/0x420
[ 2111.900385]  [<c071bd69>] ? blk_update_request+0xe9/0x420
[ 2111.900385]  [<c071bdfe>] ? blk_update_request+0x17e/0x420
[ 2111.900385]  [<c021320e>] ? kfree+0xfe/0x170
[ 2111.900385]  [<c071c0b6>] ? blk_update_bidi_request+0x16/0x80
[ 2111.900385]  [<c071da55>] ? __blk_end_request_all+0x25/0x50
[ 2111.900385]  [<c07bf212>] ? blk_done+0x42/0xd0
[ 2111.900385]  [<c0787ec4>] ? vring_interrupt+0x24/0x40
[ 2111.900385]  [<c01ba684>] ? handle_IRQ_event+0x44/0x160
[ 2111.900385]  [<c01bc5ac>] ? handle_edge_irq+0x9c/0x140
[ 2111.900385]  [<c01bc5b6>] ? handle_edge_irq+0xa6/0x140
[ 2111.900385]  [<c01bc510>] ? handle_edge_irq+0x0/0x140
[ 2111.900385]  <IRQ> 
[ 2111.900385]  [<c0135dd4>] ? do_IRQ+0x44/0xc0
[ 2111.900385]  [<c017b556>] ? run_timer_softirq+0xd6/0x350
[ 2111.900385]  [<c01739d0>] ? __do_softirq+0x0/0x1f0
[ 2111.900385]  [<c013502e>] ? common_interrupt+0x2e/0x34
[ 2111.900385]  [<c01367c4>] ? do_softirq+0x94/0xe0
[ 2111.900385]  [<c01739d0>] ? __do_softirq+0x0/0x1f0
[ 2111.900385]  [<c0173a20>] ? __do_softirq+0x50/0x1f0
[ 2111.900385]  [<c0173a22>] ? __do_softirq+0x52/0x1f0
[ 2111.900385]  [<c01739d0>] ? __do_softirq+0x0/0x1f0
[ 2111.900385]  <IRQ> 
[ 2111.900385]  [<c017384d>] ? irq_exit+0x6d/0x80
[ 2111.900385]  [<c014b3b6>] ? smp_apic_timer_interrupt+0x56/0x90
[ 2111.900385]  [<c0736f04>] ? trace_hardirqs_off_thunk+0xc/0x18
[ 2111.900385]  [<c0a07167>] ? apic_timer_interrupt+0x2f/0x34
[ 2111.900385]  [<c0153691>] ? native_set_pte_at+0x1/0x10
[ 2111.900385]  [<c0158cc0>] ? __kunmap_atomic+0x70/0xa0
[ 2111.900385]  [<c024e32a>] ? aio_read_evt+0xca/0xf0
[ 2111.900385]  [<c024f16f>] ? read_events+0xcf/0x340
[ 2111.900385]  [<c019ff0b>] ? trace_hardirqs_on+0xb/0x10
[ 2111.900385]  [<c0153f65>] ? pvclock_clocksource_read+0xf5/0x190
[ 2111.900385]  [<c0169660>] ? default_wake_function+0x0/0x10
[ 2111.900385]  [<c024f423>] ? sys_io_getevents+0x43/0x90
[ 2111.900385]  [<c0a06cdd>] ? syscall_call+0x7/0xb

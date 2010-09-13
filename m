Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421Ab0IMOvE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 10:51:04 -0400
Received: from relay01.mx.bawue.net ([193.7.176.67]:43483 "EHLO
	relay01.mx.bawue.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926Ab0IMOvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 10:51:01 -0400
Date: Mon, 13 Sep 2010 16:51:02 +0200
From: Nils Radtke <lkml@Think-Future.de>
To: Linux Kernel-Liste <linux-kernel@vger.kernel.org>
Subject: INFO: inconsistent lock state
Message-ID: <20100913145102.GI25129@localhost>
Reply-To: Nils Radtke <lkml@Think-Future.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Bkp: p2mi
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi, 

  Got this in the logs:

PM: Adding info for No Bus:vcs7
PM: Adding info for No Bus:vcsa7
initialized framebuffer f62c8580 with backing bo f62c0080

=================================
[ INFO: inconsistent lock state ]
2.6.35.4 #11
---------------------------------
inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
swapper/0 [HC0[0]:SC1[1]:HE1:SE0] takes:
 (&(&bdi->wb_lock)->rlock){+.?...}, at: [<c110b042>] bdi_queue_work+0x22/0x90
{SOFTIRQ-ON-W} state was registered at:
  [<c10682f4>] __lock_acquire+0x984/0x17c0
  [<c10691ab>] lock_acquire+0x7b/0x190
  [<c16ecd81>] _raw_spin_lock+0x41/0x70
  [<c10c7223>] bdi_task_init+0x23/0x70
  [<c10c7a56>] bdi_forker_task+0x16/0x2e0
  [<c1052b2c>] kthread+0x6c/0x80
  [<c10031ba>] kernel_thread_helper+0x6/0x3c
irq event stamp: 523044
hardirqs last  enabled at (523044): [<c10e2877>] kmem_cache_alloc_notrace+0x57/0xc0
hardirqs last disabled at (523043): [<c10e284f>] kmem_cache_alloc_notrace+0x2f/0xc0
softirqs last  enabled at (522978): [<c103d305>] __do_softirq+0xe5/0x2e0
softirqs last disabled at (523039): [<c103d54d>] do_softirq+0x4d/0x60

other info that might help us debug this:
1 lock held by swapper/0:
 #0:  (&q->backing_dev_info.laptop_mode_wb_timer){+.-...}, at: [<c1044ddf>] run_timer_softirq+0xbf/0x500

stack backtrace:
Pid: 0, comm: swapper Not tainted 2.6.35.4 #11
Call Trace:
 [<c16ea035>] ? printk+0x18/0x1a
 [<c1065512>] print_usage_bug+0x162/0x1a0
 [<c10658fb>] mark_lock+0x3ab/0x5b0
 [<c10648bb>] ? trace_hardirqs_off+0xb/0x10
 [<c1066180>] ? check_usage_forwards+0x0/0xe0
 [<c10682b3>] __lock_acquire+0x943/0x17c0
 [<c1004b1f>] ? dump_trace+0x7f/0xd0
 [<c1064b7b>] ? save_trace+0x3b/0xc0
 [<c106567c>] ? mark_lock+0x12c/0x5b0
 [<c10648bb>] ? trace_hardirqs_off+0xb/0x10
 [<c10691ab>] lock_acquire+0x7b/0x190
 [<c110b042>] ? bdi_queue_work+0x22/0x90
 [<c16ecd81>] _raw_spin_lock+0x41/0x70
 [<c110b042>] ? bdi_queue_work+0x22/0x90
 [<c110b042>] bdi_queue_work+0x22/0x90
 [<c110b8de>] __bdi_start_writeback+0x7e/0x190
 [<c110ba27>] bdi_start_writeback+0x17/0x20
 [<c10badd8>] laptop_mode_timer_fn+0x38/0x50
 [<c1044e67>] run_timer_softirq+0x147/0x500
 [<c1044ddf>] ? run_timer_softirq+0xbf/0x500
 [<c10bada0>] ? laptop_mode_timer_fn+0x0/0x50
 [<c103d2a6>] __do_softirq+0x86/0x2e0
 [<c103d54d>] do_softirq+0x4d/0x60
 [<c103d725>] irq_exit+0x75/0x80
 [<c1004453>] do_IRQ+0x43/0xb0
 [<c10031ae>] common_interrupt+0x2e/0x34
 [<c106007b>] ? time_to_tm+0x4b/0x1f0
 [<c131fe74>] ? acpi_idle_enter_bm+0x21d/0x251
 [<c14b67fa>] cpuidle_idle_call+0x6a/0x180
 [<c1001bd9>] cpu_idle+0x39/0x70
 [<c16de676>] rest_init+0xe6/0x100
 [<c16de590>] ? rest_init+0x0/0x100
 [<c1b6d823>] start_kernel+0x2f8/0x2fe
 [<c1b6d355>] ? unknown_bootoption+0x0/0x1a0
 [<c1b6d0b4>] i386_start_kernel+0xb4/0xbc
ata3.00: configured for UDMA/133
ata3: EH complete
sd 2:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
PM: Adding info for No Bus:vcs2


      Cheers,

              Nils


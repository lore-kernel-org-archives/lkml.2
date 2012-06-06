Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180Ab2FFPp5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 11:45:57 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34830 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173Ab2FFPpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 11:45:55 -0400
Date: Wed, 6 Jun 2012 17:45:50 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Jan Beulich <JBeulich@suse.com>, x86@kernel.org, zhong@linux.vnet.ibm.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86,nmi: Fix section mismatch warnings on 32-bit
Message-ID: <20120606154550.GA28071@gmail.com>
References: <1338839763-11140-1-git-send-email-dzickus@redhat.com>
 <4FCDDB7D0200007800088390@nat28.tlf.novell.com>
 <20120605144734.GU32472@redhat.com>
 <4FCE44FC0200007800088524@nat28.tlf.novell.com>
 <20120605183539.GA32472@redhat.com>
 <4FCF57B902000078000887EA@nat28.tlf.novell.com>
 <20120606140357.GB32472@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120606140357.GB32472@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


btw., to hijack a NMI watchdog thread, I'm sometimes getting 
these:

initcall flow_cache_init_global+0x0/0x17a returned 0 after 346 usecs
calling  pg_init+0x0/0x31b @ 1
pktgen: Packet Generator for packet performance testing. Version: 2.74
hub 2-0:1.0: state 7 ports 10 chg 0000 evt 0000
------------[ cut here ]------------
WARNING: at kernel/watchdog.c:242 watchdog_overflow_callback+0xa4/0xd0()
Watchdog detected hard LOCKUP on cpu 1Pid: 93, comm: kworker/u:1 Not tainted 3.5.0-rc1-01411-gb2f5ce5-dirty #188912
Call Trace:
 <NMI>  [<ffffffff810ada34>] ? watchdog_overflow_callback+0xa4/0xd0
 [<ffffffff8104a09b>] warn_slowpath_common+0x6b/0x90
 [<ffffffff8104a126>] warn_slowpath_fmt+0x46/0x50
 [<ffffffff810ad990>] ? proc_dohung_task_timeout_secs+0x40/0x40
 [<ffffffff810ada34>] watchdog_overflow_callback+0xa4/0xd0
 [<ffffffff810e0bb8>] __perf_event_overflow+0x158/0x240
 [<ffffffff810de220>] ? perf_event_task_disable+0x90/0x90
 [<ffffffff810e1624>] perf_event_overflow+0x14/0x20
 [<ffffffff810142a3>] x86_pmu_handle_irq+0xe3/0x130
 [<ffffffff81012749>] perf_event_nmi_handler+0x19/0x20
 [<ffffffff81006539>] nmi_handle.isra.1+0x89/0xd0
 [<ffffffff810064b0>] ? die+0x80/0x80
 [<ffffffff81006b51>] do_nmi+0x331/0x350
 [<ffffffff81ca7c62>] end_repeat_nmi+0x1a/0x1e
 [<ffffffff8102250c>] ? early_serial_putc+0x2c/0x50
 [<ffffffff8102250c>] ? early_serial_putc+0x2c/0x50
 [<ffffffff8102250c>] ? early_serial_putc+0x2c/0x50
 <<EOE>>  [<ffffffff8102256c>] early_serial_write+0x3c/0x50
 [<ffffffff8104b8b7>] console_unlock+0x267/0x360
 [<ffffffff8104bf13>] vprintk_emit+0x533/0x540
 [<ffffffff81c8dab3>] printk+0x4d/0x4f
 [<ffffffff81794bf0>] ? ata_port_probe+0x40/0x40
 [<ffffffff810751f9>] async_run_entry_fn+0x99/0x160
 [<ffffffff81065621>] process_one_work+0x2c1/0x550
 [<ffffffff81065570>] ? process_one_work+0x210/0x550
 [<ffffffff81097eee>] ? put_lock_stats.isra.16+0xe/0x40
 [<ffffffff81075160>] ? __async_schedule+0x180/0x180
 [<ffffffff81065d3a>] worker_thread+0x18a/0x290
 [<ffffffff81065bb0>] ? rescuer_thread+0x2c0/0x2c0
 [<ffffffff8106c002>] kthread+0xb2/0xc0
 [<ffffffff81ca9154>] kernel_thread_helper+0x4/0x10
 [<ffffffff8106bf50>] ? kthread_flush_work_fn+0x20/0x20
 [<ffffffff81ca9150>] ? gs_change+0xb/0xb
---[ end trace 34a2acc48c10e4d7 ]---
initcall pg_init+0x0/0x31b returned 0 after 49580351 usecs
calling  init_net_drop_monitor+0x0/0x164 @ 1
drop_monitor: Initializing network drop monitor service
initcall init_net_drop_monitor+0x0/0x164 returned 0 after 96956 usecs
ata1.00: ATA-6: HDS722525VLAT80, V36OA60A, max UDMA/100
calling  llc_init+0x0/0x20 @ 1

Which I suspect is the pg_init() in net/core/pktgen.c.

So it does its performance testing with all irqs disabled?

Thanks,

	Ingo

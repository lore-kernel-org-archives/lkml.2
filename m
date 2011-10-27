Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678Ab1J0AGM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 20:06:12 -0400
Received: from peace.netnation.com ([204.174.223.2]:47133 "EHLO
	peace.netnation.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633Ab1J0AGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 20:06:10 -0400
Date: Wed, 26 Oct 2011 17:06:09 -0700
From: Simon Kirby <sim@hostway.ca>
To: linux-kernel@vger.kernel.org
Subject: [3.1] lockdep scheduling while atomic on boot
Message-ID: <20111027000609.GE2742@hostway.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We were messing with initrd stuff to get root on MD to work with newer
than original MD superblock versions (grumble), and threw a lockdep
kernel on, which spat out the following during boot:

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.1.0-hw-lockdep+ (root@packages01-dev) (gcc version 4.3.2 (Debian 4.3.2-1.1) ) #54 SMP Wed Oct 26 14:25:58 CDT 2011
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.1.0-hw-lockdep+ root=UUID=5c132cc5-ec54-4155-aa8d-ab1834b58eee ro quiet
...
[    0.004146] Mount-cache hash table entries: 256
[    0.004999] Initializing cgroup subsys blkio
[    0.005087] CPU: Physical Processor ID: 0
[    0.005090] CPU: Processor Core ID: 0
[    0.005092] mce: CPU supports 6 MCE banks
[    0.005099] CPU0: Thermal monitoring enabled (TM1)
[    0.005104] using mwait in idle threads.
[    0.009021] ACPI: Core revision 20110623
[    0.009157] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.009217] no locks held by swapper/0.
[    0.009219] Modules linked in:
[    0.009223] Pid: 0, comm: swapper Not tainted 3.1.0-hw-lockdep+ #54
[    0.009225] Call Trace:
[    0.009234]  [<ffffffff81051475>] __schedule_bug+0x85/0x90
[    0.009240]  [<ffffffff816f5305>] __schedule+0x795/0xa20
[    0.009245]  [<ffffffff81096c3d>] ? trace_hardirqs_on_caller+0x13d/0x1c0
[    0.009250]  [<ffffffff81126a89>] ? kmem_cache_free+0x159/0x190
[    0.009254]  [<ffffffff813da692>] ? acpi_os_release_object+0x9/0xd
[    0.009258]  [<ffffffff81096c3d>] ? trace_hardirqs_on_caller+0x13d/0x1c0
[    0.009261]  [<ffffffff81096ccd>] ? trace_hardirqs_on+0xd/0x10
[    0.009265]  [<ffffffff813da692>] ? acpi_os_release_object+0x9/0xd
[    0.009269]  [<ffffffff813f8340>] ? acpi_ps_free_op+0x22/0x24
[    0.009273]  [<ffffffff81059335>] __cond_resched+0x25/0x40
[    0.009277]  [<ffffffff816f561d>] _cond_resched+0x2d/0x40
[    0.009280]  [<ffffffff813f75e8>] acpi_ps_complete_op+0x258/0x26e
[    0.009284]  [<ffffffff813f7e54>] acpi_ps_parse_loop+0x856/0x9ae
[    0.009287]  [<ffffffff813f6f2d>] acpi_ps_parse_aml+0x9a/0x282
[    0.009291]  [<ffffffff813f55bc>] acpi_ns_one_complete_parse+0xfc/0x117
[    0.009295]  [<ffffffff813f55f3>] acpi_ns_parse_table+0x1c/0x35
[    0.009298]  [<ffffffff813f2d1a>] acpi_ns_load_table+0x4a/0x8c
[    0.009302]  [<ffffffff813f9e1b>] acpi_load_tables+0xa0/0x164
[    0.009307]  [<ffffffff81b0dbe9>] ? acpi_initialize_subsystem+0x84/0xac
[    0.009310]  [<ffffffff81b0c8db>] acpi_early_init+0x6c/0xf7
[    0.009315]  [<ffffffff81ae0ca5>] start_kernel+0x370/0x43e
[    0.009320]  [<ffffffff81af77ba>] ? memblock_x86_reserve_range+0x2f/0x80
[    0.009323]  [<ffffffff81ae02c5>] x86_64_start_reservations+0xa5/0xc9
[    0.009327]  [<ffffffff81ae03f8>] x86_64_start_kernel+0x10f/0x12a
[    0.009331]  [<ffffffff81ae0140>] ? early_idt_handlers+0x140/0x140
[    0.012520] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.053354] CPU0: Intel(R) Pentium(R) Dual  CPU  E2220  @ 2.40GHz stepping 0d
[    0.056003] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
[    0.056003] PEBS disabled due to CPU errata.
[    0.056003] ... version:                2
[    0.056003] ... bit width:              40
[    0.056003] ... generic registers:      2
[    0.056003] ... value mask:             000000ffffffffff
[    0.056003] ... max period:             000000007fffffff
[    0.056003] ... fixed-purpose events:   3
[    0.056003] ... event mask:             0000000700000003
[    0.056003] NMI watchdog enabled, takes one hw-pmu counter.
[    0.056003] lockdep: fixing up alternatives.
[    0.056003] Booting Node   0, Processors  #1
[    0.056003] smpboot cpu 1: start_ip = 9c000
[    0.144097] NMI watchdog enabled, takes one hw-pmu counter.
[    0.144159] Brought up 2 CPUs

It still seems to work regardless of this BUG(). This didn't happen
without lockdep, so I assume it has something to do with how lockdep
checks are happening during early boot.

Dell r200; config, acidump, and full dmesg here: 0x.ca/sim/ref/3.1/

Simon-

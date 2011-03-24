Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036Ab1CXQME (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 12:12:04 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:56983 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754698Ab1CXQMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 12:12:01 -0400
Date: Thu, 24 Mar 2011 21:42:36 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [patch 00/15] CFS Bandwidth Control V5
Message-ID: <20110324161236.GA3399@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20110323030326.789836913@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110323030326.789836913@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 08:03:26PM -0700, Paul Turner wrote:
> Hi all,
> 
> Please find attached the latest version of bandwidth control for the normal
> scheduling class.  This revision has undergone fairly extensive changes since
> the previous version based largely on the observation that many of the edge
> conditions requiring special casing around update_curr() were a result of
> introducing side-effects into that operation.  By introducing an interstitial
> state, where we recognize that the runqueue is over bandwidth, but not marking
> it throttled until we can actually remove it from the CPU we avoid the
> previous possible interactions with throttled entities which eliminates some
> head-scratching corner cases.

I am seeing hard lockups occasionally, not always reproducible. This particular
one occured when I had 1 task in a bandwidth constrained parent group and 10
tasks in its child group which has infinite bandwidth on a 16 CPU system.

Here is the log...

WARNING: at kernel/watchdog.c:226 watchdog_overflow_callback+0x98/0xc0()
Hardware name: System x3650 M2 -[794796Q]-
Watchdog detected hard LOCKUP on cpu 0
Modules linked in: autofs4 sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf xt_physdev ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables ipv6 ext4 jbd2 dm_mirror dm_region_hash dm_log dm_mod kvm_intel kvm uinput matroxfb_base matroxfb_DAC1064 matroxfb_accel matroxfb_Ti3026 matroxfb_g450 g450_pll matroxfb_misc cdc_ether usbnet mii ses enclosure sg serio_raw pcspkr i2c_i801 i2c_core iTCO_wdt iTCO_vendor_support shpchp ioatdma dca i7core_edac edac_core bnx2 ext3 jbd mbcache sr_mod cdrom sd_mod crc_t10dif usb_storage pata_acpi ata_generic ata_piix megaraid_sas qla2xxx scsi_transport_fc scsi_tgt [last unloaded: microcode]
Pid: 0, comm: swapper Not tainted 2.6.38-tip #6
Call Trace:
 <NMI>  [<ffffffff8106558f>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff81065686>] warn_slowpath_fmt+0x46/0x50
 [<ffffffff810d8158>] watchdog_overflow_callback+0x98/0xc0
 [<ffffffff8110fb39>] __perf_event_overflow+0x99/0x250
 [<ffffffff8110d2dd>] ? perf_event_update_userpage+0xbd/0x140
 [<ffffffff8110d220>] ? perf_event_update_userpage+0x0/0x140
 [<ffffffff81110234>] perf_event_overflow+0x14/0x20
 [<ffffffff8101eb66>] intel_pmu_handle_irq+0x306/0x560
 [<ffffffff8150e4c1>] ? hw_breakpoint_exceptions_notify+0x21/0x200
 [<ffffffff8150faf6>] ? kprobe_exceptions_notify+0x16/0x450
 [<ffffffff8150e6f0>] perf_event_nmi_handler+0x50/0xc0
 [<ffffffff81510aa4>] notifier_call_chain+0x94/0xd0
 [<ffffffff81510b4c>] __atomic_notifier_call_chain+0x6c/0xa0
 [<ffffffff81510ae0>] ? __atomic_notifier_call_chain+0x0/0xa0
 [<ffffffff81510b96>] atomic_notifier_call_chain+0x16/0x20
 [<ffffffff81510bce>] notify_die+0x2e/0x30
 [<ffffffff8150d89a>] do_nmi+0xda/0x2a0
 [<ffffffff8150d4e0>] nmi+0x20/0x39
 [<ffffffff8109f4a3>] ? register_lock_class+0xb3/0x550
 <<EOE>>  <IRQ>  [<ffffffff81013e73>] ? native_sched_clock+0x13/0x60
 [<ffffffff810131e9>] ? sched_clock+0x9/0x10
 [<ffffffff81090e0d>] ? sched_clock_cpu+0xcd/0x110
 [<ffffffff810a2348>] __lock_acquire+0x98/0x15c0
 [<ffffffff810a2628>] ? __lock_acquire+0x378/0x15c0
 [<ffffffff81013e73>] ? native_sched_clock+0x13/0x60
 [<ffffffff810131e9>] ? sched_clock+0x9/0x10
 [<ffffffff81049880>] ? tg_unthrottle_down+0x0/0x50
 [<ffffffff810a3928>] lock_acquire+0xb8/0x150
 [<ffffffff81059e9c>] ? distribute_cfs_bandwidth+0xfc/0x1d0
 [<ffffffff8150c146>] _raw_spin_lock+0x36/0x70
 [<ffffffff81059e9c>] ? distribute_cfs_bandwidth+0xfc/0x1d0
 [<ffffffff81059e9c>] distribute_cfs_bandwidth+0xfc/0x1d0
 [<ffffffff81059da0>] ? distribute_cfs_bandwidth+0x0/0x1d0
 [<ffffffff8105a0eb>] sched_cfs_period_timer+0x9b/0x100
 [<ffffffff8105a050>] ? sched_cfs_period_timer+0x0/0x100
 [<ffffffff8108e631>] __run_hrtimer+0x91/0x1f0
 [<ffffffff8108e9fa>] hrtimer_interrupt+0xda/0x250
 [<ffffffff8109a5d9>] tick_do_broadcast+0x49/0x90
 [<ffffffff8109a71c>] tick_handle_oneshot_broadcast+0xfc/0x140
 [<ffffffff8100ecae>] timer_interrupt+0x1e/0x30
 [<ffffffff810d8bcd>] handle_irq_event_percpu+0x5d/0x230
 [<ffffffff810d8e28>] handle_irq_event+0x58/0x80
 [<ffffffff810dbaae>] ? handle_edge_irq+0x1e/0xe0
 [<ffffffff810dbaff>] handle_edge_irq+0x6f/0xe0
 [<ffffffff8100e449>] handle_irq+0x49/0xa0
 [<ffffffff81516bed>] do_IRQ+0x5d/0xe0
 [<ffffffff8150ce53>] ret_from_intr+0x0/0x1a
 <EOI>  [<ffffffff8109dbbd>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffff812dd074>] ? acpi_idle_enter_bm+0x242/0x27a
 [<ffffffff812dd06d>] ? acpi_idle_enter_bm+0x23b/0x27a
 [<ffffffff813ee532>] cpuidle_idle_call+0xc2/0x260
 [<ffffffff8100c07c>] cpu_idle+0xbc/0x110
 [<ffffffff814f0937>] rest_init+0xb7/0xc0
 [<ffffffff814f0880>] ? rest_init+0x0/0xc0
 [<ffffffff81dfffa2>] start_kernel+0x41c/0x427
 [<ffffffff81dff346>] x86_64_start_reservations+0x131/0x135
 [<ffffffff81dff44d>] x86_64_start_kernel+0x103/0x112

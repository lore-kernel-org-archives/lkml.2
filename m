Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab1BCDl6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 22:41:58 -0500
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:45482 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753207Ab1BCDl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 22:41:56 -0500
Date: Wed, 2 Feb 2011 22:19:43 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: linux-kernel@vger.kernel.org
Cc: Yong Zhang <yong.zhang0@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Regression: WARNINGS and lockdep spews in 2.6.38-rc3+ (bisected).
Message-ID: <20110203031943.GA8910@elliptictech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With 2.6.38-rc3+, I'm receiving nasty WARNINGS and lockdep spews on my
laptop.  Other than the noise, things seem to work fine.  The lockdep
warning is spewed as soon as the second of the following two events
occurs (in any order):

  * a key on the keyboard is pressed.
  * the radio switch is in the off position.

For example, pressing a key after booting with the switch in the off
position will trigger a dump.  The following output was what I got when I
booted with the switch on, flipped the switch off, flipped the switch
back on, then pressed a key (note that the iwlagn errors are normal).
Bisection results follow the traces -- reverting the implicated commit
solves the issue.

  ------------[ cut here ]------------
  WARNING: at /home/nick/misc/linux-2.6/kernel/softirq.c:159 _local_bh_enable_ip+0x49/0xe3()
  Hardware name: 2242CTO
  Modules linked in: nfs nfs_acl aes_x86_64 aes_generic nfsd lockd sunrpc exportfs ipv6 iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack iptable_filter xt_mark ip_tables snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_hda_codec_conexant snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer snd soundcore snd_page_alloc ufs ext2 vhost_net tun arc4 ecb crypto_blkcipher kvm_intel cryptomgr aead crypto_algapi kvm iwlagn iwlcore mac80211 btusb bluetooth cfg80211 e1000e sg joydev sr_mod cdrom uhci_hcd mmc_block ehci_hcd usbcore nls_base evdev thinkpad_acpi hwmon rfkill nvram acpi_cpufreq mperf sdhci_pci sdhci pcmcia mmc_core yenta_socket pcmcia_rsrc pcmcia_core psmouse loop rtc_cmos rtc_core rtc_lib
  Pid: 10, comm: kworker/0:1 Not tainted 2.6.38-rc3-bisect-00062-g8c007a1 #92
  Call Trace:
  [<ffffffff8103f57b>] ? warn_slowpath_common+0x80/0x98
  [<ffffffff8104a418>] ? del_timer_sync+0x4f/0x8e
  [<ffffffff8103f5a8>] ? warn_slowpath_null+0x15/0x17
  [<ffffffff81044c88>] ? _local_bh_enable_ip+0x49/0xe3
  [<ffffffff81044d3a>] ? local_bh_enable+0xd/0xf
  [<ffffffff8104a418>] ? del_timer_sync+0x4f/0x8e
  [<ffffffff8104a3c9>] ? del_timer_sync+0x0/0x8e
  [<ffffffffa00947fe>] ? rfkill_schedule_global_op+0x41/0x84 [rfkill]
  [<ffffffffa0094858>] ? rfkill_schedule_evsw_rfkillall+0x17/0x19 [rfkill]
  [<ffffffffa009495f>] ? rfkill_event+0x58/0x5a [rfkill]
  [<ffffffff8125c980>] ? input_pass_event+0x97/0xea
  [<ffffffff8125de13>] ? input_handle_event+0x460/0x46f
  [<ffffffff8125df1b>] ? input_event+0x66/0x83
  [<ffffffffa009becb>] ? tpacpi_send_radiosw_update+0x7f/0xc4 [thinkpad_acpi]
  [<ffffffffa009c417>] ? hotkey_notify+0x507/0x581 [thinkpad_acpi]
  [<ffffffff810bc242>] ? kfree+0xd2/0xeb
  [<ffffffffa009b029>] ? dispatch_acpi_notify+0x29/0x2b [thinkpad_acpi]
  [<ffffffff8119a18a>] ? acpi_ev_notify_dispatch+0x62/0x7c
  [<ffffffff8118b323>] ? acpi_os_execute_deferred+0x24/0x31
  [<ffffffff810511bf>] ? process_one_work+0x204/0x33b
  [<ffffffff8105115e>] ? process_one_work+0x1a3/0x33b
  [<ffffffff8118b2ff>] ? acpi_os_execute_deferred+0x0/0x31
  [<ffffffff81053384>] ? worker_thread+0x136/0x255
  [<ffffffff8105324e>] ? worker_thread+0x0/0x255
  [<ffffffff810566da>] ? kthread+0x7d/0x85
  [<ffffffff81003864>] ? kernel_thread_helper+0x4/0x10
  [<ffffffff812ffed8>] ? restore_args+0x0/0x30
  [<ffffffff8105665d>] ? kthread+0x0/0x85
  [<ffffffff81003860>] ? kernel_thread_helper+0x0/0x10
  ---[ end trace aae23672f55877aa ]---
  iwlagn 0000:03:00.0: Not sending command - RF KILL
  iwlagn 0000:03:00.0: Error sending REPLY_REMOVE_STA: enqueue_hcmd failed: -5
  iwlagn 0000:03:00.0: Error removing station 00:1e:e5:7a:b2:6f
  iwlagn 0000:03:00.0: Not sending command - RF KILL
  iwlagn 0000:03:00.0: Error sending REPLY_RXON: enqueue_hcmd failed: -5
  iwlagn 0000:03:00.0: Error clearing ASSOC_MSK on BSS (-5)
  iwlagn 0000:03:00.0: Not sending command - RF KILL
  iwlagn 0000:03:00.0: Error sending REPLY_RXON: enqueue_hcmd failed: -5
  iwlagn 0000:03:00.0: Error clearing ASSOC_MSK on BSS (-5)
  cfg80211: Calling CRDA to update world regulatory domain
  iwlagn 0000:03:00.0: Not sending command - RF KILL
  iwlagn 0000:03:00.0: Error sending REPLY_RXON: enqueue_hcmd failed: -5
  iwlagn 0000:03:00.0: Error clearing ASSOC_MSK on BSS (-5)
  usb 4-2: USB disconnect, address 2
  iwlagn 0000:03:00.0: RF_KILL bit toggled to enable radio.
  usb 4-2: new full speed USB device using uhci_hcd and address 3
  
  =================================
  [ INFO: inconsistent lock state ]
  2.6.38-rc3-bisect-00062-g8c007a1 #92
  ---------------------------------
  inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
  swapper/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
  (&(&dev->event_lock)->rlock){?.+...}, at: [<ffffffff8125def6>] input_event+0x41/0x83
  {HARDIRQ-ON-W} state was registered at:
  [<ffffffff810656d4>] mark_held_locks+0x52/0x70
  [<ffffffff8106593a>] trace_hardirqs_on_caller+0xf7/0x135
  [<ffffffff81065985>] trace_hardirqs_on+0xd/0xf
  [<ffffffff81044ac2>] __do_softirq+0x62/0x160
  [<ffffffff8100395c>] call_softirq+0x1c/0x28
  [<ffffffff81044cf2>] _local_bh_enable_ip+0xb3/0xe3
  [<ffffffff81044d3a>] local_bh_enable+0xd/0xf
  [<ffffffff8104a418>] del_timer_sync+0x4f/0x8e
  [<ffffffffa00947fe>] rfkill_schedule_global_op+0x41/0x84 [rfkill]
  [<ffffffffa0094858>] rfkill_schedule_evsw_rfkillall+0x17/0x19 [rfkill]
  [<ffffffffa009495f>] rfkill_event+0x58/0x5a [rfkill]
  [<ffffffff8125c980>] input_pass_event+0x97/0xea
  [<ffffffff8125de13>] input_handle_event+0x460/0x46f
  [<ffffffff8125df1b>] input_event+0x66/0x83
  [<ffffffffa009becb>] tpacpi_send_radiosw_update+0x7f/0xc4 [thinkpad_acpi]
  [<ffffffffa009c417>] hotkey_notify+0x507/0x581 [thinkpad_acpi]
  [<ffffffffa009b029>] dispatch_acpi_notify+0x29/0x2b [thinkpad_acpi]
  [<ffffffff8119a18a>] acpi_ev_notify_dispatch+0x62/0x7c
  [<ffffffff8118b323>] acpi_os_execute_deferred+0x24/0x31
  [<ffffffff810511bf>] process_one_work+0x204/0x33b
  [<ffffffff81053384>] worker_thread+0x136/0x255
  [<ffffffff810566da>] kthread+0x7d/0x85
  [<ffffffff81003864>] kernel_thread_helper+0x4/0x10
  irq event stamp: 559266
  hardirqs last  enabled at (559263): [<ffffffff811b40a5>] acpi_idle_enter_bm+0x236/0x275
  hardirqs last disabled at (559264): [<ffffffff812ffd6a>] save_args+0x6a/0x70
  softirqs last  enabled at (559266): [<ffffffff81044bce>] _local_bh_enable+0xe/0x10
  softirqs last disabled at (559265): [<ffffffff81044c0d>] irq_enter+0x3d/0x6f
  
  other info that might help us debug this:
  1 lock held by swapper/0:
  #0:  (&serio->lock){-.-...}, at: [<ffffffff81259018>] serio_interrupt+0x24/0x7e
  
  stack backtrace:
  Pid: 0, comm: swapper Tainted: G        W   2.6.38-rc3-bisect-00062-g8c007a1 #92
  Call Trace:
  <IRQ>  [<ffffffff81065442>] ? valid_state+0x17e/0x191
  [<ffffffff8100e159>] ? save_stack_trace+0x28/0x45
  [<ffffffff81065d18>] ? check_usage_forwards+0x0/0x87
  [<ffffffff81065568>] ? mark_lock+0x113/0x22d
  [<ffffffff8106687f>] ? __lock_acquire+0x2ac/0xd01
  [<ffffffff81065482>] ? mark_lock+0x2d/0x22d
  [<ffffffff81065482>] ? mark_lock+0x2d/0x22d
  [<ffffffff81065482>] ? mark_lock+0x2d/0x22d
  [<ffffffff81067338>] ? lock_acquire+0x64/0x81
  [<ffffffff8125def6>] ? input_event+0x41/0x83
  [<ffffffff812ff378>] ? _raw_spin_lock_irqsave+0x53/0x65
  [<ffffffff8125def6>] ? input_event+0x41/0x83
  [<ffffffff8125def6>] ? input_event+0x41/0x83
  [<ffffffff81261fb6>] ? atkbd_interrupt+0x9a/0x574
  [<ffffffff81259034>] ? serio_interrupt+0x40/0x7e
  [<ffffffff8125a31c>] ? i8042_interrupt+0x28e/0x2a8
  [<ffffffff8107e834>] ? handle_IRQ_event+0x20/0xae
  [<ffffffff810805e6>] ? handle_edge_irq+0xde/0x12a
  [<ffffffff810055c9>] ? handle_irq+0x1f/0x2a
  [<ffffffff81004c37>] ? do_IRQ+0x48/0xaf
  [<ffffffff812ffe13>] ? ret_from_intr+0x0/0x1a
  <EOI>  [<ffffffff8100a1aa>] ? native_sched_clock+0x2d/0x5f
  [<ffffffff811b40ac>] ? acpi_idle_enter_bm+0x23d/0x275
  [<ffffffff811b40a5>] ? acpi_idle_enter_bm+0x236/0x275
  [<ffffffff8126c2ae>] ? cpuidle_idle_call+0x9f/0xd5
  [<ffffffff81001e75>] ? cpu_idle+0x61/0xaa
  [<ffffffff812ecdc9>] ? rest_init+0xcd/0xd4
  [<ffffffff812eccfc>] ? rest_init+0x0/0xd4
  [<ffffffff81682d3d>] ? start_kernel+0x3a6/0x3b1
  [<ffffffff816822b1>] ? x86_64_start_reservations+0xb8/0xbc
  [<ffffffff816823bb>] ? x86_64_start_kernel+0x106/0x115

1118e2cd33d47254854e1ba3ba8e32802ff14fdf is the first bad commit
commit 1118e2cd33d47254854e1ba3ba8e32802ff14fdf
Author: Yong Zhang <yong.zhang@windriver.com>
Date:   Wed Oct 20 15:57:32 2010 -0700

    timer: Del_timer_sync() can be used in softirq context
    
    Actually we have used del_timer_sync() in softirq context for a long time,
    e.g. in __dst_free()::cancel_delayed_work().
    
    So change the comments of it to warn on hardirq context only, and make
    lockdep know about this change.
    
    Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
    Cc: Ingo Molnar <mingo@elte.hu>
    Cc: Peter Zijlstra <peterz@infradead.org>
    Cc: Oleg Nesterov <oleg@redhat.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

:040000 040000 864a7fbdaeb5226c2cc47a49e56c2d5509d548be adb06c69b689b1ec1a9853e9d4f22b631683c164 M	kernel

git bisect start
# bad: [afe8a887550f7cc24eb16449670b93f6b43c32d8] Merge branch 'next' of git://git.monstr.eu/linux-2.6-microblaze
git bisect bad afe8a887550f7cc24eb16449670b93f6b43c32d8
# good: [3c0eee3fe6a3a1c745379547c7e7c904aa64f6d5] Linux 2.6.37
git bisect good 3c0eee3fe6a3a1c745379547c7e7c904aa64f6d5
# bad: [949f6711b83d2809d1ccb9d830155a65fdacdff9] Merge branch 'staging-next' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-2.6
git bisect bad 949f6711b83d2809d1ccb9d830155a65fdacdff9
# bad: [3c0cb7c31c206aaedb967e44b98442bbeb17a6c4] Merge branch 'devel' of master.kernel.org:/home/rmk/linux-2.6-arm
git bisect bad 3c0cb7c31c206aaedb967e44b98442bbeb17a6c4
# good: [63e35cd9bd4c8ae085c8b9a70554595b529c4100] Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next-2.6 into for-davem
git bisect good 63e35cd9bd4c8ae085c8b9a70554595b529c4100
# bad: [9858a38ea3a940762ae3028cce88f686d0e0c28b] Merge branch 'sh-latest' of git://git.kernel.org/pub/scm/linux/kernel/git/lethal/sh-2.6
git bisect bad 9858a38ea3a940762ae3028cce88f686d0e0c28b
# bad: [6f46b120a96212b85cbdcb84a64c854dfd791ede] Merge branch 'x86-microcode-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
git bisect bad 6f46b120a96212b85cbdcb84a64c854dfd791ede
# good: [4eed11d5e24540dc133003b6e8f904cb747ac4bb] perf evsel: Auto allocate resources needed for some methods
git bisect good 4eed11d5e24540dc133003b6e8f904cb747ac4bb
# good: [28d9bfc37c861aa9c8386dff1ac7e9a10e5c5162] Merge branch 'perf-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
git bisect good 28d9bfc37c861aa9c8386dff1ac7e9a10e5c5162
# good: [65b2074f84be2287e020839e93b4cdaaf60eb37c] Merge branch 'sched-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
git bisect good 65b2074f84be2287e020839e93b4cdaaf60eb37c
# bad: [42cbd8efb0746b55112de45173219f76c54390da] Merge branch 'x86-amd-nb-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
git bisect bad 42cbd8efb0746b55112de45173219f76c54390da
# bad: [87de5ac782761a3ebf806e434e8c9cc205a87274] timers: Introduce timerlist infrastructure.
git bisect bad 87de5ac782761a3ebf806e434e8c9cc205a87274
# good: [dd6414b50fa2b1cd247a8aa8f8bd42414b7453e1] timer: Permit statically-declared work with deferrable timers
git bisect good dd6414b50fa2b1cd247a8aa8f8bd42414b7453e1
# bad: [1118e2cd33d47254854e1ba3ba8e32802ff14fdf] timer: Del_timer_sync() can be used in softirq context
git bisect bad 1118e2cd33d47254854e1ba3ba8e32802ff14fdf
# good: [6f1bc451e6a79470b122a37ee1fc6bbca450f444] timer: Make try_to_del_timer_sync() the same on SMP and UP
git bisect good 6f1bc451e6a79470b122a37ee1fc6bbca450f444

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671Ab0HPSms (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 14:42:48 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:53235 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586Ab0HPSmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 14:42:46 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 16 Aug 2010 20:42:34 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: lockdep false positive? -- firewire-core transaction timer vs.
 scsi-core host lock
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.1e48e021935dc8b7@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, I just saw the following (twice, with a reboot in between) with
kernel 2.6.35 plus firewire driver patched to their state in 2.6.36-rc1,
i.e. basically with a kernel according to commit e78483c5.

I suspect it might also happen without firewire patches, as 2.6.35
already contains the change where firewire-core's per-transaction timer
was introduced which shows up in the following log.

It happened while I was testing hotplugging of FireWire disks with
several ones on a bus together with several FireWire 800 repeaters,
which sometimes act up so that reconnect does not succeed immediately.
Perhaps such reconnection troubles are necessary to provoke this lockdep
report.

[I only accidentally discovered this on a test PC which do not use very
frequently.  Unfortunately, I had lockdep disabled on my main PC on
which I test most of my FireWire hardware for quite a while now.  I
guess I should enable lockdep there again, but I have a suspicion that I
won't leave it on for too long.]

Note how the IN-HARDIRQ-W talks about a SCSI host lock of a libata host,
whereas the locking in the firewire stack surely does only interact
(hopefully correctly) with SCSI host locks of firewire-sbp2 host
instances.

What does this all mean?  How to act on it?

=========================================================
[ INFO: possible irq lock inversion dependency detected ]
2.6.35 #1
---------------------------------------------------------
swapper/0 just changed the state of lock:
 (&t->split_timeout_timer){+.-...}, at: [<c1032228>] run_timer_softirq+0x112/0x21c
but this lock was taken by another, HARDIRQ-safe lock in the past:
 (&(shost->host_lock)->rlock){-.-...}

and interrupts could create inverse lock ordering between them.


other info that might help us debug this:
no locks held by swapper/0.

the shortest dependencies between 2nd lock and 1st lock:
 -> (&(shost->host_lock)->rlock){-.-...} ops: 123308 {
    IN-HARDIRQ-W at:
                          [<c104a080>] __lock_acquire+0x612/0x153e
                          [<c104b008>] lock_acquire+0x5c/0x73
                          [<c1268b57>] _raw_spin_lock_irqsave+0x2e/0x3e
                          [<c11ad508>] scsi_eh_scmd_add+0x25/0x8a
                          [<c11ad5b7>] scsi_times_out+0x4a/0x64
                          [<c10e9fca>] blk_rq_timed_out+0xf/0x4b
                          [<c10ea044>] blk_abort_request+0x3e/0x41
                          [<c11c43c0>] ata_qc_schedule_eh+0x55/0x67
                          [<c11b9c4e>] ata_qc_complete+0x59/0x1b6
                          [<c11c6751>] ata_hsm_qc_complete+0xb5/0xcf
                          [<c11c6e18>] ata_sff_hsm_move+0x6ad/0x6fa
                          [<c11c7002>] __ata_sff_port_intr+0x9f/0xad
                          [<c11c70c9>] ata_bmdma_port_intr+0xb9/0x127
                          [<c11c71c3>] ata_bmdma_interrupt+0x8c/0x170
                          [<c1059b58>] handle_IRQ_event+0x1d/0xa2
                          [<c105b45f>] handle_fasteoi_irq+0x79/0xb2
                          [<c10045bb>] handle_irq+0x3b/0x48
                          [<c1003df9>] do_IRQ+0x45/0x9f
                          [<c1002d2e>] common_interrupt+0x2e/0x34
                          [<c11f4500>] cpuidle_idle_call+0x6d/0xa1
                          [<c1001a72>] cpu_idle+0x49/0x77
                          [<c12594f7>] rest_init+0xbf/0xc4
                          [<c13c98c9>] start_kernel+0x306/0x30b
                          [<c13c90b7>] i386_start_kernel+0xb7/0xbf
    IN-SOFTIRQ-W at:
                          [<c104a0a1>] __lock_acquire+0x633/0x153e
                          [<c104b008>] lock_acquire+0x5c/0x73
                          [<c1268b57>] _raw_spin_lock_irqsave+0x2e/0x3e
                          [<c11aec72>] scsi_device_unbusy+0x1e/0x8d
                          [<c11a92fa>] scsi_finish_command+0x22/0xdf
                          [<c11af291>] scsi_softirq_done+0xf4/0xfc
                          [<c10e9d9c>] blk_done_softirq+0x5c/0x69
                          [<c102defb>] __do_softirq+0x8b/0x10a
                          [<c102dfa5>] do_softirq+0x2b/0x43
                          [<c102e031>] run_ksoftirqd+0x74/0x15a
                          [<c103ae19>] kthread+0x61/0x66
                          [<c1002d3a>] kernel_thread_helper+0x6/0x1a
    INITIAL USE at:
                         [<c104a17b>] __lock_acquire+0x70d/0x153e
                         [<c104b008>] lock_acquire+0x5c/0x73
                         [<c1268b57>] _raw_spin_lock_irqsave+0x2e/0x3e
                         [<c11ad5e0>] scsi_schedule_eh+0xf/0x4f
                         [<c11c4125>] ata_port_schedule_eh+0x37/0x3a
                         [<c11bd629>] async_port_probe+0x65/0x9c
                         [<c1040051>] async_thread+0xe7/0x1c8
                         [<c103ae19>] kthread+0x61/0x66
                         [<c1002d3a>] kernel_thread_helper+0x6/0x1a
  }
  ... key      at: [<c19b0ab4>] __key.30680+0x0/0x8
  ... acquired at:
   [<c104b008>] lock_acquire+0x5c/0x73
   [<c1032a3f>] del_timer_sync+0x29/0x6c
   [<f84a6ea0>] close_transaction+0x93/0xb4 [firewire_core]
   [<f84a6f00>] transmit_complete_callback+0x3f/0x43 [firewire_core]
   [<f8da60ff>] at_context_transmit+0x59b/0x5a3 [firewire_ohci]
   [<f8da6123>] ohci_send_request+0xd/0xf [firewire_ohci]
   [<f84a7ce4>] fw_send_request+0x21c/0x224 [firewire_core]
   [<f8dab307>] 0xf8dab307
   [<f8dac075>] 0xf8dac075
   [<c11a962a>] scsi_dispatch_cmd+0x182/0x1f2
   [<c11ae4ed>] scsi_request_fn+0x359/0x492
   [<c10e644f>] __generic_unplug_device+0x26/0x29
   [<c10e9306>] blk_execute_rq_nowait+0x56/0x75
   [<c10e93cd>] blk_execute_rq+0xa8/0xc7
   [<c11af359>] scsi_execute+0xc0/0x105
   [<c11af3f3>] scsi_execute_req+0x55/0x7d
   [<c11b3d9a>] sd_start_stop_device+0x7b/0x117
   [<c11b41a7>] sd_shutdown+0x108/0x117
   [<c11b42d0>] sd_remove+0x42/0x6f
   [<c11975af>] __device_release_driver+0x5e/0x96
   [<c119768d>] device_release_driver+0x1a/0x25
   [<c1196dcc>] bus_remove_device+0x7b/0x92
   [<c119592a>] device_del+0xfa/0x154
   [<c11b21ae>] __scsi_remove_device+0x3d/0x7b
   [<c11b2208>] scsi_remove_device+0x1c/0x27
   [<f8dab83e>] 0xf8dab83e
   [<c10f2b89>] kref_put+0x39/0x44
   [<f8dab0ff>] 0xf8dab0ff
   [<c11975af>] __device_release_driver+0x5e/0x96
   [<c119768d>] device_release_driver+0x1a/0x25
   [<c1196dcc>] bus_remove_device+0x7b/0x92
   [<c119592a>] device_del+0xfa/0x154
   [<c119598f>] device_unregister+0xb/0x15
   [<f84a4eb8>] shutdown_unit+0x8/0xc [firewire_core]
   [<c1195270>] device_for_each_child+0x2a/0x54
   [<f84a4f2e>] fw_device_shutdown+0x72/0xa4 [firewire_core]
   [<c1037f34>] worker_thread+0x16a/0x242
   [<c103ae19>] kthread+0x61/0x66
   [<c1002d3a>] kernel_thread_helper+0x6/0x1a

-> (&t->split_timeout_timer){+.-...} ops: 14281 {
   HARDIRQ-ON-W at:
                        [<c104a100>] __lock_acquire+0x692/0x153e
                        [<c104b008>] lock_acquire+0x5c/0x73
                        [<c1032291>] run_timer_softirq+0x17b/0x21c
                        [<c102defb>] __do_softirq+0x8b/0x10a
                        [<c102dfa5>] do_softirq+0x2b/0x43
                        [<c102e14f>] irq_exit+0x38/0x74
                        [<c1003e3d>] do_IRQ+0x89/0x9f
                        [<c1002d2e>] common_interrupt+0x2e/0x34
                        [<c11f4500>] cpuidle_idle_call+0x6d/0xa1
                        [<c1001a72>] cpu_idle+0x49/0x77
                        [<c12594f7>] rest_init+0xbf/0xc4
                        [<c13c98c9>] start_kernel+0x306/0x30b
                        [<c13c90b7>] i386_start_kernel+0xb7/0xbf
   IN-SOFTIRQ-W at:
                        [<c104a0a1>] __lock_acquire+0x633/0x153e
                        [<c104b008>] lock_acquire+0x5c/0x73
                        [<c1032a3f>] del_timer_sync+0x29/0x6c
                        [<f84a6ddc>] fw_core_handle_response+0x108/0x139 [firewire_core]
                        [<f8da5b58>] handle_ar_packet+0x108/0x114 [firewire_ohci]
                        [<f8da6236>] ar_context_tasklet+0x111/0x11f [firewire_ohci]
                        [<c102da6d>] tasklet_action+0x8d/0xe0
                        [<c102defb>] __do_softirq+0x8b/0x10a
                        [<c102dfa5>] do_softirq+0x2b/0x43
                        [<c102e14f>] irq_exit+0x38/0x74
                        [<c1003e3d>] do_IRQ+0x89/0x9f
                        [<c1002d2e>] common_interrupt+0x2e/0x34
                        [<c11f4500>] cpuidle_idle_call+0x6d/0xa1
                        [<c1001a72>] cpu_idle+0x49/0x77
                        [<c12594f7>] rest_init+0xbf/0xc4
                        [<c13c98c9>] start_kernel+0x306/0x30b
                        [<c13c90b7>] i386_start_kernel+0xb7/0xbf
   INITIAL USE at:
                       [<c104a17b>] __lock_acquire+0x70d/0x153e
                       [<c104b008>] lock_acquire+0x5c/0x73
                       [<c1032a3f>] del_timer_sync+0x29/0x6c
                       [<f84a6ddc>] fw_core_handle_response+0x108/0x139 [firewire_core]
                       [<f8da5de2>] at_context_transmit+0x27e/0x5a3 [firewire_ohci]
                       [<f8da6123>] ohci_send_request+0xd/0xf [firewire_ohci]
                       [<f84a7ce4>] fw_send_request+0x21c/0x224 [firewire_core]
                       [<f84a7d71>] fw_run_transaction+0x85/0xc5 [firewire_core]
                       [<f84a2485>] bm_work+0x16c/0x34b [firewire_core]
                       [<c1037f34>] worker_thread+0x16a/0x242
                       [<c103ae19>] kthread+0x61/0x66
                       [<c1002d3a>] kernel_thread_helper+0x6/0x1a
 }
 ... key      at: [<f84a97d0>] __key.22471+0x0/0xffffe611 [firewire_core]
 ... acquired at:
   [<c10494ba>] check_usage_backwards+0x94/0x9f
   [<c1048b60>] mark_lock+0x2c0/0x4cd
   [<c104a100>] __lock_acquire+0x692/0x153e
   [<c104b008>] lock_acquire+0x5c/0x73
   [<c1032291>] run_timer_softirq+0x17b/0x21c
   [<c102defb>] __do_softirq+0x8b/0x10a
   [<c102dfa5>] do_softirq+0x2b/0x43
   [<c102e14f>] irq_exit+0x38/0x74
   [<c1003e3d>] do_IRQ+0x89/0x9f
   [<c1002d2e>] common_interrupt+0x2e/0x34
   [<c11f4500>] cpuidle_idle_call+0x6d/0xa1
   [<c1001a72>] cpu_idle+0x49/0x77
   [<c12594f7>] rest_init+0xbf/0xc4
   [<c13c98c9>] start_kernel+0x306/0x30b
   [<c13c90b7>] i386_start_kernel+0xb7/0xbf


stack backtrace:
Pid: 0, comm: swapper Not tainted 2.6.35 #1
Call Trace:
 [<c1266701>] ? printk+0xf/0x16
 [<c104937c>] print_irq_inversion_bug+0xeb/0xf6
 [<c10494ba>] check_usage_backwards+0x94/0x9f
 [<c1048b60>] mark_lock+0x2c0/0x4cd
 [<c1049426>] ? check_usage_backwards+0x0/0x9f
 [<c104a100>] __lock_acquire+0x692/0x153e
 [<c126910a>] ? _raw_spin_unlock_irqrestore+0x54/0x58
 [<c10fbc1f>] ? debug_object_deactivate+0xa1/0xcc
 [<c104b008>] lock_acquire+0x5c/0x73
 [<c1032228>] ? run_timer_softirq+0x112/0x21c
 [<c1032291>] run_timer_softirq+0x17b/0x21c
 [<c1032228>] ? run_timer_softirq+0x112/0x21c
 [<f84a77ce>] ? split_transaction_timeout_callback+0x0/0x8b [firewire_core]
 [<c102defb>] __do_softirq+0x8b/0x10a
 [<c102dfa5>] do_softirq+0x2b/0x43
 [<c102e14f>] irq_exit+0x38/0x74
 [<c1003e3d>] do_IRQ+0x89/0x9f
 [<c1002d2e>] common_interrupt+0x2e/0x34
 [<c1140f6d>] ? acpi_idle_enter_simple+0x122/0x14e
 [<c11f4500>] cpuidle_idle_call+0x6d/0xa1
 [<c1001a72>] cpu_idle+0x49/0x77
 [<c12594f7>] rest_init+0xbf/0xc4
 [<c13c98c9>] start_kernel+0x306/0x30b
 [<c13c90b7>] i386_start_kernel+0xb7/0xbf


-- 
Stefan Richter
-=====-==-=- =--- =----
http://arcgraph.de/sr/


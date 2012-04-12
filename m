Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761909Ab2DLLnK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 07:43:10 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:1107 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752083Ab2DLLnH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 07:43:07 -0400
Message-ID: <1334230976.1913.9.camel@x61.thuisdomein>
Subject: Re: [v3.4-rc1] ACPI regression bisected
From: Paul Bolle <pebolle@tiscali.nl>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: =?ISO-8859-1?Q?J=F6rg?= Otte <jrg.otte@googlemail.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        Len Brown <lenb@kernel.org>
Date: Thu, 12 Apr 2012 13:42:56 +0200
In-Reply-To: <alpine.LFD.2.02.1204121055200.2542@ionos>
References: <CADDKRnBpGr=yzDftChA3xiaK9gK4D4UDV6HJiw8hcMo6159+Cw@mail.gmail.com>
	 <20120402235412.GD16303@tassilo.jf.intel.com>
	 <alpine.LFD.2.02.1204031001510.2542@ionos>
	 <CADDKRnAOqfxTjrCp4E5eKFJvVTu6s0xF3Ca3jRJavFkyGpYLmQ@mail.gmail.com>
	 <alpine.LFD.2.02.1204121055200.2542@ionos>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
X-OriginalArrivalTime: 12 Apr 2012 11:42:57.0011 (UTC) FILETIME=[67932430:01CD18A1]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-04-12 at 10:57 +0200, Thomas Gleixner wrote:
> OK, so now the question is whether the ACPI interrupt can end up being
> shared or not.
> 
> If it can be shared, then we need a proper primary handler which
> silences the interrupt at the device level and the threaded handler
> needs to reenable it after finishing the processing.

0) For what it's worth, I've got a ThinkPad T41 that triggers the same
problem Jörg reported (both in v3.4-rc1 and in v3.4-rc2). I managed to
capture some further info over a serial line.

1) After printing
    "ACPI: EC: EC description table is found, configuring boot EC"

Fedora Rawhide's 3.4.0-0.rc1.git3.1.fc18.i686 loops printing:

BUG: soft lockup - CPU#0 stuck for 22s! [swapper/0:1]
Modules linked in:
irq event stamp: 6634591
hardirqs last  enabled at (6634590): [<c09d903d>] restore_all_notrace+0x0/0x18
hardirqs last disabled at (6634591): [<c09e10ee>] common_interrupt+0x2e/0x3c
softirqs last  enabled at (302952): [<c0443645>] __do_softirq+0x115/0x330
softirqs last disabled at (303313): [<c04053e5>] do_softirq+0xa5/0x100
Modules linked in:

Pid: 1, comm: swapper/0 Not tainted 3.4.0-0.rc1.git3.1.fc18.i686 #1 IBM        /       
EIP: 0060:[<c0443592>] EFLAGS: 00000206 CPU: 0
EIP is at __do_softirq+0x62/0x330
EAX: f4538000 EBX: f4538000 ECX: 00000002 EDX: f4538484
ESI: 00000002 EDI: 00000002 EBP: f4413ff8 ESP: f4413fc4
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
CR0: 8005003b CR2: ff996000 CR3: 00ea7000 CR4: 000007d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Process swapper/0 (pid: 1, ti=f4410000 task=f4538000 task.ti=f452a000)
Stack:
 00000000 00000000 00000000 00000000 00000000 00000000 00000000 0000000a
 00000100 c0c1da08 f452b950 f452a000 c0443530 f452b960 c04053e5
Call Trace:
 [<c0443530>] ? local_bh_enable_ip+0xd0/0xd0
 <IRQ> 
 [<c0443b25>] ? irq_exit+0xb5/0xc0
 [<c040501b>] ? do_IRQ+0x4b/0xc0
 [<c04a1084>] ? trace_hardirqs_on_caller+0xf4/0x180
 [<c09e10f5>] ? common_interrupt+0x35/0x3c
 [<c04a007b>] ? __lock_acquire+0x154b/0x1640
 [<c09d8cea>] ? _raw_spin_unlock_irqrestore+0x3a/0x70
 [<c046054e>] ? prepare_to_wait+0x4e/0x70
 [<c070dd6e>] ? acpi_ec_transaction_unlocked+0x13f/0x1f0
 [<c0460330>] ? wake_up_bit+0x30/0x30
 [<c070e0dd>] ? acpi_ec_transaction+0x18c/0x24f
 [<c04a111b>] ? trace_hardirqs_on+0xb/0x10
 [<c070962f>] ? acpi_os_signal_semaphore+0x67/0x76
 [<c070e23c>] ? acpi_ec_read+0x43/0x50
 [<c070e3aa>] ? acpi_ec_space_handler+0x84/0xf2
 [<c070e326>] ? acpi_ec_burst_disable+0x40/0x40
 [<c0719cd7>] ? acpi_ev_address_space_dispatch+0x201/0x253
 [<c070e326>] ? acpi_ec_burst_disable+0x40/0x40
 [<c071e2a1>] ? acpi_ex_access_region+0x2c9/0x361
 [<c071e719>] ? acpi_ex_field_datum_io+0x110/0x35f
 [<c0551180>] ? kmem_cache_alloc+0xd0/0x230
 [<c04055c7>] ? dump_trace+0x97/0x100
 [<c0733523>] ? acpi_ut_allocate_object_desc_dbg+0x3a/0xaf
 [<c071e9f6>] ? acpi_ex_extract_from_field+0x8e/0x223
 [<c0733778>] ? acpi_ut_create_integer_object+0x2a/0x39
 [<c071dd15>] ? acpi_ex_read_data_from_field+0x195/0x1ca
 [<c0721e44>] ? acpi_ex_resolve_node_to_value+0x21c/0x2a8
 [<c072217b>] ? acpi_ex_resolve_to_value+0x2ab/0x2bb
 [<c0715b67>] ? acpi_ds_evaluate_name_path+0x6d/0xd6
 [<c0715fb2>] ? acpi_ds_exec_end_op+0x8b/0x585
 [<c0715f02>] ? acpi_ds_exec_begin_op+0x169/0x18e
 [<c072bb1e>] ? acpi_ps_parse_loop+0x805/0x9b7
 [<c072c102>] ? acpi_ps_parse_aml+0x105/0x34f
 [<c072c9ea>] ? acpi_ps_execute_method+0x1ea/0x2c8
 [<c07266f3>] ? acpi_ns_evaluate+0x167/0x2cb
 [<c0726aa0>] ? acpi_ns_init_one_device+0xa0/0x14e
 [<c0726a00>] ? acpi_ns_exec_module_code_list+0x1a9/0x1a9
 [<c0729a17>] ? acpi_ns_walk_namespace+0xc8/0x171
 [<c0cd33d4>] ? acpi_sleep_proc_init+0x2e/0x2e
 [<c0726fc2>] ? acpi_ns_initialize_devices+0x132/0x1c8
 [<c0726a00>] ? acpi_ns_exec_module_code_list+0x1a9/0x1a9
 [<c07340e4>] ? acpi_initialize_objects+0xed/0xf7
 [<c0cd34e3>] ? acpi_init+0x10f/0x28c
 [<c0401202>] ? do_one_initcall+0x112/0x160
 [<c0ca88bf>] ? kernel_init+0x10f/0x1a6
 [<c0ca8154>] ? rdinit_setup+0x22/0x22
 [<c0ca87b0>] ? start_kernel+0x39f/0x39f
 [<c09e1102>] ? kernel_thread_helper+0x6/0x10
Code: 00 01 64 a1 6c 88 d5 c0 c7 45 e8 0a 00 00 00 89 45 e4 8d b4 26 00 00 00 00 64 c7 05 40 d6 e9 c0 00 00 00 00 e8 80 db 05 00 fb 90 <8d> 74 26 00 c7 45 f0 00 da c1 c0 eb 09 90 83 45 f0 04 d1 ef 74
Call Trace:
 [<c0443530>] ? local_bh_enable_ip+0xd0/0xd0
 <IRQ>  [<c0443b25>] ? irq_exit+0xb5/0xc0
 [<c040501b>] ? do_IRQ+0x4b/0xc0
 [<c04a1084>] ? trace_hardirqs_on_caller+0xf4/0x180
 [<c09e10f5>] ? common_interrupt+0x35/0x3c
 [<c04a007b>] ? __lock_acquire+0x154b/0x1640
 [<c09d8cea>] ? _raw_spin_unlock_irqrestore+0x3a/0x70
 [<c046054e>] ? prepare_to_wait+0x4e/0x70
 [<c070dd6e>] ? acpi_ec_transaction_unlocked+0x13f/0x1f0
 [<c0460330>] ? wake_up_bit+0x30/0x30
 [<c070e0dd>] ? acpi_ec_transaction+0x18c/0x24f
 [<c04a111b>] ? trace_hardirqs_on+0xb/0x10
 [<c070962f>] ? acpi_os_signal_semaphore+0x67/0x76
 [<c070e23c>] ? acpi_ec_read+0x43/0x50
 [<c070e3aa>] ? acpi_ec_space_handler+0x84/0xf2
 [<c070e326>] ? acpi_ec_burst_disable+0x40/0x40
 [<c0719cd7>] ? acpi_ev_address_space_dispatch+0x201/0x253
 [<c070e326>] ? acpi_ec_burst_disable+0x40/0x40
 [<c071e2a1>] ? acpi_ex_access_region+0x2c9/0x361
 [<c071e719>] ? acpi_ex_field_datum_io+0x110/0x35f
 [<c0551180>] ? kmem_cache_alloc+0xd0/0x230
 [<c04055c7>] ? dump_trace+0x97/0x100
 [<c0733523>] ? acpi_ut_allocate_object_desc_dbg+0x3a/0xaf
 [<c071e9f6>] ? acpi_ex_extract_from_field+0x8e/0x223
 [<c0733778>] ? acpi_ut_create_integer_object+0x2a/0x39
 [<c071dd15>] ? acpi_ex_read_data_from_field+0x195/0x1ca
 [<c0721e44>] ? acpi_ex_resolve_node_to_value+0x21c/0x2a8
 [<c072217b>] ? acpi_ex_resolve_to_value+0x2ab/0x2bb
 [<c0715b67>] ? acpi_ds_evaluate_name_path+0x6d/0xd6
 [<c0715fb2>] ? acpi_ds_exec_end_op+0x8b/0x585
 [<c0715f02>] ? acpi_ds_exec_begin_op+0x169/0x18e
 [<c072bb1e>] ? acpi_ps_parse_loop+0x805/0x9b7
 [<c072c102>] ? acpi_ps_parse_aml+0x105/0x34f
 [<c072c9ea>] ? acpi_ps_execute_method+0x1ea/0x2c8
 [<c07266f3>] ? acpi_ns_evaluate+0x167/0x2cb
 [<c0726aa0>] ? acpi_ns_init_one_device+0xa0/0x14e
 [<c0726a00>] ? acpi_ns_exec_module_code_list+0x1a9/0x1a9
 [<c0729a17>] ? acpi_ns_walk_namespace+0xc8/0x171
 [<c0cd33d4>] ? acpi_sleep_proc_init+0x2e/0x2e
 [<c0726fc2>] ? acpi_ns_initialize_devices+0x132/0x1c8
 [<c0726a00>] ? acpi_ns_exec_module_code_list+0x1a9/0x1a9
 [<c07340e4>] ? acpi_initialize_objects+0xed/0xf7
 [<c0cd34e3>] ? acpi_init+0x10f/0x28c
 [<c0401202>] ? do_one_initcall+0x112/0x160
 [<c0ca88bf>] ? kernel_init+0x10f/0x1a6
 [<c0ca8154>] ? rdinit_setup+0x22/0x22
 [<c0ca87b0>] ? start_kernel+0x39f/0x39f
 [<c09e1102>] ? kernel_thread_helper+0x6/0x10

2) And, also after printing
    "ACPI: EC: EC description table is found, configuring boot EC"

Fedora Rawhide's 3.4.0-0.rc2.git0.2.fc18.i686 loops printing:
BUG: soft lockup - CPU#0 stuck for 23s! [swapper/0:0]
Modules linked in:
Modules linked in:

Pid: 0, comm: swapper/0 Not tainted 3.4.0-0.rc2.git0.2.fc18.i686 #1 IBM        /       
EIP: 0060:[<c043e405>] EFLAGS: 00000206 CPU: 0
EIP is at __do_softirq+0x55/0x190
EAX: 00000000 EBX: 00000002 ECX: 00000000 EDX: 00000000
ESI: c0b52000 EDI: c043e3b0 EBP: f440bff8 ESP: f440bfc4
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
CR0: 8005003b CR2: ff996000 CR3: 00c74000 CR4: 000007d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Process swapper/0 (pid: 0, ti=f4408000 task=c0b5e020 task.ti=c0b52000)
Stack:
 bf00827e 28fffff7 ff18043a 04f7ffff ff00907f 00ddfff9 00000000 0000000a
 00000100 00000002 c0b53dd8 c0b52000 c043e3b0 c0b53de8 c0405246
Call Trace:
 [<c043e3b0>] ? local_bh_enable_ip+0x90/0x90
 <IRQ> 
 [<c043e79d>] ? irq_exit+0x9d/0xb0
 [<c0404ebb>] ? do_IRQ+0x4b/0xc0
 [<c0409588>] ? sched_clock+0x8/0x10
 [<c0467df0>] ? sched_clock_local+0xf0/0x1e0
 [<c093f170>] ? common_interrupt+0x30/0x38
 [<c065c6c3>] ? sha_transform+0xe03/0x1070
 [<c070abb6>] ? extract_buf+0x56/0x130
 [<c0460195>] ? __wake_up+0x45/0x60
 [<c070a9bd>] ? account+0xad/0x100
 [<c070b0c2>] ? extract_entropy+0x62/0x110
 [<c070b1dd>] ? get_random_bytes+0x6d/0x80
 [<c040b029>] ? cpu_idle+0x19/0xe0
 [<c0936bf3>] ? schedule+0x23/0x60
 [<c09186d5>] ? rest_init+0x5d/0x68
 [<c0bd0778>] ? start_kernel+0x367/0x36d
 [<c0bd0186>] ? loglevel+0x2b/0x2b
 [<c0bd0078>] ? i386_start_kernel+0x78/0x7d
Code: 00 01 00 00 64 a1 2c 57 c6 c0 89 5d f0 89 45 e4 c7 45 e8 0a 00 00 00 8d b4 26 00 00 00 00 64 c7 05 80 a1 c6 c0 00 00 00 00 fb 90 <8d> 74 26 00 bf 00 7a b5 c0 eb 08 83 c7 04 d1 6d f0 74 57 f6 45
Call Trace:
 [<c043e3b0>] ? local_bh_enable_ip+0x90/0x90
 <IRQ>  [<c043e79d>] ? irq_exit+0x9d/0xb0
 [<c0404ebb>] ? do_IRQ+0x4b/0xc0
 [<c0409588>] ? sched_clock+0x8/0x10
 [<c0467df0>] ? sched_clock_local+0xf0/0x1e0
 [<c093f170>] ? common_interrupt+0x30/0x38
 [<c065c6c3>] ? sha_transform+0xe03/0x1070
 [<c070abb6>] ? extract_buf+0x56/0x130
 [<c0460195>] ? __wake_up+0x45/0x60
 [<c070a9bd>] ? account+0xad/0x100
 [<c070b0c2>] ? extract_entropy+0x62/0x110
 [<c070b1dd>] ? get_random_bytes+0x6d/0x80
 [<c040b029>] ? cpu_idle+0x19/0xe0
 [<c0936bf3>] ? schedule+0x23/0x60
 [<c09186d5>] ? rest_init+0x5d/0x68
 [<c0bd0778>] ? start_kernel+0x367/0x36d
 [<c0bd0186>] ? loglevel+0x2b/0x2b
 [<c0bd0078>] ? i386_start_kernel+0x78/0x7d

3) Feel free to ask for more information.


Paul Bolle


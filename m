Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759016Ab2JSPe7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 11:34:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61622 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758993Ab2JSPe5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 11:34:57 -0400
Date: Fri, 19 Oct 2012 11:34:52 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, dmitry.torokhov@gmail.com
Subject: Re: weird use-after-free bug in module_put
Message-ID: <20121019153452.GB1532@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	dmitry.torokhov@gmail.com
References: <20121019144351.GA1532@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121019144351.GA1532@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 10:43:51AM -0400, Dave Jones wrote:
 > I've hit this twice in the last two days while fuzz testing.
 > (Both times on i686 only, my x86-64 tests aren't hitting it
 >  for some reason).
 > 
 > BUG: unable to handle kernel paging request at 6b6b6ce3
 > IP: [<c10b52fe>] module_put+0x1e/0x160
 > *pdpt = 0000000025a4b001 *pde = 0000000000000000 
 > Oops: 0000 [#1] PREEMPT SMP 
 > Modules linked in: fuse tun binfmt_misc nfnetlink nfc caif_socket caif phonet bluetooth rfkill can llc2 pppoe pppox ppp_generic slhc irda crc_ccitt rds af_key decnet rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 lockd sunrpc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 nf_conntrack_ipv4 ip6table_filter ip6_tables nf_defrag_ipv4 xt_state nf_conntrack kvm_intel kvm microcode serio_raw pcspkr i2c_i801 tg3 i2c_core shpchp raid0 ata_piix
 > Pid: 512, comm: acpid Not tainted 3.7.0-rc1+ #11 Dell Inc.                 Precision WorkStation 490    /0DT031
 > EIP: 0060:[<c10b52fe>] EFLAGS: 00010246 CPU: 1
 > EIP is at module_put+0x1e/0x160
 > EAX: 00000000 EBX: 6b6b6b6b ECX: 00000000 EDX: c118509c
 > ESI: 00000010 EDI: 6b6b6b6b EBP: e5ae9f44 ESP: e5ae9f34
 >  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
 > CR0: 8005003b CR2: 6b6b6ce3 CR3: 25a4a000 CR4: 000007f0
 > DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
 > DR6: ffff0ff0 DR7: 00000400
 > Process acpid (pid: 512, ti=e5ae8000 task=e6311680 task.ti=e5ae8000)
 > Stack:
 >  e6062140 6b6b6b6b 00000010 f01ce540 e5ae9f50 c118509c e6062140 e5ae9f80
 >  c11821ed 00000001 00000000 00000000 f2073410 ef256814 ef256814 e6062148
 >  00000000 e6311a60 e6311680 e5ae9f88 c118226d e5ae9f9c c1062f19 00000002
 > Call Trace:
 >  [<c118509c>] cdev_put+0x1c/0x20
 >  [<c11821ed>] __fput+0x20d/0x280
 >  [<c118226d>] ____fput+0xd/0x10
 >  [<c1062f19>] task_work_run+0x89/0xb0
 >  [<c1002c41>] do_notify_resume+0x61/0xa0
 >  [<c15d32f0>] work_notifysig+0x29/0x31
 > Code: 51 00 eb df 89 f6 8d bc 27 00 00 00 00 55 89 e5 57 56 53 83 ec 04 66 66 66 66 90 85 c0 89 c7 74 44 b8 01 00 00 00 e8 c2 14 52 00 <8b> 87 78 01 00 00 64 ff 40 04 8b 45 04 89 45 f0 66 66 66 66 90
 > 
 > 
 > It looks like the chardev went away under our feet.
 > How can this happen ?

Another clue.

I was building a kernel with PAGEALLOC_DEBUG set, but didn't reboot after the above.
During the build process, it spewed this..


BUG: scheduling while atomic: acpid/512/0x00000002
INFO: lockdep is turned off.
Modules linked in: fuse tun binfmt_misc nfnetlink nfc caif_socket caif phonet bluetooth rfkill can llc2 pppoe pppox ppp_generic slhc irda crc_ccitt rds af_key decnet rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 lockd sunrpc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 nf_conntrack_ipv4 ip6table_filter ip6_tables nf_defrag_ipv4 xt_state nf_conntrack kvm_intel kvm microcode serio_raw pcspkr i2c_i801 tg3 i2c_core shpchp raid0 ata_piix
Pid: 512, comm: acpid Tainted: G      D W    3.7.0-rc1+ #11
Call Trace:
 [<c15c77af>] __schedule_bug+0x65/0x75
 [<c15d1386>] __schedule+0x916/0x9a0
 [<c106372f>] ? __kernel_text_address+0x4f/0x70
 [<c1005a73>] ? print_context_stack+0x63/0xd0
 [<c1004b37>] ? dump_trace+0x97/0x100
 [<c15d1483>] schedule+0x23/0x60
 [<c15cec95>] schedule_timeout+0x145/0x2a0
 [<c12e3e1f>] ? debug_object_active_state+0x3f/0x100
 [<c15d08a0>] ? wait_for_common+0x30/0x120
 [<c15d08a0>] ? wait_for_common+0x30/0x120
 [<c15d2ea7>] ? _raw_spin_unlock_irq+0x27/0x50
 [<c10ab381>] ? trace_hardirqs_on_caller+0x11/0x170
 [<c15d094a>] wait_for_common+0xda/0x120
 [<c107b730>] ? try_to_wake_up+0x2b0/0x2b0
 [<c10e6a80>] ? kfree_call_rcu+0x20/0x20
 [<c15d0a67>] wait_for_completion+0x17/0x20
 [<c10632bc>] wait_rcu_gp+0x4c/0x70
 [<c10632e0>] ? wait_rcu_gp+0x70/0x70
 [<c1430101>] ? serio_show_modalias+0x11/0x50
 [<c143a513>] ? evdev_detach_client+0x33/0x50
 [<c10e5602>] synchronize_rcu+0x32/0x90
 [<c143a518>] evdev_detach_client+0x38/0x50
 [<c143a575>] evdev_release+0x45/0xa0
 [<c11820b8>] __fput+0xd8/0x280
 [<c118226d>] ____fput+0xd/0x10
 [<c1062f19>] task_work_run+0x89/0xb0
 [<c1045b4d>] do_exit+0x16d/0xa90
 [<c12db4be>] ? __const_udelay+0x1e/0x20
 [<c10635a4>] ? __rcu_read_unlock+0x54/0xa0
 [<c1042d89>] ? kmsg_dump+0x1a9/0x210
 [<c1042c01>] ? kmsg_dump+0x21/0x210
 [<c15d3f73>] oops_end+0x83/0xc0
 [<c15c68f5>] no_context+0x1b4/0x1bc
 [<c15c6a27>] __bad_area_nosemaphore+0x12a/0x132
 [<c107e82e>] ? local_clock+0x4e/0x60
 [<c15d61e4>] ? __do_page_fault+0x264/0x4d0
 [<c15d6450>] ? __do_page_fault+0x4d0/0x4d0
 [<c15d6450>] ? __do_page_fault+0x4d0/0x4d0
 [<c15c6a46>] bad_area_nosemaphore+0x17/0x19
 [<c15d6245>] __do_page_fault+0x2c5/0x4d0
 [<c15d2f25>] ? _raw_spin_unlock_irqrestore+0x55/0x70
 [<c15d6755>] ? sub_preempt_count+0x55/0xc0
 [<c15d2f0b>] ? _raw_spin_unlock_irqrestore+0x3b/0x70
 [<c15ca16c>] ? __slab_free+0x2b2/0x31b
 [<c127672f>] ? selinux_file_free_security+0x1f/0x30
 [<c15d3790>] ? error_code+0x68/0x74
 [<c15d6450>] ? __do_page_fault+0x4d0/0x4d0
 [<c15d6450>] ? __do_page_fault+0x4d0/0x4d0
 [<c15d645d>] do_page_fault+0xd/0x10
 [<c15d3794>] error_code+0x6c/0x74
 [<c118509c>] ? cdev_put+0x1c/0x20
 [<c10b52fe>] ? module_put+0x1e/0x160
 [<c118509c>] cdev_put+0x1c/0x20
 [<c11821ed>] __fput+0x20d/0x280
 [<c118226d>] ____fput+0xd/0x10
 [<c1062f19>] task_work_run+0x89/0xb0
 [<c1002c41>] do_notify_resume+0x61/0xa0
 [<c15d32f0>] work_notifysig+0x29/0x31


'evdev' caught my eye there.
shortly later...


 =============================================================================
 BUG kmalloc-1024 (Tainted: G      D W   ): Poison overwritten
 -----------------------------------------------------------------------------
 
 INFO: 0xef231630-0xef231630. First byte 0x6a instead of 0x6b
 INFO: Allocated in evdev_connect+0x4d/0x210 age=54802462 cpu=3 pid=41
 	__slab_alloc.constprop.71+0x4aa/0x4d6
 	kmem_cache_alloc_trace+0x1e4/0x230
 	evdev_connect+0x4d/0x210
 	input_attach_handler+0x175/0x1c0
 	input_register_device+0x40b/0x460
 	hidinput_connect+0x153a/0x2af0
 	hid_connect+0x2bc/0x320
 	hid_device_probe+0xd5/0x110
 	driver_probe_device+0x7f/0x370
 	__device_attach+0x41/0x50
 	bus_for_each_drv+0x3c/0x80
 	device_attach+0x96/0xb0
 	bus_probe_device+0x77/0xa0
 	device_add+0x5c6/0x6a0
 	hid_add_device+0x1d0/0x470
 	usbhid_probe+0x355/0x4a0
 INFO: Freed in evdev_free+0x2b/0x30 age=36397979 cpu=1 pid=512
 	__slab_free+0x43/0x31b
 	kfree+0x233/0x290
 	evdev_free+0x2b/0x30
 	device_release+0x31/0xa0
 	kobject_cleanup+0x78/0x1b0
 	kobject_put+0x25/0x60
 	put_device+0x14/0x20
 	evdev_release+0x75/0xa0
 	__fput+0xd8/0x280
 	____fput+0xd/0x10
 	task_work_run+0x89/0xb0
 	do_notify_resume+0x61/0xa0
 	work_notifysig+0x29/0x31
 INFO: Slab 0xf6d96600 objects=27 used=27 fp=0x  (null) flags=0x2804080
 INFO: Object 0xef2312c0 @offset=4800 fp=0xef236720
 
 Bytes b4 ef2312b0: c2 02 00 00 7c ea fd ff 5a 5a 5a 5a 5a 5a 5a 5a  ....|...ZZZZZZZZ
 Object ef2312c0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 Object ef2312d0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 Object ef2312e0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 Object ef2312f0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 Object ef231300: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 Object ef231310: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 Object ef231320: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 Object ef231330: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 Object ef231340: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 Object ef231350: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 Object ef231360: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 Object ef231370: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 Object ef231380: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 Object ef231390: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 Object ef2313a0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 Object ef2313b0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 Object ef2313c0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 Object ef2313d0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 Object ef2313e0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 Object ef2313f0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 Object ef231400: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 Object ef231410: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 Object ef231420: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 Object ef231430: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 Object ef231440: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 Object ef231450: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 Object ef231460: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 Object ef231470: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 Object ef231480: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 Object ef231490: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 Object ef2314a0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 Object ef2314b0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 Object ef2314c0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 Object ef2314d0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 Object ef2314e0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 Object ef2314f0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 Object ef231500: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 Object ef231510: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 Object ef231520: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 Object ef231530: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 Object ef231540: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 Object ef231550: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 Object ef231560: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 Object ef231570: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 Object ef231580: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 Object ef231590: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 Object ef2315a0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 Object ef2315b0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 Object ef2315c0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 Object ef2315d0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 Object ef2315e0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 Object ef2315f0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 Object ef231600: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 Object ef231610: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 Object ef231620: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 Object ef231630: 6a 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  jkkkkkkkkkkkkkkk
 Object ef231640: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 Object ef231650: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 Object ef231660: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 Object ef231670: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 Object ef231680: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 Object ef231690: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 Object ef2316a0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 Object ef2316b0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5  kkkkkkkkkkkkkkk.
 Redzone ef2316c0: bb bb bb bb                                      ....
 Padding ef231768: 5a 5a 5a 5a 5a 5a 5a 5a                          ZZZZZZZZ
 Pid: 29790, comm: gcc Tainted: G    B D W    3.7.0-rc1+ #11
 Call Trace:
  [<c116c4f2>] print_trailer+0xe2/0x130
  [<c116c653>] check_bytes_and_report+0xc3/0x100
  [<c116ce39>] check_object+0x1c9/0x210
  [<c15c9e16>] alloc_debug_processing+0x57/0xfb
  [<c15d6755>] ? sub_preempt_count+0x55/0xc0
  [<c15ca67f>] __slab_alloc.constprop.71+0x4aa/0x4d6
  [<c10cf0d8>] ? audit_alloc+0xe8/0x200
  [<c10cf0d8>] ? audit_alloc+0xe8/0x200
  [<c116f0c4>] kmem_cache_alloc_trace+0x1e4/0x230
  [<c10cf0d8>] ? audit_alloc+0xe8/0x200
  [<c10cf0d8>] audit_alloc+0xe8/0x200
  [<c103d6fc>] copy_process.part.28+0x56c/0x12f0
  [<c1150041>] ? handle_mm_fault+0x1d1/0x250
  [<c15d6450>] ? __do_page_fault+0x4d0/0x4d0
  [<c103e5a1>] do_fork+0xe1/0x470
  [<c119d53a>] ? __fd_install+0x5a/0xe0
  [<c15d3236>] ? restore_all+0xf/0xf
  [<c100b771>] sys_vfork+0x31/0x40
  [<c15d3203>] syscall_call+0x7/0xb
 FIX kmalloc-1024: Restoring 0xef231630-0xef231630=0x6b
 
 FIX kmalloc-1024: Marking all objects used

OHHHH... wait. Just before going to bed last night, I yanked out the keyboard
and plugged it into another box..

X shows..

 (II) config/udev: removing device DELL DELL USB Keyboard
 (II) evdev: DELL DELL USB Keyboard: Close
 (II) UnloadModule: "evdev"

That explains why I haven't seen this on other machines, they're all headless

Dmitry ?

	Dave

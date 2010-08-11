Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479Ab0HKXEA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 19:04:00 -0400
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:36738 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757165Ab0HKXD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:03:57 -0400
Subject: Re: [2.6.35] usb 2.0 em28xx  kernel panic general protection
 fault: 0000 [#1] SMP          RIP: 0010:[<ffffffffa004fbc5>] 
 [<ffffffffa004fbc5>] em28xx_isoc_copy_vbi+0x62e/0x812 [em28xx]
From: Andy Walls <awalls@md.metrocast.net>
To: Devin Heitmueller <dheitmueller@kernellabs.com>,
        Sander Eikelenboom <linux@eikelenboom.it>
Cc: mchehab@infradead.org, mrechberger@gmail.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-usb@vger.kernel.org
In-Reply-To: <61936849.20100811001257@eikelenboom.it>
References: <61936849.20100811001257@eikelenboom.it>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 Aug 2010 19:04:23 -0400
Message-ID: <1281567863.2419.52.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.0.10011,1.0.148,0.0.0000
 definitions=2010-08-11_11:2010-08-11,2010-08-11,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 phishscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1005130000 definitions=main-1008110202
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-11 at 00:12 +0200, Sander Eikelenboom wrote:
> Hi,
> 
> While trying to test try and report about some other bugs,  i ran into this kernel panic when trying to grab video from my usb 2.0 em28xx videgrabber connected to a usb 2.0 port.
> Complete serial log attachted.
> 
> 
> [  279.680018] general protection fault: 0000 [#1] SMP
> [  279.683901] last sysfs file: /sys/devices/pci0000:00/0000:00:12.2/usb1/1-5/i2c-0/name
> [  279.683901] CPU 5 
> [  279.683901] Modules linked in: xt_multiport ipt_REJECT xt_recent xt_limit xt_tcpudp powernow_k8 mperf xt_state ipt_MA
> SQUERADE ipt_LOG iptable_mangle iptable_filter iptable_nat ip_tables nf_nat x_tables nf_conntrack_ipv4 nf_conntrack nf_d
> efrag_ipv4 fuse hwmon_vid loop saa7115 snd_cmipci gameport snd_opl3_lib snd_hwdep snd_mpu401_uart snd_rawmidi em28xx v4l
> 2_common snd_hda_codec_atihdmi snd_hda_intel snd_hda_codec snd_pcm snd_seq_device videodev snd_timer snd v4l1_compat v4l
> 2_compat_ioctl32 videobuf_vmalloc videobuf_core psmouse tpm_tis joydev evdev tveeprom serio_raw shpchp edac_core i2c_pii
> x4 soundcore pcspkr i2c_core pci_hotplug wmi snd_page_alloc processor button sd_mod r8169 thermal fan thermal_sys [last 
> unloaded: scsi_wait_scan]
> [  279.683901] 
> [  279.683901] Pid: 0, comm: swapper Not tainted 2.6.352.6.35-vanilla-xhci-isoc+ #6 890FXA-GD70 (MS-7640)  /MS-7640
> [  279.683901] RIP: 0010:[<ffffffffa004fbc5>]  [<ffffffffa004fbc5>] em28xx_isoc_copy_vbi+0x62e/0x812 [em28xx]
> [  279.683901] RSP: 0018:ffff880001b43c68  EFLAGS: 00010082
> [  279.683901] RAX: dead000000200200 RBX: 0000000000000804 RCX: ffff880229625818
> [  279.683901] RDX: dead000000100100 RSI: 0000000000000003 RDI: ffff880229625868
                      ^^^^^^^^^^^^^^^^

List poison.

arch/x86/Kconfig:
                        config ILLEGAL_POINTER_VALUE
                               hex
                               default 0 if X86_32
                               default 0xdead000000000000 if X86_64
                        
include/linux/poison.h:
                        #ifdef CONFIG_ILLEGAL_POINTER_VALUE
                        # define POISON_POINTER_DELTA _AC(CONFIG_ILLEGAL_POINTER_VALUE, UL)
                        #else
                        # define POISON_POINTER_DELTA 0
                        #endif
                        
                        /*
                         * These are non-NULL pointers that will result in page faults
                         * under normal circumstances, used to verify that nobody uses
                         * non-initialized list entries.
                         */
                        #define LIST_POISON1  ((void *) 0x00100100 + POISON_POINTER_DELTA)
                        #define LIST_POISON2  ((void *) 0x00200200 + POISON_POINTER_DELTA)

So at least one uninitialized list entry was accessed.

> [  279.683901] RBP: ffff880001b43d08 R08: 0000000000000000 R09: 0000000000000804
> [  279.683901] R10: ffff880229597000 R11: 0000000000000000 R12: 0000000000000000
> [  279.683901] R13: ffff88022f158820 R14: ffff880229597000 R15: 0000000000000344
> [  279.683901] FS:  00007fa4bd3706e0(0000) GS:ffff880001b40000(0000) knlGS:0000000000000000
> [  279.683901] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  279.683901] CR2: 00007fa4bd35f000 CR3: 000000022a9ad000 CR4: 00000000000006e0
> [  279.683901] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  279.683901] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  279.683901] Process swapper (pid: 0, threadinfo ffff880237d4a000, task ffff880237d2f7a0)
> [  279.683901] Stack:
> [  279.683901]  ffffffff8103d7a3 ffff880001b43cb0 0000000000000082 ffff8802375e2188
> [  279.683901] <0> 0000000000000804 ffff880229625818 ffff880229597a40 ffff880229597a90
> [  279.683901] <0> ffffc90010b72000 0000000000000000 0000002237d20000 ffff880229597000
> [  279.683901] Call Trace:
> [  279.683901]  <IRQ> 
> [  279.683901]  [<ffffffff8103d7a3>] ? enqueue_task+0x77/0x87
> [  279.683901]  [<ffffffffa0053398>] em28xx_irq_callback+0x7e/0xfe [em28xx]
> [  279.683901]  [<ffffffff81359415>] usb_hcd_giveback_urb+0x84/0xb8
> [  279.683901]  [<ffffffff8136b51b>] ehci_urb_done+0xcf/0xe4
> [  279.683901]  [<ffffffff8136cd15>] ehci_work+0x504/0x8da
> [  279.683901]  [<ffffffff81370fda>] ehci_irq+0x19c/0x1ce
> [  279.683901]  [<ffffffff81358bd1>] usb_hcd_irq+0x3e/0x83
> [  279.683901]  [<ffffffff8108782c>] handle_IRQ_event+0x58/0x136
> [  279.683901]  [<ffffffff81089414>] handle_fasteoi_irq+0x92/0xd2
> [  279.683901]  [<ffffffff8100b241>] handle_irq+0x1f/0x2a
> [  279.683901]  [<ffffffff8100a884>] do_IRQ+0x5a/0xc1
> [  279.683901]  [<ffffffff8146c953>] ret_from_intr+0x0/0x11
> [  279.683901]  <EOI> 
> [  279.683901]  [<ffffffffa0044740>] ? acpi_idle_enter_simple+0x130/0x168 [processor]
> [  279.683901]  [<ffffffffa004473c>] ? acpi_idle_enter_simple+0x12c/0x168 [processor]
> [  279.683901]  [<ffffffff813ad822>] cpuidle_idle_call+0x9b/0xfd
> [  279.683901]  [<ffffffff81007868>] cpu_idle+0x51/0x84
> [  279.683901]  [<ffffffff81466d1b>] start_secondary+0x1c0/0x1c5
> [  279.683901] Code: 83 ef 80 e8 69 39 01 e1 48 8b 4d 88 49 c7 86 18 0b 00 00 00 00 00 00 be 03 00 00 00 48 8b 51 40 48 
> 8b 41 48 48 89 cf 48 83 c7 50 <48> 89 42 08 48 89 10 48 b8 00 01 10 00 00 00 ad de 48 89 41 40 
> [  279.683901] RIP  [<ffffffffa004fbc5>] em28xx_isoc_copy_vbi+0x62e/0x812 [em28xx]

         603:	83 ef 80             	sub    $0xffffffffffffff80,%edi  <--- &buf->vb.ts
         606:	e8 69 39 01 e1       	callq  0xffffffffe1013f74 <--- do_gettimeofday()
         60b:	48 8b 4d 88          	mov    -0x78(%rbp),%rcx <--- ?
         60f:	49 c7 86 18 0b 00 00 	movq   $0x0,0xb18(%r14) <--- dev->isoc_ctl.vbi_buf = NULL ?
         616:	00 00 00 00 
         61a:	be 03 00 00 00       	mov    $0x3,%esi        <--- move TASK_NORMAL into a register for the wake_up() macro
         61f:	48 8b 51 40          	mov    0x40(%rcx),%rdx  <--- Fetch the list pointers ?
         623:	48 8b 41 48          	mov    0x48(%rcx),%rax  <--- Fetch the list pointers ?
         627:	48 89 cf             	mov    %rcx,%rdi        <--- ?
         62a:	48 83 c7 50          	add    $0x50,%rdi       <--- ? 
         62e:	48 89 42 08          	mov    %rax,0x8(%rdx)   <----Ooops is here, dereferencing the poisoned list ptrs
         632:	48 89 10             	mov    %rdx,(%rax)      (These lines & a few preceeding look like list_del() inlined)
         635:	48 b8 00 01 10 00 00 	mov    $0xdead000000100100,%rax <--- Inlined list code, setting LIST_POISON1.
         63c:	00 ad de 
         63f:	48 89 41 40          	mov    %rax,0x40(%rcx)

It's hard to tell if the Ooops is happening in
em28xx-video.c:buffer_filled() or em28xx-video.c:vbi_buffer_filled() but
I'm pretty sure it's one of them.  em28xx_isoc_copy_vbi() is a long
function and the *buffer_filled() functions are inlined (what's up with
that?).  I'd need an objdump disassembly of your actual em28xx-video.o
binary to figure out which one conclusively.

But that's probably not needed.  There's an obvious uninitialized list
object being used in the em28xx driver with its interaction with
videobuf.  I'll bail out at this point and let someone else, who knows
more than I about both of those, audit the code. :P


Regards,
Andy

> [  279.683901]  RSP <ffff880001b43c68>
> [  279.683901] ---[ end trace 0f55a03076b067cf ]---
> [  279.683901] Kernel panic - not syncing: Fatal exception in interrupt
> [  279.683901] Pid: 0, comm: swapper Tainted: G      D     2.6.352.6.35-vanilla-xhci-isoc+ #6
> [  279.683901] Call Trace:
> [  279.683901]  <IRQ>  [<ffffffff81469cf9>] panic+0xb1/0x12a
> [  279.683901]  [<ffffffff81043b90>] ? kmsg_dump+0x126/0x140
> [  279.683901]  [<ffffffff8100c354>] oops_end+0x89/0x96
> [  279.683901]  [<ffffffff8100c534>] die+0x55/0x5e
> [  279.683901]  [<ffffffff8100a26f>] do_general_protection+0x130/0x138
> [  279.683901]  [<ffffffff8146cc05>] general_protection+0x25/0x30
> [  279.683901]  [<ffffffffa004fbc5>] ? em28xx_isoc_copy_vbi+0x62e/0x812 [em28xx]
> [  279.683901]  [<ffffffffa004fba2>] ? em28xx_isoc_copy_vbi+0x60b/0x812 [em28xx]
> [  279.683901]  [<ffffffff8103d7a3>] ? enqueue_task+0x77/0x87
> [  279.683901]  [<ffffffffa0053398>] em28xx_irq_callback+0x7e/0xfe [em28xx]
> [  279.683901]  [<ffffffff81359415>] usb_hcd_giveback_urb+0x84/0xb8
> [  279.683901]  [<ffffffff8136b51b>] ehci_urb_done+0xcf/0xe4
> [  279.683901]  [<ffffffff8136cd15>] ehci_work+0x504/0x8da
> [  279.683901]  [<ffffffff81370fda>] ehci_irq+0x19c/0x1ce
> [  279.683901]  [<ffffffff81358bd1>] usb_hcd_irq+0x3e/0x83
> [  279.683901]  [<ffffffff8108782c>] handle_IRQ_event+0x58/0x136
> [  279.683901]  [<ffffffff81089414>] handle_fasteoi_irq+0x92/0xd2
> [  279.683901]  [<ffffffff8100b241>] handle_irq+0x1f/0x2a
> [  279.683901]  [<ffffffff8100a884>] do_IRQ+0x5a/0xc1
> [  279.683901]  [<ffffffff8146c953>] ret_from_intr+0x0/0x11
> [  279.683901]  <EOI>  [<ffffffffa0044740>] ? acpi_idle_enter_simple+0x130/0x168 [processor]
> [  279.683901]  [<ffffffffa004473c>] ? acpi_idle_enter_simple+0x12c/0x168 [processor]
> [  279.683901]  [<ffffffff813ad822>] cpuidle_idle_call+0x9b/0xfd
> [  279.683901]  [<ffffffff81007868>] cpu_idle+0x51/0x84
> [  279.683901]  [<ffffffff81466d1b>] start_secondary+0x1c0/0x1c5
> 
> 
> 
> 
> 
> --
> Sander



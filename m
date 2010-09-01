Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488Ab0IAINR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 04:13:17 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34449 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab0IAINM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 04:13:12 -0400
Date: Wed, 1 Sep 2010 05:00:55 -0300
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-bluetooth@vger.kernel.org, marcel@holtmann.org, suraj@atheros.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH]Bluetooth:net/bluetooth/hci_core.c Fix system crash
 when creating a new device with bluetooth-applet
Message-ID: <20100901010821.GA28764@vigoh>
References: <1283274827-2770-1-git-send-email-justinmattock@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283274827-2770-1-git-send-email-justinmattock@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Justin,

* Justin P. Mattock <justinmattock@gmail.com> [2010-08-31 10:13:47 -0700]:

> When using bluetooth-applet adding my apple magic mouse I'm getting a total system freeze. 
> I used firescope to grab the crash data(below) The results of the bisect pointed to here:
> Bluetooth: Implemented HCI frame reassembly from RX stream
> commit:9981151086385eecc2febf4ba95a14593f834b3d
> 
> after looking through, and at the crash log, I couldn't help but notice something in there 
> with IRQ, then after looking at hci_h4.c /* H4 receiver States */ #58 I noticed
> #define H4_W4_PACKET_TYPE 0 is at zero as well as  #define STREAM_REASSEMBLY 0 
> so changing  STREAM_REASSEMBLY to a different number that isn't taken gets my machine to connect
> perfectly to my magic mouse. Please have a look and let me know if this is a good 
> solution and/or send me something else to test out.

Your patch seems very wrong, H4_W4_PACKET_TYPE and STREAM_REASSEMBLY
have nothing to do with each other, your commit message doesn't make
sense. Also the patch corrupts 'struct hci_dev'.
If you pay attention on the code flow you can check that
STREAM_REASSEMBLY is never used in the crash log you sent.

> 
> crash:
> 
> 
> <1>[ 1755.556472] BUG: unable to handle kernel paging request at ffff880224d0c548
> <1>[ 1755.556485] IP: [<ffffffffa0042bec>] hci_reassembly.part.13.constprop.18+0x23/0x1b5 [bluetooth]
> <4>[ 1755.556507] PGD 1609063 PUD 0
> <0>[ 1755.556515] Oops: 0000 [#1] SMP
> <0>[ 1755.556522] last sysfs file: /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0A:00/power_supply/BAT0/voltage_now
> <4>[ 1755.556530] CPU 0
> <4>[ 1755.556533] Modules linked in: usb_storage xfrm4_mode_transport xcbc rmd160 sha512_generic sco bnep xt_tcpudp ipt_LOG iptable_nat nf_nat xt_state nf_conntrack_ftp nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter ip_tables x_tables ath9k firewire_ohci ath9k_common firewire_core ath9k_hw battery ac ohci1394 evdev thermal ath sky2 joydev button snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer i2c_i801 snd soundcore snd_page_alloc video aes_x86_64 lzo lzo_compress tun kvm_intel ipcomp xfrm_ipcomp crypto_null sha256_generic cbc des_generic cast5 blowfish serpent camellia twofish_generic twofish_x86_64 twofish_common ctr ah4 esp4 authenc raw1394 ieee1394 uhci_hcd ehci_hcd hci_uart rfcomm btusb hidp l2cap bluetooth coretemp acpi_cpufreq processor mperf appletouch applesmc
> <4>[ 1755.556676]
> <4>[ 1755.556682] Pid: 0, comm: swapper Not tainted 2.6.36-rc3 #3 Mac-F42187C8/MacBookPro2,2
> <4>[ 1755.556688] RIP: 0010:[<ffffffffa0042bec>]  [<ffffffffa0042bec>] hci_reassembly.part.13.constprop.18+0x23/0x1b5 [bluetooth]
> <4>[ 1755.556705] RSP: 0018:ffff880001803ca8  EFLAGS: 00010092
> <4>[ 1755.556710] RAX: 000000003df64001 RBX: 0000000000000014 RCX: 0000000000000014
> <4>[ 1755.556716] RDX: ffff8800372018d8 RSI: 0000000000000002 RDI: ffff8800351ec240
> <4>[ 1755.556722] RBP: ffff880001803cf8 R08: ffff88003df64001 R09: ffff88000180f398
> <4>[ 1755.556728] R10: dead000000100100 R11: dead000000200200 R12: ffff8800351ec240
> <4>[ 1755.556733] R13: 0000000000000002 R14: 000000003df64001 R15: 0000000000000001
> <4>[ 1755.556740] FS:  0000000000000000(0000) GS:ffff880001800000(0000) knlGS:0000000000000000
> <4>[ 1755.556746] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> <4>[ 1755.556752] CR2: ffff880224d0c548 CR3: 0000000001608000 CR4: 00000000000006f0
> <4>[ 1755.556758] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> <4>[ 1755.556763] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> <4>[ 1755.556770] Process swapper (pid: 0, threadinfo ffffffff815f0000, task ffffffff81610020)
> <0>[ 1755.556774] Stack:
> <4>[ 1755.556778]  ffffea0000b9fdc8 ffff88003df64000 ffff8800372018d8 ffffffffa00a189f
> <4>[ 1755.556787] <0> ffff880001803d08 0000000000000014 0000000000000002 ffff8800372018d8
> <4>[ 1755.556797] <0> ffff8800351ec240 0000000000000001 ffff880001803d38 ffffffffa0042dc5
> <0>[ 1755.556809] Call Trace:
> <0>[ 1755.556813]  <IRQ>
> <4>[ 1755.556825]  [<ffffffffa00a189f>] ? uhci_free_urb_priv+0xa6/0xb3 [uhci_hcd]
> <4>[ 1755.556839]  [<ffffffffa0042dc5>] hci_recv_fragment+0x47/0x65 [bluetooth]
> <4>[ 1755.556851]  [<ffffffffa00705ee>] btusb_bulk_complete+0x56/0xd6 [btusb]
> <4>[ 1755.556862]  [<ffffffff812c1df9>] usb_hcd_giveback_urb+0x5d/0x8d
> <4>[ 1755.556873]  [<ffffffffa00a217b>] uhci_giveback_urb+0x11a/0x1a9 [uhci_hcd]
> <4>[ 1755.556884]  [<ffffffffa00a2a1a>] uhci_scan_schedule+0x544/0x84e [uhci_hcd]
> <4>[ 1755.556896]  [<ffffffffa00a3343>] uhci_irq+0xee/0x104 [uhci_hcd]
> <4>[ 1755.556903]  [<ffffffff812c1a08>] usb_hcd_irq+0x43/0x79
> <4>[ 1755.556913]  [<ffffffff81098c0b>] handle_IRQ_event+0x6e/0x14b
> <4>[ 1755.556922]  [<ffffffff8109aa52>] handle_fasteoi_irq+0x92/0xd2
> <4>[ 1755.556931]  [<ffffffff81029ab6>] handle_irq+0x86/0x8c
> <4>[ 1755.556938]  [<ffffffff8102975c>] do_IRQ+0x57/0xbe
> <4>[ 1755.556948]  [<ffffffff813ecb93>] ret_from_intr+0x0/0x11
> <0>[ 1755.556952]  <EOI>
> <4>[ 1755.556966]  [<ffffffffa0022e7b>] ? acpi_idle_enter_bm+0x252/0x28a [processor]
> <4>[ 1755.556979]  [<ffffffffa0022e74>] ? acpi_idle_enter_bm+0x24b/0x28a [processor]
> <4>[ 1755.556988]  [<ffffffff8130a5d5>] ? menu_select+0x16f/0x296
> <4>[ 1755.556996]  [<ffffffff81309501>] cpuidle_idle_call+0x9f/0x119
> <4>[ 1755.557004]  [<ffffffff81025db4>] cpu_idle+0x62/0xc5
> <4>[ 1755.557014]  [<ffffffff813d1bd4>] rest_init+0x68/0x6a
> <4>[ 1755.557024]  [<ffffffff8168cb7b>] start_kernel+0x365/0x370
> <4>[ 1755.557033]  [<ffffffff8168c2a6>] x86_64_start_reservations+0xad/0xb1
> <4>[ 1755.557042]  [<ffffffff8168c140>] ? early_idt_handler+0x0/0x71
> <4>[ 1755.557050]  [<ffffffff8168c3a3>] x86_64_start_kernel+0xf9/0x108
> <0>[ 1755.557055] Code: 41 5c 41 5d 41 5e c9 c3 55 49 63 c0 48 89 e5 41 57 41 56 45 89 c6 41 55 41 89 f5 41 54 49 89 fc 53 89 cb 48 83 ec 28 48 89 55 c0 <48> 8b 94 c7 00 03 00 00 48 85 d2 0f 85 61 01 00 00 41 8d 45 fe
> <1>[ 1755.557139] RIP  [<ffffffffa0042bec>] hci_reassembly.part.13.constprop.18+0x23/0x1b5 [bluetooth]
> <4>[ 1755.557154]  RSP <ffff880001803ca8>
> <0>[ 1755.557158] CR2: ffff880224d0c548
> <4>[ 1755.557164] ---[ end trace 6c64514f0ad01ea5 ]---
> <0>[ 1755.557169] Kernel panic - not syncing: Fatal exception in interrupt
> <4>[ 1755.557176] Pid: 0, comm: swapper Tainted: G      D     2.6.36-rc3 #3
> <4>[ 1755.557180] Call Trace:
> <4>[ 1755.557183]  <IRQ>  [<ffffffff813e47d2>] panic+0x8c/0x189
> <4>[ 1755.557199]  [<ffffffff813ed90c>] oops_end+0x87/0x94
> <4>[ 1755.557206]  [<ffffffff813e4737>] no_context+0x1f4/0x203
> <4>[ 1755.557216]  [<ffffffff8104487f>] __bad_area_nosemaphore+0x17f/0x1a2
> <4>[ 1755.557224]  [<ffffffff810448b0>] bad_area_nosemaphore+0xe/0x10
> <4>[ 1755.557233]  [<ffffffff813ef9fd>] do_page_fault+0x1ee/0x3c2
> <4>[ 1755.557243]  [<ffffffff810e4748>] ? check_object+0x151/0x202
> <4>[ 1755.557254]  [<ffffffffa00a336f>] ? uhci_alloc_td.isra.22+0x16/0x44 [uhci_hcd]
> <4>[ 1755.557265]  [<ffffffffa00a3b17>] ? uhci_submit_common.isra.24+0x233/0x2d3 [uhci_hcd]
> <4>[ 1755.557273]  [<ffffffff813ecde5>] page_fault+0x25/0x30
> <4>[ 1755.557287]  [<ffffffffa0042bec>] ? hci_reassembly.part.13.constprop.18+0x23/0x1b5 [bluetooth]
> <4>[ 1755.557298]  [<ffffffffa00a189f>] ? uhci_free_urb_priv+0xa6/0xb3 [uhci_hcd]
> <4>[ 1755.557311]  [<ffffffffa0042dc5>] hci_recv_fragment+0x47/0x65 [bluetooth]
> <4>[ 1755.557322]  [<ffffffffa00705ee>] btusb_bulk_complete+0x56/0xd6 [btusb]
> <4>[ 1755.557330]  [<ffffffff812c1df9>] usb_hcd_giveback_urb+0x5d/0x8d
> <4>[ 1755.557340]  [<ffffffffa00a217b>] uhci_giveback_urb+0x11a/0x1a9 [uhci_hcd]
> <4>[ 1755.557351]  [<ffffffffa00a2a1a>] uhci_scan_schedule+0x544/0x84e [uhci_hcd]
> <4>[ 1755.557362]  [<ffffffffa00a3343>] uhci_irq+0xee/0x104 [uhci_hcd]
> <4>[ 1755.557369]  [<ffffffff812c1a08>] usb_hcd_irq+0x43/0x79
> <4>[ 1755.557377]  [<ffffffff81098c0b>] handle_IRQ_event+0x6e/0x14b
> <4>[ 1755.557386]  [<ffffffff8109aa52>] handle_fasteoi_irq+0x92/0xd2
> <4>[ 1755.557393]  [<ffffffff81029ab6>] handle_irq+0x86/0x8c
> <4>[ 1755.557401]  [<ffffffff8102975c>] do_IRQ+0x57/0xbe
> <4>[ 1755.557408]  [<ffffffff813ecb93>] ret_from_intr+0x0/0x11
> <4>[ 1755.557413]  <EOI>  [<ffffffffa0022e7b>] ? acpi_idle_enter_bm+0x252/0x28a [processor]
> <4>[ 1755.557420]  [<ffffffffa0022e74>] ? acpi_idle_enter_bm+0x24b/0x28a [processor]
> <4>[ 1755.557420]  [<ffffffff8130a5d5>] ? menu_select+0x16f/0x296
> <4>[ 1755.557420]  [<ffffffff81309501>] cpuidle_idle_call+0x9f/0x119 > <4>[ 1755.557420]  [<ffffffff81025db4>] cpu_idle+0x62/0xc5 > <4>[ 1755.557420]  [<ffffffff813d1bd4>] rest_init+0x68/0x6a > <4>[ 1755.557420]  [<ffffffff8168cb7b>] start_kernel+0x365/0x370
> <4>[ 1755.557420]  [<ffffffff8168c2a6>] x86_64_start_reservations+0xad/0xb1
> <4>[ 1755.557420]  [<ffffffff8168c140>] ? early_idt_handler+0x0/0x71
> <4>[ 1755.557420]  [<ffffffff8168c3a3>] x86_64_start_kernel+0xf9/0x108

Suraj, do you have any idea on that?

-- 
Gustavo F. Padovan
ProFUSION embedded systems - http://profusion.mobi

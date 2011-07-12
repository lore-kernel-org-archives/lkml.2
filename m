Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189Ab1GLWf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 18:35:26 -0400
Received: from ppp118-208-123-30.lns20.bne4.internode.on.net ([118.208.123.30]:45066
	"EHLO mail.psychogeeks.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755623Ab1GLWfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 18:35:24 -0400
Message-ID: <4E1CCC26.4060506@psychogeeks.com>
Date: Wed, 13 Jul 2011 08:35:18 +1000
From: Chris W <lkml@psychogeeks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110620 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Jarod Wilson <jarod@wilsonet.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: Imon module Oops and kernel hang
References: <4E1B978C.2030407@psychogeeks.com> <20110712080309.d538fec9.rdunlap@xenotime.net> <7B814F02-408C-434F-B813-8630B60914DA@wilsonet.com>
In-Reply-To: <7B814F02-408C-434F-B813-8630B60914DA@wilsonet.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the reply.

On 13/07/11 05:55, Jarod Wilson wrote:
> 
> I don't see any rc_imon_pad or rc_imon_mce modules there, and I've not
> seen any panics with multiple imon devices here, so I'm guessing you
> didn't build either of the possible imon keymaps, and having a null
> keymap is interacting badly with rc_g_keycode_from_table.


There is only one imon device in this machine.

kepler ~ $ lsusb
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 003 Device 002: ID 0471:0815 Philips (or NXP) eHome Infrared Receiver
Bus 004 Device 002: ID 0dc6:2011 Precision Squared Technology Corp.
Bus 004 Device 003: ID 15c2:ffdc SoundGraph Inc. iMON PAD Remote Controller

The Philips device is a Microsoft branded MCE remote dongle.  The
Precision Squared device is the media control keypad on the case
(claimed by USB HID).


The rc keymap modules have been built (en masse as a result of
CONFIG_RC_MAP=m) but I am not explicitly loading them and they do not
get automatically loaded.

kepler ~ # ls -l /lib/modules/2.6.39.3/kernel/drivers/media/rc/keymaps/
total 352
--8<-- snip
-rw-r--r-- 1 root root 3018 Jul 12 09:34 rc-imon-mce.ko
-rw-r--r-- 1 root root 3146 Jul 12 09:34 rc-imon-pad.ko
--8<-- snip

The ir_*_decoder  and rc_winfast modules you can see loaded have been
automatically loaded during boot (udev I assume).  Loading the mceusb
module automatically loads the rc_rc6_mce keymap module.


I just tried this:

kepler ~ # rmmod rc_winfast ir_lirc_codec lirc_dev ir_sony_decoder
ir_jvc_decoder ir_rc6_decoder ir_rc5_decoder ir_nec_decoder

kepler ~ # modprobe -v rc-imon-pad
insmod /lib/modules/2.6.39.3/kernel/drivers/media/rc/keymaps/rc-imon-pad.ko

kepler ~ # modprobe -v rc-imon-mce
insmod /lib/modules/2.6.39.3/kernel/drivers/media/rc/keymaps/rc-imon-mce.ko

kepler ~ # lsmod
Module                  Size  Used by
rc_imon_mce             1161  0
rc_imon_pad             1289  0
asb100                  8772  0
hwmon_vid               2016  1 asb100
nvidia               7029915  24
cx22702                 4117  1
dvb_pll                 7836  3
mt352                   4637  2
cx88_dvb               19835  3
cx88_vp3054_i2c         1295  1 cx88_dvb
videobuf_dvb            3778  1 cx88_dvb
snd_via82xx            16242  0
cx8800                 23903  0
snd_ac97_codec         86082  1 snd_via82xx
cx8802                 11067  1 cx88_dvb
ac97_bus                 770  1 snd_ac97_codec
b44                    22202  0
cx88xx                 65916  3 cx88_dvb,cx8800,cx8802
snd_mpu401_uart         4679  1 snd_via82xx
ssb                    27969  1 b44
rc_core                12781  4 rc_imon_mce,rc_imon_pad,cx88xx
i2c_algo_bit            4248  2 cx88_vp3054_i2c,cx88xx
tveeprom               10545  1 cx88xx
snd_rawmidi            15080  1 snd_mpu401_uart
btcx_risc               2671  3 cx8800,cx8802,cx88xx
videobuf_dma_sg         6392  4 cx88_dvb,cx8800,cx8802,cx88xx
videobuf_core          13519  5
videobuf_dvb,cx8800,cx8802,cx88xx,videobuf_dma_sg
mii                     3271  1 b44
i2c_viapro              4523  0

kepler ~ # modprobe netconsole

kepler ~ # modprobe -v imon debug=1
insmod /lib/modules/2.6.39.3/kernel/drivers/media/rc/imon.ko debug=1

with the same crash (below).  (I have the tainting nvidia driver loaded
today but it was absent yesterday)

Perhaps there something else in the kernel config that must be on in
order to support the keymaps?

Any other thoughts?

Regards,
Chris



Jul 13 08:21:14 kepler BUG: unable to handle kernel
Jul 13 08:21:14 kepler NULL pointer dereference
Jul 13 08:21:14 kepler at 000000dc
Jul 13 08:21:14 kepler IP:
Jul 13 08:21:14 kepler [<f8f9d46e>] rc_g_keycode_from_table+0x1e/0xe0
[rc_core]
Jul 13 08:21:14 kepler *pde = 00000000
Jul 13 08:21:14 kepler
Jul 13 08:21:14 kepler Oops: 0000 [#1]
Jul 13 08:21:14 kepler PREEMPT
Jul 13 08:21:14 kepler
Jul 13 08:21:14 kepler last sysfs file:
/sys/devices/pci0000:00/0000:00:10.2/usb4/4-2/4-2:1.0/input/input6/capabilities/key
Jul 13 08:21:14 kepler Modules linked in:
Jul 13 08:21:14 kepler imon(+)
Jul 13 08:21:14 kepler netconsole
Jul 13 08:21:14 kepler rc_imon_mce
Jul 13 08:21:14 kepler rc_imon_pad
Jul 13 08:21:14 kepler asb100
Jul 13 08:21:14 kepler hwmon_vid
Jul 13 08:21:14 kepler nvidia(P)
Jul 13 08:21:14 kepler cx22702
Jul 13 08:21:14 kepler dvb_pll
Jul 13 08:21:14 kepler mt352
Jul 13 08:21:14 kepler cx88_dvb
Jul 13 08:21:14 kepler cx88_vp3054_i2c
Jul 13 08:21:14 kepler videobuf_dvb
Jul 13 08:21:14 kepler snd_via82xx
Jul 13 08:21:14 kepler cx8800
Jul 13 08:21:14 kepler snd_ac97_codec
Jul 13 08:21:14 kepler cx8802
Jul 13 08:21:14 kepler ac97_bus
Jul 13 08:21:14 kepler b44
Jul 13 08:21:14 kepler cx88xx
Jul 13 08:21:14 kepler snd_mpu401_uart
Jul 13 08:21:14 kepler ssb
Jul 13 08:21:14 kepler rc_core
Jul 13 08:21:14 kepler i2c_algo_bit
Jul 13 08:21:14 kepler tveeprom
Jul 13 08:21:14 kepler snd_rawmidi
Jul 13 08:21:14 kepler btcx_risc
Jul 13 08:21:14 kepler videobuf_dma_sg
Jul 13 08:21:14 kepler videobuf_core
Jul 13 08:21:14 kepler mii
Jul 13 08:21:14 kepler i2c_viapro
Jul 13 08:21:14 kepler [last unloaded: rc_imon_pad]
Jul 13 08:21:14 kepler
Jul 13 08:21:14 kepler
Jul 13 08:21:14 kepler Pid: 2513, comm: udevd Tainted: P
2.6.39.3 #2
Jul 13 08:21:14 kepler System Manufacturer System Name
Jul 13 08:21:14 kepler /A7V8X
Jul 13 08:21:14 kepler
Jul 13 08:21:14 kepler EIP: 0060:[<f8f9d46e>] EFLAGS: 00010002 CPU: 0
Jul 13 08:21:14 kepler EIP is at rc_g_keycode_from_table+0x1e/0xe0 [rc_core]
Jul 13 08:21:14 kepler EAX: 00000000 EBX: f39a2000 ECX: 00000008 EDX:
00000000
Jul 13 08:21:14 kepler ESI: 00000000 EDI: 00000000 EBP: f7007e48 ESP:
f7007e18
Jul 13 08:21:14 kepler DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Jul 13 08:21:14 kepler Process udevd (pid: 2513, ti=f7006000
task=f724fa60 task.ti=f5a68000)
Jul 13 08:21:14 kepler Stack:
Jul 13 08:21:14 kepler 00000001
Jul 13 08:21:14 kepler f7007e30
Jul 13 08:21:14 kepler c101e9ae
Jul 13 08:21:14 kepler f71f2280
Jul 13 08:21:14 kepler 00000001
Jul 13 08:21:14 kepler f71f2280
Jul 13 08:21:14 kepler 00000000
Jul 13 08:21:14 kepler 00000086
Jul 13 08:21:14 kepler
Jul 13 08:21:14 kepler 00000082
Jul 13 08:21:14 kepler f39a2000
Jul 13 08:21:14 kepler 00000000
Jul 13 08:21:14 kepler 00000000
Jul 13 08:21:14 kepler f7007e58
Jul 13 08:21:14 kepler f8e3759c
Jul 13 08:21:14 kepler f39a2000
Jul 13 08:21:14 kepler f39a2041
Jul 13 08:21:14 kepler
Jul 13 08:21:14 kepler f7007edc
Jul 13 08:21:14 kepler f8e376dc
Jul 13 08:21:14 kepler f7007e90
Jul 13 08:21:14 kepler f7007e80
Jul 13 08:21:14 kepler f68f8b20
Jul 13 08:21:14 kepler fbcde004
Jul 13 08:21:14 kepler f69e5008
Jul 13 08:21:14 kepler f69e5000
Jul 13 08:21:14 kepler
Jul 13 08:21:14 kepler Call Trace:
Jul 13 08:21:14 kepler [<c101e9ae>] ? T.889+0x2e/0x50
Jul 13 08:21:14 kepler [<f8e3759c>] imon_remote_key_lookup+0x1c/0x70 [imon]
Jul 13 08:21:14 kepler [<f8e376dc>] imon_incoming_packet+0x5c/0xe10 [imon]
Jul 13 08:21:14 kepler [<fbcde004>] ? _nv004358rm+0x24/0x70 [nvidia]
Jul 13 08:21:14 kepler [<fbcde030>] ? _nv004358rm+0x50/0x70 [nvidia]
Jul 13 08:21:14 kepler [<c124f353>] ? __ata_qc_complete+0x73/0x110
Jul 13 08:21:14 kepler [<f8e38563>] usb_rx_callback_intf0+0x63/0x70 [imon]
Jul 13 08:21:14 kepler [<c1272cc8>] usb_hcd_giveback_urb+0x48/0xb0
Jul 13 08:21:14 kepler [<c128a5ee>] uhci_giveback_urb+0x8e/0x220
Jul 13 08:21:14 kepler [<c128ac16>] uhci_scan_schedule+0x396/0x9a0
Jul 13 08:21:14 kepler [<c128cfd1>] uhci_irq+0x91/0x170
Jul 13 08:21:14 kepler [<c1271de1>] usb_hcd_irq+0x21/0x50
Jul 13 08:21:14 kepler [<c1051246>] handle_irq_event_percpu+0x36/0x140
Jul 13 08:21:14 kepler [<c1015f06>] ? __io_apic_modify_irq+0x76/0x90
Jul 13 08:21:14 kepler [<c1053000>] ? handle_edge_irq+0x100/0x100
Jul 13 08:21:14 kepler [<c1051382>] handle_irq_event+0x32/0x60
Jul 13 08:21:14 kepler [<c1053045>] handle_fasteoi_irq+0x45/0xc0
Jul 13 08:21:14 kepler <IRQ>
Jul 13 08:21:14 kepler
Jul 13 08:21:14 kepler [<c1003cea>] ? do_IRQ+0x3a/0xb0
Jul 13 08:21:14 kepler [<c13d8d69>] ? common_interrupt+0x29/0x30
Jul 13 08:21:14 kepler [<c10d517e>] ? sysfs_dentry_revalidate+0xbe/0xd0
Jul 13 08:21:14 kepler [<c1092ce9>] ? do_lookup+0x149/0x250
Jul 13 08:21:14 kepler [<c1093254>] ? link_path_walk+0x164/0x8c0
Jul 13 08:21:14 kepler [<c109547d>] ? path_init+0x2dd/0x3b0
Jul 13 08:21:14 kepler [<c109559c>] ? path_lookupat+0x4c/0x720
Jul 13 08:21:14 kepler [<c1076124>] ? handle_pte_fault+0x2a4/0x590
Jul 13 08:21:14 kepler [<c1095c95>] ? do_path_lookup+0x25/0x70
Jul 13 08:21:14 kepler [<c1096736>] ? user_path_at+0x36/0x70
Jul 13 08:21:14 kepler [<c108d221>] ? sys_readlinkat+0x31/0xa0
Jul 13 08:21:14 kepler [<c108d2b7>] ? sys_readlink+0x27/0x30
Jul 13 08:21:14 kepler [<c13d8850>] ? sysenter_do_call+0x12/0x26
Jul 13 08:21:14 kepler Code:
Jul 13 08:21:14 kepler ff
Jul 13 08:21:14 kepler ff
Jul 13 08:21:14 kepler 8d
Jul 13 08:21:14 kepler 74
Jul 13 08:21:14 kepler 26
Jul 13 08:21:14 kepler 00
Jul 13 08:21:14 kepler 8d
Jul 13 08:21:14 kepler bc
Jul 13 08:21:14 kepler 27
Jul 13 08:21:14 kepler 00
Jul 13 08:21:14 kepler 00
Jul 13 08:21:14 kepler 00
Jul 13 08:21:14 kepler 00
Jul 13 08:21:14 kepler 55
Jul 13 08:21:14 kepler 89
Jul 13 08:21:14 kepler e5
Jul 13 08:21:14 kepler 57
Jul 13 08:21:14 kepler 56
Jul 13 08:21:14 kepler 53
Jul 13 08:21:14 kepler 83
Jul 13 08:21:14 kepler ec
Jul 13 08:21:14 kepler 24
Jul 13 08:21:14 kepler 89
Jul 13 08:21:14 kepler 45
Jul 13 08:21:14 kepler e8
Jul 13 08:21:14 kepler 9c
Jul 13 08:21:14 kepler 8f
Jul 13 08:21:14 kepler 45
Jul 13 08:21:14 kepler ec
Jul 13 08:21:14 kepler fa
Jul 13 08:21:14 kepler 89
Jul 13 08:21:14 kepler e0
Jul 13 08:21:14 kepler 25
Jul 13 08:21:14 kepler 00
Jul 13 08:21:14 kepler e0
Jul 13 08:21:14 kepler ff
Jul 13 08:21:14 kepler ff
Jul 13 08:21:14 kepler ff
Jul 13 08:21:14 kepler 40
Jul 13 08:21:14 kepler 14
Jul 13 08:21:14 kepler 8b
Jul 13 08:21:14 kepler 45
Jul 13 08:21:14 kepler e8
Jul 13 08:21:14 kepler syslog-ng[2058]: Error processing log message: <8b>
Jul 13 08:21:14 kepler 80
Jul 13 08:21:14 kepler dc
Jul 13 08:21:14 kepler 00
Jul 13 08:21:14 kepler 00
Jul 13 08:21:14 kepler 00
Jul 13 08:21:14 kepler 89
Jul 13 08:21:14 kepler c3
Jul 13 08:21:14 kepler 89
Jul 13 08:21:14 kepler 45
Jul 13 08:21:14 kepler f0
Jul 13 08:21:14 kepler 4b
Jul 13 08:21:14 kepler 78
Jul 13 08:21:14 kepler 38
Jul 13 08:21:14 kepler 8b
Jul 13 08:21:14 kepler 45
Jul 13 08:21:14 kepler e8
Jul 13 08:21:14 kepler 31
Jul 13 08:21:14 kepler c9
Jul 13 08:21:14 kepler 8b
Jul 13 08:21:14 kepler b0
Jul 13 08:21:14 kepler
Jul 13 08:21:14 kepler EIP: [<f8f9d46e>]
Jul 13 08:21:14 kepler rc_g_keycode_from_table+0x1e/0xe0 [rc_core]
Jul 13 08:21:14 kepler SS:ESP 0068:f7007e18
Jul 13 08:21:14 kepler CR2: 00000000000000dc
Jul 13 08:21:14 kepler ---[ end trace 05456f0fc2588a75 ]---
Jul 13 08:21:14 kepler Kernel panic - not syncing: Fatal exception in
interrupt
Jul 13 08:21:14 kepler Pid: 2513, comm: udevd Tainted: P      D
2.6.39.3 #2
Jul 13 08:21:14 kepler Call Trace:
Jul 13 08:21:14 kepler [<c13d6279>] panic+0x61/0x145
Jul 13 08:21:14 kepler [<c1004ff0>] oops_end+0x80/0x80
Jul 13 08:21:14 kepler [<c101906e>] no_context+0xbe/0x150
Jul 13 08:21:14 kepler [<c101918f>] __bad_area_nosemaphore+0x8f/0x130
Jul 13 08:21:14 kepler [<c1019242>] bad_area_nosemaphore+0x12/0x20
Jul 13 08:21:14 kepler [<c10195fb>] do_page_fault+0x24b/0x410
Jul 13 08:21:14 kepler [<c128bdf6>] ? uhci_alloc_td+0x16/0x40
Jul 13 08:21:14 kepler [<c10400e5>] ? T.312+0x15/0x1b0
Jul 13 08:21:14 kepler [<c10193b0>] ? mm_fault_error+0xe0/0xe0
Jul 13 08:21:14 kepler [<c13d85f4>] error_code+0x58/0x60
Jul 13 08:21:14 kepler [<c10193b0>] ? mm_fault_error+0xe0/0xe0
Jul 13 08:21:14 kepler [<f8f9d46e>] ? rc_g_keycode_from_table+0x1e/0xe0
[rc_core]
Jul 13 08:21:14 kepler [<c101e9ae>] ? T.889+0x2e/0x50
Jul 13 08:21:14 kepler [<f8e3759c>] imon_remote_key_lookup+0x1c/0x70 [imon]
Jul 13 08:21:14 kepler [<f8e376dc>] imon_incoming_packet+0x5c/0xe10 [imon]
Jul 13 08:21:14 kepler [<fbcde004>] ? _nv004358rm+0x24/0x70 [nvidia]
Jul 13 08:21:14 kepler [<fbcde030>] ? _nv004358rm+0x50/0x70 [nvidia]
Jul 13 08:21:14 kepler [<c124f353>] ? __ata_qc_complete+0x73/0x110
Jul 13 08:21:14 kepler [<f8e38563>] usb_rx_callback_intf0+0x63/0x70 [imon]
Jul 13 08:21:14 kepler [<c1272cc8>] usb_hcd_giveback_urb+0x48/0xb0
Jul 13 08:21:14 kepler [<c128a5ee>] uhci_giveback_urb+0x8e/0x220
Jul 13 08:21:14 kepler [<c128ac16>] uhci_scan_schedule+0x396/0x9a0
Jul 13 08:21:14 kepler [<c128cfd1>] uhci_irq+0x91/0x170
Jul 13 08:21:14 kepler [<c1271de1>] usb_hcd_irq+0x21/0x50
Jul 13 08:21:14 kepler [<c1051246>] handle_irq_event_percpu+0x36/0x140
Jul 13 08:21:14 kepler [<c1015f06>] ? __io_apic_modify_irq+0x76/0x90
Jul 13 08:21:14 kepler [<c1053000>] ? handle_edge_irq+0x100/0x100
Jul 13 08:21:14 kepler [<c1051382>] handle_irq_event+0x32/0x60
Jul 13 08:21:14 kepler [<c1053045>] handle_fasteoi_irq+0x45/0xc0
Jul 13 08:21:14 kepler <IRQ>
Jul 13 08:21:14 kepler [<c1003cea>] ? do_IRQ+0x3a/0xb0
Jul 13 08:21:14 kepler [<c13d8d69>] ? common_interrupt+0x29/0x30
Jul 13 08:21:14 kepler [<c10d517e>] ? sysfs_dentry_revalidate+0xbe/0xd0
Jul 13 08:21:14 kepler [<c1092ce9>] ? do_lookup+0x149/0x250
Jul 13 08:21:14 kepler [<c1093254>] ? link_path_walk+0x164/0x8c0
Jul 13 08:21:14 kepler [<c109547d>] ? path_init+0x2dd/0x3b0
Jul 13 08:21:14 kepler [<c109559c>] ? path_lookupat+0x4c/0x720
Jul 13 08:21:14 kepler [<c1076124>] ? handle_pte_fault+0x2a4/0x590
Jul 13 08:21:14 kepler [<c1095c95>] ? do_path_lookup+0x25/0x70
Jul 13 08:21:14 kepler [<c1096736>
Jul 13 08:21:14 kepler ] ? user_path_at+0x36/0x70
Jul 13 08:21:14 kepler [<c108d221>] ? sys_readlinkat+0x31/0xa0
Jul 13 08:21:14 kepler [<c108d2b7>] ? sys_readlink+0x27/0x30
Jul 13 08:21:14 kepler [<c13d8850>] ? sysenter_do_call+0x12/0x26



-- 
Chris Williams
Brisbane, Australia

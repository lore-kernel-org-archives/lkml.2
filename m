Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672Ab0JOIDn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 04:03:43 -0400
Received: from gw3.lbox.cz ([62.245.111.133]:52350 "EHLO pcnci.linuxbox.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752852Ab0JOIDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 04:03:39 -0400
X-Greylist: delayed 3207 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Oct 2010 04:03:38 EDT
Date: Fri, 15 Oct 2010 09:10:08 +0200
From: Nikola Ciprich <extmaillist@linuxbox.cz>
To: Linux kernel list <linux-kernel@vger.kernel.org>,
        linux-net maillist <linux-net@vger.kernel.org>
Cc: nikola.ciprich@linuxbox.cz
Subject: 2.6.36-rc7-git2 - panic/GPF: e1000e/vlans?
Message-ID: <20101015071008.GA8714@pcnci.linuxbox.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

when I try to boot 2.6.36-rc7-git2 on one of my machines, it crashes while setting up the network.
The setup is quite complex, with bonding, lots of vlans and 3 intel adapters (system is quad x86_64)

snip of lspci:
06:00.0 Ethernet controller: Intel Corporation 80003ES2LAN Gigabit Ethernet Controller (Copper) (rev 01)
06:00.1 Ethernet controller: Intel Corporation 80003ES2LAN Gigabit Ethernet Controller (Copper) (rev 01)
09:00.0 Ethernet controller: Intel Corporation 82574L Gigabit Network Connection

/proc/interrupts (this is from 2.6.35 though):
[root@vbox1 ~]# cat /proc/interrupts
            CPU0       CPU1       CPU2       CPU3	CPU4	   CPU5       CPU6	 CPU7
   0:        110         37         35         40         32         32         21         21   IO-APIC-edge	  timer
   1:          1          1          2          1          1          1          2          1   IO-APIC-edge	    i8042
   3:          1          1          2          3          2          2          2          2   IO-APIC-edge	      serial
   7:          0          0          0          0          0          0          0          0   IO-APIC-edge	        parport0
   9:          0          0          0          0          0          0          0          0   IO-APIC-fasteoi   acpi
  12:         13         12         13         13         13         13         13         13   IO-APIC-edge	    i8042
  14:          0          0          0          0          0          0          0          0   IO-APIC-edge      ata_piix
  15:          0          0          0          0          0          0          0          0   IO-APIC-edge	    ata_piix
  16:     682921     685346     693461     694947     676981     675139     701777     701287   IO-APIC-fasteoi   aic94xx
  17:          5          4          2     3          3          3          4          2   IO-APIC-fasteoi   ehci_hcd:usb1, uhci_hcd:usb2
  18:          0          0          0          0          0          0          0          0   IO-APIC-fasteoi   uhci_hcd:usb4
  19:     997780     999181     999953     997339    1000298    1000151    1000998     999476   IO-APIC-fasteoi   ahci, uhci_hcd:usb3
  70:     369494     369442     369429     369546     369246     369180     368920     369440   PCI-MSI-edge	    eth0
  71:          1          0          2          0          1          0          0          1   PCI-MSI-edge	      ioat-msi
  72:    6582932    6581874    6600038    6599808    6610844    6615320    6577533    6575521   PCI-MSI-edge      eth1
  73:    4640350    4642969    4620265    4618102    4658361    4656713    4621047    4622633   PCI-MSI-edge	    eth2-rx-0
  74:    4825916    4820566    4816223    4819625    4783628    4782868    4829161    4831033   PCI-MSI-edge      eth2-tx-0
  75:          1          0          1          0          1          0          0          0   PCI-MSI-edge	    eth2
 NMI:          0          0          0          0          0          0          0          0   Non-maskable interrupts
 LOC:   26193128   26202524   23438305   21050728   20675131   21073869   19116842   20390479   Local timer interrupts
 SPU:          0          0          0          0          0          0          0          0   Spurious interrupts
 PMI:          0          0          0          0          0          0          0          0   Performance monitoring interrupts
 PND:          0          0          0    	0          0          0          0          0   Performance pending work
 RES:     683619     704633     770437     844562     631756     661455     712375     693839   Rescheduling interrupts
 CAL:    3911641    3885148    1508737    1570661    3805584    3932046    1387438    1430719   Function call interrupts
 TLB:     782332     851609    1030107     976888     745355     866368     874263     964798   TLB shootdowns
 TRM:          0          0          0          0          0          0          0          0   Thermal event interrupts
 THR:          0          0          0          0          0          0          0          0   Threshold APIC interrupts
 MCE:          0          0          0          0          0          0          0          0   Machine check exceptions
 MCP:        252        252        252        252        252        252        252        252   Machine check polls
 ERR:          0
 MIS:          0

here's the backtrace:


[   24.893702] general protection fault: 0000 [#1] PREEMPT SMP
[   24.897668] last sysfs file: /sys/devices/virtual/net/bond0/broadcast
[   24.897668] CPU 2
[   24.897668] Modules linked in: bridge stp llc 8021q bonding ipv6 ext4 jbd2 crc32 crc16 dm_mirror dm_region_hash dm_log dm_mod video backlight output sbs sbshc fan battery ac kvm_intel kvm joydev ppdev
+piix pata_acpi ide_pci_generic ide_core tpm_tis tpm tpm_bios ata_piix i5k_amb hwmon pcspkr parport_pc parport i2c_i801 i2c_core ata_generic rng_core usbhid e1000e iTCO_wdt sg container i5000_edac ioatdma
+dca edac_core shpchp thermal processor pci_hotplug thermal_sys button aic94xx libsas scsi_transport_sas sd_mod crc_t10dif raid1 ext3 jbd uhci_hcd ohci_hcd ehci_hcd ahci libahci libata scsi_mod [last
+unloaded: scsi_wait_scan]
[   24.897668]
[   24.897668] Pid: 0, comm: kworker/0:1 Not tainted 2.6.36lb.00_01_PRE07 #1 X7DB8/X7DB8
[   24.897668] RIP: 0010:[<ffffffff81343044>]  [<ffffffff81343044>] vlan_hwaccel_do_receive+0x74/0xf0
[   24.897668] RSP: 0018:ffff880001a83c30  EFLAGS: 00010287
[   24.897668] RAX: 0000000000000002 RBX: ffff88041c7ac790 RCX: ffff88042fdb6000
[   24.897668] RDX: ffff10041e22c790 RSI: ffff88041b162100 RDI: ffff88041b162100
[   24.897668] RBP: ffff880001a83c50 R08: 0000000000000000 R09: ffff88041b162100
[   24.897668] R10: 0000000000000000 R11: 0000000bba250000 R12: ffff88041b162100
[   24.897668] R13: ffff88041c7ac000 R14: 0000000000000000 R15: ffff88041c7ac6c0
[   24.897668] FS:  0000000000000000(0000) GS:ffff880001a80000(0000) knlGS:0000000000000000
[   24.897668] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   24.897668] CR2: 00007fd9a60830b0 CR3: 0000000001655000 CR4: 00000000000006e0
[   24.897668] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   24.897668] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   24.897668] Process kworker/0:1 (pid: 0, threadinfo ffff88042fcda000, task ffff88042fccdcc0)
[   24.897668] Stack:
[   24.897668]  ffff880001a83c60 0000000000000001 000000000000000e ffff88041b162100
[   24.897668] <0> ffff880001a83ca0 ffffffff812b9402 ffff880001a83cb0 ffffffff812b92cf
[   24.897668] <0> 0000000000000000 ffff88041b162100 000000000000000e ffff88041ff8b680
[   24.897668] Call Trace:
[   24.897668]  <IRQ>
[   24.897668]  [<ffffffff812b9402>] __netif_receive_skb+0x472/0x530
[   24.897668]  [<ffffffff812b92cf>] ? __netif_receive_skb+0x33f/0x530
[   24.897668]  [<ffffffff812ba2fc>] netif_receive_skb+0xbc/0xe0
[   24.897668]  [<ffffffff812ba3ec>] napi_skb_finish+0x3c/0x50
[   24.897668]  [<ffffffff81343173>] vlan_gro_receive+0xa3/0xb0
[   24.897668]  [<ffffffffa019ae34>] e1000_receive_skb+0x84/0x90 [e1000e]
[   24.897668]  [<ffffffffa019f4a7>] e1000_clean_rx_irq+0x287/0x360 [e1000e]
[   24.897668]  [<ffffffffa019e5c5>] e1000_clean+0x85/0x2b0 [e1000e]
[   24.897668]  [<ffffffff812bd71e>] net_rx_action+0x12e/0x220
[   24.897668]  [<ffffffff8104f58a>] __do_softirq+0xca/0x230
[   24.897668]  [<ffffffff810032cc>] call_softirq+0x1c/0x30
[   24.897668]  [<ffffffff8100530a>] do_softirq+0x4a/0x80
[   24.897668]  [<ffffffff8104f439>] irq_exit+0x89/0xa0
[   24.897668]  [<ffffffff81004867>] do_IRQ+0x77/0xf0
[   24.897668]  [<ffffffff8135db93>] ret_from_intr+0x0/0xa
[   24.897668]  <EOI>
[   24.897668]  [<ffffffff8100b723>] ? mwait_idle+0x83/0x100
[   24.897668]  [<ffffffff8100b6d2>] ? mwait_idle+0x32/0x100
[   24.897668]  [<ffffffff81001283>] cpu_idle+0x53/0xf0
[   24.897668]  [<ffffffff81353e7a>] start_secondary+0x17a/0x1e0
[   24.897668] Code: 83 04 66 41 c7 84 24 bc 00 00 00 00 00 41 89 44 24 78 48 8b 9b d8 00 00 00 e8 59 e4 e8 ff 89 c0 48 89 da 48 03 14 c5 60 14 6a 81 <48> 83 02 01 41 8b 44 24 68 48 01 42 08 41 0f b6 44 24
+7d 83 e0
[   24.897668] RIP  [<ffffffff81343044>] vlan_hwaccel_do_receive+0x74/0xf0
[   24.897668]  RSP <ffff880001a83c30>
[   24.897668] ---[ end trace 853b21a733cfcf20 ]---
[   24.897668] Kernel panic - not syncing: Fatal exception in interrupt
[   24.897668] Pid: 0, comm: kworker/0:1 Tainted: G	    D     2.6.36lb.00_01_PRE07 #1
[   24.897668] Call Trace:
[   24.897668]  <IRQ>  [<ffffffff81048d24>] panic+0xc4/0x1e0
[   24.897668]  [<ffffffff8135d55d>] ? _raw_spin_unlock_irqrestore+0x1d/0x50
[   24.897668]  [<ffffffff8104a790>] ? kmsg_dump+0x110/0x180
[   24.897668]  [<ffffffff8100692f>] oops_end+0x9f/0xb0
[   24.897668]  [<ffffffff81006b36>] die+0x56/0x90
[   24.897668]  [<ffffffff81004312>] do_general_protection+0x152/0x160
[   24.897668]  [<ffffffff8135dd9f>] general_protection+0x1f/0x30
[   24.897668]  [<ffffffff81343044>] ? vlan_hwaccel_do_receive+0x74/0xf0
[   24.897668]  [<ffffffff812b9402>] __netif_receive_skb+0x472/0x530
[   24.897668]  [<ffffffff812b92cf>] ? __netif_receive_skb+0x33f/0x530
[   24.897668]  [<ffffffff812ba2fc>] netif_receive_skb+0xbc/0xe0
[   24.897668]  [<ffffffff812ba3ec>] napi_skb_finish+0x3c/0x50
[   24.897668]  [<ffffffff81343173>] vlan_gro_receive+0xa3/0xb0
[   24.897668]  [<ffffffffa019ae34>] e1000_receive_skb+0x84/0x90 [e1000e]
[   24.897668]  [<ffffffffa019f4a7>] e1000_clean_rx_irq+0x287/0x360 [e1000e]
[   24.897668]  [<ffffffffa019e5c5>] e1000_clean+0x85/0x2b0 [e1000e]
[   24.897668]  [<ffffffff812bd71e>] net_rx_action+0x12e/0x220
[   24.897668]  [<ffffffff8104f58a>] __do_softirq+0xca/0x230
[   24.897668]  [<ffffffff810032cc>] call_softirq+0x1c/0x30
[   24.897668]  [<ffffffff8100530a>] do_softirq+0x4a/0x80
[   24.897668]  [<ffffffff8104f439>] irq_exit+0x89/0xa0
[   24.897668]  [<ffffffff81004867>] do_IRQ+0x77/0xf0
[   24.897668]  [<ffffffff8135db93>] ret_from_intr+0x0/0xa
[   24.897668]  <EOI>  [<ffffffff8100b723>] ? mwait_idle+0x83/0x100
[   24.897668]  [<ffffffff8100b6d2>] ? mwait_idle+0x32/0x100
[   24.897668]  [<ffffffff81001283>] cpu_idle+0x53/0xf0
[   24.897668]  [<ffffffff81353e7a>] start_secondary+0x17a/0x1e0

The problem is 100% reproducible (it always crashes), so if anybody would like to try some fix,
I'll be happy to test it.

If I could provide more information, please let me know.

with best regards

nik

-- 
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 01 Ostrava

tel.:   +420 596 603 142
fax:    +420 596 621 273
mobil:  +420 777 093 799
www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab0ESPMq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 11:12:46 -0400
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:55406 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752951Ab0ESPMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 11:12:42 -0400
Message-ID: <4BF40014.30303@ntlworld.com>
Date: Wed, 19 May 2010 16:13:24 +0100
From: Graham Ramsey <ramsey.graham@ntlworld.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Shredder/3.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: x86/pci Oops with CONFIG_SND_HDA_INTEL
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.1 cv=1ggfb5FlKZQUfF3vzm9UBYZ2uTfLsbs/8dSljwg5+mE= c=1 sm=0 a=KdWteQuKHX4A:10 a=ADBQPqJMlbwA:10 a=8nJEP1OIZ-IA:10 a=zFxLgs37czE3F_oB2R0A:9 a=taOivcj8Afd4S3dElKcA:7 a=A4gHc6UmdBVzaKJfI3BwVn7ZeO8A:4 a=wPNLvfGTeEIA:10 a=fhhOszP4gbyALReq:21 a=KUSU_j2aCufBDmzV:21 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I am on x86_64 with latest (v2.6.34) kernel. When i set 
CONFIG_SND_HDA_INTEL=Y It hangs at an early stage in boot with kernel oops.
When i use CONFIG_SND_HDA_INTEL=M the machine will boot, and i get the 
dmesg (below).

I have bisected down to one commit that causes the problem:

   commit 3e3da00c01d050307e753fb7b3e84aefc16da0d0
   x86/pci: AMD one chain system to use pci read out res
   ...

I have reverted this in my current kernel (v3.6.34) and it seems to work 
OK like this.
Is it possible to get this commit either removed, or amended to work 
with SND_HDA_INTEL ?


OOPS from dmesg
---------------
Pid: 1714, comm: modprobe Not tainted 2.6.34 #3 
ALiveSATA2-GLAN/ALiveSATA2-GLAN
RIP: 0010:[<ffffffffa0018d11>]  [<ffffffffa0018d11>] 
azx_probe+0x3a2/0xa6a [snd_hda_intel]
RSP: 0018:ffff88007e80bd18  EFLAGS: 00010282
RAX: ffffc90000078000 RBX: ffff88007d724c00 RCX: 000000000000000d
RDX: 0000000000000000 RSI: 0000000000000246 RDI: ffffffff813f2f24
RBP: ffff88007f9da088 R08: 0000000000000000 R09: 0000000000000040
R10: 0000000000000008 R11: 000000000000000a R12: ffff88007f9da000
R13: ffff88007d726400 R14: 0000000000000000 R15: 0000000000000000
FS:  00007f1a13aa6700(0000) GS:ffff880001700000(0000) 
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffc90000078000 CR3: 0000000037ad1000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process modprobe (pid: 1714, threadinfo ffff88007e80a000, task 
ffff88007d0ed080)
Stack:
  0000000000000292 0000000000000005 ffff88007f9c62c8 ffff88007d60e948
<0> ffff88007d60e948 ffffffff810c5d3f ffff88007e80bd64 ffff88007e80bdb8
<0> ffff88007f9033f0 ffff88007d60e948 ffff88007e80bdb8 ffff88007e80bdb8
Call Trace:
  [<ffffffff810c5d3f>] ? sysfs_addrm_finish+0x29/0xb4
  [<ffffffff8116e849>] ? local_pci_probe+0x12/0x19
  [<ffffffff8116ea65>] ? pci_device_probe+0x60/0x8e
  [<ffffffff811ac286>] ? driver_sysfs_add+0x42/0x69
  [<ffffffff811ac4cd>] ? driver_probe_device+0x8e/0x10e
  [<ffffffff811ac59c>] ? __driver_attach+0x4f/0x6f
  [<ffffffff811ac54d>] ? __driver_attach+0x0/0x6f
  [<ffffffff811ab8cc>] ? bus_for_each_dev+0x47/0x72
  [<ffffffff811abede>] ? bus_add_driver+0xa2/0x1f2
  [<ffffffff811ac7bc>] ? driver_register+0x8d/0xf5
  [<ffffffff8116ecb0>] ? __pci_register_driver+0x50/0xbb
  [<ffffffffa001e000>] ? alsa_card_azx_init+0x0/0x22 [snd_hda_intel]
  [<ffffffff810002d0>] ? do_one_initcall+0x4f/0x13f
  [<ffffffff8104aa56>] ? sys_init_module+0xc5/0x2cf
  [<ffffffff81001eab>] ? system_call_fastpath+0x16/0x1b
Code: 83 f0 01 00 00 31 f6 48 89 df e8 9f e4 ff ff 85 c0 0f 88 f5 03 00 
00 4c 89 e7 e8 e2 45 15 e1 8b 7b 40 e8 70 41 03 e1 48 8b 43 38 <66> 44 
8b 38 8b 43 14 83 e8 03 83 f8 01 77 2c 31 d2 be 85 43 00
RIP  [<ffffffffa0018d11>] azx_probe+0x3a2/0xa6a [snd_hda_intel]
  RSP <ffff88007e80bd18>
CR2: ffffc90000078000
---[ end trace 1814cadd98ff217d ]---



Patch for revert of commit
-------------------------------------

--- a/arch/x86/pci/amd_bus.c
+++ b/arch/x86/pci/amd_bus.c
@@ -83,12 +83,11 @@ static int __init early_fill_mp_bus_info(void)
         struct range range[RANGE_NUM];
         u64 val;
         u32 address;
-       bool found;

         if (!early_pci_allowed())
                 return -1;

-       found = false;
+       found_all_numa_early = 0;
         for (i = 0; i < ARRAY_SIZE(pci_probes); i++) {
                 u32 id;
                 u16 device;
@@ -102,12 +101,12 @@ static int __init early_fill_mp_bus_info(void)
                 device = (id>>16) & 0xffff;
                 if (pci_probes[i].vendor == vendor &&
                     pci_probes[i].device == device) {
-                       found = true;
+                       found_all_numa_early = 1;
                         break;
                 }
         }

-       if (!found)
+       if (!found_all_numa_early)
                 return 0;

         pci_root_num = 0;
diff --git a/arch/x86/pci/bus_numa.c b/arch/x86/pci/bus_numa.c
index 64a1228..894a17e 100644
--- a/arch/x86/pci/bus_numa.c
+++ b/arch/x86/pci/bus_numa.c
@@ -6,6 +6,7 @@

  int pci_root_num;
  struct pci_root_info pci_root_info[PCI_ROOT_NR];
+int found_all_numa_early;

  void x86_pci_root_bus_res_quirks(struct pci_bus *b)
  {
@@ -21,6 +22,10 @@ void x86_pci_root_bus_res_quirks(struct pci_bus *b)
         if (!pci_root_num)
                 return;

+       /* for amd, if only one root bus, don't need to do anything */
+       if (pci_root_num < 2 && found_all_numa_early)
+               return;
+
         for (i = 0; i < pci_root_num; i++) {
                 if (pci_root_info[i].bus_min == b->number)
                         break;
diff --git a/arch/x86/pci/bus_numa.h b/arch/x86/pci/bus_numa.h
index 804a4b4..d4ad5fa 100644
--- a/arch/x86/pci/bus_numa.h
+++ b/arch/x86/pci/bus_numa.h
@@ -19,6 +19,7 @@ struct pci_root_info {
  #define PCI_ROOT_NR 4
  extern int pci_root_num;
  extern struct pci_root_info pci_root_info[PCI_ROOT_NR];
+extern int found_all_numa_early;

  extern void update_res(struct pci_root_info *info, resource_size_t start,
                       resource_size_t end, unsigned long flags, int 
merge);

My lspci
--------

00:00.0 Host bridge: VIA Technologies, Inc. K8T890CF Host Bridge
00:00.1 Host bridge: VIA Technologies, Inc. VT3351 Host Bridge
00:00.2 Host bridge: VIA Technologies, Inc. VT3351 Host Bridge
00:00.3 Host bridge: VIA Technologies, Inc. VT3351 Host Bridge
00:00.4 Host bridge: VIA Technologies, Inc. VT3351 Host Bridge
00:00.5 PIC: VIA Technologies, Inc. VT3351 I/O APIC Interrupt Controller
00:00.7 Host bridge: VIA Technologies, Inc. VT3351 Host Bridge
00:01.0 PCI bridge: VIA Technologies, Inc. [K8T890 North / VT8237 South] 
PCI Bridge
00:02.0 PCI bridge: VIA Technologies, Inc. K8T890 PCI to PCI Bridge 
Controller
00:03.0 PCI bridge: VIA Technologies, Inc. K8T890 PCI to PCI Bridge 
Controller
00:03.1 PCI bridge: VIA Technologies, Inc. K8T890 PCI to PCI Bridge 
Controller
00:03.2 PCI bridge: VIA Technologies, Inc. K8T890 PCI to PCI Bridge 
Controller
00:03.3 PCI bridge: VIA Technologies, Inc. K8T890 PCI to PCI Bridge 
Controller
00:0f.0 RAID bus controller: VIA Technologies, Inc. VT8237A SATA 2-Port 
Controller (rev 80)
00:0f.1 IDE interface: VIA Technologies, Inc. 
VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 07)
00:10.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 
Controller (rev a0)
00:10.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 
Controller (rev a0)
00:10.2 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 
Controller (rev a0)
00:10.3 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 
Controller (rev a0)
00:10.4 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 86)
00:11.0 ISA bridge: VIA Technologies, Inc. VT8237A PCI to ISA Bridge
00:11.7 Host bridge: VIA Technologies, Inc. VT8251 Ultra VLINK Controller
00:13.0 Host bridge: VIA Technologies, Inc. VT8237A Host Bridge
00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
HyperTransport Technology Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
Miscellaneous Control
02:00.0 SATA controller: JMicron Technology Corp. JMB362/JMB363 Serial 
ATA Controller (rev 02)
02:00.1 IDE interface: JMicron Technology Corp. JMB362/JMB363 Serial ATA 
Controller (rev 02)
03:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. 
RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 01)
06:00.0 VGA compatible controller: nVidia Corporation G71 [GeForce 7900 
GS] (rev a1)
80:01.0 Audio device: VIA Technologies, Inc. VT1708/A [Azalia HDAC] (VIA 
High Definition Audio Controller) (rev 10)


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900Ab1HTPhG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 11:37:06 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35775 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586Ab1HTPhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 11:37:01 -0400
Date: Sat, 20 Aug 2011 23:36:34 +0800 (SGT)
From: Jeff Chua <jeff.chua.linux@gmail.com>
X-X-Sender: root@boston.corp.fedex.com
To: Linux Kernel <linux-kernel@vger.kernel.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Daniel Halperin <dhalperi@cs.washington.edu>,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: WARNING: at lib/iomap.c:43 0xffffffffa00ac458()
In-Reply-To: <Pine.LNX.4.64.1108181259020.4357@boston.corp.fedex.com>
Message-ID: <Pine.LNX.4.64.1108202327480.7271@boston.corp.fedex.com>
References: <Pine.LNX.4.64.1108181259020.4357@boston.corp.fedex.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I bisected it further and it came down to this commit. Reverting it solves 
the problem. Now I'm on linux-3.1.0-rc2 
(bed8cad9593974a46de5c8aa3d2ee7c49c17182f) with the patch reverted and 
system 
is stable once again. modprobe -r iwlagn no longer hangs the system.


wlagn 0000:02:00.0: L1 Disabled; Enabling L0S
iwlagn 0000:02:00.0: Radio type=0x1-0x3-0x1
iwlagn 0000:02:00.0: L1 Disabled; Enabling L0S
iwlagn 0000:02:00.0: Radio type=0x1-0x3-0x1
wlan0: authenticate with 00:18:39:a3:83:94 (try 1)
wlan0: authenticated
wlan0: waiting for beacon from 00:18:39:a3:83:94
wlan0: beacon received
wlan0: associate with 00:18:39:a3:83:94 (try 1)
wlan0: RX AssocResp from 00:18:39:a3:83:94 (capab=0x471 status=0 aid=2)
wlan0: associated
wlan0: deauthenticating from 00:18:39:a3:83:94 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
------------[ cut here ]------------
WARNING: at lib/iomap.c:43 0xffffffffa00ac570()
Hardware name: 5413FGA
Bad IO access at port 0x0 ()
Modules linked in: iwlagn(-) mac80211 cfg80211 i915 drm_kms_helper
Pid: 2810, comm: modprobe Not tainted 3.0.0+ #4
Call Trace:
[<ffffffff8103463c>] ? 0xffffffff8103463c
[<ffffffff810346ef>] ? 0xffffffff810346ef
[<ffffffffa00ac570>] ? 0xffffffffa00ac570
[<ffffffff811fb6e1>] ? 0xffffffff811fb6e1
[<ffffffff8128ddd0>] ? 0xffffffff8128ddd0
[<ffffffff8128de95>] ? 0xffffffff8128de95
[<ffffffff8128d1c3>] ? 0xffffffff8128d1c3
[<ffffffff811fb9df>] ? 0xffffffff811fb9df
[<ffffffffa00ac3b9>] ? 0xffffffffa00ac3b9
[<ffffffff8105e794>] ? 0xffffffff8105e794
[<ffffffff8109339c>] ? 0xffffffff8109339c
[<ffffffff814cf175>] ? 0xffffffff814cf175
[<ffffffff814cf612>] ? 0xffffffff814cf612
---[ end trace 6f2f37533e5e3312 ]---
BUG: unable to handle kernel NULL pointer dereference at 00000000000002e0
IP: [<ffffffff811f952e>] 0xffffffff811f952e
PGD 22fbd4067 PUD 22f7c8067 PMD 0
Oops: 0000 [#1] PREEMPT SMP
CPU 0


Running on Lenovo X201s with 6200 AGN. No problem bringing up wireless. 
Bug appeared upon "modprobe -r iwlagn".

iwlagn 0000:02:00.0: Detected Intel(R) Centrino(R) Advanced-N 6200 AGN, 
REV=0x74
iwlagn 0000:02:00.0: L1 Disabled; Enabling L0S
iwlagn 0000:02:00.0: device EEPROM VER=0x436, CALIB=0x6
iwlagn 0000:02:00.0: Device SKU: 0X1f0
iwlagn 0000:02:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
iwlagn 0000:02:00.0: loaded firmware version 9.221.4.1 build 25532


Thanks,
Jeff



commit cc1a93e68f6c0d736b771f0746e8e4186f483fdc
Author: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date:   Mon Aug 1 12:46:57 2011 -0700

     iwlagn: sysfs couldn't find the priv pointer

     This bug has been introduced by:
     d593411084a56124aa9d80aafa15db8463b2d8f7
     Author: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
     Date:   Mon Jul 11 10:48:51 2011 +0300

         iwlagn: simplify the bus architecture

     Revert part of the buggy patch: dev_get_drvdata will now return
     iwl_priv as it did before the patch.

     Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
     Tested-by: Daniel Halperin <dhalperi@cs.washington.edu>
     Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
     Signed-off-by: John W. Linville <linville@tuxdriver.com>

diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index fb7e436..69d4ec4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -134,6 +134,7 @@ static void iwl_pci_apm_config(struct iwl_bus *bus)
  static void iwl_pci_set_drv_data(struct iwl_bus *bus, void *drv_data)
  {
  	bus->drv_data = drv_data;
+	pci_set_drvdata(IWL_BUS_GET_PCI_DEV(bus), drv_data);
  }

  static void iwl_pci_get_hw_id(struct iwl_bus *bus, char buf[],
@@ -454,8 +455,6 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
  		pci_write_config_word(pdev, PCI_COMMAND, pci_cmd);
  	}

-	pci_set_drvdata(pdev, bus);
-
  	bus->dev = &pdev->dev;
  	bus->irq = pdev->irq;
  	bus->ops = &pci_ops;
@@ -494,11 +493,12 @@ static void iwl_pci_down(struct iwl_bus *bus)

  static void __devexit iwl_pci_remove(struct pci_dev *pdev)
  {
-	struct iwl_bus *bus = pci_get_drvdata(pdev);
+	struct iwl_priv *priv = pci_get_drvdata(pdev);
+	void *bus_specific = priv->bus->bus_specific;

-	iwl_remove(bus->drv_data);
+	iwl_remove(priv);

-	iwl_pci_down(bus);
+	iwl_pci_down(bus_specific);
  }

  #ifdef CONFIG_PM
@@ -506,20 +506,20 @@ static void __devexit iwl_pci_remove(struct pci_dev *pdev)
  static int iwl_pci_suspend(struct device *device)
  {
  	struct pci_dev *pdev = to_pci_dev(device);
-	struct iwl_bus *bus = pci_get_drvdata(pdev);
+	struct iwl_priv *priv = pci_get_drvdata(pdev);

  	/* Before you put code here, think about WoWLAN. You cannot check here
  	 * whether WoWLAN is enabled or not, and your code will run even if
  	 * WoWLAN is enabled - don't kill the NIC, someone may need it in Sx.
  	 */

-	return iwl_suspend(bus->drv_data);
+	return iwl_suspend(priv);
  }

  static int iwl_pci_resume(struct device *device)
  {
  	struct pci_dev *pdev = to_pci_dev(device);
-	struct iwl_bus *bus = pci_get_drvdata(pdev);
+	struct iwl_priv *priv = pci_get_drvdata(pdev);

  	/* Before you put code here, think about WoWLAN. You cannot check here
  	 * whether WoWLAN is enabled or not, and your code will run even if
@@ -532,7 +532,7 @@ static int iwl_pci_resume(struct device *device)
  	 */
  	pci_write_config_byte(pdev, PCI_CFG_RETRY_TIMEOUT, 0x00);

-	return iwl_resume(bus->drv_data);
+	return iwl_resume(priv);
  }

  static SIMPLE_DEV_PM_OPS(iwl_dev_pm_ops, iwl_pci_suspend, iwl_pci_resume);




On Thu, 18 Aug 2011, Jeff Chua wrote:

>
> Got several warning here and it's the iwlagn that brought down the system. 
> Running linux-3.1.0-rc2 commit at 338d0f0a6fbc82407864606f5b64b75aeb3c70f2
>
> This problem surfaced after 53d1e658df6e26d62500410719aaee2b82067c03.
>
> Before that, everything is very stable.
>
>
> ------------[ cut here ]------------
> WARNING: at fs/sysfs/dir.c:455 0xffffffff810f5ac4()
> Hardware name: 5413FGA
> sysfs: cannot create duplicate filename 
> '/devices/pci0000:00/0000:00:02.0/drm/card0/card0-LVDS-1/intel_backlight'
> Modules linked in: i915(+) drm_kms_helper
> Pid: 2016, comm: modprobe Not tainted 3.1.0-rc2 #6
> Call Trace:
> [<ffffffff8103454c>] ? 0xffffffff8103454c
> [<ffffffff810345ff>] ? 0xffffffff810345ff
> [<ffffffff810f5ac4>] ? 0xffffffff810f5ac4
> [<ffffffff810f634f>] ? 0xffffffff810f634f
> [<ffffffff81044ca7>] ? 0xffffffff81044ca7
> [<ffffffff810f6423>] ? 0xffffffff810f6423
> [<ffffffff8102dbbd>] ? 0xffffffff8102dbbd
> [<ffffffff811dc525>] ? 0xffffffff811dc525
> [<ffffffff811dc76e>] ? 0xffffffff811dc76e
> [<ffffffff8102dbbd>] ? 0xffffffff8102dbbd
> [<ffffffff812893ad>] ? 0xffffffff812893ad
> [<ffffffff8102be75>] ? 0xffffffff8102be75
> [<ffffffff8102dbbd>] ? 0xffffffff8102dbbd
> [<ffffffff81290c76>] ? 0xffffffff81290c76
> [<ffffffff81215181>] ? 0xffffffff81215181
> [<ffffffffa0031e17>] ? 0xffffffffa0031e17
> [<ffffffffa0021f2d>] ? 0xffffffffa0021f2d
> [<ffffffffa0009185>] ? 0xffffffffa0009185
> [<ffffffff8127a87b>] ? 0xffffffff8127a87b
> [<ffffffff8127c415>] ? 0xffffffff8127c415
> [<ffffffff814d065c>] ? 0xffffffff814d065c
> [<ffffffff811f767e>] ? 0xffffffff811f767e
> [<ffffffff811f8448>] ? 0xffffffff811f8448
> [<ffffffff8128b110>] ? 0xffffffff8128b110
> [<ffffffff8128b251>] ? 0xffffffff8128b251
> [<ffffffff8128b330>] ? 0xffffffff8128b330
> [<ffffffff8128b2e1>] ? 0xffffffff8128b2e1
> [<ffffffff8128aabd>] ? 0xffffffff8128aabd
> [<ffffffff8128a46b>] ? 0xffffffff8128a46b
> [<ffffffff8128b865>] ? 0xffffffff8128b865
> [<ffffffff811f869a>] ? 0xffffffff811f869a
> [<ffffffffa004c000>] ? 0xffffffffa004c000
> [<ffffffffa004c000>] ? 0xffffffffa004c000
> [<ffffffff81000208>] ? 0xffffffff81000208
> [<ffffffff8105e445>] ? 0xffffffff8105e445
> [<ffffffff814d0fd2>] ? 0xffffffff814d0fd2
> ---[ end trace 7d200175acf13c73 ]---
> kobject_add_internal failed for intel_backlight with -EEXIST, don't try to 
> register things with the same name in the same directory.
> Pid: 2016, comm: modprobe Tainted: G        W   3.1.0-rc2 #6
> Call Trace:
> [<ffffffff811dc5b4>] ? 0xffffffff811dc5b4
> [<ffffffff811dc76e>] ? 0xffffffff811dc76e
> [<ffffffff8102dbbd>] ? 0xffffffff8102dbbd
> [<ffffffff812893ad>] ? 0xffffffff812893ad
> [<ffffffff8102be75>] ? 0xffffffff8102be75
> [<ffffffff8102dbbd>] ? 0xffffffff8102dbbd
> [<ffffffff81290c76>] ? 0xffffffff81290c76
> [<ffffffff81215181>] ? 0xffffffff81215181
> [<ffffffffa0031e17>] ? 0xffffffffa0031e17
> [<ffffffffa0021f2d>] ? 0xffffffffa0021f2d
> [<ffffffffa0009185>] ? 0xffffffffa0009185
> [<ffffffff8127a87b>] ? 0xffffffff8127a87b
> [<ffffffff8127c415>] ? 0xffffffff8127c415
> [<ffffffff814d065c>] ? 0xffffffff814d065c
> [<ffffffff811f767e>] ? 0xffffffff811f767e
> [<ffffffff811f8448>] ? 0xffffffff811f8448
> [<ffffffff8128b110>] ? 0xffffffff8128b110
> [<ffffffff8128b251>] ? 0xffffffff8128b251
> [<ffffffff8128b330>] ? 0xffffffff8128b330
> [<ffffffff8128b2e1>] ? 0xffffffff8128b2e1
> [<ffffffff8128aabd>] ? 0xffffffff8128aabd
> [<ffffffff8128a46b>] ? 0xffffffff8128a46b
> [<ffffffff8128b865>] ? 0xffffffff8128b865
> [<ffffffff811f869a>] ? 0xffffffff811f869a
> [<ffffffffa004c000>] ? 0xffffffffa004c000
> [<ffffffffa004c000>] ? 0xffffffffa004c000
> [<ffffffff81000208>] ? 0xffffffff81000208
> [<ffffffff8105e445>] ? 0xffffffff8105e445
> [<ffffffff814d0fd2>] ? 0xffffffff814d0fd2
> [drm:intel_panel_setup_backlight] *ERROR* Failed to register backlight: -17
> fbcon: inteldrmfb (fb0) is primary device
> Console: switching to colour frame buffer device 180x56
> fb0: inteldrmfb frame buffer device
> drm: registered panic notifier
> acpi device:02: registered as cooling_device4
> input: Video Bus as 
> /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input6
> ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
> [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
> [drm:ironlake_update_pch_refclk] *ERROR* enabling SSC on PCH
> cfg80211: Calling CRDA to update world regulatory domain
> Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
> Copyright(c) 2003-2011 Intel Corporation
> iwlagn 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> iwlagn 0000:02:00.0: setting latency timer to 64
> iwlagn 0000:02:00.0: pci_resource_len = 0x00002000
> iwlagn 0000:02:00.0: pci_resource_base = ffffc90001ce8000
> iwlagn 0000:02:00.0: HW Revision ID = 0x35
> iwlagn 0000:02:00.0: irq 43 for MSI/MSI-X
> iwlagn 0000:02:00.0: Detected Intel(R) Centrino(R) Advanced-N 6200 AGN, 
> REV=0x74
> iwlagn 0000:02:00.0: L1 Disabled; Enabling L0S
> iwlagn 0000:02:00.0: device EEPROM VER=0x436, CALIB=0x6
> iwlagn 0000:02:00.0: Device SKU: 0X1f0
> iwlagn 0000:02:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
> iwlagn 0000:02:00.0: loaded firmware version 9.221.4.1 build 25532
> Registered led device: phy0-led
> ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
> iwlagn 0000:02:00.0: L1 Disabled; Enabling L0S
> iwlagn 0000:02:00.0: Radio type=0x1-0x3-0x1
> iwlagn 0000:02:00.0: L1 Disabled; Enabling L0S
> iwlagn 0000:02:00.0: Radio type=0x1-0x3-0x1
> wlan0: authenticate with 00:18:39:a3:83:94 (try 1)
> wlan0: authenticated
> wlan0: waiting for beacon from 00:18:39:a3:83:94
> wlan0: beacon received
> wlan0: associate with 00:18:39:a3:83:94 (try 1)
> wlan0: RX AssocResp from 00:18:39:a3:83:94 (capab=0x471 status=0 aid=2)
> wlan0: associated
> iwlagn 0000:02:00.0: Queue 2 stuck for 2000 ms.
> iwlagn 0000:02:00.0: On demand firmware reload
> ieee80211 phy0: Hardware restart was requested
> iwlagn 0000:02:00.0: L1 Disabled; Enabling L0S
> iwlagn 0000:02:00.0: Radio type=0x1-0x3-0x1
> wlan0: deauthenticating from 00:18:39:a3:83:94 by local choice (reason=3)
> cfg80211: Calling CRDA to update world regulatory domain
> iwlagn 0000:02:00.0: Error: Response NULL in 'REPLY_ADD_STA'
> iwlagn 0000:02:00.0: Adding station ff:ff:ff:ff:ff:ff failed.
> ------------[ cut here ]------------
> WARNING: at lib/iomap.c:43 0xffffffffa00ac458()
> Hardware name: 5413FGA
> Bad IO access at port 0x0 ()
> Modules linked in: iwlagn(-) mac80211 cfg80211 i915 drm_kms_helper
> Pid: 2889, comm: modprobe Tainted: G        W   3.1.0-rc2 #6
> Call Trace:
> [<ffffffff8103454c>] ? 0xffffffff8103454c
> [<ffffffff810345ff>] ? 0xffffffff810345ff
> [<ffffffffa00ac458>] ? 0xffffffffa00ac458
> [<ffffffff811f82ed>] ? 0xffffffff811f82ed
> [<ffffffff8128af7c>] ? 0xffffffff8128af7c
> [<ffffffff8128b041>] ? 0xffffffff8128b041
> [<ffffffff8128a36f>] ? 0xffffffff8128a36f
> [<ffffffff811f85eb>] ? 0xffffffff811f85eb
> [<ffffffffa00ac2a1>] ? 0xffffffffa00ac2a1
> [<ffffffff8105e744>] ? 0xffffffff8105e744
> [<ffffffff8109240c>] ? 0xffffffff8109240c
> [<ffffffff814d0b35>] ? 0xffffffff814d0b35
> [<ffffffff814d0fd2>] ? 0xffffffff814d0fd2
> ---[ end trace 7d200175acf13c74 ]---
> Trying to free nonexistent resource <0000000000000021-00000000017cd000>
> Trying to free nonexistent resource <ffff880228481000-ffff88022eb38320>
> Trying to free nonexistent resource <ffff88022eb38fc0-ffffffffa006b108>
> general protection fault: 0000 [#1] PREEMPT SMP
> CPU 1
> Modules linked in: iwlagn(-) mac80211 cfg80211 i915 drm_kms_helper
>
> Pid: 2889, comm: modprobe Tainted: G        W   3.1.0-rc2 #6 LENOVO 
> 5413FGA/5413FGA
> RIP: 0010:[<ffffffff8128aec0>]  [<ffffffff8128aec0>] 0xffffffff8128aec0
> RSP: 0018:ffff880227e77e08  EFLAGS: 00010286
> RAX: 8000000000000000 RBX: ffff88022eb38950 RCX: ffff88022fd99c20
> RDX: ffff88022fd900a0 RSI: 0000000000000000 RDI: ffff88022eb38950
> RBP: 0000000000000000 R08: 0000000000000002 R09: ffff88022eb382e0
> R10: 00007fffd6a978f0 R11: 000000000000bd6b R12: ffff88022eb38300
> R13: 00007fffd6a978f0 R14: 0000000000000001 R15: 00000000011404a0
> FS:  00007f7fac94b700(0000) GS:ffff88023bc80000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 00000000006b4c24 CR3: 0000000228587000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process modprobe (pid: 2889, threadinfo ffff880227e76000, task 
> ffff880231c6c800)
> Stack:
> ffff88022eb382e0 ffff88022eb382e0 ffff88022eb382c0 ffffffffa00ac47c
> ffff8802326e1090 ffffffffa00b4bb0 ffff8802326e1000 ffffffff811f82ed
> ffff8802326e1090 ffffffffa00b4c10 ffff8802326e10f0 ffffffff8128af7c
> Call Trace:
> [<ffffffffa00ac47c>] ? 0xffffffffa00ac47c
> [<ffffffff811f82ed>] ? 0xffffffff811f82ed
> [<ffffffff8128af7c>] ? 0xffffffff8128af7c
> [<ffffffff8128b041>] ? 0xffffffff8128b041
> [<ffffffff8128a36f>] ? 0xffffffff8128a36f
> [<ffffffff811f85eb>] ? 0xffffffff811f85eb
> [<ffffffffa00ac2a1>] ? 0xffffffffa00ac2a1
> [<ffffffff8105e744>] ? 0xffffffff8105e744
> [<ffffffff8109240c>] ? 0xffffffff8109240c
> [<ffffffff814d0b35>] ? 0xffffffff814d0b35
> [<ffffffff814d0fd2>] ? 0xffffffff814d0fd2
> Code: 48 8b 80 88 00 00 00 c3 31 c0 c3 55 48 89 f5 53 48 89 fb 48 83 ec 08 48 
> 83 7f 08 00 75 09 e8 60 e0 ff ff 85 c0 75 0d 48 8b 43 08
> RIP  [<ffffffff8128aec0>] 0xffffffff8128aec0
> RSP <ffff880227e77e08>
> ---[ end trace 7d200175acf13c75 ]---
>
>
> Thanks,
> Jeff
>
>
>
>
>
>

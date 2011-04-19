Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898Ab1DSROX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 13:14:23 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:60359 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474Ab1DSROW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 13:14:22 -0400
X-IronPort-AV: E=Sophos;i="4.64,240,1301875200"; 
   d="scan'208";a="5380581"
Date: Tue, 19 Apr 2011 18:14:48 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Alessandro Zummo <a.zummo@towertech.it>
CC: <rtc-linux@googlegroups.com>, <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH] rtc-cmos: do not call rtc_update_irq when cmos->rtc is
 uninitialized
Message-ID: <alpine.DEB.2.00.1104191707440.10886@kaball-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
I have a 32 bit kernel compiled with:

CONFIG_HPET_TIMER
CONFIG_HPET_EMULATE_RTC
CONFIG_RTC_DRV_CMOS

that crashes reliably on boot on xen with the following stack trace:

[    0.222933] BUG: unable to handle kernel NULL pointer dereference at 0000020c
[    0.222958] IP: [<c104a34c>] queue_work_on+0x5/0x1f
[    0.222984] *pdpt = 0000000000000000 *pde = c2c2c2c2c2c2c2c2 
[    0.223008] Oops: 0002 [#1] SMP 
[    0.223027] last sysfs file: 
[    0.223040] Modules linked in:
[    0.223058] 
[    0.223058] Pid: 1, comm: swapper Not tainted 2.6.39-rc3+ #247  
[    0.223058] EIP: 0061:[<c104a34c>] EFLAGS: 00010006 CPU: 0
[    0.223058] EIP is at queue_work_on+0x5/0x1f
[    0.223058] EAX: 00000000 EBX: cd81a5a0 ECX: 0000020c EDX: cd81a5a0
[    0.223058] ESI: 000000ff EDI: ffffffd0 EBP: cd829cf4 ESP: cd829cec
[    0.223058]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: e021
[    0.223058] Process swapper (pid: 1, ti=cd828000 task=cd824000 task.ti=cd828000)
[    0.223058] Stack:
[    0.223058]  cd81a5a0 000000ff cd829d00 c104a38d c18b37d8 cd829d08 c104a39f cd829d10
[    0.223058]  c132a450 cd829d24 c132be1c cd829d20 c18b37d8 000000df cd829d38 c132bf15
[    0.223058]  cd829de8 c18b37d8 00000023 cd829d58 c132cba4 c132a045 030000a5 47142d2f
[    0.223058] Call Trace:
[    0.223058]  [<c104a38d>] queue_work+0x15/0x18
[    0.223058]  [<c104a39f>] schedule_work+0xf/0x11
[    0.223058]  [<c132a450>] rtc_update_irq+0xd/0xf
[    0.223058]  [<c132be1c>] cmos_checkintr+0x4f/0x57
[    0.223058]  [<c132bf15>] cmos_irq_disable+0x3a/0x3f
[    0.223058]  [<c132cba4>] cmos_set_alarm+0xcd/0x153
[    0.223058]  [<c132a045>] ? rtc_time_to_tm+0xfb/0x105
[    0.223058]  [<c132a8e9>] __rtc_set_alarm+0x63/0x6b
[    0.223058]  [<c132aa2f>] rtc_timer_enqueue+0x7b/0xba
[    0.223058]  [<c132a110>] ? rtc_tm_to_ktime+0x11/0x1d
[    0.223058]  [<c132ac85>] rtc_set_alarm+0x9d/0xb3
[    0.223058]  [<c132ac85>] ? rtc_set_alarm+0x9d/0xb3
[    0.223058]  [<c132a360>] rtc_device_register+0x1bb/0x27b
[    0.223058]  [<c132c775>] cmos_do_probe+0x14f/0x3c3
[    0.223058]  [<c17bdc23>] cmos_platform_probe+0x40/0x48
[    0.223058]  [<c12642dd>] platform_drv_probe+0xc/0xe
[    0.223058]  [<c126350f>] driver_probe_device+0x81/0xfd
[    0.223058]  [<c12635ce>] __driver_attach+0x43/0x5f
[    0.223058]  [<c1262d3d>] bus_for_each_dev+0x3d/0x67
[    0.223058]  [<c12633c7>] driver_attach+0x14/0x16
[    0.223058]  [<c126358b>] ? driver_probe_device+0xfd/0xfd
[    0.223058]  [<c12630e9>] bus_add_driver+0x8f/0x1c2
[    0.223058]  [<c1263a3e>] driver_register+0x7c/0xe3
[    0.223058]  [<c12646bc>] platform_driver_register+0x38/0x3a
[    0.223058]  [<c12646d1>] platform_driver_probe+0x13/0x63
[    0.223058]  [<c17bdbb8>] cmos_init+0x33/0x5e
[    0.223058]  [<c1003071>] do_one_initcall+0x71/0x11c
[    0.223058]  [<c17bdb85>] ? rtc_sysfs_init+0xc/0xc
[    0.223058]  [<c17922a9>] kernel_init+0xb6/0x131
[    0.223058]  [<c17921f3>] ? parse_early_options+0x1c/0x1c
[    0.223058]  [<c14c4b36>] kernel_thread_helper+0x6/0x10
[    0.223058] Code: 5d c3 55 89 c1 89 e5 31 d2 53 8b 00 89 c3 30 db a8 04 0f 45 d3 8b 52 04 64 a1 d0 8c 80 c1 e8 2a fd ff ff 5b 5d c3 55 89 e5 56 53 <3e> 0f ba 29 00 19 f6 31 db 85 f6 75 07 e8 10 fd ff ff b3 01 89 
[    0.223058] EIP: [<c104a34c>] queue_work_on+0x5/0x1f SS:ESP e021:cd829cec
[    0.223058] CR2: 000000000000020c
[    0.223058] ---[ end trace 4cb55f26e51edafd ]---
[    0.224327] swapper used greatest stack depth: 6004 bytes left
[    0.224367] Kernel panic - not syncing: Attempted to kill init!
[    0.224386] Pid: 1, comm: swapper Tainted: G      D     2.6.39-rc3+ #247
[    0.224400] Call Trace:
[    0.224415]  [<c14bd875>] panic+0x50/0x146
[    0.224432]  [<c103b29c>] do_exit+0x87/0x6b0
[    0.224450]  [<c10065fb>] ? xen_restore_fl_direct_reloc+0x4/0x4
[    0.224468]  [<c14bf2ed>] ? _raw_spin_unlock_irqrestore+0xf/0x11
[    0.224489]  [<c10384d0>] ? kmsg_dump+0x35/0xb5
[    0.224505]  [<c14c04b5>] oops_end+0x98/0xa0
[    0.224524]  [<c10246dd>] no_context+0x13e/0x148
[    0.224542]  [<c10247d6>] __bad_area_nosemaphore+0xef/0xf7
[    0.224558]  [<c14c1a02>] ? spurious_fault+0xff/0xff
[    0.224576]  [<c10247eb>] bad_area_nosemaphore+0xd/0x10
[    0.224593]  [<c14c1baf>] do_page_fault+0x1ad/0x35e
[    0.224610]  [<c1005f87>] ? xen_force_evtchn_callback+0xf/0x14
[    0.224629]  [<c1006604>] ? check_events+0x8/0xc
[    0.224645]  [<c10065fb>] ? xen_restore_fl_direct_reloc+0x4/0x4
[    0.224663]  [<c1038dfc>] ? vprintk+0x2fb/0x31d
[    0.224680]  [<c14c1a02>] ? spurious_fault+0xff/0xff
[    0.224699]  [<c14bfbe6>] error_code+0x5a/0x60
[    0.224716]  [<c14c1a02>] ? spurious_fault+0xff/0xff
[    0.224735]  [<c104a34c>] ? queue_work_on+0x5/0x1f
[    0.224750]  [<c104a38d>] queue_work+0x15/0x18
[    0.224768]  [<c104a39f>] schedule_work+0xf/0x11
[    0.224788]  [<c132a450>] rtc_update_irq+0xd/0xf
[    0.224804]  [<c132be1c>] cmos_checkintr+0x4f/0x57
[    0.224821]  [<c132bf15>] cmos_irq_disable+0x3a/0x3f
[    0.224839]  [<c132cba4>] cmos_set_alarm+0xcd/0x153
[    0.224857]  [<c132a045>] ? rtc_time_to_tm+0xfb/0x105
[    0.224875]  [<c132a8e9>] __rtc_set_alarm+0x63/0x6b
[    0.224893]  [<c132aa2f>] rtc_timer_enqueue+0x7b/0xba
[    0.224911]  [<c132a110>] ? rtc_tm_to_ktime+0x11/0x1d
[    0.224928]  [<c132ac85>] rtc_set_alarm+0x9d/0xb3
[    0.224945]  [<c132ac85>] ? rtc_set_alarm+0x9d/0xb3
[    0.224962]  [<c132a360>] rtc_device_register+0x1bb/0x27b
[    0.224981]  [<c132c775>] cmos_do_probe+0x14f/0x3c3
[    0.224998]  [<c17bdc23>] cmos_platform_probe+0x40/0x48
[    0.225017]  [<c12642dd>] platform_drv_probe+0xc/0xe
[    0.225034]  [<c126350f>] driver_probe_device+0x81/0xfd
[    0.225054]  [<c12635ce>] __driver_attach+0x43/0x5f
[    0.225071]  [<c1262d3d>] bus_for_each_dev+0x3d/0x67
[    0.225088]  [<c12633c7>] driver_attach+0x14/0x16
[    0.225104]  [<c126358b>] ? driver_probe_device+0xfd/0xfd
[    0.225120]  [<c12630e9>] bus_add_driver+0x8f/0x1c2
[    0.225136]  [<c1263a3e>] driver_register+0x7c/0xe3
[    0.225153]  [<c12646bc>] platform_driver_register+0x38/0x3a
[    0.225169]  [<c12646d1>] platform_driver_probe+0x13/0x63
[    0.225186]  [<c17bdbb8>] cmos_init+0x33/0x5e
[    0.225201]  [<c1003071>] do_one_initcall+0x71/0x11c
[    0.225217]  [<c17bdb85>] ? rtc_sysfs_init+0xc/0xc
[    0.225233]  [<c17922a9>] kernel_init+0xb6/0x131
[    0.225248]  [<c17921f3>] ? parse_early_options+0x1c/0x1c
[    0.225265]  [<c14c4b36>] kernel_thread_helper+0x6/0x10


the same kernel config works on 2.6.38.
Note that running on Xen means that hpet is not available.
The problem seems to be that cmos_do_probe calls rtc_device_register
that ends up calling cmos_checkintr (see stack trace), however at this
point cmos->rtc is still NULL because cmos->rtc gets a value only when
rtc_device_register returns.
It seems that on 2.6.38 a call to rtc_device_register didn't result in a
call to cmos_checkintr so the problem didn't happen.
It is probably not the correct fix, but the following patch fixes the
crash for me:


commit 6a5411f016864709907fe1fa9fbbe6b267823f66
Author: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Date:   Tue Apr 19 16:59:44 2011 +0000

    rtc-cmos: do not call rtc_update_irq when cmos->rtc is uninitialized
    
    Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index 911e75c..039068f 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -290,7 +290,7 @@ static void cmos_checkintr(struct cmos_rtc *cmos, unsigned char rtc_control)
 		return;
 
 	rtc_intr &= (rtc_control & RTC_IRQMASK) | RTC_IRQF;
-	if (is_intr(rtc_intr))
+	if (is_intr(rtc_intr) && cmos->rtc != NULL)
 		rtc_update_irq(cmos->rtc, 1, rtc_intr);
 }
 

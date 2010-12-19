Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932425Ab0LSNAN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 08:00:13 -0500
Received: from mail.skyhub.de ([78.46.96.112]:47214 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932358Ab0LSNAJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 08:00:09 -0500
Date: Sun, 19 Dec 2010 14:00:01 +0100
From: Borislav Petkov <bp@alien8.de>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Len Brown <len.brown@intel.com>, Seblu <seblu@seblu.net>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] ACPI battery: Fix sysfs oops when removing battery
Message-ID: <20101219130001.GB5790@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Zhang Rui <rui.zhang@intel.com>, Len Brown <len.brown@intel.com>,
	Seblu <seblu@seblu.net>, lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

I get the oops below on 37-rc6. Here's a possible fix:

---
From: Borislav Petkov <bp@alien8.de>
Date: Sun, 19 Dec 2010 12:58:45 +0100
Subject: [PATCH] ACPI battery: Fix sysfs oops when removing battery

3138b32d5e0998ba3cbd1c74bdc1887d74c5279b fixed battery status updates in
sysfs but when the battery is removed from the machine, we hit a sysfs
warning which ends in NULL-ptr deref since the battery is not present
anymore:

[   39.592724] ------------[ cut here ]------------
[   39.599420] WARNING: at fs/sysfs/group.c:138 sysfs_remove_group+0xcd/0xd0()
[   39.606279] Hardware name: AOA150
[   39.606295] sysfs group c15191e0 not found for kobject 'BAT1'
...

Fix this by doing sysfs status updates only if the battery is not
disappearing. Also, remove call to acpi_battery_get_state() since we
call it through acpi_battery_update() anyway.

Cc: Seblu <seblu@seblu.net>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Len Brown <len.brown@intel.com>
Signed-off-by: Borislav Petkov <bp@alien8.de>
---
 drivers/acpi/battery.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index 9fb9d5a..78be7d5 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -186,14 +186,15 @@ static int acpi_battery_get_property(struct power_supply *psy,
 	int ret = 0;
 	struct acpi_battery *battery = to_acpi_battery(psy);
 
-	if (acpi_battery_update(battery))
-		return -ENODEV;
-
 	if (acpi_battery_present(battery)) {
+
 		/* run battery update only if it is present */
-		acpi_battery_get_state(battery);
+		if (acpi_battery_update(battery))
+			return -ENODEV;
+
 	} else if (psp != POWER_SUPPLY_PROP_PRESENT)
 		return -ENODEV;
+
 	switch (psp) {
 	case POWER_SUPPLY_PROP_STATUS:
 		if (battery->state & 0x01)
-- 
1.7.2.3

Oops:
--

[   39.592724] ------------[ cut here ]------------
[   39.599420] WARNING: at fs/sysfs/group.c:138 sysfs_remove_group+0xcd/0xd0()
[   39.606279] Hardware name: AOA150
[   39.606295] sysfs group c15191e0 not found for kobject 'BAT1'
[   39.606305] Modules linked in: acerhdf ipv6 sbs sbshc thermal container fan acpi_cpufreq mperf cpufreq_conservative cpufreq_stats cpufreq_userspace cpufreq_powersave fuse dm_crypt dm_mod loop arc4 ecb ath5k ath usbhid mac80211 psmouse sdhci_pci sdhci mmc_core battery cfg80211 processor rfkill ac uhci_hcd rng_core i2c_i801
[   39.606519] Pid: 2267, comm: kworker/0:3 Not tainted 2.6.37-rc6-dirty #12
[   39.606532] Call Trace:
[   39.606560]  [<c103aba2>] warn_slowpath_common+0x72/0xa0
[   39.606624]  [<c1125f0d>] ? sysfs_remove_group+0xcd/0xd0
[   39.606721]  [<c1125f0d>] ? sysfs_remove_group+0xcd/0xd0
[   39.606898]  [<c103ac73>] warn_slowpath_fmt+0x33/0x40
[   39.606999]  [<c1125f0d>] sysfs_remove_group+0xcd/0xd0
[   39.607064]  [<c1266d2d>] dpm_sysfs_remove+0x1d/0x20
[   39.607159]  [<c1260096>] device_del+0x36/0x180
[   39.607180]  [<c12601f0>] device_unregister+0x10/0x20
[   39.607203]  [<c12d3fff>] power_supply_unregister+0x1f/0x30
[   39.607237]  [<f879c05a>] sysfs_remove_battery+0x24/0x2e [battery]
[   39.607264]  [<f879c3bd>] acpi_battery_update+0x6a/0x28e [battery]
[   39.607289]  [<c1184300>] ? vsnprintf+0xf0/0x430
[   39.607317]  [<f879c712>] acpi_battery_get_property+0x19/0x1a6 [battery]
[   39.607342]  [<c12d454b>] power_supply_show_property+0x3b/0x150
[   39.607366]  [<c10ab4fb>] ? __get_free_pages+0x2b/0x30
[   39.607388]  [<c12d4715>] power_supply_uevent+0xb5/0x190
[   39.607412]  [<c125f96c>] dev_uevent+0x8c/0x150
[   39.607432]  [<c117e418>] ? add_uevent_var+0x38/0xd0
[   39.607454]  [<c117e6cd>] kobject_uevent_env+0x1cd/0x4d0
[   39.607477]  [<c1032d6b>] ? sub_preempt_count+0x7b/0xb0
[   39.607541]  [<c13d9126>] ? _raw_spin_unlock_irqrestore+0x16/0x40
[   39.607563]  [<c125f8e0>] ? dev_uevent+0x0/0x150
[   39.607585]  [<c117e9da>] kobject_uevent+0xa/0x10
[   39.607604]  [<c126017b>] device_del+0x11b/0x180
[   39.607624]  [<c12601f0>] device_unregister+0x10/0x20
[   39.607645]  [<c12d3fff>] power_supply_unregister+0x1f/0x30
[   39.607676]  [<f879c05a>] sysfs_remove_battery+0x24/0x2e [battery]
[   39.607702]  [<f879c3bd>] acpi_battery_update+0x6a/0x28e [battery]
[   39.607725]  [<c12da8dd>] ? do_dbs_timer+0x23d/0x3f0
[   39.607753]  [<f879c610>] acpi_battery_notify+0x2f/0x8b [battery]
[   39.607781]  [<c11b4789>] acpi_device_notify+0x17/0x1a
[   39.607802]  [<c11c0914>] acpi_ev_notify_dispatch+0x56/0x6a
[   39.607824]  [<c11b1d32>] acpi_os_execute_deferred+0x22/0x2d
[   39.607847]  [<c105424b>] process_one_work+0x11b/0x430
[   39.607870]  [<c11b1d10>] ? acpi_os_execute_deferred+0x0/0x2d
[   39.607893]  [<c10548b5>] worker_thread+0x125/0x3c0
[   39.607917]  [<c1054790>] ? worker_thread+0x0/0x3c0
[   39.607936]  [<c1057dc4>] kthread+0x74/0x80
[   39.607958]  [<c1057d50>] ? kthread+0x0/0x80
[   39.607978]  [<c100347e>] kernel_thread_helper+0x6/0x10
[   39.607994] ---[ end trace a636886777d7a081 ]---
[   39.608084] BUG: unable to handle kernel NULL pointer dereference at 00000010
[   39.608104] IP: [<c13c6858>] klist_put+0x18/0x90
[   39.608127] *pde = 00000000 
[   39.608141] Oops: 0000 [#1] PREEMPT SMP 
[   39.608156] last sysfs file: /sys/devices/system/cpu/sched_smt_power_savings
[   39.608172] Modules linked in: acerhdf ipv6 sbs sbshc thermal container fan acpi_cpufreq mperf cpufreq_conservative cpufreq_stats cpufreq_userspace cpufreq_powersave fuse dm_crypt dm_mod loop arc4 ecb ath5k ath usbhid mac80211 psmouse sdhci_pci sdhci mmc_core battery cfg80211 processor rfkill ac uhci_hcd rng_core i2c_i801
[   39.608286] 
[   39.608303] Pid: 2267, comm: kworker/0:3 Tainted: G        W   2.6.37-rc6-dirty #12         /AOA150
[   39.608322] EIP: 0060:[<c13c6858>] EFLAGS: 00010246 CPU: 0
[   39.608339] EIP is at klist_put+0x18/0x90
[   39.608352] EAX: 00000000 EBX: 00000000 ECX: 35a22000 EDX: 00000001
[   39.608369] ESI: f5972374 EDI: f68361f0 EBP: f5f11d0c ESP: f5f11cfc
[   39.608385]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[   39.608402] Process kworker/0:3 (pid: 2267, ti=f5f10000 task=f618ed80 task.ti=f5f10000)
[   39.608415] Stack:
[   39.608423]  f5f7ba00 f5f7ba00 00000000 f68361f0 f5f11d14 c13c68fd f5f11d28 c12600a5
[   39.608457]  f5f7ba00 00000000 f5f7a000 f5f11d34 c12601f0 f5f7a014 f5f11d40 c12d3fff
[   39.608489]  f5f7a000 f5f11d4c f879c05a f5f7a000 f5f11d84 f879c3bd f683602c f5dc80ff
[   39.608522] Call Trace:
[   39.608543]  [<c13c68fd>] ? klist_del+0xd/0x10
[   39.608563]  [<c12600a5>] ? device_del+0x45/0x180
[   39.608584]  [<c12601f0>] ? device_unregister+0x10/0x20
[   39.608606]  [<c12d3fff>] ? power_supply_unregister+0x1f/0x30
[   39.608637]  [<f879c05a>] ? sysfs_remove_battery+0x24/0x2e [battery]
[   39.608664]  [<f879c3bd>] ? acpi_battery_update+0x6a/0x28e [battery]
[   39.608689]  [<c1184300>] ? vsnprintf+0xf0/0x430
[   39.608718]  [<f879c712>] ? acpi_battery_get_property+0x19/0x1a6 [battery]
[   39.608743]  [<c12d454b>] ? power_supply_show_property+0x3b/0x150
[   39.608767]  [<c10ab4fb>] ? __get_free_pages+0x2b/0x30
[   39.608790]  [<c12d4715>] ? power_supply_uevent+0xb5/0x190
[   39.608814]  [<c125f96c>] ? dev_uevent+0x8c/0x150
[   39.608834]  [<c117e418>] ? add_uevent_var+0x38/0xd0
[   39.608856]  [<c117e6cd>] ? kobject_uevent_env+0x1cd/0x4d0
[   39.608879]  [<c1032d6b>] ? sub_preempt_count+0x7b/0xb0
[   39.608901]  [<c13d9126>] ? _raw_spin_unlock_irqrestore+0x16/0x40
[   39.608924]  [<c125f8e0>] ? dev_uevent+0x0/0x150
[   39.608945]  [<c117e9da>] ? kobject_uevent+0xa/0x10
[   39.608965]  [<c126017b>] ? device_del+0x11b/0x180
[   39.608986]  [<c12601f0>] ? device_unregister+0x10/0x20
[   39.609007]  [<c12d3fff>] ? power_supply_unregister+0x1f/0x30
[   39.609039]  [<f879c05a>] ? sysfs_remove_battery+0x24/0x2e [battery]
[   39.609065]  [<f879c3bd>] ? acpi_battery_update+0x6a/0x28e [battery]
[   39.609088]  [<c12da8dd>] ? do_dbs_timer+0x23d/0x3f0
[   39.609117]  [<f879c610>] ? acpi_battery_notify+0x2f/0x8b [battery]
[   39.609144]  [<c11b4789>] ? acpi_device_notify+0x17/0x1a
[   39.609164]  [<c11c0914>] ? acpi_ev_notify_dispatch+0x56/0x6a
[   39.609187]  [<c11b1d32>] ? acpi_os_execute_deferred+0x22/0x2d
[   39.609209]  [<c105424b>] ? process_one_work+0x11b/0x430
[   39.609232]  [<c11b1d10>] ? acpi_os_execute_deferred+0x0/0x2d
[   39.609255]  [<c10548b5>] ? worker_thread+0x125/0x3c0
[   39.609279]  [<c1054790>] ? worker_thread+0x0/0x3c0
[   39.609299]  [<c1057dc4>] ? kthread+0x74/0x80
[   39.609321]  [<c1057d50>] ? kthread+0x0/0x80
[   39.609341]  [<c100347e>] ? kernel_thread_helper+0x6/0x10
[   39.609353] Code: e8 9e 43 c7 ff e9 51 ff ff ff 89 f6 8d bc 27 00 00 00 00 55 89 e5 83 ec 10 89 75 f8 89 c6 89 5d f4 89 7d fc 8b 18 83 e3 fe 89 d8 <8b> 7b 10 88 55 f0 e8 4d 2c 01 00 0f b6 55 f0 84 d2 74 0b 8b 06 
[   39.609538] EIP: [<c13c6858>] klist_put+0x18/0x90 SS:ESP 0068:f5f11cfc
[   39.609563] CR2: 0000000000000010
[   39.609661] ---[ end trace a636886777d7a082 ]---
[   39.609979] BUG: unable to handle kernel paging request at fffffffc
[   39.609998] IP: [<c10579ff>] kthread_data+0xf/0x20
[   39.610024] *pde = 015db067 *pte = 00000000 
[   39.610041] Oops: 0000 [#2] PREEMPT SMP 
[   39.610056] last sysfs file: /sys/devices/system/cpu/sched_smt_power_savings
[   39.610070] Modules linked in: acerhdf ipv6 sbs sbshc thermal container fan acpi_cpufreq mperf cpufreq_conservative cpufreq_stats cpufreq_userspace cpufreq_powersave fuse dm_crypt dm_mod loop arc4 ecb ath5k ath usbhid mac80211 psmouse sdhci_pci sdhci mmc_core battery cfg80211 processor rfkill ac uhci_hcd rng_core i2c_i801
[   39.610182] 
[   39.610198] Pid: 2267, comm: kworker/0:3 Tainted: G      D W   2.6.37-rc6-dirty #12         /AOA150
[   39.610217] EIP: 0060:[<c10579ff>] EFLAGS: 00010002 CPU: 0
[   39.610234] EIP is at kthread_data+0xf/0x20
[   39.610248] EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: 00000000
[   39.610263] ESI: 00000000 EDI: f618ed80 EBP: f5f11aa4 ESP: f5f11a98
[   39.610280]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[   39.610296] Process kworker/0:3 (pid: 2267, ti=f5f10000 task=f618ed80 task.ti=f5f10000)
[   39.610309] Stack:
[   39.610317]  c1053991 f6ff3e80 00000000 f5f11b64 c13d6e69 00000000 00000001 f5f11b3c
[   39.610348]  00000001 c10e007b f640007b f5f100d8 f5f100e0 ffffffc6 c111aebe c14f5fc0
[   39.610379]  00000009 c15cee80 f618ed80 c15d1e80 f618eef4 f618eef8 c15cc000 c15d1e80
[   39.610410] Call Trace:
[   39.610429]  [<c1053991>] ? wq_worker_sleeping+0x11/0x80
[   39.610452]  [<c13d6e69>] ? schedule+0x3f9/0xa00
[   39.610474]  [<c10e007b>] ? lookup_create+0xb/0xb0
[   39.610496]  [<c111aebe>] ? proc_flush_task+0x22e/0x270
[   39.610520]  [<c1003470>] ? common_interrupt+0x30/0x38
[   39.610540]  [<c10066de>] ? oops_end+0x6e/0x90
[   39.610559]  [<c10066de>] ? oops_end+0x6e/0x90
[   39.610578]  [<c10300d8>] ? sched_debug_show+0x948/0xce0
[   39.610600]  [<c103e73a>] ? do_exit+0x48a/0x6b0
[   39.610621]  [<c13d9126>] ? _raw_spin_unlock_irqrestore+0x16/0x40
[   39.610640]  [<c103bc21>] ? kmsg_dump+0x111/0x120
[   39.610662]  [<c10066de>] ? oops_end+0x6e/0x90
[   39.610681]  [<c13d66ee>] ? printk+0x1d/0x1f
[   39.610701]  [<c1024186>] ? no_context+0xc6/0x160
[   39.610723]  [<c10242b0>] ? __bad_area_nosemaphore+0x90/0x130
[   39.610744]  [<c13d760e>] ? preempt_schedule+0x2e/0x50
[   39.610763]  [<c103baa4>] ? vprintk+0x454/0x4c0
[   39.610784]  [<c1024367>] ? bad_area_nosemaphore+0x17/0x20
[   39.610804]  [<c102472b>] ? do_page_fault+0x25b/0x420
[   39.610827]  [<c13d66ee>] ? printk+0x1d/0x1f
[   39.610846]  [<c103a97f>] ? print_oops_end_marker+0x2f/0x40
[   39.610867]  [<c103abaf>] ? warn_slowpath_common+0x7f/0xa0
[   39.610887]  [<c10244d0>] ? do_page_fault+0x0/0x420
[   39.610906]  [<c13da067>] ? error_code+0x67/0x6c
[   39.610928]  [<c112007b>] ? kpagecount_read+0x3b/0x110
[   39.610947]  [<c13c6858>] ? klist_put+0x18/0x90
[   39.610967]  [<c13c68fd>] ? klist_del+0xd/0x10
[   39.610985]  [<c12600a5>] ? device_del+0x45/0x180
[   39.611005]  [<c12601f0>] ? device_unregister+0x10/0x20
[   39.611026]  [<c12d3fff>] ? power_supply_unregister+0x1f/0x30
[   39.611058]  [<f879c05a>] ? sysfs_remove_battery+0x24/0x2e [battery]
[   39.611084]  [<f879c3bd>] ? acpi_battery_update+0x6a/0x28e [battery]
[   39.611107]  [<c1184300>] ? vsnprintf+0xf0/0x430
[   39.611133]  [<f879c712>] ? acpi_battery_get_property+0x19/0x1a6 [battery]
[   39.611157]  [<c12d454b>] ? power_supply_show_property+0x3b/0x150
[   39.611180]  [<c10ab4fb>] ? __get_free_pages+0x2b/0x30
[   39.611202]  [<c12d4715>] ? power_supply_uevent+0xb5/0x190
[   39.611224]  [<c125f96c>] ? dev_uevent+0x8c/0x150
[   39.611243]  [<c117e418>] ? add_uevent_var+0x38/0xd0
[   39.611264]  [<c117e6cd>] ? kobject_uevent_env+0x1cd/0x4d0
[   39.611286]  [<c1032d6b>] ? sub_preempt_count+0x7b/0xb0
[   39.611308]  [<c13d9126>] ? _raw_spin_unlock_irqrestore+0x16/0x40
[   39.611328]  [<c125f8e0>] ? dev_uevent+0x0/0x150
[   39.611349]  [<c117e9da>] ? kobject_uevent+0xa/0x10
[   39.611367]  [<c126017b>] ? device_del+0x11b/0x180
[   39.611387]  [<c12601f0>] ? device_unregister+0x10/0x20
[   39.611408]  [<c12d3fff>] ? power_supply_unregister+0x1f/0x30
[   39.611438]  [<f879c05a>] ? sysfs_remove_battery+0x24/0x2e [battery]
[   39.611463]  [<f879c3bd>] ? acpi_battery_update+0x6a/0x28e [battery]
[   39.611485]  [<c12da8dd>] ? do_dbs_timer+0x23d/0x3f0
[   39.611510]  [<f879c610>] ? acpi_battery_notify+0x2f/0x8b [battery]
[   39.611536]  [<c11b4789>] ? acpi_device_notify+0x17/0x1a
[   39.611556]  [<c11c0914>] ? acpi_ev_notify_dispatch+0x56/0x6a
[   39.611578]  [<c11b1d32>] ? acpi_os_execute_deferred+0x22/0x2d
[   39.611599]  [<c105424b>] ? process_one_work+0x11b/0x430
[   39.611620]  [<c11b1d10>] ? acpi_os_execute_deferred+0x0/0x2d
[   39.611642]  [<c10548b5>] ? worker_thread+0x125/0x3c0
[   39.611664]  [<c1054790>] ? worker_thread+0x0/0x3c0
[   39.611684]  [<c1057dc4>] ? kthread+0x74/0x80
[   39.611704]  [<c1057d50>] ? kthread+0x0/0x80
[   39.611723]  [<c100347e>] ? kernel_thread_helper+0x6/0x10
[   39.611735] Code: 8d 74 26 00 64 a1 cc d4 5c c1 8b 80 4c 01 00 00 5d 8b 40 f8 c3 8d b4 26 00 00 00 00 55 89 e5 3e 8d 74 26 00 8b 80 4c 01 00 00 5d <8b> 40 fc c3 8d b6 00 00 00 00 8d bc 27 00 00 00 00 55 89 e5 3e 
[   39.611903] EIP: [<c10579ff>] kthread_data+0xf/0x20 SS:ESP 0068:f5f11a98
[   39.611928] CR2: 00000000fffffffc
[   39.611940] ---[ end trace a636886777d7a083 ]---
[   39.611952] Fixing recursive fault but reboot is needed!

-- 
Regards/Gruss,
    Boris.

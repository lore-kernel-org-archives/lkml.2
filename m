Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718Ab1JJIHT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 04:07:19 -0400
Received: from nef2.ens.fr ([129.199.96.40]:4789 "EHLO nef2.ens.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752455Ab1JJIHR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 04:07:17 -0400
From: =?utf-8?q?=C3=89ric_Brunet?= <Eric.Brunet@lps.ens.fr>
Organization: UPMC LPS-ENS
To: linux-kernel@vger.kernel.org, tiwai@suse.de, linux-pm@vger.kernel.org
Subject: List corruption and crash with kernel 3.1
Date: Mon, 10 Oct 2011 10:07:12 +0200
User-Agent: KMail/1.13.7 (Linux/3.1.0-rc6; KDE/4.6.5; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201110101007.12882.Eric.Brunet@lps.ens.fr>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.1.4 (nef2.ens.fr [129.199.96.32]); Mon, 10 Oct 2011 10:07:14 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have had the following WARNING this morning at resume time with kernel 
3.1.0-rc6 (x86-64). The WARNING has been followed immediately by three other 
WARNINGs looking very similar, and the computer was dead a couple of
minutes later. (More explanations after the WARNING.)

-------------------------------------------------------------------------------
WARNING: at lib/list_debug.c:47 __list_del_entry+0x8d/0x98()
Hardware name: Latitude E4200
list_del corruption, ffff880075e147b0->next is LIST_POISON1 (dead000000100100)
Modules linked in: cpufreq_stats cpufreq_ondemand acpi_cpufreq freq_table 
mperf ip6table_filter ip6_tables arc4 iwlagn mac80211 snd_hda_codec_idt 
snd_hda_intel snd_hda_codec snd_seq dell_wmi sparse_keymap snd_seq_device 
snd_pcm dell_laptop microcode dcdbas cfg80211 i2c_i801 iTCO_wdt joydev 
iTCO_vendor_support snd_timer snd e1000e rfkill soundcore snd_page_alloc wmi 
sdhci_pci sdhci mmc_core firewire_ohci firewire_core crc_itu_t i915 
drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: scsi_wait_scan]
Pid: 4827, comm: kworker/0:2 Not tainted 3.1.0-rc6 #11
Call Trace:
 [<ffffffff810562fe>] warn_slowpath_common+0x83/0x9b
 [<ffffffff810563b9>] warn_slowpath_fmt+0x46/0x48
 [<ffffffff81243861>] __list_del_entry+0x8d/0x98
 [<ffffffff8124387a>] list_del+0xe/0x2d
 [<ffffffff813a7e55>] led_trigger_unregister+0x29/0x9c
 [<ffffffff813a7ee1>] led_trigger_unregister_simple+0x19/0x26
 [<ffffffff813828e2>] power_supply_remove_triggers+0x21/0x8f
 [<ffffffff81381d42>] power_supply_unregister+0x1f/0x2c
 [<ffffffff812a7d1f>] sysfs_remove_battery+0x3c/0x54
 [<ffffffff812a8c4d>] acpi_battery_notify+0x46/0xaa
 [<ffffffff8127c564>] ? acpi_os_wait_events_complete+0x23/0x23
 [<ffffffff8127f777>] acpi_device_notify+0x19/0x1b
 [<ffffffff8128b7a7>] acpi_ev_notify_dispatch+0x67/0x7e
 [<ffffffff8127c58b>] acpi_os_execute_deferred+0x27/0x34
 [<ffffffff8106d2f8>] process_one_work+0x176/0x2a9
 [<ffffffff8106de02>] worker_thread+0xda/0x15d
 [<ffffffff8106dd28>] ? manage_workers+0x176/0x176
 [<ffffffff8107123b>] kthread+0x84/0x8c
 [<ffffffff814b9eb4>] kernel_thread_helper+0x4/0x10
 [<ffffffff810711b7>] ? kthread_worker_fn+0x148/0x148
 [<ffffffff814b9eb0>] ? gs_change+0x13/0x13
----------------------------------------------------------------------------------


I have been having this bug from time to time since I upgraded from fedora 14 
to fedora 15. I have tried to determine with which kernel version the problem 
started, but it is hard as the bug is very intermitent and having a trace in 
the log is very rare (I am running 3.1-rc6 since sept 21; it is the fourth or 
fifth time the computer hangs at resume time, and the first time I have 
something in the log).

I had no problem with 2.6.35 (fedora 14 kernel) and very frequent problems 
with 2.6.38.xxx (fedora 15 kernel). Some kernels crash at nearly every resume, 
some kernels crash every 5 or 10 resumes only. Having something in the log is 
very rare. 

The earliest crash I have seen with a vanilla kernel was with 2.6.39-rc1. I 
have been running a little bit 2.6.37 and 2.6.38 and saw no crash. However, 
there is a small change of behaviour in 2.6.38 so I suspect the problem is 
already in 2.6.38 even if I didn't observe it yet: at resume time, since 
2.6.38, the battery applet in KDE shows for a few seconds an empty battery 
before showing the actual charge. In 2.6.37 and earlier, the battery is 
instantaneously correctly displayed at resume time.

This is a very annoying bug. Following the advice of Takashi Iwai, I made sure 
the problem is still present in very recent kernels. I am not sure what I 
should do now. I think I will run for a couple of weeks 2.6.38 to try to make 
sure if the kernel is good or bad, but I'd like a little bit of advice on what 
to do !

I read linux-kernel but not linux-pm. Please could you CC me any answer on the 
linux-pm list ?

Thanks,

	Éric Brunet

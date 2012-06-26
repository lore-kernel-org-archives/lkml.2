Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459Ab2FZWWl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 18:22:41 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:36264 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355Ab2FZWWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 18:22:34 -0400
From: Lekensteyn <lekensteyn@gmail.com>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: MEI: suspend/IRQ warnings
Date: Wed, 27 Jun 2012 00:22:26 +0200
Message-ID: <15236906.ttExm1X813@al>
User-Agent: KMail/4.8.4 (Linux/3.5.0-1-custom; KDE/4.8.4; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

Although I do not use the MEI driver (yet?), I still have it installed. Using 
kernel 3.5-rc4, I have a weird message on boot up:

[   11.259467] mei 0000:00:16.0: setting latency timer to 64
[   11.259538] mei 0000:00:16.0: irq 48 for MSI/MSI-X
[   11.263132] mei 0000:00:16.0: wd: failed to find the client

In kernel 3.4.4, I'd get:

[    7.014817] mei: module is from the staging directory, the quality is 
unknown, you have been warned.
[    7.015139] mei 0000:00:16.0: setting latency timer to 64
[    7.015233] mei 0000:00:16.0: irq 47 for MSI/MSI-X


After suspend/resume, it get even weirder:

[10771.177941] mei 0000:00:16.0: irq 48 for MSI/MSI-X
[10771.178034] genirq: Threaded irq requested with handler=NULL and !ONESHOT 
for irq 48
[10771.178043] mei 0000:00:16.0: request_threaded_irq failed: irq = 48.
[10771.178050] dpm_run_callback(): pci_pm_resume+0x0/0x140 returns -22
[10771.178051] PM: Device 0000:00:16.0 failed to resume async: error -22

The suspend/resume cycle thereafter gives even more errors:

[33724.928600] ------------[ cut here ]------------
[33724.928607] WARNING: at kernel/irq/manage.c:1214 __free_irq+0xa3/0x1e0()
[33724.928609] Hardware name: B7130                           
[33724.928609] Trying to free already-free IRQ 48
[33724.928652] Modules linked in: acpi_call(O) iptable_mangle xt_mark 
iptable_nat nf_nat mxm_wmi wmi bbswitch(O) nf_conntrack_ipv4 nf_defrag_ipv4 
xt_state nf_conntrack ipt_REJECT xt_LOG xt_limit xt_tcpudp xt_owner 
xt_addrtype iptable_filter ip_tables x_tables arc4 iwlwifi mac80211 
snd_hda_codec_hdmi snd_hda_codec_via snd_hda_intel snd_hda_codec cfg80211 
hid_logitech_dj snd_hwdep snd_pcm usbhid psmouse coretemp snd_page_alloc hid 
snd_timer snd jmb38x_ms i2c_i801 jme intel_ips sdhci_pci memstick mei sdhci 
soundcore binfmt_misc xts gf128mul dm_crypt i915 video i2c_algo_bit 
drm_kms_helper drm xhci_hcd ahci libahci [last unloaded: wmi]
[33724.928655] Pid: 9731, comm: kworker/u:15 Tainted: G           O 3.5.0-1-
custom #1
[33724.928656] Call Trace:
[33724.928664]  [<ffffffff81038adf>] warn_slowpath_common+0x7f/0xc0
[33724.928666]  [<ffffffff81038bd6>] warn_slowpath_fmt+0x46/0x50
[33724.928668]  [<ffffffff810bb673>] __free_irq+0xa3/0x1e0
[33724.928670]  [<ffffffff810bb807>] free_irq+0x57/0xd0
[33724.928677]  [<ffffffffa0133f53>] mei_pci_suspend+0x83/0xd0 [mei]
[33724.928683]  [<ffffffff812d5ee0>] pci_pm_suspend+0x70/0x1e0
[33724.928689]  [<ffffffff8137f080>] ? device_pm_wait_for_dev+0x30/0x30
[33724.928691]  [<ffffffff812d5e70>] ? pci_pm_suspend_noirq+0x220/0x220
[33724.928693]  [<ffffffff8137f32b>] dpm_run_callback.isra.7+0x3b/0x70
[33724.928695]  [<ffffffff8137fcd1>] __device_suspend+0x101/0x270
[33724.928696]  [<ffffffff8137fe5f>] async_suspend+0x1f/0xa0
[33724.928702]  [<ffffffff8106362e>] async_run_entry_fn+0x7e/0x170
[33724.928707]  [<ffffffff810568a3>] process_one_work+0x123/0x400
[33724.928709]  [<ffffffff810635b0>] ? async_synchronize_full_domain+0x20/0x20
[33724.928711]  [<ffffffff81056ede>] worker_thread+0x12e/0x2d0
[33724.928713]  [<ffffffff81056db0>] ? rescuer_thread+0x1f0/0x1f0
[33724.928715]  [<ffffffff8105c003>] kthread+0x93/0xa0
[33724.928721]  [<ffffffff8153b854>] kernel_thread_helper+0x4/0x10
[33724.928723]  [<ffffffff8105bf70>] ? flush_kthread_worker+0x80/0x80
[33724.928725]  [<ffffffff8153b850>] ? gs_change+0xb/0xb
--

[33726.729315] mei 0000:00:16.0: irq 48 for MSI/MSI-X
[33726.729373] genirq: Threaded irq requested with handler=NULL and !ONESHOT 
for irq 48
[33726.729383] mei 0000:00:16.0: request_threaded_irq failed: irq = 48.
[33726.729390] dpm_run_callback(): pci_pm_resume+0x0/0x140 returns -22
[33726.729391] PM: Device 0000:00:16.0 failed to resume async: error -22

I also noticed that /proc/interrupts does not list irq 48 nor mei anymore.

lspci
00:16.0 Communication controller [0780]: Intel Corporation 5 Series/3400 
Series Chipset HECI Controller [8086:3b64] (rev 06)

Hopefully it helps you debugging it. If you need more information, feel free 
to ask.

Regards,
Peter

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117Ab1LAKzq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 05:55:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52615 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751878Ab1LAKzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 05:55:43 -0500
Date: Thu, 1 Dec 2011 11:55:38 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, Yong Zhang <yong.zhang0@gmail.com>
Subject: Re: [3.2-rc3] 100% CPU usage while in del_timer_sync from
 iwl3945_rs_free_sta
Message-ID: <20111201105538.GA4504@tiehlicka.suse.cz>
References: <20111129100727.GD2675@tiehlicka.suse.cz>
 <20111129113906.GA7299@redhat.com>
 <20111130101028.GA2906@tiehlicka.suse.cz>
 <20111130142316.GA2466@redhat.com>
 <20111130140316.GA4153@tiehlicka.suse.cz>
 <20111130153929.GA2144@redhat.com>
 <20111201085845.GA4602@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111201085845.GA4602@tiehlicka.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 01-12-11 09:58:45, Michal Hocko wrote:
[...]
> I will try to turn on timer debugging suggested by Yong Zhang in other
> email.

OK, so applied the following commits:
$ git shortlog master..
Christine Chan (2):
      timer: Use debugobjects to catch deletion of uninitialized timers
      debugobjects: Extend to assert that an object is initialized

Michal Hocko (1):
      Debugging patch

Stephen Boyd (2):
      timer: Setup uninitialized timer with a stub callback
      debugobjects: Be smarter about static objects

Debugging patch is the one from Stanislaw posted earlier in the thread.
It prevents del_timer_sync and warns on NULL timer in iwl3945_rs_free_sta.
Also turned on the suggested DEBUG_OBJECTS_TIMERS.

I do not see any timer related warnings. I will try it with the slightly
modified Debugging patch and just warn without returning before calling
del_timer_sync.

[...]
[  305.800081] iwl3945_rs_alloc_sta rs_sta f4be1ac0
[  305.800091] ieee80211 phy0: Allocated STA 00:0b:6b:3c:8c:e4
[  305.800098] ieee80211 phy0: Inserted dummy STA 00:0b:6b:3c:8c:e4
[  305.800112] ieee80211 phy0: device no longer idle - working
[  305.800120] wlan0: associate with 00:0b:6b:3c:8c:e4 (try 1)
[  305.807868] wlan0: RX ReassocResp from 00:0b:6b:3c:8c:e4 (capab=0x431 status=0 aid=1)
[  305.807878] wlan0: associated
[  305.808067] ieee80211 phy0: Inserted STA 00:0b:6b:3c:8c:e4
[  305.808081] ieee80211 phy0: WMM queue=2 aci=0 acm=0 aifs=2 cWmin=7 cWmax=1023 txop=64 uapsd=0
[  305.808095] ieee80211 phy0: WMM queue=3 aci=1 acm=0 aifs=7 cWmin=15 cWmax=1023 txop=0 uapsd=0
[  305.808108] ieee80211 phy0: WMM queue=1 aci=2 acm=0 aifs=2 cWmin=7 cWmax=15 txop=94 uapsd=0
[  305.808121] ieee80211 phy0: WMM queue=0 aci=3 acm=0 aifs=2 cWmin=3 cWmax=7 txop=47 uapsd=0
[  316.368064] wlan0: no IPv6 routers present
[  339.387891] PM: Syncing filesystems ... done.
[  339.480244] PM: Preparing system for mem sleep
[  340.735244] Freezing user space processes ... (elapsed 0.01 seconds) done.
[  340.752248] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[  340.772279] PM: Entering mem sleep
[  340.909961] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  340.915156] sd 0:0:0:0: [sda] Stopping disk
[  340.959367] serial 00:0a: disabled
[  340.963655] serial 00:0a: wake-up capability disabled by ACPI
[  340.968461] PIIX_IDE 0000:00:1f.1: PCI INT A disabled
[  340.970913] ehci_hcd 0000:00:1d.7: PCI INT A disabled
[  340.972114] uhci_hcd 0000:00:1d.3: PCI INT D disabled
[  340.972127] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[  340.972140] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[  340.972152] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[  340.982942] i915 0000:00:02.0: PCI INT A disabled
[  341.276198] snd_hda_intel 0000:00:1b.0: PCI INT A disabled
[  341.376137] snd_hda_intel 0000:00:1b.0: power state changed by ACPI to D3
[  342.922781] ata_piix 0000:00:1f.2: PCI INT B disabled
[  343.024183] PM: suspend of devices complete after 2247.084 msecs
[  343.128551] sky2 0000:02:00.0: PME# enabled
[  343.218047] sky2 0000:02:00.0: wake-up capability enabled by ACPI
[  343.464325] ehci_hcd 0000:00:1d.7: PME# enabled
[  343.554551] ehci_hcd 0000:00:1d.7: wake-up capability enabled by ACPI
[  343.660211] uhci_hcd 0000:00:1d.3: wake-up capability enabled by ACPI
[  343.748740] uhci_hcd 0000:00:1d.2: wake-up capability enabled by ACPI
[  343.837261] uhci_hcd 0000:00:1d.1: wake-up capability enabled by ACPI
[  343.925774] uhci_hcd 0000:00:1d.0: wake-up capability enabled by ACPI
[  344.012708] PM: late suspend of devices complete after 900.012 msecs
[  344.099624] ACPI: Preparing to enter system sleep state S3
[  344.186393] PM: Saving platform NVS memory
[  344.272082] Disabling non-boot CPUs ...
[  344.460060] CPU 1 is now offline
[  344.543874] ACPI: Low-level resume complete
[  344.543874] PM: Restoring platform NVS memory
[  344.543874] Enabling non-boot CPUs ...
[  344.554434] Booting Node 0 Processor 1 APIC 0x1
[  344.558267] smpboot cpu 1: start_ip = 9b000
[  344.358012] Initializing CPU#1
[  344.358012] Calibrating delay loop (skipped) already calibrated this CPU
[  344.580289] CPU1 is up
[  344.593922] ACPI: Waking up from system sleep state S3
[  344.598517] i915 0000:00:02.0: restoring config space at offset 0xf (was 0x100, writing 0x10b)
[  344.600866] pci 0000:00:02.1: restoring config space at offset 0x1 (was 0x900000, writing 0x900007)
[  344.603204] snd_hda_intel 0000:00:1b.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
[  344.606598] snd_hda_intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100006, writing 0x100002)
[  344.609076] pci 0000:00:1c.0: restoring config space at offset 0xf (was 0x40100, writing 0x4010b)
[  344.611429] pci 0000:00:1c.0: restoring config space at offset 0x9 (was 0x10001, writing 0x80c180a1)
[  344.613759] pci 0000:00:1c.0: restoring config space at offset 0x8 (was 0x0, writing 0xf000f000)
[  344.616070] pci 0000:00:1c.0: restoring config space at offset 0x7 (was 0x20000000, writing 0x20002020)
[  344.618358] pci 0000:00:1c.0: restoring config space at offset 0x6 (was 0x0, writing 0x20200)
[  344.620666] pci 0000:00:1c.0: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
[  344.622936] pci 0000:00:1c.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100007)
[  344.625217] pci 0000:00:1c.1: restoring config space at offset 0xf (was 0x40200, writing 0x4020b)
[  344.627483] pci 0000:00:1c.1: restoring config space at offset 0x9 (was 0x10001, writing 0x80918081)
[  344.629779] pci 0000:00:1c.1: restoring config space at offset 0x8 (was 0x0, writing 0x80708060)
[  344.632079] pci 0000:00:1c.1: restoring config space at offset 0x7 (was 0x20000000, writing 0x20005050)
[  344.634367] pci 0000:00:1c.1: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
[  344.636633] pci 0000:00:1c.1: restoring config space at offset 0x1 (was 0x100000, writing 0x100007)
[  344.638923] pci 0000:00:1c.2: restoring config space at offset 0xf (was 0x40300, writing 0x4030b)
[  344.641200] pci 0000:00:1c.2: restoring config space at offset 0x9 (was 0x10001, writing 0x80518041)
[  344.643412] pci 0000:00:1c.2: restoring config space at offset 0x8 (was 0x0, writing 0x80308010)
[  344.645622] pci 0000:00:1c.2: restoring config space at offset 0x7 (was 0x20000000, writing 0x20004040)
[  344.647810] pci 0000:00:1c.2: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
[  344.650002] pci 0000:00:1c.2: restoring config space at offset 0x1 (was 0x100000, writing 0x100007)
[  344.652223] uhci_hcd 0000:00:1d.0: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
[  344.654461] uhci_hcd 0000:00:1d.0: wake-up capability disabled by ACPI
[  344.656676] uhci_hcd 0000:00:1d.1: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
[  344.658924] uhci_hcd 0000:00:1d.1: wake-up capability disabled by ACPI
[  344.661154] uhci_hcd 0000:00:1d.2: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
[  344.663418] uhci_hcd 0000:00:1d.2: wake-up capability disabled by ACPI
[  344.665710] uhci_hcd 0000:00:1d.3: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
[  344.668058] uhci_hcd 0000:00:1d.3: wake-up capability disabled by ACPI
[  344.670384] ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 (was 0x2900006, writing 0x2900002)
[  344.672780] ehci_hcd 0000:00:1d.7: wake-up capability disabled by ACPI
[  344.675140] ehci_hcd 0000:00:1d.7: PME# disabled
[  344.677545] pci 0000:00:1e.0: restoring config space at offset 0x9 (was 0x10001, writing 0x87f18401)
[  344.680014] pci 0000:00:1e.0: restoring config space at offset 0x8 (was 0x0, writing 0xf020f020)
[  344.682483] pci 0000:00:1e.0: restoring config space at offset 0x7 (was 0xa2800000, writing 0xa2803030)
[  344.685001] pci 0000:00:1e.0: restoring config space at offset 0x1 (was 0x100004, writing 0x100007)
[  344.687548] PIIX_IDE 0000:00:1f.1: restoring config space at offset 0xf (was 0x100, writing 0x1ff)
[  344.690119] ata_piix 0000:00:1f.2: restoring config space at offset 0xf (was 0x200, writing 0x20b)
[  344.692848] sky2 0000:02:00.0: restoring config space at offset 0xf (was 0x100, writing 0x10b)
[  344.695461] sky2 0000:02:00.0: restoring config space at offset 0x6 (was 0x1, writing 0x2001)
[  344.697999] sky2 0000:02:00.0: restoring config space at offset 0x4 (was 0x4, writing 0xf0000004)
[  344.700491] sky2 0000:02:00.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
[  344.702963] sky2 0000:02:00.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100407)
[  344.705707] iwl3945 0000:05:00.0: restoring config space at offset 0xf (was 0x100, writing 0x10b)
[  344.708232] iwl3945 0000:05:00.0: restoring config space at offset 0x4 (was 0x0, writing 0x80100000)
[  344.710706] iwl3945 0000:05:00.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
[  344.713210] iwl3945 0000:05:00.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100406)
[  344.715819] pci 0000:08:03.0: restoring config space at offset 0xf (was 0xc00100, writing 0x1c0010b)
[  344.718384] pci 0000:08:03.0: restoring config space at offset 0xe (was 0x1, writing 0x30fd)
[  344.720917] pci 0000:08:03.0: restoring config space at offset 0xd (was 0x1, writing 0x3001)
[  344.723403] pci 0000:08:03.0: restoring config space at offset 0xc (was 0x1, writing 0x34fd)
[  344.725882] pci 0000:08:03.0: restoring config space at offset 0xb (was 0x1, writing 0x3401)
[  344.728332] pci 0000:08:03.0: restoring config space at offset 0xa (was 0x0, writing 0x8bfff000)
[  344.730758] pci 0000:08:03.0: restoring config space at offset 0x9 (was 0x0, writing 0x88000000)
[  344.733180] pci 0000:08:03.0: restoring config space at offset 0x8 (was 0x0, writing 0x87fff000)
[  344.735574] pci 0000:08:03.0: restoring config space at offset 0x7 (was 0x0, writing 0x84000000)
[  344.737980] pci 0000:08:03.0: restoring config space at offset 0x6 (was 0x0, writing 0xb00c0908)
[  344.740358] pci 0000:08:03.0: restoring config space at offset 0x4 (was 0x0, writing 0x80000000)
[  344.742715] pci 0000:08:03.0: restoring config space at offset 0x1 (was 0x4100080, writing 0x4100007)
[  344.745107] pci 0000:08:03.4: restoring config space at offset 0xf (was 0x100, writing 0x10b)
[  344.747449] pci 0000:08:03.4: restoring config space at offset 0x5 (was 0x0, writing 0xf0201000)
[  344.749778] pci 0000:08:03.4: restoring config space at offset 0x4 (was 0x0, writing 0xf0200000)
[  344.752072] pci 0000:08:03.4: restoring config space at offset 0x3 (was 0x0, writing 0x2010)
[  344.754298] pci 0000:08:03.4: restoring config space at offset 0x1 (was 0x2100080, writing 0x2100017)
[  344.756787] PM: early resume of devices complete after 158.326 msecs
[  344.759029] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[  344.761243] i915 0000:00:02.0: setting latency timer to 64
[  344.761338] pci 0000:00:1c.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[  344.761345] pci 0000:00:1c.0: setting latency timer to 64
[  344.761361] pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[  344.761367] pci 0000:00:1c.1: setting latency timer to 64
[  344.761380] pci 0000:00:1c.2: PCI INT C -> GSI 20 (level, low) -> IRQ 20
[  344.761386] pci 0000:00:1c.2: setting latency timer to 64
[  344.761401] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[  344.761409] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[  344.761439] usb usb2: root hub lost power or was reset
[  344.761460] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 20 (level, low) -> IRQ 20
[  344.761468] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[  344.761496] usb usb3: root hub lost power or was reset
[  344.761514] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[  344.761522] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[  344.761549] usb usb4: root hub lost power or was reset
[  344.761567] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[  344.761576] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[  344.761604] usb usb5: root hub lost power or was reset
[  344.761624] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[  344.761632] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[  344.761675] pci 0000:00:1e.0: setting latency timer to 64
[  344.761694] PIIX_IDE 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[  344.761700] PIIX_IDE 0000:00:1f.1: setting latency timer to 64
[  344.761723] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[  344.761730] ata_piix 0000:00:1f.2: setting latency timer to 64
[  344.762438] sky2 0000:02:00.0: wake-up capability disabled by ACPI
[  344.762462] sky2 0000:02:00.0: PME# disabled
[  344.768820] pci 0000:08:03.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[  344.769454] serial 00:0a: activated
[  344.772573] hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[  344.772828] hda: UDMA/33 mode selected
[  344.835139] sd 0:0:0:0: [sda] Starting disk
[  344.897591] render error detected, EIR: 0x00000010
[  344.899856] page table error
[  344.900004]   PGTBL_ER: 0x00000003
[  344.900004] [drm:i915_report_and_clear_eir] *ERROR* EIR stuck: 0x00000010, masking
[  344.900004] render error detected, EIR: 0x00000010
[  344.900004] page table error
[  344.900004]   PGTBL_ER: 0x00000003
[  345.168077] usb 5-2: reset full-speed USB device number 3 using uhci_hcd
[  345.260090] snd_hda_intel 0000:00:1b.0: power state changed by ACPI to D0
[  345.263106] snd_hda_intel 0000:00:1b.0: power state changed by ACPI to D0
[  345.266113] snd_hda_intel 0000:00:1b.0: power state changed by ACPI to D0
[  345.269115] snd_hda_intel 0000:00:1b.0: power state changed by ACPI to D0
[  345.271430] snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[  345.273684] snd_hda_intel 0000:00:1b.0: setting latency timer to 64
[  345.275966] snd_hda_intel 0000:00:1b.0: irq 41 for MSI/MSI-X
[  345.572088] usb 2-2: reset low-speed USB device number 2 using uhci_hcd
[  346.608301] ata1.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
[  346.611333] ata1.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) filtered out
[  346.614399] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[  346.632440] ata1.00: configured for UDMA/133
[  346.744496] PM: resume of devices complete after 1985.491 msecs
[  346.747333] PM: Finishing wakeup.
[  346.749785] Restarting tasks ... done.
[  346.789225] video LNXVIDEO:00: Restoring backlight state
[  347.244077] ieee80211 phy0: wlan0: No probe response from AP 00:0b:6b:3c:8c:e4 after 500ms, try 1/5
[  347.744100] ieee80211 phy0: wlan0: No probe response from AP 00:0b:6b:3c:8c:e4 after 500ms, try 2/5
[  348.004058] wlan0: detected beacon loss from AP - sending probe request
[  348.244038] ieee80211 phy0: wlan0: No probe response from AP 00:0b:6b:3c:8c:e4 after 500ms, try 3/5
[  348.744062] ieee80211 phy0: wlan0: No probe response from AP 00:0b:6b:3c:8c:e4 after 500ms, try 4/5
[  349.244066] ieee80211 phy0: wlan0: No probe response from AP 00:0b:6b:3c:8c:e4 after 500ms, disconnecting.
[  349.316045] ieee80211 phy0: Removed STA 00:0b:6b:3c:8c:e4
[  349.316070] iwl3945_rs_free_sta rs_sta f4be1ac0
[  349.316076] ------------[ cut here ]------------
[  349.316097] WARNING: at drivers/net/wireless/iwlegacy/iwl-3945-rs.c:438 iwl3945_rs_free_sta+0x33/0x42 [iwl3945]()
[  349.316105] Hardware name: LIFEBOOK S7110
[  349.316110] Modules linked in: aes_i586 aes_generic i915 fbcon font bitblit softcursor drm_kms_helper drm fb fbdev i2c_algo_bit cfbcopyarea i2c_core cfbimgblt cfbfillrect fuse tun coretemp hwmon snd_hda_codec_realtek arc4 snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss iwl3945 snd_pcm iwl_legacy snd_seq_oss snd_seq_midi_event mac80211 snd_seq snd_timer snd_seq_device cfg80211 snd video snd_page_alloc fujitsu_laptop backlight [last unloaded: scsi_wait_scan]
[  349.316203] Pid: 12, comm: kworker/u:1 Tainted: G        W    3.2.0-rc3-timerstest-00009-g762dd0e #20
[  349.316209] Call Trace:
[  349.316223]  [<c01331b4>] warn_slowpath_common+0x68/0x7d
[  349.316237]  [<f8169454>] ? iwl3945_rs_free_sta+0x33/0x42 [iwl3945]
[  349.316247]  [<c01331dd>] warn_slowpath_null+0x14/0x18
[  349.316260]  [<f8169454>] iwl3945_rs_free_sta+0x33/0x42 [iwl3945]
[  349.316283]  [<f8102f94>] __sta_info_free.isra.24+0x28/0x60 [mac80211]
[  349.316304]  [<f8103df9>] __sta_info_destroy+0x259/0x283 [mac80211]
[  349.316328]  [<f8104194>] sta_info_flush+0x43/0x6e [mac80211]
[  349.316353]  [<f8109453>] ieee80211_set_disassoc+0x1a3/0x1d7 [mac80211]
[  349.316379]  [<f81095e8>] ieee80211_sta_connection_lost+0x31/0x8a [mac80211]
[  349.316390]  [<c031208f>] ? dev_printk+0x2b/0x2d
[  349.316416]  [<f810bde2>] ieee80211_sta_work+0x1b0/0x1c3 [mac80211]
[  349.316446]  [<f810e38a>] ieee80211_iface_work+0x23e/0x250 [mac80211]
[  349.316457]  [<c01468af>] process_one_work+0x19b/0x2e6
[  349.316483]  [<f810e14c>] ? ieee80211_netdev_select_queue+0x14/0x14 [mac80211]
[  349.316492]  [<c0146ddd>] worker_thread+0x136/0x1ee
[  349.316501]  [<c0146ca7>] ? manage_workers.isra.23+0x14f/0x14f
[  349.316509]  [<c014a0f5>] kthread+0x67/0x6c
[  349.316517]  [<c014a08e>] ? kthread_worker_fn+0x119/0x119
[  349.316527]  [<c04762f6>] kernel_thread_helper+0x6/0x10
[  349.316532] ---[ end trace 5cf96275a244e7ca ]---
[  349.316538] ieee80211 phy0: Destroyed STA 00:0b:6b:3c:8c:e4
[  349.316556] ieee80211 phy0: device now idle
[  349.328105] cfg80211: Calling CRDA to update world regulatory domain
[  349.416952] ieee80211 phy0: device no longer idle - scanning
[  353.091211] ieee80211 phy0: device now idle
[  358.092230] ieee80211 phy0: device no longer idle - scanning
[  361.772470] ieee80211 phy0: device now idle
[  366.774826] ieee80211 phy0: device no longer idle - scanning
[  370.448401] ieee80211 phy0: device now idle
[  375.455127] ieee80211 phy0: device no longer idle - scanning
[  379.127638] ieee80211 phy0: device now idle
[  384.131847] ieee80211 phy0: device no longer idle - scanning
[  387.806711] ieee80211 phy0: device now idle
[  396.708125] sky2 0000:02:00.0: lan0: Link is up at 1000 Mbps, full duplex, flow control both
[  407.120063] lan0: no IPv6 routers present
[  434.003896] ieee80211 phy0: device no longer idle - scanning
[  438.694843] ieee80211 phy0: device now idle
[  441.485602] process `skype' is using obsolete setsockopt SO_BSDCOMPAT
[  494.004619] ieee80211 phy0: device no longer idle - scanning
[  498.698796] ieee80211 phy0: device now idle
[  554.004822] ieee80211 phy0: device no longer idle - scanning
[  558.697908] ieee80211 phy0: device now idle
[  614.003956] ieee80211 phy0: device no longer idle - scanning
[  618.700408] ieee80211 phy0: device now idle
[  674.004164] ieee80211 phy0: device no longer idle - scanning
[  678.702423] ieee80211 phy0: device now idle

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic

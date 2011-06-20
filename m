Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab1FTKeN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 06:34:13 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52691 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920Ab1FTKeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 06:34:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=O2BeZaruHmlWM4ZuJB4zzoFQCpiv4DC/OqdAU+tR3BbG1+Tx6npdfJGQjbFVebEWhn
         Yy94Ep7RtkFPDLFA8Dw0nS6/P3iCefz/62XGuXI+Flhdns0AvfUvWpq5u5+fYr7mD+zj
         1ObbcNejdDeMMPGuWlCYDBLUzfbdx+/e2FNsU=
Message-ID: <4DFF221E.6010901@googlemail.com>
Date: Mon, 20 Jun 2011 11:34:06 +0100
From: Alan Jenkins <alan.christopher.jenkins@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        "ath5k-devel@lists.ath5k.org" <ath5k-devel@venema.h4ckr.net>
Subject: Re: [ath5k] OOPS bisected - ath5k_eeprom_init_header() - "XX: This
 value is likely too big still, waiting on a better value"
References: <4DFF2156.4000100@googlemail.com>
In-Reply-To: <4DFF2156.4000100@googlemail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Removed "XXX" from subject in order to get past VGER spam filter]

On 20/06/11 11:30, Alan Jenkins wrote:
> ## Summary of bug report ##
> Confidence: high.
> (Bisected.  Crash message captured, see end of message).
>
> Severity: low.
> (Users can easily avoid the trigger for this crash).
>
>
> ## Scenario: ##
> Asus EeePC 701.
> Wireless-toggle button, implemented in firmware, disables / enables 
> the entire PCI slot.  (See platform driver eeepc-laptop).
>
> ## Expected results: ##
> Ath5k (like any other PCI driver), must tolerate removal of PCI 
> devices without warning, and *never crash*.
>
> ## Actual results: ##
> Ath5k generally handles removal very well, but crashes in a corner 
> case.  This is a regression introduced by v2.6.33 (commit commit 
> 359207c687cc8f4f9845c8dadd0d6dabad44e584 "ath5k: Fix eeprom checksum 
> check for custom sized eeproms").
>
> ## How to reproduce: ##
> Repeatedly press the wireless-toggle button as fast as you can.  It 
> shouldn't take more than about 20 presses before the OOPS occurs.
>
>
> ## Results of git-bisect ##
>
> commit 359207c687cc8f4f9845c8dadd0d6dabad44e584
> Author: Luis R. Rodriguez <lrodriguez@atheros.com>
> Date:   Mon Jan 4 10:40:39 2010 -0500
>
>     ath5k: Fix eeprom checksum check for custom sized eeproms
>
>     Commit 8bf3d79bc401ca417ccf9fc076d3295d1a71dbf5 enabled EEPROM
>     checksum checks to avoid bogus bug reports but failed to address
>     updating the code to consider devices with custom EEPROM sizes.
>     Devices with custom sized EEPROMs have the upper limit size stuffed
>     in the EEPROM. Use this as the upper limit instead of the static
>     default size. In case of a checksum error also provide back the
>     max size and whether or not this was the default size or a custom
>     one. If the EEPROM is busted we add a failsafe check to ensure
>     we don't loop forever or try to read bogus areas of hardware.
>
>     This closes bug 14874
>
>     http://bugzilla.kernel.org/show_bug.cgi?id=14874
>
>     Cc: stable@kernel.org
>     Cc: David Quan <david.quan@atheros.com>
>     Cc: Stephen Beahm <stephenbeahm@comcast.net>
>     Reported-by: Joshua Covington <joshuacov@googlemail.com>
>     Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>     Signed-off-by: John W. Linville <linville@tuxdriver.com>
>
> ...
>
> -       for (cksum = 0, offset = 0; offset < AR5K_EEPROM_INFO_MAX; 
> offset++) {
> +       AR5K_EEPROM_READ(AR5K_EEPROM_SIZE_UPPER, val);
> +       if (val) {
> +               eep_max = (val & AR5K_EEPROM_SIZE_UPPER_MASK) <<
> +                          AR5K_EEPROM_SIZE_ENDLOC_SHIFT;
> +               AR5K_EEPROM_READ(AR5K_EEPROM_SIZE_LOWER, val);
> +               eep_max = (eep_max | val) - AR5K_EEPROM_INFO_BASE;
> +
> +               /*
> +                * Fail safe check to prevent stupid loops due
> +                * to busted EEPROMs. XXX: This value is likely too
> +                * big still, waiting on a better value.
> +                */
> +               if (eep_max > (3 * AR5K_EEPROM_INFO_MAX)) {
> +                       ATH5K_ERR(ah->ah_sc, "Invalid max custom 
> EEPROM size: "
> +                                 "%d (0x%04x) max expected: %d 
> (0x%04x)\n",
> +                                 eep_max, eep_max,
> +                                 3 * AR5K_EEPROM_INFO_MAX,
> +                                 3 * AR5K_EEPROM_INFO_MAX);
> +                       return -EIO;
> +               }
> +       }
> +
> +       for (cksum = 0, offset = 0; offset < eep_max; offset++) {
>
>
> ### Example OOPS message ###
>
> pci 0000:01:00.0: reg 10: [mem 0x00000000-0x0000ffff 64bit]
> pci 0000:01:00.0: BAR 0: assigned [mem 0xf8000000-0xf800ffff 64bit]
> pci 0000:01:00.0: BAR 0: set to [mem 0xf8000000-0xf800ffff 64bit] (PCI 
> address [0xf8000000-0xf800ffff]
> ath5k 0000:01:00.0: enabling device (0000 -> 0002)
> ath5k 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
> ath5k 0000:01:00.0: setting latency timer to 64
> ath5k 0000:01:00.0: registered as 'phy9'
> BUG: unable to handle kernel paging request at 1ef700e0
> IP: [<c05a098c>] iowrite32+0xd/0x30
> *pde = 00000000
> Oops: 0002 [#1] SMP
> last sysfs file: /sys/devices/platform/eeepc/rfkill/rfkill0/uevent
> Modules linked in: aes_i586 aes_generic snd_hda_codec_realtek arc4 ecb 
> snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device 
> ip6t_REJECT ath5k snd_pcm nf_conntrack_ipv6 mac80211 uvcvideo iTCO_wdt 
> ip6table_filter ath iTCO_vendor_support videodev snd_timer 
> eeepc_laptop microcode ip6_tables v4l1_compat joydev i2c_i801 cfg80211 
> snd sparse_keymap atl2 rfkill soundcore snd_page_alloc ipv6 autofs4 
> i915 drm_kms_helper drm usb_storage i2c_algo_bit i2c_core video output
>
> Pid: 17, comm: kacpi_notify Not tainted 2.6.33.3-85.fc13.i686 #1 701/701
> EIP: 0060:[<c05a098c>] EFLAGS: 00010216 CPU: 0
> EIP is at iowrite32+0xd/0x30
> EAX: 00000020 EBX: de324000 ECX: 1ef700e0 EDX: 1ef700e0
> ESI: 00000020 EDI: decabdba EBP: decabd90 ESP: decabd90
>  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> Process kacpi_notify (pid: 17, ti=decaa000 task=dec84c80 
> task.ti=decaa000)
> Stack:
>  decabda4 e08af61e de0e0a40 00000007 decabdba decabdc8 e08af6df decabe3a
> <0> de324000 00000000 00000000 de0e0a40 00000007 decabe38 decabe54 
> e08c041c
> <0> 0000000c decabe1c 0000000c e09a0000 de325680 def6a500 1ef6a500 
> de324000
> Call Trace:
>  [<e08af61e>] ? ath5k_hw_eeprom_read+0x80/0x116 [ath5k]
>  [<e08af6df>] ? ath5k_eeprom_read_mac+0x2b/0x8f [ath5k]
>  [<e08c041c>] ? ath5k_pci_probe+0xbd4/0x1115 [ath5k]
>  [<c05ab416>] ? local_pci_probe+0xe/0x10
>  [<c05abdef>] ? pci_device_probe+0x43/0x66
>  [<c062e3f6>] ? driver_probe_device+0xc5/0x1cd
>  [<c062e587>] ? __device_attach+0x2a/0x2e
>  [<c062d832>] ? bus_for_each_drv+0x3d/0x67
>  [<c062e5f6>] ? device_attach+0x4c/0x6c
>  [<c062e55d>] ? __device_attach+0x0/0x2e
>  [<c062d697>] ? bus_probe_device+0x18/0x2d
>  [<c062c31f>] ? device_add+0x30d/0x49c
>  [<c075f8ea>] ? pci_bus_assign_resources+0xac/0x3a7
>  [<c05a723d>] ? pci_device_add+0xca/0xce
>  [<c05a6f26>] ? pci_bus_add_device+0xf/0x30
>  [<e07480df>] ? eeepc_rfkill_hotplug+0x87/0xc0 [eeepc_laptop]
>  [<e0748126>] ? eeepc_rfkill_notify+0xe/0x10 [eeepc_laptop]
>  [<c05df721>] ? acpi_ev_notify_dispatch+0x4f/0x5a
>  [<c05d205d>] ? acpi_os_execute_deferred+0x1d/0x28
>  [<c0448d63>] ? worker_thread+0x13b/0x1b4
>  [<c05d2040>] ? acpi_os_execute_deferred+0x0/0x28
>  [<c044bd89>] ? autoremove_wake_function+0x0/0x2f
>  [<c0448c28>] ? worker_thread+0x0/0x1b4
>  [<c044ba47>] ? kthread+0x5f/0x64
>  [<c044b9e8>] ? kthread+0x0/0x64
>  [<c040383e>] ? kernel_thread_helper+0x6/0x10
> Code: 00 76 0d 25 ff ff 00 00 89 d7 89 c2 f3 6c eb 0a ba ad 60 8b c0 
> e8 4e fe ff ff 5b 5f 5d c3 55 81 fa ff ff 03 00 89 e5 89 d1 76 04 <89> 
> 02 eb 1d 81 fa 00 00 01 00 76 09 81 e2 ff ff 00 00 ef eb 0c
> EIP: [<c05a098c>] iowrite32+0xd/0x30 SS:ESP 0068:decabd90
> CR2: 000000001ef700e0
> ---[ end trace 2761b2bae95de764 ]---
>
> ## Analysis ##
>
> When the card is disabled, reads will return with all bits set.  So we 
> think the EEPROM is of maximum size, and we end up reading outside the 
> memory mapping for the device?
>
> There are two obvious solutions -
>
> 1. Bounds-check the size read from the EEPROM against the appropriate 
> memory mapping.
> 2. Check for "all ones" when reading the size of the EEPROM.
>
>
> I have a feeling the bounds-checking is more annoying than it sounds.  
> When I looked at ath5k_hw_eeprom_read(), I saw two types of hardware.  
> In one, the EEPROM was mapped directly into PCI space, which is what 
> seems to be happening here.  In other hardware, the access was 
> indirected through just a couple of registers at fixed addresses - in 
> this case the ROM could be bigger than the PCI space.
>
> The second option is a bit of a hack though, especially considering 
> the "XXX:" comment.
>
>
> Best wishes
> Alan


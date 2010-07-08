Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413Ab0GHHhp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 03:37:45 -0400
Received: from t03.superonline.com ([92.45.6.169]:3588 "EHLO
	smtpout1.superonline.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751614Ab0GHHho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 03:37:44 -0400
Message-ID: <4C35803E.4080003@superonline.com>
Date: Thu, 08 Jul 2010 10:37:34 +0300
From: "M. Vefa Bicakci" <bicave@superonline.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100619 Icedove/3.0.5
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [Possible regression] i915 GEM related oops since 2.6.34.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SMTP-Filter: SurGATE SMTP Filter Engine Release 2.1 ($Revision: 184 $) http://www.endersys.com
X-SurGATE-Result: Clean (Content eval: 0.00 points)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am using an up-to-date Debian Sid installation on a Toshiba
Satellite A100 laptop with an Intel graphics card.

Since upgrading to 2.6.34.1, I have gotten the oops below twice,
each on different days. In both instances, the oops occurred at
an unexpected moment, when I was just moving the mouse. The oops
causes X to be unusable - whatever is on the display simply freezes
- and I have to use the magic Sys-Rq key to switch the keyboard mode
and blindly use the virtual terminal to reboot.

I haven't had this problem with 2.6.34, and after seeing the same
oops twice, I thought I should report it.

The only modification I made to the vanilla 2.6.34.1 source is the
following commit. (I had this modification applied to 2.6.34 as
well, and haven't had this oops before.)

=== 8< ===
commit 985b823b919273fe1327d56d2196b4f92e5d0fae
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri Jul 2 10:04:42 2010 +1000

    drm/i915: fix hibernation since i915 self-reclaim fixes
    
    Since commit 4bdadb9785696439c6e2b3efe34aa76df1149c83 ("drm/i915:
    Selectively enable self-reclaim"), we've been passing GFP_MOVABLE to the
    i915 page allocator where we weren't before due to some over-eager
    removal of the page mapping gfp_flags games the code used to play.
    
    This caused hibernate on Intel hardware to result in a lot of memory
    corruptions on resume.  See for example
    
      http://bugzilla.kernel.org/show_bug.cgi?id=13811
=== >8 ===


Here's the oops itself:

=== 8< ===
BUG: unable to handle kernel paging request at 00aaaaaa
IP: [<f844a4f2>] drm_ht_insert_item+0x22/0xa0 [drm]
*pde = 00000000 
Oops: 0000 [#1] PREEMPT SMP 
last sysfs file: /sys/devices/virtual/net/vboxnet0/statistics/collisions
Modules linked in: ext4 jbd2 ecryptfs vboxnetadp vboxnetflt vboxdrv cpufreq_powersave cpufreq_performance kvm_intel cpufreq_conservative kvm cpufreq_ondemand cpufreq_stats parport_pc ppdev lp parport sco bridge stp bnep rfcomm l2cap crc16 af_packet binfmt_misc uinput fuse ip6table_filter ip6_tables nf_conntrack_irc nf_conntrack_ftp ipt_addrtype xt_tcpudp ipt_ULOG xt_limit xt_state nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter ip_tables x_tables acpi_cpufreq freq_table snd_hda_codec_si3054 snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event arc4 ecb snd_seq snd_timer iwl3945 snd_seq_device iwlcore pcmcia btusb snd soundcore bluetooth snd_page_alloc joydev yenta_socket mac80211 rsrc_nonstatic tifm_7xx1 tifm_core i2c_i801 pcmcia_core cfg80211 rng_core tpm_tis rtc_cmos rfkill ac battery container tpm psmouse rtc_core rtc_lib tpm_bios processor pc
uetooth evdev serio_raw ext3 jbd mbcache cbc sha256_generic serpent aes_i586 aes_generic dm_crypt dm_mod sg sd_mod sr_mod cdrom ata_generic pata_acpi i915 drm_kms_helper ata_piix sdhci_pci sdhci drm i2c_algo_bit firewire_ohci fan mmc_core i2c_core uhci_hcd libata firewire_core led_class crc_itu_t e100 mii ehci_hcd button usbcore nls_base video output scsi_mod thermal intel_agp [last unloaded: scsi_wait_scan]

Pid: 26809, comm: Xorg Not tainted 2.6.34.1-1a #1 CAPELL VALLEY(NAPA) CRB/Satellite A100
EIP: 0060:[<f844a4f2>] EFLAGS: 00213206 CPU: 1
EIP is at drm_ht_insert_item+0x22/0xa0 [drm]
EAX: f6a18aa0 EBX: 001092d0 ECX: 0000000d EDX: f63f8bb8
ESI: f8738810 EDI: 00aaaaaa EBP: f6901000 ESP: f6003e04
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process Xorg (pid: 26809, ti=f6002000 task=f5cd4000 task.ti=f6002000)
Stack:
 f5c35300 f6003e74 f6a18a80 f851f2cd 00000000 f851c9a9 00000000 f63f8ba0
<0> f69e1c14 f65f4400 f69e1c00 c0106464 00000064 f8443166 00000001 f8452f54
<0> f84524f6 f8453f3c 000068b9 c0106464 00000064 0000e200 00000001 f6003e74
Call Trace:
 [<f851f2cd>] ? i915_gem_mmap_gtt_ioctl+0x15d/0x270 [i915]
 [<f851c9a9>] ? i915_gem_busy_ioctl+0x59/0xa0 [i915]
 [<c0106464>] ? flush_ldt+0x34/0x60
 [<f8443166>] ? drm_ioctl+0x166/0x370 [drm]
 [<c0106464>] ? flush_ldt+0x34/0x60
 [<f851f170>] ? i915_gem_mmap_gtt_ioctl+0x0/0x270 [i915]
 [<c01c9045>] ? do_sync_read+0xb5/0xf0
 [<c01aa725>] ? handle_mm_fault+0x235/0xaf0
 [<c0106464>] ? flush_ldt+0x34/0x60
 [<f8443000>] ? drm_ioctl+0x0/0x370 [drm]
 [<c01d662b>] ? vfs_ioctl+0x2b/0xa0
 [<c01d680b>] ? do_vfs_ioctl+0x7b/0x5d0
 [<c01c90e6>] ? rw_verify_area+0x66/0xe0
 [<c01c9dae>] ? vfs_read+0x11e/0x190
 [<c0106464>] ? flush_ldt+0x34/0x60
 [<c01d6dd6>] ? sys_ioctl+0x76/0x90
 [<c0103758>] ? sysenter_do_call+0x12/0x28
 [<c0106464>] ? flush_ldt+0x34/0x60
Code: 90 90 90 90 90 90 90 90 90 57 b9 20 00 00 00 56 53 8b 5a 08 2b 48 04 69 f3 01 00 37 9e d3 ee c1 e6 02 03 70 0c 8b 3e 85 ff 74 57 <8b> 07 0f 18 00 90 8b 4f 08 39 d9 74 41 39 cb 73 1a eb 55 8d 76 
EIP: [<f844a4f2>] drm_ht_insert_item+0x22/0xa0 [drm] SS:ESP 0068:f6003e04
CR2: 0000000000aaaaaa
---[ end trace 72d1054f02893a7f ]---

=== >8 ===

Regards,

M. Vefa Bicakci

Note: As I am not subscribed to the mailing list, I would appreciate it
if you could include me in the CC list.

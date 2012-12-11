Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab2LKSnA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 13:43:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23240 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753317Ab2LKSm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 13:42:58 -0500
Date: Tue, 11 Dec 2012 13:42:56 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: dzickus@redhat.com
Subject: 3.7 watchdog debugobjects warning
Message-ID: <20121211184256.GA22068@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, dzickus@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like we're doing a double-init on a timer.

I had been experimenting with powertop, so that may have triggered something
maybe suspend/resume related ?

(says -rc8, but it's only missing the Makefile change)

[14844.560489] WARNING: at lib/debugobjects.c:261 debug_print_object+0x8c/0xb0()
[14844.560919] Hardware name: 2356JK8
[14844.561133] ODEBUG: init active (active state 0) object type: hrtimer hint: watchdog_timer_fn+0x0/0x190
[14844.561689] Modules linked in: bluetooth cpufreq_stats iptable_mangle nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack dm_crypt xfs arc4 iwldvm coretemp kvm_intel mac80211 kvm snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec crc32c_intel iTCO_wdt iTCO_vendor_support snd_hwdep ghash_clmulni_intel snd_seq iwlwifi microcode snd_seq_device pcspkr i2c_i801 snd_pcm cfg80211 tpm_tis e1000e thinkpad_acpi snd_page_alloc lpc_ich snd_timer mfd_core snd soundcore tpm tpm_bios nfsd auth_rpcgss nfs_acl lockd sunrpc btrfs libcrc32c zlib_deflate i915 i2c_algo_bit drm_kms_helper drm i2c_core video
[14844.565462] Pid: 14, comm: watchdog/0 Not tainted 3.7.0-rc8+ #4
[14844.565818] Call Trace:
[14844.565978]  [<ffffffff810529bf>] warn_slowpath_common+0x7f/0xc0
[14844.566342]  [<ffffffff81052ab6>] warn_slowpath_fmt+0x46/0x50
[14844.566690]  [<ffffffff8134a0ec>] debug_print_object+0x8c/0xb0
[14844.567039]  [<ffffffff81104610>] ? watchdog+0x30/0x30
[14844.567353]  [<ffffffff8134a3df>] __debug_object_init+0x20f/0x3e0
[14844.567721]  [<ffffffff816a63b9>] ? __schedule+0x479/0xa00
[14844.568055]  [<ffffffff8134a5cb>] debug_object_init+0x1b/0x20
[14844.568406]  [<ffffffff81086782>] hrtimer_init+0x32/0x180
[14844.568735]  [<ffffffff811048f5>] watchdog_enable+0x85/0x200
[14844.569078]  [<ffffffff810956a1>] ? get_parent_ip+0x11/0x50
[14844.569416]  [<ffffffff8108cd2c>] smpboot_thread_fn+0x10c/0x300
[14844.569771]  [<ffffffff8108cc20>] ? __smpboot_create_thread.part.2+0xc0/0xc0
[14844.570193]  [<ffffffff81081a7d>] kthread+0xed/0x100
[14844.570496]  [<ffffffff816a5df5>] ? wait_for_common+0x135/0x180
[14844.570850]  [<ffffffff81081990>] ? kthread_create_on_node+0x160/0x160
[14844.571243]  [<ffffffff816b0d6c>] ret_from_fork+0x7c/0xb0
[14844.571570]  [<ffffffff81081990>] ? kthread_create_on_node+0x160/0x160
[14844.571960] ---[ end trace 482f8371e46ff84f ]---


Sidenote: At this point, the output in dmesg goes crazy.  Would adding some KERN_CONT's
have fixed this ?



[14844.572807] ------------[ cut here ]------------
[14844.573099] WARNING: at lib/debugobjects.c:261 debug_print_object+0x8c/0xb0()
[14844.573529] Hardware name: 2356JK8
[14844.573751] ODEBUG: init active (active state 0) object type: hrtimer hint: watchdog_timer_fn+0x0/0x190
[14844.576953] ------------[ cut here ]------------
[14844.576958] WARNING: at lib/debugobjects.c:261 debug_print_object+0x8c/0xb0()
[14844.576959] Hardware name: 2356JK8
[14844.576962] ODEBUG: init active (active state 0) object type: hrtimer hint: watchdog_timer_fn+0x0/0x190
[14844.574316] Modules linked in: bluetooth cpufreq_stats iptable_mangle nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack dm_crypt xfs arc4 iwldvm coretemp kvm_intel mac80211 kvm snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec crc32c_intel iTCO_wdt iTCO_vendor_support snd_hwdep ghash_clmulni_intel snd_seq iwlwifi microcode snd_seq_device pcspkr i2c_i801 snd_pcm cfg80211 tpm_tis e1000e thinkpad_acpi snd_page_alloc lpc_ich snd_timer mfd_core
[14844.576962] Modules linked in:
[14844.576963]  bluetooth
[14844.576964]  cpufreq_stats
[14844.576964]  iptable_mangle
[14844.576965]  nf_conntrack_ipv4
[14844.576966]  nf_defrag_ipv4
[14844.576966]  xt_conntrack
[14844.576967]  nf_conntrack
[14844.576968]  dm_crypt
[14844.576968]  xfs
[14844.576969]  arc4
[14844.576969]  iwldvm
[14844.576970]  coretemp
[14844.576971]  kvm_intel
[14844.576971]  mac80211
[14844.576972]  kvm
[14844.576972]  snd_hda_codec_hdmi
[14844.576973]  snd_hda_codec_realtek
[14844.576974]  snd_hda_intel
[14844.576974]  snd_hda_codec
[14844.576975]  crc32c_intel
[14844.576975]  iTCO_wdt
[14844.576976]  iTCO_vendor_support
[14844.576977]  snd_hwdep
[14844.576977]  ghash_clmulni_intel
[14844.576978]  snd_seq
[14844.576978]  iwlwifi
[14844.576979]  microcode
[14844.576980]  snd_seq_device
[14844.576980]  pcspkr
[14844.576981]  i2c_i801
[14844.576981]  snd_pcm
[14844.576982]  cfg80211
[14844.576983]  tpm_tis
[14844.576983]  e1000e
[14844.576984]  thinkpad_acpi
[14844.576984]  snd_page_alloc
[14844.576985]  lpc_ich
[14844.576985]  snd_timer
[14844.576986]  mfd_core
[14844.576987]  snd
[14844.576987]  soundcore
[14844.576988]  tpm
[14844.576989]  tpm_bios
[14844.576989]  nfsd
[14844.576990]  auth_rpcgss
[14844.576990]  nfs_acl
[14844.576991]  lockd
[14844.576992]  sunrpc
[14844.576992]  btrfs
[14844.576993]  libcrc32c
[14844.576994]  zlib_deflate
[14844.576994]  i915
[14844.576995]  i2c_algo_bit
[14844.576996]  drm_kms_helper
[14844.576996]  drm
[14844.576997]  i2c_core
[14844.576998]  video

[14844.577000] Pid: 21, comm: watchdog/2 Tainted: G        W    3.7.0-rc8+ #4
[14844.577001] Call Trace:

[14844.577005]  [<ffffffff810529bf>] warn_slowpath_common+0x7f/0xc0

[14844.577008]  [<ffffffff81052ab6>] warn_slowpath_fmt+0x46/0x50

[14844.577011]  [<ffffffff8134a0ec>] debug_print_object+0x8c/0xb0

[14844.577013]  [<ffffffff81104610>] ? watchdog+0x30/0x30

[14844.577015]  [<ffffffff8134a3df>] __debug_object_init+0x20f/0x3e0

[14844.577018]  [<ffffffff816a63b9>] ? __schedule+0x479/0xa00
[14844.577018] ------------[ cut here ]------------

[14844.577021] WARNING: at lib/debugobjects.c:261 debug_print_object+0x8c/0xb0()
[14844.577023]  [<ffffffff8134a5cb>] debug_object_init+0x1b/0x20
[14844.577023] Hardware name: 2356JK8

[14844.577026] ODEBUG: init active (active state 0) object type: hrtimer hint: watchdog_timer_fn+0x0/0x190
[14844.577028]  [<ffffffff81086782>] hrtimer_init+0x32/0x180
[14844.577029] Modules linked in:

[14844.577029]  bluetooth
[14844.577031]  [<ffffffff811048f5>] watchdog_enable+0x85/0x200
[14844.577031]  cpufreq_stats

[14844.577032]  iptable_mangle
[14844.577034]  [<ffffffff810956a1>] ? get_parent_ip+0x11/0x50
[14844.577035]  nf_conntrack_ipv4

[14844.577036]  nf_defrag_ipv4
[14844.577037]  [<ffffffff8108cd2c>] smpboot_thread_fn+0x10c/0x300
[14844.577038]  xt_conntrack

[14844.577038]  nf_conntrack
[14844.577040]  [<ffffffff8108cc20>] ? __smpboot_create_thread.part.2+0xc0/0xc0
[14844.577040]  dm_crypt

[14844.577041]  xfs
[14844.577043]  [<ffffffff81081a7d>] kthread+0xed/0x100
[14844.577043]  arc4

[14844.577044]  iwldvm
[14844.577045]  [<ffffffff816a5df5>] ? wait_for_common+0x135/0x180
[14844.577046]  coretemp

[14844.577047]  kvm_intel
[14844.577048]  [<ffffffff81081990>] ? kthread_create_on_node+0x160/0x160
[14844.577049]  mac80211

[14844.577049]  kvm
[14844.577051]  [<ffffffff816b0d6c>] ret_from_fork+0x7c/0xb0
[14844.577052]  snd_hda_codec_hdmi

[14844.577052]  snd_hda_codec_realtek
[14844.577054]  [<ffffffff81081990>] ? kthread_create_on_node+0x160/0x160
[14844.577054]  snd_hda_intel
[14844.577055] ---[ end trace 482f8371e46ff850 ]---
[14844.577055]  snd_hda_codec
[14844.577056]  crc32c_intel
[14844.577057]  iTCO_wdt
[14844.577057]  iTCO_vendor_support
[14844.577058]  snd_hwdep
[14844.577058]  ghash_clmulni_intel
[14844.577059]  snd_seq
[14844.577059]  iwlwifi
[14844.577060]  microcode
[14844.577060]  snd_seq_device
[14844.577061]  pcspkr
[14844.577062]  i2c_i801
[14844.577062]  snd_pcm
[14844.577063]  cfg80211
[14844.577063]  tpm_tis
[14844.577064]  e1000e
[14844.577064]  thinkpad_acpi
[14844.577065]  snd_page_alloc
[14844.577066]  lpc_ich
[14844.577066]  snd_timer
[14844.577067]  mfd_core
[14844.577067]  snd
[14844.577068]  soundcore
[14844.577068]  tpm
[14844.577069]  tpm_bios
[14844.577070]  nfsd
[14844.577070]  auth_rpcgss
[14844.577071]  nfs_acl
[14844.577071]  lockd
[14844.577072]  sunrpc
[14844.577072]  btrfs
[14844.577073]  libcrc32c
[14844.577074]  zlib_deflate
[14844.577074]  i915
[14844.577075]  i2c_algo_bit
[14844.577075]  drm_kms_helper
[14844.577076]  drm
[14844.577076]  i2c_core
[14844.577077]  video

[14844.577079] Pid: 27, comm: watchdog/3 Tainted: G        W    3.7.0-rc8+ #4
[14844.577079] Call Trace:

[14844.577082]  [<ffffffff810529bf>] warn_slowpath_common+0x7f/0xc0

[14844.577084]  [<ffffffff81052ab6>] warn_slowpath_fmt+0x46/0x50

[14844.577087]  [<ffffffff8134a0ec>] debug_print_object+0x8c/0xb0

[14844.577089]  [<ffffffff81104610>] ? watchdog+0x30/0x30

[14844.577091]  [<ffffffff8134a3df>] __debug_object_init+0x20f/0x3e0

[14844.577093]  [<ffffffff816a63b9>] ? __schedule+0x479/0xa00

[14844.577095]  [<ffffffff8134a5cb>] debug_object_init+0x1b/0x20

[14844.577097]  [<ffffffff81086782>] hrtimer_init+0x32/0x180

[14844.577100]  [<ffffffff811048f5>] watchdog_enable+0x85/0x200

[14844.577102]  [<ffffffff810956a1>] ? get_parent_ip+0x11/0x50

[14844.577104]  [<ffffffff8108cd2c>] smpboot_thread_fn+0x10c/0x300

[14844.577106]  [<ffffffff8108cc20>] ? __smpboot_create_thread.part.2+0xc0/0xc0

[14844.577108]  [<ffffffff81081a7d>] kthread+0xed/0x100

[14844.577110]  [<ffffffff816a5d0a>] ? wait_for_common+0x4a/0x180

[14844.577112]  [<ffffffff81081990>] ? kthread_create_on_node+0x160/0x160

[14844.577114]  [<ffffffff816b0d6c>] ret_from_fork+0x7c/0xb0

[14844.577115]  [<ffffffff81081990>] ? kthread_create_on_node+0x160/0x160
[14844.577116] ---[ end trace 482f8371e46ff851 ]---
[14844.599738]  snd
[14844.599856]  soundcore tpm tpm_bios nfsd auth_rpcgss nfs_acl lockd sunrpc btrfs libcrc32c zlib_deflate i915 i2c_algo_bit drm_kms_helper drm i2c_core video
[14844.600705] Pid: 15, comm: watchdog/1 Tainted: G        W    3.7.0-rc8+ #4
[14844.601082] Call Trace:
[14844.601224]  [<ffffffff810529bf>] warn_slowpath_common+0x7f/0xc0
[14844.601555]  [<ffffffff81052ab6>] warn_slowpath_fmt+0x46/0x50
[14844.601879]  [<ffffffff8134a0ec>] debug_print_object+0x8c/0xb0
[14844.602208]  [<ffffffff81104610>] ? watchdog+0x30/0x30
[14844.602501]  [<ffffffff8134a3df>] __debug_object_init+0x20f/0x3e0
[14844.602843]  [<ffffffff816a63b9>] ? __schedule+0x479/0xa00
[14844.603147]  [<ffffffff8134a5cb>] debug_object_init+0x1b/0x20
[14844.603463]  [<ffffffff81086782>] hrtimer_init+0x32/0x180
[14844.603761]  [<ffffffff811048f5>] watchdog_enable+0x85/0x200
[14844.604077]  [<ffffffff810956a1>] ? get_parent_ip+0x11/0x50
[14844.604388]  [<ffffffff8108cd2c>] smpboot_thread_fn+0x10c/0x300
[14844.604717]  [<ffffffff8108cc20>] ? __smpboot_create_thread.part.2+0xc0/0xc0
[14844.605104]  [<ffffffff81081a7d>] kthread+0xed/0x100
[14844.605381]  [<ffffffff816a5d0a>] ? wait_for_common+0x4a/0x180
[14844.605704]  [<ffffffff81081990>] ? kthread_create_on_node+0x160/0x160
[14844.606070]  [<ffffffff816b0d6c>] ret_from_fork+0x7c/0xb0
[14844.606367]  [<ffffffff81081990>] ? kthread_create_on_node+0x160/0x160
[14844.606728] ---[ end trace 482f8371e46ff852 ]---


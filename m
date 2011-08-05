Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab1HEJAH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 05:00:07 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:34077 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756099Ab1HEJAD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 05:00:03 -0400
MIME-Version: 1.0
In-Reply-To: <20110805010038.GA18148@redhat.com>
References: <20110805010038.GA18148@redhat.com>
Date: Fri, 5 Aug 2011 17:00:02 +0800
Message-ID: <CAJn8CcH2YuRxVCDyFfdN2bdDyTr2goYO-BALMJ8tkCHB0vSgNA@mail.gmail.com>
Subject: Re: list corruption in the last few days. (block ? crypto ?)
From: Xiaotian Feng <xtfeng@gmail.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 5, 2011 at 9:00 AM, Dave Jones <davej@redhat.com> wrote:
> Sometime in the last week, something was merged which causes my laptop
> to lock up occasionally.  I can trigger it most of the time just by
> doing a kernel build. When it gets to the final linking stage, it locks up hard.
>
> I finally managed to coax something out of usb console to get the traces below,
> which seem to implicate something in the block layer ?
>
> my root device is an lvm volume on an dmcrypt'd block dev, which might be relevant,
> as I don't see this happening on other machines with simpler setups.
>
> I'm going to try bisecting, but it might take me a few days, because it's
> such a pain in the ass to reproduce this reliably.

I've met the same corruption, this might be from lockless slub patches ...
I tried with "git diff
e4a46182e1bcc2ddacff5a35f6b52398b51f1b11..9e577e8b46ab0c38970c0f0cd7eae62e6dffddee
| patch -p1 -R"
Things get better, my system doesn't crash for hours ....

>
>        Dave
>
>
> [ 5913.233035] ------------[ cut here ]------------
> [ 5913.233097] WARNING: at lib/list_debug.c:53 __list_del_entry+0x8d/0x98()
> [ 5913.233101] Hardware name: Adamo 13
> [ 5913.233105] list_del corruption. prev->next should be ffffea000434fd20, but was ffffea0004199520
> [ 5913.233108] Modules linked in: nfs fscache fuse ebtable_nat ebtables ppdev parport_pc lp parport ipt_MASQUERADE iptable_nat nf_nat nfsd lockd nfs_acl auth_rpcgss xt_CHECKSUM sunrpc iptable_mangle bridge stp llc cpufreq_ondemand acpi_cpufreq freq_table mperf ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables rfcomm bnep arc4 iwlagn snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel btusb mac80211 snd_hda_codec bluetooth snd_hwdep snd_seq snd_seq_device snd_pcm usb_debug dell_wmi sparse_keymap cdc_ether usbnet cdc_acm uvcvideo cdc_wdm mii cfg80211 snd_timer dell_laptop videodev dcdbas snd microcode v4l2_compat_ioctl32 soundcore joydev tg3 pcspkr snd_page_alloc iTCO_wdt i2c_i801 rfkill iTCO_vendor_support wmi virtio_net kvm_intel kvm ipv6 xts gf128mul dm_crypt i915 drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: scsi_wait_scan]
> [ 5913.233213] Pid: 0, comm: swapper Not tainted 3.0.0+ #127
> [ 5913.233213] Call Trace:
> [ 5913.233213]  <IRQ>  [<ffffffff8105df18>] warn_slowpath_common+0x83/0x9b
> [ 5913.233213]  [<ffffffff8105dfd3>] warn_slowpath_fmt+0x46/0x48
> [ 5913.233213]  [<ffffffff8127e7c1>] __list_del_entry+0x8d/0x98
> [ 5913.233213]  [<ffffffff8127e7da>] list_del+0xe/0x2d
> [ 5913.233213]  [<ffffffff814e0430>] __slab_free+0x1db/0x235
> [ 5913.233213]  [<ffffffff811706ab>] ? bvec_free_bs+0x35/0x37
> [ 5913.233213]  [<ffffffff811706ab>] ? bvec_free_bs+0x35/0x37
> [ 5913.233213]  [<ffffffff811706ab>] ? bvec_free_bs+0x35/0x37
> [ 5913.233213]  [<ffffffff81133085>] kmem_cache_free+0x88/0x102
> [ 5913.233213]  [<ffffffff811706ab>] bvec_free_bs+0x35/0x37
> [ 5913.233213]  [<ffffffff811706e1>] bio_free+0x34/0x64
> [ 5913.233213]  [<ffffffff813dc390>] dm_bio_destructor+0x12/0x14
> [ 5913.233213]  [<ffffffff8116fef6>] bio_put+0x2b/0x2d
> [ 5913.233213]  [<ffffffff813dccab>] clone_endio+0x9e/0xb4
> [ 5913.233213]  [<ffffffff8116f7dd>] bio_endio+0x2d/0x2f
> [ 5913.233213]  [<ffffffffa00148da>] crypt_dec_pending+0x5c/0x8b [dm_crypt]
> [ 5913.233213]  [<ffffffffa00150a9>] crypt_endio+0x78/0x81 [dm_crypt]
> [ 5913.233213]  [<ffffffff8116f7dd>] bio_endio+0x2d/0x2f
> [ 5913.233213]  [<ffffffff81257f60>] req_bio_endio+0x91/0x99
> [ 5913.233213]  [<ffffffff81259fc9>] blk_update_request+0x1f2/0x395
> [ 5913.233213]  [<ffffffff8125a18d>] blk_update_bidi_request+0x21/0x6d
> [ 5913.233213]  [<ffffffff8125a2e0>] blk_end_bidi_request+0x1f/0x5d
> [ 5913.233213]  [<ffffffff8125a358>] blk_end_request+0x10/0x12
> [ 5913.233213]  [<ffffffff8135126c>] scsi_io_completion+0x1dc/0x4d7
> [ 5913.233213]  [<ffffffff813491ac>] scsi_finish_command+0xe4/0xed
> [ 5913.233213]  [<ffffffff81350fd4>] scsi_softirq_done+0x109/0x112
> [ 5913.233213]  [<ffffffff8125f359>] blk_done_softirq+0x7f/0x93
> [ 5913.233213]  [<ffffffff810646e5>] __do_softirq+0x10f/0x257
> [ 5913.233213]  [<ffffffff810dc4e4>] ? time_hardirqs_off+0x1b/0x2f
> [ 5913.233213]  [<ffffffff814f075c>] call_softirq+0x1c/0x30
> [ 5913.233213]  [<ffffffff81011c7a>] do_softirq+0x4b/0xa1
> [ 5913.233213]  [<ffffffff81064ac8>] irq_exit+0x5d/0xcd
> [ 5913.233213]  [<ffffffff814f105d>] do_IRQ+0x8d/0xa4
> [ 5913.233213]  [<ffffffff814e86f3>] common_interrupt+0x73/0x73
> [ 5913.233213]  <EOI>  [<ffffffff81015f0c>] ? __cycles_2_ns+0xe/0x3a
> [ 5913.233213]  [<ffffffff812eb3ff>] ? arch_local_irq_enable+0x8/0xd
> [ 5913.233213]  [<ffffffff810918c2>] ? trace_hardirqs_on+0xd/0xf
> [ 5913.233213]  [<ffffffff812ec20f>] acpi_idle_enter_bm+0x235/0x26d
> [ 5913.233213]  [<ffffffff813ef81c>] cpuidle_idle_call+0x11c/0x1fe
> [ 5913.233213]  [<ffffffff8100f31d>] cpu_idle+0xe2/0x14c
> [ 5913.233213]  [<ffffffff81d48bad>] ? start_kernel+0x3ec/0x3f7
> [ 5913.233213]  [<ffffffff814c4316>] rest_init+0xda/0xe1
> [ 5913.233213]  [<ffffffff814c423c>] ? csum_partial_copy_generic+0x16c/0x16c
> [ 5913.233213]  [<ffffffff81d48bad>] start_kernel+0x3ec/0x3f7
> [ 5913.233213]  [<ffffffff81d482c4>] x86_64_start_reservations+0xaf/0[ 5913.239397] ------------[ cut here ]------------
> [ 5913.239397] WARNING: at lib/list_debug.c:53 __list_del_entry+0x8d/0x98()
> [ 5913.239397] Hardware name: Adamo 13
> [ 5913.239397] list_del corruption. prev->next should be ffffea00041a82a0, but was ffffea0004677e60
> [ 5913.239397] Modules linked in: nfs fscache fuse ebtable_nat ebtables ppdev parport_pc lp parport ipt_MASQUERADE iptable_nat nf_nat nfsd lockd nfs_acl auth_rpcgss xt_CHECKSUM sunrpc iptable_mangle bridge stp llc cpufreq_ondemand acpi_cpufreq freq_table mperf ip6t_REJECT nf_conntrack_ cdc_eth[ 5913.317698] ------------[ cut here ]------------
> [ 5913.317761] WARNING: at lib/list_debug.c:53 __list_del_entry+0x8d/0x98()
> [ 5913.317766] Hardware name: Adamo 13
> [ 5913.317769] list_del corruption. prev->next should be ffffea0004145720, but was ffffea000415ee20
> [ 5913.317773] Modules linked in: nfs fscache fuse ebtable_nat ebtables ppdev parport_pc lp parport ipt_MASQUERADE iptable_nat nf_nat nfsd lockd nfs_acl auth_rpcgss xt_CHECKSUM sunrpc iptable_mangle bridge stp llc cpufreq_ondemand acpi_cpufreq freq_table mperf ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables rfcomm bnep arc4 iwlagn snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel btusb mac80211 snd_hda_codec bluetooth snd_hwdep snd_seq snd_seq_device snd_pcm usb_debug dell_wmi sparse_keymap cdc_ether usbnet cdc_acm uvcvideo cdc_wdm mii cfg80211 snd_timer dell_laptop videodev dcdbas snd microcode v4l2_compat_ioctl32 soundcore joydev tg3 pcspkr snd_page_alloc iTCO_wdt i2c_i801 rfkill iTCO_vendor_support wmi virtio_net kvm_intel kvm ipv6 xts gf128mul dm_crypt i915 drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: scsi_wait_scan]
> [ 5913.317926] Pid: 0, comm: kworker/0:0 Tainted: G        W   3.0.0+ #127
> [ 5913.317930] Call Trace:
> [ 5913.317933]  <IRQ>  [<ffffffff8105df18>] warn_slowpath_common+0x83/0x9b
> [ 5913.317944]  [<ffffffff8105dfd3>] warn_slowpath_fmt+0x46/0x48
> [ 5913.317950]  [<ffffffff8127e7c1>] __list_del_entry+0x8d/0x98
> [ 5913.317955]  [<ffffffff8127e7da>] list_del+0xe/0x2d
> [ 5913.317961]  [<ffffffff814e0430>] __slab_free+0x1db/0x235
> [ 5913.317968]  [<ffffffff811706ab>] ? bvec_free_bs+0x35/0x37
> [ 5913.317973]  [<ffffffff811706ab>] ? bvec_free_bs+0x35/0x37
> [ 5913.317978]  [<ffffffff811706ab>] ? bvec_free_bs+0x35/0x37
> [ 5913.317985]  [<ffffffff81133085>] kmem_cache_free+0x88/0x102
> [ 5913.317990]  [<ffffffff811706ab>] bvec_free_bs+0x35/0x37
> [ 5913.317995]  [<ffffffff811706e1>] bio_free+0x34/0x64
> [ 5913.318002]  [<ffffffff813dc390>] dm_bio_destructor+0x12/0x14
> [ 5913.318007]  [<ffffffff8116fef6>] bio_put+0x2b/0x2d
> [ 5913.318012]  [<ffffffff813dccab>] clone_endio+0x9e/0xb4
> [ 5913.318017]  [<ffffffff8116f7dd>] bio_endio+0x2d/0x2f
> [ 5913.318030]  [<ffffffffa00148da>] crypt_dec_pending+0x5c/0x8b [dm_crypt]
> [ 5913.318041]  [<ffffffffa00150a9>] crypt_endio+0x78/0x81 [dm_crypt]
> [ 5913.318047]  [<ffffffff8116f7dd>] bio_endio+0x2d/0x2f
> [ 5913.318053]  [<ffffffff81257f60>] req_bio_endio+0x91/0x99
> [ 5913.318059]  [<ffffffff81259fc9>] blk_update_request+0x1f2/0x395
> [ 5913.318064]  [<ffffffff8125a18d>] blk_update_bidi_request+0x21/0x6d
> [ 5913.318070]  [<ffffffff8125a2e0>] blk_end_bidi_request+0x1f/0x5d
> [ 5913.318075]  [<ffffffff8125a358>] blk_end_request+0x10/0x12
> [ 5913.318081]  [<ffffffff8135126c>] scsi_io_completion+0x1dc/0x4d7
> [ 5913.318087]  [<ffffffff813491ac>] scsi_finish_command+0xe4/0xed
> [ 5913.318092]  [<ffffffff81350fd4>] scsi_softirq_done+0x109/0x112
> [ 5913.318098]  [<ffffffff8125f359>] blk_done_softirq+0x7f/0x93
> [ 5913.318104]  [<ffffffff810646e5>] __do_softirq+0x10f/0x257
> [ 5913.318110]  [<ffffffff810dc4e4>] ? time_hardirqs_off+0x1b/0x2f
> [ 5913.318116]  [<ffffffff814f075c>] call_softirq+0x1c/0x30
> [ 5913.318123]  [<ffffffff81011c7a>] do_softirq+0x4b/0xa1
> [ 5913.318127]  [<ffffffff81064ac8>] irq_exit+0x5d/0xcd
> [ 5913.318133]  [<ffffffff814f105d>] do_IRQ+0x8d/0xa4
> [ 5913.318138]  [<ffffffff814e86f3>] common_interrupt+0x73/0x73
> [ 5913.318142]  <EOI>  [<ffffffff81015f0c>] ? __cycles_2_ns+0xe/0x3a
> [ 5913.318152]  [<ffffffff812eb3ff>] ? arch_local_irq_enable+0x8/0xd
> [ 5913.318158]  [<ffffffff810918c2>] ? trace_hardirqs_on+0xd/0xf
> [ 5913.318164]  [<ffffffff812ec325>] acpi_idle_enter_simple+0xde/0x114
> [ 5913.318170]  [<ffffffff813ef81c>] cpuidle_idle_call+0x11c/0x1fe
> [ 5913.318176]  [<ffffffff8100f31d>] cpu_idle+0xe2/0x14c
> [ 5913.318181]  [<ffffffff814d451d>] start_secondary+0x20d/0x218
> [ 5913.318186] ---[ end trace ff2d5fa66f3f892e ]---
> [ 5913.422416] ------------[ cut here ]------------
> [ 5913.422501] WARNING: at lib/list_debug.c:53 __list_del_entry+0x8d/0x98()
> [ 5913.422505] Hardware name: Adamo 13
> [ 5913.422509] list_del corruption. prev->next should be ffffea00045acda0, but was dead000000100100
> [ 5913.422513] Modules linked in: nfs fscache fuse ebtable_nat ebtables ppdev parport_pc lp parport ipt_MASQUERADE iptable_nat nf_nat nfsd lockd nfs_acl auth_rpcgss xt_CHECKSUM sunrpc iptable_mangle bridge stp llc cpufreq_ondemand acpi_cpufreq freq_table mperf ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables rfcomm bnep arc4 iwlagn snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel btusb mac80211 snd_hda_codec bluetooth snd_hwdep snd_seq snd_seq_device snd_pcm usb_debug dell_wmi sparse_keymap cdc_ether usbnet cdc_acm uvcvideo cdc_wdm mii cfg80211 snd_timer dell_laptop videodev dcdbas snd microcode v4l2_compat_ioctl32 soundcore joydev tg3 pcspkr snd_page_alloc iTCO_wdt i2c_i801 rfkill iTCO_vendor_support wmi virtio_net kvm_intel kvm ipv6 xts gf128mul dm_crypt i915 drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: scsi_wait_scan]
> [ 5913.422667] Pid: 17555, comm: kworker/1:3 Tainted: G        W   3.0.0+ #127
> [ 5913.422670] Call Trace:
> [ 5913.422674]  <IRQ>  [<ffffffff8105df18>] warn_slowpath_common+0x83/0x9b
> [ 5913.422685]  [<ffffffff8105dfd3>] warn_slowpath_fmt+0x46/0x48
> [ 5913.422691]  [<ffffffff8127e7c1>] __list_del_entry+0x8d/0x98
> [ 5913.422696]  [<ffffffff8127e7da>] list_del+0xe/0x2d
> [ 5913.422702]  [<ffffffff814e0430>] __slab_free+0x1db/0x235
> [ 5913.422709]  [<ffffffff811706ab>] ? bvec_free_bs+0x35/0x37
> [ 5913.422715]  [<ffffffff811706ab>] ? bvec_free_bs+0x35/0x37
> [ 5913.422720]  [<ffffffff811706ab>] ? bvec_free_bs+0x35/0x37
> [ 5913.422726]  [<ffffffff81133085>] kmem_cache_free+0x88/0x102
> [ 5913.422732]  [<ffffffff811706ab>] bvec_free_bs+0x35/0x37
> [ 5913.422737]  [<ffffffff811706e1>] bio_free+0x34/0x64
> [ 5913.422743]  [<ffffffff813dc390>] dm_bio_destructor+0x12/0x14
> [ 5913.422749]  [<ffffffff8116fef6>] bio_put+0x2b/0x2d
> [ 5913.422754]  [<ffffffff813dccab>] clone_endio+0x9e/0xb4
> [ 5913.422759]  [<ffffffff8116f7dd>] bio_endio+0x2d/0x2f
> [ 5913.422773]  [<ffffffffa00148da>] crypt_dec_pending+0x5c/0x8b [dm_crypt]
> [ 5913.422786]  [<ffffffffa00150a9>] crypt_endio+0x78/0x81 [dm_crypt]
> [ 5913.422791]  [<ffffffff8116f7dd>] bio_endio+0x2d/0x2f
> [ 5913.422797]  [<ffffffff81257f60>] req_bio_endio+0x91/0x99
> [ 5913.422803]  [<ffffffff81259fc9>] blk_update_request+0x1f2/0x395
> [ 5913.422808]  [<ffffffff8125a18d>] blk_update_bidi_request+0x21/0x6d
> [ 5913.422814]  [<ffffffff8125a2e0>] blk_end_bidi_request+0x1f/0x5d
> [ 5913.422819]  [<ffffffff8125a358>] blk_end_request+0x10/0x12
> [ 5913.422825]  [<ffffffff8135126c>] scsi_io_completion+0x1dc/0x4d7
> [ 5913.422831]  [<ffffffff813491ac>] scsi_finish_command+0xe4/0xed
> [ 5913.422836]  [<ffffffff81350fd4>] scsi_softirq_done+0x109/0x112
> [ 5913.422842]  [<ffffffff8125f359>] blk_done_softirq+0x7f/0x93
> [ 5913.422848]  [<ffffffff810646e5>] __do_softirq+0x10f/0x257
> [ 5913.422854]  [<ffffffff810dc4e4>] ? time_hardirqs_off+0x1b/0x2f
> [ 5913.422867]  [<ffffffffa00156fa>] ? crypt_convert+0x2b7/0x2b7 [dm_crypt]
> [ 5913.422873]  [<ffffffff814f075c>] call_softirq+0x1c/0x30
> [ 5913.422879]  [<ffffffff81011c7a>] do_softirq+0x4b/0xa1
> [ 5913.422884]  [<ffffffff81064ac8>] irq_exit+0x5d/0xcd
> [ 5913.422889]  [<ffffffff814f105d>] do_IRQ+0x8d/0xa4
> [ 5913.422895]  [<ffffffff814e86f3>] common_interrupt+0x73/0x73
> [ 5913.422898]  <EOI>  [<ffffffff8108d090>] ? debug_mutex_init+0x3e/0x3e
> [ 5913.422909]  [<ffffffff8108d0b3>] ? arch_local_irq_save+0x9/0x18
> [ 5913.422915]  [<ffffffff8108e10b>] lock_is_held+0x2c/0x95
> [ 5913.422930]  [<ffffffff81099aea>] rcu_read_lock_held+0x25/0x27
> [ 5913.422935]  [<ffffffff81099b4d>] __module_address+0x61/0xa0
> [ 5913.422949]  [<ffffffff8109d41a>] is_module_address+0x20/0x59
> [ 5913.422960]  [<ffffffff8108dbd9>] static_obj+0x3c/0x54
> [ 5913.422970]  [<ffffffff8108e5a2>] lockdep_init_map+0xa0/0x115
> [ 5913.422982]  [<ffffffff8107c41b>] __init_waitqueue_head+0x3a/0x4b
> [ [ 5913.555121] ------------[ cut here ]------------
> [ 5913.555121] WARNING: at lib/list_debug.c:53 __list_del_entry+0x8d/0x98()
> [ 5913.555121] Hardware name: Adamo 13
> [ 5913.555121] list_del corruption. prev->next should be ffffea000451a320, but was ffffea000480eda0
> [ 5913.555121] Modules linked in: nfs fscache fuse ebtable_nat ebtables ppdev parport_pc lp parport ipt_MASQUERADE iptable_nat nf_nat nfsd lockd nfs_acl auth_rpcgss xt_CHECKSUM sunrpc iptable_mangle bridge stp llc cpufreq_ondemand acpi_cpufreq freq_table mperf ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables rfcomm bnep arc4 iwlagn snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel btusb mac80211 snd_hda_codec bluetooth snd_hwdep snd_seq snd_seq_device snd_pcm usb_debug dell_wmi sparse_keymap cdc_ether usbnet cdc_acm uvcvideo cdc_wdm mii cfg80211 snd_timer dell_laptop videodev dcdbas snd microcode v4l2_compat_ioctl32 soundcore joydev tg3 pcspkr snd_page_alloc iTCO_wdt i2c_i801 rfkill iTCO_vendor_support wmi virtio_net kvm_intel kvm ipv6 xts gf128mul dm_crypt i915 drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: scsi_wait_scan]
> [ 5913.555121] Pid: 0, comm: swapper Tainted: G        W   3.0.0+ #127
> [ 5913.555121] Call Trace:
> [ 5913.555121]  <IRQ>  [<ffffffff8105df18>] warn_slowpath_common+0x83/0x9b
> [ 5913.555121]  [<ffffffff8105dfd3>] warn_slowpath_fmt+0x46/0x48
> [ 5913.555121]  [<ffffffff8127e7c1>] __list_del_entry+0x8d/0x98
> [ 5913.555121]  [<ffffffff8127e7da>] list_del+0xe/0x2d
> [ 5913.555121]  [<ffffffff814e0430>] __slab_free+0x1db/0x235
> [ 5913.555121]  [<ffffffff811706ab>] ? bvec_free_bs+0x35/0x37
> [ 5913.555121]  [<ffffffff811706ab>] ? bvec_free_bs+0x35/0x37
> [ 5913.555121]  [<ffffffff811706ab>] ? bvec_free_bs+0x35/0x37
> [ 5913.555121]  [<ffffffff81133085>] kmem_cache_free+0x88/0x102
> [ 5913.555121]  [<ffffffff811706ab>] bvec_free_bs+0x35/0x37
> [ 5913.555121]  [<ffffffff811706e1>] bio_free+0x34/0x64
> [ 5913.555121]  [<ffffffff813dc390>] dm_bio_destructor+0x12/0x14
> [ 5913.555121]  [<ffffffff8116fef6>] bio_put+0x2b/0x2d
> [ 5913.555121]  [<ffffffff813dccab>] clone_endio+0x9e/0xb4
> [ 5913.555121]  [<ffffffff8116f7dd>] bio_endio+0x2d/0x2f
> [ 5913.555121]  [<ffffffffa00148da>] crypt_dec_pending+0x5c/0x8b [dm_crypt]
> [ 5913.555121]  [<ffffffffa00150a9>] crypt_endio+0x78/0x81 [dm_crypt]
> [ 5913.555121]  [<ffffffff8116f7dd>] bio_endio+0x2d/0x2f
> [ 5913.555121]  [<ffffffff81257f60>] req_bio_endio+0x91/0x99
> [ 5913.555121]  [<ffffffff81259fc9>] blk_update_request+0x1f2/0x395
> [ 5913.555121]  [<ffffffff8125a18d>] blk_update_bidi_request+0x21/0x6d
> [ 5913.555121]  [<ffffffff8125a2e0>] blk_end_bidi_request+0x1f/0x5d
> [ 5913.555121]  [<ffffffff8125a358>] blk_end_request+0x10/0x12
> [ 5913.555121]  [<ffffffff8135126c>] scsi_io_completion+0x1dc/0x4d7
> [ 5913.555121]  [<ffffffff813491ac>] scsi_finish_command+0xe4/0xed
> [ 5913.555121]  [<ffffffff81350fd4>] scsi_softirq_done+0x109/0x112
> [ 5913.555121]  [<ffffffff8125f359>] blk_done_softirq+0x7f/0x93
> [ 5913.555121]  [<ffffffff810646e5>] __do_softirq+0x10f/0x257
> [ 5913.555121]  [<ffffffff810dc4e4>] ? time_hardirqs_off+0x1b/0x2f
> [ 5913.555121]  [<ffffffff814f075c>] call_softirq+0x1c/0x30
> [ 5913.555121]  [<ffffffff81011c7a>] do_softirq+0x4b/0xa1
> [ 5913.555121]  [<ffffffff81064ac8>] irq_exit+0x5d/0xcd
> [ 5913.555121]  [<ffffffff814f105d>] do_IRQ+0x8d/0xa4
> [ 5913.555121]  [<ffffffff814e86f3>] common_interrupt+0x73/0x73
> [ 5913.555121]  <EOI>  [<ffffffff81015f0c>] ? __cycles_2_ns+0xe/0x3a
> [ 5913.555121]  [<ffffffff812eb3ff>] ? arch_local_irq_enable+0x8/0xd
> [ 5913.555121]  [<ffffffff810918c2>] ? trace_hardirqs_on+0xd/0xf
> [ 5913.555121]  [<ffffffff812ec325>] acpi_idle_enter_simple+0xde/0x114
> [ 5913.555121]  [<ffffffff813ef81c>] cpuidle_idle_call+0x11c/0x1fe
> [ 5913.555121]  [<ffffffff8100f31d>] cpu_idle+0xe2/0x14c
> [ 5913.555121]  [<ffffffff81d48bad>] ? start_kernel+0x3ec/0x3f7
> [ 5913.555121]  [<ffffffff814c4316>] rest_init+0xda/0xe1
> [ 5913.555121]  [<ffffffff814c423c>] ? csum_partial_copy_generic+0x16c/0x16c
> [ 5913.555121]  [<ffffffff81d48bad>] start_kernel+0x3ec/0x3f7
> [ 5913.555121]  [ 5913.555121] ------------[ cut here ]------------
> [ 5913.555121] WARNING: at lib/list_debug.c:53 __list_del_entry+0x8d/0x98()
> [ 5913.555121] Hardware name: Adamo 13
> [ 5913.555121] list_del corruption. prev->next should be ffffea00046e6c20, but was ffffea00043ae720
> [ 5913.555121] Modules linked in: nfs fscache fuse ebtable_nat ebtables ppdev parport_pc lp parport ipt_MASQUERADE iptable_nat nf_nat nfsd lockd nfs_acl auth_rpcgss xt_CHECKSUM sunrpc iptable_mangle bridge stp llc cpufreq_ondemand acpi_cpufreq freq_table mperf ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables rfcomm bnep arc4 iwlagn snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel btusb mac80211 snd_hda_codec bluetooth wmi vir[ 5913.5[ 5913.5[ 5913.5[ 5913.593105] ------------[ cut here ]------------
> [ 5913.593114] WARNING: at lib/list_debug.c:26 __list_add+0x3d/0x7f()
> [ 5913.593118] Hardware name: Adamo 13
> [ 5913.593122] list_add corruption. next->prev should be prev (ffff88013825fe70), but was ffffea000439a120. (next=ffffea00045873e0).
> [ 5913.593127] Modules linked in: nfs fscache fuse ebtable_nat ebtables ppdev parport_pc lp parport ipt_MASQUERADE iptable_nat nf_nat nfsd lockd nfs_acl auth_rpcgss xt_CHECKSUM sunrpc iptable_mangle bridge stp llc cpufreq_ondemand acpi_cpufreq freq_table mperf ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables rfcomm bnep arc4 iwlagn snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel btusb mac80211 snd_hda_codec bluetooth snd_hwdep snd_seq snd_seq_device snd_pcm usb_debug dell_wmi sparse_keymap cdc_ether usbnet cdc_acm uvcvideo cdc_wdm mii cfg80211 snd_timer dell_laptop videodev dcdbas snd microcode v4l2_compat_ioctl32 soundcore joydev tg3 pcspkr snd_page_alloc iTCO_wdt i2c_i801 rfkill iTCO_vendor_support wmi virtio_net kvm_intel kvm ipv6 xts gf128mul dm_crypt i915 drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: scsi_wait_scan]
> [ 5913.593285] Pid: 900, comm: flush-253:3 Tainted: G        W   3.0.0+ #127
> [ 5913.593289] Call Trace:
> [ 5913.593295]  [<ffffffff8105df18>] warn_slowpath_common+0x83/0x9b
> [ 5913.593301]  [<ffffffff8105dfd3>] warn_slowpath_fmt+0x46/0x48
> [ 5913.593307]  [<ffffffff811335e1>] ? deactivate_slab+0x1b4/0x2b9
> [ 5913.593313]  [<ffffffff8127e836>] __list_add+0x3d/0x7f
> [ 5913.593318]  [<ffffffff8113367c>] deactivate_slab+0x24f/0x2b9
> [ 5913.593325]  [<ffffffff811707d6>] ? bvec_[ 5914.004821] -
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

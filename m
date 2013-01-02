Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab3ABVIi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 16:08:38 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:57577 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702Ab3ABVIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 16:08:35 -0500
Date: Wed, 2 Jan 2013 13:08:22 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Dave Jones <davej@redhat.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Chris Mason <chris.mason@fusionio.com>
Subject: Re: memory corruption, possibly caused by i915
In-Reply-To: <20130102155233.GA12479@redhat.com>
Message-ID: <alpine.LNX.2.00.1301021258280.31348@eggly.anvils>
References: <20130102155233.GA12479@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jan 2013, Dave Jones wrote:

> We've had a increased number of reports in the last six months or so
> from Fedora users getting corrupted page tables.
> At first I wrote it off to bad hardware, but they started happening frequently
> enough that I began to wonder if it was a real problem.
> 
> The only common thing I could think of was that now that gnome-shell is
> our default desktop, we're making a lot more use of DRI than we used to.
> 
> To test a hypothesis, I played a whole lot of quake3 over the holidays,
> and was finally able to make it happen too.
> 
> After playing the game for a few hours, I exited it, and all was well.
> But when I then went to shut down the laptop, I saw this..
> 
> [52460.280346] BUG: Bad page map in process panel-6-systray  pte:ffff8800b665a0e8 pmd:b6659067

A virtual address in place of a page table entry:
almost the virtual address of the page table itself.

> [52460.280848] addr:00000038bf3fd000 vm_flags:00000070 anon_vma:          (null) mapping:ffff88011052fd98 index:1fd
> [52460.281547] vma->vm_ops->fault: filemap_fault+0x0/0x470
> [52460.281878] vma->vm_file->f_op->mmap: btrfs_file_mmap+0x0/0x60 [btrfs]
> [52460.282286] Modules linked in: iptable_mangle bridge stp llc ip6table_filter ip6_tables dm_crypt xfs snd_hda_codec_hdmi arc4 iwldvm mac80211 c
> oretemp crc32c_intel snd_hda_codec_realtek ghash_clmulni_intel snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm iwlwifi thinkpad_acpi snd_page_alloc btusb 
> iTCO_wdt microcode tpm_tis vhost_net iTCO_vendor_support cfg80211 snd_timer bluetooth snd e1000e tpm pcspkr tun macvtap lpc_ich soundcore tpm_bios rfkill wmi hwmon mfd_core me
> i macvlan kvm_intel kvm nfsd auth_rpcgss nfs_acl lockd sunrpc btrfs libcrc32c zlib_deflate i915 i2c_algo_bit drm_kms_helper drm sdhci_pci sdhci led_class mmc_core i2c_core vid
> eo
> [52460.286556] Pid: 1317, comm: panel-6-systray Not tainted 3.7.0+ #15
> [52460.286926] Call Trace:
> [52460.287086]  [<ffffffff8114c662>] print_bad_pte+0x1e2/0x250
> [52460.287445]  [<ffffffff8114ea1d>] unmap_single_vma+0x5dd/0x8a0
> [52460.287804]  [<ffffffff8114f541>] unmap_vmas+0x51/0xa0
> [52460.288087]  [<ffffffff81158628>] exit_mmap+0x98/0x170
> [52460.288388]  [<ffffffff81047808>] mmput+0x78/0xe0
> [52460.288651]  [<ffffffff8104ffae>] do_exit+0x24e/0xa30
> [52460.288944]  [<ffffffff8119394e>] ? ____fput+0xe/0x10
> [52460.289268]  [<ffffffff8106af3c>] ? task_work_run+0xac/0xe0
> [52460.289608]  [<ffffffff8105081f>] do_group_exit+0x3f/0xa0
> [52460.289937]  [<ffffffff81050897>] sys_exit_group+0x17/0x20
> [52460.290288]  [<ffffffff815f5699>] system_call_fastpath+0x16/0x1b
> [52460.290652] Disabling lock debugging due to kernel taint
> [52460.290972] BUG: Bad page map in process panel-6-systray  pte:ffffffff81033f52 pmd:b6659067

I wonder what's at virtual address ffffffff81033f52...

> [52460.291477] addr:00000038bf3fe000 vm_flags:00000070 anon_vma:          (null) mapping:ffff88011052fd98 index:1fe
> [52460.292083] vma->vm_ops->fault: filemap_fault+0x0/0x470
> [52460.292427] vma->vm_file->f_op->mmap: btrfs_file_mmap+0x0/0x60 [btrfs]
> [52460.292816] Modules linked in: iptable_mangle bridge stp llc ip6table_filter ip6_tables dm_crypt xfs snd_hda_codec_hdmi arc4 iwldvm mac80211 c
> oretemp crc32c_intel snd_hda_codec_realtek ghash_clmulni_intel snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm iwlwifi thinkpad_acpi snd_page_alloc btusb 
> iTCO_wdt microcode tpm_tis vhost_net iTCO_vendor_support cfg80211 snd_timer bluetooth snd e1000e tpm pcspkr tun macvtap lpc_ich soundcore tpm_bios rfkill wmi hwmon mfd_core me
> i macvlan kvm_intel kvm nfsd auth_rpcgss nfs_acl lockd sunrpc btrfs libcrc32c zlib_deflate i915 i2c_algo_bit drm_kms_helper drm sdhci_pci sdhci led_class mmc_core i2c_core vid
> eo
> [52460.297010] Pid: 1317, comm: panel-6-systray Tainted: G    B        3.7.0+ #15
> [52460.297455] Call Trace:
> [52460.297617]  [<ffffffff8114c662>] print_bad_pte+0x1e2/0x250
> [52460.297954]  [<ffffffff81033f52>] ? __change_page_attr_set_clr+0x772/0xc00
> [52460.298383]  [<ffffffff81033f52>] ? __change_page_attr_set_clr+0x772/0xc00

... oh, thank you, it's __change_page_attr_set_clr+0x772 ;)

It looks rather as if panel-6-systray's kernel stack is on one of its
userspace page tables.

Hugh

> [52460.298796]  [<ffffffff8114db8d>] vm_normal_page+0x6d/0x90
> [52460.299143]  [<ffffffff8114e90f>] unmap_single_vma+0x4cf/0x8a0
> [52460.299497]  [<ffffffff8114f541>] unmap_vmas+0x51/0xa0
> [52460.299810]  [<ffffffff81158628>] exit_mmap+0x98/0x170
> [52460.300142]  [<ffffffff81047808>] mmput+0x78/0xe0
> [52460.300432]  [<ffffffff8104ffae>] do_exit+0x24e/0xa30
> [52460.300738]  [<ffffffff8119394e>] ? ____fput+0xe/0x10
> [52460.301041]  [<ffffffff8106af3c>] ? task_work_run+0xac/0xe0
> [52460.301363]  [<ffffffff8105081f>] do_group_exit+0x3f/0xa0
> [52460.301669]  [<ffffffff81050897>] sys_exit_group+0x17/0x20
> [52460.301974]  [<ffffffff815f5699>] system_call_fastpath+0x16/0x1b
> 
> 
> It's falling over in btrfs's mmap op, but I think it's just the victim here,
> of something else corrupting what had been mmaped in the panel process.
> 
> Daniel, can you think of additional sanity checks that could be added to
> the i915 driver ? (Even if at the expense of speed: a CONFIG_DEBUG option
> to prove correctness would be very worthwhile imo)
> 
> 	Dave

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758835Ab2CFIys (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 03:54:48 -0500
Received: from mga09.intel.com ([134.134.136.24]:60670 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758649Ab2CFIyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 03:54:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="118122082"
Date: Tue, 6 Mar 2012 10:53:44 +0200
From: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>
To: Dave Jones <davej@redhat.com>, Marcel Holtmann <marcel@holtmann.org>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Fedora Kernel Team <kernel-team@fedoraproject.org>
Subject: Re: use-after-free in bluetooth (hci_conn_hash_flush)
Message-ID: <20120306085342.GA8432@aemeltch-MOBL1>
References: <20120305221242.GA2008@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120305221242.GA2008@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Mar 05, 2012 at 05:12:42PM -0500, Dave Jones wrote:
> We had a user report this, which looks like a use after free
> in hci_conn_hash_flush(). Probably related to bf4c63252490ba78fb833cc7acf1a5b1900c970f

Yes most probably this is the reason.

> Full report is at https://bugzilla.redhat.com/show_bug.cgi?id=797590

Could you try following commit?

commit 3c4e0df028935618d052235ba85bc7079be13394
Author: Andrei Emeltchenko <andrei.emeltchenko@intel.com>
Date:   Thu Feb 2 10:32:17 2012 +0200

    Bluetooth: Use list _safe deleting from conn_hash_list
    
    Use list_for_each_entry_safe which is safe version against removal
    of list entry. Otherwise we remove hci_conn element and reference
    next element which result in accessing LIST_POISON.
    
    [   95.571834] Bluetooth: unknown link type 127
    [   95.578349] BUG: unable to handle kernel paging request at 20002000
    [   95.580236] IP: [<20002000>] 0x20001fff
    [   95.580763] *pde = 00000000
    [   95.581196] Oops: 0000 [#1] SMP
    ...
    [   95.582298] Pid: 3355, comm: hciconfig Tainted: G   O
3.2.0-VirttualBox
    [   95.582298] EIP: 0060:[<20002000>] EFLAGS: 00210206 CPU: 0
    [   95.582298] EIP is at 0x20002000
    ...
    [   95.582298] Call Trace:
    [   95.582298]  [<f8231ab6>] ? hci_conn_hash_flush+0x76/0xf0
[bluetooth]
    [   95.582298]  [<f822bcb1>] hci_dev_do_close+0xc1/0x2e0 [bluetooth]
    [   95.582298]  [<f822d679>] ? hci_dev_get+0x69/0xb0 [bluetooth]
    [   95.582298]  [<f822e1da>] hci_dev_close+0x2a/0x50 [bluetooth]
    [   95.582298]  [<f824102f>] hci_sock_ioctl+0x1af/0x3f0 [bluetooth]
    [   95.582298]  [<c11153ea>] ? handle_pte_fault+0x8a/0x8f0
    [   95.582298]  [<c146becf>] sock_ioctl+0x5f/0x260
    [   95.582298]  [<c146be70>] ? sock_fasync+0x90/0x90
    [   95.582298]  [<c1152b33>] do_vfs_ioctl+0x83/0x5b0
    [   95.582298]  [<c1563f87>] ? do_page_fault+0x297/0x500
    [   95.582298]  [<c1563cf0>] ? spurious_fault+0xd0/0xd0
    [   95.582298]  [<c107165b>] ? up_read+0x1b/0x30
    [   95.582298]  [<c1563f87>] ? do_page_fault+0x297/0x500
    [   95.582298]  [<c100aa9f>] ? init_fpu+0xef/0x160
    [   95.582298]  [<c15617c0>] ? do_debug+0x180/0x180
    [   95.582298]  [<c100a958>] ? fpu_finit+0x28/0x80
    [   95.582298]  [<c11530e7>] sys_ioctl+0x87/0x90
    [   95.582298]  [<c156795f>] sysenter_do_call+0x12/0x38
    ...


Best regards 
Andrei Emeltchenko 

> 
> 	Dave
> 
> general protection fault: 0000 [#1] SMP 
> CPU 0 
> Modules linked in: rfcomm bnep btusb bluetooth lockd sunrpc uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core videodev v4l2_compat_ioctl32 media snd_hda_codec_conexant snd_hda_intel arc4 snd_hda_codec iwlwifi mac80211 snd_hwdep snd_pcm snd_page_alloc snd_timer cfg80211 thinkpad_acpi iTCO_wdt e1000e snd soundcore microcode i2c_i801 r592 memstick iTCO_vendor_support rfkill binfmt_misc uinput sdhci_pci sdhci firewire_ohci mmc_core firewire_core crc_itu_t yenta_socket wmi i915 video i2c_algo_bit drm_kms_helper drm i2c_core [last unloaded: scsi_wait_scan]
> Pid: 881, comm: bluetoothd Not tainted 3.3.0-0.rc4.git3.1.fc18.x86_64 #1 LENOVO 2767C99/2767C99
> RIP: 0010:[<ffffffffa0431175>]  [<ffffffffa0431175>] hci_conn_hash_flush+0x95/0x120 [bluetooth]
> RSP: 0018:ffff8801f33a9d68  EFLAGS: 00010296
> RAX: 0000000000000000 RBX: 6b6b6b6b6b6b6b6b RCX: 0000000000000001
> RDX: 0000000000000000 RSI: ffffffff81c297e0 RDI: 0000000000000246
> RBP: ffff8801f33a9d88 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000001 R11: 0000000000000000 R12: ffff8801f30cabb8
> R13: ffff8801f30caa88 R14: ffffffff82d20b40 R15: 0000000000000011
> FS:  00007f0e6947b740(0000) GS:ffff880232e00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 00000001f2c08000 CR4: 00000000000406f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process bluetoothd (pid: 881, threadinfo ffff8801f33a8000, task ffff8801f33a0000)
> Stack:
>  ffff8801f30ca158 6b6b6b6b6b6b6b6b ffff8801f30ca148 ffff8801f30ca158
>  ffff8801f33a9db8 ffffffffa042a6b8 ffff8801f30ca148 0000000000000000
>  ffff8801f3318000 ffffffff82d20b40 ffff8801f33a9dd8 ffffffffa042cd9d
> Call Trace:
>  [<ffffffffa042a6b8>] hci_dev_do_close+0xc8/0x340 [bluetooth]
>  [<ffffffffa042cd9d>] hci_dev_close+0x2d/0x70 [bluetooth]
>  [<ffffffffa04421a3>] hci_sock_ioctl+0x1a3/0x3e0 [bluetooth]
>  [<ffffffff812c1127>] ? inode_has_perm.isra.42+0x67/0xa0
>  [<ffffffff815443c0>] sock_do_ioctl+0x30/0x70
>  [<ffffffff8154447d>] sock_ioctl+0x7d/0x2c0
>  [<ffffffff811d06b9>] do_vfs_ioctl+0x99/0x5a0
>  [<ffffffff811d0c59>] sys_ioctl+0x99/0xa0
>  [<ffffffff816a74e9>] system_call_fastpath+0x16/0x1b
> Code: fd ff ff 48 8b 03 48 89 45 e8 48 8b 5d e8 e8 83 58 c5 e0 85 c0 74 0f e8 7a 58 c5 e0 85 c0 75 56 66 0f 1f 44 00 00 49 39 dc 74 3b <0f> b6 53 21 66 c7 43 1e 09 00 80 fa 01 74 14 73 8a be 16 00 00 
> RIP  [<ffffffffa0431175>] hci_conn_hash_flush+0x95/0x120 [bluetooth]
>  RSP <ffff8801f33a9d68>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

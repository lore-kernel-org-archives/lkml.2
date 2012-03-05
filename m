Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655Ab2CEWMy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 17:12:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29341 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755178Ab2CEWMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 17:12:51 -0500
Date: Mon, 5 Mar 2012 17:12:42 -0500
From: Dave Jones <davej@redhat.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: "Gustavo F. Padovan" <padovan@profusion.mobi>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Fedora Kernel Team <kernel-team@fedoraproject.org>
Subject: use-after-free in bluetooth (hci_conn_hash_flush)
Message-ID: <20120305221242.GA2008@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	"Gustavo F. Padovan" <padovan@profusion.mobi>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Fedora Kernel Team <kernel-team@fedoraproject.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We had a user report this, which looks like a use after free
in hci_conn_hash_flush(). Probably related to bf4c63252490ba78fb833cc7acf1a5b1900c970f

Full report is at https://bugzilla.redhat.com/show_bug.cgi?id=797590

	Dave

general protection fault: 0000 [#1] SMP 
CPU 0 
Modules linked in: rfcomm bnep btusb bluetooth lockd sunrpc uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core videodev v4l2_compat_ioctl32 media snd_hda_codec_conexant snd_hda_intel arc4 snd_hda_codec iwlwifi mac80211 snd_hwdep snd_pcm snd_page_alloc snd_timer cfg80211 thinkpad_acpi iTCO_wdt e1000e snd soundcore microcode i2c_i801 r592 memstick iTCO_vendor_support rfkill binfmt_misc uinput sdhci_pci sdhci firewire_ohci mmc_core firewire_core crc_itu_t yenta_socket wmi i915 video i2c_algo_bit drm_kms_helper drm i2c_core [last unloaded: scsi_wait_scan]
Pid: 881, comm: bluetoothd Not tainted 3.3.0-0.rc4.git3.1.fc18.x86_64 #1 LENOVO 2767C99/2767C99
RIP: 0010:[<ffffffffa0431175>]  [<ffffffffa0431175>] hci_conn_hash_flush+0x95/0x120 [bluetooth]
RSP: 0018:ffff8801f33a9d68  EFLAGS: 00010296
RAX: 0000000000000000 RBX: 6b6b6b6b6b6b6b6b RCX: 0000000000000001
RDX: 0000000000000000 RSI: ffffffff81c297e0 RDI: 0000000000000246
RBP: ffff8801f33a9d88 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: ffff8801f30cabb8
R13: ffff8801f30caa88 R14: ffffffff82d20b40 R15: 0000000000000011
FS:  00007f0e6947b740(0000) GS:ffff880232e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 00000001f2c08000 CR4: 00000000000406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process bluetoothd (pid: 881, threadinfo ffff8801f33a8000, task ffff8801f33a0000)
Stack:
 ffff8801f30ca158 6b6b6b6b6b6b6b6b ffff8801f30ca148 ffff8801f30ca158
 ffff8801f33a9db8 ffffffffa042a6b8 ffff8801f30ca148 0000000000000000
 ffff8801f3318000 ffffffff82d20b40 ffff8801f33a9dd8 ffffffffa042cd9d
Call Trace:
 [<ffffffffa042a6b8>] hci_dev_do_close+0xc8/0x340 [bluetooth]
 [<ffffffffa042cd9d>] hci_dev_close+0x2d/0x70 [bluetooth]
 [<ffffffffa04421a3>] hci_sock_ioctl+0x1a3/0x3e0 [bluetooth]
 [<ffffffff812c1127>] ? inode_has_perm.isra.42+0x67/0xa0
 [<ffffffff815443c0>] sock_do_ioctl+0x30/0x70
 [<ffffffff8154447d>] sock_ioctl+0x7d/0x2c0
 [<ffffffff811d06b9>] do_vfs_ioctl+0x99/0x5a0
 [<ffffffff811d0c59>] sys_ioctl+0x99/0xa0
 [<ffffffff816a74e9>] system_call_fastpath+0x16/0x1b
Code: fd ff ff 48 8b 03 48 89 45 e8 48 8b 5d e8 e8 83 58 c5 e0 85 c0 74 0f e8 7a 58 c5 e0 85 c0 75 56 66 0f 1f 44 00 00 49 39 dc 74 3b <0f> b6 53 21 66 c7 43 1e 09 00 80 fa 01 74 14 73 8a be 16 00 00 
RIP  [<ffffffffa0431175>] hci_conn_hash_flush+0x95/0x120 [bluetooth]
 RSP <ffff8801f33a9d68>


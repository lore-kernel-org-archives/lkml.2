Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198Ab0GHAVy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 20:21:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41659 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756765Ab0GHAVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 20:21:53 -0400
Date: Wed, 7 Jul 2010 17:21:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: linux-next: Tree for July 7
Message-Id: <20100707172136.3658fb17.akpm@linux-foundation.org>
In-Reply-To: <20100707165539.957e7d1c.sfr@canb.auug.org.au>
References: <20100707165539.957e7d1c.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(resend with viro cc)

On Wed, 7 Jul 2010 16:55:39 +1000
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> I have created today's linux-next tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> (patches at http://www.kernel.org/pub/linux/kernel/v2.6/next/ ).

I'm getting a vast stream of BUG()s from the

	BUG_ON(inode->i_state != (I_FREEING | I_CLEAR));

in iput_final().

After turning it into a WARN_ON():

[   49.780786] inode->i_state=0x67
[   49.780945] ------------[ cut here ]------------
[   49.781113] WARNING: at fs/inode.c:1246 iput+0x232/0x23f()
[   49.781279] Modules linked in: dm_mirror dm_region_hash dm_log dm_multipath dm_mod video output sbs sbshc battery ac lp parport sg ide_cd_mod cdrom option usb_wwan usbserial serio_raw floppy snd_hda_intel snd_hda_codec snd_seq_oss snd_seq_midi_event snd_seq button snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm snd_timer i2c_i801 i2c_core snd soundcore snd_page_alloc pcspkr shpchp ehci_hcd ohci_hcd uhci_hcd
[   49.783960] Pid: 2418, comm: mount Tainted: G        W   2.6.35-rc4 #3
[   49.784127] Call Trace:
[   49.784288]  [<ffffffff810cec31>] ? iput+0x1fe/0x23f
[   49.784454]  [<ffffffff810cec65>] ? iput+0x232/0x23f
[   49.784623]  [<ffffffff81036283>] warn_slowpath_common+0x7e/0x97
[   49.784790]  [<ffffffff810362b1>] warn_slowpath_null+0x15/0x17
[   49.784958]  [<ffffffff810cec65>] iput+0x232/0x23f
[   49.785134]  [<ffffffff810c59a5>] do_unlinkat+0x104/0x15a
[   49.785301]  [<ffffffff81002a1c>] ? sysret_check+0x27/0x62
[   49.785470]  [<ffffffff8137518b>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   49.785639]  [<ffffffff810c5a0c>] sys_unlink+0x11/0x13
[   49.785806]  [<ffffffff810029eb>] system_call_fastpath+0x16/0x1b
[   49.785973] ---[ end trace 6458c1d95dac3fde ]---

So I_DIRTY_SYNC, I_DIRTY_DATASYNC and I_DIRTY_PAGES are set.

Config: http://userweb.kernel.org/~akpm/stuff/config-akpm2.txt

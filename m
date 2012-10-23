Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933293Ab2JWQ4I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 12:56:08 -0400
Received: from mx1.netapp.com ([216.240.18.38]:36134 "EHLO mx1.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932939Ab2JWQ4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 12:56:04 -0400
X-IronPort-AV: E=Sophos;i="4.80,635,1344236400"; 
   d="scan'208";a="220947710"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
CC: Nix <nix@esperi.org.uk>, "Ted Ts'o" <tytso@mit.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Schumaker, Bryan" <Bryan.Schumaker@netapp.com>,
        Peng Tao <bergwolf@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>
Subject: Re: Heads-up: 3.6.2 / 3.6.3 NFS server oops: 3.6.2+ regression?
 (also an unrelated ext4 data loss bug)
Thread-Topic: Heads-up: 3.6.2 / 3.6.3 NFS server oops: 3.6.2+ regression?
 (also an unrelated ext4 data loss bug)
Thread-Index: AQHNsTwB4bFApwWkDUaJq39XtFx3BJfHjr2AgAACrwA=
Date: Tue, 23 Oct 2012 16:56:00 +0000
Message-ID: <4FA345DA4F4AE44899BD2B03EEEC2FA90928CA6F@SACEXCMBX04-PRD.hq.netapp.com>
References: <87objupjlr.fsf@spindle.srvr.nix>
	 <20121023013343.GB6370@fieldses.org> <87mwzdnuww.fsf@spindle.srvr.nix>
	 <20121023143019.GA3040@fieldses.org> <874nllxi7e.fsf_-_@spindle.srvr.nix>
	 <20121023164621.GC3040@fieldses.org>
In-Reply-To: <20121023164621.GC3040@fieldses.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.116]
Content-Type: text/plain; charset="utf-8"
Content-ID: <B4B4C00458EFBB4CA0170B0FCADE78EF@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9NGuFLe004702

On Tue, 2012-10-23 at 12:46 -0400, J. Bruce Fields wrote:
> On Tue, Oct 23, 2012 at 05:32:21PM +0100, Nix wrote:
> > On 23 Oct 2012, J. Bruce Fields uttered the following:
> > > nfs-utils shouldn't be capable of oopsing the kernel, so from my
> > > (selfish) point of view I'd actually rather you stick with whatever you
> > > have and try to reproduce the oops.
> > 
> > Reproduced in 3.6.3, not in 3.6.1, not tried 3.6.2. Capturing it was
> > rendered somewhat difficult by an ext4/JBD2 bug which leads to data loss
> > in /var on every reboot out of 3.6.1 and on some reboots out of 3.6.3 (I
> > have runs of NULs in my logs now, which keep eating the oopses):
> > 
> > [while in 3.6.1]
> > [   88.565698] JBD2: Spotted dirty metadata buffer (dev = dm-5, blocknr = 0). There's a risk of filesystem corruption in case of system crash.
> > [   88.799263] JBD2: Spotted dirty metadata buffer (dev = dm-5, blocknr = 0). There's a risk of filesystem corruption in case of system crash.
> > [   89.648152] ------------[ cut here ]------------
> > [   89.648386] WARNING: at fs/inode.c:280 drop_nlink+0x25/0x42()
> > [   89.648614] Hardware name: empty
> > [   89.648833] Modules linked in: firewire_ohci firewire_core [last unloaded: microcode]
> > [   89.649382] Pid: 1484, comm: dhcpd Not tainted 3.6.1-dirty #1
> > [   89.649610] Call Trace:
> > [   89.649832]  [<ffffffff810608c0>] warn_slowpath_common+0x83/0x9b
> > [   89.650063]  [<ffffffff810608f2>] warn_slowpath_null+0x1a/0x1c
> > [   89.650292]  [<ffffffff8112efbf>] drop_nlink+0x25/0x42
> > [   89.650533]  [<ffffffff81187112>] ext4_dec_count+0x26/0x28
> > [   89.650763]  [<ffffffff8118abb8>] ext4_rename+0x4ec/0x7b4
> > [   89.650993]  [<ffffffff81125d81>] ? vfs_rename+0xbe/0x3b7
> > [   89.651224]  [<ffffffff81125f3f>] vfs_rename+0x27c/0x3b7
> > [   89.651454]  [<ffffffff81127a53>] sys_renameat+0x1b1/0x228
> > [   89.651682]  [<ffffffff8114bda1>] ? fsnotify+0x226/0x249
> > [   89.651911]  [<ffffffff81239b75>] ? security_inode_permission+0x1e/0x20
> > [   89.652145]  [<ffffffff8111a240>] ? vfs_write+0x116/0x142
> > [   89.652372]  [<ffffffff81127ae5>] sys_rename+0x1b/0x1e
> > [   89.652601]  [<ffffffff814fffa2>] system_call_fastpath+0x16/0x1b
> > [...]
> > [while having just booted into 3.6.1 after some time in 3.6.3: the FS
> >  was clean, and fscked on the previous boot into 3.6.3 after a previous
> >  instance of this bug]
> > Oct 23 17:18:26 spindle crit: [   67.625319] EXT4-fs error (device dm-5): mb_free_blocks:1300: group 65, block 2143748:freeing already freed block (bit 13828)
> > 
> > This may well be a 3.6.1-specific bug fixed in 3.6.3, but it's hard to
> > tell since most of my reboots are 3.6.1->3.6.3 or vice versa right now.
> > 
> > 
> > Anyway, here's the NFSv4 oops (not a panic: it helps if I remember to
> > turn off panic_on_oops when I come home from the holidays).
> > 
> > It's a lockd problem, and probably happens during delivery of mail over
> > NFS (my mailserver load soars when it happens):
> > 
> > [  813.110354] ------------[ cut here ]------------
> > [  813.110585] kernel BUG at fs/lockd/mon.c:150!
> 
> So nsm_mon_unmon() is being passed a NULL client.
> 
> There are three container patches between 3.6.1 and 3.6.3:
> 
> 	lockd: per-net NSM client creation and destruction helpers introduced
> 	lockd: use rpc client's cl_nodename for id encoding
> 	lockd: create and use per-net NSM RPC clients on MON/UNMON requests
> 
> and that last does change nsm_monitor's call to nsm_mon_unmon, so that's
> almost certainly it....
> 
> Looks like there's some confusion about whether nsm_client_get() returns
> NULL or an error?

nsm_client_get() looks extremely racy in the case where ln->nsm_users ==
0.

Since we never recheck the value of ln->nsm_users after taking
nsm_create_mutex, what is stopping 2 different threads from both setting
ln->nsm_clnt and re-initialising ln->nsm_users?


-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

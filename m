Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098Ab2K2WGZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 17:06:25 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:55588 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754545Ab2K2WGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 17:06:23 -0500
MIME-Version: 1.0
In-Reply-To: <20121129213316.GU4939@ZenIV.linux.org.uk>
References: <CAE2NFgU+4QDcLaVE5dKDvZCxey7qEf7FAbYNjNmcjVU=HLhF=A@mail.gmail.com>
	<20121129213316.GU4939@ZenIV.linux.org.uk>
Date: Thu, 29 Nov 2012 14:06:22 -0800
Message-ID: <CAE2NFgWCnmgSCsw7MzRkqBLTHgRDG-FvKKcbTHN6UqePK6Ef+Q@mail.gmail.com>
Subject: Re: Regression with initramfs and nfsroot (appears to be in the dcache)
From: Patrick McLean <patrickm@gaikai.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 1:33 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Thu, Nov 29, 2012 at 11:16:59AM -0800, Patrick McLean wrote:
>> With 3.6-rc1 and up, when using a (dracut) initramfs with a read-only
>> nfs root, all accesses to /proc. /sys and /dev return EBUSY.
>
> See "[PATCH] Revert "__d_unalias() should refuse to move mountpoints"
> thread.  If you have a convenient reproducer, could you check if
> the fixes the breakage?  If so, we'll need to look into false negatives
> from nfs_same_file() in there...
>
> diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
> index ce8cb92..55436f5 100644
> --- a/fs/nfs/dir.c
> +++ b/fs/nfs/dir.c
> @@ -450,7 +450,10 @@ void nfs_prime_dcache(struct dentry *parent, struct nfs_entry *entry)
>                         nfs_refresh_inode(dentry->d_inode, entry->fattr);
>                         goto out;
>                 } else {
> -                       d_drop(dentry);
> +                       if (d_invalidate(dentry) != 0) {
> +                               WARN_ON(1);
> +                               goto out;
> +                       }
>                         dput(dentry);
>                 }
>         }

I have a trivial reproducer and am happy to help debug in any way that
I can. That patch seems to fix the problem, and produces these
warnings in dmesg:

[    3.306483] dracut: Switching root
[    4.324378] systemd-udevd[552]: starting version 195
[    9.254972] ------------[ cut here ]------------
[    9.254981] WARNING: at fs/nfs/dir.c:454
nfs_readdir_page_filler+0x1cc/0x3a2()
[    9.254983] Hardware name: Bochs
[    9.254984] Modules linked in:
[    9.254989] Pid: 676, comm: ls Not tainted 3.7.0-rc7+ #35
[    9.254990] Call Trace:
[    9.254999]  [<ffffffff8108534c>] ? warn_slowpath_common+0x76/0x8a
[    9.255002]  [<ffffffff8117de91>] ? nfs_readdir_page_filler+0x1cc/0x3a2
[    9.255005]  [<ffffffff8117e683>] ? nfs_readdir_xdr_to_array+0x1c0/0x22d
[    9.255009]  [<ffffffff8117e70c>] ? nfs_readdir_filler+0x1c/0x6b
[    9.255014]  [<ffffffff810dca9a>] ? add_to_page_cache_lru+0x2c/0x36
[    9.255017]  [<ffffffff8117e6f0>] ? nfs_readdir_xdr_to_array+0x22d/0x22d
[    9.255020]  [<ffffffff810dcbe3>] ? do_read_cache_page+0x7d/0x12b
[    9.255025]  [<ffffffff811274f8>] ? sys_ioctl+0x7a/0x7a
[    9.255028]  [<ffffffff810dccc6>] ? read_cache_page+0x7/0x10
[    9.255031]  [<ffffffff8117e888>] ? nfs_readdir+0x12d/0x435
[    9.255036]  [<ffffffff8118e653>] ? nfs3_xdr_dec_create3res+0xc5/0xc5
[    9.255039]  [<ffffffff811274f8>] ? sys_ioctl+0x7a/0x7a
[    9.255042]  [<ffffffff811274f8>] ? sys_ioctl+0x7a/0x7a
[    9.255045]  [<ffffffff811277b3>] ? vfs_readdir+0x6c/0xa7
[    9.255049]  [<ffffffff811278da>] ? sys_getdents+0x7e/0xdc
[    9.255053]  [<ffffffff814ac769>] ? system_call_fastpath+0x16/0x1b
[    9.255055] ---[ end trace 5e8b5f37fe752ab1 ]---
[    9.255062] ------------[ cut here ]------------
[    9.255065] WARNING: at fs/nfs/dir.c:454
nfs_readdir_page_filler+0x1cc/0x3a2()
[    9.255066] Hardware name: Bochs
[    9.255067] Modules linked in:
[    9.255070] Pid: 676, comm: ls Tainted: G        W    3.7.0-rc7+ #35
[    9.255071] Call Trace:
[    9.255075]  [<ffffffff8108534c>] ? warn_slowpath_common+0x76/0x8a
[    9.255077]  [<ffffffff8117de91>] ? nfs_readdir_page_filler+0x1cc/0x3a2
[    9.255080]  [<ffffffff8117e683>] ? nfs_readdir_xdr_to_array+0x1c0/0x22d
[    9.255083]  [<ffffffff8117e70c>] ? nfs_readdir_filler+0x1c/0x6b
[    9.255087]  [<ffffffff810dca9a>] ? add_to_page_cache_lru+0x2c/0x36
[    9.255089]  [<ffffffff8117e6f0>] ? nfs_readdir_xdr_to_array+0x22d/0x22d
[    9.255093]  [<ffffffff810dcbe3>] ? do_read_cache_page+0x7d/0x12b
[    9.255096]  [<ffffffff811274f8>] ? sys_ioctl+0x7a/0x7a
[    9.255099]  [<ffffffff810dccc6>] ? read_cache_page+0x7/0x10
[    9.255102]  [<ffffffff8117e888>] ? nfs_readdir+0x12d/0x435
[    9.255105]  [<ffffffff8118e653>] ? nfs3_xdr_dec_create3res+0xc5/0xc5
[    9.255109]  [<ffffffff811274f8>] ? sys_ioctl+0x7a/0x7a
[    9.255112]  [<ffffffff811274f8>] ? sys_ioctl+0x7a/0x7a
[    9.255115]  [<ffffffff811277b3>] ? vfs_readdir+0x6c/0xa7
[    9.255118]  [<ffffffff811278da>] ? sys_getdents+0x7e/0xdc
[    9.255121]  [<ffffffff814ac769>] ? system_call_fastpath+0x16/0x1b
[    9.255122] ---[ end trace 5e8b5f37fe752ab2 ]---
[    9.255133] ------------[ cut here ]------------
[    9.255135] WARNING: at fs/nfs/dir.c:454
nfs_readdir_page_filler+0x1cc/0x3a2()
[    9.255136] Hardware name: Bochs
[    9.255137] Modules linked in:
[    9.255140] Pid: 676, comm: ls Tainted: G        W    3.7.0-rc7+ #35
[    9.255141] Call Trace:
[    9.255144]  [<ffffffff8108534c>] ? warn_slowpath_common+0x76/0x8a
[    9.255147]  [<ffffffff8117de91>] ? nfs_readdir_page_filler+0x1cc/0x3a2
[    9.255150]  [<ffffffff8117e683>] ? nfs_readdir_xdr_to_array+0x1c0/0x22d
[    9.255153]  [<ffffffff8117e70c>] ? nfs_readdir_filler+0x1c/0x6b
[    9.255157]  [<ffffffff810dca9a>] ? add_to_page_cache_lru+0x2c/0x36
[    9.255159]  [<ffffffff8117e6f0>] ? nfs_readdir_xdr_to_array+0x22d/0x22d
[    9.255162]  [<ffffffff810dcbe3>] ? do_read_cache_page+0x7d/0x12b
[    9.255166]  [<ffffffff811274f8>] ? sys_ioctl+0x7a/0x7a
[    9.255169]  [<ffffffff810dccc6>] ? read_cache_page+0x7/0x10
[    9.255171]  [<ffffffff8117e888>] ? nfs_readdir+0x12d/0x435
[    9.255175]  [<ffffffff8118e653>] ? nfs3_xdr_dec_create3res+0xc5/0xc5
[    9.255178]  [<ffffffff811274f8>] ? sys_ioctl+0x7a/0x7a
[    9.255181]  [<ffffffff811274f8>] ? sys_ioctl+0x7a/0x7a
[    9.255184]  [<ffffffff811277b3>] ? vfs_readdir+0x6c/0xa7
[    9.255188]  [<ffffffff811278da>] ? sys_getdents+0x7e/0xdc
[    9.255190]  [<ffffffff814ac769>] ? system_call_fastpath+0x16/0x1b
[    9.255192] ---[ end trace 5e8b5f37fe752ab3 ]---

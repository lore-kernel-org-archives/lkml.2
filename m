Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940Ab2K2WVM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 17:21:12 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:56742 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006Ab2K2WVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 17:21:10 -0500
Date: Thu, 29 Nov 2012 22:21:09 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Patrick McLean <patrickm@gaikai.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Regression with initramfs and nfsroot (appears to be in the
 dcache)
Message-ID: <20121129222109.GW4939@ZenIV.linux.org.uk>
References: <CAE2NFgU+4QDcLaVE5dKDvZCxey7qEf7FAbYNjNmcjVU=HLhF=A@mail.gmail.com>
 <20121129213316.GU4939@ZenIV.linux.org.uk>
 <CAE2NFgWCnmgSCsw7MzRkqBLTHgRDG-FvKKcbTHN6UqePK6Ef+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE2NFgWCnmgSCsw7MzRkqBLTHgRDG-FvKKcbTHN6UqePK6Ef+Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 02:06:22PM -0800, Patrick McLean wrote:

> I have a trivial reproducer and am happy to help debug in any way that
> I can. That patch seems to fix the problem, and produces these
> warnings in dmesg:
> 
> [    3.306483] dracut: Switching root
> [    4.324378] systemd-udevd[552]: starting version 195
> [    9.254972] ------------[ cut here ]------------
> [    9.254981] WARNING: at fs/nfs/dir.c:454
> nfs_readdir_page_filler+0x1cc/0x3a2()
> [    9.254983] Hardware name: Bochs
> [    9.254984] Modules linked in:
> [    9.254989] Pid: 676, comm: ls Not tainted 3.7.0-rc7+ #35
> [    9.254990] Call Trace:
> [    9.254999]  [<ffffffff8108534c>] ? warn_slowpath_common+0x76/0x8a
> [    9.255002]  [<ffffffff8117de91>] ? nfs_readdir_page_filler+0x1cc/0x3a2
> [    9.255005]  [<ffffffff8117e683>] ? nfs_readdir_xdr_to_array+0x1c0/0x22d
> [    9.255009]  [<ffffffff8117e70c>] ? nfs_readdir_filler+0x1c/0x6b
> [    9.255014]  [<ffffffff810dca9a>] ? add_to_page_cache_lru+0x2c/0x36
> [    9.255017]  [<ffffffff8117e6f0>] ? nfs_readdir_xdr_to_array+0x22d/0x22d
> [    9.255020]  [<ffffffff810dcbe3>] ? do_read_cache_page+0x7d/0x12b
> [    9.255025]  [<ffffffff811274f8>] ? sys_ioctl+0x7a/0x7a
> [    9.255028]  [<ffffffff810dccc6>] ? read_cache_page+0x7/0x10
> [    9.255031]  [<ffffffff8117e888>] ? nfs_readdir+0x12d/0x435
> [    9.255036]  [<ffffffff8118e653>] ? nfs3_xdr_dec_create3res+0xc5/0xc5
> [    9.255039]  [<ffffffff811274f8>] ? sys_ioctl+0x7a/0x7a
> [    9.255042]  [<ffffffff811274f8>] ? sys_ioctl+0x7a/0x7a
> [    9.255045]  [<ffffffff811277b3>] ? vfs_readdir+0x6c/0xa7
> [    9.255049]  [<ffffffff811278da>] ? sys_getdents+0x7e/0xdc
> [    9.255053]  [<ffffffff814ac769>] ? system_call_fastpath+0x16/0x1b
> [    9.255055] ---[ end trace 5e8b5f37fe752ab1 ]---

OK...  So we have differing entry->fh and NFS_FH(dentry->d_inode).  Something
like
static void dump_fh(const struct nfs_fh *fh)
{
	int i;
	printk(KERN_INFO "FH(%d)", fh->size);
	for (i = 0; i < fh->size; i++)
		printk(KERN_CONT "%c%02x", i ? ' ' : '[', fh->data[i]);
	printk(KERN_CONT "]\n");
}
with dump_fh(entry->fh); dump_fh(NFS_FH(dentry->d_inode)); added next to
that WARN_ON(1) would probably be interesting.  And probably would make
sense to print filename->name as well, to see which files it is about.

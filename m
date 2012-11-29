Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962Ab2K2Wx6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 17:53:58 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:55355 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217Ab2K2Wxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 17:53:55 -0500
Message-ID: <50B7E759.9070007@gaikai.com>
Date: Thu, 29 Nov 2012 14:53:13 -0800
From: Patrick McLean <patrickm@gaikai.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Regression with initramfs and nfsroot (appears to be in the dcache)
References: <CAE2NFgU+4QDcLaVE5dKDvZCxey7qEf7FAbYNjNmcjVU=HLhF=A@mail.gmail.com> <20121129213316.GU4939@ZenIV.linux.org.uk> <CAE2NFgWCnmgSCsw7MzRkqBLTHgRDG-FvKKcbTHN6UqePK6Ef+Q@mail.gmail.com> <20121129222109.GW4939@ZenIV.linux.org.uk>
In-Reply-To: <20121129222109.GW4939@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/11/12 02:21 PM, Al Viro wrote:
> On Thu, Nov 29, 2012 at 02:06:22PM -0800, Patrick McLean wrote:
> 
>> I have a trivial reproducer and am happy to help debug in any way that
>> I can. That patch seems to fix the problem, and produces these
>> warnings in dmesg:
> 
> OK...  So we have differing entry->fh and NFS_FH(dentry->d_inode).  Something
> like
> static void dump_fh(const struct nfs_fh *fh)
> {
> 	int i;
> 	printk(KERN_INFO "FH(%d)", fh->size);
> 	for (i = 0; i < fh->size; i++)
> 		printk(KERN_CONT "%c%02x", i ? ' ' : '[', fh->data[i]);
> 	printk(KERN_CONT "]\n");
> }
> with dump_fh(entry->fh); dump_fh(NFS_FH(dentry->d_inode)); added next to
> that WARN_ON(1) would probably be interesting.  And probably would make
> sense to print filename->name as well, to see which files it is about.
> 

Here is the output of the first of the 3 times it hits the WARN_ON (I can include all 3 if desired), with the filename.name at the end:

[    8.821503] ------------[ cut here ]------------
[    8.821512] WARNING: at fs/nfs/dir.c:463 nfs_readdir_page_filler+0x1d0/0x3d2()
[    8.821513] Hardware name: Bochs
[    8.821515] Modules linked in:
[    8.821519] Pid: 630, comm: bash Not tainted 3.7.0-rc7+ #36
[    8.821520] Call Trace:
[    8.821528]  [<ffffffff8108534c>] ? warn_slowpath_common+0x76/0x8a
[    8.821531]  [<ffffffff8117de95>] ? nfs_readdir_page_filler+0x1d0/0x3d2
[    8.821535]  [<ffffffff8117e6b3>] ? nfs_readdir_xdr_to_array+0x1c0/0x22d
[    8.821538]  [<ffffffff8117e73c>] ? nfs_readdir_filler+0x1c/0x6b
[    8.821543]  [<ffffffff810dca9a>] ? add_to_page_cache_lru+0x2c/0x36
[    8.821546]  [<ffffffff8117e720>] ? nfs_readdir_xdr_to_array+0x22d/0x22d
[    8.821549]  [<ffffffff810dcbe3>] ? do_read_cache_page+0x7d/0x12b
[    8.821554]  [<ffffffff811274f8>] ? sys_ioctl+0x7a/0x7a
[    8.821557]  [<ffffffff810dccc6>] ? read_cache_page+0x7/0x10
[    8.821560]  [<ffffffff8117e8b8>] ? nfs_readdir+0x12d/0x435
[    8.821564]  [<ffffffff8118e683>] ? nfs3_xdr_dec_create3res+0xc5/0xc5
[    8.821568]  [<ffffffff811274f8>] ? sys_ioctl+0x7a/0x7a
[    8.821571]  [<ffffffff811274f8>] ? sys_ioctl+0x7a/0x7a
[    8.821574]  [<ffffffff811277b3>] ? vfs_readdir+0x6c/0xa7
[    8.821577]  [<ffffffff811278da>] ? sys_getdents+0x7e/0xdc
[    8.821581]  [<ffffffff814ac7e9>] ? system_call_fastpath+0x16/0x1b
[    8.821583] ---[ end trace 89263124889205c1 ]---
[    8.821584] FH(0)]
[    8.821586] FH(36)[01 00 07 01 89 00 00 00 00 00 00 00 e1 21 fe c4 9e 38 44 dc bf 1b d5 95 d6 76 d6 d9 a7 3c 1b 80 33 38 e3 62]
[    8.821601] filename: proc

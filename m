Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062Ab1GBAuj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 20:50:39 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:55509 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735Ab1GBAug (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 20:50:36 -0400
Message-ID: <4E0E6B59.2000303@msgid.tls.msk.ru>
Date: Sat, 02 Jul 2011 04:50:33 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.16) Gecko/20110506 Icedove/3.0.11
MIME-Version: 1.0
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@ZenIV.linux.org.uk
Subject: Re: [-v3] vfs: make unlink() and rmdir() return ENOENT in preference
 to EROFS
References: <1307402380-14166-1-git-send-email-tytso@mit.edu>
In-Reply-To: <1307402380-14166-1-git-send-email-tytso@mit.edu>
X-Enigmail-Version: 1.0.1
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

07.06.2011 03:19, Theodore Tso wrote:
> If user space attempts to remove a non-existent file or directory, and
> the file system is mounted read-only, return ENOENT instead of EROFS.
> Either error code is arguably valid/correct, but ENOENT is a more
> specific error message.
> 
> Reported-by: Michael Tokarev <mjt@tls.msk.ru>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> 
> ---
> fs/namei.c |   11 +++++++----
>  1 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/namei.c b/fs/namei.c
> index 1ab641f..647ca6e 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -2623,6 +2623,10 @@ static long do_rmdir(int dfd, const char __user *pathname)
>  	error = PTR_ERR(dentry);
>  	if (IS_ERR(dentry))
>  		goto exit2;
> +	if (!dentry->d_inode) {
> +		error = -ENOENT;
> +		goto exit3;
> +	}
>  	error = mnt_want_write(nd.path.mnt);
>  	if (error)
>  		goto exit3;
> @@ -2708,11 +2712,10 @@ static long do_unlinkat(int dfd, const char __user *pathname)
>  	error = PTR_ERR(dentry);
>  	if (!IS_ERR(dentry)) {
>  		/* Why not before? Because we want correct error value */
> -		if (nd.last.name[nd.last.len])
> -			goto slashes;
>  		inode = dentry->d_inode;
> -		if (inode)
> -			ihold(inode);
> +		if (nd.last.name[nd.last.len] || !inode)
> +			goto slashes;
> +		ihold(inode);
>  		error = mnt_want_write(nd.path.mnt);
>  		if (error)
>  			goto exit2;

With this patch applied on top of 2.6.39 I can trigger a BUG_ON
condition like this:

[  211.506827] ------------[ cut here ]------------
[  211.506919] kernel BUG at fs/inode.c:1409!
[  211.507003] invalid opcode: 0000 [#1] SMP
[  211.507095] last sysfs file: /sys/devices/pci0000:00/0000:00:11.0/host5/target5:0:0/5:0:0:0/block/sdb/uevent
[  211.507284] CPU 0
[  211.507318] Modules linked in: bnep rfcomm bluetooth rfkill autofs4 quota_v2 quota_tree fuse nfsd nfs lockd fscache auth_rpcgss
[  211.509512]
[  211.509547] Pid: 3159, comm: rm Not tainted 2.6.39-amd64 #1 System manufacturer System Product Name/M3A78-EM
[  211.509761] RIP: 0010:[<ffffffff81137e58>]  [<ffffffff81137e58>] iput+0x198/0x1d0
[  211.509918] RSP: 0018:ffff880169af3e88  EFLAGS: 00010202
[  211.509983] RAX: 0000000000000000 RBX: ffff8801809988a0 RCX: 00000000ffff984e
[  211.509983] RDX: ffff8801877075a8 RSI: ffffffffa012f1b0 RDI: ffff8801809988a0
[  211.509983] RBP: ffff8801809988a0 R08: d018000000000000 R09: ffff8801809987f0
[  211.509983] R10: ffff88012c258338 R11: 0000000000000000 R12: ffff880131062ec0
[  211.509983] R13: ffff880131062ec0 R14: ffff88019e836080 R15: ffff88012b6f5f10
[  211.509983] FS:  0000000000000000(0000) GS:ffff88019fc00000(0063) knlGS:00000000f765f8d0
[  211.509983] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
[  211.509983] CR2: 00000000082390ac CR3: 000000018734c000 CR4: 00000000000006f0
[  211.509983] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  211.509983] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  211.509983] Process rm (pid: 3159, threadinfo ffff880169af2000, task ffff88018734a0c0)
[  211.509983] Stack:
[  211.509983]  ffff8801877075e8 ffff880180997c00 ffff8801809988a0 ffff880131062ec0
[  211.509983]  ffff880131062ec0 ffffffff811333b0 ffff880180997c00 ffff8801809988a0
[  211.509983]  ffff880180997c5c ffffffff811345aa ffff88012b6f5f00 ffff88012b6f5f00
[  211.509983] Call Trace:
[  211.509983]  [<ffffffff811333b0>] ? d_kill+0xf0/0x130
[  211.509983]  [<ffffffff811345aa>] ? dput+0xca/0x180
[  211.509983]  [<ffffffff81121054>] ? fput+0x1b4/0x270
[  211.509983]  [<ffffffff8111d43c>] ? filp_close+0x5c/0x90
[  211.509983]  [<ffffffff8111d4fb>] ? sys_close+0x8b/0xe0
[  211.509983]  [<ffffffff8134f8a0>] ? cstar_dispatch+0x7/0x2e
[  211.509983] Code: d1 48 8b 15 8b ab 35 00 48 89 42 08 48 89 53 78 48 c7 83 80 00 00 00 c0 29 49 81 48 89 05 71 ab 35 00 83 05 e
[  211.509983] RIP  [<ffffffff81137e58>] iput+0x198/0x1d0
[  211.509983]  RSP <ffff880169af3e88>
[  211.546040] ---[ end trace f3b7c3bd13474628 ]---

This is happening on a debian system when running update-menus while
lxde is running.  When update-menus is run it executes

 rm -rf /var/lib/menu-xdg/desktop-directories/menu-xdg/

and regenerates it, and lxde is watching that directory somehow
in order to notice updates (I think anyway).  I can't trigger
this BUG_ON without my X running (but I did not try other
desktop environments).

The place where this BUG_ON is looks like this:

void iput(struct inode *inode)
{
        if (inode) {
                BUG_ON(inode->i_state & I_CLEAR);

                if (atomic_dec_and_lock(&inode->i_count, &inode->i_lock))
                        iput_final(inode);
        }
}


Something fishy is going on there...

Thank you!

/mjt

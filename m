Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab2AHXuu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 18:50:50 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:46202 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748Ab2AHXus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 18:50:48 -0500
Date: Sun, 8 Jan 2012 23:50:40 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miklos Szeredi <mszeredi@suse.cz>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: Re: [git pull] vfs pile 1
Message-ID: <20120108235039.GQ23916@ZenIV.linux.org.uk>
References: <20120105022318.GG23916@ZenIV.linux.org.uk>
 <CA+55aFw+7xvfP3NCr5p2Ma--UTb7zT+QQxtjCn3V2SU_g3LUdA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw+7xvfP3NCr5p2Ma--UTb7zT+QQxtjCn3V2SU_g3LUdA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 08, 2012 at 03:04:30PM -0800, Linus Torvalds wrote:
> Hmm.
> 
> Al, Miklos, I just triggered the new inc_link() warning three times in
> very close succession by just doing a simple
> 
>               perf record -f -e cycles:pp make -j
> 
> (I don't think the "perf record" part was actually required or
> relevant, although it may have been instrumental in triggering just
> the right timing)
> 
> This was in a fully built tree, I'm just checking
> 
> The warning trace looks like this:
> 
>   [ 6933.446125] ------------[ cut here ]------------
>   [ 6933.446131] WARNING: at fs/inode.c:349 inc_nlink+0x30/0x40()
>   [ 6933.446133] Hardware name: System Product Name
>   [ 6933.446135] Pid: 22955, comm: perf Not tainted
> 3.2.0-03190-g972b2c719990 #72
>   [ 6933.446137] Call Trace:
>   [ 6933.446143]  [<ffffffff8102ee15>] warn_slowpath_common+0x75/0xb0
>   [ 6933.446145]  [<ffffffff8102ef15>] warn_slowpath_null+0x15/0x20
>   [ 6933.446147]  [<ffffffff810f1450>] inc_nlink+0x30/0x40
>   [ 6933.446151]  [<ffffffff8116f333>] ext4_symlink+0x113/0x2c0
>   [ 6933.446154]  [<ffffffff810e7b01>] vfs_symlink+0xa1/0xf0
>   [ 6933.446157]  [<ffffffff810e7c03>] sys_symlinkat+0xb3/0xd0
>   [ 6933.446159]  [<ffffffff810e7c31>] sys_symlink+0x11/0x20
>   [ 6933.446162]  [<ffffffff816916a2>] system_call_fastpath+0x16/0x1b
>   [ 6933.446164] ---[ end trace 550d4b2eb6b8fbc9 ]---
> 
> and the three warnings all triggered within 2/100th of a second of
> that one (the last one had a timestamp of 6933.465678), so they are
> probably all related to the same thing happening.

WTF is ext4_symlink() doing in case of long symlinks?  Look:
                drop_nlink(inode);
                err = ext4_orphan_add(handle, inode);
                ext4_journal_stop(handle);
[write symlink body]
                inc_nlink(inode);
                err = ext4_orphan_del(handle, inode);
oh, I see...  The comment above that re deadlocks and inability to do that
in a single transaction ;-/

OK, try this; that's equivalent to what they are doing and will not WARN_ON();
I hadn't checked other filesystems for similar tricks yet, so this has a good
chance of being incomplete.

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 86edc45..2043f48 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2315,7 +2315,7 @@ retry:
 			err = PTR_ERR(handle);
 			goto err_drop_inode;
 		}
-		inc_nlink(inode);
+		set_nlink(inode, 1);
 		err = ext4_orphan_del(handle, inode);
 		if (err) {
 			ext4_journal_stop(handle);

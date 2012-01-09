Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658Ab2AIPLr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 10:11:47 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:41069 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754125Ab2AIPLp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 10:11:45 -0500
Date: Mon, 9 Jan 2012 10:11:29 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Miklos Szeredi <mszeredi@suse.cz>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: Re: [git pull] vfs pile 1
Message-ID: <20120109151129.GA22175@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Miklos Szeredi <mszeredi@suse.cz>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
References: <20120105022318.GG23916@ZenIV.linux.org.uk>
 <CA+55aFw+7xvfP3NCr5p2Ma--UTb7zT+QQxtjCn3V2SU_g3LUdA@mail.gmail.com>
 <20120108235039.GQ23916@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120108235039.GQ23916@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 08, 2012 at 11:50:40PM +0000, Al Viro wrote:
> 
> WTF is ext4_symlink() doing in case of long symlinks?  Look:
>                 drop_nlink(inode);
>                 err = ext4_orphan_add(handle, inode);
>                 ext4_journal_stop(handle);
> [write symlink body]
>                 inc_nlink(inode);
>                 err = ext4_orphan_del(handle, inode);
> oh, I see...  The comment above that re deadlocks and inability to do that
> in a single transaction ;-/
> 
> OK, try this; that's equivalent to what they are doing and will not WARN_ON();
> I hadn't checked other filesystems for similar tricks yet, so this has a good
> chance of being incomplete.
> 
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 86edc45..2043f48 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -2315,7 +2315,7 @@ retry:
>  			err = PTR_ERR(handle);
>  			goto err_drop_inode;
>  		}
> -		inc_nlink(inode);
> +		set_nlink(inode, 1);
>  		err = ext4_orphan_del(handle, inode);
>  		if (err) {
>  			ext4_journal_stop(handle);

Thanks, looks good to me.

Acked-by: "Theodore Ts'o" <tytso@mit.edu>

What's there is a bit of kludge, granted.  But an attempt to optimize
out placing the inode on and off the orphan list (either by deferring
the start of the ext3/4 journal handle, or by special casing the block
used for the long symlink) would add a lot of complexity, and creating
long symlinks is not common case in most workloads...

						- Ted

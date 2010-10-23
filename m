Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757989Ab0JWQUA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 12:20:00 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47527 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757921Ab0JWQT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 12:19:59 -0400
Date: Sat, 23 Oct 2010 17:19:48 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dave@linux.vnet.ibm.com, akpm@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/9 updated] vfs: protect remounting superblock read-only
Message-ID: <20101023161948.GP19804@ZenIV.linux.org.uk>
References: <20101005103108.288743609@szeredi.hu>
 <20101005103144.051231469@szeredi.hu>
 <20101022064627.GA21607@ZenIV.linux.org.uk>
 <E1P9Gh4-00054y-EA@pomaz-ex.szeredi.hu>
 <E1P9KCY-0005YO-4i@pomaz-ex.szeredi.hu>
 <E1P9KFl-0005ZK-0q@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1P9KFl-0005ZK-0q@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 06:14:01PM +0200, Miklos Szeredi wrote:

> @@ -1782,6 +1844,14 @@ int do_add_mount(struct vfsmount *newmnt
>  
>  	mnt_flags &= ~(MNT_SHARED | MNT_WRITE_HOLD | MNT_INTERNAL);

Obviously not enough - you've just added a new flag that needs to be
trimmed from mnt_flags.

> +	/* Locking is necessary to prevent racing with remount r/o */
> +	down_read(&newmnt->mnt_sb->s_umount);
> +	if (newmnt->mnt_sb->s_flags & MS_RDONLY)
> +		mnt_flags |= MNT_READONLY;
> +
> +	newmnt->mnt_flags = mnt_flags;
> +	up_read(&newmnt->mnt_sb->s_umount);

FWIW, I really don't like the way you are doing that; what we really need
there is a per-sb analog of mnt_want_write()/mnt_drop_write().  With
mnt_want_write() bumping per-sb write count, which would solve all these
problems quite nicely.

NOTE: vfsmount being ro and sb being ro are *independent* things; either
is enough to deny writes.  Having remount ro + remount rw lose the state
of other vfsmounts is a Bad Thing(tm).

Another thing:
	"If clone_mnt() happens while mnt_make_readonly() is running, the
	cloned mount might have MNT_WRITE_HOLD flag set, which results in
	mnt_want_write() spinning forever on this mount."
actually means
	"neither clone_mnt() nor remounts should ever be done without
namespace_sem held exclusive; if that ever happens, we have a serious
bug that can lead to any number of bad things happening".

Do you actually see such places?  If so, that's what needs fixing.

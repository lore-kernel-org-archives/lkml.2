Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751Ab2B0C17 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 21:27:59 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:36828 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753305Ab2B0C15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 21:27:57 -0500
Date: Sun, 26 Feb 2012 19:22:30 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: David Howells <dhowells@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 67/73] ext2: Remove target inode pointer from
 ext2_add_entry() [ver #2]
Message-ID: <20120227002230.GB8044@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	David Howells <dhowells@redhat.com>, linux-fsdevel@vger.kernel.org,
	viro@ZenIV.linux.org.uk, valerie.aurora@gmail.com,
	linux-kernel@vger.kernel.org
References: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
 <20120221180553.25235.8550.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120221180553.25235.8550.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 21, 2012 at 06:05:54PM +0000, David Howells wrote:
>  
> -static inline void ext2_set_de_type(ext2_dirent *de, struct inode *inode)
> +static inline void ext2_set_de_type(ext2_dirent *de, struct super_block *sb,
> +				    umode_t mode, unsigned char file_type)
>  {
> -	umode_t mode = inode->i_mode;
> -	if (EXT2_HAS_INCOMPAT_FEATURE(inode->i_sb, EXT2_FEATURE_INCOMPAT_FILETYPE))
> -		de->file_type = ext2_type_by_mode[(mode & S_IFMT)>>S_SHIFT];
> -	else
> +	if (!EXT2_HAS_INCOMPAT_FEATURE(sb, EXT2_FEATURE_INCOMPAT_FILETYPE)) {
>  		de->file_type = 0;
> +		return;
> +	}
> +
> +	if (file_type)
> +		de->file_type = file_type;
> +	else
> +		de->file_type = ext2_type_by_mode[(mode & S_IFMT) >> S_SHIFT];
>  }

It would be simpler to drop the umode_t mode parameter, and just
always make the caller pass in the correct file_type.  In fact, this
manual calculation only needs to happen in one place, ext2_set_link(),
so might as well move "ext2_type_by_mode[(mode & S_IFMT) >> S_SHIFT]"
to ext2_set_link().

See below....

> -int ext2_add_entry(struct dentry *dentry, struct inode *inode)
> +/*
> + * Called from three settings:
> + *
> + * - Creating a regular entry - de/page NULL, doesn't exist
> + * - Creating a fallthru - de/page NULL, doesn't exist
> + * - Creating a whiteout - de/page set if it exists
> + *
> + * @new_file_type is either EXT2_FT_WHT, EXT2_FT_FALLTHRU, or 0.  If
> + * 0, file type is determined by inode->i_mode.
> + */

One of the things that confused me at first when I reviewed these
patch series is that the patch that introduces whiteouts and
fallthroughs haven't been introduced yet; they come later.  Yet in
this patch and in others, sometimes the comments mention fallthru and
whiteouts earlier.

It might be simpler just to fold the commits that adds fallthrus and
whiteouts into a single patch; and then make sure all of the comments
that mention fallthrus and whiteouts are included there.  I'll
mentioned later, but it's also not clear it makes sense to have
separate INCOMPAT options whiteouts and fallthrus.  Is there any time
when you would have one, but not another?  And why can't it just be an
RO_INCOMPAT option?  As long as the inode number field is zero, older
kernels will simply assume those directory entries represent deleted
entries, which should be fine.

> @@ -660,14 +684,14 @@ int ext2_make_empty(struct inode *inode, struct inode *parent)
>  	de->rec_len = ext2_rec_len_to_disk(EXT2_DIR_REC_LEN(1));
>  	memcpy (de->name, ".\0\0", 4);
>  	de->inode = cpu_to_le32(inode->i_ino);
> -	ext2_set_de_type (de, inode);
> +	ext2_set_de_type (de, inode->i_sb, inode->i_mode, 0);

In this and the following ext2_set_de_type() (for adding the "." and
".." entries in a new directory), the type can *only* be EXT2_FT_DIR.
So why not pass it in explicitly, and save the table lookup?  This is
also why we should be able to drop passing in inode->i_mode to
ext2_set_de_type entirely --- the only place where we really need to
calculate file_type is ext2_set_link().

						- Ted

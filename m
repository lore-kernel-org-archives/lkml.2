Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965188Ab2CAQ5a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 11:57:30 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:46708 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964779Ab2CAQ52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 11:57:28 -0500
Date: Thu, 1 Mar 2012 16:57:26 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: .. anybody know of any filesystems that depend on the exact VFS
 'namehash' implementation?
Message-ID: <20120301165726.GF23916@ZenIV.linux.org.uk>
References: <CA+55aFyv=OKUuAV6pqdmbHeUL7Motsh+n026nWqaT63aEgBjBQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyv=OKUuAV6pqdmbHeUL7Motsh+n026nWqaT63aEgBjBQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 03:36:09PM -0800, Linus Torvalds wrote:
> However, doing the same thing for link_path_walk() would require that
> we actually change the hash function we use internally in the VFS
> layer, and while I think that shouldn't really be a problem, I worry
> that some filesystem might actually use the hash we generate and save
> it somewhere on disk (rather than only use it for the hashed lookup
> itself).
> 
> Computing the hash one long-word at a time is trivial if we just
> change what the hash is. Finding the terminating NUL or '/' characters
> that involves some big constants (0x2f2f2f2f2f2f2f2f,
> 0x0101010101010101 and 0x8080808080808080 but seems similarly fairly
> easy. But if filesystems actually depend on our current hash
> algorithm, the word-at-a-time model falls apart.

As long as full_name_hash() is still around, any such filesystem is welcome
to use it for ->d_hash() and STFU.

Note that there are places like this one (in btrfs_real_readdir())
                        q.name = name_ptr;
                        q.len = name_len;
                        q.hash = full_name_hash(q.name, q.len);  
                        tmp = d_lookup(filp->f_dentry, &q);
and they _will_ need to be updated if we switch the default.  I'd be more
worried about that kind of breakage, TBH, than anything leaking hash
on disk without bothering to calculate it manually (if nothing else,
finn_name_hash() is not endian-neutral, so any such place is buggy for
another reason already).

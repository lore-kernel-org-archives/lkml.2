Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133Ab2CASeK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 13:34:10 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:39756 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756006Ab2CASeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 13:34:08 -0500
Date: Thu, 1 Mar 2012 13:34:03 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: .. anybody know of any filesystems that depend on the exact VFS
 'namehash' implementation?
Message-ID: <20120301183403.GF5054@shiny>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
References: <CA+55aFyv=OKUuAV6pqdmbHeUL7Motsh+n026nWqaT63aEgBjBQ@mail.gmail.com>
 <20120301165726.GF23916@ZenIV.linux.org.uk>
 <CA+55aFzxWifxyFSpQfuztmOiyBQpYfiM560DWXoooZ8j8p3fYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFzxWifxyFSpQfuztmOiyBQpYfiM560DWXoooZ8j8p3fYw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090203.4F4FC11E.0093,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2012 at 09:14:13AM -0800, Linus Torvalds wrote:
> On Thu, Mar 1, 2012 at 8:57 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > As long as full_name_hash() is still around, any such filesystem is welcome
> > to use it for ->d_hash() and STFU.
> 
> Well, I'd make full_name_hash() match the new hash model, so no, they
> couldn't use that. They'd have to actually implement the old hash, and
> make it "their hash".
> 
> Also note that the hash model would have to become dependent on config
> options: doing things a word at a time really only works well on
> architectures that have fast unaligned accesses, and even on those
> archtiectures it really doesn't work if you enable
> CONFIG_DEBUG_PAGE_ALLOC.
> 
> > Note that there are places like this one (in btrfs_real_readdir())
> >                        q.name = name_ptr;
> >                        q.len = name_len;
> >                        q.hash = full_name_hash(q.name, q.len);
> >                        tmp = d_lookup(filp->f_dentry, &q);
> > and they _will_ need to be updated if we switch the default.
> 
> I don't agree that it will need to be updated - I was planning on just
> updating full_name_hash() to always match. That part is easy and
> obvious.

Just to clarify, btrfs isn't putting the dcache hashes on disk.  The
code above is part of our optimization to preload some information we
find during readdir to reduce IO when the file is later opened.

On disk we're crc32c only.

-chris

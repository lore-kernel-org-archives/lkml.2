Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab2DRArK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 20:47:10 -0400
Received: from fieldses.org ([174.143.236.118]:46208 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752229Ab2DRArJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 20:47:09 -0400
Date: Tue, 17 Apr 2012 20:47:06 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] vfs and fs fixes
Message-ID: <20120418004706.GA1924@fieldses.org>
References: <20120417052511.GU6589@ZenIV.linux.org.uk>
 <CA+55aFw75=Mtq1njQ9vNmNsGuTPbpUhLHnb7YBLmCZs4Q5ByMA@mail.gmail.com>
 <20120417180129.GW6589@ZenIV.linux.org.uk>
 <20120417182825.GX6589@ZenIV.linux.org.uk>
 <20120417211419.GC27426@fieldses.org>
 <CA+55aFwdh_QWG-R2FQ71kDXiNYZ04qPANBsY_PssVUwEBH4uSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFwdh_QWG-R2FQ71kDXiNYZ04qPANBsY_PssVUwEBH4uSw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 03:08:26PM -0700, Linus Torvalds wrote:
> On Tue, Apr 17, 2012 at 2:14 PM, J. Bruce Fields <bfields@fieldses.org> wrote:
> > On Tue, Apr 17, 2012 at 07:28:26PM +0100, Al Viro wrote:>
> > Maybe instead I could continue using the i_mutex but handle rename some
> > other way; e.g. in delegation code:
> >
> >        if (!mutex_trylock(inode->i_mutex))
> >                return -EAGAIN;
> >        if (atomic_read(inode->i_renames_in_progress))
> >                return -EAGAIN;
> >
> > and add an
> >
> >        atomic_inc(inode->i_renames_in_progress);
> >        atomic_dec(inode->i_renames_in_progress);
> >
> > pair around rename.
> 
> Please don't make up your own locking. Plus it's broken anyway, since
> a rename could come in directly after your atomic_read (and this is
> *why* people shouldn't make up their own locks - they are invariably
> broken).

Doh, yes, sounds like a good rule.  (I was misremembering some previous
attempt at this--which admittedly may just have failed in some more
complicated way.)

--b.

> > Or I could increment that counter for all the conflicting operations and
> > rely on it instead of the i_mutex.  I was trying to avoid adding
> > something like that (an inc, a dec, another error path) to every
> > operation.  And hoping to avoid adding another field to struct inode.
> > Oh well.
> 
> We could just say that we can do a double inode lock, but then
> standardize on the order. And the only sane order is comparing inode
> pointers, not inode numbers like ext4 apparently does.
> 
> With a standard order, I don't think it would be at all wrong to just
> take the inode lock on rename.
> 
>                         Linus

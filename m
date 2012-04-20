Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab2DTLPY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 07:15:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37467 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754746Ab2DTLPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 07:15:22 -0400
Date: Fri, 20 Apr 2012 13:15:17 +0200
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "J. Bruce Fields" <bfields@fieldses.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] vfs and fs fixes
Message-ID: <20120420111517.GB8985@quack.suse.cz>
References: <20120417052511.GU6589@ZenIV.linux.org.uk>
 <CA+55aFw75=Mtq1njQ9vNmNsGuTPbpUhLHnb7YBLmCZs4Q5ByMA@mail.gmail.com>
 <20120417180129.GW6589@ZenIV.linux.org.uk>
 <20120417182825.GX6589@ZenIV.linux.org.uk>
 <20120417211419.GC27426@fieldses.org>
 <CA+55aFwdh_QWG-R2FQ71kDXiNYZ04qPANBsY_PssVUwEBH4uSw@mail.gmail.com>
 <20120417234423.GY6589@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120417234423.GY6589@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 18-04-12 00:44:24, Al Viro wrote:
> On Tue, Apr 17, 2012 at 03:08:26PM -0700, Linus Torvalds wrote:
> > > Or I could increment that counter for all the conflicting operations and
> > > rely on it instead of the i_mutex. ?I was trying to avoid adding
> > > something like that (an inc, a dec, another error path) to every
> > > operation. ?And hoping to avoid adding another field to struct inode.
> > > Oh well.
> > 
> > We could just say that we can do a double inode lock, but then
> > standardize on the order. And the only sane order is comparing inode
> > pointers, not inode numbers like ext4 apparently does.
> > 
> > With a standard order, I don't think it would be at all wrong to just
> > take the inode lock on rename.
> 
> In principle, yes, but have you tried to grep for i_mutex?  Note that
> we have *another* place where multiple ->i_mutex might be held on
> non-directories (and unless I'm missing something, ext4 move_extent.c
> stuff doesn't play well with it): quota writes.  Which can, AFAICS,
> happen while write(2) is holding ->i_mutex on a regular file.  So
> it's not _that_ easy - we want something like "and quota file is goes
> last", since there we don't get to change the locking order - the first
> ->i_mutex is taken too far outside.
  Hum, I think I could just do away with quota file i_mutex being special.
It's used for two purposes:
  1) When quota is being turned on/off, we want to set/clear inode immutable
flag, truncate page cache, etc. But we should be able push this locking
outside of quota locks.
  2) Inside filesystems when quota file is written to. Quota writes are
serialized by quota code anyway and noone else has any bussiness with quota
files (they are marked as immutable to avoid mistakes) so there i_mutex is
not really needed.

> I really don't like how messy i_mutex had become these days.  Right now
> I'm staring at 700-odd lines all over the place where it's taken/released
> and it's a wastebucket lock - used to protect random bits and scraps, with a
> lot of filesystems, etc. using it for purposes of their own ;-/

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

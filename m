Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788Ab2DYQr4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 12:47:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42663 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756715Ab2DYQry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 12:47:54 -0400
Subject: Re: [git pull] vfs and fs fixes
From: Steven Whitehouse <swhiteho@redhat.com>
To: Jan Kara <jack@suse.cz>
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20120425162640.GA27193@quack.suse.cz>
References: <CA+55aFw75=Mtq1njQ9vNmNsGuTPbpUhLHnb7YBLmCZs4Q5ByMA@mail.gmail.com>
	 <20120417180129.GW6589@ZenIV.linux.org.uk>
	 <20120417182825.GX6589@ZenIV.linux.org.uk>
	 <20120417211419.GC27426@fieldses.org>
	 <CA+55aFwdh_QWG-R2FQ71kDXiNYZ04qPANBsY_PssVUwEBH4uSw@mail.gmail.com>
	 <20120417234423.GY6589@ZenIV.linux.org.uk>
	 <20120420111517.GB8985@quack.suse.cz> <20120424195236.GA19095@fieldses.org>
	 <20120424222312.GA10665@quack.suse.cz>
	 <20120425112930.GA30477@fieldses.org>
	 <20120425162640.GA27193@quack.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Wed, 25 Apr 2012 17:47:03 +0100
Message-ID: <1335372423.2730.2.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 2012-04-25 at 18:26 +0200, Jan Kara wrote:
> On Wed 25-04-12 07:29:30, J. Bruce Fields wrote:
> > On Wed, Apr 25, 2012 at 12:23:12AM +0200, Jan Kara wrote:
> > > On Tue 24-04-12 15:52:36, J. Bruce Fields wrote:
> > > > On Fri, Apr 20, 2012 at 01:15:17PM +0200, Jan Kara wrote:
> > > > > On Wed 18-04-12 00:44:24, Al Viro wrote:
> > > > > > On Tue, Apr 17, 2012 at 03:08:26PM -0700, Linus Torvalds wrote:
> > > > > > > > Or I could increment that counter for all the conflicting operations and
> > > > > > > > rely on it instead of the i_mutex. ?I was trying to avoid adding
> > > > > > > > something like that (an inc, a dec, another error path) to every
> > > > > > > > operation. ?And hoping to avoid adding another field to struct inode.
> > > > > > > > Oh well.
> > > > > > > 
> > > > > > > We could just say that we can do a double inode lock, but then
> > > > > > > standardize on the order. And the only sane order is comparing inode
> > > > > > > pointers, not inode numbers like ext4 apparently does.
> > > > > > > 
> > > > > > > With a standard order, I don't think it would be at all wrong to just
> > > > > > > take the inode lock on rename.
> > > > > > 
> > > > > > In principle, yes, but have you tried to grep for i_mutex?  Note that
> > > > > > we have *another* place where multiple ->i_mutex might be held on
> > > > > > non-directories (and unless I'm missing something, ext4 move_extent.c
> > > > > > stuff doesn't play well with it): quota writes.  Which can, AFAICS,
> > > > > > happen while write(2) is holding ->i_mutex on a regular file.  So
> > > > > > it's not _that_ easy - we want something like "and quota file is goes
> > > > > > last", since there we don't get to change the locking order - the first
> > > > > > ->i_mutex is taken too far outside.
> > > > >   Hum, I think I could just do away with quota file i_mutex being special.
> > > > > It's used for two purposes:
> > > > >   1) When quota is being turned on/off, we want to set/clear inode immutable
> > > > > flag, truncate page cache, etc. But we should be able push this locking
> > > > > outside of quota locks.
> > > > >   2) Inside filesystems when quota file is written to. Quota writes are
> > > > > serialized by quota code anyway and noone else has any bussiness with quota
> > > > > files (they are marked as immutable to avoid mistakes) so there i_mutex is
> > > > > not really needed.
> > > > 
> > > > Grepping for I_MUTEX_QUOTA shows hits in ext4, reiserfs, and gfs2.  The
> > > > former two are in code called from the quota code (through the
> > > > ->quota_write method).  But the gfs2 code appears to be called directly
> > > > from gfs2's write code.
> > >   Ah, gfs2 doesn't use generic quota code so whatever it does is it's own
> > > invention. For ext4 and reiserfs I could get rid of I_MUTEX_QUOTA as I
> > > wrote.
> > 
> > So, just the appended?
>   Yup, that's the easier part. We also use the mutex in quota code itself
> (fs/quota/dquot.c). That's somewhat harder to solve but still relatively
> simple.
> 
> > But unfortunately as long as that's left in gfs2 we're still stuck
> > trying to order quota files after other files when we take two
> > non-directory i_mutexes elsewhere.
>   As far as GFS2 is concerned, I'm not sure what it uses i_mutex in quota
> code for.  In any case it should be possible to replace that usage by some
> GFS2 internal lock to get rid of the last usage of I_MUTEX_QUOTA... Stephen?
> 
> 								Honza
> 
I'll have a look and see what we can do. I'm not sure off the top of my
head how easy it will be to eliminate this lock,

Steve.



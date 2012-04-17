Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab2DQQWU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 12:22:20 -0400
Received: from fieldses.org ([174.143.236.118]:48975 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715Ab2DQQWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 12:22:19 -0400
Date: Tue, 17 Apr 2012 12:22:16 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] vfs and fs fixes
Message-ID: <20120417162216.GB27426@fieldses.org>
References: <20120417052511.GU6589@ZenIV.linux.org.uk>
 <CA+55aFw75=Mtq1njQ9vNmNsGuTPbpUhLHnb7YBLmCZs4Q5ByMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFw75=Mtq1njQ9vNmNsGuTPbpUhLHnb7YBLmCZs4Q5ByMA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 08:01:48AM -0700, Linus Torvalds wrote:
> On Mon, Apr 16, 2012 at 10:25 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >        A bunch of endianness fixes plus a patch from bfields untangling
> > dependencies between vfs and nfsd trees; in principle, we could keep it
> > in nfsd tree (along with a bunch of followups that definitely belong there),
> > but Miklos' stuff in fs/namei.c steps fairly close to it and overlayfs
> > and unionfs series - even closer, so that would create serious PITA for
> > both, whichever tree it would sit in.
> 
> Why is that double mutex taking in vfs_rename_other() safe from ABBA?
> 
> We aren't guaranteed to hold the s_vfs_rename_mutex, since the parent
> directories may be the same.
> 
> And yes, we hold the i_mutex on that shared parent, but the inodes may
> exist (hardlinked) in another directory, so another rename could be
> doing the i_mutex in the reverse order.
> 
> Maybe there is some reason why that double lock is safe, but I don't
> see it, and I want it clearly documented. So I'm not pulling this.

Ugh, no, I think you're right:

	rename A/a->A/b
	rename B/b->B/b

where A/a and B/a are the same file, and A/b and B/b are the same file,
can result in the first rename holding the lock on A and a and waiting
on b, and the second holding the lock on B and b and waiting on a.

--b.

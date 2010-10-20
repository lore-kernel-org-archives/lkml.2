Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270Ab0JTRiZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 13:38:25 -0400
Received: from fieldses.org ([174.143.236.118]:37391 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437Ab0JTRiX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 13:38:23 -0400
Date: Wed, 20 Oct 2010 13:38:08 -0400
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Matthew Wilcox <matthew@wil.cx>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org, zohar@us.ibm.com, warthog9@kernel.org,
        david@fromorbit.com, jmorris@namei.org, kyle@mcmartin.ca,
        hpa@zytor.com, akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: [PATCH 1/3] IMA: move read/write counters into struct inode
Message-ID: <20101020173808.GA15056@fieldses.org>
References: <20101019011650.25346.99614.stgit@paris.rdu.redhat.com>
 <AANLkTimGdjPyLXuknDNa7WNthDT9+2FdOuPdxwjRiMHD@mail.gmail.com>
 <1287506215.2530.187.camel@localhost.localdomain>
 <20101019165530.GT19804@ZenIV.linux.org.uk>
 <AANLkTimL=eChoCQHGoiouE5s6dGG=n9ZAQGhW-RW+gDj@mail.gmail.com>
 <20101019172805.GU19804@ZenIV.linux.org.uk>
 <20101019191133.GE2447@parisc-linux.org>
 <20101020031504.GA18581@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101020031504.GA18581@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 04:15:04AM +0100, Al Viro wrote:
> On Tue, Oct 19, 2010 at 01:11:33PM -0600, Matthew Wilcox wrote:
> > Hm.  Sounds like the same question that the file leases code needs
> > answered.  The important difference is that the leases code can just
> > refuse to set a lease on inodes with multiple dentries.
> > 
> > While my mind's on it ... Al, is this code even close to correct?
> > 
> >                 if ((arg == F_RDLCK) && (atomic_read(&inode->i_writecount) > 0))
> >                         goto out;
> >                 if ((arg == F_WRLCK)
> >                     && ((atomic_read(&dentry->d_count) > 1)
> >                         || (atomic_read(&inode->i_count) > 1)))
> >                         goto out;
> 
> No.  This is complete junk; note that e.g. ls -lR will disrupt it, since
> lstat(2) will bump dentry refcount.  The first part is more or less OK;
> the second makes no sense.

It may be nobody cares about false positives--if leases are something
provided as a caching optimization, then it's OK to deny them more often
than strictly necessary.

(In fact, if you're using the write lease to allow somebody else to
cache writes, then you want the stat to break the lease so it can get
can trigger a cache flush and get an updated mtime.)

Not that I'll claim those checks are correct.

> What is it trying to do?  Note that the first part also doesn't make a lot
> of sense, since you could be acquiring a write reference *right* *now*,
> just as that check passes.  And you could finish getting it before you get
> to do anything else in generic_setlease().

Yeah, that's a race.

The lease code is broken.  On my list of problems:
    
        - Leases are broken only by conflicting opens; but both nfsv4
          delegations and (I'm told) Windows op locks actually require
          that read leases be broken on any operation that changes file
          metadata--including unlink, link, rename, chmod, and chown.
    
	- The internal kernel api used for lease-breaking is inherently
	  racy as long as it consists of a single break_lease() call.
	  (We probably need deny_leases() and undeny_leases(), or
	  something.)

I'd be happy just to have read leases that worked correctly; write
leases (which, at least for the NFSv4 server's purposes, also need to be
broken on *access* to metadata) are worse.

I have patches that attempted to replace the current mechanism for
F_RDLCK leases with an i_leasecount modeled on i_writecount.  (So
positive counts the number of leases held, negative counts operations
temporarily disabling leases.)  They were never completely correct.

I also wasn't sure what sort of requirements I should meet to avoid
noticeable scalability problems (how much additional space in the inode
could I get away with?  What about additional locks, or just writes to
inode fields, on read opens?).

--b.

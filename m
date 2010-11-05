Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891Ab0KEU6Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 16:58:16 -0400
Received: from fieldses.org ([174.143.236.118]:54775 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752454Ab0KEU6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 16:58:13 -0400
Date: Fri, 5 Nov 2010 16:58:07 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, hch@infradead.org, warthog9@kernel.org,
        david@fromorbit.com, jmorris@namei.org, kyle@mcmartin.ca,
        hpa@zytor.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, mingo@elte.hu, eparis@redhat.com,
        viro@zeniv.linux.org.uk, Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 0/4] IMA: making i_readcount a first class inode citizen
Message-ID: <20101105205807.GA10217@fieldses.org>
References: <1288303325-9628-1-git-send-email-zohar@linux.vnet.ibm.com>
 <20101105011227.GB4320@fieldses.org>
 <1288955286.3135.9.camel@localhost.localdomain>
 <20101105162811.GA3270@fieldses.org>
 <1288978685.3135.135.camel@localhost.localdomain>
 <20101105190827.GC6492@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101105190827.GC6492@fieldses.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 05, 2010 at 03:08:27PM -0400, J. Bruce Fields wrote:
> On Fri, Nov 05, 2010 at 01:38:05PM -0400, Mimi Zohar wrote:
> > On Fri, 2010-11-05 at 12:28 -0400, J. Bruce Fields wrote: 
> > > On Fri, Nov 05, 2010 at 07:08:06AM -0400, Mimi Zohar wrote:
> > 
> > > > Right, like the ima_file_check(), which is after the __dentry_open().
> > > > Al, is it possible to move the break_lease() in may_open() to later?
> > > 
> > > That would still leave a race like:
> > > 
> > > 			check count
> > > 	bump count
> > > 	break lease
> > > 			set lease
> > > 
> > > But we could extend the i_lock to prevent the lease being bumped between
> > > the two steps on the right-hand side.
> > 
> > The latest i_readcount patchset, i_readcount is atomic and doesn't
> > require i_lock, at least for IMA.  Have to think about this more ....
> > 
> > > At that point I think we'd be done?  We're assured the count is still
> > > zero while the lease is added to the inode, so anyone in the process of
> > > doing an open has yet to reach the break_lease, which will see the newly
> > > added lease.
> > > 
> > > That leaves the problem that leases really should be broken on anything
> > > that changes the attributes or the dentries pointing to the inode:
> > > setattr, link, unlink, rename, at least.
> > 
> > For this reason, IMA is now taking i_mutex, preventing file metadata
> > from changing.

Apologies, by the way, if I'm hijacking the thread, but:

> 
> Lease code could do that as well.  (Probably just with a trylock,
> failing the setlease if we can't get the lock.)
> 
> That misses rename, though, which doesn't take the i_mutex on the
> renamed file.  Which makes sense.
> 
> But a lease is used to give file server clients the right to do an open
> locally, and we want them to be able to guarantee to applications that
> the path (well, the last component, at least) still refers to the same
> file at open time.

We could *also* do trylock on the parent directory that the open used
(yipes), but even that's not quite enough; rfc 5661:

	"If the object being renamed has file delegations held by
	clients other than the one doing the RENAME, the delegations
	MUST be recalled, and the operation cannot proceed until each
	such delegation is returned or revoked.  Note that in the case
	of multiply linked files, the delegation recall requirement
	applies even if the delegation was obtained through a different
	name than the one being renamed."

That means if a client gets a delegation on file "foo", then discovers
that "bar" is the same file, it can assume it is safe to do a local open
as "bar"; so we're stuck breaking leases on a rename of "bar" to
"baz".

For correct leases from NFS's point of view--Samba's requirements are
probably similar--

	- a lease has an owner, and no operations by the owner conflict
	  with the lease.  For operations by non-owners:

	- read leases must conflict with write opens, and with anything
	  that would modify data, metadata, or the set of hard links
	  naming the file (so setattr, link, unlink, rename).

	- write leases must conflict with everything read leases do,
	  plus *reads* of data or metadata.  (If a "make" stats a source
	  file with a write lease, it has to wait for the lease to
	  broken, or else it may miss the fact that a client has updated
	  the file in its local cache).

Non-requirements:

	- Leases are an optimization, and it's OK to turn them down even
	  when we don't strictly have to.  (Though if we fail to grant
	  them in common cases then it's a performance problem.)

	- Leases are only useful in situations where conflicts are rare,
	  and they can be held for a long time.  It's OK if lease
	  acquisition is somewhat expensive.

I'd be happy just to have correct read leases....

--b.

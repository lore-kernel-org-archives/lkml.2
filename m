Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269Ab0KEQ2X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 12:28:23 -0400
Received: from fieldses.org ([174.143.236.118]:50286 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752667Ab0KEQ2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 12:28:19 -0400
Date: Fri, 5 Nov 2010 12:28:11 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, hch@infradead.org, warthog9@kernel.org,
        david@fromorbit.com, jmorris@namei.org, kyle@mcmartin.ca,
        hpa@zytor.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, mingo@elte.hu, eparis@redhat.com,
        viro@zeniv.linux.org.uk, Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 0/4] IMA: making i_readcount a first class inode citizen
Message-ID: <20101105162811.GA3270@fieldses.org>
References: <1288303325-9628-1-git-send-email-zohar@linux.vnet.ibm.com>
 <20101105011227.GB4320@fieldses.org>
 <1288955286.3135.9.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288955286.3135.9.camel@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 05, 2010 at 07:08:06AM -0400, Mimi Zohar wrote:
> On Thu, 2010-11-04 at 21:12 -0400, J. Bruce Fields wrote:
> > On Thu, Oct 28, 2010 at 06:02:01PM -0400, Mimi Zohar wrote:
> > > On Mon, 2010-10-25 at 14:41 -0400, Eric Paris wrote:
> > > 
> > > <snip>
> > > 
> > > > I believe that IBM is going to look into making i_readcount a first
> > > > class citizen which can be used by both IMA and generic_setlease().
> > > > Then people could say IMA had 0 per inode overhead   :)
> > > 
> > > This patchset separates the incrementing/decrementing of the i_readcount,
> > > in the VFS layer, from other IMA functionality, by replacing the current
> > > ima_counts_get() call with iget_readcount(). Its unclear whether this
> > > call to increment i_readcount should be made earlier. 
> > > 
> > > The patch ordering is a bit redundant in order to leave removing the ifdef
> > > around i_readcount until the last patch. The first three patches: defines 
> > > iget/iput_readcount(), moves the IMA functionality in ima_counts_get() to
> > > ima_file_check(), and removes the IMA imbalance code, simplifying IMA. The
> > > last patch moves iget/iput_readcount() to the fs directory and removes the
> > > ifdef around i_readcount, making i_readcount into a "first class inode citizen".
> > > 
> > > The generic_setlease code could then take advantage of i_readcount, assuming
> > > it can take the spin_lock, by doing something like:
> > > 
> > > -		if ((arg == F_RDLCK) && (atomic_read(&inode->i_writecount) > 0))
> > > +
> > > +		spin_lock(&inode->i_lock);
> > > +		if ((arg == F_RDLCK) && (atomic_read(&inode->i_writecount) > 0)){
> > > +			spin_unlock(&inode->i_lock);
> > >  			goto out;
> > > -		if ((arg == F_WRLCK)
> > > -		    && ((atomic_read(&dentry->d_count) > 1)
> > > -			|| (atomic_read(&inode->i_count) > 1)))
> > > +		}
> > > +		if ((arg == F_WRLCK) && (inode->i_readcount > 1)) {
> > > +			spin_unlock(&inode->i_lock);
> > >  			goto out;
> > > +		}
> > > +		spin_unlock(&inode->i_lock);
> > >  	}
> > 
> > Seems like an improvement.
> > 
> > It still leaves the race:
> > 
> > 	may_open calls lease_break, finds no lease
> > 
> > 			setlease checks read/writecount, finds 0,
> > 			creates lease
> > 
> > 	__dentry_open bumps read/writecount
> > 
> > (Is there any reason we couldn't move the break_lease to after bumping
> > read or write count?)
> > 
> > --b.
> 
> Right, like the ima_file_check(), which is after the __dentry_open().
> Al, is it possible to move the break_lease() in may_open() to later?

That would still leave a race like:

			check count
	bump count
	break lease
			set lease

But we could extend the i_lock to prevent the lease being bumped between
the two steps on the right-hand side.

At that point I think we'd be done?  We're assured the count is still
zero while the lease is added to the inode, so anyone in the process of
doing an open has yet to reach the break_lease, which will see the newly
added lease.

That leaves the problem that leases really should be broken on anything
that changes the attributes or the dentries pointing to the inode:
setattr, link, unlink, rename, at least.

One approach: add another counter to the inode named disable_leases, and
have any of those operations do something like:

	disable_lease++
	break_lease
	... do operation ...
	disable_lease--

?

--b.

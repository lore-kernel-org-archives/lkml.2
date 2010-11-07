Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab0KGADr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 20:03:47 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:56223 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753855Ab0KGADp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 20:03:45 -0400
Subject: Re: [PATCH 0/4] IMA: making i_readcount a first class inode citizen
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, hch@infradead.org, warthog9@kernel.org,
        david@fromorbit.com, jmorris@namei.org, kyle@mcmartin.ca,
        hpa@zytor.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, mingo@elte.hu, eparis@redhat.com,
        viro@zeniv.linux.org.uk, Matthew Wilcox <matthew@wil.cx>
In-Reply-To: <20101105190827.GC6492@fieldses.org>
References: <1288303325-9628-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <20101105011227.GB4320@fieldses.org>
	 <1288955286.3135.9.camel@localhost.localdomain>
	 <20101105162811.GA3270@fieldses.org>
	 <1288978685.3135.135.camel@localhost.localdomain>
	 <20101105190827.GC6492@fieldses.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 06 Nov 2010 20:03:39 -0400
Message-ID: <1289088219.3268.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-05 at 15:08 -0400, J. Bruce Fields wrote:
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
> 
> Lease code could do that as well.  (Probably just with a trylock,
> failing the setlease if we can't get the lock.)
> 
> That misses rename, though, which doesn't take the i_mutex on the
> renamed file.  Which makes sense.

fs/namei.c: vfs_rename_other() seems to be taking the i_mutex.  Am I
looking in the wrong place?

> But a lease is used to give file server clients the right to do an open
> locally, and we want them to be able to guarantee to applications that
> the path (well, the last component, at least) still refers to the same
> file at open time.

Mimi


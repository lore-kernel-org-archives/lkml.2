Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab0IOUnT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 16:43:19 -0400
Received: from fieldses.org ([174.143.236.118]:36817 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754498Ab0IOUnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 16:43:18 -0400
Date: Wed, 15 Sep 2010 16:42:03 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Matthew Wilcox <willy@linux.intel.com>, Christoph Hellwig <hch@lst.de>,
        Miklos Szeredi <mszeredi@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, John Kacur <jkacur@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Remove BKL from fs/locks.c
Message-ID: <20100915204203.GA27837@fieldses.org>
References: <201009142206.54130.arnd@arndb.de>
 <201009142239.02904.arnd@arndb.de>
 <AANLkTimK5kesHJV3mspRch-YVe8uRT=ypqNMHr2L9wHC@mail.gmail.com>
 <201009142324.16074.arnd@arndb.de>
 <1284501356.10782.139.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284501356.10782.139.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 14, 2010 at 05:55:56PM -0400, Trond Myklebust wrote:
> On Tue, 2010-09-14 at 23:24 +0200, Arnd Bergmann wrote:
> > On Tuesday 14 September 2010 22:53:31 Linus Torvalds wrote:
> > > Oh well. I guess there's no incremental way to do things sanely. And
> > > nobody has patches to fix those users, I guess.
> > 
> > The only critical user is fs/lockd, I can easily handle the rest.
> > When I talked to Bruce and Trond during LinuxCon, they told me that
> > it should be possible to separate the bits of fs/lockd that lock
> > against fs/locks.c and convert the former to use lock_flocks().
> 
> 
> The NFSv4 client is quite ready to just switch to using lock_flocks()
> now. There is nothing that depends on the magical properties of the BKL.
> I do also have someone working on BKL removal for the NLM/lockd client
> and am hoping that should be ready in a couple of weeks time.
> 
> The timeline for the server is up to Bruce, however.

Looking over the server code....  The only code I see under the BKL is:

	- a few lease callbacks in fs/nfsd/nfs4state.c, none of which
	  sleep at this point, so all should be fine under a spinlock or
	  whatever we want.
	- fs/nfsd/nfs4state.c:check_for_locks(), which explicitly takes
	  the BKL itself.  All it does, though, is walk the lock list
	  for a given file and check whether any of them have a given
	  owner.  It would be trivial to put it under some other lock
	  and/or move it to locks.c.

--b.

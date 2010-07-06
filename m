Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213Ab0GFNEq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 09:04:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55287 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755762Ab0GFNEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 09:04:45 -0400
Date: Tue, 6 Jul 2010 23:04:37 +1000
From: Nick Piggin <npiggin@suse.de>
To: Theodore Tso <tytso@MIT.EDU>
Cc: Dave Chinner <david@fromorbit.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: Re: [patch 29/52] fs: icache lock i_count
Message-ID: <20100706130437.GJ11732@laptop>
References: <20100624030730.245992858@suse.de>
 <20100630072702.GF24712@dastard>
 <20100630120502.GB21358@laptop>
 <20100702190355.2b3fe6d2.akpm@linux-foundation.org>
 <20100703034123.GE11732@laptop>
 <20100702213149.f0ca2f72.akpm@linux-foundation.org>
 <20100703050652.GF11732@laptop>
 <20100705224106.GZ24712@dastard>
 <20100706043439.GH11732@laptop>
 <48F48148-9909-47D0-A850-04B22403C006@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F48148-9909-47D0-A850-04B22403C006@mit.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 06, 2010 at 06:38:28AM -0400, Theodore Tso wrote:
> 
> On Jul 6, 2010, at 12:34 AM, Nick Piggin wrote:
> > On Tue, Jul 06, 2010 at 08:41:06AM +1000, Dave Chinner wrote:
> >> 
> >> 
> >> I don't disagree with this approach - I object to the fact that you
> >> repurpose an existing lock and change it's locking rules to "rule
> >> the inode". We don't have any one lock that "rules the inode",
> >> anyway, so adding a new "i_list_lock" for the new VFS level locking
> >> strategies makes it a lot more self-contained. Fundamentally I'm
> >> less concerned about the additional memory usage than I am about
> >> having landmines planted around i_lock...
> > 
> > If some filesystem introduces a lock ordering problem from not
> > reading the newly added documentation, lockdep should catch it pretty
> > quick.
> 
> I assume you mean inline documentation in the source, because I
> quickly scanned the source and couldn't find any significant changes
> to any files in Documentation.
> 
> It would be nice if the new state of affairs is documented in a single file,
> so that people who want to understand this new locking system don't
> have to go crawling through the code, or searching mailing list archives
> to figure out what's going on.

These type of internal details of lock ordering I think work best in
source files (see rmap.c and filemap.c) so it's a little closer to the
source code. That's in inode.c and dcache.c.

Locking for filesystem callback APIs I agree is just as good to be in
Documentation/filesystems/Locking (which I need to update a bit), but
it's never been used for this stuff before. I'm always open to
suggestions of how to document it better though.


> A lot of the text in this mail thread, including your discussion of the new
> locking hierarchy, and why things are the way they are, would be good
> fodder for a new documentation file.   And if you don't want to rename
> i_lock, because no better name can be found, we should at least
> document that starting as of 2.6.35/36 the meaning of i_lock changed.

Well there is not much definition of what i_lock is. It is really not
an "innermost" lock anyway (whatever that exactly means). CEPH even
takes dcache_lock inside i_lock. NFS uses it pretty extensively too.

So it really is *the* non sleeping lock to protect inode fields that
I can see.

As far as filesystems go, inode changes matter very little really,
but the best I can do is just to comment and document the locking
and try to audit each filesystem.


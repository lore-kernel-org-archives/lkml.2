Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818Ab2DCFpz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 01:45:55 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49176 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab2DCFpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 01:45:53 -0400
Date: Mon, 2 Apr 2012 22:45:29 -0700
From: Joel Becker <jlbec@evilplan.org>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Al Viro <viro@zeniv.linux.org.uk>, Alex Elder <elder@kernel.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>, Ben Myers <bpm@sgi.com>,
        Dave Chinner <david@fromorbit.com>, Mark Fasheh <mfasheh@suse.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm for fs: add truncate_pagecache_range
Message-ID: <20120403054528.GD15739@dhcp-172-17-9-228.mtv.corp.google.com>
Mail-Followup-To: Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>,
	Alex Elder <elder@kernel.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>, Ben Myers <bpm@sgi.com>,
	Dave Chinner <david@fromorbit.com>, Mark Fasheh <mfasheh@suse.com>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
References: <alpine.LSU.2.00.1203231343380.1940@eggly.anvils>
 <20120323140120.11f95cd5.akpm@linux-foundation.org>
 <alpine.LSU.2.00.1203231406090.2207@eggly.anvils>
 <20120323155950.f9bfb097.akpm@linux-foundation.org>
 <alpine.LSU.2.00.1203251254570.1505@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1203251254570.1505@eggly.anvils>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 25, 2012 at 01:26:10PM -0700, Hugh Dickins wrote:
> On Fri, 23 Mar 2012, Andrew Morton wrote:
> > On Fri, 23 Mar 2012 14:14:54 -0700 (PDT)
> > Hugh Dickins <hughd@google.com> wrote:
> > > On Fri, 23 Mar 2012, Andrew Morton wrote:
> > > > 
> > > > --- a/mm/truncate.c~mm-for-fs-add-truncate_pagecache_range-fix
> > > > +++ a/mm/truncate.c
> > > > @@ -639,6 +639,9 @@ int vmtruncate_range(struct inode *inode
> > > >   * with on-disk format, and the filesystem would not have to deal with
> > > >   * situations such as writepage being called for a page that has already
> > > >   * had its underlying blocks deallocated.
> > > > + *
> > > > + * Must be called with inode->i_mapping->i_mutex held.
> > > 
> > > You catch me offguard: I forget whether that's an absolute requirement or
> > > just commonly the case.  What do the other interfaces in truncate.c say ?-)
> > 
> > i_mutex is generally required, to stabilise i_size.
> 
> Sorry for being quarrelsome, but I do want to Nak your followup "fix".
> 
> Building a test kernel quickly told me that inode->i_mapping->i_mutex
> doesn't exist, of course it's inode->i_mutex.
> 
> Then running the test kernel quickly told me that neither ext4 nor xfs
> (I didn't try ocfs2) holds inode->i_mutex where holepunching calls
> truncate_inode_pages_range().

Just for completeness:

ocfs2 holds i_mutex around the entire ocfs2_change_file_space() call,
which can do hole punching and unwritten extent allocation (it is a
clone of xfs_change_file_space()).  xfs itself seems hold its own idea
of a shared lock while doing the work and an exclusive lock around the
transaction join.  I'm not clear enough about xfs to say how this
compares or even if I read it right.

But ocfs2 uses an allocation sem to protect allocation changes,
including i_size, so perhaps i_mutex isn't strictly necessary.  I don't
think we contend enough here to try hard to remove it :-)

Joel

-- 

"The question of whether computers can think is just like the question
 of whether submarines can swim."
	- Edsger W. Dijkstra

			http://www.jlbec.org/
			jlbec@evilplan.org

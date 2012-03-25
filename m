Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224Ab2CYV4I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 17:56:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65295 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932199Ab2CYV4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 17:56:06 -0400
Date: Sun, 25 Mar 2012 14:55:36 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@infradead.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>,
        Alex Elder <elder@kernel.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>, Ben Myers <bpm@sgi.com>,
        Dave Chinner <david@fromorbit.com>, Joel Becker <jlbec@evilplan.org>,
        Mark Fasheh <mfasheh@suse.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm for fs: add truncate_pagecache_range
In-Reply-To: <20120325135002.185b4caf.akpm@linux-foundation.org>
Message-ID: <alpine.LSU.2.00.1203251426540.1609@eggly.anvils>
References: <alpine.LSU.2.00.1203231343380.1940@eggly.anvils> <20120323140120.11f95cd5.akpm@linux-foundation.org> <alpine.LSU.2.00.1203231406090.2207@eggly.anvils> <20120323155950.f9bfb097.akpm@linux-foundation.org> <alpine.LSU.2.00.1203251254570.1505@eggly.anvils>
 <20120325135002.185b4caf.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Mar 2012, Andrew Morton wrote:
> On Sun, 25 Mar 2012 13:26:10 -0700 (PDT) Hugh Dickins <hughd@google.com> wrote:
> > truncate_pagecache_range() is just a drop-in replacement for
> > truncate_inode_pages_range(), and has no different locking needs.
> 
> Does anything prevent new pages from getting added to pagecache and
> perhaps faulted into VMAs after or during the execution of these
> functions?

If a page is faulted into a vma after the unmap_mapping_range() but
before truncate_inode_pages_range() reaches it, then it gets unmapped
by the fallback unmap_mapping_range(), called from truncate_inode_page()
while holding page lock.

A new page could be faulted in a moment after; but last year I did
change truncate_inode_pages_range() slightly, pinching down on the range
instead of just the ascending linear scan, so it doesn't return until
the range is empty of pages (excepting rcu races, which I think mean
there's no exact instant of return which all cpus would agree upon).

A new page could be faulted in a moment after that, and then it survives:
unlike in the truncation case, there's no equivalent of i_size to
determine whether to SIGBUS.  (But even in the truncation case, a
truncate or write to increase i_size may follow an instant later.)

Individual filesystems may impose additional constraints to guarantee
their own internal consistency; and tmpfs certainly finds inode->i_mutex
useful for that, to serialize between holepunch and truncate and write.
I wouldn't be surprised if other filesystems found it useful too,
but that's up to them - truncate_pagecache_range() doesn't need it.

> 
> Also, I wonder what prevents pages in the range from being dirtied
> between ext4_ext_punch_hole()'s filemap_write_and_wait_range() and
> truncate_inode_pages_range().

I'm not going to guess on that, or whether it matters: Ted?

Hugh

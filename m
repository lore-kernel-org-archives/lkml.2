Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757076Ab2CYUqf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 16:46:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52694 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757021Ab2CYUqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 16:46:34 -0400
Date: Sun, 25 Mar 2012 13:50:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hughd@google.com>
Cc: Christoph Hellwig <hch@infradead.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Al Viro <viro@zeniv.linux.org.uk>, Alex Elder <elder@kernel.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>, Ben Myers <bpm@sgi.com>,
        Dave Chinner <david@fromorbit.com>, Joel Becker <jlbec@evilplan.org>,
        Mark Fasheh <mfasheh@suse.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm for fs: add truncate_pagecache_range
Message-Id: <20120325135002.185b4caf.akpm@linux-foundation.org>
In-Reply-To: <alpine.LSU.2.00.1203251254570.1505@eggly.anvils>
References: <alpine.LSU.2.00.1203231343380.1940@eggly.anvils>
	<20120323140120.11f95cd5.akpm@linux-foundation.org>
	<alpine.LSU.2.00.1203231406090.2207@eggly.anvils>
	<20120323155950.f9bfb097.akpm@linux-foundation.org>
	<alpine.LSU.2.00.1203251254570.1505@eggly.anvils>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Mar 2012 13:26:10 -0700 (PDT) Hugh Dickins <hughd@google.com> wrote:

> Building a test kernel quickly told me that inode->i_mapping->i_mutex
> doesn't exist, of course it's inode->i_mutex.
> 
> Then running the test kernel quickly told me that neither ext4 nor xfs
> (I didn't try ocfs2) holds inode->i_mutex where holepunching calls
> truncate_inode_pages_range().
> 
> Now, there might or might not be reasons why ext4 or xfs ought to hold
> i_mutex there for its own consistency, but it's beyond me to determine
> that: let's assume they're correct without evidence to the contrary.
> 
> Stabilizing i_size is not a reason: holepunching does not affect i_size
> and is not affected by i_size (okay, ext4 still has the bug I reported
> a couple of months ago, whereby its holepunching stops at i_size,
> forgetting blocks fallocated beyond; but no doubt that will get fixed).
> 
> And nothing that truncate_pagecache_range() does needs i_mutex:
> neither the unmap_mapping_range() nor the truncate_inode_pages_range()
> needs i_mutex.  A year ago, yes, Miklos showed how unmap_mapping_range()
> was relying on mutex serialization, and added an additional mutex for
> that, which Peter was able to remove once he mutified i_mmap_lock.
> 
> truncate_pagecache_range() is just a drop-in replacement for
> truncate_inode_pages_range(), and has no different locking needs.

Does anything prevent new pages from getting added to pagecache and
perhaps faulted into VMAs after or during the execution of these
functions?

Also, I wonder what prevents pages in the range from being dirtied
between ext4_ext_punch_hole()'s filemap_write_and_wait_range() and
truncate_inode_pages_range().

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908Ab0GCJYt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 05:24:49 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55862 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775Ab0GCJYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 05:24:47 -0400
Date: Sat, 3 Jul 2010 10:24:42 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Jan Kara <jack@suse.cz>,
       Christoph Hellwig <hch@lst.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Chris Mason <chris.mason@oracle.com>,
       Jeff Mahoney <jeffm@jeffreymahoney.com>
Subject: Re: reiserfs locking (v2)
Message-ID: <20100703092441.GM31073@ZenIV.linux.org.uk>
References: <20100702093451.GA3973@swordfish.minsk.epam.com>
 <20100702131248.GA5324@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100702131248.GA5324@nowhere>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 02, 2010 at 03:12:52PM +0200, Frederic Weisbecker wrote:
> Right.
> 
> 
> The problem is:
> 
> vfs_readdir() {						do_munmap() {
> 	mutex_lock(inode);					read or write(don't know)_lock(mm->mmap_sem)
> 	reiserfs_readdir() {					reiserfs_file_release() {
> 		read_lock(mm->mmap_sem)					mutex_lock(inode);
> 	}							}
> }							}
> 
> 
> 
> I don't think the deadlock can really happen, as we can't release the directory while
> we are reading it. Plus I guess we can't mmap a directory (someone correct me if
> I'm wrong).

Gyah...  For the 1001st time: readdir() is far from being the only thing that
nests mmap_sem inside i_mutex.  In particular, write() does the same thing.

So yes, it *is* a real deadlock, TYVM, with no directories involved.  Open the
same file twice, mmap one fd, close it, then have munmap() hitting i_mutex
in reiserfs_file_release() race with write() through another fd.

Incidentally, reiserfs_file_release() checks in the fastpath look completely
bogus.  Checking i_count?  What the hell is that one about?  And no, these
checks won't stop open() coming between them and grabbing i_mutex, so they
couldn't prevent the deadlock in question anyway.

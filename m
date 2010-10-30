Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850Ab0J3NPj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 09:15:39 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38346 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab0J3NPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 09:15:37 -0400
Date: Sat, 30 Oct 2010 09:15:19 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jan Engelhardt <jengelh@medozas.de>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, stable@kernel.org,
        Greg KH <gregkh@suse.de>, Jens Axboe <jaxboe@fusionio.com>
Subject: Re: Sync writeback still broken
Message-ID: <20101030131518.GA8234@infradead.org>
References: <20100212091609.GB1025@kernel.dk>
 <alpine.LFD.2.00.1002120722270.7792@localhost.localdomain>
 <alpine.LSU.2.01.1002131356250.20838@obet.zrqbmnf.qr>
 <20100215144938.GD3434@quack.suse.cz>
 <alpine.LSU.2.01.1002151629380.27775@obet.zrqbmnf.qr>
 <alpine.LSU.2.01.1006271842220.1495@obet.zrqbmnf.qr>
 <alpine.LNX.2.01.1010250115360.16022@obet.zrqbmnf.qr>
 <AANLkTikBmewDmBJWHzdTerJE2W4GqRYMxLCdAJyz5JDB@mail.gmail.com>
 <AANLkTikEpV7GWG9fd3=zfrhOZtbPvxJWfXAO30iN8aae@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikEpV7GWG9fd3=zfrhOZtbPvxJWfXAO30iN8aae@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 29, 2010 at 06:16:48PM -0700, Linus Torvalds wrote:
> Btw, is the problem just that insane WB_SYNC_ALL thing?
> 
> The problem with WB_SYNC_ALL seems to be that it synchrnously writes
> out one inode at a time. And it's not just the data, it's the inode
> itself.
> 
> So rather than write out all pages for _all_ inodes, and then wait for
> them, and write out _all_ metadata, and then wait for that, it seems
> like the WB_SYNC_ALL code does the truly stupid thing, which is to
> "write out some data for one inode, then _synchronously_ wait for
> that, then write out the metadata for that single inode, then
> _synchronously_ wait for THAT" and then rinse and repeat for each
> inode.
> 
> The sane thing for "WB_SYNC_ALL" would be to:
>  - for_each_inode: write out all data (no waiting)
>  - for_each_inode: wait for the data for that inode, write out the inode
>  - for_each_inode: wait for the inode

What we do currently at a high level is:

	for_each_inode: write data (no waiting)
	for_each_inode: write metadata (no waiting)
	for_each_inode: write and wait on data
	for_each_inode: write and wait on metadata

except that as pointed out in the earlier thread we switch around inodes
in a really dumb way.  It's still not quite as efficient as your version
above.  I'd like to get to something similar to your by splitting the
data and metadata list, but for now we have a fairly nice workaround in
XFS for the inefficient metadata writes.

We basically do not start any real I/O at all in ->write_inode but only
put the inode changes in the log, and do we single force of the log
contents at the end of the sync process.  Dimitri has implemented
something very similar for ext4 as well recently.  Together with fixing
the behaviour of randomly switching between the inodes that should get
us to a point where we are doing pretty well.

I'd still like to see the split data/metadata dirty tracking and
writeout in common code eventually.

> 
> so that you avoid the whole synchronous wait thing, and can do all
> inodes in one go.
> 
> I dunno. Who even uses WB_SYNC_ALL? It's just "sync()" itself, isn't
> it? And "umount()", I guess. I didn't actually look at the code.

It's sync/umount as for the writeback threads are concerned, we of
course use the flag for synchronous writeout of single inodes, but the
issue does not apply there.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206Ab0DUSvc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 14:51:32 -0400
Received: from mail2.shareable.org ([80.68.89.115]:38962 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754572Ab0DUSva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 14:51:30 -0400
Date: Wed, 21 Apr 2010 19:51:24 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Phillip Susi <psusi@cfl.rr.com>, linux-fsdevel@vger.kernel.org,
       Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: readahead on directories
Message-ID: <20100421185124.GM27575@shareable.org>
References: <4BCC7C05.8000803@cfl.rr.com> <20100421004434.GA27420@shareable.org> <4BCF123C.6010400@cfl.rr.com> <20100421161211.GC27575@shareable.org> <20100421183853.GA14897@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100421183853.GA14897@ioremap.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Evgeniy Polyakov wrote:
> On Wed, Apr 21, 2010 at 05:12:11PM +0100, Jamie Lokier (jamie@shareable.org) wrote:
> > A quick skim of fs/{ext3,ext4}/dir.c finds a call to
> > page_cache_sync_readahead.  Doesn't that do any reading ahead? :-)
> 
> It goes down to fs callbacks of data reading, which is not appliable to
> directories.
> 
> To implement directory 'readahead' we use separated thread to call
> readdir(). It is damn slow indeed, but it can populate cache in advance
> of actual data reading. As a higher level crunch there is a 'find'
> running in background.

Fwiw, I found sorting directories by inode and reading them in that
order help to reduce seeks, some 10 years ago.  I implemented
something like 'find' which works like that, keeping a queue of
directories to read and things to open/stat, ordered by inode number
seen in d_ino before open/stat and st_ino after.  However it did not
try to readahead the blocks inside a directory, or sort operations by
block number.  It reduced some 'find'-like operations to about a
quarter of the time on cold cache.  I still use that program sometimes
before "git status" ;-)  Google "treescan" and "lokier" if you're
interested in trying it (though I use 0.7 which isn't published).

> > > I don't actually care to have the content	s of the
> > > directories returned, so readdir() does more than I need in that
> > > respect, and also it performs a blocking read of one disk block at a
> > > time, which is horribly slow with a cold cache.
> > 
> > I/O is the probably the biggest cost, so it's more important to get
> > the I/O pattern you want than worrying about return values you'll discard.
> > 
> > If readdir() calls are slowed by lots of calls and libc, consider
> > using the getdirentries system call directly.
> 
> it is not about readdir(). Plain read() is synchronous too. But
> filesystem can respond to readahead calls and read next block to current
> one, while it won't do this for next direntry.

I'm surprised it makes much difference, as directories are usually not
very large anyway.

But if it does, go on, try FIEMAP and blockdev reading, you know you
want to :-)

-- Jamie

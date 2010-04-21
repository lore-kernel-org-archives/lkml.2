Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700Ab0DUUBJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 16:01:09 -0400
Received: from mail2.shareable.org ([80.68.89.115]:45883 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab0DUUBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 16:01:08 -0400
Date: Wed, 21 Apr 2010 21:01:04 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Phillip Susi <psusi@cfl.rr.com>
Cc: Evgeniy Polyakov <zbr@ioremap.net>, linux-fsdevel@vger.kernel.org,
       Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: readahead on directories
Message-ID: <20100421200104.GT27575@shareable.org>
References: <4BCC7C05.8000803@cfl.rr.com> <20100421004434.GA27420@shareable.org> <4BCF123C.6010400@cfl.rr.com> <20100421161211.GC27575@shareable.org> <20100421183853.GA14897@ioremap.net> <20100421185124.GM27575@shareable.org> <4BCF509E.2040903@cfl.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BCF509E.2040903@cfl.rr.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Phillip Susi wrote:
> On 4/21/2010 2:51 PM, Jamie Lokier wrote:
> > Fwiw, I found sorting directories by inode and reading them in that
> > order help to reduce seeks, some 10 years ago.  I implemented
> > something like 'find' which works like that, keeping a queue of
> > directories to read and things to open/stat, ordered by inode number
> > seen in d_ino before open/stat and st_ino after.  However it did not
> > try to readahead the blocks inside a directory, or sort operations by
> > block number.  It reduced some 'find'-like operations to about a
> > quarter of the time on cold cache.  I still use that program sometimes
> > before "git status" ;-)  Google "treescan" and "lokier" if you're
> > interested in trying it (though I use 0.7 which isn't published).
> 
> That helps with open()ing or stat()ing the files since you access the
> inodes in order, but ureadahead already preloads all of the inode tables
> so this won't help.

It helps a little with data access too, because of block group
locality tending to follow inode numbers.  Don't read inodes and data
in the same batch though.

> >> it is not about readdir(). Plain read() is synchronous too. But
> >> filesystem can respond to readahead calls and read next block to current
> >> one, while it won't do this for next direntry.
> > 
> > I'm surprised it makes much difference, as directories are usually not
> > very large anyway.
> 
> That's just it; it doesn't help.  That's why I want to readahead() all
> of the directories at once instead of reading them one block at a time.

Ok, this discussion has got a bit confused.  Text above refers to
needing to asynchronously read next block in a directory, but if they
are small then that's not important.

> > But if it does, go on, try FIEMAP and blockdev reading, you know you
> > want to :-)
> 
> Why reinvent the wheel when that's readahead()'s job?  As a workaround
> I'm about to try just threading all of the calls to open().

FIEMAP suggestion is only if you think you need to issue reads for
multiple blocks in the _same_ directory in parallel.  From what you say,
I doubt that's important.

FIEMAP is not relevant for reading different directories in parallel.
You'd still have to thread the FIEMAP calls for that - it's a
different problem.

> Each one will queue a read and block, but with them all doing so at
> once should fill the queue with plenty of reads.  It is inefficient,
> but better than one block at a time.

That was my first suggestion: threads with readdir(); I thought it had
been rejected hence the further discussion.

(Actually I would use clone + open + getdirentries + tiny userspace
stack to avoid using tons of memory.  But that's just a tweak, only to
be used if the threading is effective.)

-- Jamie


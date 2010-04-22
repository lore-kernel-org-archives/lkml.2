Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab0DVTYD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:24:03 -0400
Received: from exhub016-2.exch016.msoutlookonline.net ([207.5.72.164]:30472
	"EHLO EXHUB016-2.exch016.msoutlookonline.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753585Ab0DVTYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:24:00 -0400
Message-ID: <4BD0A24B.4060209@cfl.rr.com>
Date: Thu, 22 Apr 2010 15:23:55 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jamie Lokier <jamie@shareable.org>
CC: linux-fsdevel@vger.kernel.org, Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: readahead on directories
References: <4BCC7C05.8000803@cfl.rr.com> <20100421004434.GA27420@shareable.org> <4BCF123C.6010400@cfl.rr.com> <20100421161211.GC27575@shareable.org> <4BCF3FAE.7090206@cfl.rr.com> <20100421202209.GV27575@shareable.org> <4BCF6731.1070404@cfl.rr.com> <20100421220612.GD27575@shareable.org> <4BD05C9C.9020101@cfl.rr.com> <20100422175322.GE6265@shareable.org>
In-Reply-To: <20100422175322.GE6265@shareable.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/22/2010 1:53 PM, Jamie Lokier wrote:
> Right, but finding those blocks is highly filesystem-dependent which
> is why making it a generic feature would need support in each filesystem.

It already exists, it's called ->get_blocks().  That's how readahead()
figures out which blocks need to be read.

> support FIEMAP on directories should work.  We're back to why not do
> it yourself then, as very few programs need directory readahead.

Because there's already a system call to accomplish that exact task; why
reinvent the wheel?

> If you're interested, try finding all the places which could sleep for
> a write() call...  Note that POSIX requires a mutex for write; you
> can't easily change that.  Reading is easier to make fully async than
> writing.

POSIX doesn't say anything about how write() must be implemented
internally.  You can do without mutexes just fine.  A good deal of the
current code does use mutexes, but does not have to.  If your data is
organized well then the critical sections of code that modify it can be
kept very small, and guarded with either atomic access functions or a
spin lock.  A mutex is more convenient since it it allows you to have
much larger critical sections and sleep, but we don't really like having
coarse grained locking in the kernel.

> Then readahead() isn't async, which was your request...  It can block
> waiting for memory and other things when you call it.

It doesn't have to block; it can return -ENOMEM or -EWOULDBLOCK.

> Exactly.  And making it so it _never_ blocks when called is a ton of
> work, more lines of code (in C anyway), a maintainability nightmare,
> and adds some different bottlenecks you've not thought off.  At this
> point I suggest you look up the 2007 discussions about fibrils which
> are quite good: They cover the overheads of setting up state for async
> calls when unnecessary, and the beautiful simplicty of treating stack
> frames as states in their own right.

Sounds like an interesting compromise.  I'll look it up.

> No: In that particular case, waiting while the indirect block is
> parsed is advantageous.  But suppose the first indirect block is
> located close to the second file's data blocks.  Or the second file's
> data blocks are on a different MD backing disk.  Or the disk has
> different seeking characteristics (flash, DRBD).

Hrm... true, so knowing this, defrag could lay out the indirect block of
the first file after the first 12 blocks of the second file to maintain
optimal reading.  Hrm... I might have to try that.

> I reckon the same applies to your readahead() calls: A queue which you
> make sure is always full enough that threads never block, sorted by
> inode number or better hints where known, with a small number of
> threads calling readahead() for files, and doing whatever is useful
> for directories.

Yes, and ureadahead already orders the calls to readahead() based on
disk block order.  Multithreading it leads the problem with backward
seeks right now but a tweak to the way defrag lays out the indirect
blocks, should fix that.  The more I think about it the better this idea
sounds.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939Ab0DUQMO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 12:12:14 -0400
Received: from mail2.shareable.org ([80.68.89.115]:55901 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755900Ab0DUQMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 12:12:12 -0400
Date: Wed, 21 Apr 2010 17:12:11 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Phillip Susi <psusi@cfl.rr.com>
Cc: linux-fsdevel@vger.kernel.org, Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: readahead on directories
Message-ID: <20100421161211.GC27575@shareable.org>
References: <4BCC7C05.8000803@cfl.rr.com> <20100421004434.GA27420@shareable.org> <4BCF123C.6010400@cfl.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BCF123C.6010400@cfl.rr.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Phillip Susi wrote:
> On 4/20/2010 8:44 PM, Jamie Lokier wrote:
> > readahead() doesn't make much sense on a directory - the offset and
> > size aren't meaningful.
> > 
> > But does plain opendir/readdir/closedir solve the problem?
> 
> No, since those are synchronous.  I want to have readahead() queue up
> reading the entire directory in the background to avoid blocking, and
> get the queue filled with a bunch of requests that can be merged into
> larger segments before being dispatched to the hardware.

Asynchronous is available: Use clone or pthreads.

More broadly: One of the ways to better I/O sorting is to make sure
you've got enough things in parallel that the I/O queue is never
empty, so what you issue has time to get sorted before it reaches the
head of the queue for dispatch.  On the other hand, not so many things
in parallel that the queues fill up and throttle.  Unfortunately it
only works if things aren't serialised by kernel locks - but there's been
a lot of work on lockless this and that in the kernel, which may help.

Back to your problem: You need a bunch of scattered block requests to
be queued and sorted sanely, and readdir doesn't do that, and even
waits for each block before issuing the next request.

Or does it?

A quick skim of fs/{ext3,ext4}/dir.c finds a call to
page_cache_sync_readahead.  Doesn't that do any reading ahead? :-)

> I don't actually care to have the contents of the
> directories returned, so readdir() does more than I need in that
> respect, and also it performs a blocking read of one disk block at a
> time, which is horribly slow with a cold cache.

I/O is the probably the biggest cost, so it's more important to get
the I/O pattern you want than worrying about return values you'll discard.

If readdir() calls are slowed by lots of calls and libc, consider
using the getdirentries system call directly.

If not, fs/ext4/namei.c:ext4_dir_inode_operations points to
ext4_fiemap.  So you may have luck calling FIEMAP or FIBMAP on the
directory, and then reading blocks using the block device.  I'm not
sure if the cache loaded via the block device (when mounted) will then
be used for directory lookups.

-- Jamie

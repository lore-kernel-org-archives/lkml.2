Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600Ab0DUU7e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 16:59:34 -0400
Received: from exhub016-3.exch016.msoutlookonline.net ([207.5.72.226]:38391
	"EHLO EXHUB016-3.exch016.msoutlookonline.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755012Ab0DUU7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 16:59:32 -0400
Message-ID: <4BCF6731.1070404@cfl.rr.com>
Date: Wed, 21 Apr 2010 16:59:29 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jamie Lokier <jamie@shareable.org>
CC: linux-fsdevel@vger.kernel.org, Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: readahead on directories
References: <4BCC7C05.8000803@cfl.rr.com> <20100421004434.GA27420@shareable.org> <4BCF123C.6010400@cfl.rr.com> <20100421161211.GC27575@shareable.org> <4BCF3FAE.7090206@cfl.rr.com> <20100421202209.GV27575@shareable.org>
In-Reply-To: <20100421202209.GV27575@shareable.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/21/2010 4:22 PM, Jamie Lokier wrote:
> Because tests have found that it's sometimes faster than AIO anyway!

Not when the aio is working properly ;)

This is getting a bit off topic, but aio_read() and readahead() have to
map the disk blocks before they can queue a read.  In the case of ext2/3
this often requires reading an indirect block from the disk so the
kernel has to wait for that read to finish before it can queue the rest
of the reads and return.  With ext4 extents, usually all of the mapping
information is in the inode so all of the reads can be queued without
delay, and the kernel returns to user space immediately.

So older testing done on ext3 likely ran into this and lead to the
conclusion that threading can be faster, but it would be preferable when
using ext4 with extents to drop the read requests in the queue without
the bother of setting up and tearing down threads, which is really just
a workaround for a shortcoming in aio_read and readahead() when using
indirect blocks.  For that matter aio_read and readahead() could
probably benefit from some reworking to fix this so that they can return
as soon as they have queued the read of the indirect block, and queueing
the remaining reads can be deferred until the indirect block comes in.

> ...for those things where AIO is supported at all.  The problem with
> more complicated fs operations (like, say, buffered file reads and
> directory operations) is you can't just put a request in a queue.

Unfortunately there aren't async versions of the calls that make
directory operations, but aio_read() performs a buffered file read
asynchronously just fine.  Right now though I'm only concerned with
reading lots of data into the cache at boot time to speed things up.

> Those things where putting a request on a queue works tend to move the
> sleepable metadata fetching to the code _before_ the request is queued
> to get around that.  Which is one reason why Linux O_DIRECT AIO can
> still block when submitting a request... :-/

Yep, as I just described.  Would be nice to fix this.

> The most promising direction for AIO at the moment is in fact spawning
> kernel threads on demand to do the work that needs a context, and
> swizzling some pointers so that it doesn't look like threads were used
> to userspace.

NO!  This is how aio was implemented at first and it was terrible.
Context is only required because it is easier to write the code linearly
instead of as a state machine.  It would be better for example, to have
readahead() register a callback function to be called when the read of
the indirect block completes, and the callback needs zero context to
queue reads of the data blocks referred to by the indirect block.

> You might even find that calling readahead() on *files* goes a bit
> faster if you have several threads working in parallel calling it,
> because of the ability to parallelise metadata I/O.

Indeed... or you can use extents, or fix the implementation of
readahead() ;)

> So you're saying it _does_ readahead_size if needed.  That's great!

I'm not sure, I'm just saying that if it does, it does not help much
since most directories fit in a single 4kb block anyhow.  I need to get
a number of different directories read quickly.

> Filesystem-independent readahead() on directories is out of the
> question (except by using a kernel background thread, which is
> pointless because you can do that yourself.)

No need for a thread.  readahead() does not need one for files, reading
the contents of a directory should be no different.

> Some filesystems have directories which aren't stored like a file's
> data, and the process of reading the directory needs to work through
> its logic, and needs a sleepable context to work in.  Generic page
> reading won't work for all of them.

If the fs absolutely has to block that's ok, since that is no different
from the way readahead() works on files, but most of the time it
shouldn't have to and should be able to throw the read in the queue and
return.

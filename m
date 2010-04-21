Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859Ab0DUTMd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 15:12:33 -0400
Received: from exhub016-3.exch016.msoutlookonline.net ([207.5.72.226]:19121
	"EHLO EXHUB016-3.exch016.msoutlookonline.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754518Ab0DUTMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 15:12:31 -0400
Message-ID: <4BCF3FAE.7090206@cfl.rr.com>
Date: Wed, 21 Apr 2010 14:10:54 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jamie Lokier <jamie@shareable.org>
CC: linux-fsdevel@vger.kernel.org, Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: readahead on directories
References: <4BCC7C05.8000803@cfl.rr.com> <20100421004434.GA27420@shareable.org> <4BCF123C.6010400@cfl.rr.com> <20100421161211.GC27575@shareable.org>
In-Reply-To: <20100421161211.GC27575@shareable.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/21/2010 12:12 PM, Jamie Lokier wrote:
> Asynchronous is available: Use clone or pthreads.

Synchronous in another process is not the same as async.  It seems I'm
going to have to do this for now as a workaround, but one of the reasons
that aio was created was to avoid the inefficiencies this introduces.
Why create a new thread context, switch to it, put a request in the
queue, then sleep, when you could just drop the request in the queue in
the original thread and move on?

> A quick skim of fs/{ext3,ext4}/dir.c finds a call to
> page_cache_sync_readahead.  Doesn't that do any reading ahead? :-)

Unfortunately it does not help when it is synchronous.  The process
still sleeps until it has fetched the blocks it needs.  I believe that
code just ends up doing a single 4kb read if the directory is no larger
than that, or if it is, then it reads up to readahead_size.  It puts the
request in the queue then sleeps until all the data has been read, even
if only the first 4kb was required before readdir() could return.

This means that a single thread calling readdir() is still going to
block reading the directory before it can move on to trying to read
other directories that are also needed.

> I/O is the probably the biggest cost, so it's more important to get
> the I/O pattern you want than worrying about return values you'll discard.

True, but it would be nice not to waste cpu cycles copying unneeded data
around.

> If not, fs/ext4/namei.c:ext4_dir_inode_operations points to
> ext4_fiemap.  So you may have luck calling FIEMAP or FIBMAP on the
> directory, and then reading blocks using the block device.  I'm not
> sure if the cache loaded via the block device (when mounted) will then
> be used for directory lookups.

Yes, I had considered that.  ureadahead already makes use of ext2fslibs
to open the block device and read the inode tables so they are already
in the cache for later use.  It seems a bit silly to do that though,
when that is exactly what readahead() SHOULD do for you.

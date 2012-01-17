Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253Ab2AQAgZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 19:36:25 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:29076 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751223Ab2AQAgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 19:36:23 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AloVANK+FE95LbVq/2dsb2JhbABErDAHAYEDgQaBcgEBBAEyASMjBQsIAxguFCUDIROHerYQE4kYAQEICQ0LBgQBBQgFBBEFAQYBAQYBBQYJDRABAgEBCAEBAQECgngBBQECAwcBBAEBAQGDKmMElRCSVg
Date: Tue, 17 Jan 2012 11:36:13 +1100
From: Dave Chinner <david@fromorbit.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        Edward Shishkin <edward@redhat.com>
Subject: Re: [RFC PATCH 0/3] Stop clearing uptodate flag on write IO error
Message-ID: <20120117003613.GA28571@dastard>
References: <1325774407-28531-1-git-send-email-jack@suse.cz>
 <CA+55aFy0sidnCzPkP6yjnarLZx3a=7QSpgfaf2mUNVy14y3vCw@mail.gmail.com>
 <20120116160136.GC16431@quack.suse.cz>
 <CA+55aFyUiLq7UZeQD=-MU5ppvEDULiBP8xV0mJqVLL6nFAi7VA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFyUiLq7UZeQD=-MU5ppvEDULiBP8xV0mJqVLL6nFAi7VA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 10:55:55AM -0800, Linus Torvalds wrote:
> On Mon, Jan 16, 2012 at 8:01 AM, Jan Kara <jack@suse.cz> wrote:
> >
> >  Hum, let me understand this. I understand the meaning of buffer_uptodate
> > bit as "the buffer has at least as new content as what is on disk". Now
> > when storage cannot write the block under the buffer, the contents of the
> > buffer is still "at least as new as what is (was) on disk".
> 
> No.
> 
> Stop making crap up.

Jan is right, Linus. His definition of what up-to-date means for
dirty buffers is correct, especially in the case of write errors.

> If the write fails, the buffer contents have *nothing* to do with what
> is on disk.

The dirty buffer contains what is *supposed* to be on disk. If we
fail to write it, we corrupt some application's data.

> You don't know what the disk contents are.

But *we don't care* what is on disk after a write error because
there is no guarantee that after a write error we can even read the
previous data that was on disk. IOWs, the contents of the region on
disk where the write failed is -undefined- and cannot be trusted.

> So clearly the buffer cannot be up-to-date.

What we have in memory is what is *supposed* to be on disk, and the
error is telling us that the disk is failing to be made up-to-date.
IOWs, the disk is stale after a write error, not what is in memory.
So clearly the buffer contains the up-to-date version of the data
after a write error.

How the filesystem handles that error is now up to the filesystem.
For example, the filesystem can chose to allocate new blocks for the
failed write and write the valid, up-to-date in-memory data to a
different location and continue onwards without errors. From this
example, it's pretty obvious that the data in memory contains the
data that what we need to care about after a write error, not what
is on disk.

> Now, feel free to use *other* arguments for why we shouldn't clear the
> up-to-date bit, but using the disk contents as one is pure and utter
> garbage. And it is *obviously* pure and utter garbage.

For the read case you are correct, but that logic (that the disk
version is always correct) does not apply to handling write errors.
It's an important distinction....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

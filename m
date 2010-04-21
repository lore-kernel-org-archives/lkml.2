Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520Ab0DUUhZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 16:37:25 -0400
Received: from mail2.shareable.org ([80.68.89.115]:42723 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756482Ab0DUUhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 16:37:24 -0400
Date: Wed, 21 Apr 2010 21:37:21 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Phillip Susi <psusi@cfl.rr.com>
Cc: Evgeniy Polyakov <zbr@ioremap.net>, linux-fsdevel@vger.kernel.org,
       Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: readahead on directories
Message-ID: <20100421203721.GW27575@shareable.org>
References: <4BCC7C05.8000803@cfl.rr.com> <20100421004434.GA27420@shareable.org> <4BCF123C.6010400@cfl.rr.com> <20100421161211.GC27575@shareable.org> <20100421183853.GA14897@ioremap.net> <20100421185124.GM27575@shareable.org> <4BCF509E.2040903@cfl.rr.com> <20100421200104.GT27575@shareable.org> <4BCF5C87.8060509@cfl.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BCF5C87.8060509@cfl.rr.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Phillip Susi wrote:
> On 4/21/2010 4:01 PM, Jamie Lokier wrote:
> > Ok, this discussion has got a bit confused.  Text above refers to
> > needing to asynchronously read next block in a directory, but if they
> > are small then that's not important.
> 
> It is very much important since if you ready each small directory one
> block at a time, it is very slow.  You want to queue up reads to all of
> them at once so they can be batched.

I don't understand what you are saying at this point.  Or you don't
understand what I'm saying.  Or I didn't understand what Evigny was
saying :-)

Small directories don't _have_ next blocks; this is not a problem for
them.  And you've explained that filesystems of interest already fetch
readahead_size in larger directories, so they don't have the "next
block" problem either.

> > That was my first suggestion: threads with readdir(); I thought it had
> > been rejected hence the further discussion.
> 
> Yes, it was sort of rejected, which is why I said it's just a workaround
> for now until readahead() works on directories.  It will produce the
> desired IO pattern but at the expense of ram and cpu cycles creating a
> bunch of short lived threads that go to sleep almost immediately after
> being created, and exit when they wake up.  readahead() would be much
> more efficient.

Some test results comparing AIO with kernel threads indicate that
threads are more efficient than you might expect for this.  Especially
in the cold I/O cache cases.  readahead() has to do a lot of the same
work, in a different way and with less opportunity to parallelise the
metadata stage.

clone() threads with tiny stacks (you can even preallocate the stacks,
and they can be smaller than a page) aren't especially slow or big,
and ideally you'll use *long-lived* threads with an efficient
multi-consumer queue that they pull requests from, written to by the
main program and kept full enough to avoid blocking the threads.

Also since you're discarding the getdirentries() data, you can read
all of it into the same memory for hot cache goodness.  (One per CPU
please.)

I don't know what performance that'll get you, but I think it'll be
faster than you are expecting - *if* the directory locking is
sufficiently scalable at this point.  That's an unknown.

Try it with files if you want to get a comparative picture.

-- Jamie

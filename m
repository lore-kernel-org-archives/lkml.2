Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714Ab0LFNuw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 08:50:52 -0500
Received: from THUNK.ORG ([69.25.196.29]:44343 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610Ab0LFNuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 08:50:51 -0500
Date: Mon, 6 Dec 2010 08:50:49 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Avery Pennarun <apenwarr@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: posix_fadvise(POSIX_FADV_WILLNEED) waits before returning?
Message-ID: <20101206135049.GB8135@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Avery Pennarun <apenwarr@gmail.com>, linux-kernel@vger.kernel.org
References: <AANLkTikV+uqwrCpmXywB6GqrFtOdR7LLWVJGp_VeSZg6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikV+uqwrCpmXywB6GqrFtOdR7LLWVJGp_VeSZg6@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 06, 2010 at 05:17:24AM -0800, Avery Pennarun wrote:
> 
> My understanding is that readahead() is synchronous (it reads the
> pages, then it returns), but posix_fadvise(POSIX_FADV_WILLNEED) is
> asynchronous (it enqueues the pages for reading, but returns
> immediately).  The latter is the behaviour I want.  However, AFAICT
> the latter function is running synchronously - it does exactly the
> same thing as readahead() - which kind of defeats the point.  I've
> searched around in Google and everybody seems to claim that this
> function really does work in the background as it should, so I'm
> mystified.

readahead and posix_fadvise(POSIX_FADV_WILLNEED) work exactly the same
way, and in fact share mostly the same code path (see
force_page_cache_readahead() in mm/readahead.c).

They are asynchronous in that there is no guarantee the pages will be
in the page cache by the time they return.  But at the same time, they
are not guaranteed to be non-blocking.  That is, the work of doing the
readahead does not take place in a kernel thread.  So if you try to
request I/O than will fit in the request queue, the system call will
block until some I/O is completed so that more I/O requested cam be
loaded onto the request queue.

The only way to fix this would be to either put the work on a kernel
thread (i.e., some kind of workqueue) or in a userspace thread.  For
an application programmer wondering what to do today, I'd suggest the
latter since it will be more portable across various kernel versions.

This does leave the question about whether we should change the kernel
to allow readahead() and posix_fadvise(POSIX_FADV_WILLNEED) to be
non-blocking and do this work in a workqueue (or via some kind of
callback/continuation scheme).  My worry is just doing this if a user
application does something crazy, like request gigabytes and gigabytes
of readahead, and then repents of their craziness, there should be a
way of cancelling the readahead request.  Today, the user can just
kill the application.  But if we simply shove the work to a kernel
thread, it becomes a lot harder to cancel the readahead request.  We'd
have to invent a new API, and then have a way to know whether the user
has access to kill a particular readahead request, etc.

							- Ted

P.S.  Yes, I know force_page_cache_readahead() doesn't currently have
a check for signal_pending(current) to break out of its loop.  But it
should, and that's a fixable problem.  The problem with pushing
readahead work into kernel thread is a conceptual one; our current
API's give no way cancelling the readahead request today.


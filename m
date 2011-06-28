Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660Ab1F1XES (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 19:04:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38288 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751205Ab1F1XEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 19:04:11 -0400
Date: Tue, 28 Jun 2011 16:03:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrea Righi <andrea@betterlinux.com>
Cc: Minchan Kim <minchan.kim@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>,
        Jerry James <jamesjer@betterlinux.com>,
        Marcus Sorensen <marcus@bluehost.com>, Matt Heaton <matt@bluehost.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Theodore Tso <tytso@mit.edu>,
        Shaohua Li <shaohua.li@intel.com>,
        =?ISO-8859-1?Q?P?= =?ISO-8859-1?Q?=E1draig?= Brady 
	<P@draigBrady.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 0/2] fadvise: move active pages to inactive list with
 POSIX_FADV_DONTNEED
Message-Id: <20110628160347.a5ffcc26.akpm@linux-foundation.org>
In-Reply-To: <20110628225645.GB2274@thinkpad>
References: <1309181361-14633-1-git-send-email-andrea@betterlinux.com>
	<20110628151233.f0a279be.akpm@linux-foundation.org>
	<20110628225645.GB2274@thinkpad>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Jun 2011 00:56:45 +0200
Andrea Righi <andrea@betterlinux.com> wrote:

> > > 
> > > In this way if the backup was the only user of a page, that page will be
> > > immediately removed from the page cache by calling POSIX_FADV_DONTNEED.  If the
> > > page was also touched by other processes it'll be moved to the inactive list,
> > > having another chance of being re-added to the working set, or simply reclaimed
> > > when memory is needed.
> > 
> > So if an application touches a page twice and then runs
> > POSIX_FADV_DONTNEED, that page will now not be freed.
> > 
> > That's a big behaviour change.  For many existing users
> > POSIX_FADV_DONTNEED simply doesn't work any more!
> 
> Yes. This is the main concern that was raised by P__draig.
> 
> > 
> > I'd have thought that adding a new POSIX_FADV_ANDREA would be safer
> > than this.
> 
> Actually Jerry (in cc) proposed
> POSIX_FADV_IDONTNEEDTHISBUTIFSOMEBODYELSEDOESTHENDONTTOUCHIT in a
> private email. :)

Sounds good.  Needs more underscores though.

> > 
> > 
> > The various POSIX_FADV_foo's are so ill-defined that it was a mistake
> > to ever use them.  We should have done something overtly linux-specific
> > and given userspace more explicit and direct pagecache control.
> 
> That would give us the possibility to implement a wide range of
> different operations (drop, drop if used once, add to the active list,
> add to the inactive list, etc..). Some users always complain that they
> would like to have a better control over the page cache from userspace.

Well, I'd listen to proposals ;)

One thing we must be careful about is to not expose things like "active
list" to userspace.  linux-4.5 may not _have_ an active list, and its
implementors would hate us and would have to jump through hoops to
implement vaguely compatible behaviour in the new scheme.

So any primitives which are exposed should be easily implementable and
should *make sense* within any future scheme...


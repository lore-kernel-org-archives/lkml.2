Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932410Ab2CATqh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 14:46:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49539 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757139Ab2CATqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 14:46:36 -0500
Date: Thu, 1 Mar 2012 11:46:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>, Greg Thelen <gthelen@google.com>,
        Ying Han <yinghan@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan.kim@gmail.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/9] writeback: introduce the pageout work
Message-Id: <20120301114634.957da8d2.akpm@linux-foundation.org>
In-Reply-To: <20120301114151.GA19049@localhost>
References: <20120228140022.614718843@intel.com>
	<20120228144747.198713792@intel.com>
	<20120228160403.9c9fa4dc.akpm@linux-foundation.org>
	<20120301110404.GC4385@quack.suse.cz>
	<20120301114151.GA19049@localhost>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Mar 2012 19:41:51 +0800
Fengguang Wu <fengguang.wu@intel.com> wrote:

> >   I think using get_page() might be a good way to go. Naive implementation:
> > If we need to write a page from kswapd, we do get_page(), attach page to
> > wb_writeback_work and push it to flusher thread to deal with it.
> > Flusher thread sees the work, takes a page lock, verifies the page is still
> > attached to some inode & dirty (it could have been truncated / cleaned by
> > someone else) and if yes, it submits page for IO (possibly with some
> > writearound). This scheme won't have problems with iput() and won't have
> > problems with umount. Also we guarantee some progress - either flusher
> > thread does it, or some else must have done the work before flusher thread
> > got to it.
> 
> I like this idea.
> 
> get_page() looks the perfect solution to verify if the struct inode
> pointer (w/o igrab) is still live and valid.
> 
> [...upon rethinking...] Oh but still we need to lock some page to pin
> the inode during the writeout. Then there is the dilemma: if the page
> is locked, we effectively keep it from being written out...

No, all you need to do is to structure the code so that after the page
gets unlocked, the kernel thread does not touch the address_space.  So
the processing within the kthread is along the lines of

writearound(locked_page)
{
	write some pages preceding locked_page;	/* touches address_space */
	write locked_page;
	write pages following locked_page;	/* touches address_space */
	unlock_page(locked_page);
}


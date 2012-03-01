Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757993Ab2CAVPz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 16:15:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44298 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757926Ab2CAVPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 16:15:54 -0500
Date: Thu, 1 Mar 2012 22:15:51 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, Fengguang Wu <fengguang.wu@intel.com>,
        Greg Thelen <gthelen@google.com>, Ying Han <yinghan@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan.kim@gmail.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/9] writeback: introduce the pageout work
Message-ID: <20120301211551.GD13104@quack.suse.cz>
References: <20120228140022.614718843@intel.com>
 <20120228144747.198713792@intel.com>
 <20120228160403.9c9fa4dc.akpm@linux-foundation.org>
 <20120301110404.GC4385@quack.suse.cz>
 <20120301114201.d1dcacad.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120301114201.d1dcacad.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 01-03-12 11:42:01, Andrew Morton wrote:
> On Thu, 1 Mar 2012 12:04:04 +0100
> Jan Kara <jack@suse.cz> wrote:
> 
> > > iirc, the way I "grabbed" the page was to actually lock it, with
> > > [try_]_lock_page().  And unlock it again way over within the writeback
> > > thread.  I forget why I did it this way, rather than get_page() or
> > > whatever.  Locking the page is a good way of preventing anyone else
> > > from futzing with it.  It also pins the inode, which perhaps meant that
> > > with careful management, I could avoid the igrab()/iput() horrors
> > > discussed above.
> >
> >   I think using get_page() might be a good way to go.
> 
> get_page() doesn't pin the inode - truncate() will still detach it
> from the address_space().
  Yes, I know. And exactly because of that I'd like to use it. Flusher
thread would lock the page from the work item, check whether it is still
attached to the inode and if yes, it will proceed. Otherwise it will just
discard the work item because we know the page has already been written out
by someone else or truncated.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

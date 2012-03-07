Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031608Ab2CGAho (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 19:37:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43429 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964894Ab2CGAhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 19:37:43 -0500
Date: Tue, 6 Mar 2012 16:37:42 -0800
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
Message-Id: <20120306163742.b71bf57b.akpm@linux-foundation.org>
In-Reply-To: <20120303132555.GA6312@localhost>
References: <20120228140022.614718843@intel.com>
	<20120228144747.198713792@intel.com>
	<20120228160403.9c9fa4dc.akpm@linux-foundation.org>
	<20120301110404.GC4385@quack.suse.cz>
	<20120301114151.GA19049@localhost>
	<20120301114634.957da8d2.akpm@linux-foundation.org>
	<20120303132555.GA6312@localhost>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Mar 2012 21:25:55 +0800
Fengguang Wu <fengguang.wu@intel.com> wrote:

> > > get_page() looks the perfect solution to verify if the struct inode
> > > pointer (w/o igrab) is still live and valid.
> > > 
> > > [...upon rethinking...] Oh but still we need to lock some page to pin
> > > the inode during the writeout. Then there is the dilemma: if the page
> > > is locked, we effectively keep it from being written out...
> > 
> > No, all you need to do is to structure the code so that after the page
> > gets unlocked, the kernel thread does not touch the address_space.  So
> > the processing within the kthread is along the lines of
> > 
> > writearound(locked_page)
> > {
> > 	write some pages preceding locked_page;	/* touches address_space */
> 
> It seems the above line will lead to ABBA deadlock.
> 
> At least btrfs will lock a number of pages in lock_delalloc_pages().

Well, this code locks multiple pages too.  I forget what I did about
that - probably trylock.  Dirty pages aren't locked for very long.


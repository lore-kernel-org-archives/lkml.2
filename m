Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395Ab2CIPPv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 10:15:51 -0500
Received: from mga03.intel.com ([143.182.124.21]:3519 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757285Ab2CIPPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 10:15:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="116854047"
Date: Fri, 9 Mar 2012 07:10:46 -0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>, Ying Han <yinghan@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan.kim@gmail.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Adrian Hunter <ext-adrian.hunter@nokia.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: Re: [PATCH 5/9] writeback: introduce the pageout work
Message-ID: <20120309151046.GA32749@localhost>
References: <20120228144747.198713792@intel.com>
 <20120228160403.9c9fa4dc.akpm@linux-foundation.org>
 <20120301123640.GA30369@localhost>
 <20120301163837.GA13104@quack.suse.cz>
 <20120302044858.GA14802@localhost>
 <20120302095910.GB1744@quack.suse.cz>
 <20120302103951.GA13378@localhost>
 <20120302115700.7d970497.akpm@linux-foundation.org>
 <20120303135558.GA9869@localhost>
 <20120309101546.GA14159@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120309101546.GA14159@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2012 at 11:15:46AM +0100, Jan Kara wrote:
> On Sat 03-03-12 21:55:58, Wu Fengguang wrote:
> > On Fri, Mar 02, 2012 at 11:57:00AM -0800, Andrew Morton wrote:
> > > On Fri, 2 Mar 2012 18:39:51 +0800
> > > Fengguang Wu <fengguang.wu@intel.com> wrote:
> > > 
> > > > > And I agree it's unlikely but given enough time and people, I
> > > > > believe someone finds a way to (inadvertedly) trigger this.
> > > > 
> > > > Right. The pageout works could add lots more iput() to the flusher
> > > > and turn some hidden statistical impossible bugs into real ones.
> > > > 
> > > > Fortunately the "flusher deadlocks itself" case is easy to detect and
> > > > prevent as illustrated in another email.
> > > 
> > > It would be a heck of a lot safer and saner to avoid the iput().  We
> > > know how to do this, so why not do it?
> > 
> > My concern about the page lock is, it costs more code and sounds like
> > hacking around something. It seems we (including me) have been trying
> > to shun away from the iput() problem. Since it's unlikely we are to
> > get rid of the already existing iput() calls from the flusher context,
> > why not face the problem, sort it out and use it with confident in new
> > code?
>   We can get rid of it in the current code - see my patch set. And also we
> don't have to introduce new iput() with your patch set... I don't think
> using ->writepage() directly on a locked page would be a good thing because
> filesystems tend to ignore it completely (e.g. ext4 if it needs to do an
> allocation, or btrfs) or are much less efficient than when ->writepages()
> is used.  So I'd prefer going through writeback_single_inode() as the rest
> of flusher thread.

Totally agreed. I was also not feeling good to use ->writepage() on
the locked page. It looks very nice to pin the inode with I_SYNC
rather than igrab or lock_page.

> > Let me try it now. The only scheme iput() can deadlock the flusher is
> > for the iput() path to come back to queue some work and wait for it.
>   Let me stop you right here. You severely underestimate the complexity of
> filesystems :). Take for example ext4. To do truncate you need to start a
> transaction, to start a transaction, you have to have a space in journal.
> To have a space in journal, you may have to wait for any other process to
> finish writing. If that process needs to wait for flusher thread to be able
> to finish writing, you have a deadlock. And there are other implicit
> dependencies like this. And it's similar for other filesystems as well. So
> you really want to make flusher thread as light as possible with the
> dependencies.

Ah OK, please forgive my ignorance. Let's get rid of the existing
iput()s in the flusher thread.

Thanks,
Fengguang

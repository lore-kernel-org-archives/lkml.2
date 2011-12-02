Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626Ab1LBKb5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 05:31:57 -0500
Received: from mga01.intel.com ([192.55.52.88]:45136 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752398Ab1LBKb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 05:31:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,282,1320652800"; 
   d="scan'208";a="97845822"
Date: Fri, 2 Dec 2011 18:28:44 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Jan Kara <jack@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] writeback: permit through good bdi even when global
 dirty exceeded
Message-ID: <20111202102844.GA2918@localhost>
References: <1322735278-17420-1-git-send-email-jack@suse.cz>
 <20111201122425.GA16274@localhost>
 <20111201142704.GT4387@parisc-linux.org>
 <20111202063603.GA10095@localhost>
 <20111201230359.306c4c17.akpm@linux-foundation.org>
 <20111202082950.GA19148@localhost>
 <20111202101606.GA1158@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111202101606.GA1158@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 02, 2011 at 06:16:06PM +0800, Wu Fengguang wrote:
> On Fri, Dec 02, 2011 at 04:29:50PM +0800, Wu Fengguang wrote:
> > On Fri, Dec 02, 2011 at 03:03:59PM +0800, Andrew Morton wrote:
> > > On Fri, 2 Dec 2011 14:36:03 +0800 Wu Fengguang <fengguang.wu@intel.com> wrote:
> > > 
> > > > --- linux-next.orig/mm/page-writeback.c	2011-12-02 10:16:21.000000000 +0800
> > > > +++ linux-next/mm/page-writeback.c	2011-12-02 14:28:44.000000000 +0800
> > > > @@ -1182,6 +1182,14 @@ pause:
> > > >  		if (task_ratelimit)
> > > >  			break;
> > > >  
> > > > +		/*
> > > > +		 * In the case of an unresponding NFS server and the NFS dirty
> > > > +		 * pages exceeds dirty_thresh, give the other good bdi's a pipe
> > > > +		 * to go through, so that tasks on them still remain responsive.
> > > > +		 */
> > > > +		if (bdi_dirty < 8)
> > > > +			break;
> > > 
> > > What happens if the local disk has nine dirty pages?
> > 
> > The 9 dirty pages will be cleaned by the flusher (likely in one shot),
> > so after a while the dirtier task can dirty 8 pages more. This
> > consumer-producer work flow can keep going on as long as the magic
> > number chosen is >= 1.
> > 
> > > Also: please, no more magic numbers.  We have too many in there already.
> > 
> > Good point. Let's add some comment on the number chosen?
> 
> I did a dd test to the local disk (when w/ a stalled NFS mount) and
> find that it always idle for several seconds before making a little
> progress. It can be confirmed from the trace that the bdi_dirty
> remains 8 even when the flusher has done its work.
> 
> So the number is lifted to bdi_stat_error to cover the errors in
> bdi_dirty. Here goes the updated patch.

The new trace now shows bdi_dirty=0 in the _majority_ lines. But in
fact it's some small value. In this case the max pause time should
really be set to the smallest non-zero value to avoid IO queue underrun
and improve throughput.

So here comes one more fix.

--- linux-next.orig/mm/page-writeback.c	2011-12-02 18:20:14.000000000 +0800
+++ linux-next/mm/page-writeback.c	2011-12-02 18:20:27.000000000 +0800
@@ -989,18 +989,17 @@ static unsigned long bdi_max_pause(struc
 
 	/*
 	 * Limit pause time for small memory systems. If sleeping for too long
 	 * time, a small pool of dirty/writeback pages may go empty and disk go
 	 * idle.
 	 *
 	 * 8 serves as the safety ratio.
 	 */
-	if (bdi_dirty)
-		t = min(t, bdi_dirty * HZ / (8 * bw + 1));
+	t = min(t, bdi_dirty * HZ / (8 * bw + 1));
 
 	/*
 	 * The pause time will be settled within range (max_pause/4, max_pause).
 	 * Apply a minimal value of 4 to get a non-zero max_pause/4.
 	 */
 	return clamp_val(t, 4, MAX_PAUSE);
 }
 

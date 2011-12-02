Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab1LBKQL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 05:16:11 -0500
Received: from mga03.intel.com ([143.182.124.21]:59204 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752366Ab1LBKQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 05:16:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,282,1320652800"; 
   d="scan'208";a="81463367"
Date: Fri, 2 Dec 2011 18:16:06 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Jan Kara <jack@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] writeback: permit through good bdi even when global
 dirty exceeded
Message-ID: <20111202101606.GA1158@localhost>
References: <1322735278-17420-1-git-send-email-jack@suse.cz>
 <20111201122425.GA16274@localhost>
 <20111201142704.GT4387@parisc-linux.org>
 <20111202063603.GA10095@localhost>
 <20111201230359.306c4c17.akpm@linux-foundation.org>
 <20111202082950.GA19148@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111202082950.GA19148@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 02, 2011 at 04:29:50PM +0800, Wu Fengguang wrote:
> On Fri, Dec 02, 2011 at 03:03:59PM +0800, Andrew Morton wrote:
> > On Fri, 2 Dec 2011 14:36:03 +0800 Wu Fengguang <fengguang.wu@intel.com> wrote:
> > 
> > > --- linux-next.orig/mm/page-writeback.c	2011-12-02 10:16:21.000000000 +0800
> > > +++ linux-next/mm/page-writeback.c	2011-12-02 14:28:44.000000000 +0800
> > > @@ -1182,6 +1182,14 @@ pause:
> > >  		if (task_ratelimit)
> > >  			break;
> > >  
> > > +		/*
> > > +		 * In the case of an unresponding NFS server and the NFS dirty
> > > +		 * pages exceeds dirty_thresh, give the other good bdi's a pipe
> > > +		 * to go through, so that tasks on them still remain responsive.
> > > +		 */
> > > +		if (bdi_dirty < 8)
> > > +			break;
> > 
> > What happens if the local disk has nine dirty pages?
> 
> The 9 dirty pages will be cleaned by the flusher (likely in one shot),
> so after a while the dirtier task can dirty 8 pages more. This
> consumer-producer work flow can keep going on as long as the magic
> number chosen is >= 1.
> 
> > Also: please, no more magic numbers.  We have too many in there already.
> 
> Good point. Let's add some comment on the number chosen?

I did a dd test to the local disk (when w/ a stalled NFS mount) and
find that it always idle for several seconds before making a little
progress. It can be confirmed from the trace that the bdi_dirty
remains 8 even when the flusher has done its work.

So the number is lifted to bdi_stat_error to cover the errors in
bdi_dirty. Here goes the updated patch.

---
Subject: writeback: permit through good bdi even when global dirty exceeded
Date: Fri Dec 02 10:21:33 CST 2011

On a system with 1 local mount and 1 NFS mount, if the NFS server
becomes not responding when dd to the NFS mount, the NFS dirty pages may
exceed the global dirty limit and _every_ task involving writing will be
blocked. The whole system appears unresponsive.

The workaround is to permit through the bdi's that only has a small
number of dirty pages. The number chosen (bdi_stat_error pages) is not
enough to enable the local disk to run in optimal throughput, but is
enough to make the system responsive on a broken NFS mount. The user can
then kill the dirtiers on the NFS mount and increase the global dirty
limit to bring up the local disk's throughput.

It risks allowing dirty pages to grow much larger than the global dirty
limit when there are 1000+ mounts, however that's very unlikely to happen,
especially in low memory profiles.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/page-writeback.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- linux-next.orig/mm/page-writeback.c	2011-12-02 17:01:09.000000000 +0800
+++ linux-next/mm/page-writeback.c	2011-12-02 18:07:01.000000000 +0800
@@ -1182,6 +1182,19 @@ pause:
 		if (task_ratelimit)
 			break;
 
+		/*
+		 * In the case of an unresponding NFS server and the NFS dirty
+		 * pages exceeds dirty_thresh, give the other good bdi's a pipe
+		 * to go through, so that tasks on them still remain responsive.
+		 *
+		 * In theory 1 page is enough to keep the consumer-producer
+		 * pipe going: the flusher cleans 1 page => the task dirties 1
+		 * more page. However bdi_dirty has accounting errors.  So use
+		 * the larger and more IO friendly bdi_stat_error.
+		 */
+		if (bdi_dirty < bdi_stat_error(bdi))
+			break;
+
 		if (fatal_signal_pending(current))
 			break;
 	}

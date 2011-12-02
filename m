Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987Ab1LBGgI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 01:36:08 -0500
Received: from mga09.intel.com ([134.134.136.24]:44288 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307Ab1LBGgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 01:36:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="82426244"
Date: Fri, 2 Dec 2011 14:36:03 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Matthew Wilcox <matthew@wil.cx>, Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] writeback: permit through good bdi even when global dirty
 exceeded
Message-ID: <20111202063603.GA10095@localhost>
References: <1322735278-17420-1-git-send-email-jack@suse.cz>
 <20111201122425.GA16274@localhost>
 <20111201142704.GT4387@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111201142704.GT4387@parisc-linux.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 01, 2011 at 10:27:05PM +0800, Matthew Wilcox wrote:
> On Thu, Dec 01, 2011 at 08:24:25PM +0800, Wu Fengguang wrote:
> > > This patch makes write interruptible by SIGKILL.
> > 
> > Let me try to summarize the objective impacts of (not) merging this
> > patch, and would like to hear more opinions from experienced users.
> > 
> > - w/o patch
> > 
> > BEHAVIOR:
> > write(2) insists to complete even when the user really wants to stop it.
> > 
> > IMPACT:
> > It could be annoying to experience slow responses to "kill -9" when
> > it's a large write to a slow device, for example,
> > 
> >         dd if=/dev/zero of=/mnt/nokia/zero bs=100M
> 
> Another problem scenario is an NFS mounted file going away while the
> user is writing to it.  The user should be able to kill the stuck process
> without rebooting their machine.

Hmm I find more serious problem: the whole (NFS client) test box may
(not always) go unresponsive when stopping the NFS server. I don't
even have the opportunity to kill that dd, nor able to establish a new
ssh login.

Tests show that the below patch is enough to make the system stay
responsive on a broken NFS mount.

Thanks,
Fengguang
--

Subject: writeback: permit through good bdi even when global dirty exceeded
Date: Fri Dec 02 10:21:33 CST 2011

On a system with 1 local mount and 1 NFS mount, if the NFS server
becomes not responding when dd to the NFS mount, the NFS dirty pages may
exceed the global dirty limit and _every_ task involving writing will be
blocked. The whole system appears unresponsive.

The workaround is to permit through the bdi's that only has a small
number of dirty pages. The number chosen (8 pages) is not enough to
enable the local disk to run in optimal throughput, but is enough to
make the system responsive on a broken NFS mount. The user can then
kill the dirtiers on the NFS mount and increase the global dirty limit
to bring up the local disk's throughput.

It risks allowing dirty pages to grow beyond 80000 (320MB) when there
are 10000 mounts, however that's very unlikely.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/page-writeback.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- linux-next.orig/mm/page-writeback.c	2011-12-02 10:16:21.000000000 +0800
+++ linux-next/mm/page-writeback.c	2011-12-02 14:28:44.000000000 +0800
@@ -1182,6 +1182,14 @@ pause:
 		if (task_ratelimit)
 			break;
 
+		/*
+		 * In the case of an unresponding NFS server and the NFS dirty
+		 * pages exceeds dirty_thresh, give the other good bdi's a pipe
+		 * to go through, so that tasks on them still remain responsive.
+		 */
+		if (bdi_dirty < 8)
+			break;
+
 		if (fatal_signal_pending(current))
 			break;
 	}

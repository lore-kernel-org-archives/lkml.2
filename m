Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab0KEVdc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 17:33:32 -0400
Received: from cantor.suse.de ([195.135.220.2]:56639 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751600Ab0KEVda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 17:33:30 -0400
Date: Fri, 5 Nov 2010 22:33:24 +0100
From: Jan Kara <jack@suse.cz>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <jens.axboe@oracle.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, stable@kernel.org,
        gregkh@suse.de
Subject: Re: Sync writeback still broken
Message-ID: <20101105213324.GA25520@quack.suse.cz>
References: <20100212091609.GB1025@kernel.dk>
 <alpine.LFD.2.00.1002120722270.7792@localhost.localdomain>
 <alpine.LSU.2.01.1002131356250.20838@obet.zrqbmnf.qr>
 <20100215144938.GD3434@quack.suse.cz>
 <alpine.LSU.2.01.1002151629380.27775@obet.zrqbmnf.qr>
 <alpine.LSU.2.01.1006271842220.1495@obet.zrqbmnf.qr>
 <alpine.LNX.2.01.1010250115360.16022@obet.zrqbmnf.qr>
 <20101031122437.GA6296@quack.suse.cz>
 <20101031224012.GB13207@quack.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
In-Reply-To: <20101031224012.GB13207@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun 31-10-10 23:40:12, Jan Kara wrote:
> On Sun 31-10-10 13:24:37, Jan Kara wrote:
> > On Mon 25-10-10 01:41:48, Jan Engelhardt wrote:
> > > On Sunday 2010-06-27 18:44, Jan Engelhardt wrote:
> > > >On Monday 2010-02-15 16:41, Jan Engelhardt wrote:
> > > >>On Monday 2010-02-15 15:49, Jan Kara wrote:
> > > >>>On Sat 13-02-10 13:58:19, Jan Engelhardt wrote:
> > > >>>> >> 
> > > >>>> >> This fixes it by using the passed in page writeback count, instead of
> > > >>>> >> doing MAX_WRITEBACK_PAGES batches, which gets us much better performance
> > > >>>> >> (Jan reports it's up from ~400KB/sec to 10MB/sec) and makes sync(1)
> > > >>>> >> finish properly even when new pages are being dirted.
> > > >>>> >
> > > >>>> >This seems broken.
> > > >>>> 
> > > >>>> It seems so. Jens, Jan Kara, your patch does not entirely fix this.
> > > >>>> While there is no sync/fsync to be seen in these traces, I can
> > > >>>> tell there's a livelock, without Dirty decreasing at all.
> > > >
> > > >What ultimately became of the discussion and/or the patch? 
> > > >
> > > >Your original ad-hoc patch certainly still does its job; had no need to 
> > > >reboot in 86 days and still counting.
> > > 
> > > I still observe this behavior on 2.6.36-rc8. This is starting to 
> > > get frustrating, so I will be happily following akpm's advise to 
> > > poke people.
> >   Yes, that's a good way :)
> > 
> > > Thread entrypoint: http://lkml.org/lkml/2010/2/12/41
> > > 
> > > Previously, many concurrent extractions of tarballs and so on have been 
> > > one way to trigger the issue; I now also have a rather small testcase 
> > > (below) that freezes the box here (which has 24G RAM, so even if I'm 
> > > lacking to call msync, I should be fine) sometime after memset finishes.
> >   I've tried your test but didn't succeed in freezing my laptop.
> > Everything was running smooth, the machine even felt reasonably responsive
> > although constantly reading and writing to disk. Also sync(1) finished in a
> > couple of seconds as one would expect in an optimistic case.
> >   Needless to say that my laptop has only 1G of ram so I had to downsize
> > the hash table from 16G to 1G to be able to run the test and the disk is
> > Intel SSD so the performance of the backing storage compared to the amount
> > of needed IO is much in my favor.
> >   OK, so I've taken a machine with standard rotational drive and 28GB of
> > ram and there I can see sync(1) hanging (but otherwise the machine looks
> > OK). Investigating further...
>   So with the writeback tracing, I verified that indeed the trouble is that
> work queued by sync(1) gets queued behind the background writeback which is
> just running. And background writeback won't stop because your process is
> dirtying pages so agressively. Actually, it would stop after writing
> LONG_MAX pages but that's effectively infinity. I have a patch
> (e.g. http://www.kerneltrap.com/mailarchive/linux-fsdevel/2010/8/3/6886244)
> to stop background writeback when other work is queued but it's kind
> of hacky so I can see why Christoph doesn't like it ;)
>   So I'll have to code something different to fix this issue...
  OK, so at Kernel Summit we agreed to fix the issue as I originally wanted
by patches
http://marc.info/?l=linux-fsdevel&m=128861735213143&w=2
and
http://marc.info/?l=linux-fsdevel&m=128861734813131&w=2

  I needed one more patch to resolve the issue (attached) which I've just
posted for review and possible inclusion. I had a similar one long time ago
but now I'm better able to explain why it works because of tracepoints.
Yay! ;). With those three patches I'm not able to trigger livelocks (but
sync takes still 15 minutes because the througput to disk is about 4MB/s -
no big surprise given the random nature of the load)

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--bg08WKrSYDhXBjb5
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-mm-Avoid-livelocking-of-WB_SYNC_ALL-writeback.patch"

>From 44c256bbd627ae75039b99724ce3c7caa7f4fd95 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Fri, 5 Nov 2010 17:56:03 +0100
Subject: [PATCH] mm: Avoid livelocking of WB_SYNC_ALL writeback

When wb_writeback() is called in WB_SYNC_ALL mode, work->nr_to_write is usually
set to LONG_MAX. The logic in wb_writeback() then calls __writeback_inodes_sb()
with nr_to_write == MAX_WRITEBACK_PAGES and thus we easily end up with negative
nr_to_write after the function returns. wb_writeback() then decides we need
another round of writeback but this is wrong in some cases! For example when
a single large file is continuously dirtied, we would never finish syncing
it because each pass would be able to write MAX_WRITEBACK_PAGES and inode dirty
timestamp never gets updated (as inode is never completely clean).

Fix the issue by setting nr_to_write to LONG_MAX in WB_SYNC_ALL mode. We do not
need nr_to_write in WB_SYNC_ALL mode anyway since livelock avoidance is done
differently for it.

After this patch, program from http://lkml.org/lkml/2010/10/24/154 is no longer
able to stall sync forever.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/fs-writeback.c |   18 ++++++++++++++----
 1 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 6b4d02a..d5873a6 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -629,6 +629,7 @@ static long wb_writeback(struct bdi_writeback *wb,
 	};
 	unsigned long oldest_jif;
 	long wrote = 0;
+	long write_chunk;
 	struct inode *inode;
 
 	if (wbc.for_kupdate) {
@@ -640,6 +641,15 @@ static long wb_writeback(struct bdi_writeback *wb,
 		wbc.range_start = 0;
 		wbc.range_end = LLONG_MAX;
 	}
+	/*
+	 * In WB_SYNC_ALL mode, we just want to ignore nr_to_write as
+	 * we need to write everything and livelock avoidance is implemented
+	 * differently.
+	 */
+	if (wbc.sync_mode == WB_SYNC_NONE)
+		write_chunk = MAX_WRITEBACK_PAGES;
+	else
+		write_chunk = LONG_MAX;
 
 	wbc.wb_start = jiffies; /* livelock avoidance */
 	for (;;) {
@@ -665,7 +675,7 @@ static long wb_writeback(struct bdi_writeback *wb,
 			break;
 
 		wbc.more_io = 0;
-		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
+		wbc.nr_to_write = write_chunk;
 		wbc.pages_skipped = 0;
 
 		trace_wbc_writeback_start(&wbc, wb->bdi);
@@ -675,8 +685,8 @@ static long wb_writeback(struct bdi_writeback *wb,
 			writeback_inodes_wb(wb, &wbc);
 		trace_wbc_writeback_written(&wbc, wb->bdi);
 
-		work->nr_pages -= MAX_WRITEBACK_PAGES - wbc.nr_to_write;
-		wrote += MAX_WRITEBACK_PAGES - wbc.nr_to_write;
+		work->nr_pages -= write_chunk - wbc.nr_to_write;
+		wrote += write_chunk - wbc.nr_to_write;
 
 		/*
 		 * If we consumed everything, see if we have more
@@ -691,7 +701,7 @@ static long wb_writeback(struct bdi_writeback *wb,
 		/*
 		 * Did we write something? Try for more
 		 */
-		if (wbc.nr_to_write < MAX_WRITEBACK_PAGES)
+		if (wbc.nr_to_write < write_chunk)
 			continue;
 		/*
 		 * Nothing written. Wait for some inode to
-- 
1.7.1


--bg08WKrSYDhXBjb5--

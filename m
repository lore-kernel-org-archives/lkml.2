Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757621Ab2AEBYz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 20:24:55 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62717 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757506Ab2AEBYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 20:24:51 -0500
Date: Wed, 4 Jan 2012 17:24:45 -0800
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Hugh Dickins <hughd@google.com>, Shaohua Li <shaohua.li@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH block/for-3.3/core] block: an exiting task should be
 allowed to create io_context
Message-ID: <20120105012445.GP31746@google.com>
References: <20111228164836.GP17712@google.com>
 <alpine.LSU.2.00.1112280939390.3320@eggly.anvils>
 <CAOS58YOzUcZz41+H+7dk5FteHy+Ufrtpk9dvdPqX6eie-GHi0Q@mail.gmail.com>
 <20111228211918.GA3516@google.com>
 <20120103173500.GB31746@google.com>
 <20120103175922.GC31746@google.com>
 <20120103200906.GG31746@google.com>
 <4F03631C.8080501@kernel.dk>
 <20120103221301.GH31746@google.com>
 <20120103223505.GI31746@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120103223505.GI31746@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, again.

On Tue, Jan 03, 2012 at 02:35:05PM -0800, Tejun Heo wrote:
> > Hmmm... I disabled cfqq merge logic (commented out
> > cfq_close_cooperator() and the following cfq_setup_merge() calls) in
> > cfq_select_queue() and neither is triggering for quite a while now.
> > Maybe cfqq refcnt is getting borked over cfqq merging / splitting?  It
> > would also explain the low frequency of the issue too.  I'll try to
> > further isolate it but It would be awesome if someone more familiar
> > with the logic can go over that part.
> 
> Scrap that.  It triggered and yeah cfq_get_next_queue() is retrieving
> empty cfqq from the service tree.

Update: I've been running with ELEVATOR_INSERT_SORT_MERGE disabled and
none of the issues triggered for about three hours now.  It usually
triggers under an hour.

Hugh, can you please verify whether the patch appended at the end
makes the problem go away?

Thanks.

diff --git a/block/elevator.c b/block/elevator.c
index 99838f4..2e172d2 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -644,6 +644,9 @@ void __elv_add_request(struct request_queue *q, struct request *rq, int where)
 
 	rq->q = q;
 
+	if (where == ELEVATOR_INSERT_SORT_MERGE)
+		where = ELEVATOR_INSERT_SORT;
+
 	if (rq->cmd_flags & REQ_SOFTBARRIER) {
 		/* barriers are scheduling boundary, update end_sector */
 		if (rq->cmd_type == REQ_TYPE_FS ||

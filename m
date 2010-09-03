Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660Ab0ICPNb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 11:13:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44917 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800Ab0ICPNa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 11:13:30 -0400
Date: Fri, 3 Sep 2010 11:13:24 -0400
From: David Teigland <teigland@redhat.com>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: dlm: Don't send callback to node making lock request when "try
 1cb" fails
Message-ID: <20100903151324.GB28819@redhat.com>
References: <1283506816.2500.21.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283506816.2500.21.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 03, 2010 at 10:40:16AM +0100, Steven Whitehouse wrote:
> 
> When converting a lock, an lkb is in the granted state and also being used
> to request a new state. In the case that the conversion was a "try 1cb"
> type which has failed, and if the new state was incompatible with the old
> state, a callback was being generated to the requesting node. This is
> incorrect as callbacks should only be sent to all the other nodes holding
> blocking locks. The requesting node should receive the normal (failed)
> response to its "try 1cb" conversion request only.
> 
> This was discovered while debugging a performance problem on GFS2, however
> this fix also speeds up GFS as well. In the GFS2 case the performance gain
> is over 10x for cases of write activity to an inode whose glock is cached
> on another, idle (wrt that glock) node.

Thanks, I added a comment and queued it up.
Dave


>From 314dd2a05340fffbe217c5e40ec6c3bd1d07bf89 Mon Sep 17 00:00:00 2001
From: Steven Whitehouse <swhiteho@redhat.com>
Date: Fri, 3 Sep 2010 10:07:48 -0500
Subject: [PATCH] dlm: Don't send callback to node making lock request when "try 1cb" fails

When converting a lock, an lkb is in the granted state and also being used
to request a new state. In the case that the conversion was a "try 1cb"
type which has failed, and if the new state was incompatible with the old
state, a callback was being generated to the requesting node. This is
incorrect as callbacks should only be sent to all the other nodes holding
blocking locks. The requesting node should receive the normal (failed)
response to its "try 1cb" conversion request only.

This was discovered while debugging a performance problem on GFS2, however
this fix also speeds up GFS as well. In the GFS2 case the performance gain
is over 10x for cases of write activity to an inode whose glock is cached
on another, idle (wrt that glock) node.

(comment added, dct)

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Tested-by: Abhijith Das <adas@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/lock.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 031dbe3..64e5f3e 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -1846,6 +1846,9 @@ static void send_bast_queue(struct dlm_rsb *r, struct list_head *head,
 	struct dlm_lkb *gr;
 
 	list_for_each_entry(gr, head, lkb_statequeue) {
+		/* skip self when sending basts to convertqueue */
+		if (gr == lkb)
+			continue;
 		if (gr->lkb_bastfn && modes_require_bast(gr, lkb)) {
 			queue_bast(r, gr, lkb->lkb_rqmode);
 			gr->lkb_highbast = lkb->lkb_rqmode;
-- 
1.7.1.1


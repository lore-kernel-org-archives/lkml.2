Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910Ab1HASrP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 14:47:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3475 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752786Ab1HASrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 14:47:10 -0400
Date: Mon, 1 Aug 2011 14:47:02 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>
Cc: "Israel G. Lugo" <israel.lugo@lugosys.com>
Subject: [PATCH] cfq-iosched: Reduce linked group count upon group destruction
Message-ID: <20110801184702.GF3805@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CFQ keeps track of number of groups which are linked on blkcg->blkg_list.
This is useful to avoid races between queue exit and cgroup exit code
paths. So if at the request queue exit time linked group count is not
zero, that means there are some group out there which is yet to be
deleted under rcu read period and queue exit code should wait for
on rcu period.

In my previous patch I forgot to decrease the number of group count.
So in current form, we nr_blkcg_linked_grps is always non-zero and
we will always wait one rcu period (if BLK_CGROUP=y). The side effect
of this is that it can increase boot time. I am surprised, nobody
complained so far.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6/block/cfq-iosched.c
===================================================================
--- linux-2.6.orig/block/cfq-iosched.c	2011-08-01 14:03:31.859334421 -0400
+++ linux-2.6/block/cfq-iosched.c	2011-08-01 14:03:38.130618773 -0400
@@ -1209,6 +1209,9 @@ static void cfq_destroy_cfqg(struct cfq_
 
 	hlist_del_init(&cfqg->cfqd_node);
 
+	BUG_ON(cfqd->nr_blkcg_linked_grps <= 0);
+	cfqd->nr_blkcg_linked_grps--;
+
 	/*
 	 * Put the reference taken at the time of creation so that when all
 	 * queues are gone, group can be destroyed.

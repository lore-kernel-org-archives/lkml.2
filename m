Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab0ICJea (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 05:34:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7842 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430Ab0ICJe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 05:34:29 -0400
Subject: dlm: Don't send callback to node making lock request when "try
 1cb" fails
From: Steven Whitehouse <swhiteho@redhat.com>
To: David Teigland <teigland@redhat.com>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Fri, 03 Sep 2010 10:40:16 +0100
Message-ID: <1283506816.2500.21.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Tested-by: Abhijith Das <adas@redhat.com>

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 031dbe3..dae42e1 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -1846,6 +1846,8 @@ static void send_bast_queue(struct dlm_rsb *r, struct list_head *head,
 	struct dlm_lkb *gr;
 
 	list_for_each_entry(gr, head, lkb_statequeue) {
+		if (gr == lkb)
+			continue;
 		if (gr->lkb_bastfn && modes_require_bast(gr, lkb)) {
 			queue_bast(r, gr, lkb->lkb_rqmode);
 			gr->lkb_highbast = lkb->lkb_rqmode;



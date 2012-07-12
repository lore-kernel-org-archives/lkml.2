Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759426Ab2GLWgj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:36:39 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45444 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759416Ab2GLWge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:36:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hiroaki SHIMODA <shimoda.hiroaki@gmail.com>,
        Tom Herbert <therbert@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Denys Fedoryshchenko <denys@visp.net.lb>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 018/187] bql: Avoid possible inconsistent calculation.
Date: Thu, 12 Jul 2012 15:32:54 -0700
Message-Id: <20120712191523.944857458@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Hiroaki SHIMODA <shimoda.hiroaki@gmail.com>

[ Upstream commit 914bec1011a25f65cdc94988a6f974bfb9a3c10d ]

dql->num_queued could change while processing dql_completed().
To provide consistent calculation, added an on stack variable.

Signed-off-by: Hiroaki SHIMODA <shimoda.hiroaki@gmail.com>
Cc: Tom Herbert <therbert@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Denys Fedoryshchenko <denys@visp.net.lb>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/dynamic_queue_limits.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/lib/dynamic_queue_limits.c
+++ b/lib/dynamic_queue_limits.c
@@ -17,16 +17,18 @@
 void dql_completed(struct dql *dql, unsigned int count)
 {
 	unsigned int inprogress, prev_inprogress, limit;
-	unsigned int ovlimit, completed;
+	unsigned int ovlimit, completed, num_queued;
 	bool all_prev_completed;
 
+	num_queued = ACCESS_ONCE(dql->num_queued);
+
 	/* Can't complete more than what's in queue */
-	BUG_ON(count > dql->num_queued - dql->num_completed);
+	BUG_ON(count > num_queued - dql->num_completed);
 
 	completed = dql->num_completed + count;
 	limit = dql->limit;
-	ovlimit = POSDIFF(dql->num_queued - dql->num_completed, limit);
-	inprogress = dql->num_queued - completed;
+	ovlimit = POSDIFF(num_queued - dql->num_completed, limit);
+	inprogress = num_queued - completed;
 	prev_inprogress = dql->prev_num_queued - dql->num_completed;
 	all_prev_completed = AFTER_EQ(completed, dql->prev_num_queued);
 
@@ -106,7 +108,7 @@ void dql_completed(struct dql *dql, unsi
 	dql->prev_ovlimit = ovlimit;
 	dql->prev_last_obj_cnt = dql->last_obj_cnt;
 	dql->num_completed = completed;
-	dql->prev_num_queued = dql->num_queued;
+	dql->prev_num_queued = num_queued;
 }
 EXPORT_SYMBOL(dql_completed);
 



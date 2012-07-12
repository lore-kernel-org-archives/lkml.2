Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759435Ab2GLXt7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:49:59 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40725 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930Ab2GLWga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:36:30 -0400
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
Subject: [ 017/187] bql: Avoid unneeded limit decrement.
Date: Thu, 12 Jul 2012 15:32:53 -0700
Message-Id: <20120712191523.849621112@linuxfoundation.org>
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

[ Upstream commit 25426b794efdc70dde7fd3134dc56fac3e7d562d ]

When below pattern is observed,

                                               TIME
       dql_queued()         dql_completed()     |
      a) initial state                          |
                                                |
      b) X bytes queued                         V

      c) Y bytes queued
                           d) X bytes completed
      e) Z bytes queued
                           f) Y bytes completed

a) dql->limit has already some value and there is no in-flight packet.
b) X bytes queued.
c) Y bytes queued and excess limit.
d) X bytes completed and dql->prev_ovlimit is set and also
   dql->prev_num_queued is set Y.
e) Z bytes queued.
f) Y bytes completed. inprogress and prev_inprogress are true.

At f), according to the comment, all_prev_completed becomes
true and limit should be increased. But POSDIFF() ignores
(completed == dql->prev_num_queued) case, so limit is decreased.

Signed-off-by: Hiroaki SHIMODA <shimoda.hiroaki@gmail.com>
Cc: Tom Herbert <therbert@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Denys Fedoryshchenko <denys@visp.net.lb>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/dynamic_queue_limits.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/lib/dynamic_queue_limits.c
+++ b/lib/dynamic_queue_limits.c
@@ -11,12 +11,14 @@
 #include <linux/dynamic_queue_limits.h>
 
 #define POSDIFF(A, B) ((int)((A) - (B)) > 0 ? (A) - (B) : 0)
+#define AFTER_EQ(A, B) ((int)((A) - (B)) >= 0)
 
 /* Records completed count and recalculates the queue limit */
 void dql_completed(struct dql *dql, unsigned int count)
 {
 	unsigned int inprogress, prev_inprogress, limit;
-	unsigned int ovlimit, all_prev_completed, completed;
+	unsigned int ovlimit, completed;
+	bool all_prev_completed;
 
 	/* Can't complete more than what's in queue */
 	BUG_ON(count > dql->num_queued - dql->num_completed);
@@ -26,7 +28,7 @@ void dql_completed(struct dql *dql, unsi
 	ovlimit = POSDIFF(dql->num_queued - dql->num_completed, limit);
 	inprogress = dql->num_queued - completed;
 	prev_inprogress = dql->prev_num_queued - dql->num_completed;
-	all_prev_completed = POSDIFF(completed, dql->prev_num_queued);
+	all_prev_completed = AFTER_EQ(completed, dql->prev_num_queued);
 
 	if ((ovlimit && !inprogress) ||
 	    (dql->prev_ovlimit && all_prev_completed)) {



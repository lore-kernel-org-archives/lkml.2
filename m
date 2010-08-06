Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965562Ab0HFV0O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 17:26:14 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:55264 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964823Ab0HFV0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 17:26:10 -0400
Date: Fri, 6 Aug 2010 14:26:07 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: herbert@gondor.hengli.com.au
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net,
        arnd@arndb.de
Subject: [PATCH] net: convert to rcu_dereference_index_check()
Message-ID: <20100806212607.GA9410@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Herbert!

At long last, the following is the final patch blocking acceptance
of Arnd's sparse annotations for RCU.  It was itself blocked behind
the definition of rcu_dereference_index_check(), which made it to
mainline only just today.

Would you be willing to ack this patch so that I can push it to -tip,
along with Arnd's work and a bunch of other stuff?

							Thanx, Paul

------------------------------------------------------------------------

commit 34ea15566530f8e4d0c1571cc8c3554fd91d5809
Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Date:   Mon Jun 14 17:06:21 2010 -0700

    net: convert to rcu_dereference_index_check()
    
    The task_cls_classid() function applies rcu_dereference() to integers,
    which does not work with the shiny new sparse-based checking in
    rcu_dereference().  This commit therefore moves to the new RCU API
    rcu_dereference_index_check().
    
    Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
    Reviewed-by: Josh Triplett <josh@joshtriplett.org>

 cls_cgroup.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/net/cls_cgroup.h b/include/net/cls_cgroup.h
index 726cc35..dd1fdb8 100644
--- a/include/net/cls_cgroup.h
+++ b/include/net/cls_cgroup.h
@@ -45,7 +45,8 @@ static inline u32 task_cls_classid(struct task_struct *p)
 		return 0;
 
 	rcu_read_lock();
-	id = rcu_dereference(net_cls_subsys_id);
+	id = rcu_dereference_index_check(net_cls_subsys_id,
+					 rcu_read_lock_held());
 	if (id >= 0)
 		classid = container_of(task_subsys_state(p, id),
 				       struct cgroup_cls_state, css)->classid;

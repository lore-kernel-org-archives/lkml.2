Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758388Ab0I1I1H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 04:27:07 -0400
Received: from mail.windriver.com ([147.11.1.11]:56032 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab0I1I1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 04:27:05 -0400
From: Dongdong Deng <dongdong.deng@windriver.com>
To: paulmck@linux.vnet.ibm.com, dipankar@in.ibm.com
Cc: linux-kernel@vger.kernel.org, dongdong.deng@windriver.com
Subject: [RFC PATCH] rcu: using ACCESS_ONCE() to observe the jiffies_stall/rnp->qsmask value
Date: Tue, 28 Sep 2010 16:32:43 +0800
Message-Id: <1285662763-16748-1-git-send-email-dongdong.deng@windriver.com>
X-Mailer: git-send-email 1.6.0.4
X-OriginalArrivalTime: 28 Sep 2010 08:26:40.0645 (UTC) FILETIME=[E028CB50:01CB5EE6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using ACCESS_ONCE() to observe the jiffies_stall/rnp->qsmask value
due to the caller didn't hold the root_rcu/rnp node's lock.

Signed-off-by: Dongdong Deng <dongdong.deng@windriver.com>
CC: Dipankar Sarma <dipankar@in.ibm.com>
CC: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index d5bc439..07a7063 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -532,9 +532,9 @@ static void check_cpu_stall(struct rcu_state *rsp, struct rcu_data *rdp)
 
 	if (rcu_cpu_stall_panicking)
 		return;
-	delta = jiffies - rsp->jiffies_stall;
+	delta = jiffies - ACCESS_ONCE(rsp->jiffies_stall);
 	rnp = rdp->mynode;
-	if ((rnp->qsmask & rdp->grpmask) && delta >= 0) {
+	if ((ACCESS_ONCE(rnp->qsmask) & rdp->grpmask) && delta >= 0) {
 
 		/* We haven't checked in, so go dump stack. */
 		print_cpu_stall(rsp);
-- 
1.6.0.4


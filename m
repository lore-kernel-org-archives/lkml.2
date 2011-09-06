Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601Ab1IGG0I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 02:26:08 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:46550 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755736Ab1IGGVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 02:21:01 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, Michal Hocko <mhocko@suse.cz>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 24/55] rcu: Not necessary to pass rcu_read_lock_held() to rcu_dereference_protected()
Date: Tue,  6 Sep 2011 11:00:18 -0700
Message-Id: <1315332049-2604-24-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110906180015.GA2560@linux.vnet.ibm.com>
References: <20110906180015.GA2560@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Hocko <mhocko@suse.cz>

Since ca5ecddf (rcu: define __rcu address space modifier for sparse)
rcu_dereference_check() use rcu_read_lock_held() as a part of condition
automatically.  Therefore, callers of rcu_dereference_check() no longer
need to pass rcu_read_lock_held() to rcu_dereference_check().

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/RCU/lockdep.txt |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/Documentation/RCU/lockdep.txt b/Documentation/RCU/lockdep.txt
index d7a49b2..4998c63 100644
--- a/Documentation/RCU/lockdep.txt
+++ b/Documentation/RCU/lockdep.txt
@@ -48,13 +48,11 @@ checking of rcu_dereference() primitives:
 		value of the pointer itself, for example, against NULL.
 
 The rcu_dereference_check() check expression can be any boolean
-expression, but would normally include one of the rcu_read_lock_held()
-family of functions and a lockdep expression.  However, any boolean
-expression can be used.  For a moderately ornate example, consider
-the following:
+expression, but would normally include a lockdep expression.  However,
+any boolean expression can be used.  For a moderately ornate example,
+consider the following:
 
 	file = rcu_dereference_check(fdt->fd[fd],
-				     rcu_read_lock_held() ||
 				     lockdep_is_held(&files->file_lock) ||
 				     atomic_read(&files->count) == 1);
 
@@ -62,7 +60,7 @@ This expression picks up the pointer "fdt->fd[fd]" in an RCU-safe manner,
 and, if CONFIG_PROVE_RCU is configured, verifies that this expression
 is used in:
 
-1.	An RCU read-side critical section, or
+1.	An RCU read-side critical section (implicit), or
 2.	with files->file_lock held, or
 3.	on an unshared files_struct.
 
-- 
1.7.3.2


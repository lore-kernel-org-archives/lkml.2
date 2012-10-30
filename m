Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757908Ab2J3QFp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 12:05:45 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:39513 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757369Ab2J3QFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 12:05:33 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        Kees Cook <keescook@chromium.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 3/4] RCU: Update docs to include kfree_rcu()
Date: Tue, 30 Oct 2012 09:04:35 -0700
Message-Id: <1351613076-22022-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1351613076-22022-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20121030160350.GA21837@linux.vnet.ibm.com>
 <1351613076-22022-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12103016-5518-0000-0000-000008D6839A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

Mention kfree_rcu() in the call_rcu() section.  Additionally fix the
example code for list replacement that used the wrong structure element.

Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/RCU/listRCU.txt   |    2 +-
 Documentation/RCU/whatisRCU.txt |   13 +++++++++++--
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/Documentation/RCU/listRCU.txt b/Documentation/RCU/listRCU.txt
index 4349c14..adb5a37 100644
--- a/Documentation/RCU/listRCU.txt
+++ b/Documentation/RCU/listRCU.txt
@@ -205,7 +205,7 @@ RCU ("read-copy update") its name.  The RCU code is as follows:
 				audit_copy_rule(&ne->rule, &e->rule);
 				ne->rule.action = newaction;
 				ne->rule.file_count = newfield_count;
-				list_replace_rcu(e, ne);
+				list_replace_rcu(&e->list, &ne->list);
 				call_rcu(&e->rcu, audit_free_rule);
 				return 0;
 			}
diff --git a/Documentation/RCU/whatisRCU.txt b/Documentation/RCU/whatisRCU.txt
index bf0f6de..160ac55 100644
--- a/Documentation/RCU/whatisRCU.txt
+++ b/Documentation/RCU/whatisRCU.txt
@@ -499,6 +499,8 @@ The foo_reclaim() function might appear as follows:
 	{
 		struct foo *fp = container_of(rp, struct foo, rcu);
 
+		foo_cleanup(fp->a);
+
 		kfree(fp);
 	}
 
@@ -521,6 +523,12 @@ o	Use call_rcu() -after- removing a data element from an
 	read-side critical sections that might be referencing that
 	data item.
 
+If the callback for call_rcu() is not doing anything more than calling
+kfree() on the structure, you can use kfree_rcu() instead of call_rcu()
+to avoid having to write your own callback:
+
+	kfree_rcu(old_fp, rcu);
+
 Again, see checklist.txt for additional rules governing the use of RCU.
 
 
@@ -773,8 +781,8 @@ a single atomic update, converting to RCU will require special care.
 
 Also, the presence of synchronize_rcu() means that the RCU version of
 delete() can now block.  If this is a problem, there is a callback-based
-mechanism that never blocks, namely call_rcu(), that can be used in
-place of synchronize_rcu().
+mechanism that never blocks, namely call_rcu() or kfree_rcu(), that can
+be used in place of synchronize_rcu().
 
 
 7.  FULL LIST OF RCU APIs
@@ -813,6 +821,7 @@ RCU:	Critical sections	Grace period		Barrier
 	rcu_read_unlock		synchronize_rcu
 	rcu_dereference		synchronize_rcu_expedited
 				call_rcu
+				kfree_rcu
 
 
 bh:	Critical sections	Grace period		Barrier
-- 
1.7.8


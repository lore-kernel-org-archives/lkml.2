Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759509Ab2JSQsm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 12:48:42 -0400
Received: from smtp.outflux.net ([198.145.64.163]:49496 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759114Ab2JSQsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 12:48:40 -0400
Date: Fri, 19 Oct 2012 09:48:30 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org
Subject: [PATCH] RCU: update docs to include kfree_rcu()
Message-ID: <20121019164830.GA4896@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mention kfree_rcu() in the call_rcu() section. Additionally fix the
example code for list replacement that used the wrong structure element.

Signed-off-by: Kees Cook <keescook@chromium.org>
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
1.7.9.5


-- 
Kees Cook
Chrome OS Security

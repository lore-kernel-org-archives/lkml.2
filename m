Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab0DZJ6h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 05:58:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7352 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753214Ab0DZJ6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 05:58:35 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] From: Serge E. Hallyn <serue@us.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: dhowells@redhat.com, serue@us.ibm.com, paulmck@us.ibm.com,
       linux-kernel@vger.kernel.org
Date: Mon, 26 Apr 2010 10:58:30 +0100
Message-ID: <20100426095830.25501.47002.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CRED: Holding a spinlock does not imply the holding of RCU read lock

Change the credentials documentation to make it clear that the RCU read lock
must be explicitly held when accessing credentials pointers in some other task
than current.  Holding a spinlock does not implicitly hold the RCU read lock.

Signed-off-by: Serge Hallyn <serue@us.ibm.com>
Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/credentials.txt |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/Documentation/credentials.txt b/Documentation/credentials.txt
index df03169..a2db352 100644
--- a/Documentation/credentials.txt
+++ b/Documentation/credentials.txt
@@ -408,9 +408,6 @@ This should be used inside the RCU read lock, as in the following example:
 		...
 	}
 
-A function need not get RCU read lock to use __task_cred() if it is holding a
-spinlock at the time as this implicitly holds the RCU read lock.
-
 Should it be necessary to hold another task's credentials for a long period of
 time, and possibly to sleep whilst doing so, then the caller should get a
 reference on them using:
@@ -426,17 +423,16 @@ credentials, hiding the RCU magic from the caller:
 	uid_t task_uid(task)		Task's real UID
 	uid_t task_euid(task)		Task's effective UID
 
-If the caller is holding a spinlock or the RCU read lock at the time anyway,
-then:
+If the caller is holding the RCU read lock at the time anyway, then:
 
 	__task_cred(task)->uid
 	__task_cred(task)->euid
 
 should be used instead.  Similarly, if multiple aspects of a task's credentials
-need to be accessed, RCU read lock or a spinlock should be used, __task_cred()
-called, the result stored in a temporary pointer and then the credential
-aspects called from that before dropping the lock.  This prevents the
-potentially expensive RCU magic from being invoked multiple times.
+need to be accessed, RCU read lock should be used, __task_cred() called, the
+result stored in a temporary pointer and then the credential aspects called
+from that before dropping the lock.  This prevents the potentially expensive
+RCU magic from being invoked multiple times.
 
 Should some other single aspect of another task's credentials need to be
 accessed, then this can be used:


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab1HHOzD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 10:55:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64531 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752731Ab1HHOzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 10:55:00 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] CRED: Restore const to current_cred()
To: torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Date: Mon, 08 Aug 2011 15:54:53 +0100
Message-ID: <20110808145453.16760.45460.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 3295514841c2112d94451ba5deaf54f5afb78ea9 accidentally dropped the const
of current->cred inside current_cred() by the insertion of a cast to deal with
an RCU annotation loss warning from sparce.

Use an appropriate RCU wrapper instead so as not to lose the const.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
cc: Al Viro <viro@zeniv.linux.org.uk>
---

 include/linux/cred.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/cred.h b/include/linux/cred.h
index 98f46ef..8e2fd44 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -269,7 +269,7 @@ static inline void put_cred(const struct cred *_cred)
  * since nobody else can modify it.
  */
 #define current_cred() \
-	(*(__force struct cred **)&current->cred)
+	rcu_dereference_protected(current->cred, 1)
 
 /**
  * __task_cred - Access a task's objective credentials


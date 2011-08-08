Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662Ab1HHMys (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 08:54:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63317 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752870Ab1HHMyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 08:54:47 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20110808123442.GF2385@linux.vnet.ibm.com>
References: <20110808123442.GF2385@linux.vnet.ibm.com> <20110807175511.GZ2203@ZenIV.linux.org.uk> <13248.1312791509@redhat.com>
To: paulmck@linux.vnet.ibm.com
Cc: dhowells@redhat.com, Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: fix rcu annotations noise in cred.h
Date: Mon, 08 Aug 2011 13:54:08 +0100
Message-ID: <13642.1312808048@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> This is indeed what rcu_dereference_protected() is intended for.

How about the attached patch?

David
---
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] CRED: Restore const to current_cred()

Commit 3295514841c2112d94451ba5deaf54f5afb78ea9 accidentally dropped the const
of current->cred inside current_cred() by the insertion of a cast to deal with
an RCU annotation loss warning from sparce.

Use an appropriate RCU wrapper instead so as not to lose the const.

Signed-off-by: David Howells <dhowells@redhat.com>
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

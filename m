Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375Ab0C2OFl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 10:05:41 -0400
Received: from mail.openrapids.net ([64.15.138.104]:60799 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752017Ab0C2OFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 10:05:40 -0400
Date: Mon, 29 Mar 2010 10:05:39 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] cred fix error handling
Message-ID: <20100329140539.GB24478@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 10:04:21 up 65 days, 16:41,  7 users,  load average: 0.08, 0.04,
	0.05
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Causes memory leak on OO mem condition.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: David Howells <dhowells@redhat.com>
---
 kernel/cred.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: linux.trees.git/kernel/cred.c
===================================================================
--- linux.trees.git.orig/kernel/cred.c	2010-03-29 09:40:53.000000000 -0400
+++ linux.trees.git/kernel/cred.c	2010-03-29 10:03:15.000000000 -0400
@@ -364,7 +364,7 @@ struct cred *prepare_usermodehelper_cred
 
 	new = kmem_cache_alloc(cred_jar, GFP_ATOMIC);
 	if (!new)
-		return NULL;
+		goto free_tgcred;
 
 	kdebug("prepare_usermodehelper_creds() alloc %p", new);
 
@@ -397,6 +397,10 @@ struct cred *prepare_usermodehelper_cred
 
 error:
 	put_cred(new);
+free_tgcred:
+#ifdef CONFIG_KEYS
+	kfree(tgcred);
+#endif
 	return NULL;
 }
 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab0C2XEJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 19:04:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014Ab0C2XEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 19:04:07 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] CRED: Fix memory leak in error handling
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       David Howells <dhowells@redhat.com>
Date: Tue, 30 Mar 2010 00:04:00 +0100
Message-ID: <20100329230400.26988.15372.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

Fix a memory leak on an OOM condition in prepare_usermodehelper_creds().

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 kernel/cred.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/kernel/cred.c b/kernel/cred.c
index 1ed8ca1..1b1129d 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -364,7 +364,7 @@ struct cred *prepare_usermodehelper_creds(void)
 
 	new = kmem_cache_alloc(cred_jar, GFP_ATOMIC);
 	if (!new)
-		return NULL;
+		goto free_tgcred;
 
 	kdebug("prepare_usermodehelper_creds() alloc %p", new);
 
@@ -397,6 +397,10 @@ struct cred *prepare_usermodehelper_creds(void)
 
 error:
 	put_cred(new);
+free_tgcred:
+#ifdef CONFIG_KEYS
+	kfree(tgcred);
+#endif
 	return NULL;
 }
 


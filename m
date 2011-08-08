Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120Ab1HHPKw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 11:10:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23136 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751692Ab1HHPKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 11:10:51 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] autofs4: Use no_printk() for no-op DPRINTK() and use
 __VA_ARGS__ too
To: torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org, autofs@linux.kernel.org,
        David Howells <dhowells@redhat.com>, Ian Kent <raven@themaw.net>
Date: Mon, 08 Aug 2011 16:10:38 +0100
Message-ID: <20110808151038.17366.38130.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use no_printk() for autofs's no-op DPRINTK() to prevent unused statements from
becoming accidentally obsolete, and use __VA_ARGS__ too as that's the standard
way.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Ian Kent <raven@themaw.net>
---

 fs/autofs4/autofs_i.h |   10 +++++++---
 fs/autofs4/waitq.c    |    3 ++-
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/autofs4/autofs_i.h b/fs/autofs4/autofs_i.h
index 475f9c5..c3a419f 100644
--- a/fs/autofs4/autofs_i.h
+++ b/fs/autofs4/autofs_i.h
@@ -40,13 +40,17 @@
 /* #define DEBUG */
 
 #ifdef DEBUG
-#define DPRINTK(fmt, args...)				\
+#define DPRINTK(fmt, ...)				\
 do {							\
 	printk(KERN_DEBUG "pid %d: %s: " fmt "\n",	\
-		current->pid, __func__, ##args);	\
+		current->pid, __func__, ##__VA_ARGS__);	\
 } while (0)
 #else
-#define DPRINTK(fmt, args...) do {} while (0)
+#define DPRINTK(fmt, ...)					\
+do {								\
+	no_printk(KERN_DEBUG "pid %d: %s: " fmt "\n",		\
+		  current->pid, __func__, ##__VA_ARGS__);	\
+} while (0)
 #endif
 
 #define AUTOFS_WARN(fmt, args...)			\
diff --git a/fs/autofs4/waitq.c b/fs/autofs4/waitq.c
index 2543598..6313a0d 100644
--- a/fs/autofs4/waitq.c
+++ b/fs/autofs4/waitq.c
@@ -104,7 +104,8 @@ static void autofs4_notify_daemon(struct autofs_sb_info *sbi,
 	size_t pktsz;
 
 	DPRINTK("wait id = 0x%08lx, name = %.*s, type=%d",
-		wq->wait_queue_token, wq->name.len, wq->name.name, type);
+		(unsigned long)wq->wait_queue_token,
+		wq->name.len, wq->name.name, type);
 
 	memset(&pkt,0,sizeof pkt); /* For security reasons */
 


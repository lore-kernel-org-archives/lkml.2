Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176Ab1CCQ6L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 11:58:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35131 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887Ab1CCQ6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 11:58:10 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 3/3] autofs4: Use no_printk() for no-op DPRINTK() and use
 __VA_ARGS__ too
To: viro@ZenIV.linux.org.uk, hch@infradead.org, raven@themaw.net
Cc: linux-devel@vger.kernel.org, autofs@linux.kernel.org,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Thu, 03 Mar 2011 16:58:00 +0000
Message-ID: <20110303165800.9550.43625.stgit@warthog.procyon.org.uk>
In-Reply-To: <20110303165738.9550.2251.stgit@warthog.procyon.org.uk>
References: <20110303165738.9550.2251.stgit@warthog.procyon.org.uk>
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
---

 fs/autofs4/autofs_i.h |   10 +++++++---
 fs/autofs4/waitq.c    |    3 ++-
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/autofs4/autofs_i.h b/fs/autofs4/autofs_i.h
index 54f9237..ef89828 100644
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
index 5601005..4d169cf 100644
--- a/fs/autofs4/waitq.c
+++ b/fs/autofs4/waitq.c
@@ -104,7 +104,8 @@ static void autofs4_notify_daemon(struct autofs_sb_info *sbi,
 	size_t pktsz;
 
 	DPRINTK("wait id = 0x%08lx, name = %.*s, type=%d",
-		wq->wait_queue_token, wq->name.len, wq->name.name, type);
+		(unsigned long)wq->wait_queue_token,
+		wq->name.len, wq->name.name, type);
 
 	memset(&pkt,0,sizeof pkt); /* For security reasons */
 


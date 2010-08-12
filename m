Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933956Ab0HLPzz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 11:55:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19133 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933864Ab0HLPz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 11:55:29 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 5/6] Add a dummy printk function for the maintenance of unused
	printks
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Date: Thu, 12 Aug 2010 16:54:57 +0100
Message-ID: <20100812155457.17015.6315.stgit@warthog.procyon.org.uk>
In-Reply-To: <20100812155436.17015.78424.stgit@warthog.procyon.org.uk>
References: <20100812155436.17015.78424.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a dummy printk function for the maintenance of unused printks through gcc
format checking, and also so that side-effect checking is maintained too.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/kernel/mn10300-serial.c |    5 -----
 fs/afs/internal.h                    |   12 +++---------
 fs/cachefiles/internal.h             |   13 +++----------
 fs/fscache/internal.h                |   14 ++++----------
 include/linux/kernel.h               |    7 +++++++
 kernel/cred.c                        |    4 ----
 net/rxrpc/ar-internal.h              |   16 +++++-----------
 security/keys/internal.h             |    5 -----
 8 files changed, 22 insertions(+), 54 deletions(-)


diff --git a/arch/mn10300/kernel/mn10300-serial.c b/arch/mn10300/kernel/mn10300-serial.c
index ef34d5a..9d49073 100644
--- a/arch/mn10300/kernel/mn10300-serial.c
+++ b/arch/mn10300/kernel/mn10300-serial.c
@@ -44,11 +44,6 @@ static const char serial_revdate[] = "2007-11-06";
 #include <unit/timex.h>
 #include "mn10300-serial.h"
 
-static inline __attribute__((format(printf, 1, 2)))
-void no_printk(const char *fmt, ...)
-{
-}
-
 #define kenter(FMT, ...) \
 	printk(KERN_DEBUG "-->%s(" FMT ")\n", __func__, ##__VA_ARGS__)
 #define _enter(FMT, ...) \
diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index 8679089..c6c93f1 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -752,12 +752,6 @@ extern unsigned afs_debug;
 #define dbgprintk(FMT,...) \
 	printk("[%-6.6s] "FMT"\n", current->comm ,##__VA_ARGS__)
 
-/* make sure we maintain the format strings, even when debugging is disabled */
-static inline __attribute__((format(printf,1,2)))
-void _dbprintk(const char *fmt, ...)
-{
-}
-
 #define kenter(FMT,...)	dbgprintk("==> %s("FMT")",__func__ ,##__VA_ARGS__)
 #define kleave(FMT,...)	dbgprintk("<== %s()"FMT"",__func__ ,##__VA_ARGS__)
 #define kdebug(FMT,...)	dbgprintk("    "FMT ,##__VA_ARGS__)
@@ -792,9 +786,9 @@ do {							\
 } while (0)
 
 #else
-#define _enter(FMT,...)	_dbprintk("==> %s("FMT")",__func__ ,##__VA_ARGS__)
-#define _leave(FMT,...)	_dbprintk("<== %s()"FMT"",__func__ ,##__VA_ARGS__)
-#define _debug(FMT,...)	_dbprintk("    "FMT ,##__VA_ARGS__)
+#define _enter(FMT,...)	no_printk("==> %s("FMT")",__func__ ,##__VA_ARGS__)
+#define _leave(FMT,...)	no_printk("<== %s()"FMT"",__func__ ,##__VA_ARGS__)
+#define _debug(FMT,...)	no_printk("    "FMT ,##__VA_ARGS__)
 #endif
 
 /*
diff --git a/fs/cachefiles/internal.h b/fs/cachefiles/internal.h
index a8cd821..bd6bc1b 100644
--- a/fs/cachefiles/internal.h
+++ b/fs/cachefiles/internal.h
@@ -267,13 +267,6 @@ do {									\
 #define dbgprintk(FMT, ...) \
 	printk(KERN_DEBUG "[%-6.6s] "FMT"\n", current->comm, ##__VA_ARGS__)
 
-/* make sure we maintain the format strings, even when debugging is disabled */
-static inline void _dbprintk(const char *fmt, ...)
-	__attribute__((format(printf, 1, 2)));
-static inline void _dbprintk(const char *fmt, ...)
-{
-}
-
 #define kenter(FMT, ...) dbgprintk("==> %s("FMT")", __func__, ##__VA_ARGS__)
 #define kleave(FMT, ...) dbgprintk("<== %s()"FMT"", __func__, ##__VA_ARGS__)
 #define kdebug(FMT, ...) dbgprintk(FMT, ##__VA_ARGS__)
@@ -304,9 +297,9 @@ do {							\
 } while (0)
 
 #else
-#define _enter(FMT, ...) _dbprintk("==> %s("FMT")", __func__, ##__VA_ARGS__)
-#define _leave(FMT, ...) _dbprintk("<== %s()"FMT"", __func__, ##__VA_ARGS__)
-#define _debug(FMT, ...) _dbprintk(FMT, ##__VA_ARGS__)
+#define _enter(FMT, ...) no_printk("==> %s("FMT")", __func__, ##__VA_ARGS__)
+#define _leave(FMT, ...) no_printk("<== %s()"FMT"", __func__, ##__VA_ARGS__)
+#define _debug(FMT, ...) no_printk(FMT, ##__VA_ARGS__)
 #endif
 
 #if 1 /* defined(__KDEBUGALL) */
diff --git a/fs/fscache/internal.h b/fs/fscache/internal.h
index 6a02644..f6aad48 100644
--- a/fs/fscache/internal.h
+++ b/fs/fscache/internal.h
@@ -321,17 +321,11 @@ void fscache_put_context(struct fscache_cookie *cookie, void *context)
 #define dbgprintk(FMT, ...) \
 	printk(KERN_DEBUG "[%-6.6s] "FMT"\n", current->comm, ##__VA_ARGS__)
 
-/* make sure we maintain the format strings, even when debugging is disabled */
-static inline __attribute__((format(printf, 1, 2)))
-void _dbprintk(const char *fmt, ...)
-{
-}
-
 #define kenter(FMT, ...) dbgprintk("==> %s("FMT")", __func__, ##__VA_ARGS__)
 #define kleave(FMT, ...) dbgprintk("<== %s()"FMT"", __func__, ##__VA_ARGS__)
 #define kdebug(FMT, ...) dbgprintk(FMT, ##__VA_ARGS__)
 
-#define kjournal(FMT, ...) _dbprintk(FMT, ##__VA_ARGS__)
+#define kjournal(FMT, ...) no_printk(FMT, ##__VA_ARGS__)
 
 #ifdef __KDEBUG
 #define _enter(FMT, ...) kenter(FMT, ##__VA_ARGS__)
@@ -358,9 +352,9 @@ do {						\
 } while (0)
 
 #else
-#define _enter(FMT, ...) _dbprintk("==> %s("FMT")", __func__, ##__VA_ARGS__)
-#define _leave(FMT, ...) _dbprintk("<== %s()"FMT"", __func__, ##__VA_ARGS__)
-#define _debug(FMT, ...) _dbprintk(FMT, ##__VA_ARGS__)
+#define _enter(FMT, ...) no_printk("==> %s("FMT")", __func__, ##__VA_ARGS__)
+#define _leave(FMT, ...) no_printk("<== %s()"FMT"", __func__, ##__VA_ARGS__)
+#define _debug(FMT, ...) no_printk(FMT, ##__VA_ARGS__)
 #endif
 
 /*
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index d848cb8..2b0a35e 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -306,6 +306,13 @@ static inline void log_buf_kexec_setup(void)
 }
 #endif
 
+/*
+ * Dummy printk for disabled debugging statements to use whilst maintaining
+ * gcc's format and side-effect checking.
+ */
+static inline __attribute__ ((format (printf, 1, 2)))
+int no_printk(const char *s, ...) { return 0; }
+
 extern int printk_needs_cpu(int cpu);
 extern void printk_tick(void);
 
diff --git a/kernel/cred.c b/kernel/cred.c
index 60bc8b1..9a3e226 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -22,10 +22,6 @@
 #define kdebug(FMT, ...) \
 	printk("[%-5.5s%5u] "FMT"\n", current->comm, current->pid ,##__VA_ARGS__)
 #else
-static inline __attribute__((format(printf, 1, 2)))
-void no_printk(const char *fmt, ...)
-{
-}
 #define kdebug(FMT, ...) \
 	no_printk("[%-5.5s%5u] "FMT"\n", current->comm, current->pid ,##__VA_ARGS__)
 #endif
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 7043b29..8e22bd3 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -597,12 +597,6 @@ extern unsigned rxrpc_debug;
 #define dbgprintk(FMT,...) \
 	printk("[%-6.6s] "FMT"\n", current->comm ,##__VA_ARGS__)
 
-/* make sure we maintain the format strings, even when debugging is disabled */
-static inline __attribute__((format(printf,1,2)))
-void _dbprintk(const char *fmt, ...)
-{
-}
-
 #define kenter(FMT,...)	dbgprintk("==> %s("FMT")",__func__ ,##__VA_ARGS__)
 #define kleave(FMT,...)	dbgprintk("<== %s()"FMT"",__func__ ,##__VA_ARGS__)
 #define kdebug(FMT,...)	dbgprintk("    "FMT ,##__VA_ARGS__)
@@ -655,11 +649,11 @@ do {							\
 } while (0)
 
 #else
-#define _enter(FMT,...)	_dbprintk("==> %s("FMT")",__func__ ,##__VA_ARGS__)
-#define _leave(FMT,...)	_dbprintk("<== %s()"FMT"",__func__ ,##__VA_ARGS__)
-#define _debug(FMT,...)	_dbprintk("    "FMT ,##__VA_ARGS__)
-#define _proto(FMT,...)	_dbprintk("### "FMT ,##__VA_ARGS__)
-#define _net(FMT,...)	_dbprintk("@@@ "FMT ,##__VA_ARGS__)
+#define _enter(FMT,...)	no_printk("==> %s("FMT")",__func__ ,##__VA_ARGS__)
+#define _leave(FMT,...)	no_printk("<== %s()"FMT"",__func__ ,##__VA_ARGS__)
+#define _debug(FMT,...)	no_printk("    "FMT ,##__VA_ARGS__)
+#define _proto(FMT,...)	no_printk("### "FMT ,##__VA_ARGS__)
+#define _net(FMT,...)	no_printk("@@@ "FMT ,##__VA_ARGS__)
 #endif
 
 /*
diff --git a/security/keys/internal.h b/security/keys/internal.h
index addb67b..56a133d 100644
--- a/security/keys/internal.h
+++ b/security/keys/internal.h
@@ -15,11 +15,6 @@
 #include <linux/sched.h>
 #include <linux/key-type.h>
 
-static inline __attribute__((format(printf, 1, 2)))
-void no_printk(const char *fmt, ...)
-{
-}
-
 #ifdef __KDEBUG
 #define kenter(FMT, ...) \
 	printk(KERN_DEBUG "==> %s("FMT")\n", __func__, ##__VA_ARGS__)


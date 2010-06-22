Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649Ab0FVPnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 11:43:50 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:55866 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab0FVPnt (ORCPT
	<rfc822;groupwise-SJayaraman@novell.com:0:0>);
	Tue, 22 Jun 2010 11:43:49 -0400
From: Suresh Jayaraman <sjayaraman@suse.de>
To: Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: [RFC][PATCH 03/10] cifs: register CIFS for caching
Date: Tue, 22 Jun 2010 20:53:09 +0530
Message-Id: <1277220189-3485-1-git-send-email-sjayaraman@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <yes>
References: <yes>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define CIFS for FS-Cache and register for caching. Upon registration the
top-level index object cookie will be stuck to the netfs definition by
FS-Cache.

Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>
---
 fs/cifs/Makefile  |    2 ++
 fs/cifs/cache.c   |   53 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/cifsfs.c  |    8 ++++++++
 fs/cifs/fscache.h |   40 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 103 insertions(+), 0 deletions(-)
 create mode 100644 fs/cifs/cache.c
 create mode 100644 fs/cifs/fscache.h

diff --git a/fs/cifs/Makefile b/fs/cifs/Makefile
index 9948c00..e2de709 100644
--- a/fs/cifs/Makefile
+++ b/fs/cifs/Makefile
@@ -11,3 +11,5 @@ cifs-y := cifsfs.o cifssmb.o cifs_debug.o connect.o dir.o file.o inode.o \
 cifs-$(CONFIG_CIFS_UPCALL) += cifs_spnego.o
 
 cifs-$(CONFIG_CIFS_DFS_UPCALL) += dns_resolve.o cifs_dfs_ref.o
+
+cifs-$(CONFIG_CIFS_FSCACHE) += cache.o
diff --git a/fs/cifs/cache.c b/fs/cifs/cache.c
new file mode 100644
index 0000000..1080b96
--- /dev/null
+++ b/fs/cifs/cache.c
@@ -0,0 +1,53 @@
+/*
+ *   fs/cifs/cache.c - CIFS filesystem cache index structure definitions
+ *
+ *   Copyright (c) 2010 Novell, Inc.
+ *   Authors(s): Suresh Jayaraman (sjayaraman@suse.de>
+ *
+ *   This library is free software; you can redistribute it and/or modify
+ *   it under the terms of the GNU Lesser General Public License as published
+ *   by the Free Software Foundation; either version 2.1 of the License, or
+ *   (at your option) any later version.
+ *
+ *   This library is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
+ *   the GNU Lesser General Public License for more details.
+ *
+ *   You should have received a copy of the GNU Lesser General Public License
+ *   along with this library; if not, write to the Free Software
+ *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/mm.h>
+
+#include "fscache.h"
+#include "cifsglob.h"
+#include "cifs_debug.h"
+
+/*
+ * CIFS filesystem definition for FS-Cache
+ */
+struct fscache_netfs cifs_fscache_netfs = {
+	.name = "cifs",
+	.version = 0,
+};
+
+/*
+ * Register CIFS for caching with FS-Cache
+ */
+int cifs_fscache_register(void)
+{
+	return fscache_register_netfs(&cifs_fscache_netfs);
+}
+
+/*
+ * Unregister CIFS for caching
+ */
+void cifs_fscache_unregister(void)
+{
+	fscache_unregister_netfs(&cifs_fscache_netfs);
+}
+
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 484e52b..c2a7aa9 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -47,6 +47,7 @@
 #include <linux/key-type.h>
 #include "dns_resolve.h"
 #include "cifs_spnego.h"
+#include "fscache.h"
 #define CIFS_MAGIC_NUMBER 0xFF534D42	/* the first four bytes of SMB PDUs */
 
 int cifsFYI = 0;
@@ -902,6 +903,10 @@ init_cifs(void)
 		cFYI(1, "cifs_max_pending set to max of 256");
 	}
 
+	rc = cifs_fscache_register();
+	if (rc)
+		goto out;
+
 	rc = cifs_init_inodecache();
 	if (rc)
 		goto out_clean_proc;
@@ -949,8 +954,10 @@ init_cifs(void)
 	cifs_destroy_mids();
  out_destroy_inodecache:
 	cifs_destroy_inodecache();
+	cifs_fscache_unregister();
  out_clean_proc:
 	cifs_proc_clean();
+ out:
 	return rc;
 }
 
@@ -959,6 +966,7 @@ exit_cifs(void)
 {
 	cFYI(DBG2, "exit_cifs");
 	cifs_proc_clean();
+	cifs_fscache_unregister();
 #ifdef CONFIG_CIFS_DFS_UPCALL
 	cifs_dfs_release_automount_timer();
 	unregister_key_type(&key_type_dns_resolver);
diff --git a/fs/cifs/fscache.h b/fs/cifs/fscache.h
new file mode 100644
index 0000000..cec9e2b
--- /dev/null
+++ b/fs/cifs/fscache.h
@@ -0,0 +1,40 @@
+/*
+ *   fs/cifs/fscache.h - CIFS filesystem cache interface definitions
+ *
+ *   Copyright (c) 2010 Novell, Inc.
+ *   Authors(s): Suresh Jayaraman (sjayaraman@suse.de>
+ *
+ *   This library is free software; you can redistribute it and/or modify
+ *   it under the terms of the GNU Lesser General Public License as published
+ *   by the Free Software Foundation; either version 2.1 of the License, or
+ *   (at your option) any later version.
+ *
+ *   This library is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
+ *   the GNU Lesser General Public License for more details.
+ *
+ *   You should have received a copy of the GNU Lesser General Public License
+ *   along with this library; if not, write to the Free Software
+ *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+#ifndef _CIFS_FSCACHE_H
+#define _CIFS_FSCACHE_H
+
+#include <linux/fscache.h>
+#include "cifsglob.h"
+
+#ifdef CONFIG_CIFS_FSCACHE
+
+extern struct fscache_netfs cifs_fscache_netfs;
+
+extern int cifs_fscache_register(void);
+extern void cifs_fscache_unregister(void);
+
+#else /* CONFIG_CIFS_FSCACHE */
+static inline int cifs_fscache_register(void) { return 0; }
+static inline void cifs_fscache_unregister(void) {}
+
+#endif /* CONFIG_CIFS_FSCACHE */
+
+#endif /* _CIFS_FSCACHE_H */
-- 
1.6.4.2


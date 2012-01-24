Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932388Ab2AXDGO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 22:06:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50203 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932182Ab2AXCoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:44:55 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:28 2012
Message-Id: <20120124023928.872275189@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:34:36 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: [056/129] UBIFS: make debugging messages light again
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 1965
Lines: 51

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

commit 1f5d78dc4823a85f112aaa2d0f17624f8c2a6c52 upstream.

We switch to dynamic debugging in commit
56e46742e846e4de167dde0e1e1071ace1c882a5 but did not take into account that
now we do not control anymore whether a specific message is enabled or not.
So now we lock the "dbg_lock" and release it in every debugging macro, which
make them not so light-weight.

This commit removes the "dbg_lock" protection from the debugging macros to
fix the issue.

The downside is that now our DBGKEY() stuff is broken, but this is not
critical at all and will be fixed later.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ubifs/debug.h |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/fs/ubifs/debug.h
+++ b/fs/ubifs/debug.h
@@ -175,19 +175,17 @@ const char *dbg_key_str1(const struct ub
 			 const union ubifs_key *key);
 
 /*
- * DBGKEY macros require @dbg_lock to be held, which it is in the dbg message
- * macros.
+ * TODO: these macros are now broken because there is no locking around them
+ * and we use a global buffer for the key string. This means that in case of
+ * concurrent execution we will end up with incorrect and messy key strings.
  */
 #define DBGKEY(key) dbg_key_str0(c, (key))
 #define DBGKEY1(key) dbg_key_str1(c, (key))
 
 extern spinlock_t dbg_lock;
 
-#define ubifs_dbg_msg(type, fmt, ...) do {                        \
-	spin_lock(&dbg_lock);                                     \
-	pr_debug("UBIFS DBG " type ": " fmt "\n", ##__VA_ARGS__); \
-	spin_unlock(&dbg_lock);                                   \
-} while (0)
+#define ubifs_dbg_msg(type, fmt, ...) \
+	pr_debug("UBIFS DBG " type ": " fmt "\n", ##__VA_ARGS__)
 
 /* Just a debugging messages not related to any specific UBIFS subsystem */
 #define dbg_msg(fmt, ...)                                                     \



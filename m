Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635Ab1KQSmX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 13:42:23 -0500
Received: from smtp.outflux.net ([198.145.64.163]:57146 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753862Ab1KQSmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 13:42:22 -0500
Date: Thu, 17 Nov 2011 10:42:00 -0800
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Tony Luck <tony.luck@intel.com>, Matthew Garrett <mjg@redhat.com>,
        Chen Gong <gong.chen@linux.intel.com>, Don Zickus <dzickus@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] pstore: gracefully handle NULL pstore_info functions
Message-ID: <20111117184200.GA5037@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a pstore backend doesn't want to support various portions of the
pstore interface, it can just leave those functions NULL instead of
creating no-op stubs.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/pstore/inode.c    |    3 ++-
 fs/pstore/platform.c |   11 ++++++-----
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index 379a02d..b3b426e 100644
--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -80,7 +80,8 @@ static int pstore_unlink(struct inode *dir, struct dentry *dentry)
 {
 	struct pstore_private *p = dentry->d_inode->i_private;
 
-	p->psi->erase(p->type, p->id, p->psi);
+	if (p->psi->erase)
+		p->psi->erase(p->type, p->id, p->psi);
 
 	return simple_unlink(dir, dentry);
 }
diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index f146d89..e12dfd7 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -178,7 +178,8 @@ int pstore_register(struct pstore_info *psi)
 	if (pstore_is_mounted())
 		pstore_get_records(0);
 
-	kmsg_dump_register(&pstore_dumper);
+	if (psi->write && psi->buf && psi->bufsize)
+		kmsg_dump_register(&pstore_dumper);
 
 	pstore_timer.expires = jiffies + PSTORE_INTERVAL;
 	add_timer(&pstore_timer);
@@ -203,12 +204,11 @@ void pstore_get_records(int quiet)
 	struct timespec		time;
 	int			failed = 0, rc;
 
-	if (!psi)
+	if (!psi || !psi->read)
 		return;
 
 	mutex_lock(&psi->read_mutex);
-	rc = psi->open(psi);
-	if (rc)
+	if (psi->open && psi->open(psi))
 		goto out;
 
 	while ((size = psi->read(&id, &type, &time, &buf, psi)) > 0) {
@@ -219,7 +219,8 @@ void pstore_get_records(int quiet)
 		if (rc && (rc != -EEXIST || !quiet))
 			failed++;
 	}
-	psi->close(psi);
+	if (psi->close)
+		psi->close(psi);
 out:
 	mutex_unlock(&psi->read_mutex);
 
-- 
1.7.0.4


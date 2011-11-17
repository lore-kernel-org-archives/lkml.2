Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023Ab1KQTlD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 14:41:03 -0500
Received: from smtp.outflux.net ([198.145.64.163]:37113 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755589Ab1KQTlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 14:41:01 -0500
Date: Thu, 17 Nov 2011 11:40:42 -0800
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Tony Luck <tony.luck@intel.com>, Matthew Garrett <mjg@redhat.com>,
        Chen Gong <gong.chen@linux.intel.com>, Don Zickus <dzickus@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2] pstore: gracefully handle NULL pstore_info functions
Message-ID: <20111117194042.GA25918@www.outflux.net>
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
 fs/pstore/platform.c |    8 ++++----
 2 files changed, 6 insertions(+), 5 deletions(-)

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
index f146d89..c970a66 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -203,12 +203,11 @@ void pstore_get_records(int quiet)
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
@@ -219,7 +218,8 @@ void pstore_get_records(int quiet)
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


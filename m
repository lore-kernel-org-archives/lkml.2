Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab2JNPLg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 11:11:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46213 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754360Ab2JNOmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:42:11 -0400
Message-Id: <20121014143550.683637434@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:37:38 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tyler Hicks <tyhicks@canonical.com>
Subject: [ 125/147] eCryptfs: Call lower ->flush() from ecryptfs_flush()
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tyler Hicks <tyhicks@canonical.com>

commit 64e6651dcc10e9d2cc6230208a8e6c2cfd19ae18 upstream.

Since eCryptfs only calls fput() on the lower file in
ecryptfs_release(), eCryptfs should call the lower filesystem's
->flush() from ecryptfs_flush().

If the lower filesystem implements ->flush(), then eCryptfs should try
to flush out any dirty pages prior to calling the lower ->flush(). If
the lower filesystem does not implement ->flush(), then eCryptfs has no
need to do anything in ecryptfs_flush() since dirty pages are now
written out to the lower filesystem in ecryptfs_release().

Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ecryptfs/file.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
index 44ce5c6..d45ba45 100644
--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -275,8 +275,14 @@ out:
 
 static int ecryptfs_flush(struct file *file, fl_owner_t td)
 {
-	return file->f_mode & FMODE_WRITE
-	       ? filemap_write_and_wait(file->f_mapping) : 0;
+	struct file *lower_file = ecryptfs_file_to_lower(file);
+
+	if (lower_file->f_op && lower_file->f_op->flush) {
+		filemap_write_and_wait(file->f_mapping);
+		return lower_file->f_op->flush(lower_file, td);
+	}
+
+	return 0;
 }
 
 static int ecryptfs_release(struct inode *inode, struct file *file)



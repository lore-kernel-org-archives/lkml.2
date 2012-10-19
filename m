Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932802Ab2JSDLu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 23:11:50 -0400
Received: from mail.kernel.org ([198.145.19.201]:51711 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757489Ab2JSCsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:48:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Tyler Hicks <tyhicks@canonical.com>
Subject: [ 54/62] eCryptfs: Call lower ->flush() from ecryptfs_flush()
Date: Thu, 18 Oct 2012 19:45:22 -0700
Message-Id: <20121019024304.686859434@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019024255.944999470@linuxfoundation.org>
References: <20121019024255.944999470@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ecryptfs/file.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

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



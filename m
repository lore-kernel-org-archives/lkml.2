Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739Ab2E1D3U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:29:20 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51899 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753468Ab2E1D3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:10 -0400
Message-Id: <20120528031207.461181592@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:12:35 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Manish Honap <manish_honap_vit@yahoo.co.in>
Subject: [ 033/117] vfs: make AIO use the proper rw_verify_area() area helpers
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit a70b52ec1aaeaf60f4739edb1b422827cb6f3893 upstream.

We had for some reason overlooked the AIO interface, and it didn't use
the proper rw_verify_area() helper function that checks (for example)
mandatory locking on the file, and that the size of the access doesn't
cause us to overflow the provided offset limits etc.

Instead, AIO did just the security_file_permission() thing (that
rw_verify_area() also does) directly.

This fixes it to do all the proper helper functions, which not only
means that now mandatory file locking works with AIO too, we can
actually remove lines of code.

Reported-by: Manish Honap <manish_honap_vit@yahoo.co.in>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/aio.c |   30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 67a6db3..e7f2fad 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1456,6 +1456,10 @@ static ssize_t aio_setup_vectored_rw(int type, struct kiocb *kiocb, bool compat)
 	if (ret < 0)
 		goto out;
 
+	ret = rw_verify_area(type, kiocb->ki_filp, &kiocb->ki_pos, ret);
+	if (ret < 0)
+		goto out;
+
 	kiocb->ki_nr_segs = kiocb->ki_nbytes;
 	kiocb->ki_cur_seg = 0;
 	/* ki_nbytes/left now reflect bytes instead of segs */
@@ -1467,11 +1471,17 @@ out:
 	return ret;
 }
 
-static ssize_t aio_setup_single_vector(struct kiocb *kiocb)
+static ssize_t aio_setup_single_vector(int type, struct file * file, struct kiocb *kiocb)
 {
+	int bytes;
+
+	bytes = rw_verify_area(type, file, &kiocb->ki_pos, kiocb->ki_left);
+	if (bytes < 0)
+		return bytes;
+
 	kiocb->ki_iovec = &kiocb->ki_inline_vec;
 	kiocb->ki_iovec->iov_base = kiocb->ki_buf;
-	kiocb->ki_iovec->iov_len = kiocb->ki_left;
+	kiocb->ki_iovec->iov_len = bytes;
 	kiocb->ki_nr_segs = 1;
 	kiocb->ki_cur_seg = 0;
 	return 0;
@@ -1496,10 +1506,7 @@ static ssize_t aio_setup_iocb(struct kiocb *kiocb, bool compat)
 		if (unlikely(!access_ok(VERIFY_WRITE, kiocb->ki_buf,
 			kiocb->ki_left)))
 			break;
-		ret = security_file_permission(file, MAY_READ);
-		if (unlikely(ret))
-			break;
-		ret = aio_setup_single_vector(kiocb);
+		ret = aio_setup_single_vector(READ, file, kiocb);
 		if (ret)
 			break;
 		ret = -EINVAL;
@@ -1514,10 +1521,7 @@ static ssize_t aio_setup_iocb(struct kiocb *kiocb, bool compat)
 		if (unlikely(!access_ok(VERIFY_READ, kiocb->ki_buf,
 			kiocb->ki_left)))
 			break;
-		ret = security_file_permission(file, MAY_WRITE);
-		if (unlikely(ret))
-			break;
-		ret = aio_setup_single_vector(kiocb);
+		ret = aio_setup_single_vector(WRITE, file, kiocb);
 		if (ret)
 			break;
 		ret = -EINVAL;
@@ -1528,9 +1532,6 @@ static ssize_t aio_setup_iocb(struct kiocb *kiocb, bool compat)
 		ret = -EBADF;
 		if (unlikely(!(file->f_mode & FMODE_READ)))
 			break;
-		ret = security_file_permission(file, MAY_READ);
-		if (unlikely(ret))
-			break;
 		ret = aio_setup_vectored_rw(READ, kiocb, compat);
 		if (ret)
 			break;
@@ -1542,9 +1543,6 @@ static ssize_t aio_setup_iocb(struct kiocb *kiocb, bool compat)
 		ret = -EBADF;
 		if (unlikely(!(file->f_mode & FMODE_WRITE)))
 			break;
-		ret = security_file_permission(file, MAY_WRITE);
-		if (unlikely(ret))
-			break;
 		ret = aio_setup_vectored_rw(WRITE, kiocb, compat);
 		if (ret)
 			break;



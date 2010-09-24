Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932749Ab0IXQ2l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:28:41 -0400
Received: from kroah.org ([198.145.64.141]:38404 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932716Ab0IXQ2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:28:35 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:26:19 2010
Message-Id: <20100924162618.969286057@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:24:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>,
        Zach Brown <zach.brown@oracle.com>
Subject: [47/80] aio: do not return ERESTARTSYS as a result of AIO
In-Reply-To: <20100924162706.GA7381@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jan Kara <jack@suse.cz>

commit a0c42bac79731276c9b2f28d54f9e658fcf843a2 upstream.

OCFS2 can return ERESTARTSYS from its write function when the process is
signalled while waiting for a cluster lock (and the filesystem is mounted
with intr mount option).  Generally, it seems reasonable to allow
filesystems to return this error code from its IO functions.  As we must
not leak ERESTARTSYS (and similar error codes) to userspace as a result of
an AIO operation, we have to properly convert it to EINTR inside AIO code
(restarting the syscall isn't really an option because other AIO could
have been already submitted by the same io_submit syscall).

Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Zach Brown <zach.brown@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/aio.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/fs/aio.c
+++ b/fs/aio.c
@@ -712,8 +712,16 @@ static ssize_t aio_run_iocb(struct kiocb
 	 */
 	ret = retry(iocb);
 
-	if (ret != -EIOCBRETRY && ret != -EIOCBQUEUED)
+	if (ret != -EIOCBRETRY && ret != -EIOCBQUEUED) {
+		/*
+		 * There's no easy way to restart the syscall since other AIO's
+		 * may be already running. Just fail this IO with EINTR.
+		 */
+		if (unlikely(ret == -ERESTARTSYS || ret == -ERESTARTNOINTR ||
+			     ret == -ERESTARTNOHAND || ret == -ERESTART_RESTARTBLOCK))
+			ret = -EINTR;
 		aio_complete(iocb, ret, 0);
+	}
 out:
 	spin_lock_irq(&ctx->ctx_lock);
 



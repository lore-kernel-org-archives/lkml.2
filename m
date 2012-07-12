Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162056Ab2GLXCj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:02:39 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56311 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162018Ab2GLWmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:42:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Junxiao Bi <junxiao.bi@oracle.com>, Jeff Moyer <jmoyer@redhat.com>,
        Joel Becker <jlbec@evilplan.org>
Subject: [ 121/187] aio: make kiocb->private NUll in init_sync_kiocb()
Date: Thu, 12 Jul 2012 15:34:37 -0700
Message-Id: <20120712191533.579605191@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junxiao Bi <junxiao.bi@oracle.com>

commit 2dfd06036ba7ae8e7be2daf5a2fff1dac42390bf upstream.

Ocfs2 uses kiocb.*private as a flag of unsigned long size. In
commit a11f7e6 ocfs2: serialize unaligned aio, the unaligned
io flag is involved in it to serialize the unaligned aio. As
*private is not initialized in init_sync_kiocb() of do_sync_write(),
this unaligned io flag may be unexpectly set in an aligned dio.
And this will cause OCFS2_I(inode)->ip_unaligned_aio decreased
to -1 in ocfs2_dio_end_io(), thus the following unaligned dio
will hang forever at ocfs2_aiodio_wait() in ocfs2_file_aio_write().

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Acked-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/aio.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/aio.h
+++ b/include/linux/aio.h
@@ -140,6 +140,7 @@ struct kiocb {
 		(x)->ki_dtor = NULL;			\
 		(x)->ki_obj.tsk = tsk;			\
 		(x)->ki_user_data = 0;                  \
+		(x)->private = NULL;			\
 	} while (0)
 
 #define AIO_RING_MAGIC			0xa10a10a1



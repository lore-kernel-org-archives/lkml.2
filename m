Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673Ab2F0JLU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 05:11:20 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:35532 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755175Ab2F0JLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 05:11:15 -0400
From: Junxiao Bi <junxiao.bi@oracle.com>
To: ocfs2-devel@oss.oracle.com, linux-aio@kvack.org
Cc: mfasheh@suse.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        joe.jin@oracle.com, Junxiao Bi <junxiao.bi@oracle.com>,
        stable@vger.kernel.org
Subject: [PATCH v4 1/2] aio: make kiocb->private NUll in init_sync_kiocb()
Date: Wed, 27 Jun 2012 17:09:54 +0800
Message-Id: <1340788195-20623-2-git-send-email-junxiao.bi@oracle.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1340788195-20623-1-git-send-email-junxiao.bi@oracle.com>
References: <1340788195-20623-1-git-send-email-junxiao.bi@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ocfs2 uses kiocb.*private as a flag of unsigned long size. In
commit a11f7e6 ocfs2: serialize unaligned aio, the unaligned
io flag is involved in it to serialize the unaligned aio. As
*private is not initialized in init_sync_kiocb() of do_sync_write(),
this unaligned io flag may be unexpectly set in an aligned dio.
And this will cause OCFS2_I(inode)->ip_unaligned_aio decreased
to -1 in ocfs2_dio_end_io(), thus the following unaligned dio
will hang forever at ocfs2_aiodio_wait() in ocfs2_file_aio_write().

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Cc: stable@vger.kernel.org
Acked-by: Jeff Moyer <jmoyer@redhat.com>
Acked-by: Joel Becker <jlbec@evilplan.org>
---
 include/linux/aio.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/aio.h b/include/linux/aio.h
index 2314ad8..b1a520e 100644
--- a/include/linux/aio.h
+++ b/include/linux/aio.h
@@ -140,6 +140,7 @@ struct kiocb {
 		(x)->ki_dtor = NULL;			\
 		(x)->ki_obj.tsk = tsk;			\
 		(x)->ki_user_data = 0;                  \
+		(x)->private = NULL;			\
 	} while (0)
 
 #define AIO_RING_MAGIC			0xa10a10a1
-- 
1.7.9.5


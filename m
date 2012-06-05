Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab2FEH1s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 03:27:48 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:21927 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754889Ab2FEH1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 03:27:44 -0400
From: Junxiao Bi <junxiao.bi@oracle.com>
To: ocfs2-devel@oss.oracle.com, linux-aio@kvack.org
Cc: jmoyer@redhat.com, mfasheh@suse.com, jlbec@evilplan.org, bcrl@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        joe.jin@oracle.com, dave.kleikamp@oracle.com,
        Junxiao Bi <junxiao.bi@oracle.com>
Subject: [V2 PATCH 1/2] aio: make kiocb->private NUll in init_sync_kiocb()
Date: Tue,  5 Jun 2012 15:26:49 +0800
Message-Id: <1338881210-14863-2-git-send-email-junxiao.bi@oracle.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1338881210-14863-1-git-send-email-junxiao.bi@oracle.com>
References: <1338881210-14863-1-git-send-email-junxiao.bi@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
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


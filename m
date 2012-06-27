Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749Ab2F0JL1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 05:11:27 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:47560 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201Ab2F0JLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 05:11:22 -0400
From: Junxiao Bi <junxiao.bi@oracle.com>
To: ocfs2-devel@oss.oracle.com, linux-aio@kvack.org
Cc: mfasheh@suse.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        joe.jin@oracle.com, Junxiao Bi <junxiao.bi@oracle.com>,
        stable@vger.kernel.org
Subject: [PATCH v4 2/2] ocfs2: clear unaligned io flag when dio fails
Date: Wed, 27 Jun 2012 17:09:55 +0800
Message-Id: <1340788195-20623-3-git-send-email-junxiao.bi@oracle.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1340788195-20623-1-git-send-email-junxiao.bi@oracle.com>
References: <1340788195-20623-1-git-send-email-junxiao.bi@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The unaligned io flag is set in the kiocb when an unaligned
dio is issued, it should be cleared even when the dio fails,
or it may affect the following io which are using the same
kiocb.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Cc: stable@vger.kernel.org
---
 fs/ocfs2/file.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 061591a..98513c8 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2422,8 +2422,10 @@ out_dio:
 		unaligned_dio = 0;
 	}
 
-	if (unaligned_dio)
+	if (unaligned_dio) {
+		ocfs2_iocb_clear_unaligned_aio(iocb);
 		atomic_dec(&OCFS2_I(inode)->ip_unaligned_aio);
+	}
 
 out:
 	if (rw_level != -1)
-- 
1.7.9.5


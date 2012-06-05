Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703Ab2FEH1x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 03:27:53 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:21974 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754889Ab2FEH1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 03:27:50 -0400
From: Junxiao Bi <junxiao.bi@oracle.com>
To: ocfs2-devel@oss.oracle.com, linux-aio@kvack.org
Cc: jmoyer@redhat.com, mfasheh@suse.com, jlbec@evilplan.org, bcrl@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        joe.jin@oracle.com, dave.kleikamp@oracle.com,
        Junxiao Bi <junxiao.bi@oracle.com>
Subject: [V2 PATCH 2/2] ocfs2: clear unaligned io flag when dio fails
Date: Tue,  5 Jun 2012 15:26:50 +0800
Message-Id: <1338881210-14863-3-git-send-email-junxiao.bi@oracle.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1338881210-14863-1-git-send-email-junxiao.bi@oracle.com>
References: <1338881210-14863-1-git-send-email-junxiao.bi@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The unaligned io flag is set in the kiocb when an unaligned
dio is issued, it should be cleared even when the dio fails,
or it may affect the following io which are using the same
kiocb.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
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


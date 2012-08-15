Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173Ab2HOULH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:11:07 -0400
Received: from mail.windriver.com ([147.11.1.11]:37033 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756940Ab2HOTv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:51:58 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Petr Uzel <petr.uzel@suse.cz>, James Bottomley <JBottomley@parallels.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 120/165] [SCSI] st: fix race in st_scsi_execute_end
Date: Wed, 15 Aug 2012 15:47:44 -0400
Message-ID: <1345060109-9187-121-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Petr Uzel <petr.uzel@suse.cz>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit c68bf8eeaa57c852e74adcf597237be149eef830 upstream.

The call to complete() in st_scsi_execute_end() wakes up sleeping thread
in write_behind_check(), which frees the st_request, thus invalidating
the pointer to the associated bio structure, which is then passed to the
blk_rq_unmap_user(). Fix by storing pointer to bio structure into
temporary local variable.

This bug is present since at least linux-2.6.32.

Signed-off-by: Petr Uzel <petr.uzel@suse.cz>
Reported-by: Juergen Groß <juergen.gross@ts.fujitsu.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Kai Mäkisara <kai.makisara@kolumbus.fi>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/scsi/st.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 3ea1a71..516ca15 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -462,14 +462,16 @@ static void st_scsi_execute_end(struct request *req, int uptodate)
 {
 	struct st_request *SRpnt = req->end_io_data;
 	struct scsi_tape *STp = SRpnt->stp;
+	struct bio *tmp;
 
 	STp->buffer->cmdstat.midlevel_result = SRpnt->result = req->errors;
 	STp->buffer->cmdstat.residual = req->resid_len;
 
+	tmp = SRpnt->bio;
 	if (SRpnt->waiting)
 		complete(SRpnt->waiting);
 
-	blk_rq_unmap_user(SRpnt->bio);
+	blk_rq_unmap_user(tmp);
 	__blk_put_request(req->q, req);
 }
 
-- 
1.7.12.rc2


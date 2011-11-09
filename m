Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935406Ab1KJExP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:53:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42912 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935251Ab1KJDbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:31:43 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:22 2011
Message-Id: <20111109212722.100849422@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:28:56 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Petr Uzel <petr.uzel@suse.cz>,
        =?ISO-8859-15?q?Kai=20M=C3=A4kisara?= <kai.makisara@kolumbus.fi>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [214/262] [SCSI] st: fix race in st_scsi_execute_end
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Uzel <petr.uzel@suse.cz>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/st.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -462,14 +462,16 @@ static void st_scsi_execute_end(struct r
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
 



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342Ab1JKREp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 13:04:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33330 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755076Ab1JKREn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 13:04:43 -0400
X-Mailbox-Line: From gregkh@pistachio.kroah.org Tue Oct 11 10:57:11 2011
Message-Id: <20111011165711.813833338@pistachio.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 11 Oct 2011 10:55:33 -0600
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Roland Dreier <roland@purestorage.com>,
        Chad Dupuis <chad.dupuis@qlogic.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [23/38] [SCSI] qla2xxx: Fix crash in qla2x00_abort_all_cmds() on unload
In-Reply-To: <20111011165903.GA30976@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Roland Dreier <roland@purestorage.com>

commit 9bfacd01dc9b7519e1e6da12b01963550b9d09a2 upstream.

I hit a crash in qla2x00_abort_all_cmds() if the qla2xxx module is
unloaded right after it is loaded.  I debugged this down to the abort
handling improperly treating a command of type SRB_ADISC_CMD as if it
had a bsg_job to complete when that command actually uses the iocb_cmd
part of the union.  (I guess to hit this one has to unload the module
while the async FC initialization is still in progress)

It seems we should only look for a bsg_job if type is SRB_ELS_CMD_RPT,
SRB_ELS_CMD_HST or SRB_CT_CMD, so switch the test to make that explicit.

Signed-off-by: Roland Dreier <roland@purestorage.com>
Acked-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/qla2xxx/qla_os.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1240,10 +1240,9 @@ qla2x00_abort_all_cmds(scsi_qla_host_t *
 					qla2x00_sp_compl(ha, sp);
 				} else {
 					ctx = sp->ctx;
-					if (ctx->type == SRB_LOGIN_CMD ||
-					    ctx->type == SRB_LOGOUT_CMD) {
-						ctx->u.iocb_cmd->free(sp);
-					} else {
+					if (ctx->type == SRB_ELS_CMD_RPT ||
+					    ctx->type == SRB_ELS_CMD_HST ||
+					    ctx->type == SRB_CT_CMD) {
 						struct fc_bsg_job *bsg_job =
 						    ctx->u.bsg_job;
 						if (bsg_job->request->msgcode
@@ -1255,6 +1254,8 @@ qla2x00_abort_all_cmds(scsi_qla_host_t *
 						kfree(sp->ctx);
 						mempool_free(sp,
 							ha->srb_mempool);
+					} else {
+						ctx->u.iocb_cmd->free(sp);
 					}
 				}
 			}



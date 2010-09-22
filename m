Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116Ab0IVFvB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 01:51:01 -0400
Received: from smtp105.sbc.mail.gq1.yahoo.com ([67.195.14.108]:22637 "HELO
	smtp105.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753002Ab0IVFu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 01:50:59 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: sfVaGqAVM1mNO8ltLL9HfudhTQG6Xf2Kjxt.ITwSuNaGQsm
 8mfPvz10GTPp8RCOPlJeU3ZutcR2I1IU1a8C4A1heowS5.NxFiC.BUOzYp6I
 6jCHAJRC2fI9hIeOzbnqwc_5B.HsskhQ7ZRmxXxbPciUAoNGHcCKJ2.7Lfp5
 v7wFSGwjl.KReyEN8jnq3vXNjX2pmPwnDR3afHOdnYFjNQ8tayocO4O9rSrJ
 Ny0aDsYF25MU8wZ7V.bB3W4hAYrQ1RxaEuNbx2EJwXJYieE8yM3VdoYPgl2U
 H1GPMevcInQM4thDPVKKp5a4uwUBfs4hxtL42FjG62ykXfbUNk5BG5.tD0AY
 II02GS6zBezQ3mJhDbA--
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@suse.de>,
        Douglas Gilbert <dgilbert@interlog.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Boaz Harrosh <bharrosh@panasas.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 2/2] scsi_debug: Add XDWRITEREAD_32 support
Date: Tue, 21 Sep 2010 22:50:56 -0700
Message-Id: <1285134656-7764-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds XDWRITEREAD_32 support to scsi_debug.c in
scsi_debug_queuecommand().  It follows the other READ_32 and WRITE_32
emulation for VARIABLE_LENGTH_CMD, and adds a simple goto back to existing
XDWRITEREAD_10 processing logic which already properly supports 64-bit LBA
and 32-bit transfer length in get_data_transfer_info()

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/scsi_debug.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index b02bdc6..f2547d7 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -3796,6 +3796,7 @@ write:
 		errsts = check_readiness(SCpnt, 1, devip);
 		break;
 	case XDWRITEREAD_10:
+xdwrite_read:
 		if (!scsi_bidi_cmnd(SCpnt)) {
 			mk_sense_buffer(devip, ILLEGAL_REQUEST,
 					INVALID_FIELD_IN_CDB, 0);
@@ -3834,6 +3835,8 @@ write:
 				goto write;
 			}
 		}
+		if (cmd[9] == XDWRITEREAD_32)
+			goto xdwrite_read;
 
 		mk_sense_buffer(devip, ILLEGAL_REQUEST,
 				INVALID_FIELD_IN_CDB, 0);
-- 
1.7.3


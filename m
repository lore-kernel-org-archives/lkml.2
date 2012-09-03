Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534Ab2ICSuc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 14:50:32 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44180 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535Ab2ICSua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 14:50:30 -0400
Date: Mon, 3 Sep 2012 20:50:30 +0200
From: Andi Kleen <andi@firstfloor.org>
To: bprakash@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Fix incorrect memset in bnx2fc_parse_fcp_rsp
Message-ID: <20120903185030.GV16230@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gcc 4.8 warns because the memset only clears sizeof(char *) bytes, not
the whole buffer. Use the correct buffer size and clear the whole sense
buffer.

/backup/lsrc/git/linux-lto-2.6/drivers/scsi/bnx2fc/bnx2fc_io.c: In
function 'bnx2fc_parse_fcp_rsp':
/backup/lsrc/git/linux-lto-2.6/drivers/scsi/bnx2fc/bnx2fc_io.c:1810:41:
warning: argument to 'sizeof' in 'memset' call is the same expression as
the destination; did you mean to provide an explicit length?
[-Wsizeof-pointer-memaccess]
   memset(sc_cmd->sense_buffer, 0, sizeof(sc_cmd->sense_buffer));
                                         ^

Signed-off-by: Andi Kleen <ak@linux.intel.com>



diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 73f231c..8d4626c 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1807,7 +1807,7 @@ static void bnx2fc_parse_fcp_rsp(struct bnx2fc_cmd *io_req,
 			fcp_sns_len = SCSI_SENSE_BUFFERSIZE;
 		}
 
-		memset(sc_cmd->sense_buffer, 0, sizeof(sc_cmd->sense_buffer));
+		memset(sc_cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 		if (fcp_sns_len)
 			memcpy(sc_cmd->sense_buffer, rq_data, fcp_sns_len);
 
-- 
ak@linux.intel.com -- Speaking for myself only.

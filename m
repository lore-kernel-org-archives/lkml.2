Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934917Ab2C3VFm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:05:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33001 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934734Ab2C3VFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:05:30 -0400
Message-Id: <20120330195728.841021676@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:58:09 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Roland Dreier <roland@purestorage.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 047/108] tcm_loop: Set residual field for SCSI commands
In-Reply-To: <20120330195812.GA31833@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roland Dreier <roland@purestorage.com>

commit 6cf3fa6918baab0c447f1206f1cef9166ad04864 upstream.

If the target core signals an over- or under-run, tcm_loop should call
scsi_set_resid() to tell the SCSI midlayer about the residual data length.

The difference can be seen by doing something like

    strace -eioctl sg_raw -r 1024 /dev/sda 8 0 0 0 1 0 > /dev/null

and looking at the "resid=" part of the SG_IO ioctl -- after this patch,
the field is correctly reported as 512.

Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/loopback/tcm_loop.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -905,6 +905,9 @@ static int tcm_loop_queue_data_in(struct
 
 	sc->result = SAM_STAT_GOOD;
 	set_host_byte(sc, DID_OK);
+	if ((se_cmd->se_cmd_flags & SCF_OVERFLOW_BIT) ||
+	    (se_cmd->se_cmd_flags & SCF_UNDERFLOW_BIT))
+		scsi_set_resid(sc, se_cmd->residual_count);
 	sc->scsi_done(sc);
 	return 0;
 }
@@ -930,6 +933,9 @@ static int tcm_loop_queue_status(struct
 		sc->result = se_cmd->scsi_status;
 
 	set_host_byte(sc, DID_OK);
+	if ((se_cmd->se_cmd_flags & SCF_OVERFLOW_BIT) ||
+	    (se_cmd->se_cmd_flags & SCF_UNDERFLOW_BIT))
+		scsi_set_resid(sc, se_cmd->residual_count);
 	sc->scsi_done(sc);
 	return 0;
 }



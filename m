Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965280Ab2DKXno (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:43:44 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:51056 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965219Ab2DKXXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:23:00 -0400
Message-Id: <20120411231040.842121975@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 11 Apr 2012 16:11:07 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Martin Svec <martin.svec@zoner.cz>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 32/59] target: Fix unsupported WRITE_SAME sense payload
In-Reply-To: <20120411231213.GA13124@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Svec <martin.svec@zoner.cz>

commit 67236c44741e250199ccd77f1115568e68cf8848 upstream.

This patch fixes a bug in target-core where unsupported WRITE_SAME ops
from a target_check_write_same_discard() failure was incorrectly
returning CHECK_CONDITION w/ TCM_INVALID_CDB_FIELD sense data.
This was causing some clients to not properly fall back, so go ahead
and use the correct TCM_UNSUPPORTED_SCSI_OPCODE sense for this case.

Reported-by: Martin Svec <martin.svec@zoner.cz>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_transport.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2666,7 +2666,7 @@ static int transport_generic_cmd_sequenc
 			cmd->se_cmd_flags |= SCF_SCSI_CONTROL_SG_IO_CDB;
 
 			if (target_check_write_same_discard(&cdb[10], dev) < 0)
-				goto out_invalid_cdb_field;
+				goto out_unsupported_cdb;
 			if (!passthrough)
 				cmd->execute_task = target_emulate_write_same;
 			break;
@@ -2949,7 +2949,7 @@ static int transport_generic_cmd_sequenc
 		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_SG_IO_CDB;
 
 		if (target_check_write_same_discard(&cdb[1], dev) < 0)
-			goto out_invalid_cdb_field;
+			goto out_unsupported_cdb;
 		if (!passthrough)
 			cmd->execute_task = target_emulate_write_same;
 		break;
@@ -2972,7 +2972,7 @@ static int transport_generic_cmd_sequenc
 		 * of byte 1 bit 3 UNMAP instead of original reserved field
 		 */
 		if (target_check_write_same_discard(&cdb[1], dev) < 0)
-			goto out_invalid_cdb_field;
+			goto out_unsupported_cdb;
 		if (!passthrough)
 			cmd->execute_task = target_emulate_write_same;
 		break;



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932855Ab2BJWny (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 17:43:54 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45193 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760674Ab2BJWnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:43:50 -0500
MIME-Version: 1.0
Message-Id: <20120210222951.246936878@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:30:29 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Roland Dreier <roland@purestorage.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [patch 70/86] target: Add workaround for zero-length control CDB handling
In-Reply-To: <20120210223514.GA24190@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit 91ec1d3535b2acf12c599045cc19ad9be3c6a47b upstream.

This patch adds a work-around for handling zero allocation length
control CDBs (type SCF_SCSI_CONTROL_SG_IO_CDB) that was causing an
OOPs with the following raw calls:

   # sg_raw -v /dev/sdd 3 0 0 0 0 0
   # sg_raw -v /dev/sdd 0x1a 0 1 0 0 0

This patch will follow existing zero-length handling for data I/O
and silently return with GOOD status.  This addresses the zero length
issue, but the proper long-term resolution for handling arbitary
allocation lengths will be to refactor out data-phase handling in
individual CDB emulation logic within target_core_cdb.c

Reported-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_transport.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3701,6 +3701,11 @@ transport_allocate_control_task(struct s
 	struct se_task *task;
 	unsigned long flags;
 
+	/* Workaround for handling zero-length control CDBs */
+	if ((cmd->se_cmd_flags & SCF_SCSI_CONTROL_SG_IO_CDB) &&
+	    !cmd->data_length)
+		return 0;
+
 	task = transport_generic_get_task(cmd, cmd->data_direction);
 	if (!task)
 		return -ENOMEM;
@@ -3772,6 +3777,14 @@ int transport_generic_new_cmd(struct se_
 	else if (!task_cdbs && (cmd->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB)) {
 		cmd->t_state = TRANSPORT_COMPLETE;
 		atomic_set(&cmd->t_transport_active, 1);
+
+		if (cmd->t_task_cdb[0] == REQUEST_SENSE) {
+			u8 ua_asc = 0, ua_ascq = 0;
+
+			core_scsi3_ua_clear_for_request_sense(cmd,
+					&ua_asc, &ua_ascq);
+		}
+
 		INIT_WORK(&cmd->work, target_complete_ok_work);
 		queue_work(target_completion_wq, &cmd->work);
 		return 0;



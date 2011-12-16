Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760680Ab1LPTtN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 14:49:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44890 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760361Ab1LPTsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 14:48:54 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Dec 16 11:45:57 2011
Message-Id: <20111216194557.432245534@clark.kroah.org>
User-Agent: quilt/0.50-24.1
Date: Fri, 16 Dec 2011 11:45:18 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Christoph Hellwig <hch@lst.de>,
        Andy Grover <agrover@redhat.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [21/53] target: Reject SCSI data overflow for fabrics using transport_generic_map_mem_to_cmd
In-Reply-To: <20111216194613.GA18395@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit fef58a6096770ed6ab49103a430cc755254a74d9 upstream.

This patch changes transport_generic_map_mem_to_cmd() to reject SCSI data
overflow and to send exception status with CHECK_CONDITION + TCM_INVALID_CDB_FIELD
for fabrics that are passing a pre-populated struct scatterlist (eg: tcm_loop
and iscsi-target) being mapped into se_cmd->t_data_sg and se_cmd->t_data_nents.

This addresses an OOPs where transport_allocate_data_tasks() would walk
the incorrect post OVERFLOW cmd->data_length value beyond the end of
the passed scatterlist.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/target/target_core_transport.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3873,6 +3873,18 @@ int transport_generic_map_mem_to_cmd(
 
 	if ((cmd->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB) ||
 	    (cmd->se_cmd_flags & SCF_SCSI_CONTROL_SG_IO_CDB)) {
+		/*
+		 * Reject SCSI data overflow with map_mem_to_cmd() as incoming
+		 * scatterlists already have been set to follow what the fabric
+		 * passes for the original expected data transfer length.
+		 */
+		if (cmd->se_cmd_flags & SCF_OVERFLOW_BIT) {
+			pr_warn("Rejecting SCSI DATA overflow for fabric using"
+				" SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC\n");
+			cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
+			cmd->scsi_sense_reason = TCM_INVALID_CDB_FIELD;
+			return -EINVAL;
+		}
 
 		cmd->t_data_sg = sgl;
 		cmd->t_data_nents = sgl_count;



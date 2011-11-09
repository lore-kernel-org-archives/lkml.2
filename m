Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965789Ab1KJDqY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:46:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44874 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965775Ab1KJDqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:46:18 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:32:03 2011
Message-Id: <20111109213203.558056268@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:34:17 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Christoph Hellwig <hch@lst.de>,
        Andy Grover <agrover@redhat.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [210/264] tcm_loop: Add explict read buffer memset for SCF_SCSI_CONTROL_SG_IO_CDB
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit 8cd79f24350826b81e16990d9e12bc878e67d385 upstream.

This patch addresses an issue with buggy userspace code sending I/O
via scsi-generic that does not explictly clear their associated read
buffers.  It adds an explict memset of the first SGL entry within
tcm_loop_new_cmd_map() for SCF_SCSI_CONTROL_SG_IO_CDB payloads that
are currently guaranteed to be a single SGL by target-core code.

This issue is a side effect of the v3.1-rc1 merge to remove the
extra memcpy between certain control CDB types using a contigious
+ cleared buffer in target-core, and performing a memcpy into the
SGL list within tcm_loop.

It was originally mainfesting itself by udev + scsi_id + scsi-generic
not properly setting up the expected /dev/disk/by-id/ symlinks because
the INQUIRY payload was containing extra bogus data preventing the
proper NAA IEEE WWN from being parsed by userspace.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/target/loopback/tcm_loop.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -174,6 +174,24 @@ static int tcm_loop_new_cmd_map(struct s
 		sgl_bidi = sdb->table.sgl;
 		sgl_bidi_count = sdb->table.nents;
 	}
+	/*
+	 * Because some userspace code via scsi-generic do not memset their
+	 * associated read buffers, go ahead and do that here for type
+	 * SCF_SCSI_CONTROL_SG_IO_CDB.  Also note that this is currently
+	 * guaranteed to be a single SGL for SCF_SCSI_CONTROL_SG_IO_CDB
+	 * by target core in transport_generic_allocate_tasks() ->
+	 * transport_generic_cmd_sequencer().
+	 */
+	if (se_cmd->se_cmd_flags & SCF_SCSI_CONTROL_SG_IO_CDB &&
+	    se_cmd->data_direction == DMA_FROM_DEVICE) {
+		struct scatterlist *sg = scsi_sglist(sc);
+		unsigned char *buf = kmap(sg_page(sg)) + sg->offset;
+
+		if (buf != NULL) {
+			memset(buf, 0, sg->length);
+			kunmap(sg_page(sg));
+		}
+	}
 
 	/* Tell the core about our preallocated memory */
 	ret = transport_generic_map_mem_to_cmd(se_cmd, scsi_sglist(sc),



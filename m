Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887Ab1I1Wmf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:42:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54089 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755846Ab1I1Wmd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:42:33 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:36 2011
Message-Id: <20110928220136.186081674@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:01:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Williams <dan.j.williams@intel.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [103/244] [SCSI] isci: fix 32-bit operation when CONFIG_HIGHMEM64G=n
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

commit ee33e2b771f9e9e4aaba2bb2ace7b727fe451a8b upstream.

The unsolicited frame control infrastructure requires a table of dma
addresses for the hardware to lookup the frame buffer location by an
index.  The hardware expects the elements of this table to be 64-bit
quantities, so we cannot reference these elements as dma_addr_t.  All
unsolicited frame protocols are affected, particularly SATA-PIO and SMP
which prevented direct-attached SATA drives and expander-attached drives
to not be discovered.

Reported-by: Jacek Danecki <jacek.danecki@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/isci/unsolicited_frame_control.c |    2 +-
 drivers/scsi/isci/unsolicited_frame_control.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/scsi/isci/unsolicited_frame_control.c
+++ b/drivers/scsi/isci/unsolicited_frame_control.c
@@ -72,7 +72,7 @@ int sci_unsolicited_frame_control_constr
 	 */
 	buf_len = SCU_MAX_UNSOLICITED_FRAMES * SCU_UNSOLICITED_FRAME_BUFFER_SIZE;
 	header_len = SCU_MAX_UNSOLICITED_FRAMES * sizeof(struct scu_unsolicited_frame_header);
-	size = buf_len + header_len + SCU_MAX_UNSOLICITED_FRAMES * sizeof(dma_addr_t);
+	size = buf_len + header_len + SCU_MAX_UNSOLICITED_FRAMES * sizeof(uf_control->address_table.array[0]);
 
 	/*
 	 * The Unsolicited Frame buffers are set at the start of the UF
--- a/drivers/scsi/isci/unsolicited_frame_control.h
+++ b/drivers/scsi/isci/unsolicited_frame_control.h
@@ -214,7 +214,7 @@ struct sci_uf_address_table_array {
 	 * starting address of the UF address table.
 	 * 64-bit pointers are required by the hardware.
 	 */
-	dma_addr_t *array;
+	u64 *array;
 
 	/**
 	 * This field specifies the physical address location for the UF



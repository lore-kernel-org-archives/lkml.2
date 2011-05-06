Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932582Ab1EFAiv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:38:51 -0400
Received: from kroah.org ([198.145.64.141]:37347 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932499Ab1EFA0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:26:03 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:18 2011
Message-Id: <20110506002218.044949058@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:21:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        "Kashyap Desai" <Kashyap.Desai@lsi.com>,
        James Bottomley <James.Bottomley@suse.de>
Subject: [130/143] mpt2sas: fix the incorrect scsi_dma_map error checking
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

commit bb789d01620e5d36081b22edb6fb71cf55ff043c upstream.

scsi_dma_map() returns -1 if an error occurred (zero means that the
command has no data). So the following current code can't catch an
error:

sges_left = scsi_dma_map(scmd);
if (!sges_left) {
	sdev_printk(KERN_ERR, scmd->device, "pci_map_sg"
	" failed: request for %d bytes!\n", scsi_bufflen(scmd));
	return -ENOMEM;
}

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: "Kashyap Desai" <Kashyap.Desai@lsi.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -945,7 +945,7 @@ _scsih_build_scatter_gather(struct MPT2S
 	u32 chain_offset;
 	u32 chain_length;
 	u32 chain_flags;
-	u32 sges_left;
+	int sges_left;
 	u32 sges_in_segment;
 	u32 sgl_flags;
 	u32 sgl_flags_last_element;
@@ -966,7 +966,7 @@ _scsih_build_scatter_gather(struct MPT2S
 
 	sg_scmd = scsi_sglist(scmd);
 	sges_left = scsi_dma_map(scmd);
-	if (!sges_left) {
+	if (sges_left < 0) {
 		sdev_printk(KERN_ERR, scmd->device, "pci_map_sg"
 		" failed: request for %d bytes!\n", scsi_bufflen(scmd));
 		return -ENOMEM;



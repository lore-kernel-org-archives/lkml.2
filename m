Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759438Ab0HKX7z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 19:59:55 -0400
Received: from kroah.org ([198.145.64.141]:43766 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759265Ab0HKX7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:59:36 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:55:05 2010
Message-Id: <20100811235505.544206205@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:55:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Brian King <brking@linux.vnet.ibm.com>,
        James Bottomley <James.Bottomley@suse.de>
Subject: [108/111] [SCSI] ibmvfc: Fix command completion handling
In-Reply-To: <20100811235623.GA24440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Brian King <brking@linux.vnet.ibm.com>

commit f5832fa2f8dc39adcf3ae348d2d6383163235e79 upstream.

Commands which are completed by the VIOS are placed on a CRQ
in kernel memory for the ibmvfc driver to process. Each CRQ
entry is 16 bytes. The ibmvfc driver reads the first 8 bytes
to check if the entry is valid, then reads the next 8 bytes to get
the handle, which is a pointer the completed command. This fixes
an issue seen on Power 7 where the processor reordered the
loads from memory, resulting in processing command completion
with a stale handle. This could result in command timeouts,
and also early completion of commands.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/ibmvscsi/ibmvfc.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -2720,6 +2720,7 @@ static struct ibmvfc_async_crq *ibmvfc_n
 	if (crq->valid & 0x80) {
 		if (++async_crq->cur == async_crq->size)
 			async_crq->cur = 0;
+		rmb();
 	} else
 		crq = NULL;
 
@@ -2742,6 +2743,7 @@ static struct ibmvfc_crq *ibmvfc_next_cr
 	if (crq->valid & 0x80) {
 		if (++queue->cur == queue->size)
 			queue->cur = 0;
+		rmb();
 	} else
 		crq = NULL;
 
@@ -2790,12 +2792,14 @@ static void ibmvfc_tasklet(void *data)
 		while ((async = ibmvfc_next_async_crq(vhost)) != NULL) {
 			ibmvfc_handle_async(async, vhost);
 			async->valid = 0;
+			wmb();
 		}
 
 		/* Pull all the valid messages off the CRQ */
 		while ((crq = ibmvfc_next_crq(vhost)) != NULL) {
 			ibmvfc_handle_crq(crq, vhost);
 			crq->valid = 0;
+			wmb();
 		}
 
 		vio_enable_interrupts(vdev);
@@ -2803,10 +2807,12 @@ static void ibmvfc_tasklet(void *data)
 			vio_disable_interrupts(vdev);
 			ibmvfc_handle_async(async, vhost);
 			async->valid = 0;
+			wmb();
 		} else if ((crq = ibmvfc_next_crq(vhost)) != NULL) {
 			vio_disable_interrupts(vdev);
 			ibmvfc_handle_crq(crq, vhost);
 			crq->valid = 0;
+			wmb();
 		} else
 			done = 1;
 	}



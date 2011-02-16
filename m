Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758335Ab1BPCKL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 21:10:11 -0500
Received: from kroah.org ([198.145.64.141]:48808 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756821Ab1BPBti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 20:49:38 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 17:46:57 2011
Message-Id: <20110216014657.215719247@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 17:44:55 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        maximilian attems <max@stro.at>
Subject: [029/115] [S390] hvc_iucv: allocate memory buffers for IUCV in zone DMA
In-Reply-To: <20110216014741.GA24678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>

commit 91a970d9889c7d6f451ee91ed361d0f0119d3778 upstream.

The device driver must allocate memory for IUCV buffers with GFP_DMA,
because IUCV cannot address memory above 2GB (31bit addresses only).

Because the IUCV ignores the higher bits of the address, sending and
receiving IUCV data with this driver might cause memory corruptions.

Signed-off-by: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: maximilian attems <max@stro.at>

---
 drivers/char/hvc_iucv.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/char/hvc_iucv.c
+++ b/drivers/char/hvc_iucv.c
@@ -139,6 +139,8 @@ struct hvc_iucv_private *hvc_iucv_get_pr
  *
  * This function allocates a new struct iucv_tty_buffer element and, optionally,
  * allocates an internal data buffer with the specified size @size.
+ * The internal data buffer is always allocated with GFP_DMA which is
+ * required for receiving and sending data with IUCV.
  * Note: The total message size arises from the internal buffer size and the
  *	 members of the iucv_tty_msg structure.
  * The function returns NULL if memory allocation has failed.
@@ -154,7 +156,7 @@ static struct iucv_tty_buffer *alloc_tty
 
 	if (size > 0) {
 		bufp->msg.length = MSG_SIZE(size);
-		bufp->mbuf = kmalloc(bufp->msg.length, flags);
+		bufp->mbuf = kmalloc(bufp->msg.length, flags | GFP_DMA);
 		if (!bufp->mbuf) {
 			mempool_free(bufp, hvc_iucv_mempool);
 			return NULL;
@@ -237,7 +239,7 @@ static int hvc_iucv_write(struct hvc_iuc
 	if (!rb->mbuf) { /* message not yet received ... */
 		/* allocate mem to store msg data; if no memory is available
 		 * then leave the buffer on the list and re-try later */
-		rb->mbuf = kmalloc(rb->msg.length, GFP_ATOMIC);
+		rb->mbuf = kmalloc(rb->msg.length, GFP_ATOMIC | GFP_DMA);
 		if (!rb->mbuf)
 			return -ENOMEM;
 



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935045Ab2C3VG0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:06:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33001 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935011Ab2C3VGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:06:16 -0400
Message-Id: <20120330195730.895811790@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:58:23 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Clemens Ladisch <clemens@ladisch.de>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [ 061/108] firewire: ohci: fix too-early completion of IR multichannel buffers
In-Reply-To: <20120330195812.GA31833@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clemens Ladisch <clemens@ladisch.de>

commit 0c0efbacab8d70700d13301e0ae7975783c0cb0a upstream.

handle_ir_buffer_fill() assumed that a completed descriptor would be
indicated by a non-zero transfer_status (as in most other descriptors).
However, this field is written by the controller as soon as (the end of)
the first packet has been written into the buffer.  As a consequence, if
we happen to run into such a descriptor when the interrupt handler is
executed after such a packet has completed, the descriptor would be
taken out of the list of active descriptors as soon as the buffer had
been partially filled, so the event for the buffer being completely
filled would never be sent.

To fix this, handle descriptors only when they have been completely
filled, i.e., when res_count == 0.  (This also matches the condition
that is reported by the controller with an interrupt.)

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/firewire/ohci.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -2558,15 +2558,14 @@ static int handle_ir_buffer_fill(struct
 	struct iso_context *ctx =
 		container_of(context, struct iso_context, context);
 
-	if (!last->transfer_status)
+	if (last->res_count != 0)
 		/* Descriptor(s) not done yet, stop iteration */
 		return 0;
 
 	if (le16_to_cpu(last->control) & DESCRIPTOR_IRQ_ALWAYS)
 		ctx->base.callback.mc(&ctx->base,
 				      le32_to_cpu(last->data_address) +
-				      le16_to_cpu(last->req_count) -
-				      le16_to_cpu(last->res_count),
+				      le16_to_cpu(last->req_count),
 				      ctx->base.callback_data);
 
 	return 1;



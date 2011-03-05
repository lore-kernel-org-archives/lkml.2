Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760401Ab1CEBAU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:00:20 -0500
Received: from kroah.org ([198.145.64.141]:50257 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760362Ab1CEBAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 20:00:17 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar  4 16:56:37 2011
Message-Id: <20110305005637.711450050@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Fri, 04 Mar 2011 16:55:37 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Paul Zimmerman <paulz@synopsys.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [32/73] xhci: Fix an error in count_sg_trbs_needed()
In-Reply-To: <20110305005720.GA16162@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>

commit bcd2fde05341cef0052e49566ec88b406a521cf3 upstream.

The expression

	while (running_total < sg_dma_len(sg))

does not take into account that the remaining data length can be less
than sg_dma_len(sg). In that case, running_total can end up being
greater than the total data length, so an extra TRB is counted.
Changing the expression to

	while (running_total < sg_dma_len(sg) && running_total < temp)

fixes that.

This patch should be queued for stable kernels back to 2.6.31.

Signed-off-by: Paul Zimmerman <paulz@synopsys.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/xhci-ring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2380,7 +2380,7 @@ static unsigned int count_sg_trbs_needed
 			num_trbs++;
 
 		/* How many more 64KB chunks to transfer, how many more TRBs? */
-		while (running_total < sg_dma_len(sg)) {
+		while (running_total < sg_dma_len(sg) && running_total < temp) {
 			num_trbs++;
 			running_total += TRB_MAX_BUFF_SIZE;
 		}



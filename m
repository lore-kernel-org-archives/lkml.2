Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143Ab2JNPDM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 11:03:12 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46428 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932066Ab2JNOnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:43:08 -0400
Message-Id: <20121014143546.758284287@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:37:09 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Tetsuyuki Kobayashi <koba@kmckk.co.jp>, Chris Ball <cjb@laptop.org>
Subject: [ 096/147] mmc: sh-mmcif: avoid oops on spurious interrupts
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

commit 8464dd52d3198dd05cafb005371d76e5339eb842 upstream.

On some systems, e.g., kzm9g, MMCIF interfaces can produce spurious
interrupts without any active request. To prevent the Oops, that results
in such cases, don't dereference the mmc request pointer until we make
sure, that we are indeed processing such a request.

Reported-by: Tetsuyuki Kobayashi <koba@kmckk.co.jp>
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Signed-off-by: Chris Ball <cjb@laptop.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/mmc/host/sh_mmcif.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/mmc/host/sh_mmcif.c
+++ b/drivers/mmc/host/sh_mmcif.c
@@ -1003,6 +1003,10 @@ static irqreturn_t sh_mmcif_intr(int irq
 		host->sd_error = true;
 		dev_dbg(&host->pd->dev, "int err state = %08x\n", state);
 	}
+	if (host->state == STATE_IDLE) {
+		dev_info(&host->pd->dev, "Spurious IRQ status 0x%x", state);
+		return IRQ_HANDLED;
+	}
 	if (state & ~(INT_CMD12RBE | INT_CMD12CRE))
 		complete(&host->intr_wait);
 	else



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933096Ab2JKATQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 20:19:16 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:49714 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933070Ab2JKARD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 20:17:03 -0400
X-Sasl-enc: rf2c9EsbLoLDGTZZD8/N1ao9ZbqAMlZMiUntzGlwivQv 1349914621
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Tetsuyuki Kobayashi <koba@kmckk.co.jp>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Chris Ball <cjb@laptop.org>
Subject: [ 129/133] mmc: sh-mmcif: avoid oops on spurious interrupts
Date: Thu, 11 Oct 2012 07:52:35 +0900
Message-Id: <20121010224917.775401502@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010224854.313159132@linuxfoundation.org>
References: <20121010224854.313159132@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sh_mmcif.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/mmc/host/sh_mmcif.c
+++ b/drivers/mmc/host/sh_mmcif.c
@@ -1191,6 +1191,10 @@ static irqreturn_t sh_mmcif_intr(int irq
 		host->sd_error = true;
 		dev_dbg(&host->pd->dev, "int err state = %08x\n", state);
 	}
+	if (host->state == STATE_IDLE) {
+		dev_info(&host->pd->dev, "Spurious IRQ status 0x%x", state);
+		return IRQ_HANDLED;
+	}
 	if (state & ~(INT_CMD12RBE | INT_CMD12CRE)) {
 		if (!host->dma_active)
 			return IRQ_WAKE_THREAD;



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932295Ab1BYMbA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 07:31:00 -0500
Received: from vs1.gondor.com ([78.47.100.202]:41239 "EHLO
	mail.moria.gondor.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932090Ab1BYMa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 07:30:58 -0500
Date: Fri, 25 Feb 2011 13:30:56 +0100
From: Jan Niehusmann <jan@gondor.com>
To: linux-kernel@vger.kernel.org
Cc: intel-gfx@lists.freedesktop.org, Chris Wilson <chris@chris-wilson.co.uk>
Subject: [PATCH] intel-gtt: fix memory corruption with GM965 and >4GB RAM
Message-ID: <20110225123056.GA3759@x61s.reliablesolutions.de>
References: <20110223233022.GA3439@x61s.reliablesolutions.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110223233022.GA3439@x61s.reliablesolutions.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 12:30:22AM +0100, Jan Niehusmann wrote to
linux-kernel@vger.kernel.org:
> On a Thinkpad x61s, I noticed some memory corruption when
> plugging/unplugging the external VGA connection.
> 
> Symptoms:
> ---------
> 
> 4 bytes at the beginning of a page get overwritten by zeroes. 
> The address of the corruption varies when rebooting the machine, but
> stays constant while it's running (so it's possible to repeatedly write
> some data and then corrupt it again by plugging the cable).

Further investigation revealed that the corrupted address is
(dev_priv->status_page_dmah->busaddr & 0xffffffff), ie. the beginning of
the hardware status page of the i965 graphics card, cut to 32 bits.

So it seems that for some memory access, the hardware uses only 32 bit
addressing. If the hardware status page is located >4GB, this corrupts
unrelated memory.

The corruption was observed on a Thinkpad x61s, using the Mobile Intel
GM965 Express Chipset. The first four bytes of the wrong page are
overwritten with zeroes whenever the VGA cable gets plugged or unplugged.

This patch simply works around this issue by confining the dma memory
to 32 bits.

It's not known if other chipsets are affected as well.

---
 drivers/char/agp/intel-gtt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/agp/intel-gtt.c b/drivers/char/agp/intel-gtt.c
index 29ac6d4..f7977f2 100644
--- a/drivers/char/agp/intel-gtt.c
+++ b/drivers/char/agp/intel-gtt.c
@@ -1379,7 +1379,7 @@ static const struct intel_gtt_driver i965_gtt_driver = {
 	.setup = i9xx_setup,
 	.cleanup = i9xx_cleanup,
 	.write_entry = i965_write_entry,
-	.dma_mask_size = 36,
+	.dma_mask_size = 32,
 	.check_flags = i830_check_flags,
 	.chipset_flush = i9xx_chipset_flush,
 };
-- 
1.7.2.3


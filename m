Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579Ab0JVTRB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:17:01 -0400
Received: from kroah.org ([198.145.64.141]:34093 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759319Ab0JVS4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:56:21 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:30 2010
Message-Id: <20101022185230.845109802@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:51:13 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dave Jiang <dave.jiang@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Maciej Sosnowski <maciej.sosnowski@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [039/103] ioat2: fix performance regression
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

commit c50a898fd4e736623ee175920db056194e0bb483 upstream.

Commit 0793448 "DMAENGINE: generic channel status v2" changed the interface for
how dma channel progress is retrieved.  It inadvertently exported an internal
helper function ioat_tx_status() instead of ioat_dma_tx_status().  The latter
polls the hardware to get the latest completion state, while the helper just
evaluates the current state without touching hardware.  The effect is that we
end up waiting for completion timeouts or descriptor allocation errors before
the completion state is updated.

iperf (before fix):
[SUM]  0.0-41.3 sec   364 MBytes  73.9 Mbits/sec

iperf (after fix):
[SUM]  0.0- 4.5 sec   499 MBytes   940 Mbits/sec

This is a regression starting with 2.6.35.

Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>
Reported-by: Richard Scobie <richard@sauce.co.nz>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/dma/ioat/dma_v2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dma/ioat/dma_v2.c
+++ b/drivers/dma/ioat/dma_v2.c
@@ -879,7 +879,7 @@ int __devinit ioat2_dma_probe(struct ioa
 	dma->device_issue_pending = ioat2_issue_pending;
 	dma->device_alloc_chan_resources = ioat2_alloc_chan_resources;
 	dma->device_free_chan_resources = ioat2_free_chan_resources;
-	dma->device_tx_status = ioat_tx_status;
+	dma->device_tx_status = ioat_dma_tx_status;
 
 	err = ioat_probe(device);
 	if (err)



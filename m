Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932799Ab0JVTLt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:11:49 -0400
Received: from kroah.org ([198.145.64.141]:34151 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759355Ab0JVS42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:56:28 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:31 2010
Message-Id: <20101022185231.569024469@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:51:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Simon Guinot <sguinot@lacie.com>,
        saeed bishara <saeed.bishara@gmail.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [047/103] dmaengine: fix interrupt clearing for mv_xor
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Simon Guinot <sguinot@lacie.com>

commit cc60f8878eab892c03d06b10f389232b9b66bd83 upstream.

When using simultaneously the two DMA channels on a same engine, some
transfers are never completed. For example, an endless lock can occur
while writing heavily on a RAID5 array (with async-tx offload support
enabled).

Note that this issue can also be reproduced by using the DMA test
client.

On a same engine, the interrupt cause register is shared between two
DMA channels. This patch make sure that the cause bit is only cleared
for the requested channel.

Signed-off-by: Simon Guinot <sguinot@lacie.com>
Tested-by: Luc Saillard <luc@saillard.org>
Acked-by: saeed bishara <saeed.bishara@gmail.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/dma/mv_xor.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -162,7 +162,7 @@ static int mv_is_err_intr(u32 intr_cause
 
 static void mv_xor_device_clear_eoc_cause(struct mv_xor_chan *chan)
 {
-	u32 val = (1 << (1 + (chan->idx * 16)));
+	u32 val = ~(1 << (chan->idx * 16));
 	dev_dbg(chan->device->common.dev, "%s, val 0x%08x\n", __func__, val);
 	__raw_writel(val, XOR_INTR_CAUSE(chan));
 }



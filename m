Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab1I0GVZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 02:21:25 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:36156 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766Ab1I0GVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 02:21:24 -0400
Date: Tue, 27 Sep 2011 09:20:50 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] TTY: snyclinkmp: forever loop in tx_load_dma_buffer()
Message-ID: <20110927062050.GA4227@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet23.oracle.com [156.151.31.71]
X-CT-RefId: str=0001.0A090207.4E816B4B.0027,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My main concern here was the line that said:
	copy_count = min_t(unsigned short,count,SCABUFSIZE);
"count" is an unsigned int here so the cast to unsigned short
truncates the upper bits.  So if count is 0x10000 then copy_count is
0 and the loop never exits.

"count" comes from skb->len in hdlcdev_xmit().

The other min_t() changes are just cleanups.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Compile tested only.

diff --git a/drivers/tty/synclinkmp.c b/drivers/tty/synclinkmp.c
index c77831c..0f6b796 100644
--- a/drivers/tty/synclinkmp.c
+++ b/drivers/tty/synclinkmp.c
@@ -4950,7 +4950,7 @@ CheckAgain:
 
 	if ( debug_level >= DEBUG_LEVEL_DATA )
 		trace_block(info,info->rx_buf_list_ex[StartIndex].virt_addr,
-			min_t(int, framesize,SCABUFSIZE),0);
+			min_t(unsigned int, framesize, SCABUFSIZE), 0);
 
 	if (framesize) {
 		if (framesize > info->max_frame_size)
@@ -5015,14 +5015,14 @@ static void tx_load_dma_buffer(SLMP_INFO *info, const char *buf, unsigned int co
 	SCADESC_EX *desc_ex;
 
 	if ( debug_level >= DEBUG_LEVEL_DATA )
-		trace_block(info,buf, min_t(int, count,SCABUFSIZE), 1);
+		trace_block(info, buf, min_t(unsigned int, count, SCABUFSIZE), 1);
 
 	/* Copy source buffer to one or more DMA buffers, starting with
 	 * the first transmit dma buffer.
 	 */
 	for(i=0;;)
 	{
-		copy_count = min_t(unsigned short,count,SCABUFSIZE);
+		copy_count = min_t(unsigned int, count, SCABUFSIZE);
 
 		desc = &info->tx_buf_list[i];
 		desc_ex = &info->tx_buf_list_ex[i];

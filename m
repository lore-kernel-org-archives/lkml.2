Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867Ab2IQLSY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 07:18:24 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:24870 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755789Ab2IQLSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 07:18:23 -0400
Date: Mon, 17 Sep 2012 14:18:19 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Slaby <jslaby@suse.cz>
Subject: [static analysis] memory corruption in tty/synclink.c on 64bit
Message-ID: <20120917111819.GA5769@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't think anyone really cares about this but just for laughs here
is the warning:

drivers/tty/synclink.c:5418 usc_process_rxoverrun_sync() warn: potential memory corrupting cast 8 vs 2 bytes
drivers/tty/synclink.c:6414 mgsl_reset_tx_dma_buffers() warn: potential memory corrupting cast 8 vs 2 bytes
drivers/tty/synclink.c:6455 mgsl_reset_rx_dma_buffers() warn: potential memory corrupting cast 8 vs 2 bytes
drivers/tty/synclink.c:6500 mgsl_free_rx_frame_buffers() warn: potential memory corrupting cast 8 vs 2 bytes

  6489                  /* reset current buffer for reuse */
  6490  //              pBufEntry->status = 0;
  6491  //              pBufEntry->count = DMABUFFERSIZE;
  6492                  *((unsigned long *)&(pBufEntry->count)) = DMABUFFERSIZE;

It looks like the commented out code is the correct code and the code
on line 6492 is the "faster" version?  My static checker complains that
it would corrupt the next struct elements on 64 bit.  Also it only works
on little endian systems.

typedef struct _DMABUFFERENTRY
{
        u32 phys_addr;  /* 32-bit flat physical address of data buffer */
        volatile u16 count;     /* buffer size/data count */
        volatile u16 status;    /* Control/status field */
        volatile u16 rcc;       /* character count field */
        u16 reserved;   /* padding required by 16C32 */

This was there in the original code when it was merged in 2.2.5pre1.

regards,
dan carpenter

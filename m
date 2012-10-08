Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763Ab2JHHNW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 03:13:22 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:49384 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549Ab2JHHNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 03:13:19 -0400
Date: Mon, 8 Oct 2012 10:13:03 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: sbradshaw@micron.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: re: block: Add driver for Micron RealSSD pcie flash cards
Message-ID: <20121008071303.GB17400@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sam Bradshaw,

The patch 88523a61558a: "block: Add driver for Micron RealSSD pcie 
flash cards" from Aug 30, 2011, creates an endian bug:
drivers/block/mtip32xx/mtip32xx.c:2468 mtip_hw_submit_io()

drivers/block/mtip32xx/mtip32xx.c
  2465          fis->opts        = 1 << 7;
  2466          fis->command     =
  2467                  (dir == READ ? ATA_CMD_FPDMA_READ : ATA_CMD_FPDMA_WRITE);
  2468          *((unsigned int *) &fis->lba_low) = (start & 0xFFFFFF);
                                    ^^^^^^^^^^^^
  2469          *((unsigned int *) &fis->lba_low_ex) = ((start >> 24) & 0xFFFFFF);
                                    ^^^^^^^^^^^^^^^

These addresses point to a series of four unions inside the
host_to_dev_fis struct.  The unions will be set to different values
depending on if the CPU is big or little endian.

If you knew which endianness this works on, then you could probably add
a cpu_to_be32() or cpu_to_le32().

  2470          fis->device      = 1 << 6;
  2471          fis->features    = nsect & 0xFF;

regards,
dan carpenter


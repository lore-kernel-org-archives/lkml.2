Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab0EGH2h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 03:28:37 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55747 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533Ab0EGH2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 03:28:35 -0400
From: Nitin Gupta <ngupta@vflare.org>
To: Greg KH <greg@kroah.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Cyp <cyp561@gmail.com>,
       Minchan Kim <minchan.kim@gmail.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Jens Axboe <jens.axboe@oracle.com>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       driverdev <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] ramzswap: Eliminate stale data from compressed memory (v2)
Date: Fri,  7 May 2010 12:55:04 +0530
Message-Id: <1273217107-2023-1-git-send-email-ngupta@vflare.org>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(tested on mainline but should apply to linux-next cleanly)

 * Changelog: v2 vs initial patches
   - directly add swap free callback to block_device_operations
     instead of using 'notifiers' for various swap events.

ramzswap driver creates RAM based block devices which can be
used (only) as swap disks. Pages swapped to these disks are
compressed and stored in memory itself.

However, these devices do not get any notification when a swap
slot is freed (swap_map[i] reaches 0). So, we cannot free memory
allocated corresponding to this swap slot. Such stale data can
quickly accumulate in (compressed) memory defeating the whole
purpose of such devices.

To overcome this problem, we now add a callback in struct
block_device_operations which is called as soon as a swap
slot is freed.

Nitin Gupta (3):
  Add flag to identify block swap devices
  Add swap slot free callback to block_device_operations
  ramzswap: Handler for swap slot free callback

 drivers/staging/ramzswap/TODO           |    5 -----
 drivers/staging/ramzswap/ramzswap_drv.c |   22 +++++++++++++---------
 include/linux/blkdev.h                  |    2 ++
 include/linux/swap.h                    |    1 +
 mm/swapfile.c                           |    5 +++++
 5 files changed, 21 insertions(+), 14 deletions(-)
 delete mode 100644 drivers/staging/ramzswap/TODO


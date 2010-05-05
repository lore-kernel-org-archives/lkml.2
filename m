Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759467Ab0EENtT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 09:49:19 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:44502 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab0EENtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 09:49:18 -0400
From: Nitin Gupta <ngupta@vflare.org>
To: Greg KH <greg@kroah.com>
Cc: Minchan Kim <minchan.kim@gmail.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Cyp <cyp561@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       driverdev <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] ramzswap: Eliminate stale data in compressed memory
Date: Wed,  5 May 2010 19:15:53 +0530
Message-Id: <1273067156-2574-1-git-send-email-ngupta@vflare.org>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(tested on mainline but should apply to linux-next cleanly)

ramzswap driver creates RAM based block devices which can be
used (only) as swap disks. Pages swapped to these disks are
compressed and stored in memory itself.

However, these devices do not get any notification when a swap
slot is freed (swap_map[i] reaches 0). So, we cannot free memory
allocated corresponding to this swap slot. Such stale data can
quickly accumulate in (compressed) memory defeating the whole
purpose of such devices.

To overcome this problem, we now add a callback in 'struct swap_info_struct'
which is called as soon as a swap slot is freed.

Adding handler for this callback:
swapon notifier --> set_swap_free_notify(swap_type, fn)

Removing handler:
swapoff notifier --> set_swap_free_notify(swap_type, NULL)


Alternative approaches:
1) Add callback directly in 'struct block_device_operations' but
that is considered too hacky (nacked by Linus).
2) Use swap discard mechanism: It involves unncessary overhead of
allocating 'discard bio' requests and its too slow to serve ramzswap
needs.

I also tried an approach similar to what Linus suggested:
Create an address_space like swaper_space, so we can catch
read/writes with a_ops->readpage() etc. However, this approach
turned out to be quite difficult and I could not get it to work.

Nitin Gupta (3):
  Add notifiers for swapon and swapoff events
  Send callback when a swap slot is freed
  ramzswap: Register for swap event notifiers and callback

 drivers/staging/ramzswap/TODO           |    5 --
 drivers/staging/ramzswap/ramzswap_drv.c |   79 ++++++++++++++++++++++++++++++-
 include/linux/swap.h                    |   15 ++++++
 mm/swapfile.c                           |   70 +++++++++++++++++++++++++++
 4 files changed, 163 insertions(+), 6 deletions(-)
 delete mode 100644 drivers/staging/ramzswap/TODO


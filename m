Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590Ab1JTPiL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 11:38:11 -0400
Received: from mga03.intel.com ([143.182.124.21]:52461 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756367Ab1JTPiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 11:38:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,379,1315206000"; 
   d="scan'208";a="64588838"
Message-Id: <20111020152240.751936131@intel.com>
User-Agent: quilt/0.48-1
Date: Thu, 20 Oct 2011 23:22:40 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
to: <linux-fsdevel@vger.kernel.org>
cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>
cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/7] writeback: avoid touching dirtied_when on blocked inodes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This tries to keep dirtied_when for blocked inodes by converting some
redirty_tail() calls to requeue_io_wait(). The possibly blocked inodes
will be moved to b_more_io_wait. The b_more_io_wait inodes will now be
retried as dillegent as b_more_io inodes, except when the latter goes empty,
b_more_io_wait will be retried by the kupdate work on increasing intervals
until exceeding dirty_writeback_interval.

Christoph Hellwig (1):
      writeback: avoid redirtying when ->write_inode failed to clear I_DIRTY

Jan Kara (2):
      writeback: update wb->last_active on written pages/inodes
      writeback: Retry kupdate work early if we need to retry some inode writeback

Wu Fengguang (4):
      writeback: introduce queue b_more_io_wait
      writeback: requeue_io_wait() on pages_skipped inode
      writeback: requeue_io_wait() on blocked inode
      writeback: requeue_io_wait() when failed to grab superblock

 fs/fs-writeback.c           |   62 ++++++++++++++++++++++++++++++++++---------
 include/linux/backing-dev.h |    8 +++--
 mm/backing-dev.c            |   10 +++++-
 3 files changed, 62 insertions(+), 18 deletions(-)

Thanks,
Fengguang


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911Ab2GEQCK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 12:02:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49372 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890Ab2GEQCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 12:02:08 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: snitzer@redhat.com, david@fromorbit.com, dm-devel@redhat.com,
        xfs@oss.sgi.com, hch@lst.de, martin.petersen@oracle.com,
        axboe@kernel.dk, vgoyal@redhat.com
Subject: [PATCH v3 0/2] block: improvements for discard alignment
Date: Thu,  5 Jul 2012 18:01:42 +0200
Message-Id: <1341504104-1674-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.7.10.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a disk has a large discard_granularity, discards are not split with
optimal alignment; the pessimization gets bigger as discard_granularity
and max_discard_sectors become closer.

Take the limit case of discard_granularity == max_discard_sectors == 64.
Then, if a request is submitted for 256 sectors 2..257 it will be split
like this: 2..65, 66..129, 130..193, 194..257.  None of these requests
is aligned, so in fact you might end up with no discarded logical blocks
at all.  With this patch, the split will be 2..63, 64..127, 128..191,
192..255, 256..257.  The patches also take the discard_alignment into
consideration.

Patch 1 adjusts the computation of the granularity-adjusted
max_discard_sectors so that it prepares for the new code in patch 2,
which actually adjusts the split.

v2->v3: drop addition of queue/discard_alignment to sysfs, use
  correct alignment for partitions

Paolo Bonzini (2):
  block: reorganize rounding of max_discard_sectors
  block: split discard into aligned requests

 block/blk-lib.c        |   41 ++++++++++++++++++++++++++++-------------
 include/linux/blkdev.h |   10 ++++++++++
 2 files changed, 38 insertions(+), 13 deletions(-)


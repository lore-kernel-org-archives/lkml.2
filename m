Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741Ab2GBNUd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 09:20:33 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63756 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab2GBNUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 09:20:32 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: snitzer@redhat.com, david@fromorbit.com, dm-devel@redhat.com,
        xfs@oss.sgi.com, hch@lst.de, martin.petersen@oracle.com,
        axboe@kernel.dk
Subject: [PATCH v2 0/3] block: improvements for discard alignment
Date: Mon,  2 Jul 2012 15:20:22 +0200
Message-Id: <1341235225-27551-1-git-send-email-pbonzini@redhat.com>
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

For ease of debugging, patch 1 adds a sysfs entry for discard_alignment.
Patch 2 adjusts the computation of the granularity-adjusted
max_discard_sectors so that it prepares for the new code in patch 3,
which 3 actually adjusts the split.

v1->v2: added patch 1, fixed line length

Paolo Bonzini (3):
  block: add sysfs entry for discard_alignment
  block: reorganize rounding of max_discard_sectors
  block: split discard into aligned requests

 block/blk-lib.c   |   41 ++++++++++++++++++++++++++++-------------
 block/blk-sysfs.c |   11 +++++++++++
 2 files changed, 39 insertions(+), 13 deletions(-)


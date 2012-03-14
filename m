Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761221Ab2CNRMl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 13:12:41 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:39847 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759471Ab2CNRMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 13:12:40 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 0/2] block: align start sector of a discard request
Date: Wed, 14 Mar 2012 18:12:26 +0100
Message-Id: <1331745148-24885-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.7.7.6
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
while patch 2 actually adjusts the split.

Paolo Bonzini (2):
  block: tweak rounding of max_discard_sectors
  block: split discard into aligned requests

 block/blk-lib.c    |   41 +++++++++++++++++++++++++++--------------
 1 files changed, 27 insertions(+), 14 deletions(-)

-- 
1.7.7.6


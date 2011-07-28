Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843Ab1G1XoJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 19:44:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:30203 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755661Ab1G1XoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 19:44:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,285,1309762800"; 
   d="scan'208";a="33351630"
From: Andi Kleen <andi@firstfloor.org>
References: <20110728444.299940435@firstfloor.org>
In-Reply-To: <20110728444.299940435@firstfloor.org>
To: peterz@infradead.org, fengguang.wu@intel.com, miklos@szeredi.hu,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [3/50] mm/backing-dev.c: reset bdi min_ratio in bdi_unregister()
Message-Id: <20110728234407.5B7032403FF@tassilo.jf.intel.com>
Date: Thu, 28 Jul 2011 16:44:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Peter Zijlstra <peterz@infradead.org>

[ upstream commit ccb6108f5b0b541d3eb332c3a73e645c0f84278e ]

Vito said:

: The system has many usb disks coming and going day to day, with their
: respective bdi's having min_ratio set to 1 when inserted.  It works for
: some time until eventually min_ratio can no longer be set, even when the
: active set of bdi's seen in /sys/class/bdi/*/min_ratio doesn't add up to
: anywhere near 100.
:
: This then leads to an unrelated starvation problem caused by write-heavy
: fuse mounts being used atop the usb disks, a problem the min_ratio setting
: at the underlying devices bdi effectively prevents.

Fix this leakage by resetting the bdi min_ratio when unregistering the
BDI.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Reported-by: Vito Caputo <lkml@pengaru.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.35.y/mm/backing-dev.c
===================================================================
--- linux-2.6.35.y.orig/mm/backing-dev.c
+++ linux-2.6.35.y/mm/backing-dev.c
@@ -646,6 +646,7 @@ static void bdi_prune_sb(struct backing_
 void bdi_unregister(struct backing_dev_info *bdi)
 {
 	if (bdi->dev) {
+		bdi_set_min_ratio(bdi, 0);
 		bdi_prune_sb(bdi);
 
 		if (!bdi_cap_flush_forker(bdi))

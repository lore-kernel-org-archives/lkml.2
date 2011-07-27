Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164Ab1G0WGV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 18:06:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:24579 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755506Ab1G0Vse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:48:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,278,1309762800"; 
   d="scan'208";a="30900554"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: Artem.Bityutskiy@nokia.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [34/99] UBIFS: fix shrinker object count reports
Message-Id: <20110727214832.E64A02403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:48:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

commit cf610bf4199770420629d3bc273494bd27ad6c1d upstream.

Sometimes VM asks the shrinker to return amount of objects it can shrink,
and we return the ubifs_clean_zn_cnt in that case. However, it is possible
that this counter is negative for a short period of time, due to the way
UBIFS TNC code updates it. And I can observe the following warnings sometimes:

shrink_slab: ubifs_shrinker+0x0/0x2b7 [ubifs] negative objects to delete nr=-8541616642706119788

This patch makes sure UBIFS never returns negative count of objects.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/ubifs/shrinker.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: linux-2.6.35.y/fs/ubifs/shrinker.c
===================================================================
--- linux-2.6.35.y.orig/fs/ubifs/shrinker.c
+++ linux-2.6.35.y/fs/ubifs/shrinker.c
@@ -283,7 +283,11 @@ int ubifs_shrinker(struct shrinker *shri
 	long clean_zn_cnt = atomic_long_read(&ubifs_clean_zn_cnt);
 
 	if (nr == 0)
-		return clean_zn_cnt;
+		/*
+		 * Due to the way UBIFS updates the clean znode counter it may
+		 * temporarily be negative.
+		 */
+		return clean_zn_cnt >= 0 ? clean_zn_cnt : 1;
 
 	if (!clean_zn_cnt) {
 		/*

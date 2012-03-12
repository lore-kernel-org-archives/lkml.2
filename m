Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658Ab2CLAxR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 20:53:17 -0400
Received: from 1wt.eu ([62.212.114.60]:63122 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754643Ab2CLAtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 20:49:04 -0400
Message-Id: <20120312004411.765493549@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 Mar 2012 01:44:22 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 11/13] lib: proportion: lower PROP_MAX_SHIFT to 32 on 64-bit kernel
In-Reply-To: <fec4dd6c17083169f2e217caca7375ef@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Wu Fengguang <fengguang.wu@intel.com>

commit 3310225dfc71a35a2cc9340c15c0e08b14b3c754 upstream.

PROP_MAX_SHIFT should be set to <=32 on 64-bit box. This fixes two bugs
in the below lines of bdi_dirty_limit():

	bdi_dirty *= numerator;
	do_div(bdi_dirty, denominator);

1) divide error: do_div() only uses the lower 32 bit of the denominator,
   which may trimmed to be 0 when PROP_MAX_SHIFT > 32.

2) overflow: (bdi_dirty * numerator) could easily overflow if numerator
   used up to 48 bits, leaving only 16 bits to bdi_dirty

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reported-by: Ilya Tumaykin <librarian_rus@yahoo.com>
Tested-by: Ilya Tumaykin <librarian_rus@yahoo.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/proportions.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/proportions.h b/include/linux/proportions.h
index cf793bb..22653d7 100644
--- a/include/linux/proportions.h
+++ b/include/linux/proportions.h
@@ -81,7 +81,11 @@ void prop_inc_percpu(struct prop_descriptor *pd, struct prop_local_percpu *pl)
  * Limit the time part in order to ensure there are some bits left for the
  * cycle counter and fraction multiply.
  */
+#if BITS_PER_LONG == 32
 #define PROP_MAX_SHIFT (3*BITS_PER_LONG/4)
+#else
+#define PROP_MAX_SHIFT (BITS_PER_LONG/2)
+#endif
 
 #define PROP_FRAC_SHIFT		(BITS_PER_LONG - PROP_MAX_SHIFT - 1)
 #define PROP_FRAC_BASE		(1UL << PROP_FRAC_SHIFT)
-- 
1.7.2.1.45.g54fbc




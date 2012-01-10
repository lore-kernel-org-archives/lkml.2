Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756435Ab2AJOzJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 09:55:09 -0500
Received: from mga14.intel.com ([143.182.124.37]:25618 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755803Ab2AJOzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 09:55:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="94309099"
Date: Tue, 10 Jan 2012 22:54:55 +0800
From: Wu Fengguang <wfg@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: =?utf-8?B?0JjQu9GM0Y8g0KLRg9C80LDQudC60LjQvQ==?= 
	<librarian_rus@yahoo.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Jan Kara <jack@suse.cz>
Subject: [PATCH] lib: proportion: lower PROP_MAX_SHIFT to 32 on 64-bit
 kernel
Message-ID: <20120110145455.GA8999@localhost>
References: <1325884395.57034.YahooMailClassic@web161605.mail.bf1.yahoo.com>
 <20120107145645.GA4997@localhost>
 <1325954125.2442.27.camel@twins>
 <20120108023305.GA5074@localhost>
 <1326017954.2442.35.camel@twins>
 <20120109045515.GB3976@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120109045515.GB3976@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PROP_MAX_SHIFT should be set to <=32 on 64-bit box. This fixes two bugs
in the below lines of bdi_dirty_limit():

	bdi_dirty *= numerator;
	do_div(bdi_dirty, denominator);

1) divide error: do_div() only uses the lower 32 bit of the denominator,
   which may trimmed to be 0 when PROP_MAX_SHIFT > 32.

2) overflow: (bdi_dirty * numerator) could easily overflow if numerator
   used up to 48 bits, leaving only 16 bits to bdi_dirty

Tested-by: Ilya Tumaykin <librarian_rus@yahoo.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/linux/proportions.h |    4 ++++
 1 file changed, 4 insertions(+)

--- linux.orig/include/linux/proportions.h	2012-01-09 11:51:19.000000000 +0800
+++ linux/include/linux/proportions.h	2012-01-09 11:53:47.000000000 +0800
@@ -81,7 +81,11 @@ void prop_inc_percpu(struct prop_descrip
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

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739Ab2BQA7y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 19:59:54 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:40399 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756672Ab2BQA7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 19:59:51 -0500
X-Sasl-enc: tULQbr/woAvvxsFY/HSQlq94caUx5KyJJrkhE0hAvWwj 1329440390
X-Mailbox-Line: From gregkh@linuxfoundation.org Thu Feb 16 16:55:35 2012
Message-Id: <20120217005535.717857148@linuxfoundation.org>
User-Agent: quilt/0.51-15.1
Date: Thu, 16 Feb 2012 16:55:46 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ilya Tumaykin <librarian_rus@yahoo.com>,
        Wu Fengguang <fengguang.wu@intel.com>
Subject: [12/28] lib: proportion: lower PROP_MAX_SHIFT to 32 on 64-bit kernel
In-Reply-To: <20120217005609.GA17081@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
 1 file changed, 4 insertions(+)

--- a/include/linux/proportions.h
+++ b/include/linux/proportions.h
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



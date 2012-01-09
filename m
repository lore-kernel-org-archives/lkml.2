Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416Ab2AIEH7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 23:07:59 -0500
Received: from mga03.intel.com ([143.182.124.21]:49687 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755366Ab2AIEH6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 23:07:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="93731715"
Date: Mon, 9 Jan 2012 12:04:45 +0800
From: Wu Fengguang <wfg@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: =?utf-8?B?0JjQu9GM0Y8g0KLRg9C80LDQudC60LjQvQ==?= 
	<librarian_rus@yahoo.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: Re: A regression in recent 3.2 kernel: bdi_dirty_limit() divide
 error
Message-ID: <20120109040445.GB31049@localhost>
References: <1325884395.57034.YahooMailClassic@web161605.mail.bf1.yahoo.com>
 <20120107145645.GA4997@localhost>
 <1325954125.2442.27.camel@twins>
 <20120108023305.GA5074@localhost>
 <1326017954.2442.35.camel@twins>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="tjCHc7DPkfUGtrlw"
Content-Disposition: inline
In-Reply-To: <1326017954.2442.35.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tjCHc7DPkfUGtrlw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jan 08, 2012 at 11:19:14AM +0100, Peter Zijlstra wrote:

> But even then, we limit PROP_MAX_SHIFT to 3*BITS_PER_LONG/4, I don't
> think that could ever overflow.

do_div() only uses the lower 32 bit value of the 64 bit denominator,
which may happen to be 0.

The denominator is not really 64 bit, but limited by PROP_MAX_SHIFT =
48 bit, however that upper limit looks not enough.

Ilya, would you help try the attached patch instead?

Thanks,
Fengguang

--tjCHc7DPkfUGtrlw
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="proportion-max-shift.patch"

Subject: 
Date: Mon Jan 09 11:53:50 CST 2012


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

--tjCHc7DPkfUGtrlw--

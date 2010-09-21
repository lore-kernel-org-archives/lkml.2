Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714Ab0IUIFK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 04:05:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:22208 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755945Ab0IUIFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 04:05:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,398,1280732400"; 
   d="scan'208";a="839491409"
Date: Tue, 21 Sep 2010 16:04:59 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Kenneth <liguozhu@huawei.com>, greg@kroah.com,
        linux-kernel@vger.kernel.org,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: Problem with debugfs
Message-ID: <20100921080459.GA29540@localhost>
References: <20100921022112.GA10336@localhost>
 <20100921061310.GA11526@localhost>
 <20100921162316.3C03.A69D9226@jp.fujitsu.com>
 <31aed4ad96866a97dc791186303c5719.squirrel@www.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31aed4ad96866a97dc791186303c5719.squirrel@www.firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 21, 2010 at 09:31:58AM +0200, Andi Kleen wrote:
> x
> 
> >> I'm sorry I had not checked the git before sending my last mail.
> >>
> >> For the problem I mention, consider this scenarios:
> >>
> >> 1. mm/hwpoinson-inject.c create a debugfs file with
> >>    debugfs_create_u64("corrupt-filter-flags-mask", ...,
> >>    &hwpoison_filter_flags_mask)
> >> 2. hwpoison_filter_flags_mask is supposed to be protected by
> >> filp->priv->mutex
> >>    of this file when it is accessed from user space.
> >> 3. but when it is accessed from
> >> mm/memory-failure.c:hwpoison_filter_flags,
> >>    there is no way for the function to protect the operation (so it
> >> simply
> >>    ignore it). This may create a competition problem.
> >>
> >> It should be a problem.

Thanks for the report.  Did this show up as a real bug? What's your
use case? Or is it a theoretic concern raised when doing code review?

Yeah the hwpoison_filter_flags_* values are not referenced strictly
safe to concurrent updates. I didn't care it because the typical usage
is for hwpoison test tools to _first_ echo hwpoison_filter_flags_*
values into the debugfs and _then_ start injecting hwpoison errors.
Otherwise you cannot get reliable test results. The updated value is
guaranteed to be visible because there are file mutex UNLOCK and page
LOCK operations in between.

Thanks,
Fengguang

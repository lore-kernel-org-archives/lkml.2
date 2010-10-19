Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005Ab0JSCfk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 22:35:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:25884 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753430Ab0JSCfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 22:35:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,348,1283756400"; 
   d="scan'208";a="618041627"
Date: Tue, 19 Oct 2010 10:35:37 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>, Neil Brown <neilb@suse.de>,
        Rik van Riel <riel@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Li, Shaohua" <shaohua.li@intel.com>
Subject: Re: Deadlock possibly caused by too_many_isolated.
Message-ID: <20101019023537.GB8310@localhost>
References: <20101019093142.509d6947@notabene>
 <20101018154137.90f5325f.akpm@linux-foundation.org>
 <20101019095144.A1B0.A69D9226@jp.fujitsu.com>
 <AANLkTin38qJ-U3B7XwMh-3aR9zRs21LgR1yHfqYifxrn@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin38qJ-U3B7XwMh-3aR9zRs21LgR1yHfqYifxrn@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -2054,10 +2069,11 @@ rebalance:
>                 goto got_pg;
> 
>         /*
> -        * If we failed to make any progress reclaiming, then we are
> -        * running out of options and have to consider going OOM
> +        * If we failed to make any progress reclaiming and there aren't
> +        * many parallel reclaiming, then we are unning out of options and
> +        * have to consider going OOM
>          */
> -       if (!did_some_progress) {
> +       if (!did_some_progress && !too_many_isolated_zone(preferred_zone)) {
>                 if ((gfp_mask & __GFP_FS) && !(gfp_mask & __GFP_NORETRY)) {
>                         if (oom_killer_disabled)
>                                 goto nopage;

This is simply wrong.

It disabled this block for 99% system because there won't be enough
tasks to make (!too_many_isolated_zone == true). As a result the LRU
will be scanned like mad and no task get OOMed when it should be.

Thanks,
Fengguang

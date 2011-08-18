Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861Ab1HRNNu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 09:13:50 -0400
Received: from mga14.intel.com ([143.182.124.37]:61866 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755240Ab1HRNNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 09:13:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,245,1312182000"; 
   d="scan'208";a="39818450"
Date: Thu, 18 Aug 2011 21:13:43 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Kautuk Consul <consul.kautuk@gmail.com>, Mel Gorman <mgorman@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>
Subject: Re: [PATCH] writeback: Per-block device
 bdi->dirty_writeback_interval and bdi->dirty_expire_interval.
Message-ID: <20110818131343.GA17473@localhost>
References: <CAFPAmTSrh4r71eQqW-+_nS2KFK2S2RQvYBEpa3QnNkZBy8ncbw@mail.gmail.com>
 <20110818094824.GA25752@localhost>
 <1313669702.6607.24.camel@sauron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313669702.6607.24.camel@sauron>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Artem,

> Here is a real use-case we had when developing the N900 phone. We had
> internal flash and external microSD slot. Internal flash is soldered in
> and cannot be removed by the user. MicroSD, in contrast, can be removed
> by the user.
> 
> For the internal flash we wanted long intervals and relaxed limits to
> gain better performance.
> 
> For MicroSD we wanted very short intervals and tough limits to make sure
> that if the user suddenly removes his microSD (users do this all the
> time) - we do not lose data.

Thinking twice about it, I find that the different requirements for
interval flash/external microSD can also be solved by this scheme.

Introduce a per-bdi dirty_background_time (and optionally dirty_time)
as the counterpart of (and works in parallel to) global dirty[_background]_ratio,
however with unit "milliseconds worth of data".

The per-bdi dirty_background_time will be set low for external microSD
and high for internal flash. Then you get timely writeouts for microSD
and reasonably delayed writes for internal flash (controllable by the
global dirty_expire_centisecs).

The dirty_background_time will actually work more reliable than
dirty_expire_centisecs because it will checked immediately after the
application dirties more pages. And the dirty_time could provide
strong data integrity guarantee -- much stronger than
dirty_expire_centisecs -- if used.

Does that sound reasonable?

Thanks,
Fengguang

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758366Ab2FOWnM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 18:43:12 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:28979 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754239Ab2FOWnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 18:43:08 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ak0JACW52095LKmV/2dsb2JhbABFtCYEgSyBCIIYAQEFOhwjEAgDGC4UJQMhE4gKuV0UiyIVNoVwA5UjiSWGWYJygUU
Date: Sat, 16 Jun 2012 08:43:06 +1000
From: Dave Chinner <david@fromorbit.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, Wanpeng Li <liwp.linux@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gavin Shan <shangw@linux.vnet.ibm.com>
Subject: Re: [PATCH V2] writeback: fix hung_task alarm when sync block
Message-ID: <20120615224306.GG19223@dastard>
References: <1339562553-10035-1-git-send-email-liwp.linux@gmail.com>
 <x49txyf8exl.fsf@segfault.boston.devel.redhat.com>
 <20120613144840.GA3055@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120613144840.GA3055@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 10:48:40PM +0800, Fengguang Wu wrote:
> > This really feels like we're papering over the problem.
> 
> That's true. The majority users probably don't want to cache 100s
> worth of data in memory. It may be worthwhile to add a new per-bdi
> limit whose unit is number-of-seconds (of dirty data).

Doesn't work. You have a BBWC that takes in 500MB of random 4k
writes in a second, then starts to flush and needs to do a RMW cycle
for every 4k write it cached. On RAID5/6, the flush rate will be
about 100 IOPS, so it could take half an hour to flush those writes
that took a second to dump into the cache. IO for that entire half
hour will be extremely slow, and if you isue a sync during it, then
that's when you get a hung task timer.

Limiting the amount of writeback to a few seconds of IO simply won't
fix this - the ingest rate of BBWCs is simply too great to prevent
such events by a slow moving bandwidth throttle....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757643Ab0DOJcZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 05:32:25 -0400
Received: from bld-mail12.adl6.internode.on.net ([150.101.137.97]:35750 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757560Ab0DOJcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 05:32:24 -0400
Date: Thu, 15 Apr 2010 19:32:14 +1000
From: Dave Chinner <david@fromorbit.com>
To: Suleiman Souhlal <ssouhlal@freebsd.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, Chris Mason <chris.mason@oracle.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, suleiman@google.com
Subject: Re: [PATCH 1/4] vmscan: delegate pageout io to flusher thread if
 current is kswapd
Message-ID: <20100415093214.GV2493@dastard>
References: <20100415013436.GO2493@dastard>
 <20100415130212.D16E.A69D9226@jp.fujitsu.com>
 <20100415131106.D174.A69D9226@jp.fujitsu.com>
 <64BE60A8-EEF9-4AC6-AF0A-0ED3CB544726@freebsd.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64BE60A8-EEF9-4AC6-AF0A-0ED3CB544726@freebsd.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 15, 2010 at 01:05:57AM -0700, Suleiman Souhlal wrote:
> 
> On Apr 14, 2010, at 9:11 PM, KOSAKI Motohiro wrote:
> 
> >Now, vmscan pageout() is one of IO throuput degression source.
> >Some IO workload makes very much order-0 allocation and reclaim
> >and pageout's 4K IOs are making annoying lots seeks.
> >
> >At least, kswapd can avoid such pageout() because kswapd don't
> >need to consider OOM-Killer situation. that's no risk.
> >
> >Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 
> What's your opinion on trying to cluster the writes done by pageout,
> instead of not doing any paging out in kswapd?

XFS already does this in ->writepage to try to minimise the impact
of the way pageout issues IO. It helps, but it is still not as good
as having all the writeback come from the flusher threads because
it's still pretty much random IO.

And, FWIW, it doesn't solve the stack usage problems, either. In
fact, it will make them worse as write_one_page() puts another
struct writeback_control on the stack...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

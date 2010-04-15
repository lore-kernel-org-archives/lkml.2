Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757687Ab0DOJlq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 05:41:46 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:54125 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757641Ab0DOJlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 05:41:45 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/4] vmscan: delegate pageout io to flusher thread if current is kswapd
Cc: kosaki.motohiro@jp.fujitsu.com, Suleiman Souhlal <ssouhlal@freebsd.org>,
       Mel Gorman <mel@csn.ul.ie>, Chris Mason <chris.mason@oracle.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, suleiman@google.com
In-Reply-To: <20100415093214.GV2493@dastard>
References: <64BE60A8-EEF9-4AC6-AF0A-0ED3CB544726@freebsd.org> <20100415093214.GV2493@dastard>
Message-Id: <20100415183425.D19E.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 15 Apr 2010 18:41:39 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Apr 15, 2010 at 01:05:57AM -0700, Suleiman Souhlal wrote:
> > 
> > On Apr 14, 2010, at 9:11 PM, KOSAKI Motohiro wrote:
> > 
> > >Now, vmscan pageout() is one of IO throuput degression source.
> > >Some IO workload makes very much order-0 allocation and reclaim
> > >and pageout's 4K IOs are making annoying lots seeks.
> > >
> > >At least, kswapd can avoid such pageout() because kswapd don't
> > >need to consider OOM-Killer situation. that's no risk.
> > >
> > >Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > 
> > What's your opinion on trying to cluster the writes done by pageout,
> > instead of not doing any paging out in kswapd?
> 
> XFS already does this in ->writepage to try to minimise the impact
> of the way pageout issues IO. It helps, but it is still not as good
> as having all the writeback come from the flusher threads because
> it's still pretty much random IO.

I havent review such patch yet. then, I'm talking about generic thing.
pageout() doesn't only writeout file backed page, but also write
swap backed page. so, filesystem optimization nor flusher thread
doesn't erase pageout clusterring worth.


> And, FWIW, it doesn't solve the stack usage problems, either. In
> fact, it will make them worse as write_one_page() puts another
> struct writeback_control on the stack...

Correct. we need to avoid double writeback_control on stack.
probably, we need to divide pageout() some piece.




Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725Ab1GTT2j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 15:28:39 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:20072 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752460Ab1GTT2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 15:28:37 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: WVJdxMEVM1kjyJCwBT9HjSLmF7ASXFOQtVhTdwrRG.AWuf4
 FrLaMF0VN5FHwOAnFrOMhkJJXnjXoSZ.IEZZ9G2ouZ3IcgtKkWCWlO4PqA5b
 YnUueAlKhAsDyuhdSGsY5vk01vjkIInDg8cigwBbKSeIPcbjDDZCA.XlVRhm
 0gfmZtyV.adJn.sADFAeY3pZ0t1Ka8Mxuct_HQXA23QAwt9_qncsyusVFYUe
 4Mfwcd12u6emlRC1R1GU93r4AScyyo7GpRo4UPon_vPhDUPlR7rl7WCTZgSR
 zm811bRwQVfgo8wmvLdkwc2vhmqotuELAcgoYZ2E4hGr6etEHKyxAmvny.Gx
 8pVf26YwlOQAOjneMGXHHd5rP
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 20 Jul 2011 14:28:32 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mel Gorman <mgorman@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: page allocator: Initialise ZLC for first zone
 eligible for zone_reclaim
In-Reply-To: <20110720191858.GO5349@suse.de>
Message-ID: <alpine.DEB.2.00.1107201425200.1472@router.home>
References: <1310742540-22780-1-git-send-email-mgorman@suse.de> <1310742540-22780-2-git-send-email-mgorman@suse.de> <alpine.DEB.2.00.1107180951390.30392@router.home> <20110718160552.GB5349@suse.de> <alpine.DEB.2.00.1107181208050.31576@router.home>
 <20110718211325.GC5349@suse.de> <alpine.DEB.2.00.1107181651000.31576@router.home> <alpine.DEB.2.00.1107190901120.1199@router.home> <alpine.DEB.2.00.1107201307530.1472@router.home> <20110720191858.GO5349@suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jul 2011, Mel Gorman wrote:

> On Wed, Jul 20, 2011 at 01:08:46PM -0500, Christoph Lameter wrote:
> > Hmmm... Looking at get_page_from_freelist and considering speeding that up
> > in general: Could we move the whole watermark logic into the slow path?
> > Only check when we refill the per cpu queues?
>
> Each CPU list can hold 186 pages (on my currently running
> kernel at least) which is 744K. As I'm running with THP enabled,
> the min watermark is 25852K so with 34 of more CPUs, there is a
> risk that a zone would be fully depleted due to lack of watermark
> checking. Bit unlikely that 34 CPUs would be on one node but the risk
> is there. Without THP, the min watermark would have been something like
> 32K where it would be much easier to accidentally consume all memory.
>
> Yes, moving the watermark checks to the slow path would be faster
> but under some conditions, the system will lock up.

Well the fastpath would simply grab a page if its on the list. If the list
is empty then we would be checking the watermarks and extract pages from
the buddylists. The pages in the per cpu lists would not be accounted for
for reclaim. Counters would reflect the buddy allocator pages available.
Reclaim  flushes the per cpu pages so the buddy allocator pages would be
replenished.



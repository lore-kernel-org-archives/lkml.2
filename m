Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631Ab0GMEse (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 00:48:34 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37495 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab0GMEsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 00:48:32 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH] vmscan: stop meaningless loop iteration when no  reclaimable slab
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>
In-Reply-To: <AANLkTilA2rzWVVLqDQjhivHmnt0ZfaQBGEDh2TU6OfcJ@mail.gmail.com>
References: <20100709195625.FA28.A69D9226@jp.fujitsu.com> <AANLkTilA2rzWVVLqDQjhivHmnt0ZfaQBGEDh2TU6OfcJ@mail.gmail.com>
Message-Id: <20100712101237.EA0E.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 13 Jul 2010 13:48:24 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> 
> old shrink_slab
> 
> shrinker->nr += delta; /* Add delta to previous shrinker's remained count */
> total_scan = shrinker->nr;
> 
> while(total_scan >= SHRINK_BATCH) {
> 	nr_before = shrink(xxx);
> 	total_scan =- this_scan;
> }
> 
> shrinker->nr += total_scan;
> 
> The total_scan can always be the number < SHRINK_BATCH.
> So, when next shrinker calcuates loop count, the number can affect.

Correct.


> 
> new shrink_slab
> 
> shrinker->nr += delta; /* nr is always zero by your patch */

no.
my patch don't change delta calculation at all.


> total_scan = shrinker->nr;
> 
> while(total_scan >= SHRINK_BATCH) {
> 	nr_before = shrink(xxx);
> 	if (nr_before == 0) {
> 		total_scan = 0;
> 		break;
> 	}
> }
> 
> shrinker->nr += 0;
> 
> But after your patch, total_scan is always zero. It never affect
> next shrinker's loop count.

No. after my patch this loop has two exiting way
 1) total_scan are less than SHRINK_BATCH.
      -> no behavior change.  we still pass shrinker->nr += total_scan code.
 2) (*shrinker->shrink)(0, gfp_mask) return 0
      don't increase shrinker->nr.  because two reason,
      a) if total_scan are 10000,  we shouldn't carry over such big number.
      b) now, we have zero slab objects, then we have been freed form the guilty of keeping
          balance page and slab reclaim. shrinker->nr += 0; have zero side effect.

Thanks.

> 
> Am I missing something?
> -- 
> Kind regards,
> Minchan Kim




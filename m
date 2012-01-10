Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486Ab2AJP6H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 10:58:07 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:65390 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756349Ab2AJP6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 10:58:05 -0500
MIME-Version: 1.0
In-Reply-To: <20120110094452.GC4118@suse.de>
References: <CAJd=RBAqzawZ=jEFt7TrZgU0gaejMkfiBxzH7Y19qqNnsZrJGw@mail.gmail.com>
	<20120110094452.GC4118@suse.de>
Date: Tue, 10 Jan 2012 23:58:03 +0800
Message-ID: <CAJd=RBA7vj83SFQFMS5WaRCfz2ndGJXepBqi5tK0LPjnBYYgfg@mail.gmail.com>
Subject: Re: [PATCH] mm: vmscan: fix setting reclaim mode
From: Hillf Danton <dhillf@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 10, 2012 at 5:44 PM, Mel Gorman <mgorman@suse.de> wrote:
> On Sun, Jan 08, 2012 at 03:05:03PM +0800, Hillf Danton wrote:
>> The check for under memory pressure is corrected, then lumpy reclaim or
>> reclaim/compaction could be avoided either when for order-O reclaim or
>> when free pages are already low enough.
>>
>
> No explanation of problem, how this patch fixes it or what the impact
> is.
>
> At a glance, this will have the impact of using sync reclaim at low
> reclaim priorities. This is unexpected so needs much better explanation.
>

Hi Mel

It is reprepared, please review again.

Thanks
Hillf

===cut please===
From: Hillf Danton <dhillf@gmail.com>
[PATCH] mm: vmscan: fix setting reclaim mode

The comment says, initially assume we are entering either lumpy reclaim or
reclaim/compaction, and depending on the reclaim order, we will either set the
sync mode or just reclaim order-0 pages later.

On other hand, order-0 reclaim, instead of sync reclaim, is expected when
under memory pressure, but the check for memory pressure is incorrect,
leading to sync reclaim at low reclaim priorities.

And the result is sync reclaim is set for high priorities.


Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/mm/vmscan.c	Thu Dec 29 20:20:16 2011
+++ b/mm/vmscan.c	Tue Jan 10 23:03:48 2012
@@ -387,7 +387,7 @@ static void set_reclaim_mode(int priorit
 	 */
 	if (sc->order > PAGE_ALLOC_COSTLY_ORDER)
 		sc->reclaim_mode |= syncmode;
-	else if (sc->order && priority < DEF_PRIORITY - 2)
+	else if (sc->order && priority >= DEF_PRIORITY - 2)
 		sc->reclaim_mode |= syncmode;
 	else
 		sc->reclaim_mode = RECLAIM_MODE_SINGLE | RECLAIM_MODE_ASYNC;

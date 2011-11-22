Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406Ab1KVKO4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 05:14:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42755 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034Ab1KVKOz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 05:14:55 -0500
Date: Tue, 22 Nov 2011 10:14:51 +0000
From: Mel Gorman <mgorman@suse.de>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Linux-MM <linux-mm@kvack.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>, Jan Kara <jack@suse.cz>,
        Andy Isaacson <adi@hexapodia.org>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Nai Xia <nai.xia@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/7] mm: compaction: Introduce sync-light migration for
 use by compaction
Message-ID: <20111122101451.GJ19415@suse.de>
References: <1321900608-27687-1-git-send-email-mgorman@suse.de>
 <1321900608-27687-8-git-send-email-mgorman@suse.de>
 <1321945011.22361.335.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1321945011.22361.335.camel@sli10-conroe>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 02:56:51PM +0800, Shaohua Li wrote:
> On Tue, 2011-11-22 at 02:36 +0800, Mel Gorman wrote:
> > This patch adds a lightweight sync migrate operation MIGRATE_SYNC_LIGHT
> > mode that avoids writing back pages to backing storage. Async
> > compaction maps to MIGRATE_ASYNC while sync compaction maps to
> > MIGRATE_SYNC_LIGHT. For other migrate_pages users such as memory
> > hotplug, MIGRATE_SYNC is used.
> > 
> > This avoids sync compaction stalling for an excessive length of time,
> > particularly when copying files to a USB stick where there might be
> > a large number of dirty pages backed by a filesystem that does not
> > support ->writepages.
> Hi,
> from my understanding, with this, even writes
> to /proc/sys/vm/compact_memory doesn't wait for pageout, is this
> intended?

For the moment yes so that manual and automatic compaction behave
similarly. For example, if one runs a workload that periodically
tries to fault transparent hugepages and it steadily gets X huge
pages and running manual compaction gets more, it can indicate a bug
in how and when compaction runs. If manual compaction is significantly
different, the comparison is not as useful. I know this is a bit weak
as an example but right now there is no strong motivation right now
for manual compaction to use MIGRATE_SYNC.

> on the other hand, MIGRATE_SYNC_LIGHT now waits for pagelock and buffer
> lock, so could wait on page read. page read and page out have the same
> latency, why takes them different?
> 

That's a very reasonable question.

To date, the stalls that were reported to be a problem were related to
heavy writing workloads. Workloads are naturally throttled on reads
but not necessarily on writes and the IO scheduler priorities sync
reads over writes which contributes to keeping stalls due to page
reads low.  In my own tests, there have been no significant stalls
due to waiting on page reads. I accept this may be because the stall
threshold I record is too low.

Still, I double checked an old USB copy based test to see what the
compaction-related stalls really were.

58 seconds	waiting on PageWriteback
22 seconds	waiting on generic_make_request calling ->writepage


These are total times, each stall was about 2-5 seconds and very rough
estimates. There were no other sources of stalls that had compaction
in the stacktrace I'm rerunning to gather more accurate stall times
and for a workload similar to Andrea's and will see if page reads
crop up as a major source of stalls.

-- 
Mel Gorman
SUSE Labs

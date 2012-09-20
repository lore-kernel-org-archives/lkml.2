Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985Ab2ITS5Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 14:57:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40580 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932279Ab2ITS5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 14:57:18 -0400
Message-ID: <505B6706.1000104@redhat.com>
Date: Thu, 20 Sep 2012 14:57:10 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Richard Davies <richard@arachsys.com>, Shaohua Li <shli@kernel.org>,
        Avi Kivity <avi@redhat.com>, QEMU-devel <qemu-devel@nongnu.org>,
        KVM <kvm@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/6] mm: compaction: Restart compaction from near where
 it left off
References: <1348149875-29678-1-git-send-email-mgorman@suse.de> <1348149875-29678-7-git-send-email-mgorman@suse.de>
In-Reply-To: <1348149875-29678-7-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2012 10:04 AM, Mel Gorman wrote:
> This is almost entirely based on Rik's previous patches and discussions
> with him about how this might be implemented.
>
> Order > 0 compaction stops when enough free pages of the correct page
> order have been coalesced.  When doing subsequent higher order allocations,
> it is possible for compaction to be invoked many times.
>
> However, the compaction code always starts out looking for things to compact
> at the start of the zone, and for free pages to compact things to at the
> end of the zone.
>
> This can cause quadratic behaviour, with isolate_freepages starting at
> the end of the zone each time, even though previous invocations of the
> compaction code already filled up all free memory on that end of the zone.
> This can cause isolate_freepages to take enormous amounts of CPU with
> certain workloads on larger memory systems.
>
> This patch caches where the migration and free scanner should start from on
> subsequent compaction invocations using the pageblock-skip information. When
> compaction starts it begins from the cached restart points and will
> update the cached restart points until a page is isolated or a pageblock
> is skipped that would have been scanned by synchronous compaction.
>
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Together with patch 5/6, this has the effect of
skipping compaction in a zone if the free and
isolate markers have met, and it has been less
than 5 seconds since the "skip" information was
reset.

Compaction on zones where we cycle through more
slowly can continue, even when this particular
zone is experiencing problems, so I guess this
is desired behaviour...

Acked-by: Rik van Riel <riel@redhat.com>


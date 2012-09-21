Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932607Ab2IURxz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 13:53:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23485 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932122Ab2IURxx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 13:53:53 -0400
Date: Fri, 21 Sep 2012 14:53:38 -0300
From: Rafael Aquini <aquini@redhat.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Richard Davies <richard@arachsys.com>, Shaohua Li <shli@kernel.org>,
        Rik van Riel <riel@redhat.com>, Avi Kivity <avi@redhat.com>,
        QEMU-devel <qemu-devel@nongnu.org>, KVM <kvm@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 8/9] mm: compaction: Cache if a pageblock was scanned and
 no pages were isolated
Message-ID: <20120921175337.GH6665@optiplex.redhat.com>
References: <1348224383-1499-1-git-send-email-mgorman@suse.de>
 <1348224383-1499-9-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348224383-1499-9-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 11:46:22AM +0100, Mel Gorman wrote:
> When compaction was implemented it was known that scanning could potentially
> be excessive. The ideal was that a counter be maintained for each pageblock
> but maintaining this information would incur a severe penalty due to a
> shared writable cache line. It has reached the point where the scanning
> costs are an serious problem, particularly on long-lived systems where a
> large process starts and allocates a large number of THPs at the same time.
> 
> Instead of using a shared counter, this patch adds another bit to the
> pageblock flags called PG_migrate_skip. If a pageblock is scanned by
> either migrate or free scanner and 0 pages were isolated, the pageblock
> is marked to be skipped in the future. When scanning, this bit is checked
> before any scanning takes place and the block skipped if set.
> 
> The main difficulty with a patch like this is "when to ignore the cached
> information?" If it's ignored too often, the scanning rates will still
> be excessive. If the information is too stale then allocations will fail
> that might have otherwise succeeded. In this patch
> 
> o CMA always ignores the information
> o If the migrate and free scanner meet then the cached information will
>   be discarded if it's at least 5 seconds since the last time the cache
>   was discarded
> o If there are a large number of allocation failures, discard the cache.
> 
> The time-based heuristic is very clumsy but there are few choices for a
> better event. Depending solely on multiple allocation failures still allows
> excessive scanning when THP allocations are failing in quick succession
> due to memory pressure. Waiting until memory pressure is relieved would
> cause compaction to continually fail instead of using reclaim/compaction
> to try allocate the page. The time-based mechanism is clumsy but a better
> option is not obvious.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> Acked-by: Rik van Riel <riel@redhat.com>
> ---

Acked-by: Rafael Aquini <aquini@redhat.com>


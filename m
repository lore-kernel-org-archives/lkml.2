Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148Ab0FHFig (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 01:38:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35157 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948Ab0FHFie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 01:38:34 -0400
Date: Tue, 8 Jun 2010 15:38:31 +1000
From: Nick Piggin <npiggin@suse.de>
To: Dave Chinner <david@fromorbit.com>
Cc: torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH 6/6] writeback: limit write_cache_pages integrity
 scanning to current EOF
Message-ID: <20100608053831.GR26335@laptop>
References: <1275957487-23633-1-git-send-email-david@fromorbit.com>
 <1275957487-23633-7-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275957487-23633-7-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 08, 2010 at 10:38:07AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> sync can currently take a really long time if a concurrent writer is
> extending a file. The problem is that the dirty pages on the address
> space grow in the same direction as write_cache_pages scans, so if
> the writer keeps ahead of writeback, the writeback will not
> terminate until the writer stops adding dirty pages.
> 
> For a data integrity sync, we only need to write the pages dirty at
> the time we start the writeback, so we can stop scanning once we get
> to the page that was at the end of the file at the time the scan
> started.
> 
> This will prevent operations like copying a large file preventing
> sync from completing as it will not write back pages that were
> dirtied after the sync was started. This does not impact the
> existing integrity guarantees, as any dirty page (old or new)
> within the EOF range at the start of the scan will still be
> captured.
> 
> This patch will not prevent sync from blocking on large writes into
> holes.

The writes don't have to be into holes to cause this starvation
problem, do they?


> That requires more complex intervention while this patch only
> addresses the common append-case of this sync holdoff.

Jan's tagging patch looks pretty good to me and isn't so complex.
I think we should just take that.


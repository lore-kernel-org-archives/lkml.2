Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704Ab0DTXcJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 19:32:09 -0400
Received: from bld-mail16.adl2.internode.on.net ([150.101.137.101]:56622 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753583Ab0DTXcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 19:32:08 -0400
Date: Wed, 21 Apr 2010 09:31:59 +1000
From: Dave Chinner <david@fromorbit.com>
To: Jamie Lokier <jamie@shareable.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: [PATCH 5/4] writeback: limit write_cache_pages integrity
 scanning to current EOF
Message-ID: <20100420233159.GB23541@dastard>
References: <1271731314-5893-1-git-send-email-david@fromorbit.com>
 <20100420034005.GA15130@dastard>
 <20100420232819.GR11723@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100420232819.GR11723@shareable.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 12:28:19AM +0100, Jamie Lokier wrote:
> Dave Chinner wrote:
> > sync can currently take a really long time if a concurrent writer is
> > extending a file. The problem is that the dirty pages on the address
> > space grow in the same direction as write_cache_pages scans, so if
> > the writer keeps ahead of writeback, the writeback will not
> > terminate until the writer stops adding dirty pages.
> > 
> > For a data integrity sync, we only need to write the pages dirty at
> > the time we start the writeback, so we can stop scanning once we get
> > to the page that was at the end of the file at the time the scan
> > started.
> > 
> > This will prevent operations like copying a large file preventing
> > sync from completing as it will not write back pages that were
> > dirtied after the sync was started. This does not impact the
> > existing integrity guarantees, as any dirty page (old or new)
> > within the EOF range at the start of the scan will still be
> > captured.
> 
> I guess it can still get stuck if someone does ftruncate() first, then
> writes to the hole?

Yes, it would. It only deals with extending files because fixing the
problem w.r.t.  writes into holes requires something much more
invasive like Jan's radix tree mark-and-sweep algorithm....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

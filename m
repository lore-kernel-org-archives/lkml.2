Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757617Ab1KJMId (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 07:08:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11635 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753112Ab1KJMIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 07:08:32 -0500
Date: Thu, 10 Nov 2011 13:06:49 +0100
From: Johannes Weiner <jweiner@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, Andy Isaacson <adi@hexapodia.org>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm: Do not stall in synchronous compaction for THP
 allocations
Message-ID: <20111110120649.GJ3153@redhat.com>
References: <20111110100616.GD3083@suse.de>
 <20111110105100.23fa78f9@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111110105100.23fa78f9@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 10, 2011 at 10:51:00AM +0000, Alan Cox wrote:
> On Thu, 10 Nov 2011 10:06:16 +0000
> Mel Gorman <mgorman@suse.de> wrote:
> 
> > Occasionally during large file copies to slow storage, there are still
> > reports of user-visible stalls when THP is enabled. Reports on this
> > have been intermittent and not reliable to reproduce locally but;
> 
> If you want to cause a massive stall take a cheap 32GB USB flash drive
> plug it into an 8GB box and rsync a lot of small files to it. 400,000
> emails in maildir format does the trick and can easily be simulated. The
> drive drops to about 1-2 IOPS with all the small mucking around and the
> backlog becomes massive.
> 
> > Internally in SUSE, I received a bug report related to stalls in firefox
> > 	when using Java and Flash heavily while copying from NFS
> > 	to VFAT on USB. It has not been confirmed to be the same problem
> > 	but if it looks like a duck and quacks like a duck.....
> 
> With the 32GB USB flash rsync I see firefox block for up to 45 minutes
> although operating entirely on an unrelated filesystem. I suspect it may
> be a problem that is visible because an fsync is getting jammed up in
> the mess.

Compaction walks PFN ranges, oblivious to inode dirtying order, and so
transparent huge page allocations can get stuck repeatedly on pages
under writeback that are behind whatever the bdi's queue allows to be
inflight.

On all hangs I observed while writing to my 16GB USB thumb drive, it
was tasks getting stuck in migration when allocating a THP.

Can you capture /proc/`pidof firefox`/stack while it hangs to see if
what you see is, in fact, the same problem?

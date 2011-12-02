Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865Ab1LBI3z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 03:29:55 -0500
Received: from mga14.intel.com ([143.182.124.37]:58733 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254Ab1LBI3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 03:29:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,282,1320652800"; 
   d="scan'208";a="81432083"
Date: Fri, 2 Dec 2011 16:29:50 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Jan Kara <jack@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] writeback: permit through good bdi even when global
 dirty exceeded
Message-ID: <20111202082950.GA19148@localhost>
References: <1322735278-17420-1-git-send-email-jack@suse.cz>
 <20111201122425.GA16274@localhost>
 <20111201142704.GT4387@parisc-linux.org>
 <20111202063603.GA10095@localhost>
 <20111201230359.306c4c17.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111201230359.306c4c17.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 02, 2011 at 03:03:59PM +0800, Andrew Morton wrote:
> On Fri, 2 Dec 2011 14:36:03 +0800 Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > --- linux-next.orig/mm/page-writeback.c	2011-12-02 10:16:21.000000000 +0800
> > +++ linux-next/mm/page-writeback.c	2011-12-02 14:28:44.000000000 +0800
> > @@ -1182,6 +1182,14 @@ pause:
> >  		if (task_ratelimit)
> >  			break;
> >  
> > +		/*
> > +		 * In the case of an unresponding NFS server and the NFS dirty
> > +		 * pages exceeds dirty_thresh, give the other good bdi's a pipe
> > +		 * to go through, so that tasks on them still remain responsive.
> > +		 */
> > +		if (bdi_dirty < 8)
> > +			break;
> 
> What happens if the local disk has nine dirty pages?

The 9 dirty pages will be cleaned by the flusher (likely in one shot),
so after a while the dirtier task can dirty 8 pages more. This
consumer-producer work flow can keep going on as long as the magic
number chosen is >= 1.

> Also: please, no more magic numbers.  We have too many in there already.

Good point. Let's add some comment on the number chosen?

> What to do instead?  Perhaps arrange for devices which can block in
> this fashion to be identified as such in their backing_device and then
> prevent the kernel from ever permitting such devices to fully consume
> the dirty-page pool.

Yeah, that's considered too, unfortunately it's not as simple and
elegant than the proposed patch. For example, if giving all NFS mounts
the same "lowered" limit, there is still the problem that when one NFS
mount goes broken, the other NFS mounts are all impacted.

> If someone later comes along and decreases the dirty limits mid-flight,
> I guess the same problem occurs.  This can perhaps be handled by not
> permitting to limit to be set that low at that time.

Yes! Not long ago we introduced @global_dirty_limit and
update_dirty_limit() exactly for fixing that case. The comment says:

/*
 * The global dirtyable memory and dirty threshold could be suddenly knocked
 * down by a large amount (eg. on the startup of KVM in a swapless system).
 * This may throw the system into deep dirty exceeded state and throttle
 * heavy/light dirtiers alike. To retain good responsiveness, maintain
 * global_dirty_limit for tracking slowly down to the knocked down dirty
 * threshold.
 */
static void update_dirty_limit(unsigned long thresh, unsigned long dirty)
{       
...


Thanks,
Fengguang

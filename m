Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335Ab0FXADf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 20:03:35 -0400
Received: from bld-mail16.adl2.internode.on.net ([150.101.137.101]:54675 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751458Ab0FXADe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 20:03:34 -0400
Date: Thu, 24 Jun 2010 10:02:46 +1000
From: Dave Chinner <david@fromorbit.com>
To: Michael Rubin <mrubin@google.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, jack@suse.cz, akpm@linux-foundation.org, hch@lst.de,
       axboe@kernel.dk
Subject: Re: [PATCH 0/3] writeback visibility
Message-ID: <20100624000246.GQ6590@dastard>
References: <1276907415-504-1-git-send-email-mrubin@google.com>
 <20100620231017.GI6590@dastard>
 <AANLkTikem5aW2MChCwmluUveB-F3zv5B9Tj0TtXPcfxm@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikem5aW2MChCwmluUveB-F3zv5B9Tj0TtXPcfxm@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 21, 2010 at 10:09:24AM -0700, Michael Rubin wrote:
> Thanks for looking at this.
> 
> On Sun, Jun 20, 2010 at 4:10 PM, Dave Chinner <david@fromorbit.com> wrote:
> >> Michael Rubin (3):
> >>   writeback: Creating /sys/kernel/mm/writeback/writeback
> >>   writeback: per bdi monitoring
> >>   writeback: tracking subsystems causing writeback
> >
> > I'm not sure we want to export statistics that represent internal
> > implementation details into a fixed userspace API. Who, other than
> > developers, are going to understand and be able to make use of this
> > information?
> 
> I think there are varying degrees of internal exposure on the patches.
> 
> >>   writeback: Creating /sys/kernel/mm/writeback/writeback
> This one seems to not expose any new internals. We already expose the
> concept of "dirty", "writeback" and thresholds in /proc/meminfo.

I don't see any probems with these stats - no matter the
implementation, they'll still be relevant.

> >>  writeback: per bdi monitoring
> 
> Looking at it again. I think this one is somewhat of a mixed bag.
> BDIReclaimable, BdiWriteback, and the dirty thresholds seems safe to
> export.While I agree the rest should stay in debugfs. Would that be
> amenable?

I'd much prefer all the bdi stats in the one spot. It's hard enough
to find what you're looking for without splitting them into multiple
locations.

The other thing to consider is that tracing requires debugfѕ to be
mounted. Hence most kernels are going to have the debug stats
available, anyway....

> >> writeback: tracking subsystems causing writeback
> 
> I definitely agree that this one is too revealing and needs to be
> redone. But I think we might want to add the details for concepts
> which we already expose.
> The idea of a "periodic writeback" is already exposed in /proc/sys/vm/
> and I don't see that changing in the kernel as a method to deal with
> buffered IO. Neither will sync.

I don't see much value in exposing this information outside of
development environments. I think it's much better to add trace
points for events like this so that we do fine-grained analysis of
when the events occur during problematic workloads....

> The laptop stuff and the names of
> "balance_dirty_pages" are bad, but maybe we can come up with something
> more high level. Like "writeback due to low memory"
> 
> > FWIW, I've got to resend the writeback tracing patches to Jens that I
> > have that give better visibility into the writeback behaviour.
> > Perhaps those tracing events are a better basis for tracking down
> > writeback problems - the bugs I found with the tracing could not
> > have been found with these statistics...
> 
> Yeah I have been watching the tracing stuff you have posted and I
> think it will help. There were some other trace points I wanted to add
> to this patch but was waiting to learn from your submission on the
> best way to integrate them.

I've got more work to do on them first.... :/

> > That's really why I'm asking - if the stats are just there to help
> > development and debugging, then I think that improving the writeback
> > tracing is a better approach to improving visibility of writeback
> > behaviour...
> 
> Maybe I should not have put all these patches in one series. The first
> one with the /sys/kernel/vm file is very useful for user space
> developers. System Administrators who are trying to classify IO
> problems often need to know if the disk is bad

These stats aren't the place for observing that a disk is bad ;)

> or if the buffered data
> is not even being written to disk over time..

I think this can be obtained from the existing info in /proc/meminfo.
I'm not saying the new stats aren't necessary, just that we already
have the high level information available for this....

> Also at Google we tend
> to run our jobs with very little unused RAM. Pushing things close to
> their limits results in many surprises and writeback is often one of
> them. Knowing the thresholds and rate of dirty and cleaning of pages
> can help systems do the right thing.

Yes, I hear this all the time from appliance developers that cache
everything they need in userspace - they just want the kernel to
stay out of the way and not use the unused RAM for caching stuff that
doesn't matter to the application. Normally the issue is unbounded
growth of the inode and dentry caches, but I can see how exceeding
writeback limits can be just as much of a problem.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

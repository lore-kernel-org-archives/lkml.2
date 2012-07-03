Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab2GCMba (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 08:31:30 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:47539 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168Ab2GCMb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 08:31:27 -0400
Date: Tue, 3 Jul 2012 14:31:19 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Mel Gorman <mgorman@suse.de>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
        dri-devel@lists.freedesktop.org, Keith Packard <keithp@keithp.com>,
        Eugeni Dodonov <eugeni.dodonov@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [MMTests] IO metadata on XFS
Message-ID: <20120703123119.GA5103@phenom.ffwll.local>
Mail-Followup-To: Mel Gorman <mgorman@suse.de>,
	Dave Chinner <david@fromorbit.com>,
	Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	xfs@oss.sgi.com, dri-devel@lists.freedesktop.org,
	Keith Packard <keithp@keithp.com>,
	Eugeni Dodonov <eugeni.dodonov@intel.com>,
	Chris Wilson <chris@chris-wilson.co.uk>
References: <20120620113252.GE4011@suse.de>
 <20120629111932.GA14154@suse.de>
 <20120629112505.GF14154@suse.de>
 <20120701235458.GM19223@dastard>
 <20120702063226.GA32151@infradead.org>
 <20120702143215.GS14154@suse.de>
 <20120702193516.GX14154@suse.de>
 <20120703001928.GV19223@dastard>
 <20120703105951.GB14154@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120703105951.GB14154@suse.de>
X-Operating-System: Linux phenom 3.4.0-rc3+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2012 at 11:59:51AM +0100, Mel Gorman wrote:
> On Tue, Jul 03, 2012 at 10:19:28AM +1000, Dave Chinner wrote:
> > On Mon, Jul 02, 2012 at 08:35:16PM +0100, Mel Gorman wrote:
> > > Adding dri-devel and a few others because an i915 patch contributed to
> > > the regression.
> > > 
> > > On Mon, Jul 02, 2012 at 03:32:15PM +0100, Mel Gorman wrote:
> > > > On Mon, Jul 02, 2012 at 02:32:26AM -0400, Christoph Hellwig wrote:
> > > > > > It increases the CPU overhead (dirty_inode can be called up to 4
> > > > > > times per write(2) call, IIRC), so with limited numbers of
> > > > > > threads/limited CPU power it will result in lower performance. Where
> > > > > > you have lots of CPU power, there will be little difference in
> > > > > > performance...
> > > > > 
> > > > > When I checked it it could only be called twice, and we'd already
> > > > > optimize away the second call.  I'd defintively like to track down where
> > > > > the performance changes happend, at least to a major version but even
> > > > > better to a -rc or git commit.
> > > > > 
> > > > 
> > > > By all means feel free to run the test yourself and run the bisection :)
> > > > 
> > > > It's rare but on this occasion the test machine is idle so I started an
> > > > automated git bisection. As you know the milage with an automated bisect
> > > > varies so it may or may not find the right commit. Test machine is sandy so
> > > > http://www.csn.ul.ie/~mel/postings/mmtests-20120424/global-dhp__io-metadata-xfs/sandy/comparison.html
> > > > is the report of interest. The script is doing a full search between v3.3 and
> > > > v3.4 for a point where average files/sec for fsmark-single drops below 25000.
> > > > I did not limit the search to fs/xfs on the off-chance that it is an
> > > > apparently unrelated patch that caused the problem.
> > > > 
> > > 
> > > It was obvious very quickly that there were two distinct regression so I
> > > ran two bisections. One led to a XFS and the other led to an i915 patch
> > > that enables RC6 to reduce power usage.
> > > 
> > > [aa464191: drm/i915: enable plain RC6 on Sandy Bridge by default]
> > 
> > Doesn't seem to be the major cause of the regression. By itself, it
> > has impact, but the majority comes from the XFS change...
> > 
> 
> The fact it has an impact at all is weird but lets see what the DRI
> folks think about it.

Well, presuming I understand things correctly the cpu die only goes into
the lowest sleep state (which iirc switches off l3 caches and
interconnects) when both the cpu and gpu are in the lowest sleep state.
rc6 is that deep-sleep state for the gpu, so without that enabled your
system won't go into these deep-sleep states.

I guess the slight changes in wakeup latency, power consumption (cuts
about 10W on an idle desktop snb with resulting big effect on what turbo
boost can sustain for short amounts of time) and all the follow-on effects
are good enough to massively change timing-critical things.

So this having an effect isn't too weird.

Obviously, if you also have X running while doing these tests there's the
chance that the gpu dies because of an issue when waking up from rc6
(we've known a few of these), but if no drm client is up, that shouldn't
be possible. So please retest without X running if that hasn't been done
already.

Yours, Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48

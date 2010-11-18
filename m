Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab0KRCHE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 21:07:04 -0500
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:36332 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754380Ab0KRCHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 21:07:02 -0500
Date: Thu, 18 Nov 2010 13:06:40 +1100
From: Dave Chinner <david@fromorbit.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, "Theodore Ts'o" <tytso@mit.edu>,
        Chris Mason <chris.mason@oracle.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mel@csn.ul.ie>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-mm <linux-mm@kvack.org>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/13] IO-less dirty throttling v2
Message-ID: <20101118020640.GS22876@dastard>
References: <20101117042720.033773013@intel.com>
 <20101117150330.139251f9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101117150330.139251f9.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 03:03:30PM -0800, Andrew Morton wrote:
> On Wed, 17 Nov 2010 12:27:20 +0800
> Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > On a simple test of 100 dd, it reduces the CPU %system time from 30% to 3%, and
> > improves IO throughput from 38MB/s to 42MB/s.
> 
> The changes in CPU consumption are remarkable.  I've looked through the
> changelogs but cannot find mention of where all that time was being
> spent?

In the writeback path, mostly because every CPU is trying to run
writeback at the same time and causing contention on locks and
shared structures in the writeback path. That no longer happens
because writeback is only happening from one thread instead of from
all CPUs at once.

This is one of the reasons why I want this series to be sorted out
before we start to consider scalability of the writeback lists and
locking - controlling the level of writeback parallelism provides a
major reduction in writeback lock contention and indicates that the
next bottleneck we really need to solve is bdi-flusher thread
parallelism...

> How well have these changes been tested with NFS?

Next on my list (just doing some ext4 sanity testing).

> The changes are complex and will probably do Bad Things for some
> people.  Does the code implement sufficient
> debug/reporting/instrumentation to enable you to diagnose, understand
> and fix people's problems in the minimum possible time?  If not, please
> add that stuff.  Just go nuts with it.  Put it in debugfs, add /*
> DELETEME */ comments and we can pull it all out again in half a year or
> so.
> 
> Or perhaps litter the code with temporary tracepoints, provided we can
> come up with a way for our testers to trivially gather their output.

I think tracepoints are the way to go - I've been asking XFS users
to send me trace dumps for anyhting non-trivial recently. I've been
able to understand the cause of their problems without having to
reproduce the problem locally, which has been a big help....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

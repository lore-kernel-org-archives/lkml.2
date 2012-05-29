Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307Ab2E2Byp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 21:54:45 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:12777 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751944Ab2E2Byo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 21:54:44 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlAJADQrxE95LJr7/2dsb2JhbABEFrQjBIEkgQiCFwEBAwEBOhwjBQsIAw4KLhQlAyETiAYEDLgSFIpvFAwvhGIDlRaBEIgPhlOCcoFEAQ
Date: Tue, 29 May 2012 11:54:38 +1000
From: Dave Chinner <david@fromorbit.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org, dm-devel@redhat.com,
        linux-fsdevel@vger.kernel.org, axboe@kernel.dk, yehuda@hq.newdream.net,
        mpatocka@redhat.com, vgoyal@redhat.com, bharrosh@panasas.com,
        tj@kernel.org, sage@newdream.net, agk@redhat.com,
        drbd-dev@lists.linbit.com, Dave Chinner <dchinner@redhat.com>,
        tytso@google.com
Subject: Re: [PATCH v3 14/16] Gut bio_add_page()
Message-ID: <20120529015438.GZ5091@dastard>
References: <1337977539-16977-1-git-send-email-koverstreet@google.com>
 <1337977539-16977-15-git-send-email-koverstreet@google.com>
 <20120525204651.GA24246@redhat.com>
 <20120525210944.GB14196@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120525210944.GB14196@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2012 at 02:09:44PM -0700, Kent Overstreet wrote:
> On Fri, May 25, 2012 at 04:46:51PM -0400, Mike Snitzer wrote:
> > I'd love to see the merge_bvec stuff go away but it does serve a
> > purpose: filesystems benefit from accurately building up much larger
> > bios (based on underlying device limits).  XFS has leveraged this for
> > some time and ext4 adopted this (commit bd2d0210cf) because of the
> > performance advantage.
> 
> That commit only talks about skipping buffer heads, from the patch
> description I don't see how merge_bvec_fn would have anything to do with
> what it's after.

XFS has used it since 2.6.16 as building our own bios enabled the Io
path form IOs of sizes that are independent of the filesystem block
size.

http://oss.sgi.com/projects/xfs/papers/ols2006/ols-2006-paper.pdf

And it's not just the XFS write path that uses bio_add_page - the XFS
metadata read/write IO code uses it as well because we have metadata
constructs that are larger than a single page...

> > So if you don't have a mechanism for the filesystem's IO to have
> > accurate understanding of the limits of the device the filesystem is
> > built on (merge_bvec was the mechanism) and are leaning on late
> > splitting does filesystem performance suffer?
> 
> So is the issue that it may take longer for an IO to complete, or is it
> CPU utilization/scalability?

Both. Moving to this code reduced the CPU overhead per MB of data
written to disk by 80-90%. It also allowed us to build IOs that span
entire RAID stripe widths, thereby avoiding potential RAID RMW
cycles, and even allowing high end raid controllers to trigger BBWC
bypass fast paths that could double or triple the write throughput
of the arrays...

> If it's the former, we've got a real problem.

... then you have a real problem.

> If it's the latter - it
> might be a problem in the interim (I don't expect generic_make_request()
> to be splitting bios in the common case long term), but I doubt it's
> going to be much of an issue.

I think this will also be an issue - the typical sort of throughput
I've been hearing about over the past year for typical HPC
deployments is >20GB/s buffered write throughput to disk on a single
XFS filesystem, and that is typically limited by the flusher thread
being CPU bound. So if you changes have a CPU usage impact, then
these systems will definitely see reduced performance....

> > Would be nice to see before and after XFS and ext4 benchmarks against a
> > RAID device (level 5 or 6).  I'm especially interested to get Dave
> > Chinner's and Ted's insight here.
> 
> Yeah.
> 
> I can't remember who it was, but Ted knows someone who was able to
> benchmark on a 48 core system. I don't think we need numbers from a 48
> core machine for these patches, but whatever workloads they were testing
> that were problematic CPU wise would be useful to test.

Eric Whitney.

http://downloads.linux.hp.com/~enw/ext4/3.2/

His storage hardware probably isn't fast enough to demonstrate the
sort of problems I'm expecting that would occur...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

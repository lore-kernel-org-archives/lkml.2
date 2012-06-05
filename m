Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761267Ab2FEAd1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 20:33:27 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:16676 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751519Ab2FEAd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 20:33:26 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ak4JAEJTzU95LMSO/2dsb2JhbABEswIEgSWBCIIYAQEEATocIwULCAMOCi4UJQMhE4gGBLczFIp9ToRiYAOVGokhhlaCcg
Date: Tue, 5 Jun 2012 10:33:10 +1000
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
Message-ID: <20120605003309.GD4347@dastard>
References: <1337977539-16977-1-git-send-email-koverstreet@google.com>
 <1337977539-16977-15-git-send-email-koverstreet@google.com>
 <20120525204651.GA24246@redhat.com>
 <20120525210944.GB14196@google.com>
 <20120529015438.GZ5091@dastard>
 <20120529033434.GC10175@dhcp-172-18-216-138.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120529033434.GC10175@dhcp-172-18-216-138.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2012 at 11:34:34PM -0400, Kent Overstreet wrote:
> On Tue, May 29, 2012 at 11:54:38AM +1000, Dave Chinner wrote:
> > It also allowed us to build IOs that span
> > entire RAID stripe widths, thereby avoiding potential RAID RMW
> > cycles, and even allowing high end raid controllers to trigger BBWC
> > bypass fast paths that could double or triple the write throughput
> > of the arrays...
> 
> merge_bvec_fn has nothing to do with that though, since for one there

You're mistaking me for someone who cares about merge_bvec_fn().
Someone asked me to describe why XFS uses bio_add_page()....

> aren't any merge_bvec_fn's being called in the IO paths on these high
> end disk arrays,

Yes there are, because high bandwidth filesytem use software RAID 0
striping to stripe multiple hardware RAID luns together to acheive
the necessary bandwidth. Hardware RAID is used for disk failure
prevention and to manage 1000 disks more easily, while software RAID
(usually with multipathing) is used to scale the performance....

> and for our software raid implementations their
> merge_bvec_fns will keep you from sending them bios that span entire
> stripes.

Well, yeah, the lower layer has to break up large bios into chunks
for it's sub-devices.  What matters is that we build IOs that are
larger than what the lower layers break it up into. e.g. if your
hardware RAID5 stripe width is 1MB, then the software RAID chunks
size is 1MB (and the stripe width is N luns X 1MB), then all that
matters is that we build IOs larger than 1MB so that we get full
stripe writes at that hardware RAID level and so avoid RMW cycles
right at the bottom of the IO stack...

As long as the new code still allows us to achieve the same or
better IO sizes without any new overhead, then I simply don't care
what happens to the guts of bio_add_page().

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298Ab2E2CHK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 22:07:10 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:62812 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751885Ab2E2CHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 22:07:06 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ak4JAKIuxE95LJr7/2dsb2JhbABEtDMEgSSBCIIXAQEEATocIwULCAMOCi4UJQMhE4gGBLgjFIpvT4QCYAOVFokfhlOCcg
Date: Tue, 29 May 2012 12:07:02 +1000
From: Dave Chinner <david@fromorbit.com>
To: Tejun Heo <tj@kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Alasdair G Kergon <agk@redhat.com>,
        Kent Overstreet <koverstreet@google.com>,
        Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org, dm-devel@redhat.com,
        linux-fsdevel@vger.kernel.org, axboe@kernel.dk, yehuda@hq.newdream.net,
        vgoyal@redhat.com, bharrosh@panasas.com, sage@newdream.net,
        drbd-dev@lists.linbit.com, Dave Chinner <dchinner@redhat.com>,
        tytso@google.com
Subject: Re: [PATCH v3 14/16] Gut bio_add_page()
Message-ID: <20120529020702.GA5091@dastard>
References: <1337977539-16977-1-git-send-email-koverstreet@google.com>
 <1337977539-16977-15-git-send-email-koverstreet@google.com>
 <20120525204651.GA24246@redhat.com>
 <20120525210944.GB14196@google.com>
 <20120525223937.GF5761@agk-dp.fab.redhat.com>
 <Pine.LNX.4.64.1205281129180.2227@file.rdu.redhat.com>
 <20120528202839.GA18537@dhcp-172-17-108-109.mtv.corp.google.com>
 <Pine.LNX.4.64.1205281659580.11763@file.rdu.redhat.com>
 <20120528213839.GB18537@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120528213839.GB18537@dhcp-172-17-108-109.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2012 at 06:38:39AM +0900, Tejun Heo wrote:
> On Mon, May 28, 2012 at 05:27:33PM -0400, Mikulas Patocka wrote:
> > > Isn't it more like you shouldn't be sending read requested by user and
> > > read ahead in the same bio?
> > 
> > If the user calls read with 512 bytes, you would send bio for just one 
> > sector. That's too small and you'd get worse performance because of higher 
> > command overhead. You need to send larger bios.
> 
> All modern FSes are page granular, so the granularity would be
> per-page.

Most modern filesystems support sparse files and block sizes smaller
than page size, so a single page may require multiple unmergable
bios to fill all the data in them. Hence IO granularity is
definitely not per-page even though that is the granularity of the
page cache.

> Also, RAHEAD is treated differently in terms of
> error-handling.  Do filesystems implement their own rahead
> (independent from the common logic in vfs layer) on their own?

Yes. Keep in mind there is no rule that says filesystems must use
the generic IO paths, or even the page cache for that matter.
Indeed, XFS (and I think btrfs now) do no use the page cache for
their metadata caching and IO.

So just off the top of my head, XFS has it's own readahead for
metadata constructs (btrees, directory data, etc) , and btrfs
implements it's own readpage/readpages and readahead paths (see the
btrfs compression support, for example).

And FWIW, XFS has variable sized metadata, so to complete the
circle, some metadata requires sector granularity, some filesystem
block size granularity, and some multiple page granularity.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

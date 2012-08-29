Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886Ab2H2VJO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 17:09:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48764 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350Ab2H2VJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 17:09:12 -0400
Date: Wed, 29 Aug 2012 14:08:38 -0700
From: Kent Overstreet <koverstreet@google.com>
To: John Stoffel <john@stoffel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org, mpatocka@redhat.com,
        bharrosh@panasas.com, Tejun Heo <tj@kernel.org>
Subject: Re: [dm-devel] [PATCH v7 9/9] block: Avoid deadlocks with bio
 allocation by stacking drivers
Message-ID: <20120829210838.GA15218@moria.home.lan>
References: <1346175456-1572-10-git-send-email-koverstreet@google.com>
 <20120828204910.GG24608@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120828222800.GG1048@moria.home.lan>
 <20120828230108.GI1048@moria.home.lan>
 <20120829013150.GA9269@redhat.com>
 <20120829032558.GA22214@moria.home.lan>
 <20120829125759.GB12504@redhat.com>
 <20120829143913.GA5500@agk-dp.fab.redhat.com>
 <20120829162612.GA20312@google.com>
 <20542.33557.833272.561494@quad.stoffel.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20542.33557.833272.561494@quad.stoffel.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29, 2012 at 05:01:09PM -0400, John Stoffel wrote:
> >>>>> "Kent" == Kent Overstreet <koverstreet@google.com> writes:
> 
> Kent> On Wed, Aug 29, 2012 at 03:39:14PM +0100, Alasdair G Kergon wrote:
> >> It's also instructive to remember why the code is the way it is: it used
> >> to process bios for underlying devices immediately, but this sometimes
> >> meant too much recursive stack growth.  If a per-device rescuer thread
> >> is to be made available (as well as the mempool), the option of
> >> reinstating recursion is there too - only punting to workqueue when the
> >> stack actually becomes "too big".  (Also bear in mind that some dm
> >> targets may have dependencies on their own mempools - submission can
> >> block there too.)  I find it helpful only to consider splitting into two
> >> pieces - it must always be possible to process the first piece (i.e.
> >> process it at the next layer down in the stack) and complete it
> >> independently of what happens to the second piece (which might require
> >> further splitting and block until the first piece has completed).
> 
> Kent> I'm sure it could be made to work (and it may well simpler), but it
> Kent> seems problematic from a performance pov.
> 
> Kent> With stacked devices you'd then have to switch stacks on _every_ bio.
> Kent> That could be made fast enough I'm sure, but it wouldn't be free and I
> Kent> don't know of any existing code in the kernel that implements what we'd
> Kent> need (though if you know how you'd go about doing that, I'd love to
> Kent> know! Would be useful for other things).
> 
> Kent> The real problem is that because we'd need these extra stacks for
> Kent> handling all bios we couldn't get by with just one per bio_set. We'd
> Kent> only need one to make forward progress so the rest could be allocated
> Kent> on demand (i.e. what the workqueue code does) but that sounds like it's
> Kent> starting to get expensive.
> 
> Maybe we need to limit the size of BIOs to that of the bottom-most
> underlying device instead?  Or maybe limit BIOs to some small
> multiple?  As you stack up DM targets one on top of each other, they
> should respect the limits of the underlying devices and pass those
> limits up the chain.

That's the approach the block layer currently tries to take. It's
brittle, tricky and inefficient, and it completely breaks down when the
limits are dynamic - so things like dm and bcache are always going to
have to split anyways.

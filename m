Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020Ab2LYQlr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 11:41:47 -0500
Received: from mail-vb0-f41.google.com ([209.85.212.41]:35108 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866Ab2LYQlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 11:41:46 -0500
X-Greylist: delayed 388 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Dec 2012 11:41:46 EST
Date: Tue, 25 Dec 2012 08:35:13 -0800
From: Tejun Heo <tj@kernel.org>
To: Borislav Petkov <bp@alien8.de>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 25/25] ipc: don't use [delayed_]work_pending()
Message-ID: <20121225163513.GF10220@mtj.dyndns.org>
References: <1356141435-17340-1-git-send-email-tj@kernel.org>
 <1356141435-17340-26-git-send-email-tj@kernel.org>
 <20121221181523.0e0998e4.akpm@linux-foundation.org>
 <20121222022210.GA30177@htj.dyndns.org>
 <20121222110929.GA3567@liondog.tnic>
 <20121224183334.GB11817@htj.dyndns.org>
 <20121224184520.GC11817@htj.dyndns.org>
 <20121224194101.GC5344@liondog.tnic>
 <20121225032914.GE10220@mtj.dyndns.org>
 <20121225104614.GA7692@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121225104614.GA7692@liondog.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Borislav.

On Tue, Dec 25, 2012 at 11:46:14AM +0100, Borislav Petkov wrote:
> > It doesn't have anything to do with memory hotplug event itself.  It's
> > a generic memory access ordering / synchronization issue.  There just
> > isn't anything preventing test_bit() from seeing PENDING bit from
> > before clearing.
> 
> That's true. So is it that the whole PENDING bit testing was actually
> the wrong sync primitive to use in most cases and we actually really
> needed to disable interrupts around testing of that bit?

The IRQ disabling is for synchronization with other workqueue
operations.  Once PENDING is set, other workqueue operations may
busy-wait for the work item to be put on the appropriate queue so that
further operations can happen (e.g. flush / cancel).  So, if you have
to be atomic locally w.r.t. IRQs.

Memory ordering issue is the one which makes using test_bit() in
itself inadequate for gating the queue operation.  It could be all we
need is throwing in a smp_mb() before test_bit() to guarantee that
either clear PENDING is visible or all updates upto that point is
visible to the coming work item execution.  Not sure whether that
would be worthwhile tho.  The only case that may help is, I think, if
an already pending work item is queued very frequently from multiple
CPUs, which is unlikely and, if exists, indicates larger problems.

> Which would make your patches actually bugfixes.

Yes, why I'm talking about making [delayed_]work_pending() go away or
at least make it very ugly to use.

> /me goes and rereads 0/25 announcement mail.
> 
> Yes, it sounds like [delayed_]work_pending() needs to go or at least
> needs a big fat comment over it explaining that it is a special, cheaper
> alternative to be used *only* in conjunction with other synchronization.
> 
> Ok, thanks Tejun, for taking the time and explaining it again to me.

Thanks.

-- 
tejun

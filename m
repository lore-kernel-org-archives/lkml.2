Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092Ab1LNU6h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 15:58:37 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:56456 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755364Ab1LNU6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 15:58:36 -0500
Date: Wed, 14 Dec 2011 15:58:22 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] AIO: Don't plug the I/O queue in do_io_submit()
Message-ID: <20111214205822.GM31158@shiny>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Jeff Moyer <jmoyer@redhat.com>, linux-aio@kvack.org,
	linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	Andi Kleen <ak@linux.intel.com>
References: <4EE7C74D.1020306@oracle.com>
 <x49sjkoi08u.fsf@segfault.boston.devel.redhat.com>
 <4EE7DF0F.4030506@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EE7DF0F.4030506@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090201.4EE90DF4.007A,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 13, 2011 at 05:26:07PM -0600, Dave Kleikamp wrote:
> On 12/13/2011 04:18 PM, Jeff Moyer wrote:
> > Dave Kleikamp <dave.kleikamp@oracle.com> writes:
> > 
> >> Asynchronous I/O latency to a solid-state disk greatly increased
> >> between the 2.6.32 and 3.0 kernels. By removing the plug from
> >> do_io_submit(), we observed a 34% improvement in the I/O latency.
> >>
> >> Unfortunately, at this level, we don't know if the request is to
> >> a rotating disk or not.
> > 
> > I'm guessing I know the answer to this, but what workload were you
> > testing, and can you provide more concrete evidence than "latency
> > greatly increased?"
> 
> It is a piece of a larger industry-standard benchmark and you're
> probably guessing correctly. The "greatly increased" latency was
> actually slightly higher the improvement I get with this patch. So the
> patch brought the latency nearly down to where it was before.
> 
>  I will try a microbenchmark to see if I get similar behavior, but I
> wanted to throw this out here to get input.

The better IO latency did bump the overall benchmark score by 3%, and it
did end up bringing our latencies on par with solaris runs on similar
hardware.

We didn't find this one through exhaustive tracing...instead we used a more
traditional approach involving a list of Jens' commits and a dart board.
So, we don't have a lot of data yet on exactly why the plug is hurting.

But, I'm starting to wonder if the plug makes sense here at all.  We're
queueing up IO in the main submit loop, and the aio submit might be
spanning any number of devices on a large variety of filesystems.  The
actual direct IO call may be pretty expensive.

My guess for why this helps is contention on the aio context lock
between the submission code and the end_io softirq code.  We bash on
that lock a number of times during the IO submit, and the whole time
we're holding on to our list of plugged IOs instead of giving the
hardware the chance to process them.

-chris


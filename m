Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759643Ab1LPOpc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 09:45:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58573 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759212Ab1LPOpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 09:45:24 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: Dave Kleikamp <dave.kleikamp@oracle.com>, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] AIO: Don't plug the I/O queue in do_io_submit()
References: <4EE7C74D.1020306@oracle.com>
	<x49sjkoi08u.fsf@segfault.boston.devel.redhat.com>
	<4EE7DF0F.4030506@oracle.com> <20111214205822.GM31158@shiny>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 16 Dec 2011 09:45:07 -0500
In-Reply-To: <20111214205822.GM31158@shiny> (Chris Mason's message of "Wed, 14
	Dec 2011 15:58:22 -0500")
Message-ID: <x49d3bomv7w.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Mason <chris.mason@oracle.com> writes:

> On Tue, Dec 13, 2011 at 05:26:07PM -0600, Dave Kleikamp wrote:
>> On 12/13/2011 04:18 PM, Jeff Moyer wrote:
>> > Dave Kleikamp <dave.kleikamp@oracle.com> writes:
>> > 
>> >> Asynchronous I/O latency to a solid-state disk greatly increased
>> >> between the 2.6.32 and 3.0 kernels. By removing the plug from
>> >> do_io_submit(), we observed a 34% improvement in the I/O latency.
>> >>
>> >> Unfortunately, at this level, we don't know if the request is to
>> >> a rotating disk or not.
>> > 
>> > I'm guessing I know the answer to this, but what workload were you
>> > testing, and can you provide more concrete evidence than "latency
>> > greatly increased?"
>> 
>> It is a piece of a larger industry-standard benchmark and you're
>> probably guessing correctly. The "greatly increased" latency was
>> actually slightly higher the improvement I get with this patch. So the
>> patch brought the latency nearly down to where it was before.
>> 
>>  I will try a microbenchmark to see if I get similar behavior, but I
>> wanted to throw this out here to get input.
>
> The better IO latency did bump the overall benchmark score by 3%, and it
> did end up bringing our latencies on par with solaris runs on similar
> hardware.
>
> We didn't find this one through exhaustive tracing...instead we used a more
> traditional approach involving a list of Jens' commits and a dart board.
> So, we don't have a lot of data yet on exactly why the plug is hurting.
>
> But, I'm starting to wonder if the plug makes sense here at all.  We're
> queueing up IO in the main submit loop, and the aio submit might be
> spanning any number of devices on a large variety of filesystems.  The
> actual direct IO call may be pretty expensive.

I believe the original plugging here was done on a per fd basis.  So, I
concede that the behaviour may have changed a bit since the initial
patch for this was merged.

> My guess for why this helps is contention on the aio context lock
> between the submission code and the end_io softirq code.  We bash on
> that lock a number of times during the IO submit, and the whole time
> we're holding on to our list of plugged IOs instead of giving the
> hardware the chance to process them.

I have a patch slated for 3.2 that should help that.  It batches the
allocation of the aio requests, which showed a good improvement in
microbenchmarks there.

commit 080d676de095a14ecba14c0b9a91acb5bbb634df
Author: Jeff Moyer <jmoyer@redhat.com>
Date:   Wed Nov 2 13:40:10 2011 -0700

    aio: allocate kiocbs in batches

Cheers,
Jeff

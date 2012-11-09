Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757470Ab2KICcM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 21:32:12 -0500
Received: from mga14.intel.com ([143.182.124.37]:10407 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756523Ab2KICcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 21:32:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,741,1344236400"; 
   d="scan'208";a="166206264"
Date: Fri, 9 Nov 2012 10:32:21 +0800
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] kfifo: round up the fifo size power of 2
Message-ID: <20121109023221.GO18293@yliu-dev.sh.intel.com>
References: <1351238218-22648-1-git-send-email-yuanhan.liu@linux.intel.com>
 <20121029135935.bb8b0b2a.akpm@linux-foundation.org>
 <20121031055916.GC29509@yliu-dev.sh.intel.com>
 <1351665033.23165.6.camel@wall-e>
 <20121030235210.4dfc6ef7.akpm@linux-foundation.org>
 <20121108122409.GN18293@yliu-dev.sh.intel.com>
 <1352378235.15351.9.camel@wall-e>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352378235.15351.9.camel@wall-e>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 08, 2012 at 01:37:15PM +0100, Stefani Seibold wrote:
> Am Donnerstag, den 08.11.2012, 20:24 +0800 schrieb Yuanhan Liu:
> > On Tue, Oct 30, 2012 at 11:52:10PM -0700, Andrew Morton wrote:
> > > On Wed, 31 Oct 2012 07:30:33 +0100 Stefani Seibold <stefani@seibold.net> wrote:
> > > 
> > > > > Yes, and I guess the same to give them a 64-element one.
> > > > > 
> > > > > > 
> > > > > > If there's absolutely no prospect that the kfifo code will ever support
> > > > > > 100-byte fifos then I guess we should rework the API so that the caller
> > > > > > has to pass in log2 of the size, not the size itself.  That way there
> > > > > > will be no surprises and no mistakes.
> > > > > > 
> > > > > > That being said, the power-of-2 limitation isn't at all intrinsic to a
> > > > > > fifo, so we shouldn't do this.  Ideally, we'd change the kfifo
> > > > > > implementation so it does what the caller asked it to do!
> > > > > 
> > > > > I'm fine with removing the power-of-2 limitation. Stefani, what's your
> > > > > comment on that?
> > > > > 
> > > > 
> > > > You can't remove the power-of-2-limitation, since this would result in a
> > > > performance decrease (bit wise and vs. modulo operation).
> > > 
> > > Probably an insignificant change in performance.
> > > 
> > > It could be made much smaller by just never doing the modulus operation
> > > - instead do
> > > 
> > > 	if (++index == max)
> > > 		index = 0;
> > > 
> > > this does introduce one problem: it's no longer possible to distinguish
> > > the "full" and "empty" states by comparing the head and tail indices. 
> > > But that is soluble.
> > 
> > Hi Andrew,
> > 
> > Yes, it is soluble. How about the following solution?
> > 
> > Add 2 more fields(in_off and out_off) in __kfifo structure, so that in
> > and out will keep increasing each time, while in_off and out_off will be
> > wrapped to head if goes to the end of fifo buffer.
> > 
> > So, we can use in and out for counting unused space, and distinguish the
> > "full" and "empty" state, and also, of course no need for locking.
> > 
> > Stefani, sorry for quite late reply. I checked all the code used kfifo_alloc
> > and kfifo_init. Firstly, there are a lot of users ;-)
> > 
> > And secondly, I did find some examples used kfifo as it supports
> > none-power-of-2 kfifo. Say, the one at drivers/hid/hid-logitech-dj.c:
> >        if (kfifo_alloc(&djrcv_dev->notif_fifo,
> >                        DJ_MAX_NUMBER_NOTIFICATIONS * sizeof(struct dj_report),
> >                        GFP_KERNEL)) {
> > 
> > which means it wants to allocate a kfifo buffer which can store
> > DJ_MAX_NUMBER_NOTIFICATIONS(8 here) dj_report(each 15 bytes) at once.
> > 
> > And DJ_MAX_NUMBER_NOTIFICATIONS * sizeof(struct dj_report) = 8 * 15.
> > Then current code would allocate a size of rounddown_power_of_2(120) =
> > 64 bytes, which can hold 4 dj_report only once, which is a half of expected.
> > 
> 
> This will go away with a log API.
> 
> > There are few more examples like this.
> > 
> > And, kfifo_init used a pre-allocated buffer, it would be a little strange
> > to ask user to pre-allocate a power of 2 size aligned buffer.
> > 
> > So, I guess it's would be good to support none-power-of-2 kfifo?
> > 
> > I know you care the performance a lot. Well, as Andrew said, it may
> > introduce a little insignificant drop(no modulus, few more add/dec).
> > Thus, do you have some benchmarks for that? I can have a test to check
> > if it is a insignificant change on performance or not :)
> > 
> 
> Dirty, Ugly, Hacky and this will produce a lot of overhead, especially
> for kfifo_put and kfifo_get which are inlined code.

Yes, it is. I will try log API then.

Stefani, I found an issue while rework to current API. Say the current
code of __kfifo_init:
    int __kfifo_init(struct __kfifo *fifo, void *buffer,
                    unsigned int size, size_t esize)
    {
        size /= esize;

        if (!is_power_of_2(size))
                size = rounddown_pow_of_two(size);
        ....
    }

Even thought I changed the API to something like:
    int __kfifo_init(struct __kfifo *fifo, void *buffer,
                    int size_order, size_t esize)
    {
	unsigned int size = 1 << size_order;

	size /= esize;
	...
    }

See? There is still a divide and we can't make it sure that it will be
power of 2 after that.

So, I came up 2 proposal to fix this.

1. refactor the meaning of 'size' argument first.

   'size' means the size of pre-allocated buffer. We can refactor it to
   meaning of 'the number of fifo elements' just like __kfifo_alloc, so
   that we don't need do the size /= esize stuff.

2. remove kfifo_init

   As we can't make sure that kfifo will do exactly what users asked(in
   the way of fifo size). It would be safe and good to maintain buffer
   and buffer size inside kfifo. So, I propose to remove it and use
   kfifo_alloc instead.

   git grep 'kfifo_init\>' shows that we currently have 2 users only.


The first way is hacky, and it doesn't make much sense to me. Since
buffer is pre-allocated by user but not kfifo. User has to calculate
element size and the number of elements, which is not friendly.

The second way does make more sense to me.

So, Stefani, what's your comments on that?

Thanks!

	--yliu
 
> In the kernel world it was always a regular use case to use power-of-2
> restricted API's, f.e. the slab cache.
> 
> I see no benefit for a none-power-of-2 kfifo, only drawbacks.
> 

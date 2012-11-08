Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483Ab2KHMYJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 07:24:09 -0500
Received: from mga02.intel.com ([134.134.136.20]:46149 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755418Ab2KHMX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 07:23:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,737,1344236400"; 
   d="scan'208";a="238981093"
Date: Thu, 8 Nov 2012 20:24:09 +0800
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stefani Seibold <stefani@seibold.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] kfifo: round up the fifo size power of 2
Message-ID: <20121108122409.GN18293@yliu-dev.sh.intel.com>
References: <1351238218-22648-1-git-send-email-yuanhan.liu@linux.intel.com>
 <20121029135935.bb8b0b2a.akpm@linux-foundation.org>
 <20121031055916.GC29509@yliu-dev.sh.intel.com>
 <1351665033.23165.6.camel@wall-e>
 <20121030235210.4dfc6ef7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121030235210.4dfc6ef7.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2012 at 11:52:10PM -0700, Andrew Morton wrote:
> On Wed, 31 Oct 2012 07:30:33 +0100 Stefani Seibold <stefani@seibold.net> wrote:
> 
> > > Yes, and I guess the same to give them a 64-element one.
> > > 
> > > > 
> > > > If there's absolutely no prospect that the kfifo code will ever support
> > > > 100-byte fifos then I guess we should rework the API so that the caller
> > > > has to pass in log2 of the size, not the size itself.  That way there
> > > > will be no surprises and no mistakes.
> > > > 
> > > > That being said, the power-of-2 limitation isn't at all intrinsic to a
> > > > fifo, so we shouldn't do this.  Ideally, we'd change the kfifo
> > > > implementation so it does what the caller asked it to do!
> > > 
> > > I'm fine with removing the power-of-2 limitation. Stefani, what's your
> > > comment on that?
> > > 
> > 
> > You can't remove the power-of-2-limitation, since this would result in a
> > performance decrease (bit wise and vs. modulo operation).
> 
> Probably an insignificant change in performance.
> 
> It could be made much smaller by just never doing the modulus operation
> - instead do
> 
> 	if (++index == max)
> 		index = 0;
> 
> this does introduce one problem: it's no longer possible to distinguish
> the "full" and "empty" states by comparing the head and tail indices. 
> But that is soluble.

Hi Andrew,

Yes, it is soluble. How about the following solution?

Add 2 more fields(in_off and out_off) in __kfifo structure, so that in
and out will keep increasing each time, while in_off and out_off will be
wrapped to head if goes to the end of fifo buffer.

So, we can use in and out for counting unused space, and distinguish the
"full" and "empty" state, and also, of course no need for locking.

Stefani, sorry for quite late reply. I checked all the code used kfifo_alloc
and kfifo_init. Firstly, there are a lot of users ;-)

And secondly, I did find some examples used kfifo as it supports
none-power-of-2 kfifo. Say, the one at drivers/hid/hid-logitech-dj.c:
       if (kfifo_alloc(&djrcv_dev->notif_fifo,
                       DJ_MAX_NUMBER_NOTIFICATIONS * sizeof(struct dj_report),
                       GFP_KERNEL)) {

which means it wants to allocate a kfifo buffer which can store
DJ_MAX_NUMBER_NOTIFICATIONS(8 here) dj_report(each 15 bytes) at once.

And DJ_MAX_NUMBER_NOTIFICATIONS * sizeof(struct dj_report) = 8 * 15.
Then current code would allocate a size of rounddown_power_of_2(120) =
64 bytes, which can hold 4 dj_report only once, which is a half of expected.

There are few more examples like this.

And, kfifo_init used a pre-allocated buffer, it would be a little strange
to ask user to pre-allocate a power of 2 size aligned buffer.

So, I guess it's would be good to support none-power-of-2 kfifo?

I know you care the performance a lot. Well, as Andrew said, it may
introduce a little insignificant drop(no modulus, few more add/dec).
Thus, do you have some benchmarks for that? I can have a test to check
if it is a insignificant change on performance or not :)

Thanks!

	--yliu

> 
> > Andrew is right, this is an API miss design.  So it would be good to
> > rework the kfifo_init () and kfifo_alloc() to pass in log2 of the size,
> > not the size itself.
> 
> The power-of-2 thing is just a restriction in the current
> implementation - it's not a good idea to cement that into the
> interface.  Of course, it could later be uncemented if the
> implementation's restriction was later relaxed.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205Ab2KHMiD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 07:38:03 -0500
Received: from www84.your-server.de ([213.133.104.84]:49250 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059Ab2KHMiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 07:38:00 -0500
Message-ID: <1352378235.15351.9.camel@wall-e>
Subject: Re: [PATCH 1/2] kfifo: round up the fifo size power of 2
From: Stefani Seibold <stefani@seibold.net>
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Date: Thu, 08 Nov 2012 13:37:15 +0100
In-Reply-To: <20121108122409.GN18293@yliu-dev.sh.intel.com>
References: <1351238218-22648-1-git-send-email-yuanhan.liu@linux.intel.com>
	 <20121029135935.bb8b0b2a.akpm@linux-foundation.org>
	 <20121031055916.GC29509@yliu-dev.sh.intel.com>
	 <1351665033.23165.6.camel@wall-e>
	 <20121030235210.4dfc6ef7.akpm@linux-foundation.org>
	 <20121108122409.GN18293@yliu-dev.sh.intel.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, den 08.11.2012, 20:24 +0800 schrieb Yuanhan Liu:
> On Tue, Oct 30, 2012 at 11:52:10PM -0700, Andrew Morton wrote:
> > On Wed, 31 Oct 2012 07:30:33 +0100 Stefani Seibold <stefani@seibold.net> wrote:
> > 
> > > > Yes, and I guess the same to give them a 64-element one.
> > > > 
> > > > > 
> > > > > If there's absolutely no prospect that the kfifo code will ever support
> > > > > 100-byte fifos then I guess we should rework the API so that the caller
> > > > > has to pass in log2 of the size, not the size itself.  That way there
> > > > > will be no surprises and no mistakes.
> > > > > 
> > > > > That being said, the power-of-2 limitation isn't at all intrinsic to a
> > > > > fifo, so we shouldn't do this.  Ideally, we'd change the kfifo
> > > > > implementation so it does what the caller asked it to do!
> > > > 
> > > > I'm fine with removing the power-of-2 limitation. Stefani, what's your
> > > > comment on that?
> > > > 
> > > 
> > > You can't remove the power-of-2-limitation, since this would result in a
> > > performance decrease (bit wise and vs. modulo operation).
> > 
> > Probably an insignificant change in performance.
> > 
> > It could be made much smaller by just never doing the modulus operation
> > - instead do
> > 
> > 	if (++index == max)
> > 		index = 0;
> > 
> > this does introduce one problem: it's no longer possible to distinguish
> > the "full" and "empty" states by comparing the head and tail indices. 
> > But that is soluble.
> 
> Hi Andrew,
> 
> Yes, it is soluble. How about the following solution?
> 
> Add 2 more fields(in_off and out_off) in __kfifo structure, so that in
> and out will keep increasing each time, while in_off and out_off will be
> wrapped to head if goes to the end of fifo buffer.
> 
> So, we can use in and out for counting unused space, and distinguish the
> "full" and "empty" state, and also, of course no need for locking.
> 
> Stefani, sorry for quite late reply. I checked all the code used kfifo_alloc
> and kfifo_init. Firstly, there are a lot of users ;-)
> 
> And secondly, I did find some examples used kfifo as it supports
> none-power-of-2 kfifo. Say, the one at drivers/hid/hid-logitech-dj.c:
>        if (kfifo_alloc(&djrcv_dev->notif_fifo,
>                        DJ_MAX_NUMBER_NOTIFICATIONS * sizeof(struct dj_report),
>                        GFP_KERNEL)) {
> 
> which means it wants to allocate a kfifo buffer which can store
> DJ_MAX_NUMBER_NOTIFICATIONS(8 here) dj_report(each 15 bytes) at once.
> 
> And DJ_MAX_NUMBER_NOTIFICATIONS * sizeof(struct dj_report) = 8 * 15.
> Then current code would allocate a size of rounddown_power_of_2(120) =
> 64 bytes, which can hold 4 dj_report only once, which is a half of expected.
> 

This will go away with a log API.

> There are few more examples like this.
> 
> And, kfifo_init used a pre-allocated buffer, it would be a little strange
> to ask user to pre-allocate a power of 2 size aligned buffer.
> 
> So, I guess it's would be good to support none-power-of-2 kfifo?
> 
> I know you care the performance a lot. Well, as Andrew said, it may
> introduce a little insignificant drop(no modulus, few more add/dec).
> Thus, do you have some benchmarks for that? I can have a test to check
> if it is a insignificant change on performance or not :)
> 

Dirty, Ugly, Hacky and this will produce a lot of overhead, especially
for kfifo_put and kfifo_get which are inlined code.

In the kernel world it was always a regular use case to use power-of-2
restricted API's, f.e. the slab cache.

I see no benefit for a none-power-of-2 kfifo, only drawbacks.



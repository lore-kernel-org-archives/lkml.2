Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916Ab2LOKhh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 05:37:37 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:45312 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214Ab2LOKhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 05:37:33 -0500
Date: Sat, 15 Dec 2012 02:36:58 -0800
From: Kent Overstreet <koverstreet@google.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Jack Wang <jack.wang.usish@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "zab@redhat.com" <zab@redhat.com>, "bcrl@kvack.org" <bcrl@kvack.org>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 00/26] AIO performance improvements/cleanups, v2
Message-ID: <20121215103658.GB10411@moria.home.lan>
References: <1354568322-29029-1-git-send-email-koverstreet@google.com>
 <20121213211808.GJ25017@kernel.dk>
 <CA+res+SKXjXTgrxPaj+kuekd-CZMp4POkSpsdJ7Csfg0HsD=bA@mail.gmail.com>
 <50CAD6D9.5070703@fusionio.com>
 <20121215092526.GA10411@moria.home.lan>
 <50CC46F8.3070600@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50CC46F8.3070600@fusionio.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 15, 2012 at 10:46:32AM +0100, Jens Axboe wrote:
> On 2012-12-15 10:25, Kent Overstreet wrote:
> > Cool, thanks for the numbers!
> > 
> > I suspect the difference is due to contention on the ringbuffer,
> > completion side. You didn't enable my batched completion stuff, did you?
> 
> No, haven't tried the batching yet.
> 
> > I suspect the numbers would look quite a bit different with that,
> > based on my own profiling. If the driver for the device you're testing
> > on is open source, I'd be happy to do the conversion (it's a 5 minute
> > job).
> 
> Knock yourself out - I already took a quick look at it, and conversion
> should be pretty simple. It's the mtip32xx driver, it's in the kernel. I
> would suggest getting rid of the ->async_callback() (since it's always
> bio_endio()) since that'll make it cleaner.

Just pushed my conversion - it's untested, but it's pretty
straightforward.

> 
> > Also, I don't think our approaches really conflict - it's been awhile
> 
> Completely agree. I split my patches up a bit yesterday, and then I took
> a look at your series. There's a bit of overlap between the two, but
> really most of it would be useful together. You can see the (bit more)
> split series here:
> 
> http://git.kernel.dk/?p=linux-block.git;a=shortlog;h=refs/heads/aio-dio

Cool, taking a look at it now.

> 
> > since I looked at your patch but you're getting rid of the aio
> > ringbuffer and using a linked list instead, right? My batched completion
> > stuff should still benefit that case.
> 
> Yes, I make the ring interface optional. Basically you tell aio to use
> the ring or not at io_queue_init() time. If you don't care about the
> ring, we can use a lockless list for the completions.

Yeah, it is a good idea - I'm certainly not attached to the current
ringbuffer implementation (though a ringbuffer isn't a terrible idea if
we had one that was implemented correctly).

> You completely remove the cancel, I just make it optional for the gadget
> case. I'm fine with either of them, though I did not look at your usb
> change in detail. If it's clean, I suspect we should just kill cancel
> completion as you did.

We (Zach and I) actually made it optional too, more or less - I haven't
looked at how you did it yet, but in my tree the linked list is there,
but the kiocb isn't added to the kioctx's list until something sets a
cancel function.

> > Though - hrm, I'd have expected getting rid of the cancellation linked
> > list to make a bigger difference and both our patchsets do that.
> 
> The machine in question runs out of oomph, which is hampering the
> results. I should have it beefed up next week. It's running E5-2630
> right now, will move to E5-2690. I think that should make the results
> clearer.

Well, the fact that it's cpu bound just means the throughput numbers for
our various patches are different... and what I'm really interested in
is the profiles, I can't think of any reason cpu speed would affect that
much.

> > What device are you testing on, and what's your fio script? I may just
> > have to buy some hardware so I can test this myself.
> 
> Pretty basic script, it's attached. Probably could eek more out of the
> system, but it's been fine for just basic apples-to-apples comparison.
> I'm using 6x p320h for this test case.

Thanks - I'll have to see if I can get something setup that roughly
matches your setup. 

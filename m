Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075Ab2LOJ0G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 04:26:06 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:57809 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab2LOJ0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 04:26:01 -0500
Date: Sat, 15 Dec 2012 01:25:26 -0800
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
Message-ID: <20121215092526.GA10411@moria.home.lan>
References: <1354568322-29029-1-git-send-email-koverstreet@google.com>
 <20121213211808.GJ25017@kernel.dk>
 <CA+res+SKXjXTgrxPaj+kuekd-CZMp4POkSpsdJ7Csfg0HsD=bA@mail.gmail.com>
 <50CAD6D9.5070703@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50CAD6D9.5070703@fusionio.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2012 at 08:35:53AM +0100, Jens Axboe wrote:
> On 2012-12-14 03:26, Jack Wang wrote:
> > 2012/12/14 Jens Axboe <jaxboe@fusionio.com>:
> >> On Mon, Dec 03 2012, Kent Overstreet wrote:
> >>> Last posting: http://thread.gmane.org/gmane.linux.kernel.aio.general/3169
> >>>
> >>> Changes since the last posting should all be noted in the individual
> >>> patch descriptions.
> >>>
> >>>  * Zach pointed out the aio_read_evt() patch was calling functions that
> >>>    could sleep in TASK_INTERRUPTIBLE state, that patch is rewritten.
> >>>  * Ben pointed out some synchronize_rcu() usage was problematic,
> >>>    converted it to call_rcu()
> >>>  * The flush_dcache_page() patch is new
> >>>  * Changed the "use cancellation list lazily" patch so as to remove
> >>>    ki_flags from struct kiocb.
> >>
> >> Kent, I ran a few tests, and the below patches still don't seem as fast
> >> as the approach I took. To keep it fair, I used your aio branch and
> >> applied by dio speedups too. As a sanity check, I ran with your branch
> >> alone as well. The quick results below - kaio is kent-aio, just your
> >> branch. kaio-dio is with the direct IO speedups too. jaio is my branch,
> >> which already has the dio changes too.
> >>
> >> Devices         Branch          IOPS
> >> 1               kaio            ~915K
> >> 1               kaio-dio        ~930K
> >> 1               jaio           ~1220K
> >> 6               kaio           ~3050K
> >> 6               kaio-dio       ~3080K
> >> 6               jaio            3500K
> >>
> >> The box runs out of CPU driving power, which is why it doesn't scale
> >> linearly, otherwise I know that jaio at least does. It's basically
> >> completion limited for the 6 device test at the moment.
> >>
> >> I'll run some profiling tomorrow morning and get you some better
> >> results. Just thought I'd share these at least.
> >>
> >> --
> >> Jens Axboe
> >>
> > 
> > A really good performance, woo.
> > 
> > I think the device tested is really fast PCIe SSD builded by fusionio
> > with fusionio in house block driver?
> 
> It is pci-e flash storage, but it is not fusion-io.
> 
> > any compare number with current mainline?
> 
> Sure, I should have included that. Here's the table again, this time
> with mainline as well.
> 
> Devices         Branch          IOPS
> 1               mainline        ~870K
> 1               kaio            ~915K
> 1               kaio-dio        ~930K
> 1               jaio           ~1220K
> 6               kaio           ~3050K
> 6               kaio-dio       ~3080K
> 6               jaio           ~3500K
> 6               mainline       ~2850K

Cool, thanks for the numbers!

I suspect the difference is due to contention on the ringbuffer,
completion side. You didn't enable my batched completion stuff, did you?

I suspect the numbers would look quite a bit different with that,
based on my own profiling. If the driver for the device you're testing
on is open source, I'd be happy to do the conversion (it's a 5 minute
job).

Also, I don't think our approaches really conflict - it's been awhile
since I looked at your patch but you're getting rid of the aio
ringbuffer and using a linked list instead, right? My batched completion
stuff should still benefit that case.

Though - hrm, I'd have expected getting rid of the cancellation linked
list to make a bigger difference and both our patchsets do that.

What device are you testing on, and what's your fio script? I may just
have to buy some hardware so I can test this myself.

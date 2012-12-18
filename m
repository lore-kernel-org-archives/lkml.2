Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab2LRTX6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 14:23:58 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:43476 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993Ab2LRTX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 14:23:57 -0500
X-Greylist: delayed 440 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Dec 2012 14:23:57 EST
Date: Tue, 18 Dec 2012 11:16:33 -0800
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
Message-ID: <20121218191633.GB24548@google.com>
References: <1354568322-29029-1-git-send-email-koverstreet@google.com>
 <20121213211808.GJ25017@kernel.dk>
 <CA+res+SKXjXTgrxPaj+kuekd-CZMp4POkSpsdJ7Csfg0HsD=bA@mail.gmail.com>
 <50CAD6D9.5070703@fusionio.com>
 <20121215092526.GA10411@moria.home.lan>
 <50CC46F8.3070600@fusionio.com>
 <20121215103658.GB10411@moria.home.lan>
 <50CC7840.4090403@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50CC7840.4090403@fusionio.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 15, 2012 at 02:16:48PM +0100, Jens Axboe wrote:
> On 2012-12-15 11:36, Kent Overstreet wrote:
> >> Knock yourself out - I already took a quick look at it, and conversion
> >> should be pretty simple. It's the mtip32xx driver, it's in the kernel. I
> >> would suggest getting rid of the ->async_callback() (since it's always
> >> bio_endio()) since that'll make it cleaner.
> > 
> > Just pushed my conversion - it's untested, but it's pretty
> > straightforward.
> 
> You forgot a batch_complete_init(). With that, it works. Single device
> is ~1050K now, so still slower than jaio without batching (which was
> ~1220K).  But it's an improvement over kaio-dio, which was roughly ~930K
> IOPS.

Curious... if the device is delivering a reasonable number of
completions per interrupt, I would've expected that to help more (it
made a huge difference for me). Now I'm really curious where the
difference is coming from.

It's possible something I did introduced a performance regression you're
uncovering (i.e. I reordered stuff in struct kiocb to shrink it, not
sure if you were testing with those changes). It sounds like the
mtip32xx driver is better/more efficient than anything I can test with,
so if so it's entirely possible you're seing it due to less noise there.

Or maybe just getting rid of the ringbuffer is that awesome. Gonna try
and work on combining our optimizations so I can see what that looks
like :)

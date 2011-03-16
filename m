Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757183Ab1CPAru (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 20:47:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39502 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753844Ab1CPArt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 20:47:49 -0400
Date: Tue, 15 Mar 2011 17:44:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org,
        oakad@yahoo.com
Subject: Re: [PATCH 1/4] scatterlist: new helper functions
Message-Id: <20110315174459.54b02f99.akpm@linux-foundation.org>
In-Reply-To: <1299464437.24051.13.camel@maxim-laptop>
References: <1299212213-4255-2-git-send-email-maximlevitsky@gmail.com>
	<20110306162859E.fujita.tomonori@lab.ntt.co.jp>
	<1299424470.22378.9.camel@maxim-laptop>
	<20110307064900X.fujita.tomonori@lab.ntt.co.jp>
	<1299464437.24051.13.camel@maxim-laptop>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 Mar 2011 04:20:37 +0200 Maxim Levitsky <maximlevitsky@gmail.com> wrote:

> On Mon, 2011-03-07 at 06:49 +0900, FUJITA Tomonori wrote:
> > On Sun, 06 Mar 2011 17:14:30 +0200
> > Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> > 
> > > On Sun, 2011-03-06 at 16:29 +0900, FUJITA Tomonori wrote:
> > > > On Fri,  4 Mar 2011 06:16:50 +0200
> > > > Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> > > > 
> > > > > While developing memstick driver for legacy memsticks
> > > > > I found the need in few helpers that I think should be
> > > > > in common scatterlist library
> > > > > 
> > > > > The functions that were added:
> > > > > 
> > > > > * sg_nents/sg_total_len - iterate over scatterlist to figure
> > > > > out total length of memory it covers / number of entries.
> > > > 
> > > > You should invent a data structure per I/O request, something like
> > > > msb_request structure. Then you can store nents and total_len in
> > > > that.
> > > > 
> > > > That's what block subsystems and drivers do. I took a look at your
> > > > driver but I can't see why your driver can't do the same.
> > > I also need to break the request into small grained chunks.
> > > If I invent such structure, I will end up writing these helpers for it.
> > > 
> > > The I have this lifetime of a request:
> > > 
> > > I get arbitary sized request from block layer (I can of course control
> > > maximum size/number of segments in it, etc).
> > > 
> > > I break it into eraseblock sized chunks, and for each I translate the
> > > the LBA, into flash address.
> > > 
> > > Then I break it into flash page sized requests (512 bytes), and yet its
> > > better not to assume that such requests always contained in one sg
> > > entry.
> > > 
> > > Worse than that, I have to pass an sg list that spans always one 512
> > > page to lowlevel driver, because thats how Alex defined the interface.
> > 
> > This restriction is due to hardware specification or the software
> > design (e.g. memstick layer)? If it is due to the latter, why can't
> > you fix that?
> 
> Yes.
> I already tried addressing some shortcomings of memstick layer, no no, I
> don't want to deal with its author, Alex Dubov again.
> I think this code tries to be too clever/complex for the range of
> devices/speeds it supports, but I rather leave it as is.
> 

I have to say, these aren't very good reasons for a particular
implementation!

> To be honest, the code in question is for >5 year old memstick standard
> cards, thats hardly anybody uses.
> It works, it is more or less simple, its not performance bound, its
> testd, and thus I want to keep it as is _for_ now.
> 
> 
> Why I break sg lists into chunks?
> Because unlike vast majority of block devices, I need to do FTL in the
> driver, thus its easier to work on eraseblock boundary.
> Also unlike anything else, you can't just read/write a sector from a
> memorystick (especially the legacy one), you have to perform full dance
> of commands.
> 
> Not to mention error handling (like if you failed to write to block, you
> must try to choose another one, etc...)
> 
> (Of course writes follow same rules as raw nand flash, thats is writes
> only clear bits, and you can erase a eraseblock only).

hm.  If you think there's little likelihood that other drivers will
need the new sg functions in the future then perhaps they should be
made private to the memstick driver, rather than bloating everyone's
kernels.  Which is, I think, the exact opposite of what I suggested
last year :(

Fujita-san, you've gone all quiet.  Do you believe that these functions
should be added to the sg API?

Thanks.


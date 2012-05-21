Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932589Ab2EUXgt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 19:36:49 -0400
Received: from www.linutronix.de ([62.245.132.108]:34087 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921Ab2EUXgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 19:36:48 -0400
Date: Tue, 22 May 2012 01:36:43 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Michael S. Tsirkin" <mst@redhat.com>
cc: kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: optimize ISR lookups
In-Reply-To: <20120521230623.GO17031@redhat.com>
Message-ID: <alpine.LFD.2.02.1205220118080.3231@ionos>
References: <20120521163727.GA13337@redhat.com> <alpine.LFD.2.02.1205211940030.3231@ionos> <20120521230623.GO17031@redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2012, Michael S. Tsirkin wrote:
> On Mon, May 21, 2012 at 11:04:25PM +0200, Thomas Gleixner wrote:
> > On Mon, 21 May 2012, Michael S. Tsirkin wrote:
> > > +static u8 count_vectors(void *bitmap)
> > > +{
> > > +	u32 *word = bitmap;
> > > +	int word_offset;
> > > +	u8 count = 0;
> > > +	for (word_offset = 0; word_offset < MAX_APIC_VECTOR >> 5; ++word_offset)
> > > +		count += hweight32(word[word_offset << 2]);
> > > +	return count;
> > > +}
> > 
> > Why do you need to reimplement bitmap_weight()?
> > 
> > Because your bitmap is not a bitmap,
> 
> It's an existing "bitmap". It's not my bitmap :)

Dammit. You added a function:

+static u8 count_vectors(void *bitmap)

So it's YOUR bitmap. It's YOUR fault that you copied mindlessly the
existing crap.

And you just copied it to push performance without even thinking about
the underlying problems.

And now you expect me to accept this just because someone else missed
to use his brain when implementing the exisiting nonsense ?

> > Yes, I know, the existing code is full of this, but that's not an
> > excuse to add more of it.
> 
> There's no other way to use existing code. If current code
> is reworked to use bitmap.h then my patch can use it too.

Then sit down and rework the existing code instead of insisting on
something which makes the code worse than it is already.

> > This emulation is just silly. Nothing in an emulation where the access
> > to the emulated hardware is implemented with vmexits is requiring a
> > 1:1 memory layout. It's completely irrelevant whether the hardware has
> > an ISR regs offset of 0x10 or not. Nothing prevents the emulation to
> > use a consecutive bitmap for the vector bits instead of reimplementing
> > a boatload of bitmap operations.
> > 
> > The only justification for having the same layout as the actual
> > hardware is when you are going to map the memory into the guest space,
> > which is not the case here.
> 
> I think the reason is __apic_read which now simply copies the registers
> out to guest, this code will become less straight-forward if it's not
> 1:1.

Oh yes. You didn't even read the few lines below, which explain what's
wrong and why the existing code is less straight forward than
optimized code.
 
> > And if you look deeper, then you'll notice that _ALL_ APIC registers
> > are on a 16 byte boundary (thanks Peter for pointing that out).
> > 
> > So it's even more silly to have a 1:1 representation instead of
> > implementing the default emulated apic_read/write functions to access
> > (offset >> 2).
> > 
> > And of course, that design decision causes lookups to be slow.
> 
> Yes, it might be one of the reasons why my patch helps so
> much: it adds a cache in front of this data structure.

Obviously you didn't even try to answer my obresvations/questions, you
are just justfying your hackery.

> So what you propose is in fact to rework apic registers at least for
> ISR,IRR,TMR to use a bitmap.

This is the final confirmation that you never tried to understand my
reply. Hint: "s/at least.*//"

> I am fine with this suggestion but would like some feedback from kvm
> maintainers on where they want to go before I spend time on that.

Are the kvm maintainers controlling your common sense or what ?

Thanks,

	tglx

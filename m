Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751254Ab1GYGnn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 02:43:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53782 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967Ab1GYGnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 02:43:39 -0400
Date: Mon, 25 Jul 2011 08:42:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Lutomirski <luto@mit.edu>
Cc: linux-kernel@vger.kernel.org, x86 <x86@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>, Avi Kivity <avi@redhat.com>
Subject: Re: [RFC] syscall calling convention, stts/clts, and xstate latency
Message-ID: <20110725064252.GD694@elte.hu>
References: <CAObL_7GCDsfXWRJgkNk7c44GNF0JhQPAH_P0WiYHK7QUX1Bcaw@mail.gmail.com>
 <20110724211526.GA6785@elte.hu>
 <CAObL_7H1j1cewgWP6Jmkw_H9dZVh1kxRGgTLa+ju=ns4gYxMdA@mail.gmail.com>
 <CAObL_7EuFXbuxpz2bzKuEReyDHo+mBxDyJSf_rjBKpdnUmEzLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAObL_7EuFXbuxpz2bzKuEReyDHo+mBxDyJSf_rjBKpdnUmEzLQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Lutomirski <luto@mit.edu> wrote:

> On Sun, Jul 24, 2011 at 6:34 PM, Andrew Lutomirski <luto@mit.edu> wrote:
> >
> > I had in mind something a little less ambitious: making 
> > kernel_fpu_begin very fast, especially when used more than once. 
> > Currently it's slow enough to have spawned arch/x86/crypto/fpu.c, 
> > which is a hideous piece of infrastructure that exists solely to 
> > reduce the number of kernel_fpu_begin/end pairs when using 
> > AES-NI. Clobbering registers in syscall would reduce the cost 
> > even more, but it might require having a way to detect whether 
> > the most recent kernel entry was via syscall or some other means.
> 
> I think it will be very hard to inadvertently cause a regression, 
> because the current code looks pretty bad.

[ heh, one of the rare cases where bad code works in our favor ;-) ]

> 1. Once a task uses xstate for five timeslices, the kernel decides 
> that it will continue using it.  The only thing that clears that 
> condition is __unlazy_fpu called with TS_USEDFPU set.  The only way 
> I can see for that to happen is if kernel_fpu_begin is called twice 
> in a row between context switches, and that has little do with the 
> task's xstate usage.
> 
> 2. __switch_to, when switching to a task with fpu_counter > 5, will 
> do stts(); clts().
> 
> The combination means that when switching between two xstate-using 
> tasks (or even tasks that were once xstate-using), we pay the full 
> price of a state save/restore *and* stts/clts.

I'm all for simplifying this for modern x86 CPUs.

The lazy FPU switching logic was kind of neat on UP but started 
showing its limitations with SMP already - and that was 10 years ago.

So if the numbers prove you right then go for it. It's an added bonus 
that this could enable the kernel to be built using vector 
instructions - you may or may not want to shoot for the glory of 
achieving that feat first ;-)

Thanks,

	Ingo

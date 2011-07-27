Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003Ab1G0IAF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 04:00:05 -0400
Received: from gate.crashing.org ([63.228.1.57]:49330 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753386Ab1G0IAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 04:00:03 -0400
Subject: Re: [RFC/PATCH] mm/futex: Fix futex writes on archs with SW
 tracking of dirty & young
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Shan Hai <haishan.bai@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, paulus@samba.org,
        tglx@linutronix.de, walken@google.com, dhowells@redhat.com,
        cmetcalf@tilera.com, tony.luck@intel.com, akpm@linux-foundation.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org
In-Reply-To: <CAMjpGUdxpaYBFfKjBEPFOJohnKoXfagLUHvhrst+NembeabxcA@mail.gmail.com>
References: <1310717238-13857-1-git-send-email-haishan.bai@gmail.com>
	 <1310717238-13857-2-git-send-email-haishan.bai@gmail.com>
	 <1310725418.2586.309.camel@twins> <4E21A526.8010904@gmail.com>
	 <1310860194.25044.17.camel@pasglop>
	 <4b337921-d430-4b63-bc36-ad31753cf800@email.android.com>
	 <1310912990.25044.203.camel@pasglop> <1310944453.25044.262.camel@pasglop>
	 <1310961691.25044.274.camel@pasglop> <4E23D728.7090406@gmail.com>
	 <1310972462.25044.292.camel@pasglop> <4E23E02C.8090401@gmail.com>
	 <1310974591.25044.298.camel@pasglop> <4E24FA51.70602@gmail.com>
	 <1311049762.25044.392.camel@pasglop>
	 <CAMjpGUdxpaYBFfKjBEPFOJohnKoXfagLUHvhrst+NembeabxcA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Jul 2011 17:58:33 +1000
Message-ID: <1311753513.25044.663.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-26 at 23:50 -0700, Mike Frysinger wrote:
> On Mon, Jul 18, 2011 at 21:29, Benjamin Herrenschmidt wrote:
> > The futex code currently attempts to write to user memory within
> > a pagefault disabled section, and if that fails, tries to fix it
> > up using get_user_pages().
> >
> > This doesn't work on archs where the dirty and young bits are
> > maintained by software, since they will gate access permission
> > in the TLB, and will not be updated by gup().
> >
> > In addition, there's an expectation on some archs that a
> > spurious write fault triggers a local TLB flush, and that is
> > missing from the picture as well.
> >
> > I decided that adding those "features" to gup() would be too much
> > for this already too complex function, and instead added a new
> > simpler fixup_user_fault() which is essentially a wrapper around
> > handle_mm_fault() which the futex code can call.
> 
> unfortunately, this breaks all nommu ports.  you added
> fixup_user_fault() to mm/memory.c only which is not used by nommu

Argh. Andrew, do you want to send a fix ? I won't be able to do that
tonight, I have to go.

What should nommu do anyways ? it's not like there's much it can do
right ? It should never even hit the fault path to start with ...

Cheers,
Ben.



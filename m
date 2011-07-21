Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907Ab1GUWxB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 18:53:01 -0400
Received: from gate.crashing.org ([63.228.1.57]:40007 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505Ab1GUWw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 18:52:58 -0400
Subject: Re: [RFC/PATCH] mm/futex: Fix futex writes on archs with SW
 tracking of dirty & young
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Shan Hai <haishan.bai@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, paulus@samba.org,
        tglx@linutronix.de, walken@google.com, dhowells@redhat.com,
        cmetcalf@tilera.com, tony.luck@intel.com,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <20110721153606.37e6f432.akpm@linux-foundation.org>
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
	 <20110721153606.37e6f432.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Jul 2011 08:52:06 +1000
Message-ID: <1311288726.25044.545.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-21 at 15:36 -0700, Andrew Morton wrote:
> On Tue, 19 Jul 2011 14:29:22 +1000
> Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> 
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
> > 
> > Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > ---
> > 
> > Shan, can you test this ? It might not fix the problem
> 
> um, what problem.  There's no description here of the user-visible
> effects of the bug hence it's hard to work out what kernel version(s)
> should receive this patch.

Shan could give you an actual example (it was in the previous thread),
but basically, livelock as the kernel keeps trying and trying the
in_atomic op and never resolves it.
 
> What kernel version(s) should receive this patch?

I haven't dug. Probably anything it applies on as far as we did that
trick of atomic + gup() for futex.

> > since I'm
> > starting to have the nasty feeling that you are hitting what is
> > somewhat a subtly different issue or my previous patch should
> > have worked (but then I might have done a stupid mistake as well)
> > but let us know anyway.
> 
> I assume that Shan reported the secret problem so I added the
> reported-by to the changelog.

He did :-) Shan, care to provide a rough explanation of what you
observed ?

Also Russell confirmed that ARM should be affected as well.

Cheers,
Ben.


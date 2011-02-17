Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440Ab1BQSBj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 13:01:39 -0500
Received: from [65.115.85.73] ([65.115.85.73]:63331 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757390Ab1BQSBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 13:01:37 -0500
Date: Thu, 17 Feb 2011 10:00:42 -0800
From: Dmitry Torokhov <dtor@vmware.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH 1/3] module: deal with alignment issues in built-in
 module versions
Message-ID: <20110217180042.GA30530@dtor-ws.eng.vmware.com>
References: <1297123347-2170-1-git-send-email-dtor@vmware.com>
 <AANLkTim_BL_Cw=X0iuatgw1F4n50CyXv0uqx9n=5=Bq+@mail.gmail.com>
 <20110217173136.GA28486@dtor-ws.eng.vmware.com>
 <AANLkTikGVS9EM=7uhwYfXrGHg9yzes7m0pxAinRxivPC@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikGVS9EM=7uhwYfXrGHg9yzes7m0pxAinRxivPC@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 09:45:37AM -0800, Linus Torvalds wrote:
> On Thu, Feb 17, 2011 at 9:31 AM, Dmitry Torokhov <dtor@vmware.com> wrote:
> >
> > From what I understand __attribute__ ((aligned(x))) only guarantees
> > minimum alignment, not exact (gapless) alignment. GCC seems to lay out
> > pointers in the section without gaps on all arches that we have.
> 
> I still don't see the problem.
> 
> Have you actually _tried_ just adding the proper alignment to before
> the __modver thing in include/asm-generic/vmlinux.lds.h ?
> 
> As far as I can tell, the bug is really simple:
>  - the section is not aligned
>  - but we told the compiler that that structure is aligned
> 
> End result: there is a gap between the section start and the first structure.
> 
> And the fix seems obvious: just make sure that the section is
> sufficiently aligned.
> 
> IOW, why isn't the proper fix the obvious trivial one (attached)?
> 

The problem is that on m68k size of the struct module_version_attribute
is not evenly divisible by sizeof(void *), thus when we lay out the
__modver section we align on 4 bytes but when we iterate we think that
the alignment is 2.

I/Geert tried adding __attribute__ (aligned(sizeof(void *))) to the type
definition itself so we have matching alignment everywhere, but DaveM
said that this only guarantees minimum alignment and that using
structures like we do shown to break from time to time in kprobes and
that only pointers worked reliably.

Thanks.

-- 
Dmitry

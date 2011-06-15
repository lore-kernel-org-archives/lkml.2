Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270Ab1FOQkA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 12:40:00 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43194 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab1FOQj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 12:39:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=C220YjCRbl+OuyiZCZCYLStHYZnlD36lJE8TlRe4z62nW8Wfmr+d2hUCge++ucylYZ
         SPkOxAq8ZR56KPqWTTdG74aCy6Qt6r4LtPJ3PpRccr8pm0jEPWIyosXz+GLviZqDF/WT
         vqwAQl3PXT/gySnKKM345uMcdCX1vbIZtrewU=
Date: Wed, 15 Jun 2011 18:39:52 +0200
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        David Rientjes <rientjes@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [slubllv7 04/17] x86: Add support for cmpxchg_double
Message-ID: <20110615163952.GE8141@htj.dyndns.org>
References: <20110601172543.437240675@linux.com>
 <20110601172614.173427964@linux.com>
 <20110615085512.GO8141@htj.dyndns.org>
 <alpine.DEB.2.00.1106150917520.768@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1106150917520.768@router.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Christoph.

On Wed, Jun 15, 2011 at 09:26:15AM -0500, Christoph Lameter wrote:
> > Do we really need cmpxchg16b*() macros separately?  Why not just
> > collapse them into cmpxchg_double*()?  Also, it would be better if we
> > have the same level of VM_BUG_ON() checks as in percpu cmpxchg_double
> > ops.  Maybe we should put them in a separate macro?
> 
> The method here is to put all the high level checks in cmpxchg_double()
> and then do the low level asm stuff in cmpxchg16b macros. I think that is
> a good separation.

I don't know; then, I think the name better clearly indicate that
they're not used outside of implementation.  I don't see merit in
keeping them separate.

> > > +#define system_has_cmpxchg_double() cpu_has_cx16
> >
> > Where's the fallback %false definition for the above feature macro for
> > archs which don't support cmpxchg_double?  Also, is system_has_*()
> > conventional?  Isn't arch_has_*() more conventional for this purpose?
> 
> There is a convention for querying processor flags from core code?

At least generic ptrace code uses arch_has_block/single_step().
Probably better than introducing something completely new.

> The system_has_cmpxchg_double() is only used if the arch defines
> CONFIG_CMPXCHG_DOUBLE

Why?  What's the benefit of that?

> This way it is done in the same way on 32 bit than on 64 bit. The use of
> cmpxchg64 also means that some of the parameters would have to be combined
> to form 64 bit ints from the 32 bit ones before __cmpxchg64 could be used.
> 
> __cmpxchg64 has different parameter conventions.

But they all just deal with the starting addresses and the _local
version already has proper fallback implementation.

> > Another thing is that choosing different code path depending on
> > has_cmpxchg_double() would be quite messy and won't bode well with
> > many people.  I agree that fallback implementation would be heavier
> > for SMP safe operations but some archs already do that for cmpxchg
> > (forgot which one).  If we're gonna export this to generic code,
> > wouldn't it be better to implement proper generic fallbacks and
> > provide has_*() as hint?
> 
> A generic fallback for cmpxchg_double would mean having to disable
> interrupts and then take a global spinlock. There are significant scaling
> problems with such an implementation.
> 
> The fallback through the subsystem means that the subsystem can do locking
> that scales better. In the case of SLUB we fall back to a bit lock in the
> page struct which is a hot cache line in the hotpaths. This is the same
> approach as used before the lockless patches and we expect the performance
> on platforms not supporting cmpxchg_double to stay the same.

Yes, that's nice but you're introducing new operations and they should
meet the usual conventions and cmpxchg fallback on the arch which I
don't recall now already uses hashed lock so it's not like this is
completely new.  As added, the interface basically requires extreme
ifdeffery which isn't good.

Thanks.

-- 
tejun

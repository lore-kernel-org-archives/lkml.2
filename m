Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932529Ab0DGHZh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 03:25:37 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38197 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932474Ab0DGHZb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 03:25:31 -0400
Subject: Re: [PATCH 1/2] sparc64: Implement local_irq_save_nmi().
From: Peter Zijlstra <peterz@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: mingo@elte.hu, acme@redhat.com, paulus@samba.org, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org, linux-arch@vger.kernel.org
In-Reply-To: <20100407.000625.203083228.davem@davemloft.net>
References: <20100406.163955.28809295.davem@davemloft.net>
	 <1270623146.5109.532.camel@twins>
	 <20100407.000625.203083228.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 07 Apr 2010 09:24:19 +0200
Message-ID: <1270625059.5109.537.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-07 at 00:06 -0700, David Miller wrote:
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Wed, 07 Apr 2010 08:52:26 +0200
> 
> > On Tue, 2010-04-06 at 16:39 -0700, David Miller wrote:
> >> @@ -49,6 +49,16 @@ static inline void raw_local_irq_disable(void)
> >>  	);
> >>  }
> >>  
> >> +static inline void raw_local_irq_disable_nmi(void)
> >> +{
> >> +	__asm__ __volatile__(
> >> +		"wrpr	%0, %%pil"
> >> +		: /* no outputs */
> >> +		: "i" (PIL_NMI)
> >> +		: "memory"
> >> +	);
> >> +}
> >> +
> > 
> > Isn't this wrong when used from !NMI context?
> > 
> > Should this thing do something like:
> > 
> >   if (rdpr() < PIL_NORMAL_MAX)
> >     wrpr(PIL_NORMAL_MAX);
> > 
> > so that it only disables IRQs, but doesn't enable NMIs.
> 
> It's immaterial, local_irq_restore() will do the right thing,
> and it's ok to disable NMIs in these few cases I think.
> 
> I desperately want to avoid that "test and maybe change the
> value %pil value we write" business, and honestly that's
> the whole point of this exercise.

Sure, its your architecture.. but could you explain why you're trying to
avoid that compare so desperately, the local_irq_save_nmi() calls are
few so surely they could carry that overhead.

Also, doesn't __raw_local_irq_save_flags() already do the read? So its
really just the compare that's gone missing.

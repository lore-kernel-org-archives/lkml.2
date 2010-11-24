Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530Ab0KXIgJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 03:36:09 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:45855 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215Ab0KXIgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 03:36:07 -0500
Date: Wed, 24 Nov 2010 17:35:20 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Tim Bird <tim.bird@am.sony.com>
Subject: Re: [PATCH 08/16 v4] pramfs: headers
Message-ID: <20101124083519.GF2212@linux-sh.org>
References: <4CE79C2F.5090001@gmail.com> <20101124080658.GC2212@linux-sh.org> <AANLkTikXxzcr+Ybru9vCt0+w6s-UYVNEudxvecF-0Xse@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikXxzcr+Ybru9vCt0+w6s-UYVNEudxvecF-0Xse@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 09:23:02AM +0100, Marco Stornelli wrote:
> 2010/11/24 Paul Mundt <lethal@linux-sh.org>:
> >> +#ifdef CONFIG_PRAMFS_WRITE_PROTECT
> >> +extern void pram_writeable(void *vaddr, unsigned long size, int rw);
> >> +
> >> +#define wrprotect(addr, size) pram_writeable(addr, size, 0)
> >> +
> >> +#else
> >> +
> >> +#define wrprotect(addr, size) do {} while (0)
> >> +
> >> +#endif /* CONFIG PRAMFS_WRITE_PROTECT */
> >> +
> > Perhaps this should be pram_wrprotect()? Does this really benefit from
> > being a config option instead of a mount option? Will this handle
> > multiple mounts with some write protected and others not?
> 
> See my previous response.
> 
Your previous response only alludes to why you didn't feel like making it
a mount option, and doesn't address any of the other questions.

> >
> >> +#ifdef CONFIG_PRAMFS_WRITE_PROTECT
> >> +static inline void pram_memunlock_range(void *p, unsigned long len)
> >> +{
> >> +#ifndef CONFIG_X86
> >> + ? ? local_irq_disable();
> >> +#endif
> >> + ? ? preempt_disable();
> >> + ? ? pram_writeable(p, len, 1);
> >> +}
> >> +
> > This needs some explaining, or killing. While the latter is preferable,
> > we can also work with the former.
> >
> 
> Maybe I didn't understand, you mean preemt_disable() without disabling
> the interrupt?

I mean what exactly is this supposed to be doing? It looks pretty
questionable for SMP for starters, it doesn't explain why x86 is special,
etc. It looks like you wanted a spinlock with IRQs disabled but probably
opted not to use it because you were throwing this around interfaces that
could sleep, which looks like a really scary thing for latency. It's also
making architecture assumptions without any explanation of why. This
needs to be explained, and in some amount of detail, as it's not entirely
obvious.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355Ab1IGRZH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 13:25:07 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:49175 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751647Ab1IGRZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 13:25:05 -0400
Date: Wed, 7 Sep 2011 18:24:45 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Dave Martin <dave.martin@linaro.org>,
        John Ogness <john.ogness@linutronix.de>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: alignment: setup alignment handler earlier
Message-ID: <20110907172445.GD1696@e102109-lin.cambridge.arm.com>
References: <87ehzstr07.fsf@vostro.fn.ogness.net>
 <20110907144016.GA30719@e102109-lin.cambridge.arm.com>
 <20110907162857.GB2327@n2100.arm.linux.org.uk>
 <yw1xipp4cnis.fsf@unicorn.mansr.com>
 <20110907170452.GC2327@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110907170452.GC2327@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 07, 2011 at 06:04:52PM +0100, Russell King - ARM Linux wrote:
> On Wed, Sep 07, 2011 at 05:42:19PM +0100, Måns Rullgård wrote:
> > There are such instructions (ldrd, ldm), but gcc will not emit those
> > unless the address is known to be aligned.  For ARMv6 and later, gcc 4.6
> > *will* emit potentially unaligned ldr and ldrh since these very clearly
> > allow an unaligned address and are faster than the alternatives in all
> > implementations to date.  This is unless strict alignment checking is
> > explicitly enabled, which unfortunately the Linux kernel does for no
> > apparent reason at all.
> 
> "no apparant reason at all" heh.  The reason is to keep the code
> simple and free from bugs.  To do otherwise means that each of the
> CPU files needs to be littered with ifdefs to deal with the alignment
> fault configuration, of which there are 16 of them (ignoring v6 and v7.)
> 
> If you think code maintanence of the same thing in 16 places is efficient
> then I guess there is "no apparant reason".  I beg to differ, being one
> of those folk who have had to edit 18 different places several times.
> 
> So no, I do not intend to move this:
> 
> #ifdef CONFIG_ALIGNMENT_TRAP
>         orr     r0, r0, #CR_A
> #else
>         bic     r0, r0, #CR_A
> #endif
> 
> into 16 separate places in the kernel.

What about something like this (untested):

#if defined(CONFIG_ALIGNMENT_TRAP) && __LINUX_ARM_ARCH__ < 6
	orr	r0, r0, #CR_A
#else
	bic	r0, r0, #CR_A
#endif

-- 
Catalin

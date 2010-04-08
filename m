Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758935Ab0DHS1W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 14:27:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46443 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758895Ab0DHS1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 14:27:20 -0400
Date: Thu, 8 Apr 2010 20:26:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Schwab <schwab@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Anton Blanchard <anton@samba.org>
Subject: Re: [GIT PULL] scheduler fix
Message-ID: <20100408182654.GA31578@elte.hu>
References: <20100408153854.GA5055@elte.hu>
 <alpine.LFD.2.00.1004080839350.3544@i5.linux-foundation.org>
 <m3ljcylymv.fsf@hase.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3ljcylymv.fsf@hase.home>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andreas Schwab <schwab@redhat.com> wrote:

> Linus Torvalds <torvalds@linux-foundation.org> writes:
> 
> > On Thu, 8 Apr 2010, Ingo Molnar wrote:
> >>  
> >> -	if (len < nr_cpu_ids)
> >> +	if ((len * BITS_PER_BYTE) < nr_cpu_ids)
> >>  		return -EINVAL;
> >
> > Not that it really matters, but this will now fail for no good reason if 
> > you pass it a half-gigabyte area due to overflow.
> 
> Which can easily be avoided.
> 
> 	if (len < DIV_ROUND_UP(nr_cpu_ids, BITS_PER_BYTE))

nr_cpu_ids is a signed integer which turns the DIV_ROUND_UP into a somewhat 
suboptimal instruction sequence. (havent checked it though)

So i'd suggest changing nr_cpu_ids to unsigned int [unless there's some strong 
reason to have it signed] plus doing something like:

	if (len < (nr_cpu_ids >> BITS_PER_BYTE_BITS))

ought to both result in better code and should be more readable. We'd have to 
add:

  #define BITS_PER_BYTE_BITS 3

to linux/bitops.h.

	Ingo

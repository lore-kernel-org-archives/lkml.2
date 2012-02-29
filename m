Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364Ab2B2IaM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 03:30:12 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39167 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299Ab2B2IaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 03:30:09 -0500
Date: Wed, 29 Feb 2012 09:29:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Nick Piggin <npiggin@kernel.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andi Kleen <ak@linux.intel.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-fsdevel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] cpumask: fix lg_lock/br_lock.
Message-ID: <20120229082944.GA10425@elte.hu>
References: <87ehtf3lqh.fsf@rustcorp.com.au>
 <20120227155338.7b5110cd.akpm@linux-foundation.org>
 <20120228084359.GJ21106@elte.hu>
 <20120228132719.f375071a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120228132719.f375071a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 28 Feb 2012 09:43:59 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > This patch should also probably go upstream through the 
> > locking/lockdep tree? Mind sending it us once you think it's 
> > ready?
> 
> Oh goody, that means you own 
> http://marc.info/?l=linux-kernel&m=131419353511653&w=2.
>
> I do think the brlock code is sick, but Nick has turned into 
> an ex-Nick and nobody works on it.

The main problem, highlighted by the above soft lockup report, 
is that lglocks and brlocks go outside the regular spinlock 
facilities and thus avoid quite a bit of generic lock debugging 
for no good reason. Those patches should never have gone 
upstream in their incomplete form via the VFS tree.

As part of any cleanup they should first be converted from 
arch_spinlock_t to regular spinlock_t - I bet if that is done 
then that not only simplifies the wrappers massively, it also 
turns the above soft lockup report into a nice, actionable 
lockdep splat.

Andi's deficient patch does not address that main shortcoming of 
brlocks/lglocks, it just addresses a symptom - while introducing 
a handful of new symptoms of suckage.

I'll review and process resubmitted patches from Andi if he 
wants to submit a proper, complete series - but there's a 
quality threshold and in this case I'd rather keep 1970's 
preprocessor code that sucks very visibly and possibly attracts 
someone with a clue than have a sloppy patch hiding the deeper 
design problems done by a clueless person who is also openly 
hostile towards the concept of producing quality code.

Thanks,

	Ingo

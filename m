Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758535Ab2CGUhw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 15:37:52 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48831 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755470Ab2CGUhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 15:37:51 -0500
Date: Wed, 7 Mar 2012 21:37:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Seebach <peter.seebach@windriver.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Anton Blanchard <anton@samba.org>, paulus@samba.org,
        peterz@infradead.org, dsahern@gmail.com, fweisbec@gmail.com,
        yanmin_zhang@linux.intel.com, emunson@mgebm.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: Incorrect use of snprintf results in SEGV
Message-ID: <20120307203725.GA4333@elte.hu>
References: <20120307114249.44275ca3@kryten>
 <20120307010904.GE5656@infradead.org>
 <20120306192912.59811e3e@wrlaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120306192912.59811e3e@wrlaptop>
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


* Peter Seebach <peter.seebach@windriver.com> wrote:

> On Tue, 6 Mar 2012 22:09:04 -0300
> Arnaldo Carvalho de Melo <acme@redhat.com> wrote:
> 
> > Or what kind of such pipe the people who designed snprintf 
> > were using
> > :-(
> 
> I wasn't there for the original 4.4BSD implementation, but I 
> was on the ISO committee when we adopted it, and I regret to 
> say, while the food was lovely, the hosting organization 
> didn't offer us any drugs at all. But I can explain the 
> rationale of the choice.

;-)

> If snprintf returns the size it needed, and you know the size 
> you gave it, you have a choice of what to do, and you have all 
> the information you need to make an informed choice.
> 
> If it returns the amount it wrote, or possibly an error 
> indicator (such as -1) when out of space, you *don't* have the 
> information you need to make an informed choice, and one 
> possible choice ("reallocate with the right amount") is not 
> available to you. We had also seen other functions which made 
> that implementation choice, and consistently, people disliked 
> them more.

You are missing two important aspects:

1) Dynamic reallocation on snprintf() failure is an utterly rare
   thing - it is used in less than 1% of snprintf() invocations. 
   (Yes, I just checked a couple of codebases.)

   We *DONT* want to make APIs more fragile just to accomodate a
   rare, esoteric usecase! Doing that you are introducing very
   real bugs in very real code. You are hurting the 99% for the
   sake of the 1%, and needlessly so:

2) It's not even true that should some code want to
   dynamically allocate the 'required' number of bytes is not
   available. Some oddball side API could be added for that 1%:

	size_needed = snprintf_size(...);

So this API could have been designed right but it was messed up 
out of concern for an insane 1% case - FAIL.

This is a case study for how insane semantics are created ...

Thanks,

	Ingo

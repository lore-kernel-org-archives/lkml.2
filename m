Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706Ab2CHHtP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 02:49:15 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53457 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753291Ab2CHHtK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 02:49:10 -0500
Date: Thu, 8 Mar 2012 08:48:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Seebach <peter.seebach@windriver.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Anton Blanchard <anton@samba.org>, paulus@samba.org,
        peterz@infradead.org, dsahern@gmail.com, fweisbec@gmail.com,
        yanmin_zhang@linux.intel.com, emunson@mgebm.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: Incorrect use of snprintf results in SEGV
Message-ID: <20120308074837.GE20784@elte.hu>
References: <20120307114249.44275ca3@kryten>
 <20120307010904.GE5656@infradead.org>
 <20120306192912.59811e3e@wrlaptop>
 <20120307203725.GA4333@elte.hu>
 <20120307151951.7e84adb6@wrlaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120307151951.7e84adb6@wrlaptop>
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


* Peter Seebach <peter.seebach@windriver.com> wrote:

> On Wed, 7 Mar 2012 21:37:25 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > You are missing two important aspects:
> > 
> > 1) Dynamic reallocation on snprintf() failure is an utterly rare
> >    thing - it is used in less than 1% of snprintf() invocations. 
> >    (Yes, I just checked a couple of codebases.)
> 
> I would agree that it's very rare.  But then, using the return 
> value at all isn't especially common in my experience -- the 
> only interesting part, most of the time, is "we're sure this 
> didn't overrun the buffer".

Erm. Doing:

	+= snprintf(...);

is a *very* common pattern within the kernel. It occurs more 
than a thousand times - i.e. about 25% of all snprintf uses 
(~5000 instances) within the kernel does care about the return 
value.

I found only a single case that did a reallocation if the buffer 
did not fit. Lets assume that I missed some and there's 4 
altogether.

I.e. the API usage proportion, within the kernel project, looks 
like this, approximately:

  snprintf() call site that:

   does not care about the return value:          75.0%
   uses the return value as a 'written' count:    24.9%
   wants to dynamically reallocate:                0.1%

> >    We *DONT* want to make APIs more fragile just to accomodate a
> >    rare, esoteric usecase!
> 
> I would view snprintf as an API which already exists.

Changing it is obviously not possible anymore.

I was just countering your justification for it - which is still 
wrong. People might read that and use it to justify newly 
introduced, crappy APIs.

The 0.1% usecase is absolutely not a valid excuse to make an API 
less robust - *especially* when a separate API could serve that 
0.1% case just fine.

When designing APIs it is of utmost importance how average 
developers intuitively *think* it works - not how the designer 
thinks it should work ... Any severe mismatch between the two is 
a serious design FAIL that should not be repeated in new code.

Thanks,

	Ingo

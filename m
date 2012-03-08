Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab2CHIwU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 03:52:20 -0500
Received: from mail1.windriver.com ([147.11.146.13]:64466 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754986Ab2CHIwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 03:52:18 -0500
Date: Thu, 8 Mar 2012 02:51:38 -0600
From: Peter Seebach <peter.seebach@windriver.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Anton Blanchard <anton@samba.org>, <paulus@samba.org>,
        <dsahern@gmail.com>, <fweisbec@gmail.com>,
        <yanmin_zhang@linux.intel.com>, <emunson@mgebm.net>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf: Incorrect use of snprintf results in SEGV
Message-ID: <20120308025138.3caf84b2@wrlaptop>
In-Reply-To: <20120308073454.GD20784@elte.hu>
References: <20120307114249.44275ca3@kryten>
	<20120307010904.GE5656@infradead.org>
	<20120306192912.59811e3e@wrlaptop>
	<20120307203725.GA4333@elte.hu>
	<1331153964.11248.362.camel@twins>
	<20120308073454.GD20784@elte.hu>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Mar 2012 08:34:54 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> But the self-justification, as outlined in the mail I replied 
> to, is brutally wrong,

Consider, if you will, an interface which has both snprintf_needed()
and snprintf_written().

Under the hood, any reasonably sane implementation of these functions
needs to have at least one function with the semantics of
snprintf_needed.  APIs which omit that create baroque monstrosities on
the (admittedly relatively rare) occasions when people try to get things
right.

Here, I think, the habit of C programmers of not writing trivial
five-line wrappers because "you could just write that, it's only five
lines", rather bites us.  It might have been better to put both of
these designs in the spec, but at the time when the decision was
originally made, it was clear that there was a need for *a*
length-limited version of snprintf, and if you're only going to have
one, there are significant technical advantages to making the one that
makes the other trivial to provide if you'd prefer it.  It may be
easy to misuse snprintf, but it's nearly impossible to use sprintf_s
correctly if you actually care about your data.

> When designing APIs it is of utmost importance how average 
> developers intuitively *think* it works - not how the designer 
> thinks it should work ...

There is perhaps a subtle clash between the Principle of Least
Astonishment and the Spirit of C.  C has often chosen design decisions
that are intuitively appealing to skilled programmers who have heard
the rationale for them, but which may surprise average programmers or
programmers relying purely on intuition.

I usually think the right thing to do in designing an API is to
provide the smallest and cleanest spanning set possible, and trust
users to know whether they need wrapper functions to provide more
congenial semantics.

The snprintf() interface might well have been done differently if
there'd been any way to get data on how it would be used before it was
specified.  At the time, though, I think the only available criterion
was the observation that one specification could be trivially
implemented in terms of the other.  I suspect, though, that even with
that information, the C committee's response would have been to provide
the function which could predictably produce correct output when used
correctly, rather than the function which couldn't.

We did look at the existing practice, and we heard feedback from people
on what they found with it.  Multiple people present had been badly
burned by one or another API that did not provide a way to find out how
much space was needed.  None of us had, at the time, encountered
this problem with the snprintf() specification, or if we had, it seemed
obvious enough that the fix was trivial.  (Possibly even a Simple
Matter of Programming.)

It may be a decision which produced problems in retrospect, but I think
it was a pretty reasonable decision at the time.

... And I say this even noting that I have at least one hunk of code
which I'm pretty sure makes this bad assumption.

-s
-- 
Listen, get this.  Nobody with a good compiler needs to be justified.

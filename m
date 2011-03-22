Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302Ab1CVRBA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 13:01:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43494 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752265Ab1CVRA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 13:00:57 -0400
MIME-Version: 1.0
In-Reply-To: <20110322102741.GA4448@elte.hu>
References: <alpine.LNX.2.00.1103212105490.15815@swampdragon.chaosbits.net>
 <AANLkTinmAJsXy=iJ5Fq-+CLTAGXTtLGhULRUf=Q1rkY1@mail.gmail.com> <20110322102741.GA4448@elte.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 22 Mar 2011 09:59:59 -0700
Message-ID: <AANLkTikz+vJGFuysDXAdVb33q1q3L547dXNJa9NmeqeM@mail.gmail.com>
Subject: Re: PATCH][RFC][resend] CC_OPTIMIZE_FOR_SIZE should default to N
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@kernel.org>, Jesper Juhl <jj@chaosbits.net>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>,
        Eric Paris <eparis@redhat.com>, Roman Zippel <zippel@linux-m68k.org>,
        linux-kbuild@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 3:27 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> If that situation has changed - if GCC has regressed in this area then a commit
> changing the default IMHO gains a lot of credibility if it is backed by careful
> measurements using perf stat --repeat or similar tools.

Also, please don't back up any numbers for the "-O2 is faster than
-Os" case with some benchmark that is hot in the caches.

The thing is, many optimizations that make the code larger look really
good if there are no cache misses, and the code is run a million times
in a tight loop.

But kernel code in particular tends to not be like that. Yes, there
are cases where we spend 75% of the time in the kernel (my own
personal favorite is "git diff") basically having user space loop
around just one single operation. But it is _really_ quite rare in
real life. Most of the time, user space will blow the kernel caches
out of the water, and the kernel loops will be on the order of a few
entries (eg a "loop" may be the loop around a pathname lookup, and
loops over three path components). Not millions.

The rule-of-thumb should be simple: 10% larger code likely means 10%
more I$ misses. Does the larger -O2 code make up for it?

Now, the downside of -Os has always been that it's not all that widely
used, so we've hit compiler bugs several times. That's been almost
enough to make me think that it's not worth it. But currently I don't
think we have any known issues, and probably exactly _because_ we use
-Os it seems that gcc hasn't that many regressions. It was much more
painful when we started trying to use -Os.

(That said, gcc -Os isn't all that wonderful. It tends to sometimes
generate really crappy code just because it's smaller, ie using a
multiply instruction in a critical code window just because doing a
few shifts and adds is larger. And that can be _so_ much slower that
it really hurts. So we might be better off with a model where we can
say "this code is important and really core kernel code that everybody
uses, do -O2 for this", and just compile _most_ of the kernel with
-Os)

                             Linus

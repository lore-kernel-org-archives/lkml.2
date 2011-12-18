Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751449Ab1LRID4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 03:03:56 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56515 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224Ab1LRIDy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 03:03:54 -0500
Date: Sun, 18 Dec 2011 09:02:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Howells <dhowells@redhat.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/7] Add conditional oopsing with annotation
Message-ID: <20111218080205.GA4144@elte.hu>
References: <20111216141357.24668.49793.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111216141357.24668.49793.stgit@warthog.procyon.org.uk>
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


* David Howells <dhowells@redhat.com> wrote:

> This facility can be made use of by one of:
> 
> 	ANNOTATED_BUG(const char *fmt, ...);
> 	ANNOTATED_BUG_ON(bool condition, const char *fmt, ...);

Hm, what about WARN_ON()s?

WARN_ON() and WARN_ON_ONCE() covers like 99% of the *actual* 
bugreports we get: we are actively getting rid of BUG()s that do 
trigger and are asking all new patches to come with WARN_ON()s.

BUG()s are generally a poor way of reporting bugs.

Another, much bigger issue is the actual syntax:

> -       BUG_ON(atomic_read(&cookie->usage) <= 0);
> +       ASSERTCMP(atomic_read(&cookie->usage), >, 0);

NAK on that concept on two grounds!

1) BUG_ON() is a well-known pattern. Changing it to the inverted
   assert() braindamage is going to cause confusion years down
   the road. Years ago we've settled on using BUG*() and WARN*()
   assertions to include conditions that check the 'bad'
   condition'. assert() covers the negated 'good' condition -
   which works but the two are truly awful when mixed.

2) The '>,0' syntax is ugly.

Why don't we simply extend the *existing* primitives with a 
'verbose' variant that saves the text string of the macro using 
the '#param' syntax, intead of modifying the usage sites with a 
pointless splitting along logical ops?

Doing that would also remove the rather pointess ANNOTATED_() 
prefix, which is like totally uninteresting in the actual usage 
sites. WARN()s want to be as short, obvious and low-profile as 
possible.

So the whole schizophrenic split between BUG_ON()/WARN_ON() and 
the assert() world is nonsensical and confusing - we should 
settle on *one* logical variant to make code reading easier. And 
i thought in the kernel we already settled on one of these 
variants and are using it almost exclusively ...

So this series does not look good enough to me yet.

Thanks,

	Ingo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813Ab1LTPfG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 10:35:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880Ab1LTPfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 10:35:01 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20111218080205.GA4144@elte.hu>
References: <20111218080205.GA4144@elte.hu> <20111216141357.24668.49793.stgit@warthog.procyon.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: dhowells@redhat.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/7] Add conditional oopsing with annotation
Date: Tue, 20 Dec 2011 15:34:43 +0000
Message-ID: <14686.1324395283@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> wrote:

> Hm, what about WARN_ON()s?

Good point.

> BUG()s are generally a poor way of reporting bugs.

Sometimes you can't continue, and there's no way you can know how to clean up
- after all, if you see values you don't expect, how can you handle them?

> 1) BUG_ON() is a well-known pattern. Changing it to the inverted
>    assert() braindamage is going to cause confusion years down
>    the road.

In my opinion, BUG_ON() is usually inverted from what it should be.
Frequently, it seems to be bugging on an inverted condition.

assert() is generally well known from userspace.  You lay out your
expectations with asserts.  An assert says "I expect this value to comply with
this condition" - such as a value being in a specific range.  Generally I
would turn them on whilst debugging stuff, and suppressing them at other
times, but I'd leave BUG[_ON]() and WARN[_ON]() enabled.

> 2) The '>,0' syntax is ugly.

And works rather well.  I've been using it for a while now in the kernel quite
successfully.

> Why don't we simply extend the *existing* primitives with a 
> 'verbose' variant that saves the text string of the macro using 
> the '#param' syntax, intead of modifying the usage sites with a 
> pointless splitting along logical ops?

You've completely missed the point.  Go back and re-read the description.

> Doing that would also remove the rather pointess ANNOTATED_() 
> prefix, which is like totally uninteresting in the actual usage 
> sites. WARN()s want to be as short, obvious and low-profile as 
> possible.

You need to distinguish annotated errors/warnings from non-annotated ones...
unless you're planning on completely converting all the BUG/WARN calls in one
patch?

You could call it BUG_ON_VERBOSE() - but verbose BUG_ON already exists as a
concept within the kernel, so I chose a different name.


Note that my preferred mechanism would be to permit the cut-here line to be
emitted early, and have the one that's emitted by the BUG handler then
suppressed, but Linus doesn't like that.  I think it would be preferable to
trying to pass a va_list argument through the exception handler.

David

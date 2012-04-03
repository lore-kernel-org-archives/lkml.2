Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab2DCIEV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 04:04:21 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:33040 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736Ab2DCIEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 04:04:15 -0400
Date: Tue, 3 Apr 2012 10:04:11 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Prevent crash on missing sysfs attribute group
Message-ID: <20120403080410.GF26826@gmail.com>
References: <20120402165036.2bc987ad@pluto.restena.lu>
 <m17gxyklfm.fsf@fess.ebiederm.org>
 <20120402213440.49e9de74@neptune>
 <1333401898.2960.78.camel@laptop>
 <1333403193.2960.80.camel@laptop>
 <20120403060252.GA27084@gmail.com>
 <20120403081735.78ca3bb3@pluto.restena.lu>
 <m1d37pgugy.fsf@fess.ebiederm.org>
 <20120403071543.GA17502@gmail.com>
 <m1r4w5dzjq.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1r4w5dzjq.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric W. Biederman <ebiederm@xmission.com> wrote:

> > Huh, so put repeated, duplicated, inconsistently applied sanity 
> > checks into dozens of sysfs attribute using kernel subsystems?
>
> [...]
>
> No.  I was not talking about every usage site.

Note, I'm not arguing that this isn't a bug in the P4 PMU driver 
- it is clearly a bug and I've applied the fix for it. I'm 
arguing about the escallation vector that this bug takes - that 
is unnecessarily disruptive:

You were talking about:

> >> FIX perf to include sanity checks.

and what the PMU drivers do here is not uncommon at all, and the 
bug (for which I applied the fix and will push to Linus ASAP) is 
not uncommon either:

Bugs happen and indirections happen too. perf uses a generic PMU 
driver layer where the lower level layers register themselves. 
There's at least a dozen similar constructs in the kernel and 
you suggest that the right solution is to put checks in every 
one of them, while the nice patch from Bruno could catch it too, 
in one central place?

If the PMU code used those attributes directly and could 
crash/misbehave then you'd have a point. But the first thing 
that makes real use of these objects is sysfs - so it's 
trivially useful to at minimum have a sanity check there...

> [...]  I was talking about the sites that are don't have a 
> direct call chain to the sysfs methods and instead do 
> something clever that makes backtraces worthless.
> 
> In the normal case sysfs registration problems are simple to 
> trace back to their source because the backtrace points a 
> finger at the piece of code that when registering had a 
> problem.

You mean the crash backtrace?

I don't think we should spuriously crash the kernel on NULL 
pointer input to generic facilities, especially when a check is 
so simple and would catch so many similar patterns of bugs.

That lack of a check escallated a simple missing (and 
unimportant) attribute into a "box won't boot at all" bug. 
*That* is not acceptable behavior and robustness from a generic 
facility, in my book.

In that sense the crash behaves like a BUG_ON().

Thanks,

	Ingo

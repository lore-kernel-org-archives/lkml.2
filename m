Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab2FYNmk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 09:42:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27862 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702Ab2FYNmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 09:42:39 -0400
X-Authority-Analysis: v=2.0 cv=ULpf7Vjy c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=C_U1be-mfRQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=VwQbUJbxAAAA:8 a=82irRftXAAAA:8 a=GE6IBiy5ujAXJaIvAA8A:9 a=PUjeQqilurYA:10 a=LI9Vle30uBYA:10 a=WgwKcZQGGVUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1340631757.27036.311.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] printk: Revert the buffered-printk() changes for now
From: Steven Rostedt <rostedt@goodmis.org>
To: Kay Sievers <kay@vrfy.org>
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>, Ingo Molnar <mingo@elte.hu>
Date: Mon, 25 Jun 2012 09:42:37 -0400
In-Reply-To: <CAPXgP10E7HNDQ73ZFyb4EyDVBko2yXs8Rw0KOSKukGUpSBSz_g@mail.gmail.com>
References: <1340322723.27036.220.camel@gandalf.stny.rr.com>
	 <20120622145402.8047a669.akpm@linux-foundation.org>
	 <20120623061313.GA21895@gmail.com> <1340452052.1784.40.camel@mop>
	 <20120625090933.GD24512@gmail.com>
	 <CAPXgP10E7HNDQ73ZFyb4EyDVBko2yXs8Rw0KOSKukGUpSBSz_g@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-25 at 12:06 +0200, Kay Sievers wrote:
> On Mon, Jun 25, 2012 at 11:09 AM, Ingo Molnar <mingo@kernel.org> wrote:
> > * Kay Sievers <kay@vrfy.org> wrote:
> 
> >> I just don't have a better idea than Joe or Steven.
> >
> > Then pick the fix you see as the best solution, post it and push
> > the fix to Linus, don't just sit there passive-aggressively
> > leaving a regression you introduced unresolved ...
> 
> Yeah, sometimes we can't have everything at the same time, and we
> fixed serious reliability and integrity bugs for the cost of changing
> the behaviour of: debug-printk + continuation line + crash the box. If
> the box does not crash, the output does not change at all from before.

But if the box crashes, then we get lies about where it crashed. That's
an important part.

> 
> > I think Steve's fix would be OK as a workaround, if no-one can
> > think of anything better.
> >
> > The thing is, this bug, despite being reported early on, has
> > been left unresolved for weeks and it's -rc4 time now. Time is
> > running out and frankly, I've been watching this thread, and the
> > only reason you appear to be taking this bug somewhat seriously
> > now is because Andrew and me complained. That is sad.
> 
> Steven said he would try something else on Monday, that's why I'm
> waiting. I'm not happy with any of the current
> optimize-continuation-lines-for-kernel-crashes patches, so I wanted to
> see what he has in mind.

I just posted it. You may not like it either, but it removes the needed
printk_flush(), and doesn't touch any of your 'facility' work. Besides
adding its own 0x1ffc tag.


> 
> > Kernel policy is that kernel bugs introduced during the merge
> > window are fixed by those who introduced them, or the changes
> > get reverted. The kernel project uses a very user-friendly
> > process to resolve regressions and in the worst case you as a
> > developer have to suffer your changes reverted. Obviously timely
> > fixes are preferred over invasive reverts.
> 
> That's true. this change is a trade, and the kernel self-tests
> print-continuation-line-and-let-the-kernel-crash is currently affected
> by the hugely improved integrity and reliability of all the "normal"
> users.

I'm hoping that my last patch can satisfy both users.

> 
> > It is not *Steve's* job to fix this bug. That he actually posted
> > a fix is nice from him, it makes your life easier (and you can
> > still write some other fix) but *you* should be driving the
> > resolution here, not Steve, me or Andrew.
> 
> Let's see what other idea Steven has, he wrote "But I have an idea for
> a fix. I'll work on it on Monday, and it wont require adding a
> pr_flush() like I did in this patch set." before pointing fingers here
> please.

It's out, please continue to point ;-)

> 
> If we find a way to solve that cleanly, I'm all for it. But honestly,
> just letting these very special-case users print fully terminated
> lines instead of continuation lines seems like an option to me too. We
> really should not optimize for cosmetics (full lines work reliably,
> they are not buffered) of self-tests, for the price of the reliability
> and integrity of all other users.

The thing is, you made a fundamental change to the way printk() has
worked from day one. This will give lots of developers a "surprise",
that will last for a long time.

> 
> The self-test users would need to be changed anyway to use "flush",
> why don't we just print a full line,  omit the "PASSED" in case all
> went well, and only print in case of an error? I really do not see the
> need for continuation lines for the crash-sensitive self-tests; people
> will find out (without PASSED on the same line), that we passed the
> test when the box is still alive.

Well, it was a way my scripts would check if the test passed or not.

-- Steve



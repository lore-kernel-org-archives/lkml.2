Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751306Ab1JLIju (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 04:39:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52405 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957Ab1JLIjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 04:39:49 -0400
Date: Wed, 12 Oct 2011 10:38:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@stusta.de>
Cc: Arjan van de Ven <arjan@infradead.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>
Subject: Re: Please revert "debug: Make CONFIG_EXPERT select
 CONFIG_DEBUG_KERNEL to unhide debug options"
Message-ID: <20111012083801.GA27853@elte.hu>
References: <20110930134245.GB21474@localhost.pp.htv.fi>
 <20110930150519.GA7980@leaf>
 <20110930155012.GC9049@localhost.pp.htv.fi>
 <20111010072946.GA29035@elte.hu>
 <20111010084811.GG4586@localhost.pp.htv.fi>
 <20111010102116.GA26901@elte.hu>
 <20111010121340.GA3731@localhost.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111010121340.GA3731@localhost.pp.htv.fi>
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


* Adrian Bunk <bunk@stusta.de> wrote:

> On Mon, Oct 10, 2011 at 12:21:21PM +0200, Ingo Molnar wrote:
> > 
> > * Adrian Bunk <bunk@stusta.de> wrote:
> > 
> > > On Mon, Oct 10, 2011 at 09:29:48AM +0200, Ingo Molnar wrote:
> > > > * Adrian Bunk <bunk@stusta.de> wrote:
> > > >...
> > > > I think you are wrong not just about that detail but about the whole 
> > > > premise of your complaint as well:
> > > > 
> > > > >  config DEBUG_BUGVERBOSE
> > > > > -	bool "Verbose BUG() reporting (adds 70K)" if DEBUG_KERNEL && EXPERT
> > > > > +	bool "Verbose BUG() reporting (adds 70K)" if EXPERT
> > > > > 
> > > > > This part of the patch would have been the correct and complete 
> > > > > solution for DEBUG_BUGVERBOSE.
> > > > 
> > > > Not really - it's a debugging-only option and when i turn on 
> > > > CONFIG_DEBUG_KERNEL I expect to have full config control over all 
> > > > debug options - with sane defaults provided.
> > > 
> > > Then you would have to remove the dependency on EXPERT from the prompt, 
> > > and allow unsetting DEBUG_BUGVERBOSE with EXPERT=n, DEBUG_KERNEL=y.
> > > 
> > > Note that this is completely unrelated to the commit we are discussing,
> > > since commit f505c553 has no effect in the EXPERT=n case you are 
> > > discussing here.
> > > 
> > > > I definitely don't want a debugging option to depend on 
> > > > CONFIG_EXPERT.
> > > 
> > > DEBUG_BUGVERBOSE does not depend on EXPERT.
> > > 
> > > But EXPERT is currently required for disabling it.
> > 
> > Correct - that's a further variation. In the case of debug options 
> > that we *really* don't want normal users to disable we do something 
> > like this:
> > 
> >  config DEBUG_BUGVERBOSE
> >          bool "Verbose BUG() reporting (adds 70K)" if DEBUG_KERNEL && EXPERT
> > 
> > Commit f505c553 ("debug: Make CONFIG_EXPERT select 
> > CONFIG_DEBUG_KERNEL to unhide debug options") allows this line to be 
> > further simplified into:
> > 
> >         bool "Verbose BUG() reporting (adds 70K)" if EXPERT
> > 
> > ... but this was not the main purpose of the commit - nor is this 
> > simplification strictly necessary.
> 
> You do not need commit f505c553 for that, the dependency of this 
> prompt on DEBUG_KERNEL should be removed in any case.

An opt-out model is more maintainable here than an opt-in method. 
People will get debug dependencies right most of the time - but 
getting debug *and* CONFIG_EXPERT interactions right is on the 
backburner generally.

So we are better off if CONFIG_EXPERT simply implies (selects) 
CONFIG_KERNEL_DEBUG - makes CONFIG_EXPERT an invariant as far as 
debugging features are concerned and reduces/eliminates the trickle 
of avoidable CONFIG_EXPERT tweaking patches in lib/Kconfig.debug.

> Why do you want to make life harder for people with EXPERT=y by not 
> allowing them to turn this off if they want to?

It's simpler to have one flat CONFIG_EXPERT=y option to gain broad 
expert-configurability of core debug functionality of the kernel.

It should arguably not explode the options to *all* drivers of the 
kernel:

> When configuring his kernel, a user set MISC_FILESYSTEMS=n.
> 
> Now he sets EXPERT=y and runs "make oldconfig".
>
> Why would it make sense that he is now asked for each of these 
> filesystems whether he wants to enable it?

I agree with you that filesystems are more like drivers here and 
should probably not be selected by CONFIG_EXPERT. It's up to the VFS 
folks whether they consider experts to be frequent requestors. 
(probably not)

But the important case here is the situation outlined in the 
changelog, that a default-y core kernel option such as BUGVERBOSE 
unconditionally *adds* code. Core kernel debugging code is an area 
that by its nature has and is bound to have such options - 
MISC_FILESYSTEMS probably not.

Thanks,

	Ingo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387Ab1JJKXD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 06:23:03 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52957 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753097Ab1JJKXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 06:23:01 -0400
Date: Mon, 10 Oct 2011 12:21:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@stusta.de>, Arjan van de Ven <arjan@infradead.org>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>
Subject: Re: Please revert "debug: Make CONFIG_EXPERT select
 CONFIG_DEBUG_KERNEL to unhide debug options"
Message-ID: <20111010102116.GA26901@elte.hu>
References: <20110930134245.GB21474@localhost.pp.htv.fi>
 <20110930150519.GA7980@leaf>
 <20110930155012.GC9049@localhost.pp.htv.fi>
 <20111010072946.GA29035@elte.hu>
 <20111010084811.GG4586@localhost.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111010084811.GG4586@localhost.pp.htv.fi>
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


* Adrian Bunk <bunk@stusta.de> wrote:

> On Mon, Oct 10, 2011 at 09:29:48AM +0200, Ingo Molnar wrote:
> > * Adrian Bunk <bunk@stusta.de> wrote:
> >...
> > I think you are wrong not just about that detail but about the whole 
> > premise of your complaint as well:
> > 
> > >  config DEBUG_BUGVERBOSE
> > > -	bool "Verbose BUG() reporting (adds 70K)" if DEBUG_KERNEL && EXPERT
> > > +	bool "Verbose BUG() reporting (adds 70K)" if EXPERT
> > > 
> > > This part of the patch would have been the correct and complete 
> > > solution for DEBUG_BUGVERBOSE.
> > 
> > Not really - it's a debugging-only option and when i turn on 
> > CONFIG_DEBUG_KERNEL I expect to have full config control over all 
> > debug options - with sane defaults provided.
> 
> Then you would have to remove the dependency on EXPERT from the prompt, 
> and allow unsetting DEBUG_BUGVERBOSE with EXPERT=n, DEBUG_KERNEL=y.
> 
> Note that this is completely unrelated to the commit we are discussing,
> since commit f505c553 has no effect in the EXPERT=n case you are 
> discussing here.
> 
> > I definitely don't want a debugging option to depend on 
> > CONFIG_EXPERT.
> 
> DEBUG_BUGVERBOSE does not depend on EXPERT.
> 
> But EXPERT is currently required for disabling it.

Correct - that's a further variation. In the case of debug options 
that we *really* don't want normal users to disable we do something 
like this:

 config DEBUG_BUGVERBOSE
         bool "Verbose BUG() reporting (adds 70K)" if DEBUG_KERNEL && EXPERT

Commit f505c553 ("debug: Make CONFIG_EXPERT select 
CONFIG_DEBUG_KERNEL to unhide debug options") allows this line to be 
further simplified into:

        bool "Verbose BUG() reporting (adds 70K)" if EXPERT

... but this was not the main purpose of the commit - nor is this 
simplification strictly necessary.

> This part of our discussion boils down to the following options:
> 1. DEBUG_KERNEL allows a user to enable additional debugging
> 2. DEBUG_KERNEL gives a user full control over all debug options
> 
> Traditionally it was 1., to tell a user reporting a bug that he should 
> enable additional debugging in his kernel - without him accidentally 
> disabling useful debugging.
> 
> Again, this part of the discussion is unrelated to commit f505c553.
> 
> > CONFIG_EXPERT is a superset to all that: it implies config control 
> > over all debug options *and* over many other kernel components as 
> > well.
> 
> I don't see the advantage that EXPERT=y is now unconditionally enabling 
> the DEBUG_KERNEL knob.

You don't see it - Josh and me saw an advantage and we explained it 
in the commit and in the discussion: when full fine-grained 
configurability is desired then it's useful to extend that to all the 
debugging options as well - instead of requiring an explicit EXPERT 
line on all default-enabled debug feature options that might have 
kernel size (or other expert configuration) relevance.

It's a somewhat simpler, more robust and more maintainable Kconfig 
option hierarchy.

> When I am an "expert", why can't I still decide myself globally if 
> I want to enable more debugging or not?

The (valid) observation from Josh was that enabling CONFIG_EXPERT 
is more than enough to signal that unusual, highly expert 
configuration is sought.

Any additional knobs are just unnecessary obfuscation of that primary 
intent.

So the point of the change is to extend the scope of CONFIG_EXPERT to 
more kernel subsystem config options.

The only side effect of the change that i can see, beyond open-coded 
use of CONFIG_DEBUG_KERNEL, is that DEBUG_KERNEL hidden options like 
this:

	FOO
	bool "debug option foo"
	default y
	depends on DEBUG_KERNEL

... will now become visible if CONFIG_EXPERT is enabled. This is 
similar to how new CONFIG_EXPERT options become visible so not 
unusual or hard to handle for the expert configurator. Normal users 
should not need to enable CONFIG_EXPERT.

> Another problem is that we have code using "#ifdef 
> CONFIG_DEBUG_KERNEL" so enabling EXPERT for making your kernel 
> smaller can make your kernel bigger, but such usages should anyway 
> get own config options.

Doesn't seem to be a significant issue, only some architectures have 
a low number of such hacks:

 arch/blackfin/include/asm/context.S:#ifdef CONFIG_DEBUG_KERNEL
 arch/blackfin/include/asm/entry.h:# ifndef CONFIG_DEBUG_KERNEL
 arch/blackfin/include/asm/entry.h:# else /* CONFIG_DEBUG_KERNEL */
 arch/blackfin/include/asm/entry.h:# endif /* CONFIG_DEBUG_KERNEL */
 arch/parisc/mm/init.c:#ifdef CONFIG_DEBUG_KERNEL /* double-sanity-check paranoia */
 arch/powerpc/kernel/sysfs.c:#ifdef CONFIG_DEBUG_KERNEL
 arch/powerpc/kernel/sysfs.c:#endif /* CONFIG_DEBUG_KERNEL */
 arch/powerpc/kernel/sysfs.c:#ifdef CONFIG_DEBUG_KERNEL
 arch/powerpc/kernel/sysfs.c:#endif /* CONFIG_DEBUG_KERNEL */

and yes, it should be fixed: CONFIG_DEBUG_KERNEL is a container 
Kconfig option which should not have functional side-effects in 
itself.

> > This is a pretty easy model to think about.
> 
> There are many options in the kernel that only enable seeing other 
> config options.
> 
> With that model, shouldn't EXPERT also have
> 	select MISC_FILESYSTEMS
> and many other similar select's?

Yes, adding that select would probably make sense, if the vfs folks 
agreed too. Basically CONFIG_EXPERT wants to imply 'full 
configurability of the kernel' - within sensible limits.

> The point I am trying to make here is that there are many 
> convenience config options that only exist to allow a user to hide 
> a bunch of options he is not interested in, and DEBUG_KERNEL is one 
> of them. [1]

Yes, and the correct answer to that observation is to increase 
convenience, not to reduce it.

> > > The crazy select added in commit f505c553 is wrong.
> > 
> > Why? Your original message does not explain it.
> 
> It is not needed for what it was claimed it was needed for,
> and it is a bad idea in general.

Nonsense, what the commit changelog says is mostly accurate: before 
the change it was not possible to disable DEBUG_BUGVERBOSE under 
CONFIG_EXPERT, if DEBUG_KERNEL was disabled.

DEBUG_BUGVERBOSE is by far the biggest size impact debug option of 
the ones that are enabled by default.

The changelog is technically not correct for RODATA (which depends on 
DEBUG_KERNEL in a depends line) but it's certainly true in spirit, 
IMO DEBUG_RODATA should be turned into an always-enabled debug option 
like:

config DEBUG_RODATA
        bool "Write protect kernel read-only data structures" if DEBUG_KERNEL
        default y
        ---help---

Arjan, Linus, do you have objections against doing that?

Adrian, you had valid points, but i have the impression that you got 
lost in details and are missing the bigger picture and the revert you 
suggested looks like a step backwards to me. The commit itself is no 
big deal, it's a small convenience change - but i preferred if it all 
moved in the right direction ...

Thanks,

	Ingo

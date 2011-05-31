Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442Ab1EaLnn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 07:43:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:58916 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350Ab1EaLnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 07:43:42 -0400
Subject: Re: [PATCH] Fix corruption of CONFIG_X86_32 in 'make oldconfig'
From: David Woodhouse <dwmw2@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Ted Ts'o" <tytso@mit.edu>, x86@kernel.org, linux-kernel@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Randy Dunlap <rdunlap@xenotime.net>
Date: Tue, 31 May 2011 12:43:29 +0100
In-Reply-To: <20110531104106.GD24172@elte.hu>
References: <20110530104231.GF17821@elte.hu>
	 <20110530104656.GA19532@elte.hu>
	 <E934876C-FABB-41F8-8C5E-469AA42DBE91@mit.edu>
	 <20110530105809.GA20133@elte.hu>
	 <1A4DB87D-9B32-44C0-B7C9-47A003CABD96@mit.edu>
	 <alpine.LFD.2.02.1105301955210.3164@localhost6.localdomain6>
	 <20110530195545.GG2890@dhcp-172-31-194-241.cam.corp.google.com>
	 <alpine.LFD.2.02.1105302103220.3164@localhost6.localdomain6>
	 <20110531075306.GB20798@elte.hu>
	 <1306832148.2029.484.camel@i7.infradead.org>
	 <20110531104106.GD24172@elte.hu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.1 (3.0.1-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1306842211.2029.531.camel@i7.infradead.org>
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-31 at 12:41 +0200, Ingo Molnar wrote:
> * David Woodhouse <dwmw2@infradead.org> wrote:
> 
> > On Tue, 2011-05-31 at 09:53 +0200, Ingo Molnar wrote:
> > > I'll always prefer typing:
> > >   make ARCH=x86_64 ...
> > > To:
> > >   make ARCH=x86 CONFIG_64BIT=y ...
> > 
> > Why else would you need to specify ARCH=x86 on the latter command line? 
> 
> Note that if we are consistent and implement the logical extension of 
> your CONFIG_64BIT 'fix' then we could pick up the target architecture 
> from the .config as well and not use the host architecture.

It would be interesting, perhaps, to make the architecture a config
option. Distinctly non-trivial, though. I think it's been discussed
before.

On the other hand, CONFIG_64BIT *is* a config option, and has been ever
since we merged the 32-bit and 64-bit support into arch/x86.

> The very same arguments apply: the user provided an ARCH=arm .config, 
> why does 'make oldconfig' switch it to x86_64 automatically?

Yes, it's "automatic" because the architecture is *not* a config option.
But yes, perhaps it would be nice if it *was*.

> Also, i prefer to type out the architecture due to:
>  |                                              ...So if i get an ARM
>  |  bugreport that gives me the appearance of a core kernel bug i will
>  |  often start by converting that to an x86 .config via 'make
>  |  ARCH=x86_64 oldconfig'. ]

So first you point out that it's automatic, and then you still specify
it manually?

> But even if we leave out the 'ARCH=x86' portion, which ones are the 
> two shortest commands to type, in your opinion:
> 
> 	make ARCH=i386
> 	make ARCH=x86_64
> 	make CONFIG_64BIT=y
> 
> ?
> 
> > You're not building on an x86 box? I always suspected you had some 
> > alien technology! Does it run Linux?
> 
> Could you please stop with this borderline taunting tone?
>
> You've been wrong so many times in this thread that i think toning 
> down some of your shouting in favor of a bit more listening would be 
> well advised ...

No, Ingo. I haven't been wrong. I don't think either of us is *wrong*.
Let's review a little...

- You like to use 'ARCH=i386' and 'ARCH=x86_64' as a convenient shortcut
  to override the CONFIG_64BIT option.

- I *don't* like it when the CONFIG_64BIT option is silently overridden
  according to the host architecture.

- I posted a patch making ARCH=x86 the default 'inferred' architecture,
  so that both of our desires are met.

- I was uncomfortable with keeping the legacy 'ARCH=i386' and
  'ARCH=x86_64' settings around now that arch/i386 and arch/x86_64
  are actually dead. I observed that while you have a valid need to
  set CONFIG_64BIT, that's a trick that actually works *only* on x86
  because we haven't finished the merge and removed the dregs of the
  old architectures, and it works *only* for CONFIG_64BIT. It seems
  *unclean*. It doesn't work on anything *else* you might need to set to
  test 'core' functionality, such as CONFIG_SMP, and not on anything you
  might need to set to actually boot your kernel on a test box, such as
  CONFIG_SATA_MV, and not on anything else you might need to be
  compatible with the userspace on your test box, such as CONFIG_CGROUPS
  if you have a Fedora 15 userspace with systemd. And it doesn't *even*
  work for CONFIG_64BIT on any platforms other than x86, for example
  powerpc where the legacy ARCH=ppc and ARCH=ppc64 settings actually got
  removed when the merge was completed.

- I posted a patch which gives a more generic way to set config options
  from the make command line, which satisfies *all* the above
  requirements (except that it doesn't auto-enable dependencies, as
  observed). To me, it seems much cleaner and nicer. I observed that the
  legacy ARCH= trick *can* now be deprecated, but didn't actually post
  a patch which *does* deprecate or remove it.

- You objected, because you would have to type three more letters to
  enable CONFIG_64BIT, and a whole *five* more to disable it. Except you
  lied a bit in your message, adding a pointless 'ARCH=x86' to make it
  look like it was even *more* extra typing, and the world would
  actually end.

Did I miss something?

Aside from you adding 'ARCH=x86' to the example in your latest message
to make it look like I'm going to contribute more to your RSI to I
actually am, I don't think anyone was really *wrong*.

It's just a matter of opinion. I see this use of ARCH=i386 as a limited
legacy hack, and implemented something which allows us to do that and
much more in a *clean* and generic fashion. I happen to believe that
even if it means we have to type a couple of extra characters when the
command isn't in our command history already, it's worth it to have a
clean generic interface instead of a legacy hack.

You, evidently, have a different opinion. That is your right. I think
you're being *silly*, but I don't think you're *wrong*.

-- 
dwmw2


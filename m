Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405Ab1E0SRq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 14:17:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56517 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752956Ab1E0SRp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 14:17:45 -0400
Date: Fri, 27 May 2011 20:17:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dan Rosenberg <drosenberg@vsecurity.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tony Luck <tony.luck@gmail.com>,
        linux-kernel@vger.kernel.org, davej@redhat.com,
        kees.cook@canonical.com, davem@davemloft.net, eranian@google.com,
        adobriyan@gmail.com, penberg@kernel.org, hpa@zytor.com,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        pageexec@freemail.hu
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
Message-ID: <20110527181724.GA6485@elte.hu>
References: <1306269105.21443.20.camel@dan>
 <201105270018.36835.rjw@sisk.pl>
 <BANLkTin+Vjhqtv5-N07G9P9_asNQnrnhVg@mail.gmail.com>
 <20110527170045.GB4356@elte.hu>
 <1306516230.3339.17.camel@dan>
 <20110527171611.GE4356@elte.hu>
 <BANLkTim7+gPdvQS99oJ7xteYOAQaSSr8Sw@mail.gmail.com>
 <20110527174644.GG4356@elte.hu>
 <BANLkTimGQh7P9O+BEd85Wm5iqzWg5DuYYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimGQh7P9O+BEd85Wm5iqzWg5DuYYg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, May 27, 2011 at 10:46 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > If i understood you correctly you suggest randomizing the image 
> > by shifting the symbols in it around. The boot loader would still 
> > load an 'image' where it always loads it - just that image itself 
> > is randomized internally somewhat, right?
> 
> You snipped the other part of my email you responded to:
> 
>   For chrissake - you're doing the same thing. The only question is
>   "when" (and the fact that if you do it at install-time, you can do a
>   fancier job of it)
> 
> ie the fact that if you do it at install-time, you have the option of
> being much more fancy about it.
> 
> So sure, the install time option *can* do more. It doesn't *have* 
> to do more.
> 
> But being able to do a better job of randomization is *better*. Ok? 
> It doesn't mean you have to, but you have more options to do things 
> if you want to.
> 
> IOW, there is absolutely zero difference between doing it at 
> install-time or run-time, but the install-time one is (a) likely 
> easier and (b) certainly more flexible. But both of them do the 
> exact same thing, and require the exact same support in things like 
> /proc/kallsyms.
> 
> Of course, if we end up doing something really fancy (which the 
> install-time option allows), that obviously does mean that the 
> remapping by %pK thing for kallsyms needs to be much smarter too.
> 
> But at %pK time, you can *afford* to do that kind of things. At 
> boot-time, before you're even loaded and have a hard time even 
> parsing the e820 maps? Yeah, you're not going to do anything smart 
> there, I can tell you.

Ok, you are right, we could patch in all the things into the image at 
install time to be able to 'derandomize' symbols and still be able to 
provide them.

[ One worry i have is that distro logic is to go for the simplest 
  route: which is to randomize the symbols by padding the beginning 
  or the end of the kernel image a bit, but don't bother making %pK 
  smart or fancy. This means that /proc/kallsyms will be restricted 
  (maybe even turned off completely, because it's now broken) and a 
  'real' System.map put, only readable to root. This still 'allows'
  tooling, in a full SystemTap and Oprofile usability fashion. ]

Anyway, this strikes off the second item from my list. Meanwhile i 
also found two other usecases which i added to the head of the list:

 - Boot time dynamic randomization allows randomization of 'mass 
   install' systems, where the same image is used, to still be 
   randomized: for example a million phones all with the same Flash 
   ROM image and no 'install' performed at all on them.

   With static randomization these systems will all have the same
   kernel addresses.

 - Boot time dynamic randomization allows read-only systems to still 
   be randomized: for example internet cafes that use some popular 
   pre-packaged kiosk-mode live-DVD. They probably wont bother 
   randomizing and relinking the ISOs per machine and burning per 
   machine DVDs ...

 - A root exploit will still not give away the location of the
   kernel (assuming module loading has been disabled after bootup),
   so a rootkit cannot be installed 'silently' on the system, into
   RAM only, evading most offline-storage-checking tools.

   With static linking this is not possible: reading the kernel image
   as root trivially exposes the kernel's location.

 - Crash & reboot & retry brute force exploits get harder: if one
   attempt at an exploit causes a crash and a reboot, the kernel
   addresses are different after the reboot so the attempt has to be
   retried without the advantage of any prior history.

   With static linking this kind of exploit is somewhat easier: every
   crash gives a permanent proof that the guessed RIP offet was
   wrong, so history can be used on subsequent retries.

 - It gives a way to go one step further in secure server lockdown:
   where even root with full access to all storage has no way to
   break into the kernel. Reboots, module loading and kexec can be
   controlled, ioperm() and iopl() can be restricted. If those are
   taken away then even if a root exploit allows the attacker to
   overwrite the kernel image, a reboot has to be waited for and if
   reboots do sanity checks [based on immutable storage] of the
   system then the exploit can be found.

   With static linking this is not possible: reading the kernel image
   as root trivially exposes the kernel's location.

Thanks,

	Ingo


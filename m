Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286Ab1E1Gda (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 02:33:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55159 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349Ab1E1Gd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 02:33:27 -0400
Date: Sat, 28 May 2011 08:32:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Olivier Galibert <galibert@pobox.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tony Luck <tony.luck@gmail.com>,
        linux-kernel@vger.kernel.org, davej@redhat.com,
        kees.cook@canonical.com, davem@davemloft.net, eranian@google.com,
        adobriyan@gmail.com, penberg@kernel.org, hpa@zytor.com,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        pageexec@freemail.hu
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
Message-ID: <20110528063241.GA22399@elte.hu>
References: <201105270018.36835.rjw@sisk.pl>
 <BANLkTin+Vjhqtv5-N07G9P9_asNQnrnhVg@mail.gmail.com>
 <20110527170045.GB4356@elte.hu>
 <1306516230.3339.17.camel@dan>
 <20110527171611.GE4356@elte.hu>
 <BANLkTim7+gPdvQS99oJ7xteYOAQaSSr8Sw@mail.gmail.com>
 <20110527174644.GG4356@elte.hu>
 <BANLkTimGQh7P9O+BEd85Wm5iqzWg5DuYYg@mail.gmail.com>
 <20110527181724.GA6485@elte.hu>
 <20110527215123.GA45133@dspnet.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110527215123.GA45133@dspnet.fr>
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


* Olivier Galibert <galibert@pobox.com> wrote:

> On Fri, May 27, 2011 at 08:17:24PM +0200, Ingo Molnar wrote:
> >  - A root exploit will still not give away the location of the
> >    kernel (assuming module loading has been disabled after bootup),
> >    so a rootkit cannot be installed 'silently' on the system, into
> >    RAM only, evading most offline-storage-checking tools.
> > 
> >    With static linking this is not possible: reading the kernel image
> >    as root trivially exposes the kernel's location.
> 
> There's something I don't get there.  If you managed to escalate your
> priviledges enough that you have physical ram access, there's a
> billion things you can do to find the kernel, including vector
> tracing, pattern matching, looking at the page tables, etc.
>
> What am I missing?

You are missing that it's not unrealistic to make the
"root does not have physical RAM access" condition true
on a system.

CONFIG_STRICT_DEVMEM=y will go a long way already, enabled
on most distros these days:

 $ grep DEVMEM $(rpm -ql kernel-2.6.38-0.rc7.git2.3.fc16.x86_64 | grep boot/config)
 CONFIG_STRICT_DEVMEM=y

Combined with:

 echo 1 > /proc/sys/kernel/modules_disabled

( Which cannot be turned back on once turned off after essential 
  modules have loaded. )

Admins do not actually need access to physical RAM, nor do they need
the ability to binary patch kernel code, so it's not unrealistic to
do this in distros.

There can be a few more vectors to access physical RAM but they can 
be controlled as well.

This will already force a reboot (or a wait for a regular reboot) by 
the attacker to install rootkit level code.

But yes, if root controls RAM then it's obviously game over: even 
with randomization RAM can be scanned for kernel image signatures, 
kernel code can be inserted or system call table patched - q.e.d.

Thanks,

	Ingo

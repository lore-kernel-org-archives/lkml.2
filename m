Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab1APUac (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 15:30:32 -0500
Received: from mx2.parallels.com ([64.131.90.16]:53049 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753804Ab1APUab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 15:30:31 -0500
Message-ID: <4D335554.7020403@parallels.com>
Date: Sun, 16 Jan 2011 14:30:12 -0600
From: Rob Landley <rlandley@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jesper Juhl <jj@chaosbits.net>
CC: <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>, <x86@kernel.org>,
        "K. Y. Srinivasan" <ksrinivasan@novell.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] Use sed instead of perl to generate x86/kernel/cpu/capflags.c.
References: <4D334E1E.7090708@parallels.com> <alpine.LNX.2.00.1101162103450.13377@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1101162103450.13377@swampdragon.chaosbits.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2011 02:05 PM, Jesper Juhl wrote:
> On Sun, 16 Jan 2011, Rob Landley wrote:
> 
>> From: Rob Landley <rlandley@parallels.com>
>>
>> Generate capflags.c with sed (POSIX 2008) instead of perl.
>>
> 
> While I'm not personally a great perl fan, this still begs the 
> question, why?

1) In general, simpler is better.  (Why ship autoconf files to build on
hosts that don't have autoconf?  Why fix make oldconfig so it builds on
platforms that don't have curses installed?)

2) Making reliable cross compile build environments involves creating a
known build environment on the host, generally removing everything you
don't actually _need_ so it can't screw things up when you introduce
another target or upgrade packages on your host.

I've maintained such a build environment (aboriginal linux) for several
years.  I've personally encountered literally _dozens_ of others, and
expect there are at least hundreds if not thousands out in the wild.

3) Perl is not a well-defined langauge.  It is a single implementation,
not a standard.  (Like Microsoft Word and Excel, their file formats are
just "what this program emits/parses".  Similarly, Perl is what the perl
binary runs.  Attemts to rewrite it based on Parrot famously collapsed
into a black hole of corner cases.)

Meaning, if you have a platform on which the one and only implementation
of perl doesn't run, you have no alternative implementations to try.
(Did I mention that Perl's configuration stage is implemented in perl?)

This moves to an alternative standardized by POSIX, which has well
understood behavior with multiple independent implementations (gnu, bsd,
busybox...)

> We already depend on perl for other stuff, so why replace something that 
> works with something that may or may not work?

We have various development scripts that depend on perl, curses, python,
QT, and so on.  But building a _kernel_ doesn't depend on any of that...
except perl.  I'm not proposing removing checkstack.pl and such, because
"development system" != "build machine".  A build machine can be a
headless box, a development system usually has things like Gnome or KDE
installed.

The kernel's dependency on Perl was introduced in 2.6.25.  Before 2008
the kernel built just fine on a host that didn't have perl installed,
and I've been patching the kernel to remove the requirement ever since
in my own build environment.  (And building the resulting kernel for a
dozen different targets, and submitting those patches here when they
changed.  They just haven't changed in a while.)

Perl is used in exactly three places during the kernel build.  I have
patches to remove the other two instances of perl use, and using them
have built a kernel on a system that doesn't have perl installed.  I'm
tweaking them for submission later today.  My prevoius submissions (such
as http://lkml.indiana.edu/hypermail/linux/kernel/0901.0/00148.html)
treated them as a series, but since the three issues are really
orthogonal I'm posting them individually this time, and cc-ing the
various people get_maintainer.pl says to.

Rob

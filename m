Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862Ab0KGIut (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 03:50:49 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34027 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753794Ab0KGIur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 03:50:47 -0500
Date: Sun, 7 Nov 2010 09:50:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Willy Tarreau <w@1wt.eu>
Cc: Marcus Meissner <meissner@suse.de>, security@kernel.org, mort@sgi.com,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, fweisbec@gmail.com,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        jason.wessel@windriver.com, tj@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Security] [PATCH] kernel: make /proc/kallsyms mode 400 to
 reduce ease of attacking
Message-ID: <20101107085016.GA23843@elte.hu>
References: <20101104100914.GC25118@suse.de>
 <20101104114648.GA23381@elte.hu>
 <20101104122906.GH25118@suse.de>
 <20101104135802.GA31416@elte.hu>
 <20101104141104.GA31753@elte.hu>
 <20101104143322.GL25118@suse.de>
 <20101104190804.GA16099@elte.hu>
 <20101104212920.GA31256@1wt.eu>
 <20101104215157.GA25128@elte.hu>
 <20101104223526.GC31236@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101104223526.GC31236@1wt.eu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Willy Tarreau <w@1wt.eu> wrote:

> On Thu, Nov 04, 2010 at 10:51:57PM +0100, Ingo Molnar wrote:
> > > Quite honnestly, it's the worst idea I've ever read to protect the kernel. Kernel 
> > > version is needed at many places, when building some code which relies on presence 
> > > of syscall X or Y depending on a version, etc... [...]
> > 
> > Actually that's not true, since we have a kernel ABI, and since there's many 
> > backports of newer kernel features into older kernels that it's generally not
> > needed nor meaningful to know the kernel version for syscalls.
> > 
> > Returning -ENOSYS is the general standard we use to communicate syscall 
> > capabilities.
> > 
> > In fact using kernel version to switch around library functionality is a bug i'd 
> > argue.
> 
> I'm sorry Ingo, but I still don't agree. We've had several versions of epoll, 
> several (some even buggy) versions of splice() which cannot even be detected 
> without checking the kernel release. And those are just two that immediately come 
> to my mind. If we've been providing a version for the last 19 years, it surely had 
> some valid uses.

I'm sorry Willy, but you are mostly wrong - and there's no need to speculate here 
really. Just try the patch below :-)

If your claim that 'kernel version is needed at many places' is true then why am i 
seeing this on a pretty general distro box bootup:

 [root@aldebaran ~]# uname -a
 Linux aldebaran 2.6.99-tip-01574-g6ba54c9-dirty #1 SMP Sun Nov 7 10:24:38 CET 2010 x86_64 x86_64 x86_64 GNU/Linux

?

Yes, some user-space might be unhappy if we set the version _back_ to say 2.4.0, but 
we could (as the patch below) fuzz up the version information from unprivileged 
attackers easily.

_Future_ ABI breakages that necessiate a version check are clearly frowned upon, so 
this patch could even be considered a debugging feature: it makes it harder to 
create ABI incompatibilities (at least for unprivileged user-space).

So you can think of version fuzzing also as the ultimate ABI check.

( This is a real defensive measure - here's a reason why attackers try stealth
  remote fingerprinting of a target system first: they really want to avoid 
  detection and knowing the exact OS and version of a target tells them which 
  attacks can be tried with a higher chance of success. Same goes for local attacks 
  as well.

  And once we have _that_, version fuzzing, removing kallsyms is one of the many 
  measures we need to use to hide the true version of the kernel from unprivileged 
  user-space. )

Thanks,

	Ingo

Index: linux/Makefile
===================================================================
--- linux.orig/Makefile
+++ linux/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
-SUBLEVEL = 37
-EXTRAVERSION = -rc1
+SUBLEVEL = 99
+EXTRAVERSION =
 NAME = Flesh-Eating Bats with Fangs
 
 # *DOCUMENTATION*

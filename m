Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878Ab0KGJu3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 04:50:29 -0500
Received: from 1wt.eu ([62.212.114.60]:47098 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753121Ab0KGJu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 04:50:27 -0500
Date: Sun, 7 Nov 2010 10:49:32 +0100
From: Willy Tarreau <w@1wt.eu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Marcus Meissner <meissner@suse.de>, security@kernel.org, mort@sgi.com,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, fweisbec@gmail.com,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        jason.wessel@windriver.com, tj@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Security] [PATCH] kernel: make /proc/kallsyms mode 400 to reduce ease of attacking
Message-ID: <20101107094932.GT4627@1wt.eu>
References: <20101104114648.GA23381@elte.hu> <20101104122906.GH25118@suse.de> <20101104135802.GA31416@elte.hu> <20101104141104.GA31753@elte.hu> <20101104143322.GL25118@suse.de> <20101104190804.GA16099@elte.hu> <20101104212920.GA31256@1wt.eu> <20101104215157.GA25128@elte.hu> <20101104223526.GC31236@1wt.eu> <20101107085016.GA23843@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101107085016.GA23843@elte.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Sun, Nov 07, 2010 at 09:50:16AM +0100, Ingo Molnar wrote:
> 
> * Willy Tarreau <w@1wt.eu> wrote:
> 
> > On Thu, Nov 04, 2010 at 10:51:57PM +0100, Ingo Molnar wrote:
> > > > Quite honnestly, it's the worst idea I've ever read to protect the kernel. Kernel 
> > > > version is needed at many places, when building some code which relies on presence 
> > > > of syscall X or Y depending on a version, etc... [...]
> > > 
> > > Actually that's not true, since we have a kernel ABI, and since there's many 
> > > backports of newer kernel features into older kernels that it's generally not
> > > needed nor meaningful to know the kernel version for syscalls.
> > > 
> > > Returning -ENOSYS is the general standard we use to communicate syscall 
> > > capabilities.
> > > 
> > > In fact using kernel version to switch around library functionality is a bug i'd 
> > > argue.
> > 
> > I'm sorry Ingo, but I still don't agree. We've had several versions of epoll, 
> > several (some even buggy) versions of splice() which cannot even be detected 
> > without checking the kernel release. And those are just two that immediately come 
> > to my mind. If we've been providing a version for the last 19 years, it surely had 
> > some valid uses.
> 
> I'm sorry Willy, but you are mostly wrong - and there's no need to speculate here 
> really. Just try the patch below :-)
> 
> If your claim that 'kernel version is needed at many places' is true then why am i 
> seeing this on a pretty general distro box bootup:
> 
>  [root@aldebaran ~]# uname -a
>  Linux aldebaran 2.6.99-tip-01574-g6ba54c9-dirty #1 SMP Sun Nov 7 10:24:38 CET 2010 x86_64 x86_64 x86_64 GNU/Linux

I don't understand the point you're trying to make with this patch. Obviously
we can pretend to be any version, and by doing that, you also pretend not to
have some bugs that would have been fixed later after the *real* version.

What I'm saying is that history has shown that we have known bugs that are
not detectable by any other way than the kernel version. Take the splice()
data corruption bug for instance. I believe it was fixed in 2.6.26 or 2.6.27
and backported late in the 2.6.25.X stable branch. Due to this, without
knowing the kernel version, the user can't know whether it's safe to use
splice() or not. I'm particularly aware of this one because I got quite a
bunch of questions from users on this subject. But certainly there are a
bunch of other ones.

> Yes, some user-space might be unhappy if we set the version _back_ to say 2.4.0, but 
> we could (as the patch below) fuzz up the version information from unprivileged 
> attackers easily.

I think you understood my concerns about breaking compatibility with userspace
by announcing a wrong version. That's not what I'm saying, but rather that
user-space couldn't rely on the version anymore to avoid known bugs.

> _Future_ ABI breakages that necessiate a version check are clearly frowned upon, so 
> this patch could even be considered a debugging feature: it makes it harder to 
> create ABI incompatibilities (at least for unprivileged user-space).

Stating this will not change the behaviour WRT bugs unfortunately.

> So you can think of version fuzzing also as the ultimate ABI check.
>
> 
> ( This is a real defensive measure - here's a reason why attackers try stealth
>   remote fingerprinting of a target system first: they really want to avoid 
>   detection and knowing the exact OS and version of a target tells them which 
>   attacks can be tried with a higher chance of success. Same goes for local attacks 
>   as well.
> 
>   And once we have _that_, version fuzzing, removing kallsyms is one of the many 
>   measures we need to use to hide the true version of the kernel from unprivileged 
>   user-space. )

I think you didn't understand me. I was explaining that doing this will not
prevent them from guessing the precise kernel version, because if you're on
a mainstream distro, just check the uptime. If last reboot matches the next
day of a kernel release, most likely it's this version. Same for /boot
modification date. And conversely, when you find an uptime of 800 days, you
know for sure that your freshly discovered bug is still present, no need of
uname for that. And I gave you examples of that which have worked.

That's why I'm claiming that version fuzzing brings nothing *really* useful.
It just makes admin think they're secure but that's false.

Also as I said, if you want your distro to hide the bug fix level, simply
rebuild the kernel with a fixed EXTRAVERSION string, or ask the kernel
maintainers there not to update the EXTRAVERSION anymore and you'll have
your version fuzzing for free without changing any kernel code. But I'm
still certain it will not bring any value.

Willy


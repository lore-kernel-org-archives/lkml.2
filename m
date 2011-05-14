Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417Ab1ENG61 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 02:58:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39922 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752174Ab1ENG6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 02:58:23 -0400
Date: Sat, 14 May 2011 08:57:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, libc-alpha@sourceware.org,
        Andi Kleen <ak@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 4/5] Add a sysconf syscall
Message-ID: <20110514065752.GA8827@elte.hu>
References: <1305329059-2017-1-git-send-email-andi@firstfloor.org>
 <1305329059-2017-5-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305329059-2017-5-git-send-email-andi@firstfloor.org>
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


* Andi Kleen <andi@firstfloor.org> wrote:

> From: Andi Kleen <ak@linux.intel.com>
> 
> During testing we found some cases where a library wants to know
> the number of CPUs for internal tuning, and calls sysconf for that.
> glibc then reads /proc/stat which is very slow and scales poorly,
> when the program is executed often.
> 
> For example sleepycat DB has this problem.
> 
> This patch adds a sysconf system call to avoid this problem.
> This adds very little code to the kernel, but gives a large speedup.
> 
> It is intended to be called from glibc.
> 
> It is not a 100% POSIX sysconf -- some values in there are only
> known to the C library, but supplies all values usefully
> known to the kernel.
> 
> In some cases it is more accurate than glibc can do because it doesn't
> have to guess. So when some value changes in the kernel it can
> return the current value.
> ---
>  include/linux/sysconf.h |   23 ++++++++++++++
>  kernel/Makefile         |    2 +-
>  kernel/sysconf.c        |   77 +++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 101 insertions(+), 1 deletions(-)
>  create mode 100644 include/linux/sysconf.h
>  create mode 100644 kernel/sysconf.c

What glibc does (opening /proc/stat) is rather stupid, but i think your syscall 
is just as stupid a solution as well, you are just implementing a weird 
filesystem, and a pretty slow one at that.

Note that these are mostly constant or semi-constant values that are updated 
very rarely:

+#define _SC_ARG_MAX     	0
+#define _SC_CHILD_MAX          1
+#define _SC_CLK_TCK            2
+#define _SC_NGROUPS_MAX        3
+#define _SC_OPEN_MAX           4
+#define _SC_PAGESIZE           30
+#define _SC_SEM_NSEMS_MAX      32
+#define _SC_SIGQUEUE_MAX       34
+#define _SC_UIO_MAXIOV         60
+#define _SC_NPROCESSORS_CONF   83
+#define _SC_NPROCESSORS_ONLN   84
+#define _SC_PHYS_PAGES         85
+#define _SC_AVPHYS_PAGES	86
+#define _SC_SYMLOOP_MAX	173

If glibc is stupid and reads /proc/stat to receive something it could cache or 
mmap() itself then hey, did you consider fixing glibc or creating a sane libc? 
It's open-source.

Do not help glibc remain stupid and sloppy until eternity!

If we *really* want to offer kernel help for these values even then your 
solution is still wrong: then the proper solution would be to define a standard 
*data* structure and map it as a vsyscall *data* page - essentially a 
kernel-guaranteed data mmap(), with no extra syscall needed!

That could have other uses as well in the future.

That way it would much faster than your current code btw.

So unless there are some compelling arguments in favor of sys_sysconf() that i 
missed, i have to NAK this:

Nacked-by: Ingo Molnar <mingo@elte.hu>

Thanks,

	Ingo

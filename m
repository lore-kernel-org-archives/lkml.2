Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469Ab0GIUdI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 16:33:08 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:42370 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904Ab0GIUdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 16:33:06 -0400
Date: Fri, 9 Jul 2010 22:33:01 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Zeev Tarantov <zeev.tarantov@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Maciej@antispam.struernethosting.dk,
       "Rutecki <"@antispam.struernethosting.dk
Subject: Re: [PATCH][GIT PULL][for 2.6.35] tracing: Add alignment to
	syscall metadata declarations
Message-ID: <20100709203301.GA13839@merkur.ravnborg.org>
References: <1278705402.1537.157.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278705402.1537.157.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 09, 2010 at 03:56:42PM -0400, Steven Rostedt wrote:
> 
> Ingo,
> 
> Please pull the latest tip/perf/urgent tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/perf/urgent
> 
> 
> Steven Rostedt (1):
>       tracing: Add alignment to syscall metadata declarations
> 
> ----
>  include/linux/syscalls.h |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> ---------------------------
> commit 44a54f787c0abcf75a2ed49b8ec8b2b512468f73
> Author: Steven Rostedt <srostedt@redhat.com>
> Date:   Fri Jul 9 15:41:44 2010 -0400
> 
>     tracing: Add alignment to syscall metadata declarations
>     
>     For some reason if we declare a static variable and then assign it
>     later, and the assignment contains a __attribute__((__aligned__(#))),
>     some versions of gcc will ignore it.
>     
>     This caused the syscall meta data to not be compact in its section
>     and caused a kernel oops when the section was being read.
>     
>     The fix for these versions of gcc seems to be to add the aligned
>     attribute to the declaration as well.
>     
>     This fixes the BZ regression:
>     
>       https://bugzilla.kernel.org/show_bug.cgi?id=16353
>     
>     Reported-by: Zeev Tarantov <zeev.tarantov@gmail.com>
>     Tested-by: Zeev Tarantov <zeev.tarantov@gmail.com>
>     Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
>     LKML-Reference: <AANLkTinkKVmB0fpVeqUkMeqe3ZYeXJdI8xDuzJEOjYwh@mail.gmail.com>
>     Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> index 7f614ce..13ebb54 100644
> --- a/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h
> @@ -124,7 +124,8 @@ extern struct trace_event_functions enter_syscall_print_funcs;
>  extern struct trace_event_functions exit_syscall_print_funcs;
>  
>  #define SYSCALL_TRACE_ENTER_EVENT(sname)				\
> -	static struct syscall_metadata __syscall_meta_##sname;		\
> +	static struct syscall_metadata					\
> +	__attribute__((__aligned__(4))) __syscall_meta_##sname;		\
>  	static struct ftrace_event_call					\
>  	__attribute__((__aligned__(4))) event_enter_##sname;		\
>  	static struct ftrace_event_call __used				\
> @@ -138,7 +139,8 @@ extern struct trace_event_functions exit_syscall_print_funcs;
>  	}
>  
>  #define SYSCALL_TRACE_EXIT_EVENT(sname)					\
> -	static struct syscall_metadata __syscall_meta_##sname;		\
> +	static struct syscall_metadata					\
> +	__attribute__((__aligned__(4))) __syscall_meta_##sname;		\
>  	static struct ftrace_event_call					\
>  	__attribute__((__aligned__(4))) event_exit_##sname;		\
>  	static struct ftrace_event_call __used				\

This looks like a fix that just hide the real bug.
If I remember the original report correct the problem is
that the symbol:

    __start_syscalls_metadata

Does not point to a valid syscall entry.

The symbol is assigned in vmlinux.lds.h like this:
#define TRACE_SYSCALLS() VMLINUX_SYMBOL(__start_syscalls_metadata) = .; \
                         *(__syscalls_metadata)                         \
                         VMLINUX_SYMBOL(__stop_syscalls_metadata) = .;

Now consider what is happening if we have the following scanario:

. equals 0x1004 so __start_syscalls_metadata is set to 0x1004
But __syscall_metadata require 8 byte alignment so it starts at 0x1008.

Then __start_syscalls_metadata fails to point at the first entry and
this code will fail:

        start = (struct syscall_metadata *)__start_syscalls_metadata;
        for ( ; start < stop; start++) {
                if (start->name && !strcmp(start->name + 3, str + 3))
                        return start;
 


iThe right fix seems to me that we guarantee that __start_syscalls_metadata
is assinged a proper address.

Something like this:
(whitespace damaged)
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 48c5299..64430d3 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -133,7 +133,8 @@
 #endif

 #ifdef CONFIG_FTRACE_SYSCALLS
-#define TRACE_SYSCALLS() VMLINUX_SYMBOL(__start_syscalls_metadata) = .;        \
+#define TRACE_SYSCALLS() . = ALIGN(8);                                 \
+                        VMLINUX_SYMBOL(__start_syscalls_metadata) = .; \
                         *(__syscalls_metadata)                         \
                         VMLINUX_SYMBOL(__stop_syscalls_metadata) = .;
 #else


But at the same time we should audit the other trace related symbols
in vmlinux.lds.h to see if they may suffer from the same potential bug.

__start_ftrace_events looks like it may have the same potential bug..

The reason why your patch works is that you force a smaller alignment
and this happens by pure luck to be the alignmnet of "." from the
previous section.

	Sam

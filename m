Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202Ab2FTM1t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 08:27:49 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33206 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab2FTM1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 08:27:48 -0400
Date: Wed, 20 Jun 2012 14:27:42 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Fengguang Wu <wfg@linux.intel.com>
Subject: Re: [PATCH v2][GIT PULL][v3.5] ftrace: Make all inline tags also
 include notrace
Message-ID: <20120620122742.GB10561@gmail.com>
References: <1340028098.25903.94.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340028098.25903.94.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo,
> 
> I updated the change log as you recommended, there was no code change.
> 
> -- Steve
> 
> Please pull the latest tip/perf/urgent-2 tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> tip/perf/urgent-2
> 
> Head SHA1: 93b3cca1ccd30b1ad290951a3fc7c10c73db7313
> 
> 
> Steven Rostedt (1):
>       ftrace: Make all inline tags also include notrace
> 
> ----
>  include/linux/compiler-gcc.h |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> ---------------------------
> commit 93b3cca1ccd30b1ad290951a3fc7c10c73db7313
> Author: Steven Rostedt <rostedt@goodmis.org>
> Date:   Thu Jun 14 10:54:28 2012 -0400
> 
>     ftrace: Make all inline tags also include notrace
>     
>     Commit 5963e317b1e9d2a ("ftrace/x86: Do not change stacks in DEBUG when
>     calling lockdep") prevented lockdep calls from the int3 breakpoint handler
>     from reseting the stack if a function that was called was in the process
>     of being converted for tracing and had a breakpoint on it. The idea is,
>     before calling the lockdep code, do a load_idt() to the special IDT that
>     kept the breakpoint stack from reseting. This worked well as a quick fix
>     for this kernel release, until a certain config caused a lockup in the
>     function tracer start up tests.
>     
>     Investigating it, I found that the load_idt that was used to prevent
>     the int3 from changing stacks was itself being traced!
>     
>     Even though the config had CONFIG_OPTIMIZE_INLINING disabled, and
>     all 'inline' tags were set to always inline, there were still cases that
>     it did not inline! This was caused by CONFIG_PARAVIRT_GUEST, where it
>     would add a pointer to the native_load_idt() which made that function
>     to be traced.
>     
>     Commit 45959ee7aa645815a ("ftrace: Do not function trace inlined functions")
>     only touched the 'inline' tags when CONFIG_OPMITIZE_INLINING was enabled.
>     PARAVIRT_GUEST shows that this was not enough and we need to also
>     mark always_inline with notrace as well.
>     
>     Reported-by: Fengguang Wu <wfg@linux.intel.com>
>     Tested-by: Fengguang Wu <wfg@linux.intel.com>
>     Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
> index e5834aa..6a6d7ae 100644
> --- a/include/linux/compiler-gcc.h
> +++ b/include/linux/compiler-gcc.h
> @@ -47,9 +47,9 @@
>   */
>  #if !defined(CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING) || \
>      !defined(CONFIG_OPTIMIZE_INLINING) || (__GNUC__ < 4)
> -# define inline		inline		__attribute__((always_inline))
> -# define __inline__	__inline__	__attribute__((always_inline))
> -# define __inline	__inline	__attribute__((always_inline))
> +# define inline		inline		__attribute__((always_inline)) notrace
> +# define __inline__	__inline__	__attribute__((always_inline)) notrace
> +# define __inline	__inline	__attribute__((always_inline)) notrace
>  #else
>  /* A lot of inline functions can cause havoc with function tracing */
>  # define inline		inline		notrace

Pulled, thanks Steve!

	Ingo

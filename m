Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382Ab1BDGEB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 01:04:01 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:59666 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab1BDGEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 01:04:00 -0500
X-AuditID: b753bd60-a2ec6ba0000066fd-a9-4d4b96cd33cd
X-AuditID: b753bd60-a2ec6ba0000066fd-a9-4d4b96cd33cd
Message-ID: <4D4B96CA.2010100@hitachi.com>
Date: Fri, 04 Feb 2011 15:03:54 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
Cc: mingo@elte.hu, rostedt@goodmis.org, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [RFC 0/4] tracing,x86_64 - function/graph trace without mcount/-pg/framepointer
References: <1296747761-9082-1-git-send-email-jolsa@redhat.com>
In-Reply-To: <1296747761-9082-1-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

(2011/02/04 0:42), Jiri Olsa wrote:
> hi,
> 
> I recently saw the direct jump probing made for kprobes
> and tried to use it inside the trace framework.
> 
> The global idea is patching the function entry with direct
> jump to the trace code, instead of using pregenerated gcc
> profile code.
> 
> I started this just to see if it would be even possible
> to hook with new probing to the current trace code. It
> appears it's not that bad. I was able to run function
> and function_graph trace on x86_64.
> 
> For details on direct jumps probe, please check:
> http://www.linuxinsight.com/ols2007-djprobe-kernel-probing-with-the-smallest-overhead.html

Thank you for referring it ;-)

> I realize using this way to hook the functions has some
> drawbacks, from what I can see it's roughly:
> - no all functions could be patched

Yeah, that is why the "djprobe" becomes "optprobe". If kprobe
finds there is no space to patch, it just fallback to a
breakpoint. Since this check is done internally, kprobes
user takes this benefit transparently ( don't need to
change user's code).

> - need to find a way to say which function is safe to patch
> - memory consumption for detour buffers and symbol records

And also, you can't patch more than two instructions without
int3 bypass method (or special stack checker), because a processor
can run and may have been interrupted on the 2nd instruction
when stop_machine is issued.
That's the 2nd reason why the djprobe is a part of kprobes.
this "int3 bypass" method disallow you to probe NMI handlers,
since int3 inside NMI will clear additional NMI masking by
issuing IRET.

> but seems there're some advantages as well:
> - trace code could be in a module
> - no profiling code is needed
> - framepointer can be disabled (framepointer is needed for
>   generating profile code)

nowadays profiling code with dynamic ftrace will not make
visible overhead, and if you need to do that without
profiling binary, you can already use kprobe-tracer for it.
(Using kprobe-tracer via perf-probe allows you to probe not
 only actual function but also inlined function entry ;-))


Thank you,

> 
> As for the attached implementation it's hack mostly (expect bugs),
> especially the ftrace/kprobe integration could be probably done better.
> It's only for x86_64.
> 
> It can be used like this:
> 
> - new menu config item is added (function tracer engine),
>   to choose mcount or ktrace
> - new file "ktrace" is added to the tracing dir
> - to add symbols to trace run:
> 	echo mutex_unlock > ./ktrace
> 	echo mutex_lock >> ./ktrace
> - to display trace symbols:
> 	cat ktrace
> - to enable the trace, the usual is needed:
> 	echo function > ./current_tracer
> 	echo function_graph > ./current_tracer
> - to remove symbols from trace:
> 	echo nop > ./current_tracer 
> 	echo > ./ktrace 
> - if the function is added while the tracer is running,
>   the symbol is enabled automatically.
> - only all symbols could be removed and only if there's
>   no tracer running.
> 
> I'm not sure how to choose from kallsyms interface what function
> is safe to patch, so I omit patching of all symbols so far.


> 
> 
> attached patches:
>  1/4 - kprobe - ktrace instruction slot cache interface
>      using kprobe detour buffer allocation, adding interface
>      to use it from trace framework
> 
>  2/4 - tracing - adding size parameter to do_ftrace_mod_code
>      adding size parameter to be able to restore the saved
>      instructions, which could be longer than relative call
> 
>  3/4 - ktrace - function trace support
>      adding ktrace support with function tracer
> 
>  4/4 - ktrace - function trace support
>      adding function graph support
> 
> 
> please let me know what you think, thanks
> jirka
> ---
>  Makefile                   |    2 +-
>  arch/x86/Kconfig           |    4 +-
>  arch/x86/kernel/Makefile   |    1 +
>  arch/x86/kernel/entry_64.S |   50 +++++++
>  arch/x86/kernel/ftrace.c   |  157 +++++++++++----------
>  arch/x86/kernel/ktrace.c   |  256 ++++++++++++++++++++++++++++++++++
>  include/linux/ftrace.h     |   36 +++++-
>  include/linux/kprobes.h    |    8 +
>  kernel/kprobes.c           |   33 +++++
>  kernel/trace/Kconfig       |   28 ++++-
>  kernel/trace/Makefile      |    1 +
>  kernel/trace/ftrace.c      |   21 +++
>  kernel/trace/ktrace.c      |  330 ++++++++++++++++++++++++++++++++++++++++++++
>  kernel/trace/trace.c       |    1 +
>  14 files changed, 846 insertions(+), 82 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com

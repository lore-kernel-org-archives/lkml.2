Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930Ab2ATNi0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 08:38:26 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:61737 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446Ab2ATNiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 08:38:21 -0500
Date: Fri, 20 Jan 2012 14:38:16 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, David Ahern <dsahern@gmail.com>,
        linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH -tip v4 0/5] perf script: add BTS analysis features
Message-ID: <20120120133811.GD18056@somewhere>
References: <20120116052146.2485.48349.stgit@linux3>
 <20120118114833.GB1024@somewhere.redhat.com>
 <4F191ED0.8070305@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F191ED0.8070305@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 20, 2012 at 04:59:12PM +0900, Akihiro Nagai wrote:
> (2012/01/18 20:48), Frederic Weisbecker wrote:
> >On Mon, Jan 16, 2012 at 02:21:46PM +0900, Akihiro Nagai wrote:
> >>Hi Frederic, David,
> >>
> >>This patch series adds the functions to analyze BTS logs to perf-script and,
> >>makes perf-script more informative version 4.
> >>The patches add the following functions.
> >>  - Unify the expression to "[unknown]"
> >>  - Fix BTS record header to resolve DSOs and symbols of user-space
> >>  - Resolve DSOs and symbols for BTS's branch_from addresses
> >>  - Show the offset of symbols with the 'offs' field specifier.
> >>  - Resolve the real path of [kernel.kallsym] using
> >>    '--show-kernel-path' option.
> >>
> >>Usage:
> >>First, get the BTS log with the following command.
> >># perf record -e branches:u -c 1 -d<command>
> >>
> >>Second, analyze that trace data.
> >># perf script -f ip,addr,sym,offs,dso [--show-kernel-path]
> >>This command's output format is:
> >><branch_to addr>  <branch_to function+offset>  <branch_to DSO>  <branch_from addr>  <branch_from function+offset>  <branch_from DSO>
> >>
> >>Output sample:
> >># perf record -e branches:u -c 1 -d ls
> >>[snip]
> >># perf script -f ip,addr,sym,dso,offs --show-kernel-path
> >>[snip]
> >>402c1c main+0x0             (/root/bin/ls)       3430c21399 __libc_start_main+0xe9 (/lib64/libc-2.14.so)
> >
> >I was confused first, looking for the reason why we have a so strange branch flow
> >until I realized the format is "to from".
> >
> >Can we have "from to" instead? This will be much more intuitive. "from =>  to" would be even better.
> Exactly.
> perf records branch_to information in perf_sample->addr, and branch_from in perf_sample->ip.
> And, currently I use the generic function: process_event() in builtin-script.c to print
> branch information. This function prints perf_sample->addr before it prints perf_sample->ip.
> 
> So, I'm going to add the bts specialized codes to process_event().
> 
> static void process_event(...)
> {
>     <snip>
>     print_sample_start(sample, thread, attr);
> 
>     if (is_bts_event(attr)) {
>         print_sample_bts(...);
>         return;
>     }
> 
>     if (PRINT_FIELD(TRACE))
>     <snip>
> }
> 
> Thank you.

You're right, that's a specialization. We need to support well raw
formatting like you did and then we can do the specialization incrementally.

Thanks!

> >
> >Thanks!
> >
> >>40b390 set_program_name+0x0 (/root/bin/ls)           402c41 main+0x25              (/root/bin/ls)
> >>40b390 set_program_name+0x0 (/root/bin/ls) ffffffff814ac5ed irq_return+0x0         (/lib/modules/3.2.0+/build/vmlinux)
> >>401e20 strrchr@plt+0x0      (/root/bin/ls)           40b39e set_program_name+0xe   (/root/bin/ls)
> >>401e26 strrchr@plt+0x6      (/root/bin/ls)           401e20 strrchr@plt+0x0        (/root/bin/ls)
> >>401b80 _init+0x18           (/root/bin/ls)           401e2b strrchr@plt+0xb        (/root/bin/ls)
> >>3430813850 _dl_runtime_resolve+0x0 (/lib64/ld-2.14.so) 401b86 _init+0x1e           (/root/bin/ls)
> >>[snip]
> >

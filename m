Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610Ab1EZN2k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 09:28:40 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57564 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748Ab1EZN2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 09:28:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hCbLaKLPvxRo6E0bieRIXmCcF/eet1KBEXxJLoT8RlXTVk6z+ay5f5wJuUyh85B6R0
         Muug/Dw01kZnDKi79WK0YlWjspqiEFUo91mS+MtCXeXQQhmsP19j9V7bRHMHL6+f4Zw6
         3yVP3sjpLlbCNCtPfubgqb52sWN0yU2IPKAkc=
Date: Thu, 26 May 2011 15:28:34 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        pp-manager@sdl.hitachi.co.jp, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH -tip v4 0/7] perf: Introduce branch sub commands
Message-ID: <20110526132833.GC21815@nowhere>
References: <20110526050246.30011.86048.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110526050246.30011.86048.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Adding David Ahern in Cc)

Ok that's all good except this needs to use the "perf script" centralized
dump.

Currently running "perf script" without an actual script dumps
the events by default, whatever kind of event they are: hardware,
software, tracepoints, ...
So we want the branch output to be supported there, so we can reuse
some code and interface.

For example, "perf script -f branch:comm,tid,sym" would print the
comm, tid and the sym for to and from addresses.

That's better than creating a new set of options in a new command
that people need to relearn while everybody could simply get
familiarized with common perf script options.

Of course we can still have a "perf branch" command, which could
be a tiny shortcut that maps to perf record and perf script.

Like:

	perf branch record
	perf branch [trace] -f tid,sym,comm

Would map to:

	perf record branch:u
	perf script -f branch:tid,sym,comm

And may be if one day we can do something more tricky than a
linear output for branches (like source code coloring/browsing),
then it may be implemented inside perf branch and not rely on
another subcommand. Until then we are only dealing with raw linear
dump, and that's a core job for perf script where we want to
centralize that kind of facility.

Thanks.

On Thu, May 26, 2011 at 02:02:46PM +0900, Akihiro Nagai wrote:
> Hi,
> 
> This patch series provides the commands 'perf branch record' and
> 'perf branch trace' version 4. These commands record and analyze
> a BTS (Branch Trace Store) log. And, they provide the interface
> to use BTS log for application developers.
> 
> BTS is a facility of Intel x86 processors, which records the address of
> 'branch to/from' on every branch/jump instruction and interrupt.
> This facility is very useful for developers to test their software,
> for example, coverage test, execution path analysis, dynamic step count ...etc.
> These test tools have a big advantage, which user doesn't have to modify target
> executable binaries, because the BTS is a hardware feauture.
> 
> But, there are few applications using BTS. Reasons I guess are ...
>  - Few people know what BTS is.
>  - Few people know how to use BTS on Linux box.
>  - It's hard to analyze the BTS log because it includes just a series of
>    addresses.
> 
> So, I want to provide a user-friendly interface to BTS for application
> developers.
> 
> 
>  About new sub commands
> ========================
> 'perf branch record' provides an easy way to record BTS log.
> Usage is 'perf branch record <command>'.  This command is just an alias to
> 'perf record -e branches:u -c 1 -d <command>'. But, new one is more simple
> and more intuitive.
> 
> 'perf branch trace' can parse and analyze recorded BTS log and print various
> information of execution path. This command can show address, pid, command name,
> function+offset, file path of elf.
> You can choose the printed information with option.
> 
> Example: 'perf branch trace'
> 
> function+offset
> _start+0x3      => _dl_start+0x0
> _dl_start+0x71  => _dl_start+0x93
> _dl_start+0x97  => _dl_start+0x78
> _dl_start+0x97  => _dl_start+0x78
> _dl_start+0xa3  => _dl_start+0x3c0
> _dl_start+0x3c8 => _dl_start+0x3e8
> ...
> 
> This is the default behavior of 'perf branch trace'. It prints function+offset.
> 
> Example2: 'perf branch -cas trace'
> command address            function+offset
> ls      0x0000003e9b000b23 _start+0x3      => 0x0000003e9b004540 _dl_start+0x0
> ls      0x0000003e9b0045b1 _dl_start+0x71  => 0x0000003e9b0045d3 _dl_start+0x93
> ls      0x0000003e9b0045d7 _dl_start+0x97  => 0x0000003e9b0045b8 _dl_start+0x78
> ls      0x0000003e9b0045d7 _dl_start+0x97  => 0x0000003e9b0045b8 _dl_start+0x78
> ls      0x0000003e9b0045e3 _dl_start+0xa3  => 0x0000003e9b004900 _dl_start+0x3c0
> ls      0x0000003e9b004908 _dl_start+0x3c8 => 0x0000003e9b004928 _dl_start+0x3e8
> ...
> 
> In the future, I'd like to make this more informative. For example
>  - Show source file path
>  - Show line number
>  - Show inlined function name
>  - Draw call graph
>  - Browse source code and coloring
>  - Make BTS record fast
> and more!
> 
> Changes in V4:
>  - Add kenel filter
>  - Print PID and command only once in a line
>  - Add output TSV mode
> 
> Changes in V3:
>  - Update to the latest -tip tree
>  - Rename to 'perf branch'
>  - Process only BTS records
>  - Fix bug of getting elf_filepath
>  - Fix return value of __cmd_trace
> 
> Changes in V2:
>  - Update to the latest -tip tree
>  - Add bts explanation to the subcommand list
>  - Remove the patch already merged (add OPT_CALLBACK_DEFAULT_NOOPT)
>  - Add comments
>  - Add new function to the todo list
> 
> Thanks,
> 
> ---
> 
> Akihiro Nagai (7):
>       perf branch trace: add kernel filter
>       perf branch trace: add print all option
>       perf branch trace: print function+offset
>       perf branch trace: print file path of the executed elf
>       perf branch trace: print pid and command
>       perf branch: Introduce new sub command 'perf branch trace'
>       perf: new subcommand perf branch record
> 
> 
>  tools/perf/Documentation/perf-branch.txt |   62 +++++
>  tools/perf/Makefile                      |    1 
>  tools/perf/builtin-branch.c              |  361 ++++++++++++++++++++++++++++++
>  tools/perf/builtin.h                     |    1 
>  tools/perf/command-list.txt              |    1 
>  tools/perf/perf.c                        |    1 
>  6 files changed, 427 insertions(+), 0 deletions(-)
>  create mode 100644 tools/perf/Documentation/perf-branch.txt
>  create mode 100644 tools/perf/builtin-branch.c
> 
> -- 
> Akihiro Nagai (akihiro.nagai.hw@hitachi.com)

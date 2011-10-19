Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674Ab1JSHQc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 03:16:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58520 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249Ab1JSHQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 03:16:30 -0400
Date: Wed, 19 Oct 2011 09:14:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [GIT PULL 0/7] perf/core fixes and improvements
Message-ID: <20111019071457.GB2075@elte.hu>
References: <1318974247-6683-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1318974247-6683-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

>         Please consider pulling from:
> 
> git://github.com/acmel/linux.git perf/core
> 
> 	The TUI now should be much closer to the old 'perf top' stdio
> visual/experience, more on that vein in the next pull req.
> 
> - Arnaldo
> 
> Arnaldo Carvalho de Melo (7):
>   perf hists browser: Add missing hotkeys to the help window
>   perf tui: Catch signals to exit gracefully
>   perf ui browser: Allow initial use without navigation UI elements
>   perf hists: Don't format the percentage on hist_entry__snprintf
>   perf tui: Remove unneeded call to newtCls on startup
>   perf ui browser: Make the colors configurable and change the defaults
>   perf top tui: Give color hints just on the percentage, like on --stdio
> 
>  tools/perf/Documentation/perfconfig.example |   20 ++++
>  tools/perf/util/hist.c                      |   29 ++++--
>  tools/perf/util/hist.h                      |    4 +-
>  tools/perf/util/ui/browser.c                |  127 ++++++++++++++++++++++-----
>  tools/perf/util/ui/browser.h                |    2 +
>  tools/perf/util/ui/browsers/annotate.c      |    6 ++
>  tools/perf/util/ui/browsers/hists.c         |   51 ++++++-----
>  tools/perf/util/ui/setup.c                  |   25 +++++-
>  8 files changed, 203 insertions(+), 61 deletions(-)
>  create mode 100644 tools/perf/Documentation/perfconfig.example

Pulled, thanks Arnaldo.

The way the TUI now follows terminal colors is really nice. There's a 
few regressions that sneaked in, and there's also still a few rough 
edges as well:

 - in callq following if i exit a secondary annotation screen via 'q' 
   or left-arrow, it does not jump back to the callq line as it did 
   earlier.

 - it's still hard to find all the callq's in the stream of assembly,
   i think it should be highlighted in a minimal fashion.

 - the mixed assembly and source code output for annotation now 
   became *harder* to follow, that the instruction opcodes are not 
   embedded. The reason is that there's now fewer visual patterns 
   that set apart the two types of lines.

   Not sure what to do about it, but it's not really usable this way, 
   to me at least. Color differentiation would certainly help, if 
   it's not too intrusive - could assembly be drawn grey? That would 
   put it into the 'visual background' on most terminal color 
   schemes.

   I tried a few mockup screens of splitting the screen 
   intelligently, and found one variant that works pretty well for 
   me. The main UI design complication is that the assembly opcodes 
   look so C source code-ish when put next to each other.

   So this is the original output:

         :        static u8 kallsyms2elf_type(char type)                                            ▒
         :        {                                                                                 ▒
         :                if (type == 'W')                                                          ▒
    0.00 :          43fd18:       mov    %rdx,%rdi                                                  ▒
         :                struct rb_node **p = &symbols->rb_node;                                   ▒
         :                struct rb_node *parent = NULL;                                            ▒
         :                const u64 ip = sym->start;                                                ▒
         :                struct symbol *s;                                                         ▒
         :                                                                                          ▒
         :                while (*p != NULL) {                                                      ▒
    0.00 :          43fd1b:       mov    (%rcx),%rdx                                                ▒
    0.00 :          43fd1e:       test   %rdx,%rdx                                                  ▒
    0.00 :          43fd21:       jne    43fd08 <map__process_kallsym_symbol+0xc8>                  ▒


   and here's the mockup:

        .                              | static u8 kallsyms2elf_type(char type)                     ▒
        .                              | {                                                          ▒
        .                              |         if (type == 'W')                                   ▒
   0.00 #  43fd18: mov    %rdx,%rdi                                                                 ▒
        .                              |         struct rb_node **p = &symbols->rb_node;            ▒
        .                              |         struct rb_node *parent = NULL;                     ▒
        .                              |         const u64 ip = sym->start;                         ▒
        .                              |         struct symbol *s;                                  ▒
        .                              |                                                            ▒
        .                              |         while (*p != NULL) {                               ▒
   0.00 #  43fd1b: mov    (%rcx),%rdx                                                               ▒
   0.00 #  43fd1e: test   %rdx,%rdx                                                                 ▒
   0.00 #  43fd21: jne    43fd08 <map__process_kallsym_symbol+0xc8>                                 ▒

There's several UI tricks:

 - typical short opcodes (80% of assembly) will fit on the left side 
   of the screen.

 - lines can still be arbitrarily long and overlap, so it's not a 
   true split screen - but the vertical helper line prefixing source 
   code lines keeps the eye focused on whichever side one intends to 
   concentrate on.

 - the first column separator uses two types of characters, '.' and 
   '#', to help the eye find the blocks of assembly.

 - we could, in addition, print assembly in grey.

 - i cut one character from the percentage column - the maximum value 
   is 100.00 so we don't need the original 7.2 format, 6.2 is enough.

We could eventually further compress the assembly display later on, 
but auto-labeling function-local labels (which are 99% of the jump 
targets). This would compress such jumps:

   0.00 #  43fd21: jne    43fd08 <map__process_kallsym_symbol+0xc8>

into:

   0.00 #  43fd21: jne    43fd08 <L3>

Thanks,

	Ingo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086Ab1JSOOa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 10:14:30 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46274 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984Ab1JSOO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 10:14:29 -0400
Date: Wed, 19 Oct 2011 12:14:16 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [GIT PULL 0/7] perf/core fixes and improvements
Message-ID: <20111019141416.GD2229@ghostprotocols.net>
References: <1318974247-6683-1-git-send-email-acme@infradead.org>
 <20111019071457.GB2075@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111019071457.GB2075@elte.hu>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Oct 19, 2011 at 09:14:57AM +0200, Ingo Molnar escreveu:
> * Arnaldo Carvalho de Melo <acme@infradead.org> wrote:
> > 	The TUI now should be much closer to the old 'perf top' stdio
> > visual/experience, more on that vein in the next pull req.

> Pulled, thanks Arnaldo.
> 
> The way the TUI now follows terminal colors is really nice. There's a 
> few regressions that sneaked in, and there's also still a few rough 
> edges as well:

>  - in callq following if i exit a secondary annotation screen via 'q' 
>    or left-arrow, it does not jump back to the callq line as it did 
>    earlier.

Oh, I noticed this at some point, but couldn't quickly reproduce as I
was concentrated on something else, but I think its case of using
'continue' versus 'break' when coming back from the nested annotation
browser, so that we don't change the current selection, will check that
now.
 
>  - it's still hard to find all the callq's in the stream of assembly,
>    i think it should be highlighted in a minimal fashion.

I'll use a graphic '->', like » or something, have to look at the
libslang docs.
 
>  - the mixed assembly and source code output for annotation now 
>    became *harder* to follow, that the instruction opcodes are not 
>    embedded. The reason is that there's now fewer visual patterns 
>    that set apart the two types of lines.
> 
>    Not sure what to do about it, but it's not really usable this way, 
>    to me at least. Color differentiation would certainly help, if 
>    it's not too intrusive - could assembly be drawn grey? That would 
>    put it into the 'visual background' on most terminal color 
>    schemes.

I'll make that configurable so that we can play a bit with it and then
decide on some sane default.
 
>    I tried a few mockup screens of splitting the screen 
>    intelligently, and found one variant that works pretty well for 
>    me. The main UI design complication is that the assembly opcodes 
>    look so C source code-ish when put next to each other.
> 
>    So this is the original output:
> 
>          :        static u8 kallsyms2elf_type(char type)                                            ▒
>          :        {                                                                                 ▒
>          :                if (type == 'W')                                                          ▒
>     0.00 :          43fd18:       mov    %rdx,%rdi                                                  ▒
>          :                struct rb_node **p = &symbols->rb_node;                                   ▒
>          :                struct rb_node *parent = NULL;                                            ▒
>          :                const u64 ip = sym->start;                                                ▒
>          :                struct symbol *s;                                                         ▒
>          :                                                                                          ▒
>          :                while (*p != NULL) {                                                      ▒
>     0.00 :          43fd1b:       mov    (%rcx),%rdx                                                ▒
>     0.00 :          43fd1e:       test   %rdx,%rdx                                                  ▒
>     0.00 :          43fd21:       jne    43fd08 <map__process_kallsym_symbol+0xc8>                  ▒
> 
> 
>    and here's the mockup:
> 
>         .                              | static u8 kallsyms2elf_type(char type)                     ▒
>         .                              | {                                                          ▒
>         .                              |         if (type == 'W')                                   ▒
>    0.00 #  43fd18: mov    %rdx,%rdi                                                                 ▒
>         .                              |         struct rb_node **p = &symbols->rb_node;            ▒
>         .                              |         struct rb_node *parent = NULL;                     ▒
>         .                              |         const u64 ip = sym->start;                         ▒
>         .                              |         struct symbol *s;                                  ▒
>         .                              |                                                            ▒
>         .                              |         while (*p != NULL) {                               ▒
>    0.00 #  43fd1b: mov    (%rcx),%rdx                                                               ▒
>    0.00 #  43fd1e: test   %rdx,%rdx                                                                 ▒
>    0.00 #  43fd21: jne    43fd08 <map__process_kallsym_symbol+0xc8>                                 ▒
> 
> There's several UI tricks:
> 
>  - typical short opcodes (80% of assembly) will fit on the left side 
>    of the screen.

right
 
>  - lines can still be arbitrarily long and overlap, so it's not a 
>    true split screen - but the vertical helper line prefixing source 
>    code lines keeps the eye focused on whichever side one intends to 
>    concentrate on.

Ok, I'll play with that.

	
>  - the first column separator uses two types of characters, '.' and 
>    '#', to help the eye find the blocks of assembly.

>  - we could, in addition, print assembly in grey.
> 
>  - i cut one character from the percentage column - the maximum value 
>    is 100.00 so we don't need the original 7.2 format, 6.2 is enough.

OK, after the first there was some 8 spaces that came from how it was
done long ago.
 
> We could eventually further compress the assembly display later on, 
> but auto-labeling function-local labels (which are 99% of the jump 
> targets). This would compress such jumps:
> 
>    0.00 #  43fd21: jne    43fd08 <map__process_kallsym_symbol+0xc8>
> 
> into:
> 
>    0.00 #  43fd21: jne    43fd08 <L3>

Yeah, this is something definetely in the plans, together with jumping
to labels, etc.
 
> Thanks,
> 
> 	Ingo

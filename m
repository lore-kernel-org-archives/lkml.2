Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076Ab2DYKbe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 06:31:34 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57765 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756970Ab2DYKbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 06:31:33 -0400
Date: Wed, 25 Apr 2012 07:31:32 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Hagen Paul Pfeifer <hagen@jauu.net>
Subject: Re: [GIT PULL 00/13] Annotation improvements (G+ edition)
Message-ID: <20120425103132.GB17992@infradead.org>
References: <1334867644-2722-1-git-send-email-acme@infradead.org>
 <20120425070537.GA29496@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120425070537.GA29496@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CCing Hagen, who also reported this crash on G+.

Em Wed, Apr 25, 2012 at 09:05:38AM +0200, Ingo Molnar escreveu:
> The new output looks very (very!) nice - but it is still a bit 
> fragile:

Glad you liked it :-)
 
> earth5:~/tip/tools/perf> ./perf record -a sleep 1
> [ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.092 MB perf.data (~4008 samples) ]
> 
> earth5:~/tip/tools/perf> ./perf annotate _int_free
> perf: Segmentation fault
> 
> The crash happens here:
> 
> Program received signal SIGSEGV, Segmentation fault.
> 0x0000000000486cda in annotate_browser__mark_jump_targets (size=<optimized out>, 
>     browser=<optimized out>) at ui/browsers/annotate.c:704
> 704			bdlt->jump_target = true;
> 
> But other than that the new assembly output is awesome :-)

Humm...

683 static void annotate_browser__mark_jump_targets(struct annotate_browser *browser,
684							size_t size)
685	{
686		u64 offset;
687	
688		for (offset = 0; offset < size; ++offset) {
689			struct disasm_line *dl = browser->offsets[offset], *dlt;
690			struct browser_disasm_line *bdlt;
691	
692			if (!dl || !dl->ins || !ins__is_jump(dl->ins))
693				continue;
694	
695			if (dl->ops.target >= size) {
696				ui__error("jump to after symbol!\n"
697					  "size: %zx, jump target: %" PRIx64,
698					  size, dl->ops.target);
699				continue;
700			}
701	
702			dlt = browser->offsets[dl->ops.target];
703			bdlt = disasm_line__browser(dlt);
704			bdlt->jump_target = true;
705		}
706			
707	}

(gdb) p size
$5 = 2415
(gdb) p offset
$6 = 140
(gdb) p dl->ops.target
$7 = 143
(gdb) p browser->offsets[143]
$8 = (struct disasm_line *) 0x0
(gdb) p dl->name
$9 = 0x2363bd0 "je"
(gdb)

Really strange, the code assumed that at the jump target we would have an
assembly line, but only in the previous instruction offset we have a 'lock':

(gdb) p browser->offsets[144]
$10 = (struct disasm_line *) 0x0
(gdb) p browser->offsets[142]
$11 = (struct disasm_line *) 0x27bd620
(gdb) p browser->offsets[142]->name
$12 = 0x237a8a0 "lock"
(gdb)

I'll study this more, but for now I'll just check if there is a disasm_line
at dl->ops.target, i.e. a valid jump target.

- Arnaldo

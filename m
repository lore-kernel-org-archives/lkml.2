Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227Ab2CEW1B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 17:27:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63365 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756689Ab2CEW1A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 17:27:00 -0500
Date: Mon, 5 Mar 2012 19:26:14 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Arun Sharma <asharma@fb.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        dsahern@gmail.com, ravitillo@lbl.gov, khandual@linux.vnet.ibm.com,
        robert.richter@amd.com, ming.m.lin@intel.com, vweaver1@eecs.utk.edu,
        andi@firstfloor.org
Subject: Re: [PATCH] perf report: auto-detect branch stack sampling mode
Message-ID: <20120305222614.GB5656@infradead.org>
References: <20120224094048.GA7952@quad>
 <20120305154753.GA14604@elte.hu>
 <20120305155011.GA32413@elte.hu>
 <20120305155642.GB32413@elte.hu>
 <1330965033.11248.240.camel@twins>
 <20120305203518.GA5656@infradead.org>
 <4F55337B.4080807@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F55337B.4080807@fb.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Mar 05, 2012 at 01:43:23PM -0800, Arun Sharma escreveu:
> On 3/5/12 12:35 PM, Arnaldo Carvalho de Melo wrote:
> >Em Mon, Mar 05, 2012 at 05:30:33PM +0100, Peter Zijlstra escreveu:
> >>On Mon, 2012-03-05 at 16:56 +0100, Ingo Molnar wrote:
> >Do you have any specific complaints about it?
> 
> I think --tui code paths have some bugs that cause it to SIGSEGV,
> while the --stdio paths don't. I think much of it has to do with how

We'll have the same problem with --gtk, i.e. as much as we librarise the
backend code, there will be bugs in the frontends, but then we'll fix as
in this case.

What I was more concerned was what usability problems Peter and Stephane
had with the TUI, i.e. any missing feature they like on --stdio, or any
annoyance wrt color schemes, key bindings, etc.

I made an effort to try and have the look and feel of the TUI to
resemble as much as possible the one in --stdio, while allowing
usability improvements not possible in the --stdio case, like:

. Folding/unfolding callchains
. Zooming by DSO, etc
. Going to annotate and back really quickly
. Initial support for navigation in the annotate window (just callq for
  now, but jumps, etc are on the plans)
. Toggling source code on/off on the annotation window

> often that particular combination of command line options is used.
> 
> Here's an example:
> 
> # perf record -ag -- sleep 3
> # perf report -G -s pid --tui # SIGSEGV

Ok, now this is a good report, I managed to reproduce and will work on a
fix, thanks,

- Arnaldo

> # perf report -G -s pid --stdio # works fine
> 
> Details attached.
> 
>  -Arun
> 
> 
> 

>                                                                                                                                                                                                                   
> Program received signal SIGSEGV, Segmentation fault.                                                                                                                                                              
> [Switching to Thread 139975795275488 (LWP 13155)]                                                                                                                                                                 
> symbol__inc_addr_samples (sym=0x91eb90, map=<value optimized out>, evidx=0, addr=120416) at util/annotate.c:73                                                                                                    
> 73      util/annotate.c: No such file or directory.                                                                                                                                                               
>         in util/annotate.c                                                                                                                                                                                        
> (gdb) bt                                                                                                                                                                                                          
> #0  symbol__inc_addr_samples (sym=0x91eb90, map=<value optimized out>, evidx=0, addr=120416) at util/annotate.c:73                                                                                                
> #1  0x0000000000410b5d in process_sample_event (tool=<value optimized out>, event=0x7f4ea28e26b0, sample=0x7fffcc1ca8f0, evsel=0x823ea0, machine=0x822290) at builtin-report.c:127                                
> #2  0x00000000004433ca in flush_sample_queue (s=0x822230, tool=0x7fffcc1cc340) at util/session.c:528                                                                                                              
> #3  0x0000000000444d16 in __perf_session__process_events (session=0x822230, data_offset=<value optimized out>, data_size=<value optimized out>, file_size=<value optimized out>, tool=0x7fffcc1cc340)             
>     at util/session.c:1175                                                                                                                                                                                        
> #4  0x0000000000445217 in perf_session__process_events (self=0x822230, tool=0x7fffcc1cc340) at util/session.c:1191                                                                                                
> #5  0x000000000041015b in cmd_report (argc=0, argv=0x7fffcc1cc830, prefix=<value optimized out>) at builtin-report.c:311                                                                                          
> #6  0x00000000004051b9 in handle_internal_command (argc=4, argv=0x7fffcc1cc830) at perf.c:273                                                                                                                     
> #7  0x0000000000405623 in main (argc=4, argv=0x479218) at perf.c:388                                                                                                                                              
>                                                                                                                                                                                       
> (gdb) p /x sym->start                                                                                                                                                                                          
> $5 = 0xffffffff8100fb74                                                                                                                                                                                           
> (gdb) p /x addr
> $6 = 0x1d660
> (gdb) p offset
> $7 = 2130762476
> 
> 54 int symbol__inc_addr_samples(struct symbol *sym, struct map *map,
> 55                              int evidx, u64 addr)
> 56 {
> 57         unsigned offset;
> 58         struct annotation *notes;
> 59         struct sym_hist *h;
> 60 
> 61         notes = symbol__annotation(sym);
> 62         if (notes->src == NULL)
> 63                 return -ENOMEM;
> 64 
> 65         pr_debug3("%s: addr=%#" PRIx64 "\n", __func__, map->unmap_ip(map, addr));
> 66 
> 67         if (addr >= sym->end)
> 68                 return 0;
> 69 
> 70         offset = addr - sym->start;
> 71         h = annotation__histogram(notes, evidx);
> 72         h->sum++;
> 73         h->addr[offset]++; <-- potential bad memory reference


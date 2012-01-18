Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880Ab2ARK5m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 05:57:42 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:41501 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938Ab2ARK5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 05:57:41 -0500
Date: Wed, 18 Jan 2012 16:17:49 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Anton Arapov <anton@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Roland McGrath <roland@hack.frob.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH v9 3.2 2/9] uprobes: handle breakpoint and signal step
 exception.
Message-ID: <20120118104749.GG15447@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120110114821.17610.9188.sendpatchset@srdronam.in.ibm.com>
 <20120118083906.GA4697@bandura.brq.redhat.com>
 <20120118090232.GE15447@linux.vnet.ibm.com>
 <201201180518.31407.vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <201201180518.31407.vapier@gentoo.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12011810-4242-0000-0000-00000087ADAB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Wednesday 18 January 2012 04:02:32 Srikar Dronamraju wrote:
> > >   Can we use existing SET_IP() instead of set_instruction_pointer() ?
> > 
> > Oleg had already commented about this in one his uprobes reviews.
> > 
> > The GET_IP/SET_IP available in include/asm-generic/ptrace.h doesnt work
> > on all archs. Atleast it doesnt work on powerpc when I tried it.
> 
> so migrate the arches you need over to it.

One question that could be asked is why arent we using instruction_pointer
instead of GET_IP since instruction_pointer is being defined in 25
places and with references in 120 places.

> 
> > Also most archs define instruction_pointer(). So I thought (rather Peter
> > Zijlstra suggested the name set_instruction_pointer())
> > set_instruction_pointer was a better bet than SET_IP. I
> 
> asm-generic/ptrace.h already has instruction_pointer_set()
> 
> > Also I dont see any usage for SET_IP/GET_IP.
> 
> i think you mean "users" here ?  the usage should be fairly obvious.  both 
> macros are used by asm-generic/ptrace.h internally, but (currently) rarely 
> defined by arches themselves (by design).  the funcs that are based on these 
> GET/SET helpers though do get used in many places.
> 
> simply grep arch/*/include/asm/ptrace.h


here are the stats

$ grep -r -w GET_IP * | wc -l 
5
$ grep -r -w SET_IP * | wc -l 
3
$ grep -r -w instruction_pointer * | wc -l 
120
$ grep -r -w instruction_pointer_set * | wc -l
3

The only place I saw GET_IP was used was to define SET_IP
The only place I saw SET_IP was used was to define
instruction_pointer_set.
The only place  I saw instruction_pointer_set being used is drivers/misc/kgdbts.c 

instruction_pointer was defined in close to 25 places.

> 
> > May be we should have something like this in
> > include/asm-generic/ptrace.h
> > 
> > #ifdef instruction_pointer
> > #define GET_IP(regs)		(instruction_pointer(regs))
> > #define set_instruction_pointer(regs, val) (instruction_pointer(regs) =
> > (val))
> > #define SET_IP(regs, val)	(set_instruction_pointer(regs,val))
> > #endif
> > 
> 
> what you propose here won't work on all arches which is the whole point of 
> {G,S}ET_IP in the first place.  i proposed a similar idea before and was shot 
> down for exactly that reason.  look at ia64 for an obvious example.

Sorry, I didnt quite understand this.
Was it that people objected to instruction_pointer or 
Is it that instruction_pointer and GET_IP will work differently on few
architectures or 
Is it people had an objection to defining instruction_pointer.

So let me rephrase here. Initially we used set_ip. But Peter suggested
that the name be changed to set_instruction_pointer so that it goes with 
instruction_pointer. I also felt that set_instruction_pointer was
better.  However I am okay with any other name including
SET_IP/instruction_pointer_set. I have no issues in moving the
set_instruction_pointer to arch/*/ptrace.h files it it helps (including
include/asm-generic/ptrace.h).

But I think  we should either have GET_IP or instruction_pointer.
Similarly either SET_IP/set_instruction_pointer{_set}. Since
instruction_pointer is more widely used, I would side by the
instruction_pointer.

> 
> > or should we do away with GET_IP/SET_IP esp since there are no many
> > users?
> 
> no, the point is to migrate to asm-generic/ptrace.h, not away from it.

I think the rational for having asm-generic/ptrace.h was to have define
a way to get the instruction_pointer such that the each archs dont have
to define their own definition unless and untill its necessary.

If yes, then why did we choose the names GET_IP/SET_IP instead of
instruction_pointer and the like.

-- 
Thanks and Regards
Srikar



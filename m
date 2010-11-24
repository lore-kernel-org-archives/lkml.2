Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176Ab0KXBHO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 20:07:14 -0500
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:51451 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755626Ab0KXBHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 20:07:12 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAI/v60xGHlyW/2dsb2JhbACibXK9dYJyglkEhFo4
Date: Tue, 23 Nov 2010 19:27:03 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jason Baron <jbaron@redhat.com>, mingo@elte.hu, peterz@infradead.org,
        hpa@zytor.com, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] jump label: move jump table to r/w section
Message-ID: <20101124002703.GB29158@Krystal>
References: <cover.1290546539.git.jbaron@redhat.com> <bbc34a86a4cf4addcde1b85d7fa7faecc0966c03.1290546539.git.jbaron@redhat.com> <20101123235519.GB21549@Krystal> <1290557049.30543.417.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1290557049.30543.417.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 19:24:40 up 230 days, 10:14,  5 users,  load average: 1.15, 0.40,
	0.19
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Tue, 2010-11-23 at 18:55 -0500, Mathieu Desnoyers wrote:
> > * Jason Baron (jbaron@redhat.com) wrote:
> > > Since we writing the jump table it should be be in R/W kernel
> > > section. Move it to DATA_DATA
> > > 
> > > Signed-off-by: Jason Baron <jbaron@redhat.com>
> > > ---
> > >  include/asm-generic/vmlinux.lds.h |   14 ++++----------
> > >  1 files changed, 4 insertions(+), 10 deletions(-)
> > > 
> > > diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> > > index bd69d79..9ca894d 100644
> > > --- a/include/asm-generic/vmlinux.lds.h
> > > +++ b/include/asm-generic/vmlinux.lds.h
> > > @@ -161,6 +161,10 @@
> > >  	VMLINUX_SYMBOL(__start___tracepoints) = .;			\
> > >  	*(__tracepoints)						\
> > >  	VMLINUX_SYMBOL(__stop___tracepoints) = .;			\
> > > +	. = ALIGN(8);							\
> > 
> > Past churn with various architectures and compiler with tracepoints,
> > markers and immediate values lead me to hint at the following approach
> > for jump label structure alignment:
> > 
> > . = ALIGN(32);
> > 
> > and to modify jump_label.h to have:
> > 
> > struct jump_entry {
> > 	jump_label_t code;
> > 	jump_label_t target;
> > 	jump_label_t key;
> > } __attribute__((aligned(32)));
> > 
> > Otherwise, the compiler is free to choose on which value it prefers to
> > align the jump_entry structures, which might not match the address at
> > which the linker scripts puts the beginning of the jump table.
> > 
> > In this case, given that we put put the jump label table after the
> > tracepoint table, we should be already aligned on 32 bytes. But I would
> > recommend to put the . = ALIGN(32) in the linker script anyway, just for
> > documentation purpose (and it should not add any padding in this case).
> > 
> > This is not a problem introduced by this patch, it also applies to the
> > current jump label code.
> 
> Agreed, but this change could probably wait for 2.6.38.
> 
> Also, if this is done, then an it should be wrapped in a
> #ifdef CONFIG_JUMP_LABEL and only inserted if we are using jump labels.
> Otherwise we may add a 32 byte hole for nothing. I know it's small, but
> why waste it if you don't need to.

The lack of proper alignment did cause nasty hard-to-identify/reproduce
regressions based on the compiler used, target platform and data layout.
It's up to you, but I'd be much more comfortable merging this in 2.6.37.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com

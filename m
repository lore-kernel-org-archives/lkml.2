Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136Ab0KXC74 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 21:59:56 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:54295 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889Ab0KXC7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 21:59:55 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=fIAfbhESzNEA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=bcMtALr44WPWFqAyzPwA:9 a=GmfcTasCeeci-FfHUmwA:7 a=-62nPtYrzhmBAJJqJZO2b-wcda0A:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=V4PGMTEq58M-QOI7:21 a=6QIJ6nUxqNr9ngHF:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 2/3] jump label: move jump table to r/w section
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jason Baron <jbaron@redhat.com>, mingo@elte.hu, peterz@infradead.org,
        hpa@zytor.com, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
In-Reply-To: <1290565133.30543.430.camel@gandalf.stny.rr.com>
References: <cover.1290546539.git.jbaron@redhat.com>
	 <bbc34a86a4cf4addcde1b85d7fa7faecc0966c03.1290546539.git.jbaron@redhat.com>
	 <20101123235519.GB21549@Krystal>
	 <1290565133.30543.430.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 23 Nov 2010 21:59:53 -0500
Message-ID: <1290567593.30543.436.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Calling attention to David Miller ]

On Tue, 2010-11-23 at 21:18 -0500, Steven Rostedt wrote:
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
> > 
> 
> Looking at this we have much bigger issues. That alignment to the
> structure wont do anything but break things. This is because the
> structure is not used in assigning that section. It's done in assembly:
> 
> # define JUMP_LABEL(key, label)					\
> 	do {							\
> 		asm goto("1:"					\
> 			JUMP_LABEL_INITIAL_NOP			\
> 			".pushsection __jump_table,  \"a\" \n\t"\
> 			_ASM_PTR "1b, %l[" #label "], %c0 \n\t" \
> 			".popsection \n\t"			\
> 			: :  "i" (key) :  : label);		\
> 	} while (0)
> 
> 
> 
> That __ASM_PTR "1b, %l[" #label "], %c0 \n\t" is assigning the section
> the address of label 1, the address of the label #label, and the key.
> 
> We either need to fix this by allocating an array of jump_entrys and
> having each arch copy the data into it, or we need to do something
> similar to exception tables.

Talking with Mathieu about this, we may have the simple solution of
adding the packed attribute to all arch declarations of struct
jump_entry, and that should fix it. And having this on an 8 byte
alignment should be fine.

I just want to make sure this is fine with sparc, as it is one of the
more exotic archs.

-- Steve



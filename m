Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714Ab1CJTyc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 14:54:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751664Ab1CJTyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 14:54:31 -0500
Date: Thu, 10 Mar 2011 14:53:44 -0500
From: Jason Baron <jbaron@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: David Daney <ddaney@caviumnetworks.com>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, peterz@infradead.org,
        hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, michael@ellerman.id.au, linux-kernel@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH 0/2] jump label: update for .39
Message-ID: <20110310195343.GA4058@redhat.com>
References: <1299771504.15854.347.camel@gandalf.stny.rr.com>
 <4D790A13.4060705@caviumnetworks.com>
 <1299780241.15854.393.camel@gandalf.stny.rr.com>
 <20110310182000.GB2906@redhat.com>
 <1299782143.15854.402.camel@gandalf.stny.rr.com>
 <4D791CAA.7090108@caviumnetworks.com>
 <1299783236.15854.405.camel@gandalf.stny.rr.com>
 <4D791F31.6040100@caviumnetworks.com>
 <1299785143.15854.407.camel@gandalf.stny.rr.com>
 <1299786329.15854.409.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299786329.15854.409.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 02:45:29PM -0500, Steven Rostedt wrote:
> On Thu, 2011-03-10 at 14:25 -0500, Steven Rostedt wrote:
> > On Thu, 2011-03-10 at 10:57 -0800, David Daney wrote:
> > > On 03/10/2011 10:53 AM, Steven Rostedt wrote:
> > > > On Thu, 2011-03-10 at 10:47 -0800, David Daney wrote:
> > > >
> > > >> The alignment requested by the assembler will have to satisfy *all* the
> > > >> requested alignments, so manually forcing everything to .align 8 (or
> > > >> .align 4 for 32-bit) should ensure that the linker doesn't put in any holes.
> > > >
> > > > I would agree with the assessment although, I don't know that it is
> > > > documented anywhere that this is what happens. As the previous "bug"
> > > > with the trace_events was solved by me adding .align(4) everywhere, I
> > > > would think that .align(sizeof(long)) would work here too.
> > > >
> > > > It may be a good ideal to force this alignment, and not add wasted
> > > > space. If anything, if this (hypothetical) bug appears, it will most
> > > > likely show up as a crash on boot up. I'm not too concerned about it.
> > > >
> > > 
> > > If the linker put in gratuitous holes, things like  __ex_table would 
> > > break too.
> > 
> > Again, as I have said (although I said extable not __ex_table), there
> > seems to be no problem when the data is of a power of 2 as well. As
> > __ex_table size is a power of 2. We just don't know if the linker will
> > add holes when the size is something other than power of 2.
> 
> Anyway, I think the best thing for now is to have Jason add
> the .align(sizeof(long)) in the inline assembly for all locations and be
> done with it.
> 

agreed. something like the following is all that's needed for x86. Sparc
already has this, so mips just needs something similar. Steve, should I
re-post the entire series. Or can I just post this patch separately?

thanks,

-Jason


diff --git a/arch/x86/include/asm/jump_label.h b/arch/x86/include/asm/jump_label.h
index f217cee..57f31ff 100644
--- a/arch/x86/include/asm/jump_label.h
+++ b/arch/x86/include/asm/jump_label.h
@@ -8,6 +8,7 @@
 #include <asm/asm.h>
 
 #define JUMP_LABEL_NOP_SIZE 5
+#define BYTES_PER_LONG (BITS_PER_LONG / 8)
 
 #define JUMP_LABEL_INITIAL_NOP ".byte 0xe9 \n\t .long 0\n\t"
 
@@ -16,9 +17,10 @@ static __always_inline bool arch_static_branch(struct jump_label_key *key)
 	asm goto("1:"
 		JUMP_LABEL_INITIAL_NOP
 		".pushsection __jump_table,  \"aw\" \n\t"
-		_ASM_PTR "1b, %l[l_yes], %c0 \n\t"
+		".align %c0\n\t"
+		_ASM_PTR "1b, %l[l_yes], %c1 \n\t"
 		".popsection \n\t"
-		: :  "i" (key) : : l_yes);
+		: : "i" BYTES_PER_LONG, "i" (key) : : l_yes);
 	return false;
 l_yes:
 	return true;

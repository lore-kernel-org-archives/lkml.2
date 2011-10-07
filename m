Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab1JGT62 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 15:58:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:50313 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab1JGT6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 15:58:23 -0400
X-Authority-Analysis: v=1.1 cv=agqPq5NoKwAPC9P66H7dbYUCjxvmT73as08i4x3aqAA= c=1 sm=0 a=gxfjmhR6zbwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=S-x86ON2MK9qNWMveHkA:9 a=8jbVAO-12CBWOFvf65MA:7 a=PUjeQqilurYA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [PATCH][RFC] jump_labels/x86: Use either 5 byte or 2 byte jumps
From: Steven Rostedt <rostedt@goodmis.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Richard Henderson <rth@redhat.com>, Jason Baron <jbaron@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "David S. Miller" <davem@davemloft.net>,
        David Daney <david.daney@cavium.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Jan Glauber <jang@linux.vnet.ibm.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        peterz@infradead.org
Date: Fri, 07 Oct 2011 15:58:20 -0400
In-Reply-To: <4E8F55B7.9010409@goop.org>
References: <cover.1317506051.git.jeremy.fitzhardinge@citrix.com>
	  <477dead9647029012f93c651f2892ed0e86b89e7.1317506051.git.jeremy.fitzhardinge@citrix.com>
	  <20111003150205.GB2462@redhat.com> <4E89E28C.7010700@goop.org>
	  <20111004141011.GA2520@redhat.com> <4E8B3489.60902@zytor.com>
	  <4E8CF348.4080405@goop.org> <4E8CF385.2080804@zytor.com>
	  <4E8DEB19.1050509@goop.org> <20111006181055.GA2505@redhat.com>
	  <1317925615.4729.14.camel@gandalf.stny.rr.com>
	  <4E8DF870.6010000@redhat.com>
	  <1317929321.4729.17.camel@gandalf.stny.rr.com> <4E8E20CD.5030207@goop.org>
	  <1317938775.4729.29.camel@gandalf.stny.rr.com> <4E8E275F.6010801@goop.org>
	 <1318007374.4729.58.camel@gandalf.stny.rr.com> <4E8F55B7.9010409@goop.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1318017501.4729.78.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-07 at 12:40 -0700, Jeremy Fitzhardinge wrote:
> On 10/07/2011 10:09 AM, Steven Rostedt wrote:
> > diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
> > index 3fee346..1f7f88f 100644
> > --- a/arch/x86/kernel/jump_label.c
> > +++ b/arch/x86/kernel/jump_label.c
> > @@ -16,34 +16,75 @@
> >  
> >  #ifdef HAVE_JUMP_LABEL
> >  
> > +static unsigned char nop_short[] = { P6_NOP2 };
> > +
> >  union jump_code_union {
> >  	char code[JUMP_LABEL_NOP_SIZE];
> >  	struct {
> >  		char jump;
> >  		int offset;
> >  	} __attribute__((packed));
> > +	struct {
> > +		char jump_short;
> > +		char offset_short;
> > +	} __attribute__((packed));
> >  };
> >  
> >  void arch_jump_label_transform(struct jump_entry *entry,
> >  			       enum jump_label_type type)
> >  {
> >  	union jump_code_union code;
> > +	unsigned char op;
> > +	unsigned size;
> > +	unsigned char nop;
> > +
> > +	/* Use probe_kernel_read()? */
> > +	op = *(unsigned char *)entry->code;
> > +	nop = ideal_nops[NOP_ATOMIC5][0];
> >  
> >  	if (type == JUMP_LABEL_ENABLE) {
> > -		code.jump = 0xe9;
> > -		code.offset = entry->target -
> > -				(entry->code + JUMP_LABEL_NOP_SIZE);
> > -	} else
> > -		memcpy(&code, ideal_nops[NOP_ATOMIC5], JUMP_LABEL_NOP_SIZE);
> > +		if (op == 0xe9 || op == 0xeb)
> > +			/* Already enabled. Warn? */
> > +			return;
> > +
> > +		/* FIXME for all archs */
> 
> By "archs", do you mean different x86 variants?

Yeah, that was a confusing use of archs. This was to make sure it works
for all nops for different variants of x86.

> 
> > +		if (op == nop_short[0]) {
> 
> My gut feeling is that all this "trying to determine the jump size by
> sniffing the instruction" stuff seems pretty fragile.  Couldn't you
> store the jump size in the jump_label structure (even as a bit hidden
> away somewhere)?

We could but it's not as fragile as you think. This is machine code, and
it should be a jump or not. I could add more checks, that is, to look at
the full nop to make sure it is truly a nop. But for the jump side, a
byte instruction that starts with e9 is definitely a jump.

I could harden this more like what we do with mcount updates in the
function tracer. I actually calculate what I expect to be there before
looking at what is there. The entire instruction is checked. If it does
not match, then we fail and give big warnings about it.

Other than that, it should be quite solid. If we don't get a match, we
should warn and disable jump labels.

No BUG()!

-- Steve



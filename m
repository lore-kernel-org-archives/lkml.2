Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134Ab0IHBos (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 21:44:48 -0400
Received: from ozlabs.org ([203.10.76.45]:58771 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756029Ab0IHBoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 21:44:46 -0400
Date: Wed, 8 Sep 2010 11:44:09 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Tom Zanussi <tzanussi@gmail.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-perf-users@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: disabling group leader perf_event
Message-ID: <20100908014409.GA17010@brick.ozlabs.ibm.com>
References: <4C84D1CE.3070205@redhat.com>
 <1283774045.1930.341.camel@laptop>
 <4C84D77B.6040600@redhat.com>
 <20100906124330.GA22314@elte.hu>
 <4C84E265.1020402@redhat.com>
 <20100906125905.GA25414@elte.hu>
 <4C850147.8010908@redhat.com>
 <20100906154737.GA4332@elte.hu>
 <4C852B2A.2030103@redhat.com>
 <20100907034417.GA14046@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100907034417.GA14046@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 07, 2010 at 05:44:17AM +0200, Ingo Molnar wrote:

> No, it's machine code. It's 'safe x86 bytecode executed natively by the 
> kernel as a function'.

I'm curious - how are you going to prove that addresses for the MOV
instruction are safe, using just a static pre-execution scan of the
code?  If you only allow things that you can prove are safe, then
either you'll have a very large and complex verifier, or you'll end up
disallowing interesting and useful cases.

The other alternative is to do runtime verification of addressses,
which is much more straightforward (and it's also much easier to prove
it's secure).  But it does mean that you can't run the code as-is.

> It needs a verification pass (because the code can come from untrusted 
> apps) so that we can copy, verify and trust it (so obviously it's not 
> _arbitrary_ x86 machine code - a safe subset of x86) - maybe with a sha1 
> based cache for already-verified snippets (or a fast verifier).
> 
> > x86 is quite unpleasant.
> 
> Any machine code that is fast and compact is unpleasant almost by 
> definition: it's a rather non-obvious Huffman encoding embedded in an 
> instruction architecture.

>From the point of view of having to emulate or translate x86 code (as
we would have to do on powerpc), it's not the compactness that's
unpleasant, it's things like not being able to tell whether the
condition codes set by an instruction are ever going to be used.  Many
x86 instructions set the condition codes but for most instructions the
condition codes that are set are never used.  So when emulating or
translating, you either waste time computing condition code values
that are never used, or you have to do complex lifetime analysis to
work out which instructions do need to compute the condition codes.

> We start with trivial (and useless) special case of something like:
> 
> #define MAX_BYTECODE_SIZE 256
> 
> int x86_bytecode_verify(char *opcodes, unsigned int len)
> {
> 
> 	if (len-1 > MAX_BYTECODE_SIZE-1)
> 		return -EINVAL;
> 
> 	if (opcodes[0] != 0xc3) /* RET instruction */
> 		return -EINVAL;
> 
> 	return 0;
> }
> 
> ... and then we add checks for accepted/safe x86 patterns of 
> instructions step by step - always keeping it 100% correct.

So... I would be interested to see you add the case for the MOV
instruction. :)

Paul.

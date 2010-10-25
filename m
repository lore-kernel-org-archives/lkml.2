Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251Ab0JYOnX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 10:43:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40750 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755849Ab0JYOnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 10:43:20 -0400
Date: Mon, 25 Oct 2010 16:43:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <JBeulich@novell.com>
Cc: akpm@linux-foundation.org, torvalds@osdl.org,
        David Howells <dhowells@redhat.com>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Partially revert patch that encloses asm-offset.h
 numbers in brackets
Message-ID: <20101025144303.GB13310@elte.hu>
References: <20101025140218.5092.74117.stgit@warthog.procyon.org.uk>
 <4CC5B1A1020000780001EF7C@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC5B1A1020000780001EF7C@vpn.id2.novell.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <JBeulich@novell.com> wrote:

> >>> On 25.10.10 at 16:02, David Howells <dhowells@redhat.com> wrote:
> > Partially revert patch:
> > 
> > 	commit 3234282f33b29d349bcada40204fc7c8fda7fe72
> > 	Author: Jan Beulich <JBeulich@novell.com>
> > 	Date:   Tue Oct 19 14:52:26 2010 +0100
> > 	x86, asm: Fix CFI macro invocations to deal with shortcomings in gas
> 
> No, that's not going to work for x86. You're removing the parentheses again, which 
> were added intentionally.

But that's not a valid argument - MN10300 worked before and we broke it => that's a 
regression.

> > This breaks MN10300 arch as this changes many instances of instructions similar 
> > to the following:
> > 
> > 	MOV	number,D0
> > 
> > which represents an immediate value load into:
> > 
> > 	MOV	(number),D0
> > 
> > which the assembler then interprets as a load from absolute address.
> > 
> > arch/mn10300/kernel/entry.S:64: Error: Invalid opcode/operands
> > arch/mn10300/kernel/entry.S:65: Error: junk at end of line, first 
> > unrecognized character is `0'
> > arch/mn10300/kernel/entry.S:74: Error: Invalid opcode/operands
> > arch/mn10300/kernel/entry.S:74: Error: junk at end of line, first 
> > unrecognized character is `1'
> > arch/mn10300/kernel/entry.S:75: Error: Invalid opcode/operands
> > arch/mn10300/kernel/entry.S:76: Error: junk at end of line, first 
> > unrecognized character is `0'
> 
> Isn't this a gas bug then? Anywhere you use a plain number you should also be 
> permitted to use an expression.

This argument is not valid either - we added this change to fix a GAS bug to begin 
with ...

> >  	"/^->/{s:->#\(.*\):/* \1 */:; \
> > -	s:^->\([^ ]*\) [\$$#]*\([-0-9]*\) \(.*\):#define \1 (\2) /* \3 */:; \
> > +	s:^->\([^ ]*\) [\$$#]*\([-0-9]*\) \(.*\):#define \1 \2 /* \3 */:; \
> 
> This basically gets us back to the way things were before, thus
> reverting to the state we had before the patch that changed this.

Correct - we should apply David's partial revert and then we'll need to solve our 
x86 quirk differently: for example by using a x86 and broken-GAS specific quirk.

Thanks,

	Ingo

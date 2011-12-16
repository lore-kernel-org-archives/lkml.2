Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758882Ab1LPKWW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 05:22:22 -0500
Received: from casper.infradead.org ([85.118.1.10]:60654 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab1LPKWO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 05:22:14 -0500
Message-ID: <1324030817.18942.76.camel@twins>
Subject: Re: [PATCH] x86: Use -m-omit-leaf-frame-pointer to shrink text size
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Beulich <JBeulich@suse.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, rth <rth@redhat.com>
Date: Fri, 16 Dec 2011 11:20:17 +0100
In-Reply-To: <4EEB0E14.9050505@goop.org>
References: <20111216081915.GA28288@elte.hu> <20111216085259.GA2338@elte.hu>
	 <4EEB0E14.9050505@goop.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-16 at 01:23 -0800, Jeremy Fitzhardinge wrote:
> On 12/16/2011 12:53 AM, Ingo Molnar wrote:
> > * Ingo Molnar <mingo@elte.hu> wrote:
> >
> >> [...]
> >>
> >> The call-chains are still intact for quality backtraces and 
> >> for call-chain profiling (perf record -g), as the backtrace 
> >> walker can deduct the full backtrace from the RIP of a leaf 
> >> function and the parent chain.
> > Hm, noticed one complication while looking at annotated assembly 
> > code in perf top. Code doing function calls from within asm() is 
> > incorrectly marked 'leaf' by GCC:
> >
> > ffffffff812b82d8 <arch_local_save_flags>:
> > ffffffff812b82d8:       ff 14 25 00 d9 c1 81    callq  *0xffffffff81c1d900
> > ffffffff812b82df:       c3                      retq   
> >
> > So all the paravirt details will have to be fixed, so that GCC 
> > is able to see that there's a real function call done inside. 
> > Jeremy, Konrad?
> 
> Um.  So the issue is that a function that contains only pvops looks like
> it's a leaf to gcc and it does some leaf-function optimisation?
> 
> How can we tell gcc the asm contains a call, or otherwise suppress the
> "leaf function" classification?
> 
> The alternative is to just make it a plain C-level indirect call, but
> then we'd lose all the patching and callee-save optimisations.
> 
> Any suggestions?

Added Richard Henderson to CC.

I only found the function __attribute__((leaf)) to explicitly mark a
function as being a leaf function, but the documentation doesn't list
the inverse of that to explicitly mark it as _not_ being one.

I haven't done a git grep on the gcc sources yet since I seem to have
misplaced my gcc.git tree.



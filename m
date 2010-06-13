Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753Ab0FMNea (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 09:34:30 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:56698 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410Ab0FMNe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 09:34:29 -0400
Date: Sun, 13 Jun 2010 14:34:27 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Peter Zijlstra <peterz@infradead.org>
cc: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [Q] Perf-events callchain support on MIPS
In-Reply-To: <1275903505.1645.549.camel@laptop>
Message-ID: <alpine.LFD.2.00.1006131351310.20820@eddie.linux-mips.org>
References: <AANLkTikb5jAw_fSQ08IMrzwKK7lfafXlm63S46F-C8m0@mail.gmail.com> <1275903505.1645.549.camel@laptop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jun 2010, Peter Zijlstra wrote:

> > For MIPS, recording user stack backtrace in the kernel is not quite as easy
> > as on other platforms. Because In the kernel, we don't have frame unwinder
> > to work on the user stack. Given the different possible compiler flags,
> > getting the backtrace for the user stack is especially challenging.
> > 
> > So, is it still useful to implement the Perf-events callchain support on
> > MIPS with only kernel addresses recorded for now? What impact do you see to
> > do so? Only that the user can not see user-level performance bottleneck?
> 
> Note that on x86 we rely on framepointers (a compiler option) for both
> kernel and user unwinds. If you compile either without, you will not
> obtain callchains for that particular section.
> 
> So yeah, we already have something similar to that on x86 since most
> distros don't actually build their userspace with framepointers enabled
> (although on x86_64 they really should).
> 
> Just provide as much information as you can, if/when you find a way to
> provide userspace callchains you can always add that later.

 Building with the frame-pointer register ($fp) enabled (i.e. using the 
-fno-omit-frame-pointer GCC option) makes no difference for MIPS systems, 
because you still do not know where in a given stack frame the previous 
value of $fp has been stored (there's no difference in value between $sp 
and $fp for a given frame anyway unless stuff like alloca() has been used; 
GCC makes use of $fp unconditionally in this case).

 To retrieve this value (or any other one, such as the return address, 
$ra) you need to have access to either debug information (generally 
DWARF-2 records) or at least the symbol table (to analyse machine 
instructions in the function's prologue) to figure out where each of the 
saved register slots has been placed in the frame.  Such information is 
generally only available from the ELF binary executed if at all (as it may 
have been stripped).

 For the record -- libgcc's exception frame unwinder relies on the 
presence of DWARF-2 records on the MIPS platform.  GDB is smarter and in 
the absence of DWARF-2 records it can do all the kinds of hairy processing 
including heuristic decoding of function prologues to figure out the 
layout of the associated stack frame.  It relies on known instruction 
opcodes expected to be seen there -- if anything else is present, such as 
handcoded in an assembly language function or as a result of GCC's 
optimiser getting smarter, then the analysis will fail.

 This is the kind of processing that should really be done in the 
userland, where all the facilities are available.  What's the point of 
placing it in the kernel?

  Maciej

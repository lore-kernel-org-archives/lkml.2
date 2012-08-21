Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758037Ab2HURC3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 13:02:29 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60515 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757982Ab2HURCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 13:02:22 -0400
Date: Tue, 21 Aug 2012 19:02:16 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        JBeulich@suse.com, akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        hubicka@ucw.cz
Subject: Re: RFC: Link Time Optimization support for the kernel
Message-ID: <20120821170216.GM16230@one.firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org> <20120820074835.GA6710@gmail.com> <20120820101044.GE16230@one.firstfloor.org> <20120821074921.GA10809@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120821074921.GA10809@gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The other hope would be that if LTO is used by a high-profile 
> project like the Linux kernel then the compiler folks might look 
> at it and improve it.

Yes definitely.  I already got lot of help from toolchain people.

> 
> > A lot of the overhead on the larger builds is also some 
> > specific gcc code that I'm working with the gcc developers on 
> > to improve. So the 4x extreme case will hopefully go down.
> > 
> > The large builds also currently suffer from too much memory 
> > consumption. That will hopefully improve too, as gcc improves.
> 
> Are there any LTO build files left around, blowing up the size 
> of the build tree?

The objdir size increases from the immediate information in the objects,
even though it's compressed.  A typical LTO objdir is about 2.5x 
as big as non LTO.

[this will go down a bit with slim LTO; right now there is an unnecessary
copy of the non LTOed code too; but I expect it will still be
significantly larger]

There's also the TMPDIR problem. If you put /tmp in tmpfs and gcc
defaults to put the immediate files during the final link into 
/tmp the memory fills up even faster, because tmpfs is competing
with anonymous memory.

4.7 improved a lot over 4.6 for this with better partitioning; with 4.6 I 
had some spectacular OOMst. 4.6 is not supported for LTO anymore now,
with 4.7 it became much better.

I also hope tmpfs will get better algorithms eventually that make
this less likely.

Anyways this can be overriden by setting TMPDIR to the object directory.
With TMPDIR set and not too aggressive -j* for most kernels you should
be ok with 4GB of memory. Just allyes still suffers.

This was one of the reasons why I made it not default for allyesconfig.


> > so we'll hopefully see more gains over time. Essentially it 
> > gives more power to the compiler.
> > 
> > Long term it would also help the kernel source organization. 
> > For example there's no reason with LTO to have gigantic 
> > includes with large inlines, because cross file inlining works 
> > in a efficient way without reparsing.
> 
> Can the current implementation of LTO optimize to the level of 
> inlining? A lot of our include file hell situation results from 

Yes, it does cross file inlining. Maybe a bit too much even
(Currently there are about 40% less static CALLs when LTOed)
In fact some of the current workarounds limit it, so there may be
even more in the future.

One side effect is that backtraces are harder to read. You'll
need to rely more on addr2line than before (or we may need
to make kallsyms smarter)

It only inlines inside a final binary though, as Avi mentioned,
so it's more useful inside a subsystem for modular kernels.


> If data structures could be encapsulated/internalized to 
> subsystems and only global functions are exposed to other 
> subsystems [which are then LTO optimized] then our include
> file dependencies could become a *lot* simpler.

Yes, long term we could have these benefits.

BTW I should add LTO does more than just inlining:
- Drop unused global functions and variables
  (so may cut down on ifdefs)
- Detect type inconsistencies between files
- Partial inlining (inline only parts of a function like a test
  at the beginning)
- Detect pure and const functions without side effects that can be more 
  aggressively optimized in the caller.
- Detect global clobbers globally. Normally any global call has to 
  assume all global variables could be changed.  With LTO information some
  of them can be cached in registers over calls.
- Detect read only variables and optimize them
- Optimize arguments to global functions (drop unnecessary arguments, 
  optimize input/output etc.)
- Replace indirect calls with direct calls, enabling other
  optimizations.
- Do constant propagation and specialization for functions. So if a
  function is called commonly with a constant it can generate a special 
  variant of this function optimized for that.  This still needs more tuning (and
  currently the code size impact is on the largish side), but I hope
  to eventually have e.g. a special kmalloc optimized for GFP_KERNEL. 
  It can also in principle inline callbacks.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.

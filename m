Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419Ab2HVMfR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 08:35:17 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33017 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932387Ab2HVMfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 08:35:13 -0400
Date: Wed, 22 Aug 2012 14:35:07 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        JBeulich@suse.com, akpm@linux-foundation.org
Subject: Re: RFC: Link Time Optimization support for the kernel
Message-ID: <20120822123507.GO16230@one.firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org> <201208220858.03227.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208220858.03227.arnd@arndb.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 08:58:02AM +0000, Arnd Bergmann wrote:
> * Debuggability: When we get more aggressive optimizations, it
> often becomes harder to trace back object code to a specific source
> line, which may be a reason for distros not to enable it for their
> product kernels in the end because it can make the work of their
> support teams harder.

Yes, that's a potential issue with the larger functions. People looking
at oopses may need to rely more on addr2line with debug info. It's probably 
less an issue for distributions (who should have debug info for their kernels
and may even use crash instead of only oops logs), but more for random reports 
on linux-kernel.

That said for the few LTO crashes I looked at it wasn't that big an issue.
Usually the inline chains are still broken up by indirect calls, and 
a lot of kernel paths have that, so all the backtraces I could make
sense of without debug info.

> * Stack consumption: If you do more inlining, the total stack usage
> of large functions can become higher than what the deepest path through
> the same code in the non-inlined version would be. This bites us
> more in the kernel than in user applications, which have much more
> stack space available.

Newer gcc has a heuristic to not inline when the stack frame gets too
large. We set that option. Also there's a warning for too large
stack frames. With these two together we should be pretty safe.

iirc the warning mostly showed up in some staging drivers which were likely
already too large on their own. I haven't hunted for it explicitely,
but I don't remember seeing it much in other places. Also it was alwas
still in a range that does not necessarily crash.

> Have you noticed problems with either of these so far? Do you think
> they are realistic concerns or is the LTO implementation good enough
> that they would rarely become an issue?

I think the first is a realistic possible concern, but I personally haven't
had much trouble with it so far.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

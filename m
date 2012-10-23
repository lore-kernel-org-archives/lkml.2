Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927Ab2JWVqp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 17:46:45 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:34651 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736Ab2JWVqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 17:46:44 -0400
Date: Wed, 24 Oct 2012 01:46:39 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pavel Emelyanov <xemul@parallels.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [rfc 0/2] Introducing VmFlags field into smaps output
Message-ID: <20121023214639.GM7020@moon>
References: <20121022122934.d2e2fa57.akpm@linux-foundation.org>
 <5085B1A8.4020609@parallels.com>
 <20121022205641.GL2303@moon>
 <20121022213449.GH31440@moon>
 <20121022145158.53bddfc1.akpm@linux-foundation.org>
 <20121023061341.GA7020@moon>
 <20121022233025.09ec2d92.akpm@linux-foundation.org>
 <20121023063430.GB7020@moon>
 <20121023071549.GC7020@moon>
 <20121023143045.183657c4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121023143045.183657c4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 02:30:45PM -0700, Andrew Morton wrote:
> > 
> > The data is encoded in a somewhat awkward two letters mnemonic form, to
> > encourage userspace to be prepared for fields being added or removed in
> > the future.
> > 
> 
> Wow.  This version generates 1k less kernel bloat than v2!  Gee, and I
> only sent that email as a late-night joke ;)

Cool!

> fs/proc/task_mmu.o with neither patch:
>    text    data     bss     dec     hex filename
>   14849     112    5312   20273    4f31 fs/proc/task_mmu.o
> 
> fs/proc/task_mmu.o with the v2 patch:
>   16074     112    5776   21962    55ca fs/proc/task_mmu.o
> 
> fs/proc/task_mmu.o with the v3 patch:
>   15446     112    5368   20926    51be fs/proc/task_mmu.o
> 
> fs/proc/task_mmu.o with the v3 patch and the below fix:
>   15123     112    5352   20587    506b fs/proc/task_mmu.o
> 
> So the delta has gone from 1700 bytes down to 300.  Seems that it pays
> to be anal about these things ;)

LOL ;-)

> Don't forget the `static'!  Without it, the compiler will need to

Yeah, for some reason missed it, thanks!

> construct the array as a temporary on the stack each time the function
> is called - it's just terrible.  (There's no reason why the compiler
> can't insert the static for us as an optimisation, and I think later
> gcc's may have got smarter about this).
> 
> Was there a reason why you added the ".l = " to the initialiser?  My
> gcc is happy without it.

Mine either, just as habbit I would say, thanks.

> Also...  what happens if there's an unrecognised bit set in `flags'? 
> Memory corruption or code skew could cause this.  We emit a couple of
> NULs into the procfs output, which I guess is an OK response to such a
> condition.

That's indeed will produce some nil character on the screen. I guess we
need some designited init here, say

	[0 ... (BITS_PER_LONG-1)] = { {'-', '-'} },
	...
	[ilog2(VM_READ)]	= { {'r', 'd'} },
	...
	and so on, i'll update on top

> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: procfs-add-vmflags-field-in-smaps-output-v3-fix
> 
> make mnemonics[] static, remove unneeded init code, tidy whitespace
> 

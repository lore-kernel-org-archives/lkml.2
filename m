Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924Ab2HSPS2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 11:18:28 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58351 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747Ab2HSPS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 11:18:26 -0400
Date: Sun, 19 Aug 2012 17:18:25 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jan Beulich <jbeulich@suse.com>
Cc: andi@firstfloor.org, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        x86@kernel.org, akpm@linux-foundation.org, mmarek@suse.cz,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 48/74] x86, lto: Use inline assembler instead of global register variable to get sp
Message-ID: <20120819151825.GT11413@one.firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org> <1345345030-22211-49-git-send-email-andi@firstfloor.org> <5030B3D7020000780008A217@nat28.tlf.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5030B3D7020000780008A217@nat28.tlf.novell.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 19, 2012 at 09:37:27AM +0100, Jan Beulich wrote:
> >>> Andi Kleen <andi@firstfloor.org> 08/19/12 4:59 AM >>>
> >I verified this generates the same binary (on 64bit) as the original
> >register variable.
> 
> This isn't very surprising given that the modified code is inside a
> CONFIG_X86_32 conditional (as ought to be obvious from the code using
> %%esp). Given that it's being used as operand to a binary &, the resulting
> code - if the compiler handles this only half way sensibly - can hardly be
> expected to be identical.

Doh! Thanks. I'll double check.

You're right it'll likely change code. But it shouldn't be common.

> 
> >-register unsigned long current_stack_pointer asm("esp") __used;
> >+#define current_stack_pointer ({         \
> >+    unsigned long sp;            \
> >+    asm("mov %%esp,%0" : "=r" (sp));    \
> >+    sp;                    \
> >+})
>  
> It would get closer to the original if you used "=g" (I noticed in a few
> earlier patches already that you like to use "=r" in places where a register
> is not strictly required, thus reducing the flexibility the compiler has).

My fingers have =r hardcoded. Will fix.

> 
> Also, given that this is more a workaround for a compiler deficiency,
> shouldn't this be conditional upon use of LTO?

I think it's cleaner than the global reg var, so unconditional should 
be fine. It wouldn't surprise me if global reg causes trouble even
without LTO, i probably just triggered some latent bug.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

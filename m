Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932892Ab0EZQta (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 12:49:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40839 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755381Ab0EZQt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 12:49:29 -0400
Date: Wed, 26 May 2010 09:46:11 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Joakim Tjernlund <joakim.tjernlund@transmode.se>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: build warning in Linus'tree
In-Reply-To: <OF6B2D521C.109F3133-ONC125772F.00576DF0-C125772F.005B18F3@transmode.se>
Message-ID: <alpine.LFD.2.00.1005260939030.3689@i5.linux-foundation.org>
References: <20100526110506.f2f4f22c.sfr@canb.auug.org.au> <20100525182040.f1882d0a.akpm@linux-foundation.org> <20100526140900.5b091c16.sfr@canb.auug.org.au> <OFC00BDFAC.5596A841-ONC125772F.0022984D-C125772F.0023AF14@transmode.se>
 <20100525234116.71889c71.akpm@linux-foundation.org> <20100526171424.447fac18.sfr@canb.auug.org.au> <OFE5212A1C.B62E8E51-ONC125772F.00371EE7-C125772F.0038EEC8@transmode.se> <alpine.LFD.2.00.1005260828320.3689@i5.linux-foundation.org>
 <OF6B2D521C.109F3133-ONC125772F.00576DF0-C125772F.005B18F3@transmode.se>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 26 May 2010, Joakim Tjernlund wrote:
> 
> 1) It silently breaks when neither of {__LITTLE_,__BIG}_ENDIAN (or both)are
>    defined depending on the endianess of the target CPU.
>    The glibc model generates a compile error if you forget to include __BYTE_ORDER.

Umm. Except when it doesn't (yes, Linux has the "Wundefined" thing, and 
has had for a long time). I've seen the glibc model do the wrong thing 
exactly because traditional C semantics is "undefined symbol is 0 in 
evaluations"

Try compiling this

	#include <stdio.h>

	#if NOT_HERE == NOT_THERE
	int main()
	{
		printf("Hello world!\n");
	}
	#endif

and even with -Wall it compiles perfectly happily.

So no. The glibc model is _not_ any better in practice.

> 2) It clashes with user space so one cannot use it in exported header files.

Which is annoying, I agree. But you shouldn't generally use kernel headers 
for user space anyway, much less export anything that is byteorder- 
specific. So anybody who has this problem is likely doing something iffy 
to begin with.

Besides, you can solve it cleanly by simply avoiding the crazy glibc 
semantics entirely. IOW, the CONFIG_BIG_ENDIAN option I suggested (and 
again, you should damn well not export things that depend on it to user 
space - there are architectures where user-space might be switchable)

			Linus

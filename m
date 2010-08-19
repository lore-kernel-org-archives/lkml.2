Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757Ab0HSVcl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 17:32:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47463 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753711Ab0HSVcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 17:32:39 -0400
Date: Thu, 19 Aug 2010 14:31:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Russell King <rmk@arm.linux.org.uk>,
        David Howells <dhowells@redhat.com>,
        Ralf Baechle <ralf@linux-mips.org>, David Miller <davem@davemloft.net>,
        Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-arch@vger.kernel.org
Subject: Re: [RFC][PATCH 0/6] mm, highmem: kmap_atomic rework
Message-Id: <20100819143129.81274c03.akpm@linux-foundation.org>
In-Reply-To: <20100819201317.673172547@chello.nl>
References: <20100819201317.673172547@chello.nl>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Aug 2010 22:13:17 +0200
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> 
> This patch-set reworks the kmap_atomic API to be a stack based, instead of
> static slot based. Some might remember this from last year, some not ;-)
> 
> The advantage is that you no longer need to worry about KM_foo, the
> disadvantage is that kmap_atomic/kunmap_atomic now needs to be strictly
> nested (CONFIG_HIGHMEM_DEBUG should complain in case its not) -- and of
> course its a big massive patch changing a widely used API.

Nice.  That fixes the "use of irq-only slots from interrupts-on
context" bugs which people keep adding.

We don't have any checks in there for the stack overflowing?

Did you add every runtime check you could possibly think of? 
kmap_atomic_idx_push() and pop() don't have much in there.  It'd be
good to lard it up with runtime checks for at least a few weeks.

> The patch-set is currently based on tip/master as of today, and compile
> tested on: i386-all{mod,yes}config, mips-yosemite_defconfig,
> sparc-sparc32_defconfig, powerpc-ppc6xx_defconfig, and some arm config.
> 
> (Sorry dhowells, I again couldn't find frv/mn10300 compilers)
> 
> Boot tested with i386-defconfig on kvm.
> 
> Since its a rather large set, and somewhat tedious to rebase, I wanted to
> ask how to go about getting this merged?


Well, there's that monster conversion patch.  How's about you
temporarily do

#define kmap_atomic(x, arg...)  __kmap_atomic(x)

so for a while, both kmap_atomic(a, KM_foo) and kmap_atomic(a) are
turned into __kmap_atomic(a).  Once all the dust has settled, pull that
out again?

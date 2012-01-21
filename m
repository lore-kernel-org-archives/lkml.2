Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab2AUI3V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 03:29:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50858 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109Ab2AUI3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 03:29:20 -0500
Date: Sat, 21 Jan 2012 09:28:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Hitoshi Mitake <h.mitake@gmail.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Roland Dreier <roland@purestorage.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hitoshi Mitake <h.mitake@gmail.com>,
        James Bottomley <James.Bottomley@parallels.com>,
        linux-kernel@vger.kernel.org, linux-nvme@infradead.org,
        hpa@linux.intel.com
Subject: Re: [PATCH] NVMe: Fix compilation on architecturs without
 readq/writeq
Message-ID: <20120121082857.GC32134@elte.hu>
References: <1327021265-22184-1-git-send-email-matthew.r.wilcox@intel.com>
 <CA+55aFwmDbDm5+12Nc0wnu7J8dsOKW0tCd_tVf-3pwQOq9MF3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFwmDbDm5+12Nc0wnu7J8dsOKW0tCd_tVf-3pwQOq9MF3w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, Jan 19, 2012 at 5:01 PM, Matthew Wilcox
> <matthew.r.wilcox@intel.com> wrote:
> > The only places that uses readq/writeq are in the initialisation
> > path.  Since they're not performance critical, always use readl/writel.
> 
> The arch rules are that i fthe architecture has readq/writeq, they
> will be #define'd (they may be inline functions, but there will be a
> 
>   #define readq readq
> 
> to make it visible to the preprocessor as well).
> 
> So if you don't need the atomicity guarantees of a "real" readq, you
> can do this instead:
> 
>   #ifndef readq
>   static inline u64 readq(void __iomem *addr)
>   {
>         return readl(addr) | (((u64) readl(addr + 4)) << 32LL);
>   }
>   #endif
> 
> and then use readq() as if it existed.
> 
> And I do think we should expose this in some generic manner. Because
> we currently don't, we already have that pattern copied in quite a few
> drivers.
> 
> Maybe <asm-generic/io-nonatomic.h> or something? Making it 
> clear that its not atomic, but avoiding the silly duplication 
> we do now..
> 
> This whole mess was introduced in commit dbee8a0affd5 ("x86: 
> remove 32-bit versions of readq()/writeq()"), and it already 
> talked about the problems but didn't help with the drivers 
> that simply don't care.
> 
> All the people in those threads were doing their 
> self-satisfied "writeq is broken", without much acknowledging 
> that 99% of users simply don't seem to care.
> 
> "Occupy Writeq - We are the 99%"

Agreed, and offering a generic facility for silly duplication 
was the motivation of the original commit by Hitoshi Mitake.

This:

| The presense of a writeq() implementation on 32-bit x86 that 
| splits the 64-bit write into two 32-bit writes turns out to 
| break the mpt2sas driver (and in general is risky for drivers 
| as was discussed in
|   <http://lkml.kernel.org/r/adaab6c1h7c.fsf@cisco.com>).

is actually a mostly bogus statement and creates more problems 
than it solves.

Hitoshi-san, would you be interested in re-adding the generic 
readq/writeq definitions in a slight variation to 2c5643b1c5, to 
a separate io-nonatomic.h file, so that drivers that want it can
#include that file and be happy?
 
Thanks,

	Ingo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930Ab2ATBVz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 20:21:55 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55808 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541Ab2ATBVx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 20:21:53 -0500
MIME-Version: 1.0
In-Reply-To: <1327021265-22184-1-git-send-email-matthew.r.wilcox@intel.com>
References: <1327021265-22184-1-git-send-email-matthew.r.wilcox@intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 19 Jan 2012 17:21:31 -0800
X-Google-Sender-Auth: 5TBEhJBZZ4gx5pJLcfJGlWS7kjc
Message-ID: <CA+55aFwmDbDm5+12Nc0wnu7J8dsOKW0tCd_tVf-3pwQOq9MF3w@mail.gmail.com>
Subject: Re: [PATCH] NVMe: Fix compilation on architecturs without readq/writeq
To: Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Roland Dreier <roland@purestorage.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hitoshi Mitake <h.mitake@gmail.com>,
        James Bottomley <James.Bottomley@parallels.com>,
        Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, linux-nvme@infradead.org,
        hpa@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 5:01 PM, Matthew Wilcox
<matthew.r.wilcox@intel.com> wrote:
> The only places that uses readq/writeq are in the initialisation
> path.  Since they're not performance critical, always use readl/writel.

The arch rules are that i fthe architecture has readq/writeq, they
will be #define'd (they may be inline functions, but there will be a

  #define readq readq

to make it visible to the preprocessor as well).

So if you don't need the atomicity guarantees of a "real" readq, you
can do this instead:

  #ifndef readq
  static inline u64 readq(void __iomem *addr)
  {
        return readl(addr) | (((u64) readl(addr + 4)) << 32LL);
  }
  #endif

and then use readq() as if it existed.

And I do think we should expose this in some generic manner. Because
we currently don't, we already have that pattern copied in quite a few
drivers.

Maybe <asm-generic/io-nonatomic.h> or something? Making it clear that
its not atomic, but avoiding the silly duplication we do now..

This whole mess was introduced in commit dbee8a0affd5 ("x86: remove
32-bit versions of readq()/writeq()"), and it already talked about the
problems but didn't help with the drivers that simply don't care.

All the people in those threads were doing their self-satisfied
"writeq is broken", without much acknowledging that 99% of users
simply don't seem to care.

"Occupy Writeq - We are the 99%"

                Linus

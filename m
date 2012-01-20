Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342Ab2ATRwb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 12:52:31 -0500
Received: from mga03.intel.com ([143.182.124.21]:10114 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753889Ab2ATRw3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 12:52:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="58461661"
From: "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Roland Dreier <roland@purestorage.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hitoshi Mitake <h.mitake@gmail.com>,
        James Bottomley <James.Bottomley@parallels.com>,
        Ingo Molnar <mingo@elte.hu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-nvme@infradead.org" <linux-nvme@infradead.org>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>
Subject: RE: [PATCH] NVMe: Fix compilation on architecturs without
 readq/writeq
Thread-Topic: [PATCH] NVMe: Fix compilation on architecturs without
 readq/writeq
Thread-Index: AQHM1w8BDLinPJtR+E+BIPu+GhBs2ZYU+6yAgABM65A=
Date: Fri, 20 Jan 2012 17:43:51 +0000
Message-ID: <100D68C7BA14664A8938383216E40DE0012321@FMSMSX106.amr.corp.intel.com>
References: <1327021265-22184-1-git-send-email-matthew.r.wilcox@intel.com>
 <CA+55aFwmDbDm5+12Nc0wnu7J8dsOKW0tCd_tVf-3pwQOq9MF3w@mail.gmail.com>
In-Reply-To: <CA+55aFwmDbDm5+12Nc0wnu7J8dsOKW0tCd_tVf-3pwQOq9MF3w@mail.gmail.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.200.108]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yep, I knew I could check for readq with an ifdef, but I'd rather just use the 32-bit versions everywhere and have consistent behaviour between bittedness.  If this were a performance path, I'd absolutely do what you suggest.

One minor point is that '|' is not a sequence point, so it's not defined whether you'll read the top or bottom half of the register first.  And some hardware people are crazy enough to care.

For this particular hardware, it's defined to work if you read the low order bits first, so I went with the nvme_readq() function to emphasise that this solution works for the nvme driver.

-----Original Message-----
From: linus971@gmail.com [mailto:linus971@gmail.com] On Behalf Of Linus Torvalds
Sent: Thursday, January 19, 2012 5:22 PM
To: Wilcox, Matthew R; Roland Dreier; Andrew Morton; Hitoshi Mitake; James Bottomley; Ingo Molnar
Cc: linux-kernel@vger.kernel.org; linux-nvme@infradead.org; hpa@linux.intel.com
Subject: Re: [PATCH] NVMe: Fix compilation on architecturs without readq/writeq

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

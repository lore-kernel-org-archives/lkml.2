Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524Ab2EUXcM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 19:32:12 -0400
Received: from mga03.intel.com ([143.182.124.21]:39006 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753842Ab2EUXcL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 19:32:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="145970437"
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [git pull] machine check recovery fix
References: <4fb531069693a1b42@agluck-desktop.sc.intel.com>
	<CA+55aFxB6YSz-KEwVKtOesS7yrdvYw6sP3mfpuWBOheJVL6e+w@mail.gmail.com>
	<CA+8MBbK_xeN5HWnSvbDYwzZ+E0pSpbDte30RH2deo0r1OzYBGA@mail.gmail.com>
	<CA+55aFxvjBQ+nn2JEnrMeHrRq9O7-aost1ZYrQbOFySkU_piWg@mail.gmail.com>
	<CA+8MBbLw9ySj5VDjJJ04fW383=8AUhDfyvqdrPnAR7+-etGFqQ@mail.gmail.com>
	<CA+55aFygZYVpM7Agy+Vi+Majaa=7GLzeS8Mp9v3jiq-t+_=hLQ@mail.gmail.com>
Date: Mon, 21 May 2012 16:32:10 -0700
In-Reply-To: <CA+55aFygZYVpM7Agy+Vi+Majaa=7GLzeS8Mp9v3jiq-t+_=hLQ@mail.gmail.com>
	(Linus Torvalds's message of "Thu, 17 May 2012 20:33:44 -0700")
Message-ID: <m2mx518611.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:
>
> In fact, it's *all* crap. Because it shouldn't check "m->cs" and
> "m->ip" at all, because what matters is not which instruction caused
> the MCE, but whether the *return* address is in kernel mode or not!

No it matters which instruction caused the error, because it's the
one which saw data corruption. If that was not in kernel you
can safely just return because the kernel is completely fine
and the instruction can be restarted. It's just like a interrupt.

In the cases where this cannot be determined the MCE code
only uses the address and does not use this.

> Maybe the error that triggered the MCE happened in user mode, but
> asynchronously, so the return address is in kernel mode. So the whole
> "error_context()" thing is testing entirely the wrong thing.

EIPV==1 means the error IP is valid.

The asynchronous cases never handle this.

Yes the logic is rather hairy, but mainly because the whole problem
is very.

> That "is it in kernel mode" check also seems to not know about vm86
> mode. Let's hope those MCE's can never happen on an instruction in
> vm86 mode, because then the CS check is crap too.

I fixed the VM86 thing a long time ago, but it was never merged
unfortunately. Not that it matters much, because the systems which
have recoverable machine checks usually have far too much memory
for 32bit kernels.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only

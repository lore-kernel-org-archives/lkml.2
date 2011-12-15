Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932671Ab1LOWnE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 17:43:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43537 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759632Ab1LOWnC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 17:43:02 -0500
Message-ID: <4EEA77E1.6050009@zytor.com>
Date: Thu, 15 Dec 2011 14:42:41 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Alexander van Heukelum <heukelum@mailshack.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: x86: fls64() exported to user space but not fls()?
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm trying to grok why fls64() seems to be exported to user space in
<asm/bitops.h> on x86 by unconditional inclusion of
<asm-generic/bitops/fls64.h>:

...
#endif /* __KERNEL__ */

#include <asm-generic/bitops/fls64.h>

#ifdef __KERNEL__
...


 whereas fls() isn't (although __fls() is!)

This is even more bizarre since <asm-generic/bitops/fls64.h> contains:

...
#if BITS_PER_LONG == 32
static __always_inline int fls64(__u64 x)
{
        __u32 h = x >> 32;
        if (h)
                return fls(h) + 32;
        return fls(x);
}
#elif BITS_PER_LONG == 64
static __always_inline int fls64(__u64 x)
{
        if (x == 0)
                return 0;
        return __fls(x) + 1;
}
#else
#error BITS_PER_LONG not 32 or 64
#endif
...

Both BITS_PER_LONG and fls() are non-user-visible symbols, so this code
should fail on user space.  Finally, <asm-generic/bitops/*> are
non-exported headers; they are not installed by make headers_install.

Is the #endif..#ifdef in <asm/bitops.h> a bug, plain and simple?

	-hpa

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791Ab2EWQld (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 12:41:33 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:46312 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993Ab2EWQlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 12:41:31 -0400
MIME-Version: 1.0
In-Reply-To: <20120523161932.GN14757@aftab.osrc.amd.com>
References: <1337684026-19740-1-git-send-email-bp@amd64.org>
 <tip-e8f380e00840f694599e6ab42806639f7de26f11@git.kernel.org>
 <1337789429.9783.16.camel@laptop> <4FBD0C47.70600@zytor.com> <20120523161932.GN14757@aftab.osrc.amd.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 23 May 2012 09:40:40 -0700
X-Google-Sender-Auth: 0gk9LUAurcgnfmGYqa1xPh89eXY
Message-ID: <CA+55aFx9pgAQEFuNyANpHA6OcBL8LyHwknPUOb4=ysjYd4cnwQ@mail.gmail.com>
Subject: Re: [tip:x86/mce] x86/bitops: Move BIT_64() for a wider use
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        mingo@kernel.org, linux-kernel@vger.kernel.org, frank.arnold@amd.com,
        akpm@linux-foundation.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 9:19 AM, Borislav Petkov
<borislav.petkov@amd.com> wrote:
>
> Actually we need a BIT() macro that works both
> on 32- and 64-bit. But that won't be that easy:

We could use __builtin_choose_expr(), but that *only* works with constants.

So we could do this:

  static inline unsigned long bit(unsigned int x)
  {
      return 1ul << x;
  }

  static inline u64 bit64(unsigned int x)
  {
      return 1ull << x;
  }

  #define BIT(x) \
    __builtin_choose_expr((x) < 8*sizeof(unsigned long), bit(x), bit64(x))

but then you *have* to use a plain constant for the BIT() macro.
Anything else will error out in a big way. Non-constant users would
have to be modified to use bit() and bit64() instead.

And no, I tested. You apparently can't do

  #define __is_longlongshift(x) \
        (__builtin_constant_p(x) && (x) < 8*(sizeof(long)))

because while that is a compile-time constant expression, it's not
"constant enough" for __builtin_choose_expr().

                   Linus

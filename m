Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219Ab0JNPJg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 11:09:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49545 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754920Ab0JNPJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 11:09:34 -0400
MIME-Version: 1.0
In-Reply-To: <20101014105855.GB31247@aftab>
References: <20101013131057.88238be6.randy.dunlap@oracle.com>
 <20101014042409.GB29342@aftab> <20101014105855.GB31247@aftab>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 14 Oct 2010 08:03:17 -0700
Message-ID: <AANLkTi=ZjR3bWtZ2x9wRzpzBb1K8Wst3Xg_K4mGX-b6o@mail.gmail.com>
Subject: Re: [PATCH] bitops.h: Widen BIT macro to support 64-bit types
To: Borislav Petkov <bp@amd64.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Doug Thompson <dougthompson@xmission.com>,
        akpm <akpm@linux-foundation.org>, linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 14, 2010 at 3:58 AM, Borislav Petkov <bp@amd64.org> wrote:
>>
>> Ok, so BIT() should be fixed to work with the largest type available,
>> IMHO. Let me cook up something.
>
> Maybe something like the following. Build-tested with the crosstool
> (http://www.kernel.org/pub/tools/crosstool) on the following arches:
> alpha blackfin cris hppa64 ia64 mips64 sparc.
>
> Any objections?

Yeah. I object. I have no idea what this will change for everything
else that expects bitops to work on unsigned long values.

I really think that the bug is not in the BIT() definition, but in the
use. If somebody wants a non-unsigned-long bit field, they had better
not use bitops.h.

And no, just changing the BIT() macro to return a 64-bit value is
_not_ trivially safe. Due to C type rules, now all arithmetic using
BIT() will suddenly be 64-bit, which is often *much* slower, and can
introduce real bugs.

On many architectures, a 64-bit non-constant shift will even end up
being a function call. And if the thing is used in a varargs function,
the argument layout will be totally different. We've also had several
issues with 64-bit types and switch() statements, for example. And a
quick grep for '\<BIT(' shows that non-constant cases are not unheard
of, and there's a lot of random use where it is not at all obvious
that it's safe (because it's used for defining other defines).

So no. I do not think BIT() should be 64-bit. It's "unsigned long".
Look at all the other things around it, and look at all the historical
uses.

                                    Linus

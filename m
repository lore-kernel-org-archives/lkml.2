Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114Ab1HaQk4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 12:40:56 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:60772 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096Ab1HaQkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 12:40:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RFD: x32 ABI system call numbers
Date: Wed, 31 Aug 2011 18:39:52 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Christoph Hellwig <hch@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, "H.J. Lu" <hjl.tools@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Richard Kuo <rkuo@codeaurora.org>, Mark Salter <msalter@redhat.com>,
        Jonas Bonn <jonas@southpole.se>, Tobias Klauser <tklauser@distanz.ch>
References: <4E582577.2060805@zytor.com> <201108311814.54906.arnd@arndb.de> <4E5E6075.6060209@zytor.com>
In-Reply-To: <4E5E6075.6060209@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108311839.52863.arnd@arndb.de>
X-Provags-ID: V02:K0:BzVsAS2G7Th9+k38WzTcdtPgpQPaJcovlOgvuHS3Q4H
 4VLXTVmTr84n5DAESPLxUBIHRU7UDL8D4Uu4BV9RggXRAXjVr/
 ZqimSe1CJGJbylCTp1mN9cY47jUZxTO70N9LqMJVLcik+Y+uHc
 WWlkVtnuKYJ5lOBZRPdp2D823expRRi8uJt8r+/rOrjYElptB1
 kxJ5zt0ncsByfhw4L18QicQ+8HZPoRQHd9ZX17WwUwW2BeDaMi
 6Fl8LCDT+ZZUbG29PNF4GUFfTTH+/vTS641SC67Rvkh3cXg1DZ
 E0c7/E7MnbwEb4sIV5WLcfUNMp3pY+JwS8pPpiq9sXsMVxB2ma
 YVIvR0VmXBvl5gHTcKos=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 August 2011, H. Peter Anvin wrote:
> On 08/31/2011 09:14 AM, Arnd Bergmann wrote:

> > * padding in struct timespec when you have a long long tv_sec and
> >   32-bit long tv_nsec. This might cause kernel stack data leakage
> >   in some kernel interfaces when they don't clear the padding.
> 
> Don't to that then.  For what it's worth, I think we currently use the
> same size for both fields.

Ok, good point.

> > * random broken applications assuming that timespec/timeval has
> >   two 'long' members, instead of using the proper header files.
> > 
> > Obviously these are all fixable for any new ABI, but will cause
> > some annoyance.
> > 
> > I've added a few people to Cc who are in various stages of the
> > process to finalize their upstream kernel ports. It's clearly
> > the right decision to have time_t 64-bit eventually, the question
> > is how much work is everyone willing to spend in the short run,
> > and who is going to test it. In particular, openrisc has just
> > been merged, so we should not be changing it any more unless
> > there is a serious problem, but if there is not much legacy user
> > space with the current ABI yet, it may still be worth switching
> > over.
> 
> Either way, all of this applies to x32 even more, sadly.
> 
> The other thing is that we probably need to do is to set a date when we
> redefine legacy 32-bit time_t to be unsigned.  A good time might be some
> time around (time_t)0x60000000 = Thu Jan 14 08:25:36 UTC 2021 if not sooner.

Well, we could chicken out and just use unsigned int for time_t on new
32 bit ABIs, which would buy us time until ~2106 before we need to
convert everything to 64 bit...

Do you see any side-effects of changing time_t to unsigned, besides
file dates outside of the 1970...2038 range? If we end up having to
introduce new syscalls because of some incompatibility, we could just
as well introduce the full set of syscalls using a new time64_t for
32 bit architectures, like we did for uid32_t and loff_t.
The only problem that I can see right now with changing over is that
the 32-on-64 bit emulation changes from sign-extend to zero-extend.

	Arnd

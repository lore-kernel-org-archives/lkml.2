Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757817Ab2CZXSn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 19:18:43 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:34978 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368Ab2CZXSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 19:18:42 -0400
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 1/1] vsprintf: optimize decimal conversion (again)
Date: Tue, 27 Mar 2012 01:18:38 +0200
User-Agent: KMail/1.8.2
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Douglas W Jones <jones@cs.uiowa.edu>,
        Michal Nazarewicz <mnazarewicz@google.com>
References: <201203262047.17865.vda.linux@googlemail.com> <20120326131304.018a5f4b.akpm@linux-foundation.org> <CAMuHMdWK-0m9-LUc90e7e8pYsOsECkZ3gjBYVAP-A4p7p=Pyug@mail.gmail.com>
In-Reply-To: <CAMuHMdWK-0m9-LUc90e7e8pYsOsECkZ3gjBYVAP-A4p7p=Pyug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201203270118.38639.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 March 2012 22:18, Geert Uytterhoeven wrote:
> On Mon, Mar 26, 2012 at 22:13, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Mon, 26 Mar 2012 21:56:38 +0200
> > Denys Vlasenko <vda.linux@googlemail.com> wrote:
> >
> >> >> +#if BITS_PER_LONG != 32 || (~(0ULL)>>1) != ((1ULL<<63)-1)
> >> >
> >> > What's this for?
> >>
> >> The second check should be just BITS_PER_LONG_LONG != 64,
> >> but we don't have BITS_PER_LONG_LONG.
> >
> > So let's add BITS_PER_LONG_LONG rather than hacking around its absence!
> 
> I don't think Linux runs on anything with BITS_PER_LONG_LONG != 64...
> 
> BTW, what about CPUs with slow 32x32 multiplication and/or slow 64-bit
> division?

Without 32x32->64 multiply, the best we can generate is 4 decimal digits:
we produce next digit by approximating x/10 with (x * 0xcccd) >> 19,
and the first x where it gives wrong result is 81920 if multiply result
is truncated to 32 bits.
With it, we can generate 9 digits using (x * 0x1999999a) >> 32.

Regrading "slow 64-bit division" - after this patch, 32-bit machines
wouldn't use it at all. Only 64-bit machines will perform 64-bit
division, one per 9 decimal digits (thus, at most three divisions
per one long_long->string conversion).

In fact, with small change to #ifdefs, all machines with long long <= 64
bits can use division-less routine. It might be a good thing to try...

Any people with ARM hardware in hand interesting in running the test
program I sent in first email?

-- 
vda

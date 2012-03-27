Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683Ab2C0Aaj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 20:30:39 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:34849 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610Ab2C0Aai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 20:30:38 -0400
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 1/1] vsprintf: optimize decimal conversion (again)
Date: Tue, 27 Mar 2012 02:30:35 +0200
User-Agent: KMail/1.8.2
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Douglas W Jones <jones@cs.uiowa.edu>,
        Michal Nazarewicz <mnazarewicz@google.com>
References: <201203262047.17865.vda.linux@googlemail.com> <CAMuHMdWK-0m9-LUc90e7e8pYsOsECkZ3gjBYVAP-A4p7p=Pyug@mail.gmail.com> <201203270118.38639.vda.linux@googlemail.com>
In-Reply-To: <201203270118.38639.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201203270230.35600.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 March 2012 01:18, Denys Vlasenko wrote:
> > I don't think Linux runs on anything with BITS_PER_LONG_LONG != 64...
> > 
> > BTW, what about CPUs with slow 32x32 multiplication and/or slow 64-bit
> > division?
> 
> Without 32x32->64 multiply, the best we can generate is 4 decimal digits:
> we produce next digit by approximating x/10 with (x * 0xcccd) >> 19,
> and the first x where it gives wrong result is 81920 if multiply result
> is truncated to 32 bits.
> With it, we can generate 9 digits using (x * 0x1999999a) >> 32.
> 
> Regrading "slow 64-bit division" - after this patch, 32-bit machines
> wouldn't use it at all. Only 64-bit machines will perform 64-bit
> division, one per 9 decimal digits (thus, at most three divisions
> per one long_long->string conversion).
> 
> In fact, with small change to #ifdefs, all machines with long long <= 64
> bits can use division-less routine. It might be a good thing to try...

Well, apparently it's not a good idea for my Phenom II in 64-bit mode:
It's bigger:

   text    data     bss     dec     hex filename
   2395     448       0    2843     b1b test_div64.o
   2507     448       0    2955     b8b test_nodiv.o

And slower:
Conversions per second:
div64: 8:42660000 123:31472000 123456:21748000 12345678:19140000 123456789:20980000 2^32:16948000 2^64:9480000
nodiv: 8:40532000 123:30276000 123456:21172000 12345678:18672000 123456789:13440000 2^32:13440000 2^64:8992000

-- 
vda

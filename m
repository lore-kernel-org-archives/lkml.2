Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933527Ab2HWAFx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 20:05:53 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:56203 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755697Ab2HWAFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 20:05:50 -0400
MIME-Version: 1.0
In-Reply-To: <20120822191516.8483.64529.stgit@localhost6.localdomain6>
References: <20120822133136.GC6899@x1.osrc.amd.com> <20120822191516.8483.64529.stgit@localhost6.localdomain6>
From: Jason Garrett-Glaser <jason@x264.com>
Date: Wed, 22 Aug 2012 17:05:07 -0700
X-Google-Sender-Auth: 6JeKbgcDKfoaQ3Tb8dGSAxYGf5k
Message-ID: <CABS55+BAk0QCXpJsbs6WyN4i5Q2Rt1k2fDhgs=bvbfuaBjhsEA@mail.gmail.com>
Subject: Re: [PATCH] crypto: twofish - add x86_64/avx assembler implementation
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Borislav Petkov <bp@alien8.de>,
        Johannes Goetzfried 
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        =?ISO-8859-1?Q?Tilo_M=FCller?= 
	<tilo.mueller@informatik.uni-erlangen.de>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 12:20 PM, Jussi Kivilinna
<jussi.kivilinna@mbnet.fi> wrote:
> Quoting Borislav Petkov <bp@alien8.de>:
>
>> On Wed, Aug 22, 2012 at 07:35:12AM +0300, Jussi Kivilinna wrote:
>>> Looks that encryption lost ~0.4% while decryption gained ~1.8%.
>>>
>>> For 256 byte test, it's still slightly slower than twofish-3way
>>> (~3%). For 1k
>>> and 8k tests, it's ~5% faster.
>>>
>>> Here's very last test-patch, testing different ordering of fpu<->cpu reg
>>> instructions at few places.
>>
>> Hehe,.
>>
>> I don't mind testing patches, no worries there. Here are the results
>> this time, doesn't look better than the last run, AFAICT.
>>
>
> Actually it does look better, at least for encryption. Decryption had different
> ordering for test, which appears to be bad on bulldozer as it is on
> sandy-bridge.
>
> So, yet another patch then :)
>
> Interleaving at some new places (reordered lookup_32bit()s in G-macro) and
> doing one of the round rotations one round ahead. Also introduces some
> more paralellism inside lookup_32bit.

Outsider looking in here, but avoiding the 256-way lookup tables
entirely might be faster.  Looking at the twofish code, one byte-wise
calculation looks like this:

    a0 = x >> 4; b0 = x & 15;
    a1 = a0 ^ b0; b1 = ror4[b0] ^ ashx[a0];
    a2 = qt0[n][a1]; b2 = qt1[n][b1];
    a3 = a2 ^ b2; b3 = ror4[b2] ^ ashx[a2];
    a4 = qt2[n][a3]; b4 = qt3[n][b3];
    return (b4 << 4) | a4;

This means that you can do something like this pseudocode (Intel
syntax).  pshufb on ymm registers is AVX2, but splitting it into xmm
operations would probably be fine (as would using this for just a pure
SSE implementation!).  On AVX2 you' have to double the tables for both
ways, naturally.

constants:
pb_0x0f = {0x0f,0x0f,0x0f ... }
ashx: lookup table
ror4: lookup table
qt0[n]: lookup table
qt1[n]: lookup table
qt2[n]: lookup table
qt3[n]: lookup table

vpand    b0,     in, pb_0x0f
vpsrlw   a0,     in, 4
vpand    a0,     a0, pb_0x0f    ; effectively vpsrlb, but that doesn't exist

vpxor    a1,     a0, b0
vpshufb  a0,   ashx, a0
vpshufb  b0,   ror4, b0
vpxor    b1,     a0, b0

vpshufb  a2, qt0[n], a1
vpshufb  b2, qt1[n], b1

vpxor    a3,     a2, b2
vpshufb  a3,   ashx, a2
vpshufb  b3,   ror4, b2
vpxor    b3,     a2, b2

vpshufb  a4, qt2[n], a3
vpshufb  b4, qt3[n], b3

vpsllw   b4,     b4, 4          ; effectively vpsrlb, but that doesn't exist
vpor    out,     a4, b4

That's 15 instructions (plus maybe a move or two) to do 16 lookups for
SSE (~9 cycles by my guessing on a Nehalem).  AVX would run into the
problem of lots of extra vinsert/vextract (just going 16-byte might be
better, might be not, depending on execution units).  AVX2 would be
super fast (15 for 32).

If this works, this could be quite a bit faster with the table-based approach.

Jason

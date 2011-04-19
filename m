Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011Ab1DSCPz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 22:15:55 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:33809 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713Ab1DSCPx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 22:15:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=XQCQCXwUKFQBMOG8ohbWhOhfK3HZ5gUozdq7sQ7elXkxfVT6G/DYC9kKwGX5kV0n73
         X2KzeO4C0j5ODr1j67gxcKVOoId2KK6VyIdIWBX2+IAiZ62okmTvL2CNRDL2C8zvSpL+
         quiBVykHcgHdxFdFwPEOh0AvigeSazqtGc18k=
MIME-Version: 1.0
In-Reply-To: <20110418221051.GR16484@one.firstfloor.org>
References: <BANLkTi=0gS2TSGgG15DbDPGttzCvEbEvaw@mail.gmail.com> <20110418221051.GR16484@one.firstfloor.org>
From: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 18 Apr 2011 22:15:33 -0400
X-Google-Sender-Auth: 9gKlmjgWshNK9yq95O4E7jUkYlc
Message-ID: <BANLkTim_e81meeOqYH2rBx_MWHe=kiNGTw@mail.gmail.com>
Subject: Re: [RFT] Please test rdtsc on various x86-64 hardware (app included)
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>, x86 <x86@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 6:10 PM, Andi Kleen <andi@firstfloor.org> wrote:
> I tested it on a dual Westmere-EP and a Quad Westmere-EX.
> Seems to pass everywhere.

I see a failure below...

>
> However I kept the default MAX_THREADS 4. Shouldn't that be
> increased for the large systems?

MAX_THREADS is just the size of a data structure -- the tests use
either two or three threads.   However...

>
> I suspect the tests as written didn't really use the large
> systems.
>
> Dual:
>
> CPU vendor   : GenuineIntel
> CPU model    : Intel(R) Xeon(R) CPU           E5640  ...
> CPU stepping : ..
> TSC flags    : tsc rdtscp constant_tsc nonstop_tsc
> Using lfence_rdtsc because you have an Intel CPU
> Will test the "lfence;rdtsc" clock.
> Now test failed  : worst error 48 with 48647928 samples

...that's not so good.  The "now test" is quite simple and really
shouldn't fail unless lfence doesn't work or the TSCs are out of sync.

Can you run now_test_all_pairs.sh from the same repository?  If you
have two packages that are a little out of sync, that should show it.
(It'll take a minute or so.)

I was thinking about how BIOS or the OS would go about syncing the
TSCs on different CPUs and it's not so obvious.  The problem is that
AFAICT you can't add an offset to a TSC; you have to reprogram the
whole thing.  That means that the time it takes for the wrmsr to
finish is a somewhat unknown error.  If you're off by, say, 70 cycles,
the now test will catch it if it ends up on the right CPUs.

FWIW, I can't reproduce this on a dual-package Xeon E5520.

--Andy

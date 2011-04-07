Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab1DGV1Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 17:27:16 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60468 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076Ab1DGV1K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 17:27:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=vtH4UznsnUBXt5la16q+vhA3eWu9mszQhC84rD1/HAexDwlPcTHdVnly8AsHdd0vKm
         nGHfwwWu19ZkBB2mHUNoCSB2D0+VI/FKLkWuaPNv7JTwXZ4CD2JRihZia8mm2wBTlICm
         qJZ4SeZIjilpV3Vphc3w1bDNEQChbQEwNaAxs=
MIME-Version: 1.0
In-Reply-To: <BANLkTikhG9deEo0VvrUSXzn850GjBvYtiw@mail.gmail.com>
References: <cover.1302137785.git.luto@mit.edu> <80b43d57d15f7b141799a7634274ee3bfe5a5855.1302137785.git.luto@mit.edu>
 <BANLkTi=RkeFMpcb36RrJ=+eYm-xk4B2zYw@mail.gmail.com> <20110407164245.GA21838@one.firstfloor.org>
 <BANLkTikdn+Y2pWoLH_=Q4xHTgT6XGfOuSg@mail.gmail.com> <20110407181523.GC21838@one.firstfloor.org>
 <BANLkTikhG9deEo0VvrUSXzn850GjBvYtiw@mail.gmail.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Thu, 7 Apr 2011 17:26:50 -0400
X-Google-Sender-Auth: h-cnp8HDwDRgWcqYRfatdNu3W_c
Message-ID: <BANLkTi=kh+3HTsr4xGQY88T-qwbeCx5JVw@mail.gmail.com>
Subject: Re: [RFT/PATCH v2 2/6] x86-64: Optimize vread_tsc's barriers
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 7, 2011 at 2:30 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Apr 7, 2011 at 11:15 AM, Andi Kleen <andi@firstfloor.org> wrote:
>>
>> I would prefer to be safe than sorry.
>
> There's a difference between "safe" and "making up theoretical
> arguments for the sake of an argument".
>
> If Intel _documented_ the "barriers on each side", I think you'd have a point.
>
> As it is, we're not doing the "safe" thing, we're doing the "extra
> crap that costs us and nobody has ever shown is actually worth it".

Speaking as both a userspace programmer who wants to use clock_gettime
and as the sucker who has to test this thing, I'd like to agree on
what clock_gettime is *supposed* to do.  I propose:

For the purposes of ordering, clock_gettime acts as though there is a
volatile variable that contains the time and is kept up-to-date by
some thread.  clock_gettime reads that variable.  This means that
clock_gettime is not a barrier but is ordered at least as strongly* as
a read to a volatile variable.  If code that calls clock_gettime needs
stronger ordering, it should add additional barriers as appropriate.

* Modulo errata, BIOS bugs, implementation bugs, etc.

This means, for example, that if you do:

volatile int a = 0;
int b;
struct timespec c, d;

Thread 1:
a = 1;
clock_gettime(CLOCK_MONOTONIC, &c);

Thread 2:
clock_gettime(CLOCK_MONOTONIC, &d)
b = a;

you would expect in a fully serialized world that if b == 0 then d <=
c.  (That is, if b == 0 then thread 2 finished before thread 1
started.)  I think that this does not deserve to work, although it
will by accident on AMD systems.  (But unless Intel's lfence is a lot
stronger than advertised, it will probably fail dramatically on Intel,
both in current and proposed code.)

If you agree with my proposal, I'll try to test it with and without
the magic extra barrier and I'll even write it up for Documentation
and maybe man-pages.

--Andy

>
>                               Linus
>

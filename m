Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757035Ab1DHR7w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 13:59:52 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41723 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754374Ab1DHR7t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 13:59:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=xeh2MK9EekWJyHUJU2gRLzI1KhCbKbRAvcjv25K3pyM5X1Na83ohqGwSZ7SdEcEpuw
         nZ55BJUlByW4hi/18sVC5rE5sBtw1Y3G/0xOogKDX8HjVp4bV1psTazIDASv+Uae3xPp
         yksXEKDJJl2ED8mJVcCmpkTljOfrvbt4wYqGE=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=kh+3HTsr4xGQY88T-qwbeCx5JVw@mail.gmail.com>
References: <cover.1302137785.git.luto@mit.edu> <80b43d57d15f7b141799a7634274ee3bfe5a5855.1302137785.git.luto@mit.edu>
 <BANLkTi=RkeFMpcb36RrJ=+eYm-xk4B2zYw@mail.gmail.com> <20110407164245.GA21838@one.firstfloor.org>
 <BANLkTikdn+Y2pWoLH_=Q4xHTgT6XGfOuSg@mail.gmail.com> <20110407181523.GC21838@one.firstfloor.org>
 <BANLkTikhG9deEo0VvrUSXzn850GjBvYtiw@mail.gmail.com> <BANLkTi=kh+3HTsr4xGQY88T-qwbeCx5JVw@mail.gmail.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Fri, 8 Apr 2011 13:59:29 -0400
X-Google-Sender-Auth: kYxz5nGC-vERUUQQpkZhKfdc5Yo
Message-ID: <BANLkTimjiwxC8ryiLpmd=jCjBD62ZZ0G5A@mail.gmail.com>
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

On Thu, Apr 7, 2011 at 5:26 PM, Andrew Lutomirski <luto@mit.edu> wrote:
> On Thu, Apr 7, 2011 at 2:30 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> On Thu, Apr 7, 2011 at 11:15 AM, Andi Kleen <andi@firstfloor.org> wrote:
>>>
>>> I would prefer to be safe than sorry.
>>
>> There's a difference between "safe" and "making up theoretical
>> arguments for the sake of an argument".
>>
>> If Intel _documented_ the "barriers on each side", I think you'd have a point.
>>
>> As it is, we're not doing the "safe" thing, we're doing the "extra
>> crap that costs us and nobody has ever shown is actually worth it".
>
> Speaking as both a userspace programmer who wants to use clock_gettime
> and as the sucker who has to test this thing, I'd like to agree on
> what clock_gettime is *supposed* to do.  I propose:
>
> For the purposes of ordering, clock_gettime acts as though there is a
> volatile variable that contains the time and is kept up-to-date by
> some thread.  clock_gettime reads that variable.  This means that
> clock_gettime is not a barrier but is ordered at least as strongly* as
> a read to a volatile variable.  If code that calls clock_gettime needs
> stronger ordering, it should add additional barriers as appropriate.
>
> * Modulo errata, BIOS bugs, implementation bugs, etc.

As far as I can tell, on Sandy Bridge and Bloomfield, I can't get the
sequence lfence;rdtsc to violate the rule above.  That the case even
if I stick random arithmetic and branches right before the lfence.  If
I remove the lfence, though, it starts to fail.  (This is without the
evil fake barrier.)

However, as expected, I can see stores getting reordered after
lfence;rdtsc and rdtscp but not mfence;rdtsc.

So... do you think that the rule is sensible?

I'll post the test case somewhere when it's a little less ugly.  I'd
like to see test results on AMD.

--Andy

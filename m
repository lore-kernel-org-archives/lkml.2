Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166Ab1F1C1C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 22:27:02 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34210 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756000Ab1F1CZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 22:25:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=BlshM1mBozRe4whIfu6nR/xKJtkjVWmywPQoGnJ2Z69rt+8JfS48j3ajfr8T9KGusW
         UvSlJDr0x+opdWtM82nBnBW8jgCSzaJJt4EpvB2IfXy2BAd6EWYKY/0rW2NUluMSuV8D
         Kem3H17QqNZK1fe8Twa5B6hXxIOgQ96yeSjqc=
MIME-Version: 1.0
In-Reply-To: <20110430173905.GA25641@tty.gr>
References: <20110428082625.GA23293@pcnci.linuxbox.cz>
	<20110428183434.GG30645@1wt.eu>
	<20110429100200.GB23293@pcnci.linuxbox.cz>
	<20110430093605.GA10529@1wt.eu>
	<20110430173905.GA25641@tty.gr>
Date: Mon, 27 Jun 2011 19:25:31 -0700
X-Google-Sender-Auth: t8XuTXaEShGG39DIcb7dTvK-nwA
Message-ID: <BANLkTi=22QFrJ4vO7-3VuHU=9Cg39bxJ4Q@mail.gmail.com>
Subject: Re: 2.6.32.21 - uptime related crashes?
From: john stultz <johnstul@us.ibm.com>
To: Faidon Liambotis <paravoid@debian.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
        seto.hidetoshi@jp.fujitsu.com,
        =?ISO-8859-1?Q?Herv=E9_Commowick?= <hcommowick@exosec.fr>,
        Willy Tarreau <w@1wt.eu>, Randy Dunlap <rdunlap@xenotime.net>,
        Greg KH <greg@kroah.com>, Ben Hutchings <ben@decadent.org.uk>,
        Apollon Oikonomopoulos <apoikos@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 30, 2011 at 10:39 AM, Faidon Liambotis <paravoid@debian.org> wrote:
> We too experienced problems with just the G6 blades at near 215 days uptime
> (on the 19th of April), all at the same time. From our investigation, it
> seems that their cpu_clocks jumped suddenly far in the future and then
> almost immediately rolled over due to wrapping around 64-bits.
>
> Although all of their (G6s) clocks wrapped around *at the same time*, only
> one
> of them actually crashed at the time, with a second one crashing just a few
> days later, on the 28th.
>
> Three of them had the following on their logs:
> Apr 18 20:56:07 hn-05 kernel: [17966378.581971] tap0: no IPv6 routers
> present
> Apr 19 10:15:42 hn-05 kernel: [18446743935.365550] BUG: soft lockup - CPU#4
> stuck for 17163091968s! [kvm:25913]

So, did this issue ever get any traction or get resolved?

>From the softlockup message, I suspect we hit a multiply overflow in
the underlying sched_clock() implementation.

Because the goal of  sched_clock is to be very fast, lightweight and
safe from locking issues (so it can be called anywhere) handling
transient corner cases internally has been avoided as they would
require costly locking and extra overhead. Because of this,
sched_clock users should be cautious to be robust in the face of
transient errors.

Peter: I wonder if the soft lockup code should be using the
(hopefully) more robust timekeeping code (ie: get_seconds) for its
get_timestamp function? I'd worry that you might have issues catching
cases where the system was locked up so the timekeeping accounting
code didn't get to run,  but you have the same problem in the jiffies
based sched_clock code as well (since timekeeping increments jiffies
in most cases).

That said, I didn't see from any of the backtraces in this thread why
the system actually crashed.  The softlockup message on its own
shouldn't do that, so I suspect there's still a related issue
somewhere else here.

thanks
-john

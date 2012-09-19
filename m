Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145Ab2ISMfa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 08:35:30 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:40181 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751500Ab2ISMf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 08:35:29 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19mm1JlxWVmL5K9eViwkbiUVEpOK7luc1zb2KCjq4
	j7lT0OOWx/w2fe
Message-ID: <1348058119.4457.129.camel@marge.simpson.net>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
From: Mike Galbraith <efault@gmx.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Nikolay Ulyanitsky <lystor@gmail.com>,
        linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Date: Wed, 19 Sep 2012 14:35:19 +0200
In-Reply-To: <1347770100.6952.31.camel@marge.simpson.net>
References: <CA+Medix98MHYzpKSDKKWf7Wew0H4zDFsUS74LrhsP2Lxemd3Mw@mail.gmail.com>
	 <20120914212717.GA29307@liondog.tnic>
	 <CA+55aFwn3UhTDDch4+-=9=T3rHpDvqphY+NLtf2Ljq-7eG+gYw@mail.gmail.com>
	 <1347680006.4340.142.camel@marge.simpson.net>
	 <m24nmzz2f8.fsf@firstfloor.org>
	 <1347727001.7029.37.camel@marge.simpson.net>
	 <20120915223212.4174a314@pyramind.ukuu.org.uk>
	 <1347770100.6952.31.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-09-16 at 06:35 +0200, Mike Galbraith wrote:

> Oh, while I'm thinking about it, there's another scenario that could
> cause the select_idle_sibling() change to affect pgbench on largeish
> packages, but it boils down to preemption odds as well.  IIRC pgbench
> _was_ at least 1:N, ie one process driving the whole load.  Waker of
> many (singularly bad idea as a way to generate load) being preempted by
> it's wakees stalls the whole load, so expensive spreading of wakees to
> the four winds ala WAKE_BALANCE becomes attractive, that pain being
> markedly less intense than having multiple cores go idle while creator
> or work waits for one.

Enabling SMT on little E5620 box says that's the deal.  pgbench as run
is 1:N, and all you have to do is disable select_idle_sibling() entirely
to see that for _this_ (~odd) load, max spread and lower wakeup latency
for the mother of all work itself is a good thing.

pgbench -i pgbench && pgbench -c $N -T 10 pgbench

N=   1     2     4     8    16    32    64
  1336  2482  3752  3485  3327  2928  2290  virgin 3.6.0-rc6
  1408  2457  3363  3070  2938  2368  1757  +revert reverted 
  1310  2492  2487  2729  2186   975   874  +revert + select_idle_sibling() disabled
  1407  2505  3422  3137  3093  2828  2250  +revert + schedctl -B /etc/init.d/postgresql restart
  1321  2403  2515  2759  2420  2301  1894  +revert + schedctl -B /etc/init.d/postgresql restart + select_idle_sibling() disabled

Hohum, damned if ya do, damned if ya don't.  Damn.

-Mike 



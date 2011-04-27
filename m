Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760242Ab1D0X3H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 19:29:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49174 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757162Ab1D0X3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 19:29:05 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1104280028250.3323@ionos>
References: <20110425214933.GO2468@linux.vnet.ibm.com> <20110426081904.0d2b1494@pluto.restena.lu>
 <20110426112756.GF4308@linux.vnet.ibm.com> <20110426183859.6ff6279b@neptune.home>
 <20110426190918.01660ccf@neptune.home> <BANLkTikjuqWP+PAsObJH4EAOyzgr2RbYNA@mail.gmail.com>
 <alpine.LFD.2.02.1104262314110.3323@ionos> <20110427081501.5ba28155@pluto.restena.lu>
 <20110427204139.1b0ea23b@neptune.home> <alpine.LFD.2.02.1104272351290.3323@ionos>
 <20110427222727.GU2135@linux.vnet.ibm.com> <alpine.LFD.2.02.1104280028250.3323@ionos>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 27 Apr 2011 16:28:09 -0700
Message-ID: <BANLkTi=Ad2DUQ2Lr-Q5Y+eYxKMyz04fL2g@mail.gmail.com>
Subject: Re: 2.6.39-rc4+: Kernel leaking memory during FS scanning, regression?
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Frysinger <vapier.adi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Pekka Enberg <penberg@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 3:32 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> Well that's going to paper over the problem at hand possibly. I really
> don't see why that thing would run for more than 950ms in a row even
> if there is a large number of callbacks pending.

Stop with this bogosity already, guys.

We _know_ it didn't run continuously for 950ms. That number is totally
made up. There's not enough work for it to run that long, but more
importantly, the thread has zero CPU time. There is _zero_ reason to
believe that it runs for long periods.

There is some scheduler bug, probably the rt_time hasn't been
initialized at all, or runtime we compare against is zero, or the
calculations are just wrong.

The 950ms didn't happen. Stop harping on it. It almost certainly
simply doesn't exist.

Since that

       if (rt_rq->rt_time > runtime) {
               rt_rq->rt_throttled = 1;
+               printk_once(KERN_WARNING "sched: RT throttling activated\n");

test triggers, we know that either 'runtime' or 'rt_time' is just
bogus. Make the printk print out the values, and maybe that gives some
hints.

But in the meantime, I'd suggest looking for the places that
initialize or calculate those values, and just assume that some of
them are buggy.

> And then I don't have an explanation for the hosed CPU accounting and
> why that thing does not get another 950ms RT time when the 50ms
> throttling break is over.

Again, don't even bother talking about "another 950ms". It didn't
happen in the first place, there's no "another" there either.

                      Linus

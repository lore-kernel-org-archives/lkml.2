Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032057Ab2CITzX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:55:23 -0500
Received: from www.linutronix.de ([62.245.132.108]:47199 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031998Ab2CITzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:55:16 -0500
Date: Fri, 9 Mar 2012 20:55:10 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
cc: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Glauber Costa <gcosta@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: udelay minimum delay guarantee and maximum supported delay?
In-Reply-To: <201203091437.50996.tvrtko.ursulin@onelan.co.uk>
Message-ID: <alpine.LFD.2.02.1203091855350.2742@ionos>
References: <201203091437.50996.tvrtko.ursulin@onelan.co.uk>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Mar 2012, Tvrtko Ursulin wrote:
 
> Hi all,
> 
> I was debugging some weird driver behaviour under 3.3.0-rc6+ (amd64) and 
> eventually I got to discovering udelay's driver is issuing are occasionally 
> short. That results in random hardware behaviour, but that is beside the 
> point.
> 
> Driver in question wants to delay for 500us at a time, which is not a terribly 
> nice thing to do, but putting that aside and talking more in general I would 
> have three questions:
> 
> 1. Are 500us udelays supposed to work? (I know they are not recommended and 
> I'll fix that.)

Yep, though it's crap, but you know that :)

> 2. Should udelay guarantee it won't delay by less than the time asked?

Yep

> 3. Is ktime_get() considered accurate enough to measure how long udelay 
> actually delayed? (Empirical evidence suggests it is, because hardware 
> weirdness correlates perfectly with occurences of these short udelays.)

Yep
 
> If answers to all are yes then we might have a bug here.

We have :(

> Because I am seeing udelay(500) (_occasionally_) being short, and that by 
> delaying for some duration between 0us (yep) and 491us.

Sigh. That's broken and turned into a random delay generator for 64bit
as of commit f0fbf0abc (x86: integrate delay functions). Patch below.

Thanks,

	tglx

--------------
Subject: x86: Derandom delay_tsc for 64 bit

commit f0fbf0abc (x86: integrate delay functions) converted
delay_tsc() into a random delay generator for 64 bit. The reason is
that it merged the mostly identical versions of delay_32.c and
delay_64.c. Though the subtle difference of the result was:

 static void delay_tsc(unsigned long loops)
 {
-	unsigned bclock, now;
+	unsigned long bclock, now;

Now the function uses rdtscl() which returns the lower 32bit of the
TSC. On 32bit that's not problematic as unsigned long is 32bit. On 64
bit this fails when the lower 32bit are close to wrap around when
bclock is read, because the following check

       if ((now - bclock) >= loops)
       	  	break;

evaluated to true on 64bit for e.g. bclock = 0xffffffff and now = 0
because the unsigned long (now - bclock) of these values results in
0xffffffff00000001 which is definitely larger than the loops
value. That explains Tvortkos observation:

"Because I am seeing udelay(500) (_occasionally_) being short, and
 that by delaying for some duration between 0us (yep) and 491us."

Make those variables explicitely u32 again, so this works for both 32
and 64 bit.

Reported-by: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org # >= 2.6.27

diff --git a/arch/x86/lib/delay.c b/arch/x86/lib/delay.c
index fc45ba8..e395693 100644
--- a/arch/x86/lib/delay.c
+++ b/arch/x86/lib/delay.c
@@ -48,9 +48,9 @@ static void delay_loop(unsigned long loops)
 }
 
 /* TSC based delay: */
-static void delay_tsc(unsigned long loops)
+static void delay_tsc(unsigned long __loops)
 {
-	unsigned long bclock, now;
+	u32 bclock, now, loops = __loops;
 	int cpu;
 
 	preempt_disable();


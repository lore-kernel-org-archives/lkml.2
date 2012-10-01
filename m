Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933459Ab2JAXKX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:10:23 -0400
Received: from 1wt.eu ([62.212.114.60]:35596 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933200Ab2JAXCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:02:51 -0400
Message-Id: <20121001225159.985495235@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:52:53 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 056/180] x86: Derandom delay_tsc for 64 bit
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit a7f4255f906f60f72e00aad2fb000939449ff32e upstream.

Commit f0fbf0abc093 ("x86: integrate delay functions") converted
delay_tsc() into a random delay generator for 64 bit.  The reason is
that it merged the mostly identical versions of delay_32.c and
delay_64.c.  Though the subtle difference of the result was:

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 arch/x86/lib/delay.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/lib/delay.c b/arch/x86/lib/delay.c
index ff485d3..b6372ce 100644
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
-- 
1.7.2.1.45.g54fbc




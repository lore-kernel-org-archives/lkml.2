Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946044Ab2CPXht (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 19:37:49 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39045 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946031Ab2CPXho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 19:37:44 -0400
Message-Id: <20120316233447.657865319@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 16 Mar 2012 16:34:51 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [ 04/38] x86: Derandom delay_tsc for 64 bit
In-Reply-To: <20120316233422.GA5461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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

---
 arch/x86/lib/delay.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/lib/delay.c
+++ b/arch/x86/lib/delay.c
@@ -48,9 +48,9 @@ static void delay_loop(unsigned long loo
 }
 
 /* TSC based delay: */
-static void delay_tsc(unsigned long loops)
+static void delay_tsc(unsigned long __loops)
 {
-	unsigned long bclock, now;
+	u32 bclock, now, loops = __loops;
 	int cpu;
 
 	preempt_disable();



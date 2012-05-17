Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759549Ab2EQBKG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 21:10:06 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:4188 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752141Ab2EQBKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 21:10:03 -0400
X-Forefront-Antispam-Report: CIP:160.33.194.228;KIP:(null);UIP:(null);IPV:NLI;H:usculsndmail01v.am.sony.com;RD:mail01.sonyusa.com;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2fh2a8h668h839hd25h)
Message-ID: <4FB44FD0.4090800@am.sony.com>
Date: Wed, 16 May 2012 18:09:36 -0700
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: "Rowand, Frank" <Frank_Rowand@sonyusa.com>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>
Subject: [PATCH RT 2/2] fix printk flush of messages
References: <4FB44EF1.9050809@am.sony.com>
In-Reply-To: <4FB44EF1.9050809@am.sony.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Updates console-make-rt-friendly.patch

#ifdef CONFIG_PREEMPT_RT_FULL, printk() output is never flushed by
printk() because:

   # some liberties taken in this pseudo-code to make it easier to follow
   printk()
      vprintk()
         raw_spin_lock(&logbuf_lock)
            # increment preempt_count():
            preempt_disable()
      result = console_trylock_for_printk()
         retval = 0
         # lock will always be false, because preempt_count() will be >= 1
         lock = ... && !preempt_count()
         if (lock)
            retval = 1
         return retval
      # result will always be false since lock will always be false
      if (result)
         console_unlock()
            # this is where the printk() output would be flushed


On system boot some printk() output is flushed because register_console()
and tty_open() call console_unlock().


This change also fixes the problem that was previously fixed by
preempt-rt-allow-immediate-magic-sysrq-output-for-preempt_rt_full.patch

Signed-off-by: Frank Rowand <frank.rowand@am.sony.com>

---
 kernel/printk.c |    2 	1 +	1 -	0 !
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/kernel/printk.c
===================================================================
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -847,7 +847,7 @@ static int console_trylock_for_printk(un
 	int retval = 0, wake = 0;
 #ifdef CONFIG_PREEMPT_RT_FULL
 	int lock = !early_boot_irqs_disabled && !irqs_disabled_flags(flags) &&
-		!preempt_count();
+		(preempt_count() <= 1);
 #else
 	int lock = 1;
 #endif


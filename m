Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626Ab2HYDR5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 23:17:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25476 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754418Ab2HYDQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 23:16:59 -0400
X-Authority-Analysis: v=2.0 cv=cpwZYiEi c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=2k-WFFBCSGIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=seBqgFWFO7gA:10 a=meVymXHHAAAA:8 a=z6gsHLkEAAAA:8 a=Thplo4k3AAAA:8 a=VwQbUJbxAAAA:8 a=ohp7AQS0vaYIBeFxnjgA:9 a=SXYrDhgbg5QA:10 a=Zh68SRI7RUMA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20120825031657.843877293@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 24 Aug 2012 23:12:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Frank Rowand <frank.rowand@am.sony.com>,
        Frank <Frank_Rowand@sonyusa.com>
Subject: [PATCH RT 1/2] fix printk flush of messages
References: <20120825031219.772181128@goodmis.org>
Content-Disposition: inline; filename=0001-fix-printk-flush-of-messages.patch
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
Cc: Frank <Frank_Rowand@sonyusa.com>
Link: http://lkml.kernel.org/r/4FB44FD0.4090800@am.sony.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/printk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 9eabbbb..66e83e5 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -836,7 +836,7 @@ static int console_trylock_for_printk(unsigned int cpu, unsigned long flags)
 	int retval = 0, wake = 0;
 #ifdef CONFIG_PREEMPT_RT_FULL
 	int lock = (!early_boot_irqs_disabled && !irqs_disabled_flags(flags) &&
-		!preempt_count()) || sysrq_in_progress;
+		(preempt_count() <= 1)) || sysrq_in_progress;
 #else
 	int lock = 1;
 #endif
-- 
1.7.10.4



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937592Ab0CPJIe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 05:08:34 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42171 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937082Ab0CPJIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 05:08:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:content-type:organization:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=fy5aygL/lsWEvHwivxHJTnR/fHT3Tw5pWDMTaUm1OfjPDrJndiTWClAcifs6FNglnn
         /VGGllg0ppPiI+8Jb3lX2xPbTAGioses3RoCHoYHzWENVAROk9ATP/lmlyM7C30DrlCS
         rHq25eFfVSJOhIempqKqGEXnWQVIcXWtWCUrU=
Subject: Why we need to call cpu_idle() with preemption disabled
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <srostedt@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: DSLab, Lanzhou University, China
Date: Tue, 16 Mar 2010 17:01:54 +0800
Message-ID: <1268730114.9552.34.camel@falcon>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Thomas

Just traced the preemption latency of 2.6.33-rt7 on my Yeeloong netbook
with the preemptoff tracer of Ftrace and found it is very big in
cpu_idle(), more than 1000 us.

And found that we have called cpu_idle() in init/main.c with preemption
disabled? why we need to do it? can we simply call it with preemption
enabled?

diff --git a/init/main.c b/init/main.c
index 48393c0..437ac34 100644
--- a/init/main.c
+++ b/init/main.c
@@ -428,9 +428,8 @@ static noinline void __init_refok rest_init(void)
         */
        init_idle_bootup_task(current);
        preempt_enable_and_schedule();
-       preempt_disable();
 
-       /* Call into cpu_idle with preempt disabled */
+       /* There is no reason for calling cpu_idle with preemption
disabled */
        cpu_idle();
 }

After removing that preempt_disable() and the related operations around
the calling to __schedule() in the cpu_idle(), the result becomes around
200 us, which is acceptable for I have enabled several Ftrace tracers.

Best Regards,
	Wu Zhangjin


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759Ab0KZQWW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 11:22:22 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40384 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203Ab0KZQWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 11:22:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=p7C81JzWfPn9YRpqxpe7QVIl3NSjmUxWgXokq6RHhFQxnas+73TFPBlWyYHMWQV04B
         BcRDat/HMQgi71SkcHFMitQ3WYiSQp0ojpk+CuzWg5lWI9szqJUZ71Uv8h/5B9AqOblN
         V7yf6hK21MaLTHInerOcKQrLa+Z2j9pUX7Hso=
Subject: [PATCH] printk: use this_cpu_{read|write} api on printk_pending
From: Eric Dumazet <eric.dumazet@gmail.com>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, heiko.carstens@de.ibm.com, tglx@linutronix.de,
        mingo@elte.hu
Cc: Christoph Lameter <cl@linux.com>
In-Reply-To: <tip-61ab25447ad6334a74e32f60efb135a3467223f8@git.kernel.org>
References: <20101126120235.406766476@de.ibm.com>
	 <tip-61ab25447ad6334a74e32f60efb135a3467223f8@git.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Nov 2010 17:22:16 +0100
Message-ID: <1290788536.2855.237.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 26 novembre 2010 à 15:02 +0000, tip-bot for Heiko Carstens a
écrit :
> Commit-ID:  61ab25447ad6334a74e32f60efb135a3467223f8
> Gitweb:     http://git.kernel.org/tip/61ab25447ad6334a74e32f60efb135a3467223f8
> Author:     Heiko Carstens <heiko.carstens@de.ibm.com>
> AuthorDate: Fri, 26 Nov 2010 13:00:59 +0100
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Fri, 26 Nov 2010 15:03:12 +0100
> 

...

> diff --git a/kernel/printk.c b/kernel/printk.c
> index cf7588e..a23315d 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -1082,6 +1082,8 @@ void printk_tick(void)
>  
>  int printk_needs_cpu(int cpu)
>  {
> +	if (unlikely(cpu_is_offline(cpu)))
> +		printk_tick();
>  	return per_cpu(printk_pending, cpu);
>  }
>  

The unlikely() was not needed, since we already have :
#define cpu_is_offline(cpu) unlikely(!cpu_online(cpu))

Anyway, this patch implies 'cpu' is always the current cpu.

If so, we can have a followup patch to use modern this_cpu api.

Thanks

[PATCH] printk: use this_cpu_{read|write} api on printk_pending

__get_cpu_var() is a bit inefficient, lets use __this_cpu_read() and
__this_cpu_write() to manipulate printk_pending.

printk_needs_cpu(cpu) is called only for the current cpu :
Use faster __this_cpu_read().

remove the redondant unlikely on (cpu_is_offline(cpu)) test

# size kernel/printk.o*
   text	   data	    bss	    dec	    hex	filename
   9942	    756	 263488	 274186	  42f0a	kernel/printk.o.new
   9990	    756	 263488	 274234	  42f3a	kernel/printk.o.old

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Christoph Lameter <cl@linux.com>
---
 kernel/printk.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index a23315d..ab3ffc5 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1074,17 +1074,17 @@ static DEFINE_PER_CPU(int, printk_pending);
 
 void printk_tick(void)
 {
-	if (__get_cpu_var(printk_pending)) {
-		__get_cpu_var(printk_pending) = 0;
+	if (__this_cpu_read(printk_pending)) {
+		__this_cpu_write(printk_pending, 0);
 		wake_up_interruptible(&log_wait);
 	}
 }
 
 int printk_needs_cpu(int cpu)
 {
-	if (unlikely(cpu_is_offline(cpu)))
+	if (cpu_is_offline(cpu))
 		printk_tick();
-	return per_cpu(printk_pending, cpu);
+	return __this_cpu_read(printk_pending);
 }
 
 void wake_up_klogd(void)



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933593Ab1ESQor (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 12:44:47 -0400
Received: from mail202c2.megamailservers.com ([69.49.111.103]:45625 "EHLO
	mail202c2.megamailservers.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754532Ab1ESQop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 12:44:45 -0400
X-Greylist: delayed 11117 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 May 2011 12:44:45 EDT
X-Authenticated-User: daniel.gaisler.com
Message-ID: <4DD51D37.3010907@gaisler.com>
Date: Thu, 19 May 2011 15:37:59 +0200
From: Daniel Hellstrom <daniel@gaisler.com>
User-Agent: Mozilla Thunderbird 1.0.6 (X11/20050716)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: linux-next: manual merge of the tip tree with the sparc tree
References: <20110517131435.aceca54e.sfr@canb.auug.org.au>
In-Reply-To: <20110517131435.aceca54e.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-CSC: 0
X-CHA: v=1.1 cv=xbudj22Aknmj7PWPRHa2OUfQBaxQEGnZbHIINz1otWI= c=1 sm=1
		a=pl2ZPvC6udcA:10 a=lNNZMRzb4sQA:10 a=U62ajLuCel8A:10 a=8nJEP1OIZ-IA:10
		a=jXKJviUpWSOlMmIvGrHOfw==:17 a=K2H0Sixetaskski1OVsA:9
		a=IvkyMYZoMBZ0O5vuSqsA:7 a=wPNLvfGTeEIA:10 a=jXKJviUpWSOlMmIvGrHOfw==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:

>Hi all,
>
>Today's linux-next merge of the tip tree got a conflict in
>arch/sparc/kernel/smp_32.c between commit d6d048192b1d ("sparc32:
>implement SMP IPIs using the generic functions") from the sparc tree and
>commit 184748cc50b2 ("sched: Provide scheduler_ipi() callback in response
>to smp_send_reschedule()") from the tip tree.
>
>I fixed it up (I am pretty sure that the sparc tree patch supercedes the
>tip tree one) and can carry the fix as necessary.
>  
>
Thanks for noticing this.

I looked at linux-next and I think the call to the scheduler_ipi is 
missing in the resched interrupt routine. I believe that the below patch 
should be applied ontop of linux-next. Could you include it in the merge 
or what do you suggest I do?

Thanks,
Daniel


diff --git a/arch/sparc/kernel/smp_32.c b/arch/sparc/kernel/smp_32.c
index 41102c5..d5b3958 100644
--- a/arch/sparc/kernel/smp_32.c
+++ b/arch/sparc/kernel/smp_32.c
@@ -156,11 +156,11 @@ void arch_send_call_function_ipi_mask(const struct 
cpumask *mask)

 void smp_resched_interrupt(void)
 {
+       irq_enter();
+       scheduler_ipi();
        local_cpu_data().irq_resched_count++;
-       /*
-        * do nothing, since it all was about calling re-schedule
-        * routine called by interrupt return code.
-        */
+       irq_exit();
+       /* re-schedule routine called by interrupt return code. */
 }

 void smp_call_function_single_interrupt(void)


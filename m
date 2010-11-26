Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212Ab0KZMmv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 07:42:51 -0500
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:51340 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765Ab0KZMmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 07:42:50 -0500
Date: Fri, 26 Nov 2010 13:42:47 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org,
        Christof Schmitt <christof.schmitt@de.ibm.com>,
        Frank Blaschka <frank.blaschka@de.ibm.com>,
        Horst Hartmann <horsth@linux.vnet.ibm.com>
Subject: Re: [patch 1/3] printk: fix wake_up_klogd() vs cpu hotplug
Message-ID: <20101126124247.GC7023@osiris.boeblingen.de.ibm.com>
References: <20101126120057.879397696@de.ibm.com>
 <20101126120235.091835714@de.ibm.com>
 <1290774909.2855.115.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1290774909.2855.115.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 26, 2010 at 01:35:09PM +0100, Eric Dumazet wrote:
> Le vendredi 26 novembre 2010 à 13:00 +0100, Heiko Carstens a écrit :
> >  void wake_up_klogd(void)
> >  {
> > -	if (waitqueue_active(&log_wait))
> > -		__raw_get_cpu_var(printk_pending) = 1;
> > +	if (waitqueue_active(&log_wait)) {
> > +		get_cpu_var(printk_pending) = 1;
> > +		put_cpu_var(printk_pending);
> > +	}
> >  }
> 
> Please use :
> 
> this_cpu_write(printk_pending, 1);
> 
> It is faster on x86, and does the right thing too.

Ah, right. I wasn't aware that such a thing even exists.
Updated patch below:

Subject: [PATCH] printk: fix wake_up_klogd() vs cpu hotplug

From: Heiko Carstens <heiko.carstens@de.ibm.com>

wake_up_klogd() may get called from preemtible context but uses
__raw_get_cpu_var() to write to a per cpu variable. If it gets preempted between
getting the address and writing to it, the cpu in question could be offline if
the process gets scheduled back and hence writes to the per cpu data of an offline
cpu.

No idea why that behaviour was introduced with fa33507a "printk: robustify
printk, fix #2" which was supposed to fix a "using smp_processor_id() in
preemptible" warning.

Let's use this_cpu_write() instead which disables preemption and makes sure that
the outlined scenario cannot happen.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 kernel/printk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1088,7 +1088,7 @@ int printk_needs_cpu(int cpu)
 void wake_up_klogd(void)
 {
 	if (waitqueue_active(&log_wait))
-		__raw_get_cpu_var(printk_pending) = 1;
+		this_cpu_write(printk_pending, 1);
 }
 
 /**

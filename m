Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab0KZMfR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 07:35:17 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57345 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab0KZMfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 07:35:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=iEtoB/OivSLUxBxEySWxyTESq9y/nJssUWQvlBdTIBJ21Kco/MWMP+Xf2IxxdxkwMz
         aba12sw+ds6jbXgWsGu6HrxtTpesnFjm3lnmXuqoiarO5E94tfvO2Y2pMQbKue25omNM
         f3YRXW2kf+MpNcGwDwu5/pf8zA0Yv1m8dokhc=
Subject: Re: [patch 1/3] printk: fix wake_up_klogd() vs cpu hotplug
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org,
        Christof Schmitt <christof.schmitt@de.ibm.com>,
        Frank Blaschka <frank.blaschka@de.ibm.com>,
        Horst Hartmann <horsth@linux.vnet.ibm.com>
In-Reply-To: <20101126120235.091835714@de.ibm.com>
References: <20101126120057.879397696@de.ibm.com>
	 <20101126120235.091835714@de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Nov 2010 13:35:09 +0100
Message-ID: <1290774909.2855.115.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 26 novembre 2010 à 13:00 +0100, Heiko Carstens a écrit :
> pièce jointe document texte brut (001_printk_preempt.diff)
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> wake_up_klogd() may get called from preemtible context but uses
> __raw_get_cpu_var() to write to a per cpu variable. If it gets preempted between
> getting the address and writing to it, the cpu in question could be offline if
> the process gets scheduled back and hence writes to the per cpu data of an offline
> cpu.
> 
> No idea why that behaviour was introduced with fa33507a "printk: robustify
> printk, fix #2" which was supposed to fix a "using smp_processor_id() in
> preemptible" warning.
> 
> Let's use get_cpu_var() instead which disables preemption and makes sure that
> the outlined scenario cannot happen.
> 
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---
>  kernel/printk.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -1087,8 +1087,10 @@ int printk_needs_cpu(int cpu)
>  
>  void wake_up_klogd(void)
>  {
> -	if (waitqueue_active(&log_wait))
> -		__raw_get_cpu_var(printk_pending) = 1;
> +	if (waitqueue_active(&log_wait)) {
> +		get_cpu_var(printk_pending) = 1;
> +		put_cpu_var(printk_pending);
> +	}
>  }
>  
>  


Please use :

this_cpu_write(printk_pending, 1);

It is faster on x86, and does the right thing too.




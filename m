Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab0KZQk6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 11:40:58 -0500
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:43334 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753501Ab0KZQk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 11:40:57 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: m4UA2fgVM1mB2wUAfMyY4p9jeO0YJYz5op9MBcczkQb4qKk
 bSSulLLNYwWZ8rG.oPU9_QQD7pebwunUI8gQ2Irh47JL75FWSRxqTxTXlL2X
 9nA3xQ72sZ8.iX7SLdIsxXHLnxFMKcU.iEMaP8D2X4aE1HtKFNQ0DCSeQC35
 tIO8rcQEx2TCaRCrrJD1aL6LLuHSFOs3AZm1yUPJweYiMmSa9BpTmq4qy0Gn
 FCsVwg.D2rRs-
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 26 Nov 2010 10:40:53 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, heiko.carstens@de.ibm.com, tglx@linutronix.de,
        mingo@elte.hu
Subject: Re: [PATCH] printk: use this_cpu_{read|write} api on
 printk_pending
In-Reply-To: <1290788536.2855.237.camel@edumazet-laptop>
Message-ID: <alpine.DEB.2.00.1011261038360.13524@router.home>
References: <20101126120235.406766476@de.ibm.com>  <tip-61ab25447ad6334a74e32f60efb135a3467223f8@git.kernel.org> <1290788536.2855.237.camel@edumazet-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Nov 2010, Eric Dumazet wrote:

> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -1074,17 +1074,17 @@ static DEFINE_PER_CPU(int, printk_pending);
>
>  void printk_tick(void)
>  {
> -	if (__get_cpu_var(printk_pending)) {
> -		__get_cpu_var(printk_pending) = 0;
> +	if (__this_cpu_read(printk_pending)) {
> +		__this_cpu_write(printk_pending, 0);
>  		wake_up_interruptible(&log_wait);
>  	}
>  }

The above looks ok.

>  int printk_needs_cpu(int cpu)
>  {
> -	if (unlikely(cpu_is_offline(cpu)))
> +	if (cpu_is_offline(cpu))
>  		printk_tick();
> -	return per_cpu(printk_pending, cpu);
> +	return __this_cpu_read(printk_pending);
>  }

This only works if printk_needs_cpu is always passed the current cpu. The
check for cpu_is_offline suggests that the function is also used for other
cpus. The __this_cpu_read() will then get the printk_pending stat for the
current cpu and not for the specified cpu.



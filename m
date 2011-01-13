Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114Ab1AMPRz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 10:17:55 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:58174 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757097Ab1AMPRw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 10:17:52 -0500
Message-ID: <4D2F179E.40401@corscience.de>
Date: Thu, 13 Jan 2011 16:17:50 +0100
From: Thomas Weber <weber@corscience.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101220 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Russell King <rmk@arm.linux.org.uk>,
        Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: INFO: task rcu_kthread:6 blocked for more than 120 seconds.
References: <20110112174300.GA6504@flint.arm.linux.org.uk> <20110112222219.GA17328@linux.vnet.ibm.com>
In-Reply-To: <20110112222219.GA17328@linux.vnet.ibm.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Provags-ID: V02:K0:iL+yc9izFEvq0gfPoopgxseJ81bEgA1RXBZRlk4NRRQ
 BjJaRtamWCPNDjMMCxyS/AvergbFLgv0GtCXQdrEF8VQLBKy0k
 iJvvVZIIrOSo88+MSgXX+Aes0nxZiD/h9qhzd17M5l+NcHjI43
 tRAJDETpAdxip8pn04+7A/G1DDzxr9tSbWX1TaepFDVAEYMou/
 ZkSUU/1TjzNxL6uliw4DQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 12.01.2011 23:22, schrieb Paul E. McKenney:
> On Wed, Jan 12, 2011 at 05:43:00PM +0000, Russell King wrote:
>> I'm seeing rcu_kthread get stuck from time to time on ARM Versatile PB
>> (ARM926).  Kernel is based upon commit 9e9bc973 (immediately prior to
>> the merge of the OMAP tree.)
>>
>> ~ # ps aux|grep rcu
>> root         6  0.0  0.0      0     0 ?        S    02:31   0:01 [rcu_kthread]
>> root       502  9.0  0.3   3740   472 ttyAMA0  S+   02:59   0:00 grep rcu
>> ~ # ps aux|grep rcu
>> root         6  0.0  0.0      0     0 ?        D    02:31   0:01 [rcu_kthread]
>> root       504  0.0  0.3   3740   472 ttyAMA0  S+   03:00   0:00 grep rcu
>> ~ # ps aux|grep rcu
>> root         6  0.0  0.0      0     0 ?        D    02:31   0:01 [rcu_kthread]
>> root       506  0.0  0.3   3740   472 ttyAMA0  S+   03:00   0:00 grep rcu
>> ~ # ps aux|grep rcu
>> root         6  0.0  0.0      0     0 ?        D    02:31   0:01 [rcu_kthread]
>> root       508  0.0  0.3   3740   472 ttyAMA0  S+   03:00   0:00 grep rcu
>> ~ # cat /proc/6/wchan
>> rcu_kthread
>> ~ # INFO: task rcu_kthread:6 blocked for more than 120 seconds.
>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> rcu_kthread     D c02c6684     0     6      2 0x00000000
>> Backtrace:
>> [<c02c6388>] (schedule+0x0/0x354) from [<c00836a0>] (rcu_kthread+0x78/0xf4)
>> [<c0083628>] (rcu_kthread+0x0/0xf4) from [<c00633ac>] (kthread+0x88/0x90)
>> [<c0063324>] (kthread+0x0/0x90) from [<c004d12c>] (do_exit+0x0/0x5f8)
>>  r7:00000013 r6:c004d12c r5:c0063324 r4:c181df28
>> no locks held by rcu_kthread/6.
> 
> Does the following patch help?
> 
> 							Thanx, Paul
> 
> ------------------------------------------------------------------------
> 
> commit 70ce43253a4465211a9c51e33d56a417c759a718
> Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Date:   Wed Jan 12 14:18:11 2011 -0800
> 
>     rcu: avoid pointless blocked-task warnings
>     
>     If the RCU callback-processing kthread has nothing to do, it parks in
>     a wait_event().  If RCU remains idle for more than two minutes, the
>     kernel complains about this.  This commit changes from wait_event()
>     to wait_event_interruptible() to prevent the kernel from complaining
>     just because RCU is idle.
>     
>     Reported-by: Russell King <rmk@arm.linux.org.uk>
>     Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
> index 0344937..0c343b9 100644
> --- a/kernel/rcutiny.c
> +++ b/kernel/rcutiny.c
> @@ -189,7 +189,8 @@ static int rcu_kthread(void *arg)
>  	unsigned long flags;
>  
>  	for (;;) {
> -		wait_event(rcu_kthread_wq, have_rcu_kthread_work != 0);
> +		wait_event_interruptible(rcu_kthread_wq,
> +					 have_rcu_kthread_work != 0);
>  		morework = rcu_boost();
>  		local_irq_save(flags);
>  		work = have_rcu_kthread_work;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Hello Paul,
here it helps. Tested on Devkit8000 (omap3, beagleboard clone). Without
this patch I had permanent crashes. With this patch board is running.

Tested-by: Thomas Weber <weber@corscience.de>


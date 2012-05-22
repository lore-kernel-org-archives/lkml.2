Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066Ab2EVQxD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 12:53:03 -0400
Received: from plane.gmane.org ([80.91.229.3]:50633 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753790Ab2EVQxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 12:53:00 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?ISO-8859-1?Q?J=F6rg-Volker_Peetz?= <jvpeetz@web.de>
Subject: Re: Linux 3.4 released
Date: Tue, 22 May 2012 18:52:49 +0200
Message-ID: <4FBBC461.4060008@web.de>
References: <CA+55aFwaobhbBZkE1LTyQJYhk8w8zk-cyOXXuXfPyE=BXzT3PA@mail.gmail.com> <4FBBB11D.7020904@web.de> <20120522155345.GC14339@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
Cc: linux-kernel@vger.kernel.org
X-Gmane-NNTP-Posting-Host: p5b371840.dip.t-dialin.net
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
In-Reply-To: <20120522155345.GC14339@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote, on 05/22/12 17:53:
> Hello,
> 
> On Tue, May 22, 2012 at 05:30:37PM +0200, Jörg-Volker Peetz wrote:
>> Switching from self-compiled kernel 3.2 17 to a self compiled kernel 3.4.0,
>> a notebook HP Pavilion dv7 gets hard locked with a kernel panic, when trying to
>> start a web-cam video viewer (guvcview) for the built-in USB web-cam.
>>
>> Please find attached a (hand-typed) screen-shot of the text-console and the
>> kernel config.
>>
>> By the way, thank you for all the great work on Linux.
>> -- 
>> Best regards,
>> Jörg-Volker.
> 
>> BUG: Unable to handle kernel NULL pointer dereference at 0000000000000008
> ...
>> Code: 8b 7c 24 50 48 83 c4 58 c3 66 66 66 2e 0f 1f 84 00 00 00 00 00 48 8b 0f 31 c0 48 89 fa 48 89 ce 40 80 e6 00 83 e1 04 48 0f 45 c6 <48> 8b 70 08 65 8b 3c 25 60 cc 00 00 e9 b9 fc ff ff 66 0f 1f 84
>> RIP  [<ffffffff8103ed46>] delayed_work_timer_fn+0x16/0x30
> 
> So, that looks like get_work_cwq() returning NULL and then
> delayed_work_timer_fn() trying to dereference it.  Either work item is
> being corrupted (e.g. freed early) or somebody is mucking with the
> work item embedded in a delayed work item.
> 
> Something like the following may reveal the offending work function.
> 
> Thanks.
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 5abf42f..adc1057 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -1101,6 +1101,10 @@ static void delayed_work_timer_fn(unsigned long __data)
>  	struct delayed_work *dwork = (struct delayed_work *)__data;
>  	struct cpu_workqueue_struct *cwq = get_work_cwq(&dwork->work);
>  
> +	if (!cwq)
> +		printk("XXX delayed_work_timer_fn: NULL cwq, fn=%pf\n",
> +		       dwork->work.func);
> +
>  	__queue_work(smp_processor_id(), cwq->wq, &dwork->work);
>  }
>  

Hello,

I tried the above patch but was not able to see a line beginning with "XXX", not
on the text-console nor in any log-file. After the hard-lock, I can see only the
console-screen which now changed slightly:

BUG: Unable to handle kernel NULL pointer dereference at 0000000000000008
IP: [<ffffffff8103ed60>] delayed_work_timer_fn+0x30/0x60
PGD 214fbc067 PUD 211c50067 PMD 0
Oops: 0000 [#1] SMP
CPU 1

...

Call Trace:
 <IRQ>
 [<ffffffff8103ed30>] ? __queu_work+0x320/0x320
 [<ffffffff810342c6>] ? run_timer_softirq+0x106/0x220
 [<ffffffff8105cc34>] ? tick_handle_oneshot_broadcast+0xb5/0xe0
 [<ffffffff8102f19d>] ? __do_softirq+0x8d/0x110
 [<ffffffff81069589>] ? handle_irq_event_percpu+0x79/0x140
 [<ffffffff813dfa8c>] ? call_softirq+0x1c/0x26
 [<ffffffff81003a8d>] ? do_softirq+0x4d/0x80
 [<ffffffff8102f495>] ? irq_exit+0xa5/0xb0
 [<ffffffff8100372b>] ? do_IRQ+0x5b/0xd0
 [<ffffffff813de227>] ? common_interrupt+0x67/0x67
 <EOI>
 [<ffffffff81009e60>] ? default_idle+0x20/0x40
 [<ffffffff81009ff8>] ? amd_e400_idle+0xa8/0xf0
 [<ffffffff8100a7a6>] ? cpu_idle+0xb6/0xd0

...

After that I have to press the power button until the computer switches off.
What else could I do?
-- 
Best regards,
Jörg-Volker.


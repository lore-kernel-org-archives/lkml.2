Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760122Ab2EVS00 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 14:26:26 -0400
Received: from plane.gmane.org ([80.91.229.3]:41061 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227Ab2EVS0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 14:26:25 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?ISO-8859-1?Q?J=F6rg-Volker_Peetz?= <jvpeetz@web.de>
Subject: Re: Linux 3.4 released
Date: Tue, 22 May 2012 20:26:04 +0200
Message-ID: <jpglns$1uj$1@dough.gmane.org>
References: <CA+55aFwaobhbBZkE1LTyQJYhk8w8zk-cyOXXuXfPyE=BXzT3PA@mail.gmail.com> <4FBBB11D.7020904@web.de> <20120522155345.GC14339@google.com> <4FBBC461.4060008@web.de> <20120522170320.GD14339@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: p5b371840.dip.t-dialin.net
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
In-Reply-To: <20120522170320.GD14339@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote, on 05/22/12 19:03:
> On Tue, May 22, 2012 at 06:52:49PM +0200, Jörg-Volker Peetz wrote:
>> I tried the above patch but was not able to see a line beginning with "XXX", not
>> on the text-console nor in any log-file. After the hard-lock, I can see only the
>> console-screen which now changed slightly:
>>
>> BUG: Unable to handle kernel NULL pointer dereference at 0000000000000008
>> IP: [<ffffffff8103ed60>] delayed_work_timer_fn+0x30/0x60
> 
> Oh, &cwq->wq is at offset 8 so cwq should have been -8.  Maybe I'm
> just confused.  Can you please try the following instead?
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 5abf42f..14babfe 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -1096,10 +1096,16 @@ queue_work_on(int cpu, struct workqueue_struct *wq, struct work_struct *work)
>  }
>  EXPORT_SYMBOL_GPL(queue_work_on);
>  
> +#include <linux/uaccess.h>
>  static void delayed_work_timer_fn(unsigned long __data)
>  {
>  	struct delayed_work *dwork = (struct delayed_work *)__data;
>  	struct cpu_workqueue_struct *cwq = get_work_cwq(&dwork->work);
> +	unsigned long v;
> +
> +	if (probe_kernel_read(&v, &cwq->wq, sizeof(v)))
> +		printk("XXX delayed_work_timer_fn: cwq %p, fn=%pf\n",
> +		       cwq, dwork->work.func);
>  
>  	__queue_work(smp_processor_id(), cwq->wq, &dwork->work);
>  }

Also with this second patch I wasn't able to see any output beginning with "XXX
delayed_work_timer_fn:". It should appear in the system log or on the text-console?

The screen dump starts with:

BUG: Unable to handle kernel NULL pointer dereference at 0000000000000008
IP: [<ffffffff........>] delayed_work_timer_fn+0x31/0x70

I didn't find the time to type more. Or did I miss the essential?
-- 
Best regards,
Jörg-Volker.


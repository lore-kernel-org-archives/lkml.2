Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965296Ab2EWT5B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 15:57:01 -0400
Received: from plane.gmane.org ([80.91.229.3]:36116 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964930Ab2EWT47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 15:56:59 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?ISO-8859-1?Q?J=F6rg-Volker_Peetz?= <jvpeetz@web.de>
Subject: Re: Linux 3.4 released
Date: Wed, 23 May 2012 21:56:36 +0200
Message-ID: <4FBD40F4.4090201@web.de>
References: <CA+55aFwaobhbBZkE1LTyQJYhk8w8zk-cyOXXuXfPyE=BXzT3PA@mail.gmail.com> <4FBBB11D.7020904@web.de> <20120522155345.GC14339@google.com> <4FBBC461.4060008@web.de> <20120522170320.GD14339@google.com> <jpglns$1uj$1@dough.gmane.org> <CAOS58YPMh_hbJ4a49j4p9H68n8U1LzMUuaxmHx57gVTkmfxF6A@mail.gmail.com> <4FBBEDF2.8060803@web.de> <20120523182457.GD18143@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
Cc: 0@plane.gmane.org, 0@plane.gmane.org, 0@plane.gmane.org
Cc: 0@plane.gmane.org, 0@plane.gmane.org, linux-kernel@vger.kernel.org
X-Gmane-NNTP-Posting-Host: p5b373b1f.dip.t-dialin.net
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
In-Reply-To: <20120523182457.GD18143@google.com>
Cc: 0@plane.gmane.org, 0@plane.gmane.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote, on 05/23/12 20:24:
> Hello, Jörg-Volker.
> 
> Please always use reply-to-all.
> 
> On Tue, May 22, 2012 at 09:50:10PM +0200, Jörg-Volker Peetz wrote:
>> no, changing to  printk(KERN_CRIT "XXX: ...", ...)  in kernel/workqueue.c didn't
>> print anything I could read. Would it appear before the "panic screen"? But I'm
>> not able to scroll back.
>> The Panic screen starts with
> 
> It should appear right above BUG:.  Can you please try the following
> instead?
> 
> Thanks.
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 5abf42f..57c33ef 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -1096,10 +1096,18 @@ queue_work_on(int cpu, struct workqueue_struct *wq, struct work_struct *work)
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
> +	if (probe_kernel_read(&v, &cwq->wq, sizeof(v))) {
> +		printk(KERN_CRIT "XXX delayed_work_timer_fn: cwq %p, fn=%pf\n",
> +		       cwq, dwork->work.func);
> +		return;
> +	}
>  
>  	__queue_work(smp_processor_id(), cwq->wq, &dwork->work);
>  }

Hello Tejun,

thank you for bearing with me. I applied this patch. When starting "guvcvideo"
now, the computer seems to work normally, i.e. this program shows the view from
the built-in USB web-cam on the screen. In the kernel log file it says:

May 23 21:32:33 hostname kernel: XXX delayed_work_timer_fn: cwq
(null), fn=hdmi_repoll_eld

(without line-break).

By the way, don't know if this is related, I have a phenomenon with a spurious
interrupt with every linux version I've used before on this notebook. Half a
minute after starting the system the computer produces approx. 220 lines like

... kernel: hda-intel: spurious response 0x0:0x0, last cmd=0x170503

Now with 3.4.0, I see an additional message right before (the minute before) the
"XXX ..." line:

...kernel: hda_intel: azx_get_response timeout, switching to single_cmd mode:
last cmd=0x003f0900

-- 
Best regards,
Jörg-Volker.



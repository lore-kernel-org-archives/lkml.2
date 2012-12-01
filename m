Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958Ab2LAEP6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 23:15:58 -0500
Received: from DMZ-MAILSEC-SCANNER-2.MIT.EDU ([18.9.25.13]:47579 "EHLO
	dmz-mailsec-scanner-2.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751352Ab2LAEP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 23:15:56 -0500
X-AuditID: 1209190d-b7f266d00000092b-05-50b9847b251a
Date: Fri, 30 Nov 2012 23:15:50 -0500 (EST)
From: Anders Kaseorg <andersk@MIT.EDU>
To: Tejun Heo <tj@kernel.org>
cc: Herbert Xu <herbert@gondor.hengli.com.au>,
        "John W. Linville" <linville@tuxdriver.com>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Wireless regression in workqueue: use mod_delayed_work() instead
 of __cancel + queue
In-Reply-To: <20121130225619.GD6021@htj.dyndns.org>
Message-ID: <alpine.DEB.2.00.1211302234410.25064@dr-wily.mit.edu>
References: <alpine.DEB.2.00.1211280953350.26602@dr-wily.mit.edu> <alpine.DEB.2.00.1211281016320.26602@dr-wily.mit.edu> <20121130211435.GJ3873@htj.dyndns.org> <20121130225619.GD6021@htj.dyndns.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJIsWRmVeSWpSXmKPExsUixCmqrFvdsjPA4NtFHot9G3ktLu+aw2bx
	ZsUddoutPRIWxxaIWfxafpTRgc3j23tZj02rOtk8rnxfzejxeZNcAEsUl01Kak5mWWqRvl0C
	V8aj6etZCzawVcw96dfA+J+li5GTQ0LAROL24xWsELaYxIV769lAbCGBfYwSD3tTuxi5gOwN
	jBKn5lxgg3D2MEkcWH2JEaSKRUBbYv/X6ewgNpuAmsTcDZPBbBEBWYkr0x4ygjQwCxxilLh6
	eDFYQlggWaKl8wKYzSlgLDHv3i5mEJtXwFFi16NXjBCrjzJKTPwgD2KLCuhK7D10hh2iRlDi
	5MwnYGczC2hJLJ++jWUCo8AsJKlZSFILGJlWMcqm5Fbp5iZm5hSnJusWJyfm5aUW6Rrp5WaW
	6KWmlG5iBIewJO8OxncHlQ4xCnAwKvHw7ni8I0CINbGsuDL3EKMkB5OSKK9m484AIb6k/JTK
	jMTijPii0pzUYqCvOJiVRHhlPwGV86YkVlalFuXDpKQ5WJTEea+k3PQXEkhPLEnNTk0tSC2C
	ycpwcChJ8PY3Aw0VLEpNT61Iy8wpQUgzcXCCDOcBGt4EUsNbXJCYW5yZDpE/xagoJc67HSQh
	AJLIKM2D64WlmFeM4kCvCPM+AKniAaYnuO5XQIOZgAa/WbYdZHBJIkJKqoGxQolJKPaWu33+
	pOeKq1/Lv/52/8SWK6ENwdMibGwrTdvPvO3yaN5ytPGdxbeEBy8eah93PJshwD9Nt9Z69r8X
	s1Q+h4cxfWj4s6yasc9rdcFrDbkr9iZ/+jsvfJ1r+2bP95e/Zj242if8dIHNoe32bu8010w1
	XRTl4OLr2vN/a+yKQHn7jscJSizFGYmGWsxFxYkAR9Fy9AwDAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Nov 2012, Tejun Heo wrote:
> Hey, again.
> 
> Can you please test whether the following patch makes any difference?
> 
> Thanks!
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 042d221..26368ef 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -1477,7 +1477,10 @@ bool mod_delayed_work_on(int cpu, struct workqueue_struct *wq,
>  	} while (unlikely(ret == -EAGAIN));
>  
>  	if (likely(ret >= 0)) {
> -		__queue_delayed_work(cpu, wq, dwork, delay);
> +		if (!delay)
> +			__queue_work(cpu, wq, &dwork->work);
> +		else
> +			__queue_delayed_work(cpu, wq, dwork, delay);
>  		local_irq_restore(flags);
>  	}
>  

Yes.  I tested that both directly on top of the bad commit, and on 
v3.7-rc7, and it fixes the bug in both cases.

Thanks,
Anders

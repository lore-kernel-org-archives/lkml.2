Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990Ab2DFSsb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 14:48:31 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:53280 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351Ab2DFSs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 14:48:29 -0400
X-Nat-Received: from [202.181.97.72]:60835 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1333712679.10466
To: levinsasha928@gmail.com, garlick@llnl.gov, ericvh@gmail.com
Cc: oleg@redhat.com, eric.dumazet@gmail.com, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davej@redhat.com
Subject: Re: ipv6: tunnel: hang when destroying ipv6 tunnel
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <CA+1xoqcAXyh306=2=QKWyM3BE44=MT+nsuRQn5YLOLgbtZqicA@mail.gmail.com>
	<CA+1xoqe1Wc_uifrKsko6hu+py9Ahz3Q0p1tRxup09jmh2NZ1rw@mail.gmail.com>
	<201204011221.GAG51016.JQFSFFOtLOMVHO@I-love.SAKURA.ne.jp>
	<CA+1xoqe+T=iUtUeFdeqmRvMZ7TMCgkLs_1QYv-4YNtn-jCoMCQ@mail.gmail.com>
	<201204052329.EBH52139.FFOLQMOJSVHOFt@I-love.SAKURA.ne.jp>
In-Reply-To: <201204052329.EBH52139.FFOLQMOJSVHOFt@I-love.SAKURA.ne.jp>
Message-Id: <201204062044.EJE13062.OLMQtSVFHOFOJF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Fri, 6 Apr 2012 20:44:37 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 06042012 #7635736, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa wrote:
> Most suspicious change is net/9p/client.c because it is changing handling of
> ERESTARTSYS case.
> 
> --- linux-3.3.1/net/9p/client.c
> +++ linux-next/net/9p/client.c
> @@ -740,10 +740,18 @@
>                         c->status = Disconnected;
>                 goto reterr;
>         }
> +again:
>         /* Wait for the response */
>         err = wait_event_interruptible(*req->wq,
>                                        req->status >= REQ_STATUS_RCVD);
> 
> +       if ((err == -ERESTARTSYS) && (c->status == Connected)
> +                                 && (type == P9_TFLUSH)) {
> +               sigpending = 1;
> +               clear_thread_flag(TIF_SIGPENDING);
> +               goto again;
> +       }
> +

I think this loop is bad with regard to response to SIGKILL.
If wait_event_interruptible() was interrupted by SIGKILL, it will
spin until req->status >= REQ_STATUS_RCVD becomes true.
Rather,

	if ((c->status == Connected) && (type == P9_TFLUSH))
		err = wait_event_killable(*req->wq,
					  req->status >= REQ_STATUS_RCVD);
	else
		err = wait_event_interruptible(*req->wq,
					       req->status >= REQ_STATUS_RCVD);

would be safer.



>  error:
>         /*
>          * Fid is not valid even after a failed clunk
> +        * If interrupted, retry once then give up and
> +        * leak fid until umount.
>          */
> -       p9_fid_destroy(fid);
> +       if (err == -ERESTARTSYS) {
> +               if (retries++ == 0)
> +                       goto again;

I think it is possible that the process is interrupted again upon retrying.
I suspect the handling of err == -ERESTARTSYS case when retries != 0.
It is returning without calling p9_fid_destroy(), which will be
unexpected behaviour for the various callers.

> +       } else
> +               p9_fid_destroy(fid);
>         return err;
>  }
>  EXPORT_SYMBOL(p9_client_clunk);

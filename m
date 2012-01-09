Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102Ab2AIFSM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 00:18:12 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:39364 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364Ab2AIFSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 00:18:11 -0500
Date: Mon, 9 Jan 2012 10:48:08 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [PATCH] kprobe: fix a memory leak in function
	pre_handler_kretprobe()
Message-ID: <20120109051808.GA20666@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <4F07261A.6080403@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F07261A.6080403@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
x-cbid: 12010905-5806-0000-0000-00001132632B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 07, 2012 at 12:49:30AM +0800, Jiang Liu wrote:
> From: Jiang Liu<liuj97@gmail.com>
>
> In function pre_handler_kretprobe(), the allocated kretprobe_instance object will
> be leaked if the entry_handler callback returns non-zero. This may cause all the
> preallocated kretprobe_instance objects exhausted. This issue could be reproduced
> by changing samples/kprobes/kretprobe_example.c to probe "mutex_unlock". And the
> fix is straight forward, just put the allocated kretprobe_instance object back
> onto the free_instances list.
>
> Signed-off-by: Jiang Liu<liuj97@gmail.com>
> Cc: Hien Nguyen<hien@us.ibm.com>
> Cc: Jim Keniston<jkenisto@us.ibm.com>
> Cc: Prasanna S Panchamukhi<prasanna@in.ibm.com>

Thanks for the patch.

Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

> ---
>  kprobes.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -1660,8 +1660,12 @@
>                 ri->rp = rp;
>                 ri->task = current;
>
> -               if (rp->entry_handler&&  rp->entry_handler(ri, regs))
> +               if (rp->entry_handler&&  rp->entry_handler(ri, regs)) {
> +                       spin_lock_irqsave(&rp->lock, flags);
> +                       hlist_add_head(&ri->hlist,&rp->free_instances);
> +                       spin_unlock_irqrestore(&rp->lock, flags);
>                         return 0;
> +               }

Please fix up coding style issues and resend with acks from Jim and me.
Please also cc stable@kernel.org so this gets included in the earlier
kernels too.

Ananth


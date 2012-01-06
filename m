Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030427Ab2AFR4n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 12:56:43 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:46060 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758300Ab2AFR4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 12:56:41 -0500
Subject: Re: [PATCH] kprobe: fix a memory leak in function
 pre_handler_kretprobe()
From: Jim Keniston <jkenisto@linux.vnet.ibm.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
In-Reply-To: <4F07261A.6080403@gmail.com>
References: <4F07261A.6080403@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 Jan 2012 09:56:01 -0800
Message-ID: <1325872561.3351.10.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
x-cbid: 12010617-9360-0000-0000-0000022CA2D3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-01-07 at 00:49 +0800, Jiang Liu wrote:
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

Acked-by: Jim Keniston <jkenisto@us.ibm.com>

BTW, Prasanna is no longer at IBM, and Hien's address is
hienqngu@us.ibm.com .  Ananth (cc-ed) is probably IBM's best kprobes
reviewer.

> ---
>   kprobes.c |    6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -1660,8 +1660,12 @@
>                  ri->rp = rp;
>                  ri->task = current;
> 
> -               if (rp->entry_handler&&  rp->entry_handler(ri, regs))
> +               if (rp->entry_handler&&  rp->entry_handler(ri, regs)) {
> +                       spin_lock_irqsave(&rp->lock, flags);
> +                       hlist_add_head(&ri->hlist,&rp->free_instances);
> +                       spin_unlock_irqrestore(&rp->lock, flags);
>                          return 0;
> +               }
> 
>                  arch_prepare_kretprobe(ri, regs);
> 
> 



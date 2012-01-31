Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab2AaVfO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 16:35:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34849 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466Ab2AaVfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 16:35:12 -0500
Date: Tue, 31 Jan 2012 13:35:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiang Liu <liuj97@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jim Keniston <jkenisto@us.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>, stable@vger.kernel.org
Subject: Re: [PATCH] kprobes: fix a memory leak in function
 pre_handler_kretprobe()
Message-Id: <20120131133510.c53cb790.akpm@linux-foundation.org>
In-Reply-To: <1327939812-17157-1-git-send-email-jiang.liu@huawei.com>
References: <1327939812-17157-1-git-send-email-jiang.liu@huawei.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jan 2012 00:10:12 +0800
Jiang Liu <liuj97@gmail.com> wrote:

> In function pre_handler_kretprobe(), the allocated kretprobe_instance object
> will get leaked if the entry_handler callback returns non-zero. This may cause
> all the preallocated kretprobe_instance objects exhausted. This issue could be
> reproduced by changing samples/kprobes/kretprobe_example.c to probe
> "mutex_unlock". And the fix is straight forward, just put the allocated
> kretprobe_instance object back onto the free_instances list.
> 
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Acked-by: Jim Keniston <jkenisto@us.ibm.com>
> Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> CC: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> CC: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
> CC: "David S. Miller" <davem@davemloft.net>
> CC: stable@vger.kernel.org
> ---
>  kernel/kprobes.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index e5d8464..2423295 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -1673,8 +1673,12 @@ static int __kprobes pre_handler_kretprobe(struct kprobe *p,
>  		ri->rp = rp;
>  		ri->task = current;
>  
> -		if (rp->entry_handler && rp->entry_handler(ri, regs))
> +		if (rp->entry_handler && rp->entry_handler(ri, regs)) {
> +			spin_lock_irqsave(&rp->lock, flags);
> +			hlist_add_head(&ri->hlist, &rp->free_instances);
> +			spin_unlock_irqrestore(&rp->lock, flags);
>  			return 0;
> +		}
>  

kernel/kprobes.c: In function 'pre_handler_kretprobe':
kernel/kprobes.c:1677: warning: passing argument 1 of 'spinlock_check' from incompatible pointer type
include/linux/spinlock.h:272: note: expected 'struct spinlock_t *' but argument is of type 'struct raw_spinlock_t *'
kernel/kprobes.c:1679: warning: passing argument 1 of 'spin_unlock_irqrestore' from incompatible pointer type
include/linux/spinlock.h:338: note: expected 'struct spinlock_t *' but argument is of type 'struct raw_spinlock_t *'

--- a/kernel/kprobes.c~kprobes-fix-a-memory-leak-in-function-pre_handler_kretprobe-fix
+++ a/kernel/kprobes.c
@@ -1674,9 +1674,9 @@ static int __kprobes pre_handler_kretpro
 		ri->task = current;
 
 		if (rp->entry_handler && rp->entry_handler(ri, regs)) {
-			spin_lock_irqsave(&rp->lock, flags);
+			raw_spin_lock_irqsave(&rp->lock, flags);
 			hlist_add_head(&ri->hlist, &rp->free_instances);
-			spin_unlock_irqrestore(&rp->lock, flags);
+			raw_spin_unlock_irqrestore(&rp->lock, flags);
 			return 0;
 		}
 

I'm surprised you didn't notice the warning spew.  How well tested is
this code?


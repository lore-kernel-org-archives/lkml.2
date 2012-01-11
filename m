Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757631Ab2AKQMG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 11:12:06 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:36377 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932918Ab2AKQMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 11:12:03 -0500
Date: Wed, 11 Jan 2012 21:42:33 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jun Ma <harry.majun@huawei.com>,
        stable@vger.kernel.org, Jiang Liu <jiang.liu@huawei.com>
Subject: Re: [PATCH] kprobes: fix a memory leak in function
	pre_handler_kretprobe()
Message-ID: <20120111161233.GA13539@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <1326295311-10985-1-git-send-email-jiang.liu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326295311-10985-1-git-send-email-jiang.liu@huawei.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
x-cbid: 12011116-1780-0000-0000-0000023990B1
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000244; HX=3.00000180; KW=3.00000007;
 PH=3.00000001; SC=3.00000001; SDB=6.00104040; UDB=6.00026376; UTC=2012-01-11
 16:12:02
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 11:21:51PM +0800, Jiang Liu wrote:
> From: Jiang Liu <liuj97@gmail.com>
> 
> In function pre_handler_kretprobe(), the allocated kretprobe_instance object
> will be leaked if the entry_handler callback returns non-zero. This may cause
> all the preallocated kretprobe_instance objects exhausted. This issue could be
> reproduced by changing samples/kprobes/kretprobe_example.c to probe 
> "mutex_unlock". And the fix is straight forward, just put the allocated 
> kretprobe_instance object back onto the free_instances list. 
> 
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Acked-by: Jim Keniston <jkenisto@us.ibm.com>
> Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

Thank you Jiang. I think the correct ID for stable is now
stable@vger.kernel.org.

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
>  		arch_prepare_kretprobe(ri, regs);
> 
> -- 
> 1.7.5.4


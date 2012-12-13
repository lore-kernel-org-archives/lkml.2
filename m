Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891Ab2LMK5M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 05:57:12 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:53757 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415Ab2LMK5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 05:57:10 -0500
Date: Thu, 13 Dec 2012 15:56:39 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] uprobes: _register() should always do
 register_for_each_vma(true)
Message-ID: <20121213102639.GB29086@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20121123202741.GA18858@redhat.com>
 <20121123202817.GA18907@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20121123202817.GA18907@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121310-2876-0000-0000-00000316309E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-11-23 21:28:17]:

> To support the filtering uprobe_register() should do
> register_for_each_vma(true) every time the new consumer comes,
> we need to install the previously nacked breakpoints.
> 
> Note:
> 	- uprobes_mutex[] should die, what is actually protects is
> 	  alloc_uprobe().
> 
> 	- UPROBE_RUN_HANDLER should die too, obviously it can't work
> 	  unless uprobe has a single consumer. The consumer should
> 	  serialize with _register/_unregister itself. Or this flag
> 	  should live in uprobe_consumer->state.
> 
> 	- Perhaps we can do some optimizations later. For example, if
> 	  filter_chain() never returns false uprobe can record this
> 	  fact and avoid the unnecessary register_for_each_vma().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>


Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

> ---
>  kernel/events/uprobes.c |   31 +++++++++++++------------------
>  1 files changed, 13 insertions(+), 18 deletions(-)
> 
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index 7c98671..c80507d 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -482,16 +482,12 @@ static void handler_chain(struct uprobe *uprobe, struct pt_regs *regs)
>  	up_read(&uprobe->consumer_rwsem);
>  }
> 
> -/* Returns the previous consumer */
> -static struct uprobe_consumer *
> -consumer_add(struct uprobe *uprobe, struct uprobe_consumer *uc)
> +static void consumer_add(struct uprobe *uprobe, struct uprobe_consumer *uc)
>  {
>  	down_write(&uprobe->consumer_rwsem);
>  	uc->next = uprobe->consumers;
>  	uprobe->consumers = uc;
>  	up_write(&uprobe->consumer_rwsem);
> -
> -	return uc->next;
>  }
> 
>  /*
> @@ -820,9 +816,15 @@ static int register_for_each_vma(struct uprobe *uprobe, bool is_register)
>  	return err;
>  }
> 
> -static int __uprobe_register(struct uprobe *uprobe)
> +static int __uprobe_register(struct uprobe *uprobe, struct uprobe_consumer *uc)
>  {
> -	return register_for_each_vma(uprobe, true);
> +	int err;
> +
> +	consumer_add(uprobe, uc);
> +	err = register_for_each_vma(uprobe, true);
> +	if (!err) /* TODO: pointless unless the first consumer */
> +		set_bit(UPROBE_RUN_HANDLER, &uprobe->flags);
> +	return err;
>  }
> 
>  static void __uprobe_unregister(struct uprobe *uprobe, struct uprobe_consumer *uc)
> @@ -867,21 +869,14 @@ int uprobe_register(struct inode *inode, loff_t offset, struct uprobe_consumer *
>  	if (offset > i_size_read(inode))
>  		return -EINVAL;
> 
> -	ret = 0;
> +	ret = -ENOMEM;
>  	mutex_lock(uprobes_hash(inode));
>  	uprobe = alloc_uprobe(inode, offset);
> -
> -	if (!uprobe) {
> -		ret = -ENOMEM;
> -	} else if (!consumer_add(uprobe, uc)) {
> -		ret = __uprobe_register(uprobe);
> -		if (ret) {
> +	if (uprobe) {
> +		ret = __uprobe_register(uprobe, uc);
> +		if (ret)
>  			__uprobe_unregister(uprobe, uc);
> -		} else {
> -			set_bit(UPROBE_RUN_HANDLER, &uprobe->flags);
> -		}
>  	}
> -
>  	mutex_unlock(uprobes_hash(inode));
>  	if (uprobe)
>  		put_uprobe(uprobe);
> -- 
> 1.5.5.1
> 


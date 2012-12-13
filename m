Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932605Ab2LMOnk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:43:40 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:44679 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932448Ab2LMOng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:43:36 -0500
Date: Thu, 13 Dec 2012 19:42:46 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] uprobes: Change filter_chain() to iterate
 ->consumers list
Message-ID: <20121213141246.GC3902@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20121124180213.GA30963@redhat.com>
 <20121124180231.GA30983@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20121124180231.GA30983@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121314-7182-0000-0000-000003C33564
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-11-24 19:02:31]:

> Now that it safe to use ->consumer_rwsem under ->mmap_sem we can
> almost finish the implementation of filter_chain(). It still lacks
> the actual uc->filter(...) call but othewrwise it is ready, just
> it pretends that ->filter() always returns true.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>


Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

> ---
>  kernel/events/uprobes.c |   21 +++++++++++++--------
>  1 files changed, 13 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index 03ffbb5..873c993 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -614,14 +614,19 @@ static int prepare_uprobe(struct uprobe *uprobe, struct file *file,
> 
>  static bool filter_chain(struct uprobe *uprobe)
>  {
> -	/*
> -	 * TODO:
> -	 *	for_each_consumer(uc)
> -	 *		if (uc->filter(...))
> -	 *			return true;
> -	 *	return false;
> -	 */
> -	return uprobe->consumers != NULL;
> +	struct uprobe_consumer *uc;
> +	bool ret = false;
> +
> +	down_read(&uprobe->consumer_rwsem);
> +	for (uc = uprobe->consumers; uc; uc = uc->next) {
> +		/* TODO: ret = uc->filter(...) */
> +		ret = true;
> +		if (ret)
> +			break;
> +	}
> +	up_read(&uprobe->consumer_rwsem);
> +
> +	return ret;
>  }
> 
>  static int
> -- 
> 1.5.5.1
> 


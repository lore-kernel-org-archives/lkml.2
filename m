Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932421Ab0FULqU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 07:46:20 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54227 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932377Ab0FULpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 07:45:50 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mempolicy: reduce stack size of migrate_pages()
Cc: kosaki.motohiro@jp.fujitsu.com,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100618143851.0661daa2.akpm@linux-foundation.org>
References: <20100616130040.3831.A69D9226@jp.fujitsu.com> <20100618143851.0661daa2.akpm@linux-foundation.org>
Message-Id: <20100621090550.B4F8.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 21 Jun 2010 20:45:47 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  	const struct cred *cred = current_cred(), *tcred;
> > -	struct mm_struct *mm;
> > +	struct mm_struct *mm = NULL;
> >  	struct task_struct *task;
> > -	nodemask_t old;
> > -	nodemask_t new;
> >  	nodemask_t task_nodes;
> >  	int err;
> > +	NODEMASK_SCRATCH(scratch);
> > +	nodemask_t *old = &scratch->mask1;
> > +	nodemask_t *new = &scratch->mask2;
> >
> > +	if (!scratch)
> > +		return -ENOMEM;
> 
> It doesn't matter in practice, but it makes me all queazy to see code
> which plays with pointers which might be NULL.

I see. thanks.
Do we need to send you updated patch?


> 
> --- a/mm/mempolicy.c~mempolicy-reduce-stack-size-of-migrate_pages-fix
> +++ a/mm/mempolicy.c
> @@ -1279,13 +1279,16 @@ SYSCALL_DEFINE4(migrate_pages, pid_t, pi
>  	struct task_struct *task;
>  	nodemask_t task_nodes;
>  	int err;
> +	nodemask_t *old;
> +	nodemask_t *new;
>  	NODEMASK_SCRATCH(scratch);
> -	nodemask_t *old = &scratch->mask1;
> -	nodemask_t *new = &scratch->mask2;
>  
>  	if (!scratch)
>  		return -ENOMEM;
>  
> +	old = &scratch->mask1;
> +	new = &scratch->mask2;
> +
>  	err = get_nodes(old, old_nodes, maxnode);
>  	if (err)
>  		goto out;
> _
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/




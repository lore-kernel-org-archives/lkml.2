Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324Ab0F3VjO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 17:39:14 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:50970 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754130Ab0F3VjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 17:39:12 -0400
To: kees.cook@canonical.com, eparis@parisplace.org
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Yama: add PTRACE exception tracking
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20100630003844.GE4837@outflux.net>
	<20100630004027.GG4837@outflux.net>
	<AANLkTim_RShqD7CKwjyeeGf3-1NZaVE4K2XUlrsoS1xx@mail.gmail.com>
	<20100630155345.GN4837@outflux.net>
In-Reply-To: <20100630155345.GN4837@outflux.net>
Message-Id: <201007010639.FDJ17674.JFQOStOFFMHOVL@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Thu, 1 Jul 2010 06:39:05 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook wrote:
> @@ -41,18 +41,30 @@ static DEFINE_SPINLOCK(ptracer_relations_lock);
>  static int yama_ptracer_add(struct task_struct *tracer,
>  			    struct task_struct *tracee)
>  {
> -	struct ptrace_relation *relation;
> +	int rc = 0;
> +	struct ptrace_relation *entry, *relation = NULL;
>  
> -	relation = kmalloc(sizeof(*relation), GFP_KERNEL);
> -	if (!relation)
> -		return -ENOMEM;
> -	relation->tracer = tracer;
> -	relation->tracee = tracee;
>  	spin_lock(&ptracer_relations_lock);
> -	list_add(&relation->node, &ptracer_relations);
> +	list_for_each_entry(entry, &ptracer_relations, node)
> +		if (entry->tracee == tracee) {
> +			relation = entry;
> +			break;
> +		}
> +	if (!relation) {
> +		relation = kmalloc(sizeof(*relation), GFP_KERNEL);

You can't use GFP_KERNEL here because a spinlock is held.

> +		if (!relation) {
> +			rc = -ENOMEM;
> +			goto unlock_out;
> +		}
> +		relation->tracee = tracee;
> +		list_add(&relation->node, &ptracer_relations);
> +	}
> +	relation->tracer = tracer;
> +
> +unlock_out:
>  	spin_unlock(&ptracer_relations_lock);
>  
> -	return 0;
> +	return rc;
>  }

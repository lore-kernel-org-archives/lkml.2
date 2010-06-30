Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496Ab0F3BKE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 21:10:04 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:60935 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858Ab0F3BKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 21:10:00 -0400
Message-Id: <201006300109.o5U19s1N043912@www262.sakura.ne.jp>
Subject: Re: [PATCH 2/2] Yama: add PTRACE exception tracking
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: kees.cook@canonical.com
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Wed, 30 Jun 2010 10:09:54 +0900
References: <20100630003844.GE4837@outflux.net> <20100630004027.GG4837@outflux.net>
In-Reply-To: <20100630004027.GG4837@outflux.net>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 29062010 #4014306, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook wrote:
> +static spinlock_t ptracer_relations_lock;
static DEFINE_SPINLOCK(ptracer_relations_lock);

> +static int yama_ptracer_add(struct task_struct *tracer,
> +			    struct task_struct *tracee)
> +{
> +	struct ptrace_relation *relation;
> +
> +	relation = kzalloc(sizeof(*relation), GFP_KERNEL);
You can use kmalloc() since all fields are initialized within this function.
> +	if (!relation)
> +		return -ENOMEM;
> +	relation->tracer = tracer;
> +	relation->tracee = tracee;
> +	spin_lock(&ptracer_relations_lock);
> +	list_add(&relation->node, &ptracer_relations);
> +	spin_unlock(&ptracer_relations_lock);
> +
> +	return 0;
> +}

> +static int ptracer_exception_found(struct task_struct *tracer,
> +				   struct task_struct *tracee)
> +{
> +	int rc = 0;
> +	struct ptrace_relation *relation;
> +	struct task_struct *parent = NULL;
> +
> +	spin_lock(&ptracer_relations_lock);
> +	list_for_each_entry(relation, &ptracer_relations, node)
> +		if (relation->tracee == tracee) {
> +			parent = relation->tracer;
> +			break;
> +		}
> +	if (task_is_descendant(parent, tracer))
> +		rc = 1;
> +	spin_unlock(&ptracer_relations_lock);

Can't we release ptracer_relations_lock before calling
task_is_descendant() since task_is_descendant() won't
access "struct ptrace_relation" on ptracer_relations list.

> @@ -32,27 +204,20 @@ static int yama_ptrace_access_check(struct task_struct *child,
>  {
>  	int rc;
>  
> +	/* If standard caps disallows it, so does Yama.  We should
> +	 * should only tighten restrictions further.
s/should should/should/
> +	 */

> @@ -221,6 +388,8 @@ static __init int yama_init(void)
>  
>  	printk(KERN_INFO "Yama: becoming mindful.\n");
>  
> +	spin_lock_init(&ptracer_relations_lock);
> +
You can statically initialize by using DEFINE_SPINLOCK().

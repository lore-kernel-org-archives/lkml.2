Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab1DUUQa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 16:16:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31788 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754195Ab1DUUQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 16:16:29 -0400
Date: Thu, 21 Apr 2011 22:15:37 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Stas Sergeev <stsp@aknet.ru>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [path][rfc] add PR_DETACH prctl command [2/2]
Message-ID: <20110421201537.GB12248@redhat.com>
References: <20110405151549.GB17490@redhat.com> <4D9B4265.6080403@aknet.ru> <20110405164557.GA23248@redhat.com> <4DADA22A.1010205@aknet.ru> <20110419155830.7ad33312@lxorguk.ukuu.org.uk> <4DADA581.9060700@aknet.ru> <20110419165429.71cb1508@lxorguk.ukuu.org.uk> <4DAEDC3F.5010208@aknet.ru> <20110420165023.GA24455@redhat.com> <4DB000A6.5060409@aknet.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DB000A6.5060409@aknet.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21, Stas Sergeev wrote:
>
> Attaching the fixed patch.
> Changes:
> - in wait_task_consider(), pr_detach hides the process
> only in !ptrace case
> ...
> @@ -1555,6 +1600,14 @@ static int wait_consider_task(struct wait_opts *wo, int ptrace,
>  	if (p->exit_state == EXIT_ZOMBIE && !delay_group_leader(p))
>  		return wait_task_zombie(wo, p);
>  
> +	if (unlikely(p->pr_detached)) {
> +		if (p->detaching)
> +			return wait_task_detached(wo, p);
> +		/* pr_detached tasks are hidden from parent */
> +		if (!ptrace)
> +			return 0;
> +	}

Hmm... I guess this should fix ptrace? How? I dont understand this at all.

Stas, I bet you didn't test your patch. If the old parent traces the child
WEXITED should not succeed until the child really exits. Otherwise it is
easy to escape ptrace.

Oh. And I bet there are other problems. Say, exec can change the leader...
Easy to fix, but note that we need more and more stupid pr_detached special
cases.

Stas, sorry. I am not going to looks at the next versions. Until you
convince lkml we need this feature.

Oleg.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630Ab0FWToG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 15:44:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11054 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752441Ab0FWToD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 15:44:03 -0400
Date: Wed, 23 Jun 2010 21:41:45 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Kees Cook <kees.cook@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Neil Horman <nhorman@tuxdriver.com>, Roland McGrath <roland@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] sanitize task->comm to avoid leaking escape codes
Message-ID: <20100623194145.GA19628@redhat.com>
References: <20100623181129.GM5876@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100623181129.GM5876@outflux.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23, Kees Cook wrote:
>
> @@ -956,7 +957,15 @@ void set_task_comm(struct task_struct *tsk, char *buf)
>  	 */
>  	memset(tsk->comm, 0, TASK_COMM_LEN);
>  	wmb();

Off-topic. I'd wish I could understand this barrier. Since the lockless
reader doesn't do rmb() I don't see how this can help. OTOH, I don't
understand why it is needed, we never change ->comm[TASK_COMM_LEN-1] == '0'.

> -	strlcpy(tsk->comm, buf, sizeof(tsk->comm));
> +
> +	/* sanitize non-printable characters */
> +	for (i = 0; buf[i] && i < (sizeof(tsk->comm) - 1); i++) {
> +		if (!isprint(buf[i]))
> +			tsk->comm[i] = '?';
> +		else
> +			tsk->comm[i] = buf[i];
> +	}

Personally I think this makes sense.

> -extern char *get_task_comm(char *to, struct task_struct *tsk);
> +#define get_task_comm(buf, task) get_task_comm_size(buf, sizeof(buf), task)
> +extern char *get_task_comm_size(char *to, size_t len, struct task_struct *tsk);

Oh, but this means that get_task_comm(ptr, task) doesn't work?

Oleg.


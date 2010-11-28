Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab0K1TOU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 14:14:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25605 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753866Ab0K1TOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 14:14:18 -0500
Date: Sun, 28 Nov 2010 20:07:42 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH UPDATED 06/14] signal: use GROUP_STOP_PENDING to avoid
	stopping multiple times for a single group stop
Message-ID: <20101128190741.GA12896@redhat.com>
References: <1290768569-16224-1-git-send-email-tj@kernel.org> <1290768569-16224-7-git-send-email-tj@kernel.org> <4CF0EE11.6000206@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CF0EE11.6000206@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27, Tejun Heo wrote:
>
>  static int recalc_sigpending_tsk(struct task_struct *t)
>  {
> -	if (t->signal->group_stop_count > 0 ||
> +	if ((t->group_stop & GROUP_STOP_PENDING) ||

OK, this makes the intent clear.

> @@ -732,6 +732,9 @@ static int prepare_signal(int sig, struct task_struct *p, int from_ancestor_ns)
>  		t = p;
>  		do {
>  			unsigned int state;
> +
> +			t->group_stop = 0;
> +

Yes.

But, afaics, this is not enough. Say, what about zap_other_threads() ?
We shouldn't allow sub-threads to stop in this case.

Basically, every time we clear ->group_stop_count we should also reset
->group_stop for every thread. Fortunately, every time we already do
while_each_thread().

Oleg.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461Ab1BNNc6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 08:32:58 -0500
Received: from www.tglx.de ([62.245.132.106]:59060 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755424Ab1BNNc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 08:32:56 -0500
Date: Mon, 14 Feb 2011 14:32:23 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Kirill A. Shutsemov" <kirill@shutemov.name>
cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, jacob.jun.pan@linux.intel.com,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        Matt Helsley <matthltc@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-api@vger.kernel.org
Subject: Re: [PATCH, v6 2/3] Implement timer slack notifier chain
In-Reply-To: <1297688787-3592-3-git-send-email-kirill@shutemov.name>
Message-ID: <alpine.LFD.2.00.1102141428080.26192@localhost6.localdomain6>
References: <1297688787-3592-1-git-send-email-kirill@shutemov.name> <1297688787-3592-3-git-send-email-kirill@shutemov.name>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Feb 2011, Kirill A. Shutsemov wrote:

> From: Kirill A. Shutemov <kirill@shutemov.name>
> 
> Process can change its timer slack using prctl(). Timer slack notifier
> call chain allows to react on such change or forbid it.

So we add a notifier call chain and more exports to allow what ?
 
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -1691,15 +1691,10 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
>  			error = perf_event_task_enable();
>  			break;
>  		case PR_GET_TIMERSLACK:
> -			error = current->timer_slack_ns;
> +			error = prctl_get_timer_slack();

  What's the point of replacing current->timer_slack_ns with a
  function which does exactly the same ?

> +long prctl_set_timer_slack(long timer_slack_ns)
> +{
> +	int err;
> +
> +	/* Reset timer slack to default value */
> +	if (timer_slack_ns <= 0) {
> +		current->timer_slack_ns = current->default_timer_slack_ns;
> +		return 0;

  That does not make any sense at all. Why is setting
  default_timer_slack_ns not subject to validation ? Why is it
  treaded seperately ?

> +	}
> +
> +	err = blocking_notifier_call_chain(&timer_slack_notify_list,
> +			timer_slack_ns, NULL);
> +	if (err == NOTIFY_DONE)
> +		current->timer_slack_ns = timer_slack_ns;
> +
> +	return notifier_to_errno(err);

Thanks,

	tglx

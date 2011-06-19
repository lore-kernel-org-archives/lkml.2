Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab1FSKE7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 06:04:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28275 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752886Ab1FSKE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 06:04:57 -0400
Message-ID: <4DFDC9BD.8080008@redhat.com>
Date: Sun, 19 Jun 2011 13:04:45 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Eric B Munson <emunson@mgebm.net>
Subject: Re: [PATCH v2 5/7] KVM-GST: KVM Steal time accounting
References: <1308262856-5779-1-git-send-email-glommer@redhat.com> <1308262856-5779-6-git-send-email-glommer@redhat.com>
In-Reply-To: <1308262856-5779-6-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2011 01:20 AM, Glauber Costa wrote:
> This patch accounts steal time time in kernel/sched.
> I kept it from last proposal, because I still see advantages
> in it: Doing it here will give us easier access from scheduler
> variables such as the cpu rq. The next patch shows an example of
> usage for it.
>
> Since functions like account_idle_time() can be called from
> multiple places, not only account_process_tick(), steal time
> grabbing is repeated in each account function separatedely.
>
>   /*
> + * We have to at flush steal time information every time something else
> + * is accounted. Since the accounting functions are all visible to the rest
> + * of the kernel, it gets tricky to do them in one place. This helper function
> + * helps us.
> + *
> + * When the system is idle, the concept of steal time does not apply. We just
> + * tell the underlying hypervisor that we grabbed the data, but skip steal time
> + * accounting
> + */
> +static inline bool touch_steal_time(int is_idle)
> +{
> +	u64 steal, st = 0;
> +
> +	if (static_branch(&paravirt_steal_enabled)) {
> +
> +		steal = paravirt_steal_clock(smp_processor_id());
> +
> +		steal -= this_rq()->prev_steal_time;
> +		if (is_idle) {
> +			this_rq()->prev_steal_time += steal;
> +			return false;
> +		}
> +
> +		while (steal>= TICK_NSEC) {
> +			/*
> +			 * Inline assembly required to prevent the compiler
> +			 * optimising this loop into a divmod call.
> +			 * See __iter_div_u64_rem() for another example of this.
> +			 */

Why not use said function?

> +			asm("" : "+rm" (steal));
> +
> +			steal -= TICK_NSEC;
> +			this_rq()->prev_steal_time += TICK_NSEC;
> +			st++;

Suppose a live migration or SIGSTOP causes lots of steal time.  How long 
will we spend here?

> +		}
> +
> +		account_steal_time(st);
> +		return !!st;

!! !needed, you're returning a bool.

> +	}
> +	return false;
> +}
> +

I'll need Peter's (or another sched maintainer's) review to apply this.

-- 
error compiling committee.c: too many arguments to function


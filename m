Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751717Ab2AZI7W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 03:59:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33377 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab2AZI7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 03:59:21 -0500
Date: Thu, 26 Jan 2012 01:05:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitry Antipov <dmitry.antipov@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        patches@linaro.org
Subject: Re: [PATCH] hrtimers: teach usleep_range() to return how many usecs
 was slept
Message-Id: <20120126010516.c5af4a4e.akpm@linux-foundation.org>
In-Reply-To: <1326718403-28156-1-git-send-email-dmitry.antipov@linaro.org>
References: <1326718403-28156-1-git-send-email-dmitry.antipov@linaro.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jan 2012 16:53:23 +0400 Dmitry Antipov <dmitry.antipov@linaro.org> wrote:

> Teach usleep_range() to return how many usecs was actually spent
> in sleep. The rationale beyond this is to convert jiffies-based
> wait-for-hardware loops like:
> 
> unsigned long timeout = jiffies + msecs_to_jiffies(1000);
> while (hw_is_not_ready()) {
> 	if (time_after(jiffies, timeout))
> 		return -ETIMEDOUT;
> 	msleep(1);
> }
> 
> to:
> 
> unsigned long timeout = 0;
> while (hw_is_not_ready()) {
>       if (timeout > USEC_PER_SEC)
> 	      return -ETIMEDOUT;
>       timeout += usleep_range(1000, 2000);
> }
> 

Is that useful enough to justify making the change?

>
>  int __sched schedule_hrtimeout_range(ktime_t *expires, unsigned long delta,
> -				     const enum hrtimer_mode mode)
> +				     const enum hrtimer_mode mode, unsigned long *elapsed)

Rather than adding another argument, I suggest you change the return
type to long and use return value semantics similar to schedule_timeout().

schedule_timeout() never returns -ve numbers and it returns jiffies,
but it will be close(r).

Returning usecs is odd.  One would expect it to return a ktime_t.  That
might inflict some code-size cost in callers.


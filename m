Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964973Ab0COO3x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 10:29:53 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:46015 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964961Ab0COO3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 10:29:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=g7ogT0QT6S1qLMjqFdeFsibCiT3Z/vwA1DUm+8wAXt5D1kykhTAmGpY80pK9v0Xmg+
         GsN1LI8wXc6djmyXyFYEoR5zc/4gOWhynvTl0qw2uzGpDIkiNrqu05AI+2VEth0QFB7L
         XyPAmjTUNtBnez7M1Vi2bnQvpskNqyT3iamI0=
Subject: Re: [PATCH] softlockup: stop spurious softlockup messages due to
 overflow
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Colin Ian King <colin.king@canonical.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <1268661673-21638-1-git-send-email-colin.king@canonical.com>
References: <1268661673-21638-1-git-send-email-colin.king@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Mar 2010 15:29:48 +0100
Message-ID: <1268663388.3154.30.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 15 mars 2010 à 14:01 +0000, Colin Ian King a écrit :
> Ensure additions on touch_ts do not overflow.  This can occur when
> the top 32 bits of the TSC reach 0xffffffff causing additions to
> touch_ts to overflow and this in turn generates spurious softlockup
> warnings.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  kernel/softlockup.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/softlockup.c b/kernel/softlockup.c
> index 0d4c789..90d9aa0 100644
> --- a/kernel/softlockup.c
> +++ b/kernel/softlockup.c
> @@ -111,10 +111,10 @@ int proc_dosoftlockup_thresh(struct ctl_table *table, int write,
>  void softlockup_tick(void)
>  {
>  	int this_cpu = smp_processor_id();
> -	unsigned long touch_ts = per_cpu(softlockup_touch_ts, this_cpu);
> +	unsigned long long touch_ts = per_cpu(softlockup_touch_ts, this_cpu);
>  	unsigned long print_ts;
>  	struct pt_regs *regs = get_irq_regs();
> -	unsigned long now;
> +	unsigned long long now;
>  
>  	/* Is detection switched off? */
>  	if (!per_cpu(softlockup_watchdog, this_cpu) || softlockup_thresh <= 0) {
> @@ -165,7 +165,7 @@ void softlockup_tick(void)
>  	per_cpu(softlockup_print_ts, this_cpu) = touch_ts;
>  
>  	spin_lock(&print_lock);
> -	printk(KERN_ERR "BUG: soft lockup - CPU#%d stuck for %lus! [%s:%d]\n",
> +	printk(KERN_ERR "BUG: soft lockup - CPU#%d stuck for %llus! [%s:%d]\n",
>  			this_cpu, now - touch_ts,
>  			current->comm, task_pid_nr(current));
>  	print_modules();

This looks wrong, touch_ts is a long, not a long long.

You probably want to change the comparisons instead.

if (now > touch_ts + softlockup_thresh/2)
	wake_up_process(per_cpu(softlockup_watchdog, this_cpu));
if (now <= (touch_ts + softlockup_thresh))
	return;
	
->

if ((long)(now - touch_ts) > softlockup_thresh/2)
	wake_up_process(per_cpu(softlockup_watchdog, this_cpu));
if ((long)(now - touch_ts) <= softlockup_thresh))
	return;

Or use standard time_after()/time_before() macros.



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284Ab1EQHKb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 03:10:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50565 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752333Ab1EQHK1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 03:10:27 -0400
Date: Tue, 17 May 2011 09:10:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: linux-kernel@vger.kernel.org, Marcin Slusarz <marcin.slusarz@gmail.com>,
        Don Zickus <dzickus@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 3/4] watchdog: disable watchdog when thresh is zero
Message-ID: <20110517071018.GE22305@elte.hu>
References: <1305588901-8141-1-git-send-email-msb@chromium.org>
 <1305588901-8141-3-git-send-email-msb@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305588901-8141-3-git-send-email-msb@chromium.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mandeep Singh Baines <msb@chromium.org> wrote:

> This restores the previous behavior of softlock_thresh.
> 
> Currently, setting watchdog_thresh to zero causes the watchdog
> kthreads to consume a lot of CPU.
> 
> Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
> Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: Don Zickus <dzickus@redhat.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---
>  kernel/watchdog.c |   15 ++++++++++++++-
>  1 files changed, 14 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> index cf0e09f..50c2f62 100644
> --- a/kernel/watchdog.c
> +++ b/kernel/watchdog.c
> @@ -526,7 +526,20 @@ int proc_dowatchdog_thresh(struct ctl_table *table, int write,
>  			     void __user *buffer,
>  			     size_t *lenp, loff_t *ppos)
>  {
> -	return proc_dointvec_minmax(table, write, buffer, lenp, ppos);
> +	int ret;
> +
> +	ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
> +	if (ret || !write)
> +		goto out;
> +
> +	if (softlockup_thresh)
> +		watchdog_enable_all_cpus();
> +	else
> +		watchdog_disable_all_cpus();

This now adds two similar looking blocks of these 4 lines, one in 
proc_dowatchdog_enabled(), one in proc_dowatchdog_thresh().

They are not the same though. So what happens if the watchdog is disabled but 
the threshold is updated to nonzero - do we enable the watchdog?

Thanks,

	Ingo

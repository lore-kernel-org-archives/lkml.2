Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104Ab1AaPmJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 10:42:09 -0500
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:47175 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751114Ab1AaPmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 10:42:07 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
References: <1296486501-25848-1-git-send-email-will.deacon@arm.com>
MIME-Version: 1.0
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1296486501-25848-1-git-send-email-will.deacon@arm.com>
Thread-Index: AcvBWL10GsDU467+SmmzVieDOGwpSwAApOSg
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Date: Mon, 31 Jan 2011 21:11:53 +0530
Message-ID: <ce22f38374d26d324bb8e57276eb46f0@mail.gmail.com>
Subject: RE: [PATCH] oprofile: add SMP barriers for hrtimer hotplug code
To: Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        oprofile-list@lists.sf.net
Cc: Robert Richter <robert.richter@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Will Deacon [mailto:will.deacon@arm.com]
> Sent: Monday, January 31, 2011 8:38 PM
> To: linux-kernel@vger.kernel.org; oprofile-list@lists.sf.net
> Cc: Will Deacon; Santosh Shilimkar; Robert Richter
> Subject: [PATCH] oprofile: add SMP barriers for hrtimer hotplug code
>
> OProfile uses a CPU notifier to start and stop any hrtimers when
> CPUs change
> between ONLINE and DEAD. A static int ctr_running is used to keep
> track of
> the counter state.
>
> This can lead to problems where writes to the state variable are re-
> ordered
> with repect to reads of the variable occurring on other CPUs,
> meaning that
> __oprofile_hrtimer_start may read ctr_running as 0 and not
> initialise the
> hrtimer. Potential deadlock can occur in __oprofile_hrtimer_stop
> because
> lock_hrtimer_base will poll until timer->base != NULL, which will
> never
> happen.
>
> This patch adds smp_mb()s to ensure that ctr_running mirrors the
> correct
> counter state.
>
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Cc: Robert Richter <robert.richter@amd.com>
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> ---
>  drivers/oprofile/timer_int.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/oprofile/timer_int.c
> b/drivers/oprofile/timer_int.c
> index 0107251..38c1e1b 100644
> --- a/drivers/oprofile/timer_int.c
> +++ b/drivers/oprofile/timer_int.c
> @@ -48,6 +48,7 @@ static int oprofile_hrtimer_start(void)
>  {
>  	get_online_cpus();
>  	ctr_running = 1;
> +	smp_mb();
Is smp_wmb() more appropriate ?

>  	on_each_cpu(__oprofile_hrtimer_start, NULL, 1);
>  	put_online_cpus();
>  	return 0;
> @@ -70,6 +71,7 @@ static void oprofile_hrtimer_stop(void)
>  	get_online_cpus();
>  	for_each_online_cpu(cpu)
>  		__oprofile_hrtimer_stop(cpu);
> +	smp_mb();
>  	ctr_running = 0;
>  	put_online_cpus();
>  }
> --
Otherwise patch is fine.
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

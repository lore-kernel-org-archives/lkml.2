Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156Ab0HZMMV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 08:12:21 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60857 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab0HZMMU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 08:12:20 -0400
Subject: Re: [PATCH] perf: fix possible divide-by-zero in
 perf_swevent_overflow()
From: Peter Zijlstra <peterz@infradead.org>
To: Dongdong Deng <dongdong.deng@windriver.com>
Cc: mingo@elte.hu, fweisbec@gmail.com, acme@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1282824438-13970-1-git-send-email-dongdong.deng@windriver.com>
References: <1282824438-13970-1-git-send-email-dongdong.deng@windriver.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 26 Aug 2010 14:12:07 +0200
Message-ID: <1282824727.1975.747.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-26 at 20:07 +0800, Dongdong Deng wrote:
> The event->hw.last_period is possible to zero, thus it will
> cause divide_by_zero later in perf_swevent_set_period().

How can it be zero?

> This patch checks event->hw.last_period before invoke
> perf_swevent_set_period() and replaces "event->hw" with "hwc".
> 
> Signed-off-by: Dongdong Deng <dongdong.deng@windriver.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Paul Mackerras <paulus@samba.org>
> ---
>  kernel/perf_event.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> index 403d180..ccba741 100644
> --- a/kernel/perf_event.c
> +++ b/kernel/perf_event.c
> @@ -4050,8 +4050,8 @@ static void perf_swevent_overflow(struct perf_event *event, u64 overflow,
>  	struct hw_perf_event *hwc = &event->hw;
>  	int throttle = 0;
>  
> -	data->period = event->hw.last_period;
> -	if (!overflow)
> +	data->period = hwc->last_period;
> +	if (!overflow && hwc->last_period)
>  		overflow = perf_swevent_set_period(event);
>  
>  	if (hwc->interrupts == MAX_INTERRUPTS)



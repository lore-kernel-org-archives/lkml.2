Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550Ab0KZTUh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 14:20:37 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60122 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab0KZTUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 14:20:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:in-reply-to:references:user-agent:date
         :message-id:mime-version:content-type;
        b=VQeitJtTGH/16MTgFzc6qWWAe/g/iwsRbSVRpWgCbL3/FpFW7zlYqnAuc42IAhu6nq
         PFIbXx2+su85JEsTglO9WI+etNvNfbF0qgTCXozcyCw2PYxjI/QaTfFdj2C8c+rpjj/7
         FAcKBlcPgTBCC9G2ivb7VFdOBCUG+kS/YL6Ek=
From: Francis Moreau <francis.moro@gmail.com>
To: mingo@redhat.com
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf: Ignore non-sampling overflows
In-Reply-To: <tip-963988262c3c8f4234f64a0dde59446a295e07bb@git.kernel.org>
	(tip-bot for Peter Zijlstra's message of "Fri, 26 Nov 2010 15:04:56
	GMT")
References: <tip-963988262c3c8f4234f64a0dde59446a295e07bb@git.kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
Date: Fri, 26 Nov 2010 20:20:29 +0100
Message-ID: <m2r5e7dh8i.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl> writes:
>
> perf: Ignore non-sampling overflows
>
> Some arch implementations call perf_event_overflow() by 'accident',
> ignore this.
>
> Reported-by: Francis Moreau <francis.moro@gmail.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> LKML-Reference: <new-submission>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  kernel/perf_event.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
>
> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> index 98c5549..af1e63f 100644
> --- a/kernel/perf_event.c
> +++ b/kernel/perf_event.c
> @@ -4240,6 +4240,13 @@ static int __perf_event_overflow(struct perf_event *event, int nmi,
>  	struct hw_perf_event *hwc = &event->hw;
>  	int ret = 0;
>  
> +	/*
> +	 * Non-sampling counters might still use the PMI to fold short
> +	 * hardware counters, ignore those.
> +	 */
> +	if (unlikely(!is_sampling_event(event)))
> +		return 0;
> +
>  	if (!throttle) {
>  		hwc->interrupts++;
>  	} else {

Couldn't we place this in perf_event_overflow() instead, like the
following ?

--8<---------------cut here---------------start------------->8---

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index df27fd8..1dabb54 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4267,7 +4267,9 @@ int perf_event_overflow(struct perf_event *event,
int nmi,
                  struct perf_sample_data *data,
                                            struct pt_regs *regs)
 {
-       return __perf_event_overflow(event, nmi, 1, data, regs);
+       if (is_sampling_event(event))
+          return __perf_event_overflow(event, nmi, 1, data, regs);
+          return 0;
 }
 
 /*

--8<---------------cut here---------------end--------------->8---

thanks,
-- 
Francis

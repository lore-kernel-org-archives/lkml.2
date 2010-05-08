Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086Ab0EHLds (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 07:33:48 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61192 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736Ab0EHLdq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 07:33:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=SMczbao0mRXOfNzQQiQHYaNrtmlcsrrqc9b/4vc6xQLk3+fPNG7fiwIrMpW37ESlov
         gkWWOsqFeFuD/r7WTM0deuO/arWtBZlKqlJl/zyMbYDziK1OFQkX1+ln+nQeg3YEzDMO
         Vs1vEOW1OYPUiHBQcbgkqXVAwKHIXrMQ/s/es=
MIME-Version: 1.0
In-Reply-To: <20100508112716.741423821@openvz.org>
References: <20100508112550.187421916@openvz.org>
	 <20100508112716.741423821@openvz.org>
Date: Sat, 8 May 2010 15:33:46 +0400
X-Google-Sender-Auth: 15abf61be4a99efe
Message-ID: <i2zaa79d98a1005080433qb2f44069n4548ac3cfdd4772b@mail.gmail.com>
Subject: Re: [patch 1/4] x86,perf: P4 PMU -- configurate predefined events
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: "mingo@elte.hu" <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lin Ming <ming.m.lin@intel.com>,
       Robert Richter <robert.richter@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, May 8, 2010, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> If an event is not RAW we should exit p4_hw_config
> early but call x86_setup_perfctr as well.
>

Actually i meant "should not"

> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Frederic Weisbecker <fweisbec@gmail.com>
> CC: Lin Ming <ming.m.lin@intel.com>
> CC: Robert Richter <robert.richter@amd.com>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> ---
>
> Robert, if only I'm not missing something this is
> a side effect of commit 9d0fcba67e47ff398a6fa86476d4884d472dc98a,
> wonders why don't we hit it earlier. Am I wrong?
>
>  arch/x86/kernel/cpu/perf_event_p4.c |   29 ++++++++++++++---------------
>  1 file changed, 14 insertions(+), 15 deletions(-)
>
> Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
> =====================================================================
> --- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_p4.c
> +++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
> @@ -439,21 +439,20 @@ static int p4_hw_config(struct perf_even
>         if (p4_ht_active() && p4_ht_thread(cpu))
>                 event->hw.config = p4_set_ht_bit(event->hw.config);
>
> -       if (event->attr.type != PERF_TYPE_RAW)
> -               return 0;
> -
> -       /*
> -        * We don't control raw events so it's up to the caller
> -        * to pass sane values (and we don't count the thread number
> -        * on HT machine but allow HT-compatible specifics to be
> -        * passed on)
> -        *
> -        * XXX: HT wide things should check perf_paranoid_cpu() &&
> -        *      CAP_SYS_ADMIN
> -        */
> -       event->hw.config |= event->attr.config &
> -               (p4_config_pack_escr(P4_ESCR_MASK_HT) |
> -                p4_config_pack_cccr(P4_CCCR_MASK_HT));
> +       if (event->attr.type == PERF_TYPE_RAW) {
> +               /*
> +                * We don't control raw events so it's up to the caller
> +                * to pass sane values (and we don't count the thread number
> +                * on HT machine but allow HT-compatible specifics to be
> +                * passed on)
> +                *
> +                * XXX: HT wide things should check perf_paranoid_cpu() &&
> +                *      CAP_SYS_ADMIN
> +                */
> +               event->hw.config |= event->attr.config &
> +                       (p4_config_pack_escr(P4_ESCR_MASK_HT) |
> +                        p4_config_pack_cccr(P4_CCCR_MASK_HT));
> +       }
>
>         return x86_setup_perfctr(event);
>  }
>
>

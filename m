Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265Ab2GALjk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 07:39:40 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:45205 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932124Ab2GALjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 07:39:39 -0400
X-IronPort-AV: E=Sophos;i="4.77,504,1336341600"; 
   d="scan'208";a="165166607"
Date: Sun, 1 Jul 2012 07:39:24 -0400 (EDT)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Lars-Peter Clausen <lars@metafoo.de>
cc: Michal Marek <mmarek@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [Cocci] [PATCH] scripts/coccinelle: Find threaded IRQs requests
 which are missing IRQF_ONESHOT
In-Reply-To: <1341141427-14424-1-git-send-email-lars@metafoo.de>
Message-ID: <alpine.DEB.2.02.1207010736160.1873@hadrien>
References: <1341141427-14424-1-git-send-email-lars@metafoo.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 1 Jul 2012, Lars-Peter Clausen wrote:

> Since commit 1c6c69525b ("genirq: Reject bogus threaded irq requests") threaded
> IRQs without a primary handler need to be requested with IRQF_ONESHOT, otherwise
> the request will fail. This semantic patch will help to statically identify
> (and fix) such cases.
>
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

> ---
>  scripts/coccinelle/misc/irqf_oneshot.cocci |   65 ++++++++++++++++++++++++++++
>  1 file changed, 65 insertions(+)
>  create mode 100644 scripts/coccinelle/misc/irqf_oneshot.cocci
>
> diff --git a/scripts/coccinelle/misc/irqf_oneshot.cocci b/scripts/coccinelle/misc/irqf_oneshot.cocci
> new file mode 100644
> index 0000000..6cfde94
> --- /dev/null
> +++ b/scripts/coccinelle/misc/irqf_oneshot.cocci
> @@ -0,0 +1,65 @@
> +/// Make sure threaded IRQs without a primary handler are always request with
> +/// IRQF_ONESHOT
> +///
> +//
> +// Confidence: Good
> +// Comments:
> +// Options: --no-includes
> +
> +virtual patch
> +virtual context
> +virtual org
> +virtual report
> +
> +@r1@
> +expression irq;
> +expression thread_fn;
> +expression flags;
> +position p;
> +@@
> +request_threaded_irq@p(irq, NULL, thread_fn,
> +(
> +flags | IRQF_ONESHOT
> +|
> +IRQF_ONESHOT
> +)
> +, ...)
> +
> +@depends on patch@
> +expression irq;
> +expression thread_fn;
> +expression flags;
> +position p != r1.p;
> +@@
> +request_threaded_irq@p(irq, NULL, thread_fn,
> +(
> +-0
> ++IRQF_ONESHOT
> +|
> +-flags
> ++flags | IRQF_ONESHOT
> +)
> +, ...)
> +
> +@depends on context@
> +position p != r1.p;
> +@@
> +*request_threaded_irq@p(...)
> +
> +@match depends on report || org@
> +expression irq;
> +position p != r1.p;
> +@@
> +request_threaded_irq@p(irq, NULL, ...)
> +
> +@script:python depends on org@
> +p << match.p;
> +@@
> +msg = "ERROR: Threaded IRQ with no primary handler requested without IRQF_ONESHOT"
> +coccilib.org.print_todo(p[0],msg)
> +
> +@script:python depends on report@
> +p << match.p;
> +@@
> +msg = "ERROR: Threaded IRQ with no primary handler requested without IRQF_ONESHOT"
> +coccilib.report.print_report(p[0],msg)
> --
> 1.7.10
>
> _______________________________________________
> Cocci mailing list
> Cocci@diku.dk
> http://lists.diku.dk/mailman/listinfo/cocci
> (Web access from inside DIKUs LAN only)
>

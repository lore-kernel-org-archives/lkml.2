Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227Ab1LTW3V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 17:29:21 -0500
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:15053
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753204Ab1LTW3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 17:29:17 -0500
X-IronPort-AV: E=Sophos;i="4.71,384,1320620400"; 
   d="scan'208";a="124103506"
Date: Tue, 20 Dec 2011 23:19:12 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Lars-Peter Clausen <lars@metafoo.de>
cc: Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <npalix.work@gmail.com>, linux-kernel@vger.kernel.org,
        cocci@diku.dk, Michal Marek <mmarek@suse.cz>
Subject: Re: [Cocci] [PATCH 1/2] coccinelle: Add patch for replacing open-coded
 PTR_RET
In-Reply-To: <1324301063-16117-1-git-send-email-lars@metafoo.de>
Message-ID: <alpine.DEB.2.02.1112202317450.1933@hadrien>
References: <1324301063-16117-1-git-send-email-lars@metafoo.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Dec 2011, Lars-Peter Clausen wrote:

> The PTR_RET function returns the error value of its parameter if it is an
> ERR_PTR, otherwise it returns 0. This patch adds a semantic patch which finds
> open-coded instances of this check and replaces them.
>
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

Acked-by: Julia Lawall <julia.lawall@lip6.fr>

> ---
> scripts/coccinelle/api/ptr_ret.cocci |   55 ++++++++++++++++++++++++++++++++++
> 1 files changed, 55 insertions(+), 0 deletions(-)
> create mode 100644 scripts/coccinelle/api/ptr_ret.cocci
>
> diff --git a/scripts/coccinelle/api/ptr_ret.cocci b/scripts/coccinelle/api/ptr_ret.cocci
> new file mode 100644
> index 0000000..dfd9b1f
> --- /dev/null
> +++ b/scripts/coccinelle/api/ptr_ret.cocci
> @@ -0,0 +1,55 @@
> +///
> +/// Use PTR_RET function instead of open coding it
> +///
> +// Confidence: High
> +// Options:
> +//
> +// Keywords: IS_ERR, PTR_ERR, PTR_RET
> +// Version min: 2.6.39
> +//
> +
> +virtual context
> +virtual patch
> +virtual org
> +virtual report
> +
> +@depends on context@
> +expression x;
> +@@
> +*if (IS_ERR(x))
> +*	return PTR_ERR(x);
> +*return 0;
> +
> +@depends on patch@
> +expression x;
> +@@
> +-if (IS_ERR(x))
> +-	return PTR_ERR(x);
> +-return 0;
> ++return PTR_RET(x);
> +
> +@r depends on org || report@
> +expression x;
> +position p;
> +@@
> +
> + if (IS_ERR@p(x))
> +	return PTR_ERR(x);
> + return 0;
> +
> +@script:python depends on org@
> +p << r.p;
> +x << r.x;
> +@@
> +
> +msg="WARNING PTR_RET can be used with %s" % (x)
> +msg_safe=msg.replace("[","@(").replace("]",")")
> +coccilib.org.print_todo(p[0], msg_safe)
> +
> +@script:python depends on report@
> +p << r.p;
> +x << r.x;
> +@@
> +
> +msg="WARNING: PTR_RET can be used with %s" % (x)
> +coccilib.report.print_report(p[0], msg)
> -- 
> 1.7.7.3
>
>
> _______________________________________________
> Cocci mailing list
> Cocci@diku.dk
> http://lists.diku.dk/mailman/listinfo/cocci
> (Web access from inside DIKUs LAN only)
>

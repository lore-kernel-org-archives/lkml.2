Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310Ab2J3WRS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 18:17:18 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:54322 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752307Ab2J3WRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 18:17:17 -0400
X-IronPort-AV: E=Sophos;i="4.80,683,1344204000"; 
   d="scan'208";a="179600073"
Date: Tue, 30 Oct 2012 15:17:07 -0700 (PDT)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Peter Senna Tschudin <peter.senna@gmail.com>
cc: Julia.Lawall@lip6.fr, Gilles Muller <Gilles.Muller@lip6.fr>,
        nicolas.palix@imag.fr, cocci@systeme.lip6.fr,
        linux-kernel@vger.kernel.org, mmarek@suse.cz,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scripts/coccinelle/misc/semicolon.cocci: Add unnecessary
 semicolon test
In-Reply-To: <1351628630-3800-1-git-send-email-peter.senna@gmail.com>
Message-ID: <alpine.DEB.2.02.1210301515550.2058@hadrien>
References: <1351628630-3800-1-git-send-email-peter.senna@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Oct 2012, Peter Senna Tschudin wrote:

> This semantic patch looks for semicolons that can be removed without
> changing the semantics of the code. The confidence is moderate
> because there are some false positives on cases like:
>
> drivers/mmc/host/cb710-mmc.c:589
> 		break;
> 	case MMC_POWER_UP:
> 	default:
> -		/* ignore */;
> 	}
>
> There are 37 patches accepted reported by this semantic patch and
> more than 300 fixes to be applied.
>
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

Acked-by: Julia Lawall <julia.lawall@lip6.fr>

> ---
>  scripts/coccinelle/misc/semicolon.cocci | 83 +++++++++++++++++++++++++++++++++
>  1 file changed, 83 insertions(+)
>  create mode 100644 scripts/coccinelle/misc/semicolon.cocci
>
> diff --git a/scripts/coccinelle/misc/semicolon.cocci b/scripts/coccinelle/misc/semicolon.cocci
> new file mode 100644
> index 0000000..a47eba2
> --- /dev/null
> +++ b/scripts/coccinelle/misc/semicolon.cocci
> @@ -0,0 +1,83 @@
> +///
> +/// Removes unneeded semicolon.
> +///
> +// Confidence: Moderate
> +// Copyright: (C) 2012 Peter Senna Tschudin, INRIA/LIP6.  GPLv2.
> +// URL: http://coccinelle.lip6.fr/
> +// Comments: Some false positives on empty default cases in switch statements.
> +// Options: --no-includes --include-headers
> +
> +virtual patch
> +virtual report
> +virtual context
> +virtual org
> +
> +@r_default@
> +position p;
> +@@
> +switch (...)
> +{
> +default: ...;@p
> +}
> +
> +@r_case@
> +position p;
> +@@
> +(
> +switch (...)
> +{
> +case ...:;@p
> +}
> +|
> +switch (...)
> +{
> +case ...:...
> +case ...:;@p
> +}
> +|
> +switch (...)
> +{
> +case ...:...
> +case ...:
> +case ...:;@p
> +}
> +)
> +
> +@r1@
> +statement S;
> +position p1;
> +position p != {r_default.p, r_case.p};
> +identifier label;
> +@@
> +(
> +label:;
> +|
> +S@p1;@p
> +)
> +
> +@script:python@
> +p << r1.p;
> +p1 << r1.p1;
> +@@
> +if p[0].line != p1[0].line_end:
> +	cocci.include_match(False)
> +
> +@depends on patch@
> +position r1.p;
> +@@
> +-;@p
> +
> +@script:python depends on report@
> +p << r1.p;
> +@@
> +coccilib.report.print_report(p[0],"Unneeded semicolon")
> +
> +@depends on context@
> +position r1.p;
> +@@
> +*;@p
> +
> +@script:python depends on org@
> +p << r1.p;
> +@@
> +cocci.print_main("Unneeded semicolon",p)
> --
> 1.7.11.7
>
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

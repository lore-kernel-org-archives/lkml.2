Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab2GTAx4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 20:53:56 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:55986 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066Ab2GTAxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 20:53:51 -0400
X-AuditID: 9c93016f-b7b08ae00000790d-1d-5008ac1c67e0
From: Namhyung Kim <namhyung@kernel.org>
To: Cody Schafer <cody@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf: prevent overflow in size calculation
References: <1342743215-26979-1-git-send-email-cody@linux.vnet.ibm.com>
Date: Fri, 20 Jul 2012 09:49:05 +0900
In-Reply-To: <1342743215-26979-1-git-send-email-cody@linux.vnet.ibm.com> (Cody
	Schafer's message of "Thu, 19 Jul 2012 17:13:35 -0700")
Message-ID: <87a9yv2r5q.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Cody

On Thu, 19 Jul 2012 17:13:35 -0700, Cody Schafer wrote:
> A large enough symbol size causes an overflow in the size parameter to the
> histogram allocation, leading to a segfault in symbol__inc_addr_samples later
> on when this histogram is accessed.
>
> In the case of being called via perf-report, this returns back and
> gracefully ignores the sample, eventually ignoring the chained return
> value of perf_session_deliver_event in flush_sample_queue.
>
> Signed-off-by: Cody Schafer <cody@linux.vnet.ibm.com>
> ---
>  tools/perf/util/annotate.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
> index 8069dfb..6f78f20 100644
> --- a/tools/perf/util/annotate.c
> +++ b/tools/perf/util/annotate.c
> @@ -426,8 +426,13 @@ int symbol__alloc_hist(struct symbol *sym)
>  {
>  	struct annotation *notes = symbol__annotation(sym);
>  	const size_t size = symbol__size(sym);
> -	size_t sizeof_sym_hist = (sizeof(struct sym_hist) + size * sizeof(u64));
> +	size_t sizeof_sym_hist;
>  
> +	/* Check for overflow when calculating sizeof_sym_hist */
> +	if (size > (SIZE_MAX / sizeof(u64)))
> +		return -1;

How does it guarantee that the end result which used in zalloc below
would not overflow?

Thanks,
Namhyung


> +
> +	sizeof_sym_hist = (sizeof(struct sym_hist) + size * sizeof(u64));
>  	notes->src = zalloc(sizeof(*notes->src) + symbol_conf.nr_events * sizeof_sym_hist);
>  	if (notes->src == NULL)
>  		return -1;

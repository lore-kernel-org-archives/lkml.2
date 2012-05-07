Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400Ab2EGMJD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 08:09:03 -0400
Received: from casper.infradead.org ([85.118.1.10]:56885 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755991Ab2EGMJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 08:09:01 -0400
Subject: Re: [PATCH 4/7] perf/x86-ibs: Add support for IBS pseudo events
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1335983192-23731-5-git-send-email-robert.richter@amd.com>
References: <1335983192-23731-1-git-send-email-robert.richter@amd.com>
	 <1335983192-23731-5-git-send-email-robert.richter@amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 May 2012 14:08:48 +0200
Message-ID: <1336392528.27020.8.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-02 at 20:26 +0200, Robert Richter wrote:

> This patch includes kernel and userland changes.
> 
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> ---
>  arch/x86/kernel/cpu/perf_event_amd_ibs.c |   83 ++++++-
>  tools/perf/util/pmu-ibs.c                |  433 +++++++++++++++++++++++++-----

I think its best to separate this.

>  2 files changed, 445 insertions(+), 71 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
> index 03743ad..1675479 100644
> --- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
> +++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
> @@ -478,6 +478,81 @@ static struct perf_ibs perf_ibs_op = {
>  	.get_count		= get_ibs_op_count,
>  };
>  
> +enum ibs_filter_type {
> +	IBS_NO_FILTER		= 0,
> +	IBS_MATCH_FILTER	= 1,
> +	IBS_ANY_SET_FILTER	= 2,
> +	IBS_PSEUDO_EVENT	= 0x0F,
> +};
> +
> +struct ibs_filter {
> +	struct {
> +		u16		idx		: 8;
> +		u16		reserved	: 4;
> +		u16		type		: 4;
> +	};
> +	union {
> +		struct {
> +			u8	mask;
> +			u8	match;
> +		};
> +		u16		any;
> +	};
> +};

> diff --git a/tools/perf/util/pmu-ibs.c b/tools/perf/util/pmu-ibs.c
> index 07acb82..604cb8c 100644
> --- a/tools/perf/util/pmu-ibs.c
> +++ b/tools/perf/util/pmu-ibs.c


> +enum ibs_filter_type {
> +	IBS_NO_FILTER		= 0,
> +	IBS_MATCH_FILTER	= 1,
> +	IBS_ANY_SET_FILTER	= 2,
> +	IBS_PSEUDO_EVENT	= 0x0F,
> +};
> +
> +struct ibs_filter {
> +	struct {
> +		__u16		idx		: 8;
> +		__u16		reserved	: 4;
> +		__u16		type		: 4;
> +	};
> +	union {
> +		struct {
> +			__u8	mask;
> +			__u8	match;
> +		};
> +		__u16		any;
> +	};
> +};

Having two copies of this just stinks, its only matter of time before
one receives changes the other doesn't.



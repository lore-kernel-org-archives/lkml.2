Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754Ab1EJKFd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 06:05:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:59491 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082Ab1EJKFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 06:05:31 -0400
Subject: Re: [PATCH] perf events, x86: Implement Sandybridge last-level
 cache events
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <1304930382.3924.303.camel@minggr.sh.intel.com>
References: <1304930382.3924.303.camel@minggr.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 May 2011 12:08:32 +0200
Message-ID: <1305022112.2914.40.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-09 at 16:39 +0800, Lin Ming wrote:

>  
> +/*
> + * Sandy Bridge MSR_OFFCORE_RESPONSE bits;
> + * See IA32 SDM Vol 3B 30.8.5
> + */
> +
> +#define SNB_DMND_DATA_RD	(1ULL << 0)
> +#define SNB_DMND_RFO		(1ULL << 1)
> +#define SNB_DMND_IFETCH		(1ULL << 2)
> +#define SNB_DMND_WB		(1ULL << 3)
> +#define SNB_PF_DATA_RD		(1ULL << 4)
> +#define SNB_PF_DATA_RFO		(1ULL << 5)
> +#define SNB_PF_IFETCH		(1ULL << 6)
> +#define SNB_PF_LLC_DATA_RD	(1ULL << 7)
> +#define SNB_PF_LLC_RFO		(1ULL << 8)
> +#define SNB_PF_LLC_IFETCH	(1ULL << 9)
> +#define SNB_BUS_LOCKS		(1ULL << 10)
> +#define SNB_STRM_ST		(1ULL << 11)
> +				/* hole */
> +#define SNB_OFFCORE_OTHER	(1ULL << 15)
> +#define SNB_COMMON		(1ULL << 16)
> +#define SNB_NO_SUPP		(1ULL << 17)
> +#define SNB_LLC_HITM		(1ULL << 18)
> +#define SNB_LLC_HITE		(1ULL << 19)
> +#define SNB_LLC_HITS		(1ULL << 20)
> +#define SNB_LLC_HITF		(1ULL << 21)
> +				/* hole */
> +#define SNB_SNP_NONE		(1ULL << 31)
> +#define SNB_SNP_NOT_NEEDED	(1ULL << 32)
> +#define SNB_SNP_MISS		(1ULL << 33)
> +#define SNB_SNP_NO_FWD		(1ULL << 34)
> +#define SNB_SNP_FWD		(1ULL << 35)
> +#define SNB_HITM		(1ULL << 36)
> +#define SNB_NON_DRAM		(1ULL << 37)
> +
> +#define SNB_DMND_READ		(SNB_DMND_DATA_RD)
> +#define SNB_DMND_WRITE		(SNB_DMND_RFO | SNB_DMND_WB|SNB_STRM_ST)
> +#define SNB_DMND_PREFETCH	(SNB_PF_DATA_RD | SNB_PF_DATA_RFO)
> +
> +#define SNB_SUPPLIER_INFO	(SNB_NO_SUPP | SNB_LLC_HITM | SNB_LLC_HITE | \
> +				 SNB_LLC_HITS | SNB_LLC_HITF)
> +
> +#define SNB_L3_HIT		(SNB_SUPPLIER_INFO | SNB_SNP_NOT_NEEDED | SNB_SNP_NO_FWD | SNB_HITM)
> +#define SNB_L3_MISS		(SNB_SUPPLIER_INFO | SNB_SNP_MISS | SNB_SNP_FWD | SNB_NON_DRAM)
> +#define SNB_L3_ACCESS		(SNB_L3_HIT | SNB_L3_MISS)

I would very much like to know how these bits work.. Since the SDM
doesn't explain anything could you please add a big comment explaining
things?

Otherwise the patch looks good, but unverifiable so for me.

> +static __initconst const u64 snb_hw_cache_extra_regs
> +				[PERF_COUNT_HW_CACHE_MAX]
> +				[PERF_COUNT_HW_CACHE_OP_MAX]
> +				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
> +{
> + [ C(LL  ) ] = {
> +	[ C(OP_READ) ] = {
> +		[ C(RESULT_ACCESS) ] = SNB_DMND_READ | SNB_L3_ACCESS,
> +		[ C(RESULT_MISS)   ] = SNB_DMND_READ | SNB_L3_MISS,
> +	},
> +	[ C(OP_WRITE) ] = {
> +		[ C(RESULT_ACCESS) ] = SNB_DMND_WRITE | SNB_L3_ACCESS,
> +		[ C(RESULT_MISS)   ] = SNB_DMND_WRITE | SNB_L3_MISS,
> +	},
> +	[ C(OP_PREFETCH) ] = {
> +		[ C(RESULT_ACCESS) ] = SNB_DMND_PREFETCH | SNB_L3_ACCESS,
> +		[ C(RESULT_MISS)   ] = SNB_DMND_PREFETCH | SNB_L3_MISS,
> +	},
> + }
> +};


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101Ab2A0QVm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 11:21:42 -0500
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:25232 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752688Ab2A0QVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 11:21:41 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: jtB3BbYVM1lMlaiP8qy4XeWSoWnTeghY14y9IYEvrPn601d
 EhBmg5rYL.hipG9mvqH.YX_IwoO9uIkh74XjUGjr8Y2Chzaiod9G0t1r_AVK
 GafxPogzxyo3GXOTGefFVcg5jhm0jYLuZNrzEap9H72y.QUQKVEtr.WHNBZv
 hU.qT91T58.a_3FDTaZ_AQZO98hNt5bCXiQbySCUTJkfPrwPgduFcOw0gsen
 fkypzzaealUfQIAI2TequrPITXMi4jBgiwG1rTON4GzmTy4tUHxJuyktvyWw
 ibH8QHTsiongE0BF.ONo.ey885qLXMruMSxz5KV7csK28uQGcV5Ds6tpSvIA
 tj0HrRzBe2stJts9fp6Uye3i2Xk2lbtak7MnKPCSECw5jKYZxJoDux37nWNp
 E
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 27 Jan 2012 10:21:36 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Wu Fengguang <fengguang.wu@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
        Jens Axboe <axboe@kernel.dk>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/9] readahead: add /debug/readahead/stats
In-Reply-To: <20120127031327.159293683@intel.com>
Message-ID: <alpine.DEB.2.00.1201271006480.16756@router.home>
References: <20120127030524.854259561@intel.com> <20120127031327.159293683@intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jan 2012, Wu Fengguang wrote:

> +
> +#define RA_STAT_BATCH	(INT_MAX / 2)
> +static struct percpu_counter ra_stat[RA_PATTERN_ALL][RA_ACCOUNT_MAX];

Why use percpu counter here? The stats structures are not dynamically
allocated so you can just use a DECLARE_PER_CPU statement. That way you do
not have the overhead of percpu counter calls. Instead simple instructions
are generated to deal with the counter.

There are also no calls to any of the fast access functions for percpu
counter so percpu_counter has to always having to loop over all
counters anyways to get the results. The batching of the percpu_counters
is therefore not used.

Its simpler to just do a loop that sums over all counters when displaying
the results.

> +static inline void add_ra_stat(int i, int j, s64 amount)
> +{
> +	__percpu_counter_add(&ra_stat[i][j], amount, RA_STAT_BATCH);

	__this_cpu_add(ra_stat[i][j], amount);

> +}

> +
> +static void readahead_stats_reset(void)
> +{
> +	int i, j;
> +
> +	for (i = 0; i < RA_PATTERN_ALL; i++)
> +		for (j = 0; j < RA_ACCOUNT_MAX; j++)
> +			percpu_counter_set(&ra_stat[i][j], 0);

for_each_online(cpu)
	memset(per_cpu_ptr(&ra_stat, cpu), 0, sizeof(ra_stat));

> +}
> +
> +static void
> +readahead_stats_sum(long long ra_stats[RA_PATTERN_MAX][RA_ACCOUNT_MAX])
> +{
> +	int i, j;
> +
> +	for (i = 0; i < RA_PATTERN_ALL; i++)
> +		for (j = 0; j < RA_ACCOUNT_MAX; j++) {
> +			s64 n = percpu_counter_sum(&ra_stat[i][j]);
> +			ra_stats[i][j] += n;
> +			ra_stats[RA_PATTERN_ALL][j] += n;
> +		}
> +}

Define a function stats instead?

static long get_stat_sum(long __per_cpu *x)
{
	int cpu;
	long sum;

	for_each_online(cpu)
		sum += *per_cpu_ptr(x, cpu);

	return sum;
}

> +
> +static int readahead_stats_show(struct seq_file *s, void *_)
> +{

> +	readahead_stats_sum(ra_stats);
> +
> +	for (i = 0; i < RA_PATTERN_MAX; i++) {
> +		unsigned long count = ra_stats[i][RA_ACCOUNT_COUNT];

			= get_stats(&ra_stats[i][RA_ACCOUNT]);

...

?


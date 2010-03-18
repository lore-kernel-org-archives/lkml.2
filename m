Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab0CRNgM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 09:36:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36390 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951Ab0CRNgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 09:36:11 -0400
Date: Thu, 18 Mar 2010 10:35:48 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Sheng Yang <sheng@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
       Jes Sorensen <Jes.Sorensen@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       kvm@vger.kernel.org, zhiteng.huang@intel.com,
       Zachary Amsden <zamsden@redhat.com>
Subject: Re: [PATCH 3/3] perf events: Change perf parameter --pid to
 process-wide collection instead of thread-wide
Message-ID: <20100318133548.GA2873@ghostprotocols.net>
References: <1268904666.2813.172.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268904666.2813.172.camel@localhost>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Mar 18, 2010 at 05:31:06PM +0800, Zhang, Yanmin escreveu:
> From: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
> 
> Parameter --pid (or -p) of perf currently means a thread-wide collection.
> For exmaple, if a process whose id is 8888 has 10 threads, 'perf top -p 8888'
> just collects the main thread statistics. That's misleading. Users are
> used to attach a whole process when debugging a process by gdb. To follow
> normal usage style, the patch change --pid to process-wide collection and
> add --tid (-t) to mean a thread-wide collection.
> 
> Usage example is:
> #perf top -p 8888
> #perf record -p 8888 -f sleep 10
> #perf stat -p 8888 -f sleep 10
> Above commands collect the statistics of all threads of process 8888.
> 
> Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>

Just did visual inspection of the three patches, all sane, except for
some coding style nits, don't worry right now for that, I'll fix them up
myself, but please take those into account int the future, highlight
below.
 
> ---
> 
> diff -Nraup linux-2.6_tip0317_statrecord/tools/perf/builtin-record.c linux-2.6_tip0317_statrecordpid/tools/perf/builtin-record.c
> --- linux-2.6_tip0317_statrecord/tools/perf/builtin-record.c	2010-03-18 13:48:39.578181540 +0800
> +++ linux-2.6_tip0317_statrecordpid/tools/perf/builtin-record.c	2010-03-18 14:28:41.449631936 +0800
> +			mmap_array[nr_cpu][counter][thread_index].mask = mmap_pages*page_size - 1;
> +			mmap_array[nr_cpu][counter][thread_index].base = mmap(NULL, (mmap_pages+1)*page_size,

Spaces around +, *,  etc

> +				PROT_READ|PROT_WRITE, MAP_SHARED, fd[nr_cpu][counter][thread_index], 0);
> +			if (mmap_array[nr_cpu][counter][thread_index].base == MAP_FAILED) {
> +				error("failed to mmap with %d (%s)\n", errno, strerror(errno));
> +				exit(-1);
> +			}
> +	} else {
> +		all_tids=malloc(sizeof(pid_t));

Ditto here for =

> +		if (!all_tids)
> +			return -ENOMEM;
> +
> +		all_tids[0] = target_tid;
> +		thread_num = 1;
> +	}
> +
> +	for (i = 0; i < MAX_NR_CPUS; i++) {
> +		for (j = 0; j < MAX_COUNTERS; j++) {
> +			fd[i][j] = malloc(sizeof(int)*thread_num);
> +			mmap_array[i][j] = malloc(
> +				sizeof(struct mmap_data)*thread_num);

Ditto

> +			if (!fd[i][j] || !mmap_array[i][j])
> +				return -ENOMEM;
> +		}
> +	}
> +	event_array = malloc(
> +		sizeof(struct pollfd)*MAX_NR_CPUS*MAX_COUNTERS*thread_num);

Ditto

Should be, I suggest:

	event_array = malloc((sizeof(struct pollfd) * MAX_NR_CPUS *
			      MAX_COUNTERS * thread_num));


Anyway, I'll fix some of these while merging, now.

- Arnaldo

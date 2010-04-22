Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989Ab0DVRgH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 13:36:07 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:29874 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754693Ab0DVRgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 13:36:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=E8c53oK9QuYEmFn2oFsg5NsBgX5XGANmArj/XkbxNVt7YKj+RP6tT2BLsKpHE4/0o+
         l7z5RwsKtmqvQAkSNE0Ta7Q3SAdN5lQWOn1XsFJC0Pc66ZM8SfJPn52XBRuDptiptsfD
         632NhXePMAyYRz4iGnpv1ZkBLWuQN3lxFv2DU=
Date: Thu, 22 Apr 2010 19:31:55 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>, arjan@linux.intel.com,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 1/4] perf: core, add group scheduling
	transactional APIs
Message-ID: <20100422173152.GA5600@nowhere>
References: <1271922662.30535.107.camel@minggr.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271922662.30535.107.camel@minggr.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 22, 2010 at 03:51:02PM +0800, Lin Ming wrote:
> Add group scheduling transactional APIs to struct pmu.
> These APIs will be implemented in arch code, based on Peter's idea as
> below.
> 
> > the idea behind hw_perf_group_sched_in() is to not perform
> > schedulability tests on each event in the group, but to add the group
> as
> > a whole and then perform one test.
> >
> > Of course, when that test fails, you'll have to roll-back the whole
> > group again.
> >
> > So start_txn (or a better name) would simply toggle a flag in the pmu
> > implementation that will make pmu::enable() not perform the
> > schedulablilty test.
> >
> > Then commit_txn() will perform the schedulability test (so note the
> > method has to have a !void return value, my mistake in the earlier
> > email).
> >
> > This will allow us to use the regular
> > kernel/perf_event.c::group_sched_in() and all the rollback code.
> > Currently each hw_perf_group_sched_in() implementation duplicates all
> > the rolllback code (with various bugs).
> 
> 
> Reviewed-by: Stephane Eranian <eranian@google.com>
> Reviewed-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> ---
>  include/linux/perf_event.h |    8 +++++---
>  kernel/perf_event.c        |   29 ++++++++++++++++-------------
>  2 files changed, 21 insertions(+), 16 deletions(-)
> 
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index ace31fb..b16cfba 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -532,6 +532,8 @@ struct hw_perf_event {
>  
>  struct perf_event;
>  
> +#define PERF_EVENT_TRAN_STARTED 1
> +
>  /**
>   * struct pmu - generic performance monitoring unit
>   */
> @@ -542,6 +544,9 @@ struct pmu {
>  	void (*stop)			(struct perf_event *event);
>  	void (*read)			(struct perf_event *event);
>  	void (*unthrottle)		(struct perf_event *event);
> +	void (*start_txn)		(const struct pmu *pmu);
> +	void (*stop_txn)		(const struct pmu *pmu);
> +	int (*commit_txn)		(const struct pmu *pmu);


Please add a few comments that briefly explain what these
*_txn callbacks are supposed to mean.

Unless txn is an acronym that most kernel developers are used to.

Thanks.


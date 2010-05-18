Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758395Ab0ERUO0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 16:14:26 -0400
Received: from kroah.org ([198.145.64.141]:52600 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758043Ab0ERUOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 16:14:18 -0400
Date: Tue, 18 May 2010 13:10:52 -0700
From: Greg KH <greg@kroah.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mundt <lethal@linux-sh.org>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Will Deacon <will.deacon@arm.com>, Maynard Johnson <mpjohn@us.ibm.com>,
       Carl Love <carll@us.ibm.com>, Kay Sievers <kay.sievers@vrfy.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH v2 10/11] perf: core, lookup pmu via sysfs
Message-ID: <20100518201052.GD20223@kroah.com>
References: <1274233778.3036.89.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274233778.3036.89.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 01:49:38AM +0000, Lin Ming wrote:
> Add another pmu lookup method via sysfs.
> Now we have 2 methods: type->pmu and sys_fd->pmu
> 
> Changes log,
> Lookup pmu via sysfs (Ingo Molnar)
> 
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> ---
>  kernel/perf_event.c |   33 ++++++++++++++++++++++++++++++++-
>  1 files changed, 32 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> index 8640610..0ab4a8b 100644
> --- a/kernel/perf_event.c
> +++ b/kernel/perf_event.c
> @@ -4680,7 +4680,7 @@ static struct pmu *sw_perf_event_init(struct perf_event *event)
>  	return pmu;
>  }
>  
> -static struct pmu *perf_event_lookup_pmu(struct perf_event *event)
> +static struct pmu *perf_event_lookup_pmu_by_type(struct perf_event *event)
>  {
>  	struct pmu *pmu = NULL;
>  	int pmu_id = PERF_EVENT_ATTR_TYPE(&event->attr);
> @@ -4708,6 +4708,37 @@ static struct pmu *perf_event_lookup_pmu(struct perf_event *event)
>  	return pmu;
>  }
>  
> +static struct pmu *perf_event_lookup_pmu_by_fd(struct perf_event *event)
> +{
> +	struct pmu *pmu = NULL;
> +	struct kobject *kobj;
> +	int sys_fd = PERF_EVENT_ATTR_FD(&event->attr);
> +	struct file *file;
> +	int fput_needed;
> +
> +	file = fget_light(sys_fd, &fput_needed);
> +	if (!file)
> +		return NULL;
> +
> +	kobj = sysfs_get_kobject(file);
> +	if (kobj)
> +		pmu = container_of(kobj, struct pmu, kobj);

Ick, no, I don't think this is a "valid" path to get a kobject.

How would the kernel internally have a file handle, and yet, not have
the kobject?  What is happening that it is so backwards?  Normally the
kobject will get called when its attributes are read or written to, then
you have the kobject handle.  You shouldn't have things the other way
around.

Or am I really missing something here?

> +
> +	fput_light(file, fput_needed);
> +
> +	return pmu;
> +}
> +
> +static struct pmu *perf_event_lookup_pmu(struct perf_event *event)
> +{
> +	u32 type = event->attr.type;
> +
> +	if (type & PERF_EVENT_FD)
> +		return perf_event_lookup_pmu_by_fd(event);

How are we getting here?

totally confused,

greg k-h

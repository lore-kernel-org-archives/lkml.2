Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab1HYRSB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 13:18:01 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:57932 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753516Ab1HYRR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 13:17:59 -0400
Date: Thu, 25 Aug 2011 10:17:56 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Cong Wang <amwang@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [patch] numa: fix NUMA compile error when sysfs and procfs are
 disabled
Message-Id: <20110825101756.fbbcc488.rdunlap@xenotime.net>
In-Reply-To: <alpine.DEB.2.00.1108242224180.576@chino.kir.corp.google.com>
References: <20110804145834.3b1d92a9eeb8357deb84bf83@canb.auug.org.au>
	<20110804152211.ea10e3e7.rdunlap@xenotime.net>
	<20110823143912.0691d442.akpm@linux-foundation.org>
	<4E547155.8090709@redhat.com>
	<20110824191430.8a908e70.rdunlap@xenotime.net>
	<4E55C221.8080100@redhat.com>
	<alpine.DEB.2.00.1108242224180.576@chino.kir.corp.google.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Aug 2011 22:55:02 -0700 (PDT) David Rientjes wrote:

> On Thu, 25 Aug 2011, Cong Wang wrote:
> 
> > Ah, this is because I missed the part in include/linux/node.h. :)
> > 
> > Below is the updated version.
> > 
> 
> I've never had a problem building a kernel with CONFIG_NUMA=y and 
> CONFIG_SYSFS=n since most of drivers/base/node.c is just an abstraction 
> that calls into sysfs functions that will be no-ops in such a 
> configuration.
> 
> The error you cite in a different thread 
> (http://marc.info/?l=linux-mm&m=131098795024186) about an undefined 
> reference to vmstat_text is because you have CONFIG_NUMA enabled and both 
> CONFIG_SYSFS and CONFIG_PROC_FS disabled and we only define vmstat_text 
> for those fs configurations since that's the only way these strings were 
> ever emitted before per-node vmstat.
> 
> The correct fix is to define the array for CONFIG_NUMA as well.
> 
> 
> 
> numa: fix NUMA compile error when sysfs and procfs are disabled
> 
> The vmstat_text array is only defined for CONFIG_SYSFS or CONFIG_PROC_FS, 
> yet it is referenced for per-node vmstat with CONFIG_NUMA:
> 
> 	drivers/built-in.o: In function `node_read_vmstat':
> 	node.c:(.text+0x1106df): undefined reference to `vmstat_text'
> 
> in fa25c503dfa2 (mm: per-node vmstat: show proper vmstats).
> 
> Define the array for CONFIG_NUMA as well.
> 
> Reported-by: Cong Wang <amwang@redhat.com>
> Signed-off-by: David Rientjes <rientjes@google.com>

Sure, that also works.
Acked-by: Randy Dunlap <rdunlap@xenotime.net>


> ---
>  include/linux/vmstat.h |    2 ++
>  mm/vmstat.c            |    4 ++--
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
> --- a/include/linux/vmstat.h
> +++ b/include/linux/vmstat.h
> @@ -258,6 +258,8 @@ static inline void refresh_zone_stat_thresholds(void) { }
>  
>  #endif		/* CONFIG_SMP */
>  
> +#if defined(CONFIG_PROC_FS) || defined(CONFIG_SYSFS) || defined(CONFIG_NUMA)
>  extern const char * const vmstat_text[];
> +#endif
>  
>  #endif /* _LINUX_VMSTAT_H */
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -659,7 +659,7 @@ static void walk_zones_in_node(struct seq_file *m, pg_data_t *pgdat,
>  }
>  #endif
>  
> -#if defined(CONFIG_PROC_FS) || defined(CONFIG_SYSFS)
> +#if defined(CONFIG_PROC_FS) || defined(CONFIG_SYSFS) || defined(CONFIG_NUMA)
>  #ifdef CONFIG_ZONE_DMA
>  #define TEXT_FOR_DMA(xx) xx "_dma",
>  #else
> @@ -788,7 +788,7 @@ const char * const vmstat_text[] = {
>  
>  #endif /* CONFIG_VM_EVENTS_COUNTERS */
>  };
> -#endif /* CONFIG_PROC_FS || CONFIG_SYSFS */
> +#endif /* CONFIG_PROC_FS || CONFIG_SYSFS || CONFIG_NUMA */
>  
>  
>  #ifdef CONFIG_PROC_FS


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933280Ab0JGBWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 21:22:18 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52520 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754578Ab0JGBWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 21:22:17 -0400
Message-ID: <4CAD206A.1090708@cn.fujitsu.com>
Date: Thu, 07 Oct 2010 09:20:42 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: eranian@google.com
CC: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
        perfmon2-devel@lists.sf.net, eranian@gmail.com, robert.richter@amd.com,
        acme@redhat.com
Subject: Re: [RFC PATCH 1/2] perf_events: add support for per-cpu per-cgroup
 monitoring (v4)
References: <4cac3d2e.21edd80a.7008.1831@mx.google.com>
In-Reply-To: <4cac3d2e.21edd80a.7008.1831@mx.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephane Eranian wrote:
> This kernel patch adds the ability to filter monitoring based on
> container groups (cgroups). This is for use in per-cpu mode only.
>     
> The cgroup to monitor is passed as a file descriptor in the pid
> argument to the syscall. The file descriptor must be opened to 
> the cgroup name in the cgroup filesystem. For instance, if the
> cgroup name is foo and cgroupfs is mounted in /cgroup, then the
> file descriptor is opened to /cgroup/foo. Cgroup mode is
> activated by passing PERF_FLAG_PID_CGROUP into the flags argument
> to the syscall.
>     
> Signed-off-by: Stephane Eranian <eranian@google.com>
> 
> ---
> 
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index 709dfb9..67cf276 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -623,6 +623,8 @@ bool css_is_ancestor(struct cgroup_subsys_state *cg,
>  unsigned short css_id(struct cgroup_subsys_state *css);
>  unsigned short css_depth(struct cgroup_subsys_state *css);
>  
> +struct cgroup_subsys_state *cgroup_css_from_dir(struct file *f, int id);
> +
>  #else /* !CONFIG_CGROUPS */
>  
>  static inline int cgroup_init_early(void) { return 0; }
> diff --git a/include/linux/cgroup_subsys.h b/include/linux/cgroup_subsys.h
> index ccefff0..93f86b7 100644
> --- a/include/linux/cgroup_subsys.h
> +++ b/include/linux/cgroup_subsys.h
> @@ -65,4 +65,8 @@ SUBSYS(net_cls)
>  SUBSYS(blkio)
>  #endif
>  
> +#ifdef CONFIG_PERF_EVENTS
> +SUBSYS(perf)
> +#endif
> +
>  /* */
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 61b1e2d..ad79f0a 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -454,6 +454,7 @@ enum perf_callchain_context {
>  
>  #define PERF_FLAG_FD_NO_GROUP	(1U << 0)
>  #define PERF_FLAG_FD_OUTPUT	(1U << 1)
> +#define PERF_FLAG_PID_CGROUP	(1U << 2) /* pid=cgroup id, per-cpu mode */
>  
>  #ifdef __KERNEL__
>  /*
> @@ -461,6 +462,7 @@ enum perf_callchain_context {
>   */
>  
>  #ifdef CONFIG_PERF_EVENTS
> +# include <linux/cgroup.h>
>  # include <asm/perf_event.h>
>  # include <asm/local64.h>
>  #endif
> @@ -698,6 +700,18 @@ struct swevent_hlist {
>  #define PERF_ATTACH_CONTEXT	0x01
>  #define PERF_ATTACH_GROUP	0x02
>  
> +#ifdef CONFIG_CGROUPS
> +struct perf_cgroup_time {
> +	u64 time;
> +	u64 timestamp;
> +};
> +
> +struct perf_cgroup {
> +	struct cgroup_subsys_state css;
> +	struct perf_cgroup_time *time;
> +};

Can we avoid adding this perf cgroup subsystem? It has 2 disavantages:

- If one mounted cgroup fs without perf cgroup subsys, he can't monitor it.
- If there are several different cgroup mount points, only one can be
  monitored.

To choose which cgroup hierarchy to monitor, hierarchy id can be passed
from userspace, which is the 2nd column below:

$ cat /proc/cgroups
#subsys_name    hierarchy       num_cgroups     enabled
debug   0       1       1
net_cls 0       1       1

> +#endif

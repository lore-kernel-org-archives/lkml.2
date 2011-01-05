Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751307Ab1AEDNH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 22:13:07 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53413 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750895Ab1AEDNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 22:13:05 -0500
Message-ID: <4D23E1D1.3000400@cn.fujitsu.com>
Date: Wed, 05 Jan 2011 11:13:21 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: eranian@google.com
CC: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
        perfmon2-devel@lists.sf.net, eranian@gmail.com, robert.richter@amd.com,
        acme@redhat.com
Subject: Re: [PATCH 4/5] perf_events: add cgroup support (v7)
References: <4d2205a1.8b02e30a.3541.ffff8aee@mx.google.com>
In-Reply-To: <4d2205a1.8b02e30a.3541.ffff8aee@mx.google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-01-05 11:12:43,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-01-05 11:12:43,
	Serialize complete at 2011-01-05 11:12:43
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
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
> activated by passing PERF_FLAG_PID_CGROUP in the flags argument
> to the syscall.
> 
> For instance to measure in cgroup foo on CPU1 assuming
> cgroupfs is mounted under /cgroup:
> 
> struct perf_event_attr attr;
> int cgroup_fd, fd;
> 
> cgroup_fd = open("/cgroup/foo", O_RDONLY);
> fd = perf_event_open(&attr, cgroup_fd, 1, -1, PERF_FLAG_PID_CGROUP);
> close(cgroup_fd);
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>

For the cgroup part:

Acked-by: Li Zefan <lizf@cn.fujitsu.com>

a few comments below:

> 
...
> +config CGROUP_PERF
> +	bool "Enable perf_event per-cpu per-container group (cgroup) monitoring"
> +	depends on PERF_EVENTS && CGROUPS

Depending on CGROUPS is already implicated by "if CGROUPS"

> +	help
> +	  This option extends the per-cpu mode to restrict monitoring to
> +	  threads which belong to the cgroup specificied and run on the
> +	  designated cpu.
> +
> +	  Say N if unsure.
> +
>  menuconfig CGROUP_SCHED
>  	bool "Group CPU scheduler"
>  	depends on EXPERIMENTAL
...
> +static inline int perf_cgroup_connect(int fd, struct perf_event *event,
> +				      struct perf_event_attr *attr,
> +				      struct perf_event *group_leader)
> +{
> +	struct perf_cgroup *cgrp;
> +	struct cgroup_subsys_state *css;
> +	struct file *file;
> +	int ret = 0, fput_needed;
> +
> +	file = fget_light(fd, &fput_needed);
> +	if (!file)
> +		return -EBADF;
> +
> +	css = cgroup_css_from_dir(file, perf_subsys_id);
> +	if (IS_ERR(css))
> +		return PTR_ERR(css);
> +
> +	cgrp = container_of(css, struct perf_cgroup, css);
> +	event->cgrp = cgrp;
> +
> +	/*
> +	 * all events in a group must monitor
> +	 * the same cgroup because a thread belongs
> +	 * to only one perf cgroup at a time
> +	 */
> +	if (group_leader && group_leader->cgrp != cgrp) {
> +		perf_detach_cgroup(event);

This doesn't seem right, because we haven't got the cgroup
refcount.

> +		ret = -EINVAL;
> +	} else {
> +		/* must be done before we fput() the file */
> +		perf_get_cgroup(event);
> +	}
> +	fput_light(file, fput_needed);
> +	return ret;
> +}

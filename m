Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932564Ab2KEOnl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 09:43:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42522 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606Ab2KEOnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 09:43:40 -0500
Date: Mon, 5 Nov 2012 08:43:29 -0600
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Will Drewry <wad@chromium.org>, Cyrill Gorcunov <gorcunov@openvz.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v2] proc: add "Seccomp" to status
Message-ID: <20121105144329.GB8292@sergelap>
References: <20121101183516.GA18332@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121101183516.GA18332@www.outflux.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Kees Cook (keescook@chromium.org):
> It is currently impossible to examine the state of seccomp for
> a given process. While attaching with gdb and attempting "call
> prctl(PR_GET_SECCOMP,...)" will work with some situations, it is not
> reliable. If the process is in seccomp mode 1, this query will kill the
> process (prctl not allowed), if the process is in mode 2 with prctl not
> allowed, it will similarly be killed, and in weird cases, if prctl is
> filtered to return errno 0, it can look like seccomp is disabled.
> 
> When reviewing the state of running processes, there should be a way to
> externally examine the seccomp mode. ("Did this build of Chrome end up
> using seccomp?" "Did my distro ship ssh with seccomp enabled?")
> 
> This adds the "Seccomp" line to /proc/$pid/status.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Reviewed-by: Cyrill Gorcunov <gorcunov@openvz.org>

Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>

One nit:

> 
> ---
> v2:
>  - improve commit message, add documentation, as suggested by akpm.
> ---
>  Documentation/filesystems/proc.txt |    2 ++
>  fs/proc/array.c                    |    8 ++++++++
>  2 files changed, 10 insertions(+)
> 
> diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
> index a1793d6..557891d 100644
> --- a/Documentation/filesystems/proc.txt
> +++ b/Documentation/filesystems/proc.txt
> @@ -181,6 +181,7 @@ read the file /proc/PID/status:
>    CapPrm: 0000000000000000
>    CapEff: 0000000000000000
>    CapBnd: ffffffffffffffff
> +  Seccomp:        0

Unless my mailer has messed with it, i notice that here there are 8 spaces,
whereas the code introduces a tab.  Not sure if that might confuse some
people writing simple parsers.

>    voluntary_ctxt_switches:        0
>    nonvoluntary_ctxt_switches:     1
>  
> @@ -237,6 +238,7 @@ Table 1-2: Contents of the status files (as of 2.6.30-rc7)
>   CapPrm                      bitmap of permitted capabilities
>   CapEff                      bitmap of effective capabilities
>   CapBnd                      bitmap of capabilities bounding set
> + Seccomp                     seccomp mode, like prctl(PR_GET_SECCOMP, ...)
>   Cpus_allowed                mask of CPUs on which this process may run
>   Cpus_allowed_list           Same as previous, but in "list format"
>   Mems_allowed                mask of memory nodes allowed to this process
> diff --git a/fs/proc/array.c b/fs/proc/array.c
> index c1c207c..135d6ac 100644
> --- a/fs/proc/array.c
> +++ b/fs/proc/array.c
> @@ -327,6 +327,13 @@ static inline void task_cap(struct seq_file *m, struct task_struct *p)
>  	render_cap_t(m, "CapBnd:\t", &cap_bset);
>  }
>  
> +static inline void task_seccomp(struct seq_file *m, struct task_struct *p)
> +{
> +#ifdef CONFIG_SECCOMP
> +	seq_printf(m, "Seccomp:\t%d\n", p->seccomp.mode);
> +#endif
> +}
> +
>  static inline void task_context_switch_counts(struct seq_file *m,
>  						struct task_struct *p)
>  {
> @@ -360,6 +367,7 @@ int proc_pid_status(struct seq_file *m, struct pid_namespace *ns,
>  	}
>  	task_sig(m, task);
>  	task_cap(m, task);
> +	task_seccomp(m, task);
>  	task_cpus_allowed(m, task);
>  	cpuset_task_status_allowed(m, task);
>  	task_context_switch_counts(m, task);
> -- 
> 1.7.9.5
> 
> 
> -- 
> Kees Cook
> Chrome OS Security

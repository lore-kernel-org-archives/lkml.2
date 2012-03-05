Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256Ab2CECEY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 21:04:24 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:42548 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756202Ab2CECEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 21:04:23 -0500
X-AuditID: 9c930179-b7c4fae0000073fb-af-4f541f23104b
Message-ID: <4F541F20.7000405@lge.com>
Date: Mon, 05 Mar 2012 11:04:16 +0900
From: Namhyung Kim <namhyung.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:10.0) Gecko/20120129 Thunderbird/10.0
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Luigi Semenzato <semenzato@chromium.org>
CC: Alexander Viro <viro@zeniv.linux.org.uk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Stephen Wilson <wilsons@start.ca>, Oleg Nesterov <oleg@redhat.com>,
        Tejun Heo <tj@kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andi Kleen <ak@linux.intel.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@gmail.com>,
        Robert Richter <robert.richter@amd.com>, linux-kernel@vger.kernel.org,
        sonnyrao@chromium.org, olofj@chromium.org, eranian@google.com
Subject: Re: [PATCH] perf: add PERF_RECORD_EXEC type, to distinguish from
 PERF_RECORD_COMM (DO NOT APPLY)
References: <1330716607-28227-1-git-send-email-semenzato@chromium.org>
In-Reply-To: <1330716607-28227-1-git-send-email-semenzato@chromium.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, again.

2012-03-03 4:30 AM, Luigi Semenzato wrote:
> ---- NOT FINISHED - NOT TESTED ---- rfc only
>
> I agree with others that adding a new record type is the cleanest solution.
> This is more or less what it takes to add a new record type.  It may be
> more than we like but that's a separate problem.  I am open to other
> solutions.  I may be able to do a bit of refactoring to reduce the
> copy-paste, but of course the CL will grow as the refactoring would
> not be limited to COMM and EXEC.
>
> ---- actual commit message below ----
>
> Currently the kernel produces a PERF_RECORD_COMM type record both when
> a process execs and when it renames its "comm" name.  The "perf report"
> command interprets each COMM record as an exec, and flushes all
> mappings to executables when it encounters one.  This can result in the
> inability to correlate IP samples to function symbols.
>
> This CL adds a PERF_RECORD_EXEC type, which doesn't contain the process
> name (the comm field).  Thus, an exec now must send two records, one EXEC
> and one COMM, whereas a rename sends only a COMM.
>
> The change is mostly straightforward, but there are some complications
> in the synthesized events sent when "perf record" starts to account for
> existing processes.
>
> Signed-off-by: Luigi Semenzato<semenzato@chromium.org>
> ---
>   fs/exec.c                  |    1 +
>   include/linux/perf_event.h |   19 +++++-
>   kernel/events/core.c       |  153 +++++++++++++++++++++++++++++++++++++++++---
>   tools/perf/builtin-test.c  |   24 ++-----
>   tools/perf/builtin-top.c   |    5 +-
>   tools/perf/util/event.c    |  148 +++++++++++++++++++++++++++++-------------
>   tools/perf/util/event.h    |   11 +++
>   tools/perf/util/evsel.c    |    5 +-
>   tools/perf/util/python.c   |   42 +++++++++++-
>   tools/perf/util/session.c  |   11 +++
>   tools/perf/util/thread.c   |    1 -
>   tools/perf/util/tool.h     |    1 +
>   12 files changed, 338 insertions(+), 83 deletions(-)
>
> diff --git a/fs/exec.c b/fs/exec.c
> index e33501a..077d199 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1144,6 +1144,7 @@ void setup_new_exec(struct linux_binprm * bprm)
>   	else
>   		set_dumpable(current->mm, suid_dumpable);
>
> +        perf_event_exec(current);
>   	set_task_comm(current, bprm->tcomm);
>
>   	/* Set the new mm task size. We have to do that late because it may
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 64426b7..8e4a472 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -200,8 +200,8 @@ struct perf_event_attr {
>   				exclude_kernel :  1, /* ditto kernel          */
>   				exclude_hv     :  1, /* ditto hypervisor      */
>   				exclude_idle   :  1, /* don't count when idle */
> -				mmap           :  1, /* include mmap data     */
> -				comm	       :  1, /* include comm data     */
> +				mmap_attr      :  1, /* include mmap data     */
> +				comm_attr      :  1, /* include comm data     */
>   				freq           :  1, /* use freq, not period  */
>   				inherit_stat   :  1, /* per task counts       */
>   				enable_on_exec :  1, /* next exec enables     */
> @@ -223,8 +223,10 @@ struct perf_event_attr {
>
>   				exclude_host   :  1, /* don't count in host   */
>   				exclude_guest  :  1, /* don't count in guest  */
> +                                /* COMM used to mean exec in older versions   */
> +                                exec_attr      :  1, /* include exec data     */
>
> -				__reserved_1   : 43;
> +				__reserved_1   : 42;
>

This new bit will cause the same issue with ->sample_id_all and 
->exclude_{host,guest} on old kernels. It needs to be handled too in a similar 
way of perf record/top IMHO.

Thanks,
Namhyung


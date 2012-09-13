Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213Ab2IMUX3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 16:23:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42104 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758103Ab2IMUX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 16:23:26 -0400
Message-ID: <505240BA.1010804@gmail.com>
Date: Thu, 13 Sep 2012 14:23:22 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, acme@ghostprotocols.net, namhyung@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] perf, tools: Stop perf stat -p when profiled process
 exits v3
References: <1347551931-7666-1-git-send-email-andi@firstfloor.org>
In-Reply-To: <1347551931-7666-1-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/13/12 9:58 AM, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
>
> When counting a process with perf stat -p check if the process died
> and exit collection if yes.
>
> v2: Add more checks, handle non -p again. Handle /proc not there.
> v3: Handle multi pid case. Fix non /proc error path
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>   tools/perf/builtin-stat.c |   14 +++++++++++++-
>   1 files changed, 13 insertions(+), 1 deletions(-)
>
> diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
> index 861f0ae..b5e7df2 100644
> --- a/tools/perf/builtin-stat.c
> +++ b/tools/perf/builtin-stat.c
> @@ -536,7 +536,19 @@ static int run_perf_stat(int argc __used, const char **argv)
>   		if (WIFSIGNALED(status))
>   			psignal(WTERMSIG(status), argv[0]);
>   	} else {
> -		while(!done) sleep(1);
> +		char piddir[40];
> +		int check_proc = target.pid &&
> +				 access("/proc", X_OK) == 0 &&
> +				 !strchr(target.pid, ',');
> +		if (check_proc)
> +			snprintf(piddir, sizeof piddir, "/proc/%d",
> +				 atoi(target.pid));
> +		while(!done) {
> +			sleep(1);
> +			if (check_proc && access(piddir, X_OK) < 0 &&
> +			    errno == ENOENT)
> +				break;
> +		}
>   	}

I still think this is the wrong approach. A more complete solution would 
monitor all of the targets given by the user. e.g.,

1. create a perf_target__parse_pid - all it needs to do is:
    struct strlist *slist = strlist__new(false, pid_str);
and save that into the target struct. That line is currently done in 
thread_map.c, thread_map__new_by_pid_str() and 
thread_map__new_by_tid_str. Those functions can be altered to take the 
slist instead of the string.

2. create a perf_target__is_alive that runs through each entry in the 
slist (strlist__for_each(pos, slist)) and checks that it still exists. 
As long as 1 target is alive it returns true. If no pid or tid is 
specified it always returns true.

The is_alive function can be used by perf-top, perf-stat and perf-record 
to know that its target has died so it can stop monitoring.


David

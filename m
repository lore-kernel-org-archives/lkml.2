Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367Ab2IDQAZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 12:00:25 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54620 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757085Ab2IDQAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 12:00:24 -0400
Message-ID: <50462594.7080204@gmail.com>
Date: Tue, 04 Sep 2012 10:00:20 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: chenggang qin <chenggang.qin@gmail.com>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, acme@ghostprotocols.net,
        namhyung.kim@lge.com, a.p.zijlstra@chello.nl, paulus@samba.org,
        nelhage@nelhage.com
Subject: Re: [PATCH]Perf top:  Add ability to detect new threads dynamically
 during 'perf top -p 'pid'' is running
References: <5034EE98.3070406@gmail.com>
In-Reply-To: <5034EE98.3070406@gmail.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/22/12 8:37 AM, chenggang qin wrote:
> From: Chenggang Qin <chenggang.qin@gmail.com>
> 
> While we use "perf top -p 'pid'" to monitor the symbols of specified
> processes, some new threads would be created by the monitored processes
> during "perf top" is running. In current version, these new threads and
> their symbols cannot be shown.
> This patch add ability to show these new threads.
> 
> Signed-off-by: Chenggang Qin <chenggang.qcg@taobao.com>
> 
> ---
>   tools/perf/builtin-top.c |   86 ++++++++++++++++++++++++++++++++++++++++++++--
>   tools/perf/util/evlist.c |    2 ++
>   2 files changed, 85 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
> index 68cd61e..54c9cc1 100644
> --- a/tools/perf/builtin-top.c
> +++ b/tools/perf/builtin-top.c
> @@ -882,7 +882,7 @@ static void perf_top__mmap_read(struct perf_top *top)
>   		perf_top__mmap_read_idx(top, i);
>   }
>   
> -static void perf_top__start_counters(struct perf_top *top)
> +static int perf_top__start_counters(struct perf_top *top)
>   {
>   	struct perf_evsel *counter, *first;
>   	struct perf_evlist *evlist = top->evlist;
> @@ -929,6 +929,10 @@ try_again:
>   				     group_fd) < 0) {
>   			int err = errno;
>   
> +			if (err == ESRCH) {
> +				return err;
> +			}
> +
>   			if (err == EPERM || err == EACCES) {
>   				ui__error_paranoid();
>   				goto out_err;
> @@ -994,7 +998,7 @@ try_again:
>   		goto out_err;
>   	}
>   
> -	return;
> +	return 0;
>   
>   out_err:
>   	exit_browser(0);
> @@ -1018,6 +1022,77 @@ static int perf_top__setup_sample_type(struct perf_top *top)
>   	return 0;
>   }
>   
> +static int thread_map_cmp(struct thread_map *threads_a,
> +			  struct thread_map *threads_b)
> +{
> +	int i, j;
> +
> +	if (threads_a->nr != threads_b->nr) {
> +		return 1;
> +	} else {
> +		for (i = 0; i < threads_b->nr; i++) {
> +			for (j = 0; j < threads_a->nr; j++)
> +				if (threads_b->map[i] == threads_a->map[j])
> +					break;
> +
> +			if (j == threads_a->nr)
> +				return 1;
> +		}
> +
> +		return 0;
> +	}
> +}
> +
> +static void check_new_threads(struct perf_top *top)
> +{
> +	struct thread_map *new_thread_map;
> +	struct perf_evsel *counter;
> +	struct perf_evlist *evlist = top->evlist;
> +
> +retry:
> +	new_thread_map = thread_map__new_str(top->target.pid, top->target.tid,
> +					     top->target.uid);
> +	if (!new_thread_map)
> +		return;
> +
> +	if (thread_map_cmp(top->evlist->threads, new_thread_map) == 0) {
> +		free(new_thread_map);
> +		return;
> +	} else {
> +		list_for_each_entry(counter, &evlist->entries, node) {
> +			perf_evsel__close(counter, top->evlist->cpus->nr,
> +					  top->evlist->threads->nr);
> +		}
> +
> +		if (top->evlist->mmap)
> +			perf_evlist__munmap(top->evlist);
> +
> +		if (top->evlist->pollfd) {
> +			free(top->evlist->pollfd);
> +			top->evlist->pollfd = NULL;
> +		}
> +
> +		top->evlist->nr_fds = 0;
> +
> +		thread_map__delete(top->evlist->threads);
> +		top->evlist->threads = new_thread_map;
> +
> +		if (perf_top__start_counters(top) == ESRCH) {
> +			while (thread_map_cmp(top->evlist->threads,
> +					      new_thread_map) == 0) {
> +				new_thread_map = thread_map__new_str(top->target.pid,
> +								     top->target.tid,
> +								     top->target.uid);
> +				if (!new_thread_map)
> +					return;
> +			}
> +			goto retry;
> +		}
> +
> +		return;
> +	}
> +}
> +

I think it would be better to respond to FORK (and EXIT) events and open
(close) counters accordingly. perf-top gets events when a thread is
created or terminated; it might as well use the events to react than to
poll every trip through the loop.

David

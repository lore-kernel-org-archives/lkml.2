Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492Ab1IUPad (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 11:30:33 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63095 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab1IUPac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 11:30:32 -0400
Date: Wed, 21 Sep 2011 17:30:24 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, a.p.zijlstra@chello.nl,
        mingo@elte.hu, paulus@samba.org, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] perf tools: Fix tracing info recording
Message-ID: <20110921153016.GB1811@somewhere>
References: <1314022997-9217-1-git-send-email-jolsa@redhat.com>
 <1314023913.2307.63.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <20110822145210.GA8694@jolsa.brq.redhat.com>
 <1314028266.2307.93.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <20110822160713.GA10134@jolsa.brq.redhat.com>
 <20110829132037.GB27261@ghostprotocols.net>
 <20110829134147.GD1918@jolsa.redhat.com>
 <20110829142547.GC27261@ghostprotocols.net>
 <20110914135840.GC2719@jolsa.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110914135840.GC2719@jolsa.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 14, 2011 at 03:58:40PM +0200, Jiri Olsa wrote:
> The tracing information is part of the perf data file. It contains
> several files from within the tracing debugfs and procs directories.
> 
> Beside some static header files, for each tracing event the format
> file is added. The /proc/kallsyms file is also added.
> 
> The tracing data are stored with preceeding size. This is causing some
> dificulties for pipe output, since there's no way to tell debugfs/proc
> file size before reading it. So, for pipe output, all the debugfs files
> were read twice. Once to get the overall size and once to store the
> content itself. This can cause problem in case any of these file
> changed, within the storage time.
> 
> Fixing this behaviour by using temp file in case of pipe output. The
> debugfs/proc files are being read only once, ensuring the integrity of
> the tracing data.
> 
> Also changing the way the event files are searched by quering specified
> event files directly, instead of walking the events directory.
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>

Looks good overall, but I have some comments about details:

> ---
>  tools/perf/util/header.c           |   39 ++++-
>  tools/perf/util/parse-events.h     |    1 +
>  tools/perf/util/trace-event-info.c |  333 +++++++++++++++++++-----------------
>  tools/perf/util/trace-event.h      |    7 +
>  4 files changed, 215 insertions(+), 165 deletions(-)
> 
> diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
> index b6c1ad1..6a9fd5b 100644
> --- a/tools/perf/util/header.c
> +++ b/tools/perf/util/header.c
> @@ -387,13 +387,21 @@ static int perf_header__adds_write(struct perf_header *header,
>  
>  	if (perf_header__has_feat(header, HEADER_TRACE_INFO)) {
>  		struct perf_file_section *trace_sec;
> +		struct tracing_data *tdata;
>  
>  		trace_sec = &feat_sec[idx++];
> -
> -		/* Write trace info */
>  		trace_sec->offset = lseek(fd, 0, SEEK_CUR);
> -		read_tracing_data(fd, &evlist->entries);
> -		trace_sec->size = lseek(fd, 0, SEEK_CUR) - trace_sec->offset;
> +
> +		/*
> +		 * We work over the real file, we can write data
> +		 * directly, not temp file is needed.

s/not/no

May be also briefly explain why we can write directly here. The fact
we have reserved space to write the size in the headers already.

> +		 */
> +		tdata = tracing_data_get(&evlist->entries, fd, false);
> +		if (!tdata)
> +			goto out_free;
> +
> +		trace_sec->size = tracing_data_size(tdata);
> +		tracing_data_put(tdata);
>  	}
>  
>  	if (perf_header__has_feat(header, HEADER_BUILD_ID)) {
> @@ -1100,15 +1108,25 @@ int perf_event__synthesize_tracing_data(int fd, struct perf_evlist *evlist,
>  				   struct perf_session *session __unused)
>  {
>  	union perf_event ev;
> +	struct tracing_data *tdata;
>  	ssize_t size = 0, aligned_size = 0, padding;
>  	int err __used = 0;
>  
> +	/*
> +	 * The fd descriptor is pipe, se we need to:
> +	 * - write the tracing data to the temp file
> +	 * - get/write the data size to pipe
> +	 * - write the tracing data from the temp file
> +	 *   to the pipe
> +	 */

That also needs a brief explanation on why we need to do that.


> +	tdata = tracing_data_get(&evlist->entries, fd, true);
> +	if (!tdata)
> +		return -1;
> +
>  	memset(&ev, 0, sizeof(ev));
>  
>  	ev.tracing_data.header.type = PERF_RECORD_HEADER_TRACING_DATA;
> -	size = read_tracing_data_size(fd, &evlist->entries);
> -	if (size <= 0)
> -		return size;
> +	size = tracing_data_size(tdata);
>  	aligned_size = ALIGN(size, sizeof(u64));
>  	padding = aligned_size - size;
>  	ev.tracing_data.header.size = sizeof(ev.tracing_data);
<snip>
> -int read_tracing_data(int fd, struct list_head *pattrs)
> +#define FILENAME_SIZE 50
> +
> +struct tracing_data {
> +	ssize_t size;
> +	bool temp;
> +	char temp_file[FILENAME_SIZE];
> +};
> +
> +ssize_t tracing_data_size(struct tracing_data *td)
>  {
> -	char buf[BUFSIZ];
> -	struct tracepoint_path *tps = get_tracepoints_path(pattrs);
> +	return td->size;
> +}

May be inline it. Or rather directly access td->size from calling code.

>  
> -	/*
> -	 * What? No tracepoints? No sense writing anything here, bail out.
> -	 */
> -	if (tps == NULL)
> -		return -1;
> +static char *get_format_file(char *sys, char *name)
> +{
> +	char *file, *path;
>  
> -	output_fd = fd;
> +	path = get_tracing_file("events");
> +	if (!path)
> +		return NULL;
> +
> +	file = malloc_or_die(strlen(path) + strlen(sys) +
> +			     strlen(name) + strlen("format") + 10);

Why "10" ?

> +
> +	sprintf(file, "%s/%s/%s/format", path, sys, name);
> +	return file;
> +}
> +
> +static void put_format_file(char *file)
> +{
> +	free(file);
> +}
> +
> +/*
> + * Walk tracepoint event objects and store them.
> + * Only those matching the sys parameter are stored
> + * and marked as done.
> + */
> +static void read_event_files_system(struct tracepoint_path *tps,
> +				    const char *sys)
> +{
> +	off_t count_pos;
> +	u32 count = 0;
> +
> +	/* specified events count under single system */
> +	count_pos = lseek(output_fd, 0, SEEK_CUR);
> +	write_or_die(&count, 4);
> +
> +	while (tps) {
> +		if ((!tps->done) &&
> +		    (!strcmp(sys, tps->system))) {
> +			char *file;
> +
> +			file = get_format_file(tps->system, tps->name);
> +			if (file) {
> +				record_file(file, 8);
> +				count++;
> +			}
> +
> +			put_format_file(file);
> +			tps->done = 1;
> +		}
> +
> +		tps = tps->next;
> +	}
> +
> +	if (pwrite(output_fd, &count, 4, count_pos) < 0)
> +		die("pwrite");
> +}
> +
> +/*
> + * We have all needed tracepoint event files stored in
> + * the tracepoint_path objects.
> + *
> + * - first we store ftrace system events
> + * - then we walk all '!done' event objects
> + *   and process them
> + */
> +static void read_event_files(struct tracepoint_path *tps)
> +{
> +	off_t count_pos;
> +	u32 count = 0;
> +
> +	read_event_files_system(tps, "ftrace");
> +
> +	/* systems count */
> +	count_pos = lseek(output_fd, 0, SEEK_CUR);
> +	write_or_die(&count, 4);
> +
> +	while (tps) {
> +		if (!tps->done) {
> +			write_or_die(tps->system, strlen(tps->system) + 1);
> +			read_event_files_system(tps, tps->system);
> +			count++;
> +		}
> +
> +		tps = tps->next;
> +	}
>  
> +	if (pwrite(output_fd, &count, 4, count_pos) < 0)
> +		die("write");
> +}

There seem to be a significant reorganization of the code in that file
that seem to overlap the initial scope of this patch. Should
it go to a seperate single purpose patch?

Thanks.

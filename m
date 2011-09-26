Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751347Ab1IZNgf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 09:36:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:46134 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab1IZNge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 09:36:34 -0400
X-Authority-Analysis: v=1.1 cv=lfM0d0QHaVz67dfwwr9cyIw6NbaGR/pZhMD6XWNi0kk= c=1 sm=0 a=v1jNb7L17ooA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=TDnvZG57wSb01ToM4ykA:9 a=kXKlPUSn6gp_LzTj8SUA:7 a=PUjeQqilurYA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [PATCHv2 1/2] perf tools: Collect tracing event data files
 directly
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, eric.dumazet@gmail.com, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        linux-kernel@vger.kernel.org, nhorman@tuxdriver.com
Date: Mon, 26 Sep 2011 09:36:31 -0400
In-Reply-To: <1317028312-5156-2-git-send-email-jolsa@redhat.com>
References: <20110925133406.GB2702@jolsa.brq.redhat.com>
	 <1317028312-5156-1-git-send-email-jolsa@redhat.com>
	 <1317028312-5156-2-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1317044192.26514.1.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-26 at 11:11 +0200, Jiri Olsa wrote:
> Changing the way the event files are searched by quering specified
> event files directly, instead of walking the events directory.
> 
> Hopefully this way is more straightforward and faster.

Have you looked at my code I posted earlier that uses the libparsevents?

It uses globs such that you could do -e sched:sched* and it will enable
all sched events.

-- Steve



> +	 * and one safety byte ;)
> +	 */
> +	file = malloc_or_die(strlen(path) + strlen(sys) +
> +			     strlen(name) + strlen("format") + 5);
>  
> -		free(format);
> -	}
> -	closedir(dir);
> +	sprintf(file, "%s/%s/%s/format", path, sys, name);
> +	return file;
>  }
>  
> -static void read_ftrace_files(struct tracepoint_path *tps)
> +static void put_format_file(char *file)
>  {
> -	char *path;
> -
> -	path = get_tracing_file("events/ftrace");
> -
> -	copy_event_system(path, tps);
> -
> -	put_tracing_file(path);
> +	free(file);
>  }
>  
> -static bool system_in_tp_list(char *sys, struct tracepoint_path *tps)
> +/*
> + * Walk tracepoint event objects and store them.
> + * Only those matching the sys parameter are stored
> + * and marked as done.
> + */
> +static void read_event_files_system(struct tracepoint_path *tps,
> +				    const char *sys)
>  {
> +	off_t count_pos;
> +	u32 count = 0;
> +
> +	/* Place for number of events under single system. */
> +	count_pos = lseek(output_fd, 0, SEEK_CUR);
> +	write_or_die(&count, 4);
> +
>  	while (tps) {
> -		if (!strcmp(sys, tps->system))
> -			return true;
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
>  		tps = tps->next;



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326Ab0LFDQY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 22:16:24 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:34880 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab0LFDQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 22:16:23 -0500
X-AuditID: b753bd60-a62feba000000f8d-24-4cfc5584b4e6
Message-ID: <4CFC557B.10006@hitachi.com>
Date: Mon, 06 Dec 2010 12:16:11 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH -tip  4/7] perf bts trace: print pid and command
References: <20101203035832.7827.16528.stgit@localhost6.localdomain6> <20101203035920.7827.30087.stgit@localhost6.localdomain6>
In-Reply-To: <20101203035920.7827.30087.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/12/03 12:59), Akihiro Nagai wrote:
> Provide the function of printing pid and command name to
> 'perf bts trace'. Users can select items to print with options.
> For example,
>     'perf bts -p trace' prints only pid,
>     'perf bts -ac trace' prints address and comamnd name.
>     'perf bts trace' prints only address (default)
> 
> This is output sample (perf bts -ac trace):
> command      address
> ls           0xffffffff8146fe0e => ls           0x0000003806200b20
> ls           0xffffffff8146fe0e => ls           0x0000003806200b20
> ls           0x0000003806200b23 => ls           0x0000003806204910
> ls           0xffffffff8146fe0e => ls           0x0000003806204910
> ls           0xffffffff8146fe0e => ls           0x0000003806204936
> ls           0xffffffff8146fe0e => ls           0x000000380620493d
> ls           0x0000003806204981 => ls           0x00000038062049a3
> ls           0x00000038062049a7 => ls           0x0000003806204988
> 
> Signed-off-by: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>

Looks good to me :)

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Cc: linux-kernel@vger.kernel.org
> ---
> 
>  tools/perf/Documentation/perf-bts.txt |   18 ++++-
>  tools/perf/builtin-bts.c              |  124 ++++++++++++++++++++++++++++++++-
>  2 files changed, 135 insertions(+), 7 deletions(-)
> 
> diff --git a/tools/perf/Documentation/perf-bts.txt b/tools/perf/Documentation/perf-bts.txt
> index 5920dcc..56ddaa4 100644
> --- a/tools/perf/Documentation/perf-bts.txt
> +++ b/tools/perf/Documentation/perf-bts.txt
> @@ -3,7 +3,7 @@ perf-bts(1)
>  
>  NAME
>  ----
> -perf-bts - Record and print branch-trace-store log
> +perf-bts - Record and analyze branch-trace-store log
>  
>  SYNOPSIS
>  --------
> @@ -12,20 +12,32 @@ SYNOPSIS
>  
>  DESCRIPTION
>  -----------
> -This command can record and print branch-trace-store log.
> +This command can record and analyze branch-trace-store log.
>  Branch-trace-store is a facility of processors. It can record
>  address of branch to/from on every branch instruction and interrupt.
>  
>  'perf bts record <command>' records branch-trace-store log while specified
>  command is executing. And, save to the file "perf.data".
>  
> -'perf bts trace' parses recorded branch-trace-store log and prints it.
> +'perf bts trace' analyzes recorded branch-trace-store log and prints it.
> +The command can select the item to print. For example,
> +  'perf bts -a trace'	: prints only address
> +  'perf bts -acp trace'	: prints address, command name and pid
>  
>  OPTIONS
>  -------
>  -i::
>  --input=::
>          Specify input file name to analyze.
> +-a::
> +--addr::
> +	Print address. (default)
> +-c::
> +--comm::
> +	Print command name.
> +-p::
> +--pid::
> +	Print pid.
>  
>  SEE ALSO
>  --------
> diff --git a/tools/perf/builtin-bts.c b/tools/perf/builtin-bts.c
> index 54e83af..11e491b 100644
> --- a/tools/perf/builtin-bts.c
> +++ b/tools/perf/builtin-bts.c
> @@ -3,6 +3,7 @@
>  #include "util/parse-options.h"
>  #include "util/session.h"
>  #include "util/cache.h"
> +#include "util/trace-event.h"
>  #include <inttypes.h>
>  
>  /* format string of specifying min width to print address */
> @@ -14,6 +15,32 @@
>  /* format string to print address */
>  #define FMT_ADDR	"%#0" FMT_ADDR_WIDTH "llx"
>  
> +/* printable items */
> +struct exec_info {
> +	u64		addr;		/* recorded address by bts */
> +	pid_t		pid;		/* tracee process pid */
> +	const char	*comm;		/* command name */
> +};
> +
> +#define EI_PID_UNSET	-1
> +
> +/* flags which item print */
> +#define EI_FLAG_PRINT_ADDR		(1 << 0)
> +#define EI_FLAG_PRINT_PID		(1 << 1)
> +#define EI_FLAG_PRINT_COMM		(1 << 2)
> +
> +/* it's used when no print item specified */
> +#define EI_FLAG_PRINT_DEFAULT		EI_FLAG_PRINT_ADDR
> +
> +/* print item flags */
> +static unsigned long print_flags;
> +
> +#define is_flags_unset(flags)		(flags == 0)
> +
> +/* print it when we cannnot analyze and get the information */
> +#define EI_UNKNOWN_TEXT			"(unknown)"
> +#define EI_UNKNOWN_TEXT_LEN		(sizeof(EI_UNKNOWN_TEXT))
> +
>  /* default input file name to analyze */
>  static const char *input_name = "perf.data";
>  
> @@ -31,26 +58,111 @@ static const char * const record_args[] = {
>  	"-d",
>  };
>  
> +/* set print flags call from parse_options() */
> +static int set_print_flags(const struct option *opt, const char *str __unused,
> +							int unset __unused)
> +{
> +	print_flags |= (unsigned long)opt->defval;
> +	return 0;
> +}
> +
>  static const struct option bts_options[] = {
>  	OPT_STRING('i', "input", &input_name, "file", "input file name"),
> +	OPT_CALLBACK_DEFAULT_NOOPT('a', "addr", NULL, NULL,
> +				   "print address (default)", set_print_flags,
> +				   (void *)EI_FLAG_PRINT_ADDR),
> +	OPT_CALLBACK_DEFAULT_NOOPT('p', "pid", NULL, NULL,
> +				   "print pid", set_print_flags,
> +				   (void *)EI_FLAG_PRINT_PID),
> +	OPT_CALLBACK_DEFAULT_NOOPT('c', "comm", NULL, NULL,
> +				   "print command name", set_print_flags,
> +				   (void *)EI_FLAG_PRINT_COMM),
>  	OPT_END()
>  };
>  
> +static void init_exec_info(struct exec_info *ei)
> +{
> +	memset(ei, 0, sizeof(*ei));
> +	ei->pid = EI_PID_UNSET;
> +}
> +
> +/* collect printable items to struct exec_info */
> +static void fill_exec_info(struct exec_info *ei, struct perf_session *session,
> +						event_t *event, u64 addr)
> +{
> +	struct thread *thread;
> +
> +	ei->addr = addr;
> +	ei->pid = event->ip.pid;
> +
> +	thread = perf_session__findnew(session, event->ip.pid);
> +	if (!thread)
> +		return;
> +	ei->comm = thread->comm;
> +}
> +
> +static void __print_exec_info(struct exec_info *ei)
> +{
> +	char pid[16];
> +	const char *comm;
> +
> +	if (print_flags & EI_FLAG_PRINT_PID) {
> +		if (ei->pid == EI_PID_UNSET)
> +			strncpy(pid, EI_UNKNOWN_TEXT, EI_UNKNOWN_TEXT_LEN);
> +		else
> +			snprintf(pid, 16, "%d", ei->pid);
> +		printf("%5s ", pid);
> +	}
> +	if (print_flags & EI_FLAG_PRINT_COMM) {
> +		comm = ei->comm ? : EI_UNKNOWN_TEXT;
> +		printf("%-12s ", comm);
> +	}
> +	if (print_flags & EI_FLAG_PRINT_ADDR)
> +		printf(FMT_ADDR " ", ei->addr);
> +}
> +
> +static void print_exec_info(struct exec_info *ei_from, struct exec_info *ei_to)
> +{
> +	__print_exec_info(ei_from);
> +	printf("=> ");
> +	__print_exec_info(ei_to);
> +	printf("\n");
> +}
> +
> +static void print_exec_info_header(void)
> +{
> +	if (print_flags & EI_FLAG_PRINT_PID)
> +		printf("%5s ", "pid");
> +	if (print_flags & EI_FLAG_PRINT_COMM)
> +		printf("%-12s ", "command");
> +	if (print_flags & EI_FLAG_PRINT_ADDR)
> +		printf("%-" FMT_ADDR_WIDTH "s ", "address");
> +	printf("\n");
> +}
> +
>  static int process_sample_event(event_t *event, struct perf_session *session)
>  {
>  	struct sample_data data;
> +	struct exec_info ei_from, ei_to;
>  
>  	memset(&data, 0, sizeof(data));
>  	event__parse_sample(event, session->sample_type, &data);
>  
> +	init_exec_info(&ei_from);
> +	init_exec_info(&ei_to);
> +
>  	/* data.ip is 'from address', data.addr is 'to address' */
> -	printf(FMT_ADDR " => " FMT_ADDR "\n", data.ip, data.addr);
> +	fill_exec_info(&ei_from, session, event, data.ip);
> +	fill_exec_info(&ei_to, session, event, data.addr);
> +
> +	print_exec_info(&ei_from, &ei_to);
>  
>  	return 0;
>  }
>  
>  static struct perf_event_ops event_ops = {
>  	.sample			= process_sample_event,
> +	.comm			= event__process_comm,
>  	.ordered_samples	= false,
>  };
>  
> @@ -64,6 +176,12 @@ static int __cmd_trace(void)
>  		return -ENOMEM;
>  	}
>  
> +	/* if print flags are unset, we use default flags */
> +	if (is_flags_unset(print_flags))
> +		print_flags = EI_FLAG_PRINT_DEFAULT;
> +
> +	setup_pager();
> +	print_exec_info_header();
>  	perf_session__process_events(session, &event_ops);
>  	perf_session__delete(session);
>  
> @@ -104,10 +222,8 @@ int cmd_bts(int argc, const char **argv, const char *prefix __used)
>  
>  	if (!strncmp(argv[0], "record", 6))
>  		return __cmd_record(argc, argv);
> -	else if (!strncmp(argv[0], "trace", 5)) {
> -		setup_pager();
> +	else if (!strncmp(argv[0], "trace", 5))
>  		return __cmd_trace();
> -	}
>  	else
>  		usage_with_options(bts_usage, bts_options);
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com

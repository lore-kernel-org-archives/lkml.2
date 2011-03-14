Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993Ab1CNN3t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 09:29:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:36180 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755007Ab1CNN3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 09:29:48 -0400
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=ewJeRMG01NQA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=omOdbC7AAAAA:8 a=Yt3f_L5PIwsFyoXsk3wA:9 a=yMPVP5rkoeYn5yIprKwA:7 a=qbBj-9NBpOAgis5qcpSre1vZ4awA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 3/3 V2] trace-cmd: fold option parsing
From: Steven Rostedt <rostedt@goodmis.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4D7D808C.9010108@cn.fujitsu.com>
References: <4D78A0A9.40000@cn.fujitsu.com>
	 <1299762967.15854.335.camel@gandalf.stny.rr.com>
	 <4D7D808C.9010108@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 14 Mar 2011 09:29:46 -0400
Message-ID: <1300109386.9910.67.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-14 at 10:42 +0800, Lai Jiangshan wrote:
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
>  trace-listen.c |   14 +++++++-------
>  trace-read.c   |   37 +++++++++++++++++--------------------
>  trace-record.c |   16 +++++++---------
>  trace-stack.c  |   34 +++++++++++++++++-----------------
>  4 files changed, 48 insertions(+), 53 deletions(-)

Thanks Lai,

But I already applied your original changes, and then added a patch to
convert the defines into enums.

-- Steve

> 
> diff --git a/trace-listen.c b/trace-listen.c
> index e60c96b..e1cf9ea 100644
> --- a/trace-listen.c
> +++ b/trace-listen.c
> @@ -647,6 +647,10 @@ static void start_daemon(void)
>  		die("starting daemon");
>  }
>  
> +enum {
> +	OPT_debug	= 128,
> +};
> +
>  void trace_listen(int argc, char **argv)
>  {
>  	char *logfile = NULL;
> @@ -666,7 +670,7 @@ void trace_listen(int argc, char **argv)
>  		static struct option long_options[] = {
>  			{"port", required_argument, NULL, 'p'},
>  			{"help", no_argument, NULL, '?'},
> -			{"debug", no_argument, NULL, 0},
> +			{"debug", no_argument, NULL, OPT_debug},
>  			{NULL, 0, NULL, 0}
>  		};
>  
> @@ -696,12 +700,8 @@ void trace_listen(int argc, char **argv)
>  		case 'D':
>  			daemon = 1;
>  			break;
> -		case 0:
> -			switch (option_index) {
> -			case 2:
> -				debug = 1;
> -				break;
> -			}
> +		case OPT_debug:
> +			debug = 1;
>  			break;
>  		default:
>  			usage(argv);
> diff --git a/trace-read.c b/trace-read.c
> index 63e2940..dfd945e 100644
> --- a/trace-read.c
> +++ b/trace-read.c
> @@ -815,6 +815,12 @@ static void add_functions(struct pevent *pevent, const char *file)
>  	free(buf);
>  }
>  
> +enum {
> +	OPT_cpu		= 128,
> +	OPT_events,
> +	OPT_kallsyms,
> +};
> +
>  void trace_report (int argc, char **argv)
>  {
>  	struct tracecmd_input *handle;
> @@ -848,10 +854,10 @@ void trace_report (int argc, char **argv)
>  	for (;;) {
>  		int option_index = 0;
>  		static struct option long_options[] = {
> -			{"cpu", required_argument, NULL, 0},
> -			{"events", no_argument, NULL, 0},
> +			{"cpu", required_argument, NULL, OPT_cpu},
> +			{"events", no_argument, NULL, OPT_events},
>  			{"filter-test", no_argument, NULL, 'T'},
> -			{"kallsyms", required_argument, NULL, 0},
> +			{"kallsyms", required_argument, NULL, OPT_kallsyms},
>  			{"help", no_argument, NULL, '?'},
>  			{NULL, 0, NULL, 0}
>  		};
> @@ -920,23 +926,14 @@ void trace_report (int argc, char **argv)
>  		case 'q':
>  			silence_warnings = 1;
>  			break;
> -		case 0:
> -			switch(option_index) {
> -			case 0: /* cpu */
> -				parse_cpulist(optarg);
> -				break;
> -			case 1: /* events */
> -				print_events = 1;
> -				break;
> -			case 2: /* filter-test */
> -				test_filters = 1;
> -				break;
> -			case 3: /* kallsyms */
> -				functions = optarg;
> -				break;
> -			default:
> -				usage(argv);
> -			}
> +		case OPT_cpu:
> +			parse_cpulist(optarg);
> +			break;
> +		case OPT_events:
> +			print_events = 1;
> +			break;
> +		case OPT_kallsyms:
> +			functions = optarg;
>  			break;
>  		default:
>  			usage(argv);
> diff --git a/trace-record.c b/trace-record.c
> index 2611bfa..dd1f18c 100644
> --- a/trace-record.c
> +++ b/trace-record.c
> @@ -1809,6 +1809,10 @@ static void record_all_events(void)
>  	listed_events = list;
>  }
>  
> +enum {
> +	OPT_date	= 128,
> +};
> +
>  void trace_record (int argc, char **argv)
>  {
>  	const char *plugin = NULL;
> @@ -1862,7 +1866,7 @@ void trace_record (int argc, char **argv)
>  	for (;;) {
>  		int option_index = 0;
>  		static struct option long_options[] = {
> -			{"date", no_argument, NULL, 0},
> +			{"date", no_argument, NULL, OPT_date},
>  			{"help", no_argument, NULL, '?'},
>  			{NULL, 0, NULL, 0}
>  		};
> @@ -2002,14 +2006,8 @@ void trace_record (int argc, char **argv)
>  		case 'i':
>  			ignore_event_not_found = 1;
>  			break;
> -		case 0:
> -			switch (option_index) {
> -			case 0: /* date */
> -				date = 1;
> -				break;
> -			default:
> -				usage(argv);
> -			}
> +		case OPT_date:
> +			date = 1;
>  			break;
>  		default:
>  			usage(argv);
> diff --git a/trace-stack.c b/trace-stack.c
> index 3d9f392..52c30de 100644
> --- a/trace-stack.c
> +++ b/trace-stack.c
> @@ -153,6 +153,12 @@ static void read_trace(void)
>  	fclose(fp);
>  }
>  
> +enum {
> +	OPT_start	= 128,
> +	OPT_stop,
> +	OPT_reset,
> +};
> +
>  void trace_stack (int argc, char **argv)
>  {
>  	enum stack_type trace_type = STACK_REPORT;
> @@ -167,9 +173,9 @@ void trace_stack (int argc, char **argv)
>  	for (;;) {
>  		int option_index = 0;
>  		static struct option long_options[] = {
> -			{"start", no_argument, NULL, 0},
> -			{"stop", no_argument, NULL, 0},
> -			{"reset", no_argument, NULL, 0},
> +			{"start", no_argument, NULL, OPT_start},
> +			{"stop", no_argument, NULL, OPT_stop},
> +			{"reset", no_argument, NULL, OPT_reset},
>  			{"help", no_argument, NULL, '?'},
>  			{NULL, 0, NULL, 0}
>  		};
> @@ -183,20 +189,14 @@ void trace_stack (int argc, char **argv)
>  		case 'h':
>  			usage(argv);
>  			break;
> -		case 0:
> -			switch(option_index) {
> -			case 0:
> -				trace_type = STACK_START;
> -				break;
> -			case 1:
> -				trace_type = STACK_STOP;
> -				break;
> -			case 2:
> -				trace_type = STACK_RESET;
> -				break;
> -			default:
> -				usage(argv);
> -			}
> +		case OPT_start:
> +			trace_type = STACK_START;
> +			break;
> +		case OPT_stop:
> +			trace_type = STACK_STOP;
> +			break;
> +		case OPT_reset:
> +			trace_type = STACK_RESET;
>  			break;
>  		default:
>  			usage(argv);



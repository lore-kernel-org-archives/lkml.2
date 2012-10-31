Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab2JaG6C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 02:58:02 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:48943 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646Ab2JaG57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 02:57:59 -0400
X-AuditID: 9c930179-b7c8bae000003559-3a-5090cbf5e6e6
From: Namhyung Kim <namhyung@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, acme@redhat.com, jolsa@redhat.com,
        ming.m.lin@intel.com
Subject: Re: [Patch v1 10/10] perf tools: add new mem command for memory access profiling
References: <1351523752-4215-1-git-send-email-eranian@google.com>
	<1351523752-4215-11-git-send-email-eranian@google.com>
Date: Wed, 31 Oct 2012 15:57:57 +0900
In-Reply-To: <1351523752-4215-11-git-send-email-eranian@google.com> (Stephane
	Eranian's message of "Mon, 29 Oct 2012 16:15:52 +0100")
Message-ID: <87a9v35dsa.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2012 16:15:52 +0100, Stephane Eranian wrote:
> This new command is a wrapper on top of perf record and
> perf report to make it easier to configure for memory
> access profiling.

So this new command will be run only on speicific (PEBS > 2?) Intel
machines, right?  Is there anything we can do for others?  Or at least
it might emit a warning message..

>
> To record loads:
> $ perf mem -t load rec .....
>
> To record stores:
> $ perf mem -t store rec .....
>
> To get the report:
> $ perf mem -t load rep
>
> Signed-off-by: Stephane Eranian <eranian@google.com>
> ---
[snip]
> +perf-mem(1)
> +===========
> +
> +NAME
> +----
> +perf-mem - Profile memory accesses
> +
> +SYNOPSIS
> +--------
> +[verse]
> +'perf mem' -t load record <command>
> +'perf mem' -t store record <command>
> +'perf mem' -t load report
> +'perf mem' -t store report

Is '-t' option mandatory?  AFAISC it seems optional and defaults to load.

And is <command> for record also mandatory?  Doesn't 'perf record' make
it optional?

If so, the above can be written like you did in 'mem_usage':

'perf mem' [<options>] (record [<command>] | report)


> +
> +DESCRIPTION
> +-----------
> +"perf mem -t <TYPE> record" runs a command and gathers memory operation data
> +from it, into perf.data. Perf record options are accepted and are passed through.
> +
> +"perf mem -t <TYPE> report" displays the result. It invokes perf report with the
> +right set of options to display a memory access profile.
> +
> +OPTIONS
> +-------
> +<command>...::
> +	Any command you can specify in a shell.
> +
> +-t::
> +--type=::
> +	Select the memory operation type: load or store

It'd better saying it defaults to load.

> +
> +-R::
> +--dump-raw-samples=::
> +	Dump the raw decoded samples on the screen in a format that is easy to parse with
> +	one sample per line.

Didn't we usually use -D switch for this?

> +
> +-x::
> +--field-separator::
> +	Specify the field separator used when dump raw samples (-R option). By default,
> +	The separator is the space character.

And using -t for this will make it consistent with perf report IMHO.

> +
> +-C::
> +--cpu-list::
> +	Restrict dump of raw samples to those provided via this option. Note that the same
> +	option can be passed in record mode. It will be interpreted the same way as perf
> +	record.
> +
> +SEE ALSO
> +--------
> +linkperf:perf-record[1], linkperf:perf-report[1]
[snip]
> +#define MEM_OPERATION_LOAD	"load"
> +#define MEM_OPERATION_STORE	"store"
> +
> +static char const	*input_name		= "perf.data";

We have a global 'input_name' as of commit 70cb4e963f77 ("perf tools:
Add a global variable 'const char *input_name'").


> +static const char	*mem_operation		= MEM_OPERATION_LOAD;
> +static const char	*csv_sep		= NULL;

Why not use symbol_conf.field_sep?

> +
> +struct perf_mem {
> +	struct perf_tool	tool;
> +	char const		*input_name;
> +	symbol_filter_t		annotate_init;
> +	bool			hide_unresolved;
> +	bool			dump_raw;
> +	const char		*cpu_list;
> +	DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
> +};
> +
> +static const char * const mem_usage[] = {
> +	"perf mem [<options>] {record <command> |report}",
> +	NULL
> +};
[snip]
> +static int report_raw_events(struct perf_mem *mem)
> +{
> +	int err = -EINVAL;
> +	int ret;
> +	struct perf_session *session = perf_session__new(input_name, O_RDONLY,
> +							 0, false, &mem->tool);
> +
> +	if (mem->cpu_list) {
> +		ret = perf_session__cpu_bitmap(session, mem->cpu_list,
> +					       mem->cpu_bitmap);
> +		if (ret)
> +			goto out_delete;
> +	}
> +
> +	if (symbol__init() < 0)
> +		return -1;
> +
> +	if (session == NULL)
> +		return -ENOMEM;

This check should be moved before perf_session__cpu_bitmap() calls.

Thanks,
Namhyung

> +
> +	printf("# PID, TID, IP, ADDR, COST, DSRC, SYMBOL\n");
> +
> +	err = perf_session__process_events(session, &mem->tool);
> +	if (err)
> +		return err;
> +
> +	return 0;
> +
> +out_delete:
> +	perf_session__delete(session);
> +	return err;
> +}

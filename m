Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756398Ab0K3Tgy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 14:36:54 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:49273 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755614Ab0K3Tgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 14:36:51 -0500
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAKPh9ExAaMHG/2dsb2JhbACjF3GoaZtOhUcEhFyGBoMP
X-IronPort-AV: E=Sophos;i="4.59,281,1288569600"; 
   d="scan'208";a="628375139"
Message-ID: <4CF5524C.5090900@cisco.com>
Date: Tue, 30 Nov 2010 12:36:44 -0700
From: "David S. Ahern" <daahern@cisco.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/2] perf tools: Add option to show time history of event
 samples
References: <1291072029-19178-1-git-send-email-daahern@cisco.com> <1291072029-19178-3-git-send-email-daahern@cisco.com> <20101130191905.GB9706@ghostprotocols.net>
In-Reply-To: <20101130191905.GB9706@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/30/10 12:19, Arnaldo Carvalho de Melo wrote:
> 
> Suggestion: Please put some example output on the commit log message,
> that way reviewers can have a glimpse of how it looks like.
> 

Will do. I actually had a comparison between today's 'report -D' and
'report --timehist'; I forgot to add it to the commit message.

The line lengths will be a bit ugly in an email. In practice, the
timehist is primarily a means of converting event data to sensible text
for 1. processing by scripts and gnuplot, and 2. correlating with log
entries from individual processes.

In case folks are interested now before generating another patch set:

./perf record --timehist -e cs -c 1 -p 983 -g

./perf report -D

0x1200 [0x88]: PERF_RECORD_SAMPLE(IP, 1): 983/983: 0xffffffff813e974f
period: 1 cpu:1
... chain: nr:11
.....  0: ffffffffffffff80
.....  1: ffffffff813e974f
.....  2: ffffffff813ea46d
.....  3: ffffffff813ea549
.....  4: ffffffff8111cf61
.....  5: ffffffff8111d7eb
.....  6: ffffffff8111d9a3
.....  7: ffffffff8111dad8
.....  8: ffffffff81002cf2
.....  9: fffffffffffffe00
..... 10: 00007f2e0d15dec3
 ... thread: sshd:983
 ...... dso: /lib/modules/2.6.37-rc2/build/vmlinux


./perf report --timehist -U

12:26:41.890762  105188460714 1  sshd  983  ffffffff813e974f  schedule
([kernel.kallsyms])
12:26:41.890762  105188460714 1  sshd  983  ffffffff813ea46d
schedule_hrtimeout_range_clock ([kernel.kallsyms])
12:26:41.890762  105188460714 1  sshd  983  ffffffff813ea549
schedule_hrtimeout_range ([kernel.kallsyms])
12:26:41.890762  105188460714 1  sshd  983  ffffffff8111cf61
poll_schedule_timeout ([kernel.kallsyms])
12:26:41.890762  105188460714 1  sshd  983  ffffffff8111d7eb  do_select
([kernel.kallsyms])
12:26:41.890762  105188460714 1  sshd  983  ffffffff8111d9a3
core_sys_select ([kernel.kallsyms])
12:26:41.890762  105188460714 1  sshd  983  ffffffff8111dad8  sys_select
([kernel.kallsyms])
12:26:41.890762  105188460714 1  sshd  983  ffffffff81002cf2
system_call ([kernel.kallsyms])
12:26:41.890762  105188460714 1  sshd  983      7f2e0d15dec3
__GI_select (/lib64/libc-2.12.90.so)



>> +static int perf_session__print_sample(struct perf_session *self,
> 
> Please replace self with 'session', Thomas suggested that and I agreed
> that its better. We'll slowly rename all those self variables.

Ok. I noted the mix and wasn't sure which name to use.

> 
>> +					struct addr_location *al,
>> +					struct sample_data *data)
>> +{
>> +	static int show_timehist_error = 1;
>> +	u64 timestamp = 0;
>> +	struct map_symbol *syms = NULL;
>> +	struct symbol *parent = NULL;
>> +	const char *tstr;
>> +
>> +	if (show_timehist_error &&
>> +		((data->cpu == (u32) -1) || !(self->sample_type & PERF_SAMPLE_TIME))) {
>> +		pr_err("Data for time history missing in perf event samples.\n"
>> +		       "Did you record with -T option?\n");
> 
> --timehist
> 
> As you used:
> 
> +	OPT_BOOLEAN(0, "timehist", &time_history,
> +		    "Dump time history of event samples"),
> 
> In a branch I'm working on I'm using 'T' to mean "--sample_time", i.e.
> to ask for just PERF_SAMPLE_TIME

Ok. I wanted consistency between record and report and moved from -T to
--timehist. Forgot to update the help message above.

David

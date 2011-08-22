Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357Ab1HVNDf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 09:03:35 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:49542 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636Ab1HVNDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 09:03:33 -0400
Message-ID: <4E5253A3.20306@gmail.com>
Date: Mon, 22 Aug 2011 07:03:31 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
CC: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH -tip v3 5/5] perf script: add option resolving vmlinux
 path
References: <20110811120555.5900.23642.stgit@linux3> <20110811120638.5900.72007.stgit@linux3>
In-Reply-To: <20110811120638.5900.72007.stgit@linux3>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2011 06:06 AM, Akihiro Nagai wrote:
> Add the option get the path of [kernel.kallsyms].
> Specify '--show-kernel-path' option to use this function.
> This patch enables other applications to use this output easily.
> 
> Without --show-kernel-path  option
> 
> # perf script -f ip,dso
> ffffffff81467612 irq_return ([kernel.kallsyms])
> ffffffff81467612 irq_return ([kernel.kallsyms])
>     7f24fc02a6b3 _start (/lib64/ld-2.14.so)
> [snip]
> 
> With --show-kernel-path option
> 
> # perf script -f ip,dso --show-kernel-path
> ffffffff81467612 irq_return (/lib/modules/3.0.0+/build/vmlinux)
> ffffffff81467612 irq_return (/lib/modules/3.0.0+/build/vmlinux)
>     7f24fc02a6b3 _start (/lib64/ld-2.14.so)
> [snip]
> 
> Signed-off-by: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> ---
> 
>  tools/perf/Documentation/perf-script.txt |    3 +++
>  tools/perf/builtin-script.c              |    2 ++
>  tools/perf/util/map.c                    |    9 ++++++---
>  tools/perf/util/symbol.h                 |    1 +
>  4 files changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/perf/Documentation/perf-script.txt b/tools/perf/Documentation/perf-script.txt
> index ee4d477..5383671 100644
> --- a/tools/perf/Documentation/perf-script.txt
> +++ b/tools/perf/Documentation/perf-script.txt
> @@ -188,6 +188,9 @@ OPTIONS
>  	CPUs are specified with -: 0-2. Default is to report samples on all
>  	CPUs.
>  
> +--show-kernel-path::
> +	Try to resolve the path of [kernel.kallsyms]
> +
>  SEE ALSO
>  --------
>  linkperf:perf-record[1], linkperf:perf-script-perl[1],
> diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
> index 78797b3..ba5d3bb 100644
> --- a/tools/perf/builtin-script.c
> +++ b/tools/perf/builtin-script.c
> @@ -1095,6 +1095,8 @@ static const struct option options[] = {
>  		     "addr,offs",
>  		     parse_output_fields),
>  	OPT_STRING('c', "cpu", &cpu_list, "cpu", "list of cpus to profile"),
> +	OPT_BOOLEAN('\0', "show-kernel-path", &symbol_conf.show_kernel_path,
> +		    "Show the path of [kernel.kallsyms]"),
>  
>  	OPT_END()
>  };
> diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
> index 530a5ea..6ba4909 100644
> --- a/tools/perf/util/map.c
> +++ b/tools/perf/util/map.c
> @@ -204,9 +204,12 @@ void map__print_dsoname(struct map *self)
>  {
>  	const char *dsoname;
>  
> -	if (self && self->dso && self->dso->name)
> -		dsoname = self->dso->name;
> -	else
> +	if (self && self->dso && (self->dso->name || self->dso->long_name)) {
> +		if (symbol_conf.show_kernel_path && self->dso->long_name)
> +			dsoname = self->dso->long_name;
> +		else if (self->dso->name)
> +			dsoname = self->dso->name;
> +	} else
>  		dsoname = "[unknown]";
>  
>  	printf("%s", dsoname);
> diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
> index 554b2fe..3a63c92 100644
> --- a/tools/perf/util/symbol.h
> +++ b/tools/perf/util/symbol.h
> @@ -69,6 +69,7 @@ struct strlist;
>  struct symbol_conf {
>  	unsigned short	priv_size;
>  	bool		try_vmlinux_path,
> +			show_kernel_path,
>  			use_modules,
>  			sort_by_name,
>  			show_nr_samples,
> 

Acked-By: David Ahern <dsahern@gmail.com>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480Ab0LFDUi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 22:20:38 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:53221 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732Ab0LFDUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 22:20:37 -0500
X-AuditID: b753bd60-a6112ba00000392d-7a-4cfc568279d0
Message-ID: <4CFC567D.90707@hitachi.com>
Date: Mon, 06 Dec 2010 12:20:29 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH -tip  6/7] perf bts trace: print function+offset
References: <20101203035832.7827.16528.stgit@localhost6.localdomain6> <20101203040015.7827.38870.stgit@localhost6.localdomain6>
In-Reply-To: <20101203040015.7827.38870.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/12/03 13:00), Akihiro Nagai wrote:
> Provide the function to print function+offset.
> And, set it as the default behavior of 'perf bts trace'.
> To use this function, users can also specify the option '-s' or '--symbol'.
> 
> Example: 'perf bts -as trace'
> This command prints address and function+offset.
> 
> Output sample:
> address            function+offset
> 0xffffffff8146fe0e irq_return+0x0         => 0x00007fd4038e3b20 _start+0x0
> ...
> 0x000000380661ee79 __libc_start_main+0xf9 => 0x00000000004035c3 main+0x0
> 0xffffffff8146ef4e irq_return+0x0         => 0x00000000004035c3 main+0x0
> 0x00000000004035e8 main+0x25              => 0x000000000040bca0 set_program_name+0x0
> 0xffffffff8146ef4e irq_return+0x0         => 0x000000000040bca0 set_program_name+0x0
> 0x000000000040bcae set_program_name+0xe   => 0x00000000004023d0 strrchr@plt+0x0
> 0x00000000004023d0 strrchr@plt+0x0        => 0x00000000004023d6 strrchr@plt+0x6
> ...
> 0x0000000000403e0c main+0x849             => 0x00000000004021f0 exit@plt+0x0
> 0x00000000004021f0 exit@plt+0x0           => 0x00000000004021f6 exit@plt+0x6
> 0x00000000004021fb exit@plt+0xb           => 0x00000000004020d0 _init+0x18
> 0x00000000004020d6 _init+0x1e             => 0x00000038062149d0 _dl_runtime_resolve+0x0
> ...
> 
> Signed-off-by: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>

You might think the next step is displaying line number of the address.
Feel free to use/update probe-finder.c :)

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Cc: linux-kernel@vger.kernel.org
> ---
> 
>  tools/perf/Documentation/perf-bts.txt |    5 +++-
>  tools/perf/builtin-bts.c              |   44 ++++++++++++++++++++++++++++++---
>  2 files changed, 44 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/perf/Documentation/perf-bts.txt b/tools/perf/Documentation/perf-bts.txt
> index acabffc..13ee862 100644
> --- a/tools/perf/Documentation/perf-bts.txt
> +++ b/tools/perf/Documentation/perf-bts.txt
> @@ -31,7 +31,7 @@ OPTIONS
>          Specify input file name to analyze.
>  -a::
>  --addr::
> -	Print address. (default)
> +	Print address.
>  -c::
>  --comm::
>  	Print command name.
> @@ -41,6 +41,9 @@ OPTIONS
>  -e::
>  --elfpath::
>  	Print file path of executed elf.
> +-s::
> +--symbol::
> +	Print function name and offset. (default)
>  
>  SEE ALSO
>  --------
> diff --git a/tools/perf/builtin-bts.c b/tools/perf/builtin-bts.c
> index 3b2a21e..71c7fbe 100644
> --- a/tools/perf/builtin-bts.c
> +++ b/tools/perf/builtin-bts.c
> @@ -21,6 +21,8 @@ struct exec_info {
>  	pid_t		pid;		/* tracee process pid */
>  	const char	*comm;		/* command name */
>  	const char	*elfpath;	/* file path to elf */
> +	const char	*function;	/* function name */
> +	u64		offset;		/* offset from top of the function */
>  };
>  
>  #define EI_PID_UNSET	-1
> @@ -30,9 +32,10 @@ struct exec_info {
>  #define EI_FLAG_PRINT_PID		(1 << 1)
>  #define EI_FLAG_PRINT_COMM		(1 << 2)
>  #define EI_FLAG_PRINT_ELFPATH		(1 << 3)
> +#define EI_FLAG_PRINT_SYMBOL		(1 << 4)
>  
>  /* it's used when no print item specified */
> -#define EI_FLAG_PRINT_DEFAULT		EI_FLAG_PRINT_ADDR
> +#define EI_FLAG_PRINT_DEFAULT		EI_FLAG_PRINT_SYMBOL
>  
>  /* print item flags */
>  static unsigned long print_flags;
> @@ -43,6 +46,9 @@ static unsigned long print_flags;
>  #define EI_UNKNOWN_TEXT			"(unknown)"
>  #define EI_UNKNOWN_TEXT_LEN		(sizeof(EI_UNKNOWN_TEXT))
>  
> +/* 'function+offset' lengh = function + '+' + %#18llx + '\0' */
> +#define symbol_buf_size(func_name)	(strlen(func_name) + 1 + 18 + 1)
> +
>  /* default input file name to analyze */
>  static const char *input_name = "perf.data";
>  
> @@ -71,7 +77,7 @@ static int set_print_flags(const struct option *opt, const char *str __unused,
>  static const struct option bts_options[] = {
>  	OPT_STRING('i', "input", &input_name, "file", "input file name"),
>  	OPT_CALLBACK_DEFAULT_NOOPT('a', "addr", NULL, NULL,
> -				   "print address (default)", set_print_flags,
> +				   "print address", set_print_flags,
>  				   (void *)EI_FLAG_PRINT_ADDR),
>  	OPT_CALLBACK_DEFAULT_NOOPT('p', "pid", NULL, NULL,
>  				   "print pid", set_print_flags,
> @@ -82,6 +88,10 @@ static const struct option bts_options[] = {
>  	OPT_CALLBACK_DEFAULT_NOOPT('e', "elfpath", NULL, NULL,
>  				   "print file path to elf", set_print_flags,
>  				   (void *)EI_FLAG_PRINT_ELFPATH),
> +	OPT_CALLBACK_DEFAULT_NOOPT('s', "symbol", NULL, NULL,
> +				   "print function+offset (default)",
> +				   set_print_flags,
> +				   (void *)EI_FLAG_PRINT_SYMBOL),
>  	OPT_END()
>  };
>  
> @@ -106,7 +116,7 @@ static void fill_exec_info(struct exec_info *ei, struct perf_session *session,
>  		return;
>  	ei->comm = thread->comm;
>  
> -	/* get file path to elf */
> +	/* get file path to elf, and symbol information */
>  	memset(&al, 0, sizeof(al));
>  	thread__find_addr_map(thread, session, PERF_RECORD_MISC_USER,
>  			      MAP__FUNCTION, event->ip.pid, addr, &al);
> @@ -115,8 +125,14 @@ static void fill_exec_info(struct exec_info *ei, struct perf_session *session,
>  				      MAP__FUNCTION, event->ip.pid, addr, &al);
>  	if (!al.map)
>  		return;
> -	map__load(al.map, NULL);
> +
> +	al.addr = al.map->map_ip(al.map, addr);
> +	al.sym = map__find_symbol(al.map, al.addr, NULL);
> +	if (!al.sym)
> +		return;
>  	ei->elfpath = al.map->dso->long_name;
> +	ei->function = al.sym->name;
> +	ei->offset = al.addr - al.sym->start;
>  }
>  
>  static void __print_exec_info(struct exec_info *ei)
> @@ -124,6 +140,8 @@ static void __print_exec_info(struct exec_info *ei)
>  	char pid[16];
>  	const char *comm;
>  	const char *elfpath;
> +	char *symbol;
> +	int symbol_len;
>  
>  	if (print_flags & EI_FLAG_PRINT_PID) {
>  		if (ei->pid == EI_PID_UNSET)
> @@ -138,6 +156,22 @@ static void __print_exec_info(struct exec_info *ei)
>  	}
>  	if (print_flags & EI_FLAG_PRINT_ADDR)
>  		printf(FMT_ADDR " ", ei->addr);
> +	if (print_flags & EI_FLAG_PRINT_SYMBOL) {
> +		if (!ei->function) {
> +			/* when function is unknown, offset must be unknown */
> +			printf("%-32s ", EI_UNKNOWN_TEXT);
> +			goto print_elfpath;
> +		}
> +
> +		symbol_len = symbol_buf_size(ei->function);
> +		symbol = malloc(symbol_len);
> +		snprintf(symbol, symbol_len, "%s+0x%llx",
> +			 ei->function, ei->offset);
> +		printf("%-32s ", symbol);
> +		free(symbol);
> +	}
> +
> +print_elfpath:
>  	if (print_flags & EI_FLAG_PRINT_ELFPATH) {
>  		elfpath = ei->elfpath ? : EI_UNKNOWN_TEXT;
>  		printf("%-32s ", elfpath);
> @@ -160,6 +194,8 @@ static void print_exec_info_header(void)
>  		printf("%-12s ", "command");
>  	if (print_flags & EI_FLAG_PRINT_ADDR)
>  		printf("%-" FMT_ADDR_WIDTH "s ", "address");
> +	if (print_flags & EI_FLAG_PRINT_SYMBOL)
> +		printf("%-32s ", "function+offset");
>  	if (print_flags & EI_FLAG_PRINT_ELFPATH)
>  		printf("%-32s ", "elf_filepath");
>  	printf("\n");
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

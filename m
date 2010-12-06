Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab0LFDRQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 22:17:16 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:52787 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732Ab0LFDRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 22:17:15 -0500
X-AuditID: b753bd60-a62feba000000f8d-83-4cfc55b8ad1b
Message-ID: <4CFC55AE.2010909@hitachi.com>
Date: Mon, 06 Dec 2010 12:17:02 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH -tip 5/7] perf bts trace: print file path of the executed
 elf
References: <20101203035832.7827.16528.stgit@localhost6.localdomain6> <20101203035926.7827.59335.stgit@localhost6.localdomain6>
In-Reply-To: <20101203035926.7827.59335.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/12/03 12:59), Akihiro Nagai wrote:
> Provide the function to print file path to the executed elf.
> Users can enable it with option '-e' or '--elfpath'.
> For example,
>     'perf bts -ae trace'
> This command prints address and file path of elf.
> And, output is:
> 
> address            elf_filepath
> 0xffffffff8146fe0e /lib/modules/2.6.37-rc2-tip+/build/vmlinux => 0x00007fd4038e3b20 /lib64/ld-2.12.90.so
> 0xffffffff8146fe0e /lib/modules/2.6.37-rc2-tip+/build/vmlinux => 0x00007fd4038e3b20 /lib64/ld-2.12.90.so
> 0x00007fd4038e3b23 /lib64/ld-2.12.90.so             => 0x00007fd4038e7910 /lib64/ld-2.12.90.so
> 0xffffffff8146fe0e /lib/modules/2.6.37-rc2-tip+/build/vmlinux => 0x00007fd4038e7910 /lib64/ld-2.12.90.so
> 0xffffffff8146fe0e /lib/modules/2.6.37-rc2-tip+/build/vmlinux => 0x00007fd4038e7936 /lib64/ld-2.12.90.so
> 0xffffffff8146fe0e /lib/modules/2.6.37-rc2-tip+/build/vmlinux => 0x00007fd4038e793d /lib64/ld-2.12.90.so
> 0x00007fd4038e7981 /lib64/ld-2.12.90.so             => 0x00007fd4038e79a3 /lib64/ld-2.12.90.so
> 0x00007fd4038e79a7 /lib64/ld-2.12.90.so             => 0x00007fd4038e7988 /lib64/ld-2.12.90.so
> ...
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
>  tools/perf/Documentation/perf-bts.txt |    3 +++
>  tools/perf/builtin-bts.c              |   31 +++++++++++++++++++++++++++++++
>  2 files changed, 34 insertions(+), 0 deletions(-)
> 
> diff --git a/tools/perf/Documentation/perf-bts.txt b/tools/perf/Documentation/perf-bts.txt
> index 56ddaa4..acabffc 100644
> --- a/tools/perf/Documentation/perf-bts.txt
> +++ b/tools/perf/Documentation/perf-bts.txt
> @@ -38,6 +38,9 @@ OPTIONS
>  -p::
>  --pid::
>  	Print pid.
> +-e::
> +--elfpath::
> +	Print file path of executed elf.
>  
>  SEE ALSO
>  --------
> diff --git a/tools/perf/builtin-bts.c b/tools/perf/builtin-bts.c
> index 11e491b..3b2a21e 100644
> --- a/tools/perf/builtin-bts.c
> +++ b/tools/perf/builtin-bts.c
> @@ -20,6 +20,7 @@ struct exec_info {
>  	u64		addr;		/* recorded address by bts */
>  	pid_t		pid;		/* tracee process pid */
>  	const char	*comm;		/* command name */
> +	const char	*elfpath;	/* file path to elf */
>  };
>  
>  #define EI_PID_UNSET	-1
> @@ -28,6 +29,7 @@ struct exec_info {
>  #define EI_FLAG_PRINT_ADDR		(1 << 0)
>  #define EI_FLAG_PRINT_PID		(1 << 1)
>  #define EI_FLAG_PRINT_COMM		(1 << 2)
> +#define EI_FLAG_PRINT_ELFPATH		(1 << 3)
>  
>  /* it's used when no print item specified */
>  #define EI_FLAG_PRINT_DEFAULT		EI_FLAG_PRINT_ADDR
> @@ -77,6 +79,9 @@ static const struct option bts_options[] = {
>  	OPT_CALLBACK_DEFAULT_NOOPT('c', "comm", NULL, NULL,
>  				   "print command name", set_print_flags,
>  				   (void *)EI_FLAG_PRINT_COMM),
> +	OPT_CALLBACK_DEFAULT_NOOPT('e', "elfpath", NULL, NULL,
> +				   "print file path to elf", set_print_flags,
> +				   (void *)EI_FLAG_PRINT_ELFPATH),
>  	OPT_END()
>  };
>  
> @@ -91,6 +96,7 @@ static void fill_exec_info(struct exec_info *ei, struct perf_session *session,
>  						event_t *event, u64 addr)
>  {
>  	struct thread *thread;
> +	struct addr_location al;
>  
>  	ei->addr = addr;
>  	ei->pid = event->ip.pid;
> @@ -99,12 +105,25 @@ static void fill_exec_info(struct exec_info *ei, struct perf_session *session,
>  	if (!thread)
>  		return;
>  	ei->comm = thread->comm;
> +
> +	/* get file path to elf */
> +	memset(&al, 0, sizeof(al));
> +	thread__find_addr_map(thread, session, PERF_RECORD_MISC_USER,
> +			      MAP__FUNCTION, event->ip.pid, addr, &al);
> +	if (!al.map)
> +		thread__find_addr_map(thread, session, PERF_RECORD_MISC_KERNEL,
> +				      MAP__FUNCTION, event->ip.pid, addr, &al);
> +	if (!al.map)
> +		return;
> +	map__load(al.map, NULL);
> +	ei->elfpath = al.map->dso->long_name;
>  }
>  
>  static void __print_exec_info(struct exec_info *ei)
>  {
>  	char pid[16];
>  	const char *comm;
> +	const char *elfpath;
>  
>  	if (print_flags & EI_FLAG_PRINT_PID) {
>  		if (ei->pid == EI_PID_UNSET)
> @@ -119,6 +138,10 @@ static void __print_exec_info(struct exec_info *ei)
>  	}
>  	if (print_flags & EI_FLAG_PRINT_ADDR)
>  		printf(FMT_ADDR " ", ei->addr);
> +	if (print_flags & EI_FLAG_PRINT_ELFPATH) {
> +		elfpath = ei->elfpath ? : EI_UNKNOWN_TEXT;
> +		printf("%-32s ", elfpath);
> +	}
>  }
>  
>  static void print_exec_info(struct exec_info *ei_from, struct exec_info *ei_to)
> @@ -137,6 +160,8 @@ static void print_exec_info_header(void)
>  		printf("%-12s ", "command");
>  	if (print_flags & EI_FLAG_PRINT_ADDR)
>  		printf("%-" FMT_ADDR_WIDTH "s ", "address");
> +	if (print_flags & EI_FLAG_PRINT_ELFPATH)
> +		printf("%-32s ", "elf_filepath");
>  	printf("\n");
>  }
>  
> @@ -163,6 +188,7 @@ static int process_sample_event(event_t *event, struct perf_session *session)
>  static struct perf_event_ops event_ops = {
>  	.sample			= process_sample_event,
>  	.comm			= event__process_comm,
> +	.mmap			= event__process_mmap,
>  	.ordered_samples	= false,
>  };
>  
> @@ -180,6 +206,11 @@ static int __cmd_trace(void)
>  	if (is_flags_unset(print_flags))
>  		print_flags = EI_FLAG_PRINT_DEFAULT;
>  
> +	/* setup kernel maps to resolve vmlinux file path */
> +	perf_session__create_kernel_maps(session);
> +	if (symbol__init() < 0)
> +		fprintf(stderr, "failed to initialize symbol.\n");
> +
>  	setup_pager();
>  	print_exec_info_header();
>  	perf_session__process_events(session, &event_ops);
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

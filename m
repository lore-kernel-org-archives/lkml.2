Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588Ab2DOU7R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 16:59:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55339 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397Ab2DOU7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 16:59:16 -0400
Message-ID: <4F8B36A1.1090706@gmail.com>
Date: Sun, 15 Apr 2012 14:59:13 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: acme@ghostprotocols.net
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
        eranian@google.com, namhyung.kim@lge.com
Subject: Re: [PATCH] perf report: fix crash showing warning related to kernel
 maps
References: <1334074526-67905-1-git-send-email-dsahern@gmail.com>
In-Reply-To: <1334074526-67905-1-git-send-email-dsahern@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo:

Haven't seen this one come through your urgent queue.

On 4/10/12 10:15 AM, David Ahern wrote:
> While testing https://lkml.org/lkml/2012/4/10/123 I hit this crash:
>
> (gdb) bt
>   0  0x000000000042000f in __cmd_report (rep=0x7fff80cec580) at builtin-report.c:380
>   1  cmd_report (argc=0, argv=<optimized out>, prefix=<optimized out>) at builtin-report.c:759
>   2  0x0000000000414513 in run_builtin (p=0x7724a8, argc=3, argv=0x7fff80ceca70) at perf.c:273
>   3  0x0000000000413d41 in handle_internal_command (argv=0x7fff80ceca70, argc=3) at perf.c:345
>   4  run_argv (argv=0x7fff80cec880, argcp=0x7fff80cec88c) at perf.c:389
>   5  main (argc=3, argv=0x7fff80ceca70) at perf.c:487
>
> kernel_map can be NULL, so need to handle it while dumping a warning
> to user.
>
> Signed-off-by: David Ahern<dsahern@gmail.com>
> ---
>   tools/perf/builtin-report.c |   17 ++++++++++++-----
>   1 files changed, 12 insertions(+), 5 deletions(-)
>
> diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
> index 2e31743..002c644 100644
> --- a/tools/perf/builtin-report.c
> +++ b/tools/perf/builtin-report.c
> @@ -374,16 +374,23 @@ static int __cmd_report(struct perf_report *rep)
>   	    (kernel_map->dso->hit&&
>   	(kernel_kmap->ref_reloc_sym == NULL ||
>   	      kernel_kmap->ref_reloc_sym->addr == 0))) {
> -		const struct dso *kdso = kernel_map->dso;
> +		const char *desc =
> +		    "As no suitable kallsyms nor vmlinux was found, kernel samples\n"
> +		    "can't be resolved.";
> +
> +		if (kernel_map) {
> +			const struct dso *kdso = kernel_map->dso;
> +			if (RB_EMPTY_ROOT(&kdso->symbols[MAP__FUNCTION])) {
> +				desc = "If some relocation was applied (e.g. "
> +				       "kexec) symbols may be misresolved.";
> +			}
> +		}
>
>   		ui__warning(
>   "Kernel address maps (/proc/{kallsyms,modules}) were restricted.\n\n"
>   "Check /proc/sys/kernel/kptr_restrict before running 'perf record'.\n\n%s\n\n"
>   "Samples in kernel modules can't be resolved as well.\n\n",
> -			    RB_EMPTY_ROOT(&kdso->symbols[MAP__FUNCTION]) ?
> -"As no suitable kallsyms nor vmlinux was found, kernel samples\n"
> -"can't be resolved." :
> -"If some relocation was applied (e.g. kexec) symbols may be misresolved.");
> +		desc);
>   	}
>
>   	if (dump_trace) {


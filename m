Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181Ab0LLQCA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 11:02:00 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:43565 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591Ab0LLQB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 11:01:58 -0500
X-AuditID: b753bd60-a73a6ba000003e7d-ee-4d04f1f2bda2
Message-ID: <4D04F1EF.2020005@hitachi.com>
Date: Mon, 13 Dec 2010 01:01:51 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Franck Bui-Huu <fbuihuu@gmail.com>, 2nddept-manager@sdl.hitachi.co.jp,
        Francis Moreau <francis.moro@gmail.com>,
        Franck Bui-Huu <vagabon.xyz@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 1/2] perf probe: Fix use of kernel image path given by
 'k' option
References: <1292167014-20936-1-git-send-email-acme@infradead.org> <1292167014-20936-2-git-send-email-acme@infradead.org>
In-Reply-To: <1292167014-20936-2-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/12/13 0:16), Arnaldo Carvalho de Melo wrote:
> From: Franck Bui-Huu <fbuihuu@gmail.com>
> 
> Users were not being able to have the explicitely specified vmlinux
> pathname used, instead a search on the vmlinux path was always being
> made.
> 
> Reported-by: Francis Moreau <francis.moro@gmail.com>
> Cc: 2nddept-manager@sdl.hitachi.co.jp
> Cc: Francis Moreau <francis.moro@gmail.com>
> Cc: Franck Bui-Huu <vagabon.xyz@gmail.com>
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> LPU-Reference: <m3hbelydz8.fsf_-_@gmail.com>
> Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

Thanks!

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>


> ---
>  tools/perf/builtin-probe.c    |    5 +++++
>  tools/perf/util/probe-event.c |   15 ++++++++++++---
>  tools/perf/util/symbol.c      |    4 ++--
>  tools/perf/util/symbol.h      |    2 ++
>  4 files changed, 21 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
> index 2e000c0..add163c 100644
> --- a/tools/perf/builtin-probe.c
> +++ b/tools/perf/builtin-probe.c
> @@ -249,6 +249,11 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
>  	     !params.show_lines))
>  		usage_with_options(probe_usage, options);
>  
> +	/*
> +	 * Only consider the user's kernel image path if given.
> +	 */
> +	symbol_conf.try_vmlinux_path = (symbol_conf.vmlinux_name == NULL);
> +
>  	if (params.list_events) {
>  		if (params.mod_events) {
>  			pr_err("  Error: Don't use --list with --add/--del.\n");
> diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
> index 3b6a529..b71acd6 100644
> --- a/tools/perf/util/probe-event.c
> +++ b/tools/perf/util/probe-event.c
> @@ -114,6 +114,8 @@ static struct symbol *__find_kernel_function_by_name(const char *name,
>  const char *kernel_get_module_path(const char *module)
>  {
>  	struct dso *dso;
> +	struct map *map;
> +	const char *vmlinux_name;
>  
>  	if (module) {
>  		list_for_each_entry(dso, &machine.kernel_dsos, node) {
> @@ -123,10 +125,17 @@ const char *kernel_get_module_path(const char *module)
>  		}
>  		pr_debug("Failed to find module %s.\n", module);
>  		return NULL;
> +	}
> +
> +	map = machine.vmlinux_maps[MAP__FUNCTION];
> +	dso = map->dso;
> +
> +	vmlinux_name = symbol_conf.vmlinux_name;
> +	if (vmlinux_name) {
> +		if (dso__load_vmlinux(dso, map, vmlinux_name, NULL) <= 0)
> +			return NULL;
>  	} else {
> -		dso = machine.vmlinux_maps[MAP__FUNCTION]->dso;
> -		if (dso__load_vmlinux_path(dso,
> -			 machine.vmlinux_maps[MAP__FUNCTION], NULL) < 0) {
> +		if (dso__load_vmlinux_path(dso, map, NULL) < 0) {
>  			pr_debug("Failed to load kernel map.\n");
>  			return NULL;
>  		}
> diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
> index d628c8d..439ab94 100644
> --- a/tools/perf/util/symbol.c
> +++ b/tools/perf/util/symbol.c
> @@ -1780,8 +1780,8 @@ out_failure:
>  	return -1;
>  }
>  
> -static int dso__load_vmlinux(struct dso *self, struct map *map,
> -			     const char *vmlinux, symbol_filter_t filter)
> +int dso__load_vmlinux(struct dso *self, struct map *map,
> +		      const char *vmlinux, symbol_filter_t filter)
>  {
>  	int err = -1, fd;
>  
> diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
> index 038f220..6c6eafd 100644
> --- a/tools/perf/util/symbol.h
> +++ b/tools/perf/util/symbol.h
> @@ -166,6 +166,8 @@ void dso__sort_by_name(struct dso *self, enum map_type type);
>  struct dso *__dsos__findnew(struct list_head *head, const char *name);
>  
>  int dso__load(struct dso *self, struct map *map, symbol_filter_t filter);
> +int dso__load_vmlinux(struct dso *self, struct map *map,
> +		      const char *vmlinux, symbol_filter_t filter);
>  int dso__load_vmlinux_path(struct dso *self, struct map *map,
>  			   symbol_filter_t filter);
>  int dso__load_kallsyms(struct dso *self, const char *filename, struct map *map,


-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027Ab1GQQHF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 12:07:05 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43457 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674Ab1GQQHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 12:07:02 -0400
Message-ID: <4E2308A9.5000706@gmail.com>
Date: Sun, 17 Jul 2011 10:07:05 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
CC: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH -tip v2 2/6] perf script: add magic word to indicate the
 failure of resolving symbols
References: <20110717093031.3447.52715.stgit@linux3> <20110717093051.3447.65080.stgit@linux3>
In-Reply-To: <20110717093051.3447.65080.stgit@linux3>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/17/2011 03:30 AM, Akihiro Nagai wrote:
> Latest perf-script doesn't output symbol name when it failed to
> resolve symbol name. This output is not friendly for external scripts
> because it causes misaligment. So, this patch adds the magic word
> "(unknown)" when perf-script failed to resolve symbols.

Code has [unknown] with {}, not ().

> 
> At the same time, this patch changes perf-script to output "[unknown]"
> in the DSO field, when it failed to resolve the path of DSOs.
> 
> Changes in v2:
>  - add this patch
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
>  tools/perf/builtin-script.c |   18 +++++-------------
>  tools/perf/util/map.c       |   12 ++++++++++++
>  tools/perf/util/map.h       |    1 +
>  tools/perf/util/session.c   |   35 ++++++++++-------------------------
>  tools/perf/util/symbol.c    |   12 ++++++++++++
>  tools/perf/util/symbol.h    |    1 +
>  6 files changed, 41 insertions(+), 38 deletions(-)
> 
> diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
> index 09024ec..b3e0951 100644
> --- a/tools/perf/builtin-script.c
> +++ b/tools/perf/builtin-script.c
> @@ -320,7 +320,6 @@ static void print_sample_addr(union perf_event *event,
>  {
>  	struct addr_location al;
>  	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
> -	const char *symname, *dsoname;
>  
>  	printf("%16" PRIx64, sample->addr);
>  
> @@ -340,21 +339,14 @@ static void print_sample_addr(union perf_event *event,
>  		al.sym = map__find_symbol(al.map, al.addr, NULL);
>  
>  	if (PRINT_FIELD(SYM)) {
> -		if (al.sym && al.sym->name)
> -			symname = al.sym->name;
> -		else
> -			symname = "";
> -
> -		printf(" %16s", symname);
> +		printf(" ");
> +		symbol__print_symname(al.sym);
>  	}
>  
>  	if (PRINT_FIELD(DSO)) {
> -		if (al.map && al.map->dso && al.map->dso->name)
> -			dsoname = al.map->dso->name;
> -		else
> -			dsoname = "";
> -
> -		printf(" (%s)", dsoname);
> +		printf(" (");
> +		map__print_dsoname(al.map);
> +		printf(")");
>  	}
>  }
>  
> diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
> index a16ecab..dddc0f3 100644
> --- a/tools/perf/util/map.c
> +++ b/tools/perf/util/map.c
> @@ -200,6 +200,18 @@ size_t map__fprintf(struct map *self, FILE *fp)
>  		       self->start, self->end, self->pgoff, self->dso->name);
>  }
>  
> +void map__print_dsoname(struct map *self)
> +{
> +	const char *dsoname;
> +
> +	if (self && self->dso && self->dso->name)
> +			dsoname = self->dso->name;

extra tab in the above line.

Otherwise looks good to me.

Acked-By: dsahern@gmail.com

> +	else
> +		dsoname = "[unknown]";
> +
> +	printf("%s", dsoname);
> +}
> +
>  /*
>   * objdump wants/reports absolute IPs for ET_EXEC, and RIPs for ET_DYN.
>   * map->dso->adjust_symbols==1 for ET_EXEC-like cases.
> diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
> index b397c03..6f452b9 100644
> --- a/tools/perf/util/map.h
> +++ b/tools/perf/util/map.h
> @@ -112,6 +112,7 @@ void map__delete(struct map *self);
>  struct map *map__clone(struct map *self);
>  int map__overlap(struct map *l, struct map *r);
>  size_t map__fprintf(struct map *self, FILE *fp);
> +void map__print_dsoname(struct map *self);
>  
>  int map__load(struct map *self, symbol_filter_t filter);
>  struct symbol *map__find_symbol(struct map *self,
> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
> index 453a010..442be3a 100644
> --- a/tools/perf/util/session.c
> +++ b/tools/perf/util/session.c
> @@ -1214,7 +1214,6 @@ void perf_session__print_ip(union perf_event *event,
>  			    int print_sym, int print_dso)
>  {
>  	struct addr_location al;
> -	const char *symname, *dsoname;
>  	struct callchain_cursor *cursor = &session->callchain_cursor;
>  	struct callchain_cursor_node *node;
>  
> @@ -1242,20 +1241,13 @@ void perf_session__print_ip(union perf_event *event,
>  
>  			printf("\t%16" PRIx64, node->ip);
>  			if (print_sym) {
> -				if (node->sym && node->sym->name)
> -					symname = node->sym->name;
> -				else
> -					symname = "";
> -
> -				printf(" %s", symname);
> +				printf(" ");
> +				symbol__print_symname(node->sym);
>  			}
>  			if (print_dso) {
> -				if (node->map && node->map->dso && node->map->dso->name)
> -					dsoname = node->map->dso->name;
> -				else
> -					dsoname = "";
> -
> -				printf(" (%s)", dsoname);
> +				printf(" (");
> +				map__print_dsoname(al.map);
> +				printf(")");
>  			}
>  			printf("\n");
>  
> @@ -1265,21 +1257,14 @@ void perf_session__print_ip(union perf_event *event,
>  	} else {
>  		printf("%16" PRIx64, sample->ip);
>  		if (print_sym) {
> -			if (al.sym && al.sym->name)
> -				symname = al.sym->name;
> -			else
> -				symname = "";
> -
> -			printf(" %s", symname);
> +			printf(" ");
> +			symbol__print_symname(al.sym);
>  		}
>  
>  		if (print_dso) {
> -			if (al.map && al.map->dso && al.map->dso->name)
> -				dsoname = al.map->dso->name;
> -			else
> -				dsoname = "";
> -
> -			printf(" (%s)", dsoname);
> +			printf(" (");
> +			map__print_dsoname(al.map);
> +			printf(")");
>  		}
>  	}
>  }
> diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
> index eec1963..85e19c4 100644
> --- a/tools/perf/util/symbol.c
> +++ b/tools/perf/util/symbol.c
> @@ -175,6 +175,18 @@ static size_t symbol__fprintf(struct symbol *sym, FILE *fp)
>  		       sym->name);
>  }
>  
> +void symbol__print_symname(const struct symbol *sym)
> +{
> +	const char *symname;
> +
> +	if (sym && sym->name)
> +		symname = sym->name;
> +	else
> +		symname = "(unknown)";
> +
> +	printf("%s", symname);
> +}
> +
>  void dso__set_long_name(struct dso *dso, char *name)
>  {
>  	if (name == NULL)
> diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
> index 325ee36..1ec17b4 100644
> --- a/tools/perf/util/symbol.h
> +++ b/tools/perf/util/symbol.h
> @@ -238,6 +238,7 @@ void machines__destroy_guest_kernel_maps(struct rb_root *machines);
>  
>  int symbol__init(void);
>  void symbol__exit(void);
> +void symbol__print_symname(const struct symbol *sym);
>  bool symbol_type__is_a(char symbol_type, enum map_type map_type);
>  
>  size_t machine__fprintf_vmlinux_path(struct machine *machine, FILE *fp);
> 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837Ab1C2JqX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 05:46:23 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:46103 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168Ab1C2JqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 05:46:21 -0400
X-AuditID: b753bd60-a314bba0000001d0-fd-4d91aa6a8a87
X-AuditID: b753bd60-a314bba0000001d0-fd-4d91aa6a8a87
Message-ID: <4D91AA68.1040704@hitachi.com>
Date: Tue, 29 Mar 2011 18:46:16 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Lin Ming <ming.m.lin@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "2nddept-manager@sdl.hitachi.co.jp" 
	<2nddept-manager@sdl.hitachi.co.jp>
Subject: Re: [RFC PATCH] perf report: add sort by file lines
References: <1301391136.14111.98.camel@minggr.sh.intel.com>
In-Reply-To: <1301391136.14111.98.camel@minggr.sh.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/03/29 18:32), Lin Ming wrote:
> Hi, all
> 
> This patch adds sort by file lines using dwarf debug info.
> 
> In order to add perf tool support for my load latency patches,
> I asked a question about data variable symbols.
> http://marc.info/?l=linux-kernel&m=129736540309559&w=2 
> 
> Peter suggested to reverse map the reported IP (PEBS + fixup)
> to a data access using dwarf info.
> So I wrote this patch to see if the direction is right.

Good work! :)
Hmm, this seems to require my series of patches which introduce
debuginfo object, which wraps strongly libdw dependent Dwarf/Dwfl
objects and allows us to export debuginfo object even if no libdw
support.
I'll post the series soon!

> 
> On Fri, Feb 11, 2011 at 3:17 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>> Another way is to reverse map the reported IP (PEBS + fixup) to a data
>> access using the dwarf info. That would also work for dynamically
>> allocated data structures.
>>
>> (clearly you'd loose variable things like which entry in an array, but
>> you should still be able to identify the structure members)
>>
> 
> $ ./perf report --stdio -k ~/vmlinux -s comm,dso,symbol,line
> 
> # Overhead      Command      Shared Object            Symbol                                           Line
> # ........  ...........  ..................  ...............  ..............................................
> 
>      0.99%          cc1  [kernel.kallsyms]   [k] check_bytes  /opt/linux-2.6/mm/slub.c:511                         
>      0.84%       fixdep  [kernel.kallsyms]   [k] check_bytes  /opt/linux-2.6/mm/slub.c:510                         
>      0.79%       fixdep  [kernel.kallsyms]   [k] check_bytes  /opt/linux-2.6/mm/slub.c:511                         
>      0.74%          cc1  [kernel.kallsyms]   [k] check_bytes  /opt/linux-2.6/mm/slub.c:513                         
>      0.71%       fixdep  [kernel.kallsyms]   [k] check_bytes  /opt/linux-2.6/mm/slub.c:513                         
>      0.71%          cc1  [kernel.kallsyms]   [k] page_fault   /opt/linux-2.6/arch/x86/kernel/entry_64.S:1336       
>      0.69%          cc1  cc1                 [.] 0x5ec3a3     0x5ec3a3                                             
>      0.67%          cc1  [kernel.kallsyms]   [k] clear_page_c /opt/linux-2.6/arch/x86/lib/clear_page_64.S:12  
> 
> 
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> ---
>  tools/perf/util/hist.c   |   71 ++++++++++++++++++++++++++++++++++++++-------
>  tools/perf/util/hist.h   |    4 ++
>  tools/perf/util/sort.c   |   44 ++++++++++++++++++++++++++--
>  tools/perf/util/sort.h   |    3 ++
>  tools/perf/util/symbol.c |    4 ++
>  tools/perf/util/symbol.h |    2 +
>  6 files changed, 114 insertions(+), 14 deletions(-)
> 
> diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
> index 627a02e..c1e95e4 100644
> --- a/tools/perf/util/hist.c
> +++ b/tools/perf/util/hist.c
> @@ -17,6 +17,38 @@ struct callchain_param	callchain_param = {
>  	.min_percent = 0.5
>  };
>  
> +static Dwarf_Line *hists__dwarf_line(struct map *map, u64 rip)
> +{
> +	Dwarf_Die cudie;
> +	Dwarf_Line *line = NULL;
> +	u64 ip;
> +
> +	if (!map || !map->dso || !map->dso->dwarf)
> +		return NULL;
> +
> +	ip = map->unmap_ip(map, rip);
> +	if (dwarf_addrdie(map->dso->dwarf, (Dwarf_Addr)ip, &cudie))
> +		line = dwarf_getsrc_die(&cudie, (Dwarf_Addr)ip);
> +
> +	return line;
> +}
> +
> +int hists__line(Dwarf_Line *line, char *buf, int len)
> +{
> +	int ret;
> +	const char *file;
> +	int lineno;
> +
> +	if (!line || !buf)
> +		return 0;
> +
> +	file = dwarf_linesrc(line, NULL, NULL);   
> +	dwarf_lineno(line, &lineno);
> +	ret = snprintf(buf, len, "%s:%d", file, lineno);
> +
> +	return ret;
> +}
> +
>  u16 hists__col_len(struct hists *self, enum hist_column col)
>  {
>  	return self->col_len[col];
> @@ -44,21 +76,25 @@ static void hists__reset_col_len(struct hists *self)
>  		hists__set_col_len(self, col, 0);
>  }
>  
> +static void hists__set_unresolved_col_len(struct hists *self, enum hist_column col)
> +{
> +	const unsigned int unresolved_col_width = BITS_PER_LONG / 4 + 2;
> +
> +	if (hists__col_len(self, col) < unresolved_col_width &&
> +	    !symbol_conf.col_width_list_str && !symbol_conf.field_sep &&
> +	    !symbol_conf.dso_list)
> +		hists__set_col_len(self, col,
> +				   unresolved_col_width);
> +}
> +
>  static void hists__calc_col_len(struct hists *self, struct hist_entry *h)
>  {
>  	u16 len;
>  
>  	if (h->ms.sym)
> -		hists__new_col_len(self, HISTC_SYMBOL, h->ms.sym->namelen);
> -	else {
> -		const unsigned int unresolved_col_width = BITS_PER_LONG / 4;
> -
> -		if (hists__col_len(self, HISTC_DSO) < unresolved_col_width &&
> -		    !symbol_conf.col_width_list_str && !symbol_conf.field_sep &&
> -		    !symbol_conf.dso_list)
> -			hists__set_col_len(self, HISTC_DSO,
> -					   unresolved_col_width);
> -	}
> +		hists__new_col_len(self, HISTC_SYMBOL, h->ms.sym->namelen + 4);
> +	else
> +		hists__set_unresolved_col_len(self, HISTC_DSO);
>  
>  	len = thread__comm_len(h->thread);
>  	if (hists__new_col_len(self, HISTC_COMM, len))
> @@ -68,6 +104,15 @@ static void hists__calc_col_len(struct hists *self, struct hist_entry *h)
>  		len = dso__name_len(h->ms.map->dso);
>  		hists__new_col_len(self, HISTC_DSO, len);
>  	}
> +
> +	if (!h->line)
> +		hists__set_unresolved_col_len(self, HISTC_LINE);
> +	else {
> +		char tmp[BUFSIZ];
> +
> +		len = hists__line(h->line, tmp, BUFSIZ);
> +		hists__new_col_len(self, HISTC_LINE, len);
> +	}
>  }
>  
>  static void hist_entry__add_cpumode_period(struct hist_entry *self,
> @@ -103,8 +148,11 @@ static struct hist_entry *hist_entry__new(struct hist_entry *template)
>  	if (self != NULL) {
>  		*self = *template;
>  		self->nr_events = 1;
> -		if (self->ms.map)
> +		if (self->ms.map) {
>  			self->ms.map->referenced = true;
> +
> +			self->line = hists__dwarf_line(self->ms.map, self->ip); 
> +		}
>  		if (symbol_conf.use_callchain)
>  			callchain_init(self->callchain);
>  	}
> @@ -142,6 +190,7 @@ struct hist_entry *__hists__add_entry(struct hists *self,
>  		},
>  		.cpu	= al->cpu,
>  		.ip	= al->addr,
> +		.line	= hists__dwarf_line(al->map, al->addr),
>  		.level	= al->level,
>  		.period	= period,
>  		.parent = sym_parent,
> diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
> index 3beb97c..07e0f04 100644
> --- a/tools/perf/util/hist.h
> +++ b/tools/perf/util/hist.h
> @@ -3,6 +3,7 @@
>  
>  #include <linux/types.h>
>  #include "callchain.h"
> +#include <elfutils/libdw.h>
>  
>  extern struct callchain_param callchain_param;
>  
> @@ -39,6 +40,7 @@ enum hist_column {
>  	HISTC_COMM,
>  	HISTC_PARENT,
>  	HISTC_CPU,
> +	HISTC_LINE,
>  	HISTC_NR_COLS, /* Last entry */
>  };
>  
> @@ -85,6 +87,8 @@ u16 hists__col_len(struct hists *self, enum hist_column col);
>  void hists__set_col_len(struct hists *self, enum hist_column col, u16 len);
>  bool hists__new_col_len(struct hists *self, enum hist_column col, u16 len);
>  
> +int hists__line(Dwarf_Line *line, char *buf, int len);
> +
>  struct perf_evlist;
>  
>  #ifdef NO_NEWT_SUPPORT
> diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
> index f44fa54..cfbdb6c 100644
> --- a/tools/perf/util/sort.c
> +++ b/tools/perf/util/sort.c
> @@ -27,6 +27,9 @@ static int hist_entry__parent_snprintf(struct hist_entry *self, char *bf,
>  				       size_t size, unsigned int width);
>  static int hist_entry__cpu_snprintf(struct hist_entry *self, char *bf,
>  				    size_t size, unsigned int width);
> +static int hist_entry__line_snprintf(struct hist_entry *self, char *bf,
> +				    size_t size, unsigned int width);
> +
>  
>  struct sort_entry sort_thread = {
>  	.se_header	= "Command:  Pid",
> @@ -71,6 +74,13 @@ struct sort_entry sort_cpu = {
>  	.se_width_idx	= HISTC_CPU,
>  };
>  
> +struct sort_entry sort_line = {
> +	.se_header      = "Line",
> +	.se_cmp	        = sort__line_cmp,
> +	.se_snprintf    = hist_entry__line_snprintf,
> +	.se_width_idx	= HISTC_LINE,
> +};
> +
>  struct sort_dimension {
>  	const char		*name;
>  	struct sort_entry	*entry;
> @@ -84,6 +94,7 @@ static struct sort_dimension sort_dimensions[] = {
>  	{ .name = "symbol",	.entry = &sort_sym,	},
>  	{ .name = "parent",	.entry = &sort_parent,	},
>  	{ .name = "cpu",	.entry = &sort_cpu,	},
> +	{ .name = "line",	.entry = &sort_line,	},
>  };
>  
>  int64_t cmp_null(void *l, void *r)
> @@ -190,7 +201,7 @@ sort__sym_cmp(struct hist_entry *left, struct hist_entry *right)
>  }
>  
>  static int hist_entry__sym_snprintf(struct hist_entry *self, char *bf,
> -				    size_t size, unsigned int width __used)
> +				    size_t size, unsigned int width)
>  {
>  	size_t ret = 0;
>  
> @@ -202,11 +213,11 @@ static int hist_entry__sym_snprintf(struct hist_entry *self, char *bf,
>  
>  	ret += repsep_snprintf(bf + ret, size - ret, "[%c] ", self->level);
>  	if (self->ms.sym)
> -		ret += repsep_snprintf(bf + ret, size - ret, "%s",
> +		ret += repsep_snprintf(bf + ret, size - ret, "%-*s", width - 4,
>  				       self->ms.sym->name);
>  	else
>  		ret += repsep_snprintf(bf + ret, size - ret, "%-#*llx",
> -				       BITS_PER_LONG / 4, self->ip);
> +				       width - 4, self->ip);
>  
>  	return ret;
>  }
> @@ -266,6 +277,31 @@ static int hist_entry__cpu_snprintf(struct hist_entry *self, char *bf,
>  	return repsep_snprintf(bf, size, "%-*d", width, self->cpu);
>  }
>  
> +
> +/* --sort line */
> +
> +int64_t
> +sort__line_cmp(struct hist_entry *left, struct hist_entry *right)
> +{
> +	if (!left->line || !right->line)
> +		return (int64_t)(left->ip - right->ip);
> +
> +	return (unsigned long)left->line - (unsigned long)right->line;
> +}
> +
> +static int hist_entry__line_snprintf(struct hist_entry *self, char *bf,
> +				       size_t size, unsigned int width)
> +{
> +	char buf[BUFSIZ];
> +
> +	if (!self->line)
> +		return repsep_snprintf(bf, size, "%-#*llx", width, self->ip);
> +
> +	hists__line(self->line, buf, BUFSIZ);
> +
> +	return repsep_snprintf(bf, size, "%-*s", width, buf);
> +}
> +
>  int sort_dimension__add(const char *tok)
>  {
>  	unsigned int i;
> @@ -307,6 +343,8 @@ int sort_dimension__add(const char *tok)
>  				sort__first_dimension = SORT_PARENT;
>  			else if (!strcmp(sd->name, "cpu"))
>  				sort__first_dimension = SORT_CPU;
> +			else if (!strcmp(sd->name, "line"))
> +				sort__first_dimension = SORT_LINE;
>  		}
>  
>  		list_add_tail(&sd->entry->list, &hist_entry__sort_list);
> diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
> index 0b91053..d2a4424 100644
> --- a/tools/perf/util/sort.h
> +++ b/tools/perf/util/sort.h
> @@ -53,6 +53,7 @@ struct hist_entry {
>  	u64			period_guest_us;
>  	struct map_symbol	ms;
>  	struct thread		*thread;
> +	Dwarf_Line		*line;
>  	u64			ip;
>  	s32			cpu;
>  	u32			nr_events;
> @@ -80,6 +81,7 @@ enum sort_type {
>  	SORT_SYM,
>  	SORT_PARENT,
>  	SORT_CPU,
> +	SORT_LINE,
>  };
>  
>  /*
> @@ -116,6 +118,7 @@ extern int64_t sort__dso_cmp(struct hist_entry *, struct hist_entry *);
>  extern int64_t sort__sym_cmp(struct hist_entry *, struct hist_entry *);
>  extern int64_t sort__parent_cmp(struct hist_entry *, struct hist_entry *);
>  int64_t sort__cpu_cmp(struct hist_entry *left, struct hist_entry *right);
> +int64_t sort__line_cmp(struct hist_entry *left, struct hist_entry *right);
>  extern size_t sort__parent_print(FILE *, struct hist_entry *, unsigned int);
>  extern int sort_dimension__add(const char *);
>  void sort_entry__setup_elide(struct sort_entry *self, struct strlist *list,
> diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
> index 17df793..ddaf396 100644
> --- a/tools/perf/util/symbol.c
> +++ b/tools/perf/util/symbol.c
> @@ -240,6 +240,8 @@ void dso__delete(struct dso *self)
>  		free((char *)self->short_name);
>  	if (self->lname_alloc)
>  		free(self->long_name);
> +	if (self->dwarf)
> +		dwarf_end(self->dwarf);
>  	free(self);
>  }
>  
> @@ -1052,6 +1054,8 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
>  	int nr = 0;
>  	size_t opdidx = 0;
>  
> +	self->dwarf = dwarf_begin(fd, DWARF_C_READ);
> +
>  	elf = elf_begin(fd, PERF_ELF_C_READ_MMAP, NULL);
>  	if (elf == NULL) {
>  		pr_debug("%s: cannot read %s ELF file.\n", __func__, name);
> diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
> index 713b0b4..e07b907 100644
> --- a/tools/perf/util/symbol.h
> +++ b/tools/perf/util/symbol.h
> @@ -8,6 +8,7 @@
>  #include <linux/list.h>
>  #include <linux/rbtree.h>
>  #include <stdio.h>
> +#include <elfutils/libdw.h>
>  
>  #ifdef HAVE_CPLUS_DEMANGLE
>  extern char *cplus_demangle(const char *, int);
> @@ -135,6 +136,7 @@ struct dso {
>  	struct list_head node;
>  	struct rb_root	 symbols[MAP__NR_TYPES];
>  	struct rb_root	 symbol_names[MAP__NR_TYPES];
> +	Dwarf		 *dwarf;
>  	enum dso_kernel_type	kernel;
>  	u8		 adjust_symbols:1;
>  	u8		 has_build_id:1;
> 
> 


-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com

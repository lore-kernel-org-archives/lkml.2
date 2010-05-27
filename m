Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932649Ab0E0SIz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 14:08:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:57195 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932190Ab0E0SIw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 14:08:52 -0400
Subject: Re: [PATCH] perf: implement recording/reporting per-cpu samples
From: Peter Zijlstra <peterz@infradead.org>
To: Arun Sharma <aruns@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       davem@davemloft.net, fweisbec@gmail.com,
       Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <20100505181612.GA5091@sharma-home.net>
References: <20100503203813.GA17886@sharma-home.net>
	 <1272919356.1642.154.camel@laptop>
	 <w2u850c51c31005031353x9be8ca7h90c244d64675ce3e@mail.gmail.com>
	 <1272964598.5605.133.camel@twins>  <20100505181612.GA5091@sharma-home.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 27 May 2010 20:08:43 +0200
Message-ID: <1274983723.27810.5772.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo, could you pick this up?

On Wed, 2010-05-05 at 11:16 -0700, Arun Sharma wrote:

> From 7ae0f1cd7d6ab0d74ab3f8a8a31b11d1cd416f36 Mon Sep 17 00:00:00 2001
> From: Arun Sharma <aruns@google.com>
> Date: Mon, 3 May 2010 11:45:41 -0700
> Subject: [PATCH] Implement --sort cpu
> 
> In a shared multi-core environment, users want to analyze why their
> program was slow. In particular, if the code ran slower only on
> certain CPUs due to interference from other programs or kernel
> threads, the user should be able to notice that.
> 
> Sample usage:
> 
> perf record -f -a -- sleep 3
> perf report --sort cpu,comm
> 
> Workload:
> 
> program is running on 16 CPUs
> Experiencing interference from an antagonist only on 4 CPUs.
> 
>   Samples: 106218177676 cycles
> 
>   Overhead  CPU          Command
>   ........  ...  ...............
> 
>      6.25%  2            program
>      6.24%  6            program
>      6.24%  11           program
>      6.24%  5            program
>      6.24%  9            program
>      6.24%  10           program
>      6.23%  15           program
>      6.23%  7            program
>      6.23%  3            program
>      6.23%  14           program
>      6.22%  1            program
>      6.20%  13           program
>      3.17%  12           program
>      3.15%  8            program
>      3.14%  0            program
>      3.13%  4            program
>      3.11%  4         antagonist
>      3.11%  0         antagonist
>      3.10%  8         antagonist
>      3.07%  12        antagonist
> 
> Signed-off-by: Arun Sharma <aruns@google.com>
> ---
>  tools/perf/builtin-record.c |    3 +++
>  tools/perf/builtin-report.c |    7 +++++++
>  tools/perf/util/hist.c      |    1 +
>  tools/perf/util/sort.c      |   27 +++++++++++++++++++++++++++
>  tools/perf/util/sort.h      |    8 ++++++--
>  tools/perf/util/symbol.h    |    1 +
>  6 files changed, 45 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index 27f992a..66867b8 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -290,6 +290,9 @@ static void create_counter(int counter, int cpu)
>  	if (call_graph)
>  		attr->sample_type	|= PERF_SAMPLE_CALLCHAIN;
>  
> +	if (system_wide)
> +		attr->sample_type	|= PERF_SAMPLE_CPU;
> +
>  	if (raw_samples) {
>  		attr->sample_type	|= PERF_SAMPLE_TIME;
>  		attr->sample_type	|= PERF_SAMPLE_RAW;
> diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
> index 816edae..6014d70 100644
> --- a/tools/perf/builtin-report.c
> +++ b/tools/perf/builtin-report.c
> @@ -190,6 +190,13 @@ static int process_sample_event(event_t *event, struct perf_session *session)
>  		return -1;
>  	}
>  
> +	if (session->sample_type & PERF_SAMPLE_CPU) {
> +		dump_printf("... cpu: %d\n", data.cpu);
> +		al.cpu = data.cpu;
> +	} else {
> +		al.cpu = -1;
> +	}
> +
>  	if (al.filtered || (hide_unresolved && al.sym == NULL))
>  		return 0;
>  
> diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
> index ad6b22d..4640015 100644
> --- a/tools/perf/util/hist.c
> +++ b/tools/perf/util/hist.c
> @@ -52,6 +52,7 @@ struct hist_entry *__perf_session__add_hist_entry(struct rb_root *hists,
>  		},
>  		.ip	= al->addr,
>  		.level	= al->level,
> +		.cpu    = al->cpu,
>  		.count	= count,
>  		.parent = sym_parent,
>  	};
> diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
> index da30b30..ee70bb8 100644
> --- a/tools/perf/util/sort.c
> +++ b/tools/perf/util/sort.c
> @@ -13,6 +13,7 @@ enum sort_type	sort__first_dimension;
>  unsigned int dsos__col_width;
>  unsigned int comms__col_width;
>  unsigned int threads__col_width;
> +unsigned int cpu__col_width;
>  static unsigned int parent_symbol__col_width;
>  char * field_sep;
>  
> @@ -28,6 +29,8 @@ static int hist_entry__sym_snprintf(struct hist_entry *self, char *bf,
>  				    size_t size, unsigned int width);
>  static int hist_entry__parent_snprintf(struct hist_entry *self, char *bf,
>  				       size_t size, unsigned int width);
> +static int hist_entry__cpu_snprintf(struct hist_entry *self, char *bf,
> +				    size_t size, unsigned int width);
>  
>  struct sort_entry sort_thread = {
>  	.se_header	= "Command:  Pid",
> @@ -64,6 +67,13 @@ struct sort_entry sort_parent = {
>  	.se_width	= &parent_symbol__col_width,
>  };
>  
> +struct sort_entry sort_cpu = {
> +	.se_header      = "CPU",
> +	.se_cmp	        = sort__cpu_cmp,
> +	.se_snprintf    = hist_entry__cpu_snprintf,
> +	.se_width	= &cpu__col_width,
> +};
> +
>  struct sort_dimension {
>  	const char		*name;
>  	struct sort_entry	*entry;
> @@ -76,6 +86,7 @@ static struct sort_dimension sort_dimensions[] = {
>  	{ .name = "dso",	.entry = &sort_dso,	},
>  	{ .name = "symbol",	.entry = &sort_sym,	},
>  	{ .name = "parent",	.entry = &sort_parent,	},
> +	{ .name = "cpu",	.entry = &sort_cpu,	},
>  };
>  
>  int64_t cmp_null(void *l, void *r)
> @@ -242,6 +253,20 @@ static int hist_entry__parent_snprintf(struct hist_entry *self, char *bf,
>  			      self->parent ? self->parent->name : "[other]");
>  }
>  
> +/* --sort cpu */
> +
> +int64_t
> +sort__cpu_cmp(struct hist_entry *left, struct hist_entry *right)
> +{
> +	return right->cpu - left->cpu;
> +}
> +
> +static int hist_entry__cpu_snprintf(struct hist_entry *self, char *bf,
> +				       size_t size, unsigned int width)
> +{
> +	return repsep_snprintf(bf, size, "%-*d", width, self->cpu);
> +}
> +
>  int sort_dimension__add(const char *tok)
>  {
>  	unsigned int i;
> @@ -281,6 +306,8 @@ int sort_dimension__add(const char *tok)
>  				sort__first_dimension = SORT_SYM;
>  			else if (!strcmp(sd->name, "parent"))
>  				sort__first_dimension = SORT_PARENT;
> +			else if (!strcmp(sd->name, "cpu"))
> +				sort__first_dimension = SORT_CPU;
>  		}
>  
>  		list_add_tail(&sd->entry->list, &hist_entry__sort_list);
> diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
> index b7c54ee..82c5596 100644
> --- a/tools/perf/util/sort.h
> +++ b/tools/perf/util/sort.h
> @@ -60,6 +60,7 @@ struct hist_entry {
>  	char			level;
>  	u8			filtered;
>  	struct symbol		*parent;
> +	s32                     cpu;
>  	union {
>  		unsigned long	  position;
>  		struct hist_entry *pair;
> @@ -73,7 +74,8 @@ enum sort_type {
>  	SORT_COMM,
>  	SORT_DSO,
>  	SORT_SYM,
> -	SORT_PARENT
> +	SORT_PARENT,
> +	SORT_CPU
>  };
>  
>  /*
> @@ -102,6 +104,8 @@ extern size_t sort__thread_print(FILE *, struct hist_entry *, unsigned int);
>  extern size_t sort__comm_print(FILE *, struct hist_entry *, unsigned int);
>  extern size_t sort__dso_print(FILE *, struct hist_entry *, unsigned int);
>  extern size_t sort__sym_print(FILE *, struct hist_entry *, unsigned int __used);
> +extern size_t sort__parent_print(FILE *, struct hist_entry *, unsigned int);
> +extern size_t sort__cpu_print(FILE *, struct hist_entry *, unsigned int);
>  extern int64_t cmp_null(void *, void *);
>  extern int64_t sort__thread_cmp(struct hist_entry *, struct hist_entry *);
>  extern int64_t sort__comm_cmp(struct hist_entry *, struct hist_entry *);
> @@ -109,7 +113,7 @@ extern int64_t sort__comm_collapse(struct hist_entry *, struct hist_entry *);
>  extern int64_t sort__dso_cmp(struct hist_entry *, struct hist_entry *);
>  extern int64_t sort__sym_cmp(struct hist_entry *, struct hist_entry *);
>  extern int64_t sort__parent_cmp(struct hist_entry *, struct hist_entry *);
> -extern size_t sort__parent_print(FILE *, struct hist_entry *, unsigned int);
> +extern int64_t sort__cpu_cmp(struct hist_entry *, struct hist_entry *);
>  extern int sort_dimension__add(const char *);
>  void sort_entry__setup_elide(struct sort_entry *self, struct strlist *list,
>  			     const char *list_name, FILE *fp);
> diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
> index 478f5ab..4b3e09d 100644
> --- a/tools/perf/util/symbol.h
> +++ b/tools/perf/util/symbol.h
> @@ -112,6 +112,7 @@ struct addr_location {
>  	char	      level;
>  	bool	      filtered;
>  	unsigned int  cpumode;
> +	s32           cpu;
>  };
>  
>  enum dso_kernel_type {


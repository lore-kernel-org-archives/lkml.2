Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916Ab0GLOmB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 10:42:01 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46941 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755773Ab0GLOmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 10:42:00 -0400
Date: Mon, 12 Jul 2010 11:41:44 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCHv9 2.6.35-rc4-tip 12/13]  [RFC] perf: Show Potential probe
 points.
Message-ID: <20100712144144.GD25238@ghostprotocols.net>
References: <20100712103214.27491.15142.sendpatchset@localhost6.localdomain6>
 <20100712103432.27491.61687.sendpatchset@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100712103432.27491.61687.sendpatchset@localhost6.localdomain6>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jul 12, 2010 at 04:04:32PM +0530, Srikar Dronamraju escreveu:
> Introduces an option to list potential probes to probe using perf
> probe command. Also introduces an option to limit the dso to list the
> potential probes. Listing of potential probes is sorted by dso and
> alphabetical order.

> Show all potential probes in the kernel and limit to the last 10 functions.
> # perf probe -S | tail
> zone_reclaimable_pages
> zone_spanned_pages_in_node

<SNIP>
 
> diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
> @@ -134,6 +136,17 @@ static int opt_show_lines(const struct option *opt __used,
>  }
>  #endif
>  
> +static int opt_limit_dsos(const struct option *opt __used,
> +			       const char *str, int unset __used)
> +{
> +	if (str) {
> +		if (!params.limitlist)
> +			params.limitlist = strlist__new(true, NULL);

What if strlist__new() fails?

> +		strlist__add(params.limitlist, str);
> +	}
> +	return 0;
> +}
> +
>  static const char * const probe_usage[] = {
>  	"perf probe [<options>] 'PROBEDEF' ['PROBEDEF' ...]",
>  	"perf probe [<options>] --add 'PROBEDEF' [--add 'PROBEDEF' ...]",
> diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
> index f391345..b7dedcd 100644
> --- a/tools/perf/util/map.h
> +++ b/tools/perf/util/map.h
> @@ -210,6 +210,8 @@ int map_groups__fixup_overlappings(struct map_groups *self, struct map *map,
>  
>  struct map *map_groups__find_by_name(struct map_groups *self,
>  				     enum map_type type, const char *name);
> +int map_groups__iterate_maps(struct map_groups *self, enum map_type type,
> +		const char *name, int (*fn)(struct map*, const char *));

Humm, here I think perhaps we should try to do as the kernel and
introduce some form of:

map_groups__for_each_map(self, pos)

Like we have for list_for_each_entry, strlist__for_each, for_each_lang,
for_each_script, etc.

Matter of coding style, following the culture of the kernel is a goal
for these tools, to encourage kernel hackers to contribute to these
tools.

>  struct map *machine__new_module(struct machine *self, u64 start, const char *filename);
>  
>  void map_groups__flush(struct map_groups *self);
> diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
> index ef7c2d5..05b0748 100644
> --- a/tools/perf/util/probe-event.c
> +++ b/tools/perf/util/probe-event.c
> @@ -1842,7 +1842,6 @@ int del_perf_probe_events(struct strlist *dellist, pid_t pid)
>  	struct str_node *ent;
>  	struct strlist *namelist = NULL, *unamelist = NULL;
>  
> -
>  	/* Get current event names */
>  	if (!pid) {
>  		kfd = open_kprobe_events(true);
> @@ -1907,3 +1906,87 @@ error:
>  	}
>  	return ret;
>  }
> +
> +static int print_list_available_symbols(struct map *map,
> +					const char *name __unused)
> +{
> +	if (map__load(map, NULL) < 0)
> +		return -EINVAL;
> +	if (!dso__sorted_by_name(map->dso, map->type))
> +		dso__sort_by_name(map->dso, map->type);
> +
> +	dso__list_available_symbols(map->dso, map->type);
> +	return 0;
> +}
> +
> +int show_possible_probes(struct strlist *limitlist, pid_t pid)
> +{
> +	struct perf_session *session;
> +	struct thread *thread;
> +	struct str_node *ent;
> +	struct map *map = NULL;
> +	char *name, *str;
> +	int ret = -EINVAL;
> +
> +	if (!pid) {
> +		ret = init_vmlinux();
> +		if (ret < 0)
> +			return ret;
> +		return print_list_available_symbols(
> +				machine.vmlinux_maps[MAP__FUNCTION], NULL);
> +	}
> +
> +	session = perf_session__new(NULL, O_WRONLY, false, false);
> +	if (!session) {
> +		ret = -ENOMEM;
> +		goto out_delete;
> +	}
> +
> +	symbol_conf.sort_by_name = true;
> +	symbol_conf.try_vmlinux_path = false;
> +	if (symbol__init() < 0)
> +		semantic_error("Cannot initialize symbols.");
> +
> +	event__synthesize_thread(pid, event__process, session);
> +
> +	thread = perf_session__findnew(session, pid);
> +	if (!thread)
> +		goto out_delete;
> +
> +	if (!limitlist)
> +		ret = map_groups__iterate_maps(&thread->mg,
> +				MAP__FUNCTION, NULL,
> +				print_list_available_symbols);
> +	strlist__for_each(ent, limitlist) {
> +		str = strdup(ent->s);
> +		if (!str) {
> +			ret = -ENOMEM;
> +			goto out_delete;
> +		}
> +
> +		name = basename(make_absolute_path(str));
> +		if (!name) {
> +			pr_warning("Skip probe listing in %s DSO.", str);
> +			free(str);
> +			continue;
> +		}
> +		map = map_groups__find_by_name(&thread->mg,
> +						MAP__FUNCTION, name);
> +		if (!map) {
> +			pr_warning("Skip probe listing in %s DSO.", str);
> +			free(str);
> +			continue;
> +		}
> +		ret = print_list_available_symbols(map, NULL);
> +		if (ret)
> +			pr_warning("Unknown dso %s .\n", str);
> +		free(str);
> +	}
> +
> +out_delete:
> +	if (ret)
> +		pr_warning("Failed to list available probes.\n");
> +	if (session)
> +		perf_session__delete(session);
> +	return ret;
> +}
> diff --git a/tools/perf/util/probe-event.h b/tools/perf/util/probe-event.h
> index f69f98e..a7a6a86 100644
> --- a/tools/perf/util/probe-event.h
> +++ b/tools/perf/util/probe-event.h
> @@ -116,6 +116,7 @@ extern int add_perf_probe_events(struct perf_probe_event *pevs, int npevs,
>  extern int del_perf_probe_events(struct strlist *dellist, pid_t pid);
>  extern int show_perf_probe_events(void);
>  extern int show_line_range(struct line_range *lr);
> +extern int show_possible_probes(struct strlist *availlist, pid_t pid);
>  
>  
>  /* Maximum index number of event-name postfix */
> diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
> index 971d0a0..18bb1d8 100644
> --- a/tools/perf/util/symbol.c
> +++ b/tools/perf/util/symbol.c
> @@ -1448,6 +1448,28 @@ struct map *map_groups__find_by_name(struct map_groups *self,
>  	return NULL;
>  }
>  
> +int map_groups__iterate_maps(struct map_groups *self, enum map_type type,
> +			const char *name, int (*fn)(struct map*, const char *))
> +{
> +	struct rb_node *nd;
> +	struct map *map;
> +	int ret;
> +
> +	if (!fn)
> +		return -EINVAL;
> +
> +	for (nd = rb_first(&self->maps[type]); nd; nd = rb_next(nd)) {
> +		map = rb_entry(nd, struct map, rb_node);
> +		if (!map)
> +			return -EINVAL;
> +
> +		ret = fn(map, name);
> +		if (ret)
> +			return ret;
> +	}
> +	return 0;
> +}
> +
>  static int dso__kernel_module_get_build_id(struct dso *self,
>  				const char *root_dir)
>  {
> @@ -2343,3 +2365,19 @@ int machine__load_vmlinux_path(struct machine *self, enum map_type type,
>  
>  	return ret;
>  }
> +
> +void dso__list_available_symbols(struct dso *self, enum map_type type)
> +{
> +	struct rb_root *rb;
> +	struct rb_node *nd;
> +	struct symbol_name_rb_node *pos;
> +
> +	if (!self)
> +		return;
> +
> +	rb = &self->symbol_names[type];
> +	for (nd = rb_first(&self->symbol_names[type]); nd; nd = rb_next(nd)) {
> +		pos = rb_entry(nd, struct symbol_name_rb_node, rb_node);
> +		printf("%s\n", pos->sym.name);
> +	}

Also here please follow the style of the other routines that print
entries, i.e.:

size_t dso__fprintf_symbols(self, type, fp)

like this:

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 971d0a0..85fe580 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -370,9 +370,21 @@ size_t dso__fprintf_buildid(struct dso *self, FILE *fp)
 	return fprintf(fp, "%s", sbuild_id);
 }
 
-size_t dso__fprintf(struct dso *self, enum map_type type, FILE *fp)
+size_t dso__fprintf_symbols(struct dso *self, enum map_type type, FILE *fp)
 {
+	size_t ret = 0;
 	struct rb_node *nd;
+
+	for (nd = rb_first(&self->symbols[type]); nd; nd = rb_next(nd)) {
+		struct symbol *pos = rb_entry(nd, struct symbol, rb_node);
+		ret += symbol__fprintf(pos, fp);
+	}
+
+	return ret;
+}
+
+size_t dso__fprintf(struct dso *self, enum map_type type, FILE *fp)
+{
 	size_t ret = fprintf(fp, "dso: %s (", self->short_name);
 
 	if (self->short_name != self->long_name)
@@ -381,12 +393,8 @@ size_t dso__fprintf(struct dso *self, enum map_type type, FILE *fp)
 		       self->loaded ? "" : "NOT ");
 	ret += dso__fprintf_buildid(self, fp);
 	ret += fprintf(fp, ")\n");
-	for (nd = rb_first(&self->symbols[type]); nd; nd = rb_next(nd)) {
-		struct symbol *pos = rb_entry(nd, struct symbol, rb_node);
-		ret += symbol__fprintf(pos, fp);
-	}
 
-	return ret;
+	return ret + dso__fprintf_symbols(self, type, fp);
 }
 
 int kallsyms__parse(const char *filename, void *arg,
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 261a3e3..714d286 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -177,6 +177,7 @@ size_t machines__fprintf_dsos(struct rb_root *self, FILE *fp);
 size_t machines__fprintf_dsos_buildid(struct rb_root *self, FILE *fp, bool with_hits);
 
 size_t dso__fprintf_buildid(struct dso *self, FILE *fp);
+size_t dso__fprintf_symbols(struct dso *self, enum map_type type, FILE *fp);
 size_t dso__fprintf(struct dso *self, enum map_type type, FILE *fp);
 
 enum dso_origin {

------------------------------------

This way we reduce the resulting code size while following the existing
style.

- Arnaldo

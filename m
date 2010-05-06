Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053Ab0EFXO4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 19:14:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5750 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360Ab0EFXOy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 19:14:54 -0400
Message-ID: <4BE34D1D.2020100@redhat.com>
Date: Thu, 06 May 2010 19:13:33 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Mel Gorman <mel@csn.ul.ie>, Randy Dunlap <rdunlap@xenotime.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 10/10] perf: perf interface for uprobes.
References: <20100506180139.28877.81699.sendpatchset@localhost6.localdomain6> <20100506180340.28877.25709.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20100506180340.28877.25709.sendpatchset@localhost6.localdomain6>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Srikar Dronamraju wrote:
> perf-events.patch
> 
> From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> 
> This patch enhances perf probe to accept pid and user vaddr.
> This patch provides very basic support for uprobes.

Good work! Thank you!

> TODO:
> Update perf-probes.txt.
> Global tracing.

Could you also rebase your patch on the latest tip tree? :)
(and remove die() too)

> Here is a terminal snapshot of placing, using and removing a probe on a
> process with pid 3329 (corresponding to zsh)
> 
> [ Probing a function in the executable using function name  ]
> -------------------------------------------------------------
> [root@ABCD]# perf probe -p 3329 zfree@zsh

Hmm, I'm not sure why we have to specify both of PID and exec name.
Is that possible to give a symbol as below? (omit exec name)

# perf probe -p 3329 zfree

> Added new event:
>   probe:p_3329_zfree                       (on 0x446420)

Hmm, the event name should be simpler, as like as zfree_3329.
or, we might better make a new event group for each process, as like as
'probe_3329:zfree'


> You can now use it on all perf tools, such as:
> 
> 	perf record -e probe:p_3329_zfree -a sleep 1
> [root@ABCD]# perf probe --list
> probe:p_3329_zfree                       (on 3329:0x0000000000446420)
> [root@ABCD]# cat /sys/kernel/debug/tracing/uprobe_events
> p:probe/p_3329_zfree 3329:0x0000000000446420
> [root@ABCD]# perf record -f -e probe:p_3329_zfree -a sleep 10
> [ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.039 MB perf.data (~1716 samples) ]
> [root@ABCD]# perf probe -p 3329 --del probe:p_3329_zfree
> Remove event: probe:p_3329_zfree
> [root@ABCD]# perf report
> # Samples: 447
> #
> # Overhead          Command  Shared Object  Symbol
> # ........  ...............  .............  ......
> #
>    100.00%              zsh  zsh            [.] zfree
> 
> 
> #
> # (For a higher level overview, try: perf report --sort comm,dso)
> #
> 
> [ Probing a function + offset ]
> -------------------------------

Looks great! :D

[...]
> 
> Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> ---
> 
>  tools/perf/builtin-probe.c     |   34 +++++--
>  tools/perf/builtin-top.c       |   20 ----
>  tools/perf/util/event.c        |   20 ++++
>  tools/perf/util/event.h        |    1 
>  tools/perf/util/probe-event.c  |  207 ++++++++++++++++++++++++++++++++--------
>  tools/perf/util/probe-event.h  |    9 +-
>  tools/perf/util/probe-finder.h |    1 
>  tools/perf/util/symbol.c       |    6 +
>  8 files changed, 224 insertions(+), 74 deletions(-)

Some comments on the patch.

[...]
> 
> diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
> index 152d6c9..9f867ad 100644
> --- a/tools/perf/builtin-probe.c
> +++ b/tools/perf/builtin-probe.c
> @@ -55,6 +55,7 @@ static struct {
>  	bool force_add;
>  	bool show_lines;
>  	int nr_probe;
> +	pid_t pid;
>  	struct probe_point probes[MAX_PROBES];
>  	struct strlist *dellist;
>  	struct map_groups kmap_groups;
> @@ -73,7 +74,7 @@ static void parse_probe_event(const char *str)
>  		die("Too many probes (> %d) are specified.", MAX_PROBES);
>  
>  	/* Parse perf-probe event into probe_point */
> -	parse_perf_probe_event(str, pp, &session.need_dwarf);
> +	parse_perf_probe_event(str, pp, &session.need_dwarf, session.pid);
>  
>  	pr_debug("%d arguments\n", pp->nr_args);
>  }
> @@ -203,6 +204,8 @@ static const struct option options[] = {
>  		     "FUNC[:RLN[+NUM|:RLN2]]|SRC:ALN[+NUM|:ALN2]",
>  		     "Show source code lines.", opt_show_lines),
>  #endif
> +	OPT_INTEGER('p', "pid", &session.pid,
> +	"specify a pid for a uprobes based probe"),
>  	OPT_END()
>  };
>  
> @@ -263,7 +266,7 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
>  	}
>  
>  #ifndef NO_DWARF_SUPPORT
> -	if (session.show_lines) {
> +	if (session.show_lines && !session.pid) {
>  		if (session.nr_probe != 0 || session.dellist) {
>  			pr_warning("  Error: Don't use --line with"
>  				   " --add/--del.\n");

Hmm, if user gave --list with -p, what happened?
We need to check a bad combination and warn it.

> @@ -283,12 +286,19 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
>  #endif
>  
>  	if (session.dellist) {
> -		del_trace_kprobe_events(session.dellist);
> +		if (session.pid)
> +			del_trace_uprobe_events(session.dellist);
> +		else
> +			del_trace_kprobe_events(session.dellist);
> +
>  		strlist__delete(session.dellist);
>  		if (session.nr_probe == 0)
>  			return 0;
>  	}
>  
> +	if (session.pid)
> +		goto end_dwarf;
> +

Again, it must be checked that the combination of -p option and dwarf requirement.
The latest code has perf_probe_event_need_dwarf(), so you can check it easier.

[...]
> @@ -112,6 +113,64 @@ static bool check_event_name(const char *name)
>  	return true;
>  }
>  
> +/*
> + * uprobe_events only accepts address:
> + * Convert function and any offset to address
> + */
> +static void convert_name_to_addr(struct probe_point *pp)
> +{
> +	struct perf_session *session;
> +	struct thread *thread;
> +	struct symbol *sym;
> +	struct map *map;
> +	char *name = pp->file;
> +	unsigned long long vaddr;
> +
> +	/* check if user has specifed a virtual address */
> +	vaddr = strtoul(pp->function, NULL, 0);
> +	if (vaddr)
> +		return;
> +
> +	session = perf_session__new(NULL, O_WRONLY, false);
> +	DIE_IF(session == NULL);
> +	symbol_conf.sort_by_name = true;
> +	symbol_conf.try_vmlinux_path = false;
> +	if (symbol__init() < 0)
> +		semantic_error("Cannot initialize symbols.");
> +
> +	event__synthesize_thread(pp->upid, event__process, session);
> +
> +	thread = perf_session__findnew(session, pp->upid);
> +	DIE_IF(thread == NULL);
> +
> +	if (!name)
> +		/* Lets find the function in the executable. */
> +		name = thread->comm;
> +	DIE_IF(name == NULL);
> +
> +	map = map_groups__find_by_name(&thread->mg, MAP__FUNCTION, name);
> +	if (!map)
> +		semantic_error("Cannot find appropriate DSO.");
> +
> +	sym = map__find_symbol_by_name(map, pp->function, NULL);
> +	if (!sym)
> +		semantic_error("Cannot find appropriate Symbol.");
> +
> +	if (map->start > sym->start)
> +		vaddr = map->start;
> +	vaddr += sym->start + pp->offset + map->pgoff;
> +	pp->offset = 0;
> +
> +	if (!pp->event)
> +		pp->event = pp->function;
> +	else
> +		free(pp->function);
> +	pp->function = zalloc(sizeof(char *) * 20);
> +	if (!pp->function)
> +		die("Failed to allocate memory by zalloc.");
> +	e_snprintf(pp->function, 20, "0x%llx", vaddr);
> +}

Well, after rebasing, you'll need to remove die()s from here and
make it returns errors. 

[...]
> @@ -383,7 +450,11 @@ int synthesize_trace_kprobe_event(struct probe_point *pp)
>  	pp->probes[0] = buf = zalloc(MAX_CMDLEN);
>  	if (!buf)
>  		die("Failed to allocate memory by zalloc.");
> -	ret = e_snprintf(buf, MAX_CMDLEN, "%s+%d", pp->function, pp->offset);
> +	if (pp->offset)
> +		ret = e_snprintf(buf, MAX_CMDLEN, "%s+%d", pp->function,
> +					pp->offset);
> +	else
> +		ret = e_snprintf(buf, MAX_CMDLEN, "%s", pp->function);
>  	if (ret <= 0)
>  		goto error;
>  	len = ret;

Isn't it a cleanup ?

[...]
> @@ -595,22 +697,25 @@ static void get_new_event_name(char *buf, size_t len, const char *base,
>  		die("Too many events are on the same function.");
>  }
>  
> -void add_trace_kprobe_events(struct probe_point *probes, int nr_probes,
> -			     bool force_add)
> +static void add_trace_probe_events(int fd, struct probe_point *probes,
> +		int nr_probes, bool force_add, pid_t pid)
>  {
> -	int i, j, fd;
> +	int i, j;
>  	struct probe_point *pp;
>  	char buf[MAX_CMDLEN];
> +	char tempbuf[MAX_CMDLEN];
>  	char event[64];
>  	struct strlist *namelist;
>  	bool allow_suffix;
>  
> -	fd = open_kprobe_events(O_RDWR, O_APPEND);
>  	/* Get current event names */
>  	namelist = get_perf_event_names(fd, false);
>  
>  	for (j = 0; j < nr_probes; j++) {
>  		pp = probes + j;
> +		pp->upid = pid;
> +		if (pid)
> +			snprintf(tempbuf, MAX_CMDLEN, "%d:", pid);
>  		if (!pp->event)
>  			pp->event = strdup(pp->function);
>  		if (!pp->group)
> @@ -621,12 +726,13 @@ void add_trace_kprobe_events(struct probe_point *probes, int nr_probes,
>  		for (i = 0; i < pp->found; i++) {
>  			/* Get an unused new event name */
>  			get_new_event_name(event, 64, pp->event, namelist,
> -					   allow_suffix);
> -			snprintf(buf, MAX_CMDLEN, "%c:%s/%s %s\n",
> +					   allow_suffix, pid);
> +			snprintf(buf, MAX_CMDLEN, "%c:%s/%s %s%s\n",
>  				 pp->retprobe ? 'r' : 'p',
>  				 pp->group, event,
> +				 pp->upid ? tempbuf : " ",
>  				 pp->probes[i]);
> -			write_trace_kprobe_event(fd, buf);
> +			write_trace_probe_event(fd, buf);
>  			printf("Added new event:\n");
>  			/* Get the first parameter (probe-point) */
>  			sscanf(pp->probes[i], "%s", buf);
> @@ -650,7 +756,21 @@ void add_trace_kprobe_events(struct probe_point *probes, int nr_probes,
>  	close(fd);
>  }
>  
> -static void __del_trace_kprobe_event(int fd, struct str_node *ent)
> +void add_trace_kprobe_events(struct probe_point *probes, int nr_probes,
> +			     bool force_add)
> +{
> +	int fd = open_kprobe_events(O_RDWR, O_APPEND);
> +	add_trace_probe_events(fd, probes, nr_probes, force_add, 0);
> +}
> +
> +void add_trace_uprobe_events(struct probe_point *probes, int nr_probes,
> +			     bool force_add, pid_t pid)
> +{
> +	int fd = open_uprobe_events(O_RDWR, O_APPEND);
> +	add_trace_probe_events(fd, probes, nr_probes, force_add, pid);
> +}

Please close fd in the function which opened it.


> @@ -696,16 +816,13 @@ static void del_trace_kprobe_event(int fd, const char *group,
>  		pr_info("Info: event \"%s\" does not exist, could not remove it.\n", buf);
>  }
>  
> -void del_trace_kprobe_events(struct strlist *dellist)
> +static void del_trace_probe_events(int fd, struct strlist *dellist)
>  {
> -	int fd;
>  	const char *group, *event;
>  	char *p, *str;
>  	struct str_node *ent;
>  	struct strlist *namelist;
>  
> -	fd = open_kprobe_events(O_RDWR, O_APPEND);
> -	/* Get current event names */
>  	namelist = get_perf_event_names(fd, true);
>  
>  	strlist__for_each(ent, dellist) {
> @@ -723,13 +840,25 @@ void del_trace_kprobe_events(struct strlist *dellist)
>  			event = str;
>  		}
>  		pr_debug("Group: %s, Event: %s\n", group, event);
> -		del_trace_kprobe_event(fd, group, event, namelist);
> +		del_trace_probe_event(fd, group, event, namelist);
>  		free(str);
>  	}
>  	strlist__delete(namelist);
>  	close(fd);
>  }
>  
> +void del_trace_kprobe_events(struct strlist *dellist)
> +{
> +	int fd = open_kprobe_events(O_RDWR, O_APPEND);
> +	del_trace_probe_events(fd, dellist);
> +}
> +
> +void del_trace_uprobe_events(struct strlist *dellist)
> +{
> +	int fd = open_uprobe_events(O_RDWR, O_APPEND);
> +	del_trace_probe_events(fd, dellist);
> +}

Ditto.

[...]
> diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
> index c458c4a..7267050 100644
> --- a/tools/perf/util/symbol.c
> +++ b/tools/perf/util/symbol.c
> @@ -958,12 +958,14 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
>  	nr_syms = shdr.sh_size / shdr.sh_entsize;
>  
>  	memset(&sym, 0, sizeof(sym));
> -	if (!self->kernel) {
> +	if (self->kernel || symbol_conf.sort_by_name)
> +		self->adjust_symbols = 0;
> +	else {
>  		self->adjust_symbols = (ehdr.e_type == ET_EXEC ||
>  				elf_section_by_name(elf, &ehdr, &shdr,
>  						     ".gnu.prelink_undo",
>  						     NULL) != NULL);
> -	} else self->adjust_symbols = 0;
> +	}
>  
>  	elf_symtab__for_each_symbol(syms, nr_syms, idx, sym) {
>  		struct symbol *f;

This one changes the symbol.c, so I think you'd better make a
separate patch for this change.

Thank you,

-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com

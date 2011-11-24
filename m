Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171Ab1KXSLD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 13:11:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16689 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750832Ab1KXSLB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 13:11:01 -0500
Date: Thu, 24 Nov 2011 16:10:52 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Robert Richter <robert.richter@amd.com>
Cc: mingo@redhat.com, eranian@google.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, efault@gmx.de, peterz@infradead.org
Subject: Re: libperf interface stability
Message-ID: <20111124181052.GA4058@infradead.org>
References: <new-submission> <tip-06daaaba7c211ca6a8227b9a54dbc86dd837f034@git.kernel.org> <20111124162845.GB7795@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111124162845.GB7795@erda.amd.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Nov 24, 2011 at 05:28:45PM +0100, Robert Richter escreveu:
> On 02.08.10 07:49:49, tip-bot for Arnaldo Carvalho de Melo wrote:
> > +	if (symbol_conf.show_cpu_utilization) {
> > +		ret += 7; /* count_sys % */
> > +		ret += 6; /* count_us % */
> > +		if (perf_guest) {
> 
> Arnaldo,
> 
> this accesses a global variable that is not part of libperf. Linking
> it causes undefined references, see below for example code. This
> applies at least to following symbols: perf_guest, perf_host,
> use_browser, perf_version_string. To fix this we need to extend the
> library interface. As a workaround the references must be added to the
> application using libperf:
> 
> bool perf_host;
> bool perf_guest;
> const char perf_version_string[] = "undefined";
> int use_browser = -1;
> 
> Also there are library dependencies to -lelf -ldw -lm -lbfd even if
> its functionality is not used. It would be better to load libraries
> dynamically then or to have switches to disable code using them.
> 
> Is libperf supposed to be a library interface in general, or is it for

No it was not meant to be, I guess, when I started working in perf it
was there already, I guess it was made like that by Ingo following some
convention found in the git sources from where code/model was borrowed.

> internal perf tools usage only?

yes, so far

> It would be good to have a well defined, stable libperf interface for
> tools other than perf.

Agreed, an effort in this direction was the perf python binding, that so
far includes only:

tools/perf/util/setup.py

	sources = ['util/python.c', 'util/ctype.c', 'util/evlist.c',
		   'util/evsel.c', 'util/cpumap.c', 'util/thread_map.c',
		   'util/util.c', 'util/xyarray.c', 'util/cgroup.c',
		   'util/debugfs.c'],

You need https://github.com/acmel/linux/commits/perf/urgent to build it
tho, it has a fix for that:

In the end it generates a ~/build/perf/python/perf.so file (I use make
-C tools/perf O=/home/acme/build/perf) that has all that is needed for
simple tools like tools/perf/python/twatch.py.

I think of it as a precursor for a shared library for use with C and I
have been working on untangling references such as the symbol_conf one
you mentioned and making the 'perf_evlist' and 'perf_evsel' classes the
main way to work with libperf.

I'm working right now on another effort that hopefully will end up
easing the development of new tools, in-perf and outside, current goal
is to have a strace like tool using using code carved out from tools.

I have a branch that I explicitely mark as unstable where I'm putting
what I have at:

https://github.com/acmel/linux/commits/tmp.perf/trace4

I hope to have it in a form that is reasonable to move it to 'perf/core'
and then ask Ingo to merge it in the next merge window.

This is how the 'strace' is looking like, removing the error handling to
simplify:

static const char *strace__tracepoints[] = {
	"raw_syscalls:sys_enter",
	"raw_syscalls:sys_exit",
};

static int strace(struct perf_record_opts *opts, const char *argv[])
{
	struct perf_evlist *evlist = perf_evlist__new(NULL, NULL);

	err = perf_evlist__create_maps(evlist, opts->target_pid,
				       opts->target_tid, opts->cpu_list);

	err = perf_evlist__add_tracepoints_array(evlist, strace__tracepoints);

	err = perf_evlist__prepare_workload(evlist, opts, argv);

	perf_evlist__config_attrs(evlist, opts);

	err = perf_evlist__open(evlist, opts->group);

	err = perf_evlist__mmap(evlist, opts->mmap_pages, false);

	perf_evlist__start_workload(evlist);

	/*
	 * WIP: use perf_evlist__read, etc and then feed a
	 * perf_event_ops operations sorted events like is done in
	 * perf_session__process_events. Top is like that but currently
	 * doesn't use perf_session__process_events, we need to make it
	 * use something refactored out from perf_session that does the
	 * ordering of samples perf_session does, etc.
	 */

	perf_evlist__munmap(evlist);

	perf_evlist__delete(evlist);
}

So yes, I agree that at some point we should have a libperf.so, I'm
working on it, but there are still several experimentations to do to
commit to such an stable library :-\

Jiri Olsa is experimenting with the mmap part, that needs to be reworked
to support multiple sample types, etc.

- Arnaldo

> -Robert
> 
> 
> $ cd tools/perf
> $ cat linktest.c 
> #include "util/evsel.h"
> #include "util/evlist.h"
> #include "util/cpumap.h"
> #include "util/thread_map.h"
> 
> int main(void)
> {
> 	perf_evlist__mmap(NULL, 0, 0);
> 	return 0;
> }
> 
> $ gcc -I util/include/ -DNO_NEWT_SUPPORT -DNO_DWARF -lelf -ldw -lm -lbfd linktest.c libperf.a -o linktest
> libperf.a(hist.o): In function `hists__sort_list_width':
> tools/perf/util/hist.c:1074: undefined reference to `perf_guest'
> tools/perf/util/hist.c:1074: undefined reference to `perf_guest'
> libperf.a(hist.o): In function `hist_entry__pcnt_snprintf':
> tools/perf/util/hist.c:779: undefined reference to `perf_guest'
> libperf.a(hist.o): In function `hists__fprintf':
> tools/perf/util/hist.c:938: undefined reference to `perf_guest'
> tools/perf/util/hist.c:945: undefined reference to `perf_guest'
> libperf.a(event.o):tools/perf/util/event.c:697: more undefined references to `perf_guest' follow
> libperf.a(event.o): In function `thread__find_addr_map':
> tools/perf/util/event.c:681: undefined reference to `perf_host'
> tools/perf/util/event.c:673: undefined reference to `perf_host'
> tools/perf/util/event.c:707: undefined reference to `perf_host'
> tools/perf/util/event.c:684: undefined reference to `perf_guest'
> tools/perf/util/event.c:703: undefined reference to `perf_guest'
> libperf.a(debug.o): In function `eprintf':
> tools/perf/util/debug.c:25: undefined reference to `use_browser'
> libperf.a(header.o): In function `do_write_string':
> tools/perf/util/header.c:126: undefined reference to `perf_version_string'
> libperf.a(header.o): In function `do_write':
> tools/perf/util/header.c:94: undefined reference to `perf_version_string'
> collect2: ld returned 1 exit status
> 
> 
> > +			ret += 13; /* count_guest_sys % */
> > +			ret += 12; /* count_guest_us % */
> > +		}
> > +	}
> > +
> > +	if (symbol_conf.show_nr_samples)
> > +		ret += 11;
> > +
> > +	list_for_each_entry(se, &hist_entry__sort_list, list)
> > +		if (!se->elide)
> > +			ret += 2 + hists__col_len(self, se->se_width_idx);
> > +
> > +	return ret;
> > +}
> > +
> >  static void hists__remove_entry_filter(struct hists *self, struct hist_entry *h,
> >  				       enum hist_filter filter)
> >  {
> > diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
> > index 92962b2..65a48db 100644
> > --- a/tools/perf/util/hist.h
> > +++ b/tools/perf/util/hist.h
> > @@ -141,4 +141,7 @@ int hist_entry__tui_annotate(struct hist_entry *self);
> >  
> >  int hists__tui_browse_tree(struct rb_root *self, const char *help);
> >  #endif
> > +
> > +unsigned int hists__sort_list_width(struct hists *self);
> > +
> >  #endif	/* __PERF_HIST_H */
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> -- 
> Advanced Micro Devices, Inc.
> Operating System Research Center

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030Ab1KROiA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 09:38:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12294 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755027Ab1KROh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 09:37:59 -0500
Date: Fri, 18 Nov 2011 12:37:40 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] perf tool: Introducing perf_mmap object
Message-ID: <20111118143740.GD13052@ghostprotocols.net>
References: <1321624005-6889-1-git-send-email-jolsa@redhat.com> <1321624005-6889-4-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321624005-6889-4-git-send-email-jolsa@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Nov 18, 2011 at 02:46:43PM +0100, Jiri Olsa escreveu:
> +++ b/tools/perf/builtin-test.c
> @@ -476,6 +477,7 @@ static int test__basic_mmap(void)
>  		     expected_nr_events[nsyscalls], i, j;
>  	struct perf_evsel *evsels[nsyscalls], *evsel;
>  	int sample_size = __perf_evsel__sample_size(attr.sample_type);
> +	struct perf_mmap *md;
>  
>  	for (i = 0; i < nsyscalls; ++i) {
>  		char name[64];
> @@ -551,7 +553,9 @@ static int test__basic_mmap(void)
>  			++foo;
>  		}
>  
> -	while ((event = perf_evlist__mmap_read(evlist, 0)) != NULL) {
> +	md = &evlist->mmap[0];
> +
> +	while ((event = perf_mmap__read(md)) != NULL) {
>  		struct perf_sample sample;
>  
>  		if (event->header.type != PERF_RECORD_SAMPLE) {

Please keep perf_evlist__mmap_read() as just a wrapper for the above
operation, that way you reduce the patch size by not touching the
functions that use perf_evlist__mmap_read().

Later, if we think this is the right thing to do, i.e. to open code it
like you're doing above, we can elliminate it, but I think its better to
keep it as perf_evlist__mmap_read(evlist, 0) as it uses just one line
instead of the 4 above :-)

> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
> index 8e02027..032f70d 100644
> --- a/tools/perf/builtin-top.c
> +++ b/tools/perf/builtin-top.c
> @@ -38,6 +38,7 @@
>  #include "util/cpumap.h"
>  #include "util/xyarray.h"
>  #include "util/sort.h"
> +#include "util/mmap.h"
>  
>  #include "util/debug.h"
>  
> @@ -804,14 +805,16 @@ static void perf_event__process_sample(const union perf_event *event,
>  	return;
>  }
>  
> -static void perf_session__mmap_read_idx(struct perf_session *self, int idx)
> +static void session_mmap_read(struct perf_session *self,
> +			      struct perf_mmap *md)
>  {
> -	struct perf_sample sample;
> -	struct perf_evsel *evsel;
>  	union perf_event *event;
> -	int ret;
>  
> -	while ((event = perf_evlist__mmap_read(top.evlist, idx)) != NULL) {
> +	while ((event = perf_mmap__read(md)) != NULL) {
> +		struct perf_sample sample;
> +		struct perf_evsel *evsel;
> +		int ret;
> +

Ditto, all the above is not needed, just keep perf_evlist__mmap_read()

>  		ret = perf_session__parse_sample(self, event, &sample);
>  		if (ret) {
>  			pr_err("Can't parse sample, err = %d\n", ret);
> @@ -835,8 +838,10 @@ static void perf_session__mmap_read(struct perf_session *self)
>  {
>  	int i;
>  
> -	for (i = 0; i < top.evlist->nr_mmaps; i++)
> -		perf_session__mmap_read_idx(self, i);
> +	for (i = 0; i < top.evlist->nr_mmaps; i++) {
> +		struct perf_mmap *md = &top.evlist->mmap[i];
> +		session_mmap_read(self, md);
> +	}

ditto

>  }
>  
>  static void start_counters(struct perf_evlist *evlist)
> diff --git a/tools/perf/perf.h b/tools/perf/perf.h
> index 914c895..d79efbb 100644
> --- a/tools/perf/perf.h
> +++ b/tools/perf/perf.h
> @@ -104,32 +104,6 @@ void get_term_dimensions(struct winsize *ws);
>  #include "util/types.h"
>  #include <stdbool.h>
>  
> -struct perf_mmap {
> -	void			*base;
> -	int			mask;
> -	unsigned int		prev;
> -};
> -
> -static inline unsigned int perf_mmap__read_head(struct perf_mmap *mm)
> -{
> -	struct perf_event_mmap_page *pc = mm->base;
> -	int head = pc->data_head;
> -	rmb();
> -	return head;
> -}
> -
> -static inline void perf_mmap__write_tail(struct perf_mmap *md,
> -					 unsigned long tail)
> -{
> -	struct perf_event_mmap_page *pc = md->base;
> -
> -	/*
> -	 * ensure all reads are done before we write the tail out.
> -	 */
> -	/* mb(); */
> -	pc->data_tail = tail;
> -}
> -

Ok, the above just moved to tools/perf/util/mmap.c, I guess, reading
on...

>  /*
>   * prctl(PR_TASK_PERF_EVENTS_DISABLE) will (cheaply) disable all
>   * counters in the current task.
> diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
> index 0f715d0..2237833 100644
> --- a/tools/perf/util/evlist.c
> +++ b/tools/perf/util/evlist.c
> @@ -12,6 +12,7 @@
>  #include "evlist.h"
>  #include "evsel.h"
>  #include "util.h"
> +#include "mmap.h"
>  
>  #include <sys/mman.h>
>  
> @@ -200,82 +201,14 @@ struct perf_evsel *perf_evlist__id2evsel(struct perf_evlist *evlist, u64 id)
>  	return NULL;
>  }
>  
> -union perf_event *perf_evlist__mmap_read(struct perf_evlist *evlist, int idx)
> -{
> -	/* XXX Move this to perf.c, making it generally available */
> -	unsigned int page_size = sysconf(_SC_PAGE_SIZE);
> -	struct perf_mmap *md = &evlist->mmap[idx];
> -	unsigned int head = perf_mmap__read_head(md);
> -	unsigned int old = md->prev;
> -	unsigned char *data = md->base + page_size;
> -	union perf_event *event = NULL;

Just keep this as a simple wrapper to the functions moved to the
perf_mmap__ class

> -
> -	if (evlist->overwrite) {
> -		/*
> -		 * If we're further behind than half the buffer, there's a chance
> -		 * the writer will bite our tail and mess up the samples under us.
> -		 *
> -		 * If we somehow ended up ahead of the head, we got messed up.
> -		 *
> -		 * In either case, truncate and restart at head.
> -		 */
> -		int diff = head - old;
> -		if (diff > md->mask / 2 || diff < 0) {
> -			fprintf(stderr, "WARNING: failed to keep up with mmap data.\n");
> -
> -			/*
> -			 * head points to a known good entry, start there.
> -			 */
> -			old = head;
> -		}
> -	}
> -
> -	if (old != head) {
> -		size_t size;
> -
> -		event = (union perf_event *)&data[old & md->mask];
> -		size = event->header.size;
> -
> -		/*
> -		 * Event straddles the mmap boundary -- header should always
> -		 * be inside due to u64 alignment of output.
> -		 */
> -		if ((old & md->mask) + size != ((old + size) & md->mask)) {
> -			unsigned int offset = old;
> -			unsigned int len = min(sizeof(*event), size), cpy;
> -			void *dst = &evlist->event_copy;
> -
> -			do {
> -				cpy = min(md->mask + 1 - (offset & md->mask), len);
> -				memcpy(dst, &data[offset & md->mask], cpy);
> -				offset += cpy;
> -				dst += cpy;
> -				len -= cpy;
> -			} while (len);
> -
> -			event = &evlist->event_copy;
> -		}
> -
> -		old += size;
> -	}
> -
> -	md->prev = old;
> -
> -	if (!evlist->overwrite)
> -		perf_mmap__write_tail(md, old);
> -
> -	return event;
> -}
> -
>  void perf_evlist__munmap(struct perf_evlist *evlist)
>  {
>  	int i;
>  
>  	for (i = 0; i < evlist->nr_mmaps; i++) {
> -		if (evlist->mmap[i].base != NULL) {
> -			munmap(evlist->mmap[i].base, evlist->mmap_len);
> -			evlist->mmap[i].base = NULL;
> -		}
> +		struct perf_mmap *m = &evlist->mmap[i];
> +		if (m->base != NULL)
> +			perf_mmap__close(m);

Wouldn't it be perf_mmap__munmap() ? 

>  	}
>  
>  	free(evlist->mmap);
> @@ -292,20 +225,18 @@ int perf_evlist__alloc_mmap(struct perf_evlist *evlist)
>  }
>  
>  static int __perf_evlist__mmap(struct perf_evlist *evlist,
> -			       int idx, int prot, int mask, int fd)
> +			       int idx, int fd)
>  {
> -	evlist->mmap[idx].prev = 0;
> -	evlist->mmap[idx].mask = mask;
> -	evlist->mmap[idx].base = mmap(NULL, evlist->mmap_len, prot,
> -				      MAP_SHARED, fd, 0);
> -	if (evlist->mmap[idx].base == MAP_FAILED)
> +	struct perf_mmap *m = &evlist->mmap[idx];
> +
> +	if (perf_mmap__open(m, fd, evlist->overwrite, evlist->pages))

And here perf_mmap__mmap or at least perf_mmap__map and the other
perf_mmap__unmap?

>  		return -1;
>  
>  	perf_evlist__add_pollfd(evlist, fd);
>  	return 0;
>  }
>  
> -static int perf_evlist__mmap_per_cpu(struct perf_evlist *evlist, int prot, int mask)
> +static int perf_evlist__mmap_per_cpu(struct perf_evlist *evlist)
>  {
>  	struct perf_evsel *evsel;
>  	int cpu, thread;
> @@ -320,7 +251,7 @@ static int perf_evlist__mmap_per_cpu(struct perf_evlist *evlist, int prot, int m
>  				if (output == -1) {
>  					output = fd;
>  					if (__perf_evlist__mmap(evlist, cpu,
> -								prot, mask, output) < 0)
> +								output) < 0)
>  						goto out_unmap;
>  				} else {
>  					if (ioctl(fd, PERF_EVENT_IOC_SET_OUTPUT, output) != 0)
> @@ -334,15 +265,14 @@ static int perf_evlist__mmap_per_cpu(struct perf_evlist *evlist, int prot, int m
>  
>  out_unmap:
>  	for (cpu = 0; cpu < evlist->cpus->nr; cpu++) {
> -		if (evlist->mmap[cpu].base != NULL) {
> -			munmap(evlist->mmap[cpu].base, evlist->mmap_len);
> -			evlist->mmap[cpu].base = NULL;
> -		}
> +		struct perf_mmap *m = &evlist->mmap[cpu];
> +		if (m->base != NULL)
> +			perf_mmap__close(m);

ditto

>  	}
>  	return -1;
>  }
>  
> -static int perf_evlist__mmap_per_thread(struct perf_evlist *evlist, int prot, int mask)
> +static int perf_evlist__mmap_per_thread(struct perf_evlist *evlist)
>  {
>  	struct perf_evsel *evsel;
>  	int thread;
> @@ -356,7 +286,7 @@ static int perf_evlist__mmap_per_thread(struct perf_evlist *evlist, int prot, in
>  			if (output == -1) {
>  				output = fd;
>  				if (__perf_evlist__mmap(evlist, thread,
> -							prot, mask, output) < 0)
> +							output) < 0)
>  					goto out_unmap;
>  			} else {
>  				if (ioctl(fd, PERF_EVENT_IOC_SET_OUTPUT, output) != 0)
> @@ -369,10 +299,9 @@ static int perf_evlist__mmap_per_thread(struct perf_evlist *evlist, int prot, in
>  
>  out_unmap:
>  	for (thread = 0; thread < evlist->threads->nr; thread++) {
> -		if (evlist->mmap[thread].base != NULL) {
> -			munmap(evlist->mmap[thread].base, evlist->mmap_len);
> -			evlist->mmap[thread].base = NULL;
> -		}
> +		struct perf_mmap *m = &evlist->mmap[thread];
> +		if (m->base != NULL)
> +			perf_mmap__close(m);
>  	}
>  	return -1;
>  }
> @@ -421,10 +350,8 @@ static int perf_evlist__init_ids(struct perf_evlist *evlist)
>   */
>  int perf_evlist__mmap(struct perf_evlist *evlist, int pages, bool overwrite)
>  {
> -	unsigned int page_size = sysconf(_SC_PAGE_SIZE);
> -	int mask = pages * page_size - 1, ret;
>  	const struct cpu_map *cpus = evlist->cpus;
> -	int prot = PROT_READ | (overwrite ? 0 : PROT_WRITE);
> +	int ret;
>  
>  	if (evlist->mmap == NULL && perf_evlist__alloc_mmap(evlist) < 0)
>  		return -ENOMEM;
> @@ -433,16 +360,16 @@ int perf_evlist__mmap(struct perf_evlist *evlist, int pages, bool overwrite)
>  		return -ENOMEM;
>  
>  	evlist->overwrite = overwrite;
> -	evlist->mmap_len = (pages + 1) * page_size;
> +	evlist->pages = pages;
>  
>  	ret = perf_evlist__init_ids(evlist);
>  	if (ret)
>  		return ret;
>  
>  	if (cpus->map[0] == -1)
> -		return perf_evlist__mmap_per_thread(evlist, prot, mask);
> +		return perf_evlist__mmap_per_thread(evlist);
>  
> -	return perf_evlist__mmap_per_cpu(evlist, prot, mask);
> +	return perf_evlist__mmap_per_cpu(evlist);
>  }
>  
>  int perf_evlist__create_maps(struct perf_evlist *evlist, pid_t target_pid,
> diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
> index 1779ffe..3784273 100644
> --- a/tools/perf/util/evlist.h
> +++ b/tools/perf/util/evlist.h
> @@ -18,7 +18,7 @@ struct perf_evlist {
>  	int		 nr_entries;
>  	int		 nr_fds;
>  	int		 nr_mmaps;
> -	int		 mmap_len;
> +	int		 pages;
>  	bool		 overwrite;
>  	union perf_event event_copy;
>  	struct perf_mmap *mmap;
> diff --git a/tools/perf/util/mmap.c b/tools/perf/util/mmap.c
> new file mode 100644
> index 0000000..45e62a2
> --- /dev/null
> +++ b/tools/perf/util/mmap.c
> @@ -0,0 +1,138 @@
> +#include <string.h>
> +#include <stdio.h>
> +#include "mmap.h"
> +
> +int perf_mmap__open(struct perf_mmap *m, int fd, bool overwrite, int pages)
> +{
> +	unsigned int page_size = sysconf(_SC_PAGE_SIZE);
> +	int mask, len, prot;
> +	void *base;
> +
> +	mask = pages * page_size - 1;
> +	len  = (pages + 1) * page_size;
> +	prot = PROT_READ | (overwrite ? 0 : PROT_WRITE);
> +
> +	base = mmap(NULL, len, prot, MAP_SHARED, fd, 0);
> +	if (base == MAP_FAILED)
> +		return -1;
> +
> +	memset(m, 0, sizeof(*m));
> +	m->mask = mask;
> +	m->len  = len;
> +	m->base = base;
> +	m->fd   = fd;
> +	m->owrt = overwrite;
> +	return 0;
> +}
> +
> +int perf_mmap__close(struct perf_mmap *m)
> +{
> +	int ret = munmap(m->base, m->len);
> +
> +	memset(m, 0x0, sizeof(*m));
> +	return ret;
> +}
> +
> +int perf_mmap__process(struct perf_mmap *md, perf_mmap_process_t process)
> +{
> +	unsigned int head, old, page_size = sysconf(_SC_PAGE_SIZE);
> +	unsigned char *data = md->base + page_size;
> +	unsigned long size;
> +	void *buf;
> +
> +	head = perf_mmap__read_head(md);
> +	old  = md->prev;
> +
> +	if (old == head)
> +		return 0;
> +
> +	size = head - old;
> +
> +	if ((old & md->mask) + size != (head & md->mask)) {
> +		buf = &data[old & md->mask];
> +		size = md->mask + 1 - (old & md->mask);
> +		old += size;
> +
> +		process(md, buf, size);
> +	}
> +
> +	buf = &data[old & md->mask];
> +	size = head - old;
> +	old += size;
> +
> +	process(md, buf, size);
> +
> +	md->prev = old;
> +	perf_mmap__write_tail(md, old);
> +	return 1;
> +}
> +
> +union perf_event *perf_mmap__read(struct perf_mmap *md)
> +{
> +	unsigned int head, old, page_size = sysconf(_SC_PAGE_SIZE);
> +	unsigned char *data = md->base + page_size;
> +	union perf_event *event = NULL;
> +
> +	head = perf_mmap__read_head(md);
> +	old = md->prev;
> +
> +	if (md->owrt) {
> +		/*
> +		 * If we're further behind than half the buffer, there's
> +		 * a chance the writer will bite our tail and mess up the
> +		 * samples under us.
> +		 *
> +		 * If we somehow ended up ahead of the head, we got messed up.
> +		 *
> +		 * In either case, truncate and restart at head.
> +		 */
> +		int diff = head - old;
> +		if (diff > md->mask / 2 || diff < 0) {
> +			fprintf(stderr, "WARNING: failed to keep up "
> +					"with mmap data.\n");
> +
> +			/*
> +			 * head points to a known good entry, start there.
> +			 */
> +			old = head;
> +		}
> +	}
> +
> +	if (old != head) {
> +		size_t size;
> +
> +		event = (union perf_event *)&data[old & md->mask];
> +		size = event->header.size;
> +
> +		/*
> +		 * Event straddles the mmap boundary -- header should always
> +		 * be inside due to u64 alignment of output.
> +		 */
> +		if ((old & md->mask) + size != ((old + size) & md->mask)) {
> +			unsigned int offset = old;
> +			unsigned int len = min(sizeof(*event), size), cpy;
> +			static union perf_event event_copy;
> +			void *dst = &event_copy;
> +
> +			do {
> +				cpy = min(md->mask + 1 - (offset & md->mask),
> +					  len);
> +				memcpy(dst, &data[offset & md->mask], cpy);
> +				offset += cpy;
> +				dst += cpy;
> +				len -= cpy;
> +			} while (len);
> +
> +			event = &event_copy;
> +		}
> +
> +		old += size;
> +	}
> +
> +	md->prev = old;
> +
> +	if (!md->owrt)
> +		perf_mmap__write_tail(md, old);
> +
> +	return event;
> +}
> diff --git a/tools/perf/util/mmap.h b/tools/perf/util/mmap.h
> new file mode 100644
> index 0000000..24cf88f
> --- /dev/null
> +++ b/tools/perf/util/mmap.h
> @@ -0,0 +1,45 @@
> +#ifndef __PERF_MMAP_H
> +#define __PERF_MMAP_H
> +
> +#include <sys/mman.h>
> +#include "event.h"
> +#include "../perf.h"
> +
> +struct perf_mmap {
> +	void  *base;
> +	int   mask;
> +	u_int prev;
> +	int   len;
> +	int   fd;
> +	bool  owrt;
> +};
> +
> +typedef void (*perf_mmap_process_t)(struct perf_mmap *m,
> +				    void *buf, unsigned long size);
> +
> +int perf_mmap__open(struct perf_mmap *m, int fd, bool overwrite, int pages);
> +int perf_mmap__close(struct perf_mmap *m);
> +int perf_mmap__process(struct perf_mmap *m, perf_mmap_process_t process);
> +union perf_event *perf_mmap__read(struct perf_mmap *md);
> +
> +static inline unsigned int perf_mmap__read_head(struct perf_mmap *mm)
> +{
> +	struct perf_event_mmap_page *pc = mm->base;
> +	int head = pc->data_head;
> +	rmb();
> +	return head;
> +}
> +
> +static inline void perf_mmap__write_tail(struct perf_mmap *md,
> +					 unsigned long tail)
> +{
> +	struct perf_event_mmap_page *pc = md->base;
> +
> +	/*
> +	 * ensure all reads are done before we write the tail out.
> +	 */
> +	/* mb(); */
> +	pc->data_tail = tail;
> +}
> +
> +#endif /* __PERF_MMAP_H */
> -- 
> 1.7.4

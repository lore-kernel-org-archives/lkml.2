Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676Ab1KSSl1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 13:41:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39869 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751959Ab1KSSl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 13:41:26 -0500
Date: Sat, 19 Nov 2011 20:39:07 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] perf tool: Introducing perf_mmap object
Message-ID: <20111120013907.GB2248@krava.redhat.com>
References: <1321624005-6889-1-git-send-email-jolsa@redhat.com>
 <1321624005-6889-4-git-send-email-jolsa@redhat.com>
 <20111118143740.GD13052@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111118143740.GD13052@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 18, 2011 at 12:37:40PM -0200, Arnaldo Carvalho de Melo wrote:
> Em Fri, Nov 18, 2011 at 02:46:43PM +0100, Jiri Olsa escreveu:
> > +++ b/tools/perf/builtin-test.c
> > @@ -476,6 +477,7 @@ static int test__basic_mmap(void)
> >  		     expected_nr_events[nsyscalls], i, j;
> >  	struct perf_evsel *evsels[nsyscalls], *evsel;
> >  	int sample_size = __perf_evsel__sample_size(attr.sample_type);
> > +	struct perf_mmap *md;
> >  
> >  	for (i = 0; i < nsyscalls; ++i) {
> >  		char name[64];
> > @@ -551,7 +553,9 @@ static int test__basic_mmap(void)
> >  			++foo;
> >  		}
> >  
> > -	while ((event = perf_evlist__mmap_read(evlist, 0)) != NULL) {
> > +	md = &evlist->mmap[0];
> > +
> > +	while ((event = perf_mmap__read(md)) != NULL) {
> >  		struct perf_sample sample;
> >  
> >  		if (event->header.type != PERF_RECORD_SAMPLE) {
> 
> Please keep perf_evlist__mmap_read() as just a wrapper for the above
> operation, that way you reduce the patch size by not touching the
> functions that use perf_evlist__mmap_read().
> 
> Later, if we think this is the right thing to do, i.e. to open code it
> like you're doing above, we can elliminate it, but I think its better to
> keep it as perf_evlist__mmap_read(evlist, 0) as it uses just one line
> instead of the 4 above :-)

right, I'll sent v2 shortly

> 
> > diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
> > index 8e02027..032f70d 100644
> > --- a/tools/perf/builtin-top.c
> > +++ b/tools/perf/builtin-top.c
> > @@ -38,6 +38,7 @@

SNIP

> >  void perf_evlist__munmap(struct perf_evlist *evlist)
> >  {
> >  	int i;
> >  
> >  	for (i = 0; i < evlist->nr_mmaps; i++) {
> > -		if (evlist->mmap[i].base != NULL) {
> > -			munmap(evlist->mmap[i].base, evlist->mmap_len);
> > -			evlist->mmap[i].base = NULL;
> > -		}
> > +		struct perf_mmap *m = &evlist->mmap[i];
> > +		if (m->base != NULL)
> > +			perf_mmap__close(m);
> 
> Wouldn't it be perf_mmap__munmap() ? 
> 
> >  	}
> >  
> >  	free(evlist->mmap);
> > @@ -292,20 +225,18 @@ int perf_evlist__alloc_mmap(struct perf_evlist *evlist)
> >  }
> >  
> >  static int __perf_evlist__mmap(struct perf_evlist *evlist,
> > -			       int idx, int prot, int mask, int fd)
> > +			       int idx, int fd)
> >  {
> > -	evlist->mmap[idx].prev = 0;
> > -	evlist->mmap[idx].mask = mask;
> > -	evlist->mmap[idx].base = mmap(NULL, evlist->mmap_len, prot,
> > -				      MAP_SHARED, fd, 0);
> > -	if (evlist->mmap[idx].base == MAP_FAILED)
> > +	struct perf_mmap *m = &evlist->mmap[idx];
> > +
> > +	if (perf_mmap__open(m, fd, evlist->overwrite, evlist->pages))
> 
> And here perf_mmap__mmap or at least perf_mmap__map and the other
> perf_mmap__unmap?

not sure, perf_mmap__open and perf_mmap__close actually does map/umap..
maybe we can rename them ;)

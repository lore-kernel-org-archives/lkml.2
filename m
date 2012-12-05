Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab2LESqf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 13:46:35 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:47430 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073Ab2LESqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 13:46:34 -0500
Date: Wed, 5 Dec 2012 15:46:27 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Miller <davem@davemloft.net>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix perf mmap limitations on 32-bit.
Message-ID: <20121205184627.GA6629@ghostprotocols.net>
References: <20121110.141219.582924082787523608.davem@davemloft.net>
 <20121205.133253.1408250042985203804.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121205.133253.1408250042985203804.davem@davemloft.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Dec 05, 2012 at 01:32:53PM -0500, David Miller escreveu:
> From: David Miller <davem@davemloft.net>
> Date: Sat, 10 Nov 2012 14:12:19 -0500 (EST)
> 
> 
> Ping?

Went to my perf/core branch:

http://git.kernel.org/?p=linux/kernel/git/acme/linux.git;a=shortlog;h=refs/heads/perf/core

http://git.kernel.org/?p=linux/kernel/git/acme/linux.git;a=commitdiff;h=69a8ae881d6448aab652756affc2bdaf2b223121

- Arnaldo
 
> > This is a suggested patch to fix the bug I reported at:
> > 
> > 	http://marc.info/?l=linux-kernel&m=135033028924652&w=2
> > 
> > Essentially, there is a hard requirement that when perf analyzes a
> > trace, it must have the entire thing mmap()'d.
> > 
> > Therefore the scheme used on 32-bit where we have a fixed (8) number
> > of 32MB mmaps, and cycle through them, simply does not work.
> > 
> > One of the reasons this requirement exists is because the iterators
> > maintain references to perf entry objects and those references don't
> > just simply go away when this mmap code decides to cycle an old mmap
> > area out and reuse it.  At this point, those entry pointers now point
> > to garbage resulting in unpredictable behavior and crashes.
> > 
> > It is better to try to mmap() as much as we can and if we do actually
> > run into address space limitations, the failure of the mmap() call
> > will indicate that and stop processing.
> > 
> > I noticed that perf_session->mmap_window is set to a constant in one
> > location, and only used in one other location.  So I got rid of it
> > altogether.
> > 
> > So we adjust the size of the mmaps[] array to the maximum we could
> > need.  On 64-bit we only need one slot.  On 32-bit we could need
> > up to 128 (128 * 32MB == 4GB).
> > 
> > I've verified that this allows a large (~600MB) perf.data file to
> > be analyzed properly with a 32-bit perf binary, which previously
> > was not possible.
> > 
> > Signed-off-by: David S. Miller <davem@davemloft.net>
> > 
> > diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
> > index 8cdd232..2cd3cc3 100644
> > --- a/tools/perf/util/session.c
> > +++ b/tools/perf/util/session.c
> > @@ -128,15 +128,6 @@ struct perf_session *perf_session__new(const char *filename, int mode,
> >  		goto out;
> >  
> >  	memcpy(self->filename, filename, len);
> > -	/*
> > -	 * On 64bit we can mmap the data file in one go. No need for tiny mmap
> > -	 * slices. On 32bit we use 32MB.
> > -	 */
> > -#if BITS_PER_LONG == 64
> > -	self->mmap_window = ULLONG_MAX;
> > -#else
> > -	self->mmap_window = 32 * 1024 * 1024ULL;
> > -#endif
> >  	self->machines = RB_ROOT;
> >  	self->repipe = repipe;
> >  	INIT_LIST_HEAD(&self->ordered_samples.samples);
> > @@ -1369,6 +1360,18 @@ fetch_mmaped_event(struct perf_session *session,
> >  	return event;
> >  }
> >  
> > +/*
> > + * On 64bit we can mmap the data file in one go. No need for tiny mmap
> > + * slices. On 32bit we use 32MB.
> > + */
> > +#if BITS_PER_LONG == 64
> > +#define MMAP_SIZE ULLONG_MAX
> > +#define NUM_MMAPS 1
> > +#else
> > +#define MMAP_SIZE (32 * 1024 * 1024ULL)
> > +#define NUM_MMAPS 128
> > +#endif
> > +
> >  int __perf_session__process_events(struct perf_session *session,
> >  				   u64 data_offset, u64 data_size,
> >  				   u64 file_size, struct perf_tool *tool)
> > @@ -1376,7 +1379,7 @@ int __perf_session__process_events(struct perf_session *session,
> >  	u64 head, page_offset, file_offset, file_pos, progress_next;
> >  	int err, mmap_prot, mmap_flags, map_idx = 0;
> >  	size_t	page_size, mmap_size;
> > -	char *buf, *mmaps[8];
> > +	char *buf, *mmaps[NUM_MMAPS];
> >  	union perf_event *event;
> >  	uint32_t size;
> >  
> > @@ -1393,7 +1396,7 @@ int __perf_session__process_events(struct perf_session *session,
> >  
> >  	progress_next = file_size / 16;
> >  
> > -	mmap_size = session->mmap_window;
> > +	mmap_size = MMAP_SIZE;
> >  	if (mmap_size > file_size)
> >  		mmap_size = file_size;
> >  
> > diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
> > index dd64261..903966b 100644
> > --- a/tools/perf/util/session.h
> > +++ b/tools/perf/util/session.h
> > @@ -29,7 +29,6 @@ struct ordered_samples {
> >  struct perf_session {
> >  	struct perf_header	header;
> >  	unsigned long		size;
> > -	unsigned long		mmap_window;
> >  	struct machine		host_machine;
> >  	struct rb_root		machines;
> >  	struct perf_evlist	*evlist;

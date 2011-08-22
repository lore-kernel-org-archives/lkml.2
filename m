Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949Ab1HVOLo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 10:11:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49780 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752667Ab1HVOLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 10:11:41 -0400
Date: Mon, 22 Aug 2011 11:11:30 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf map: Do not display load warning for maps without
	dso
Message-ID: <20110822141130.GA21345@ghostprotocols.net>
References: <1312980251-4945-1-git-send-email-jolsa@redhat.com> <20110822075322.GI2073@jolsa.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110822075322.GI2073@jolsa.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Aug 22, 2011 at 09:53:22AM +0200, Jiri Olsa escreveu:
> hi,
> any feedback on this?

Fell thru the cracks, sorry.
 
> On Wed, Aug 10, 2011 at 02:44:11PM +0200, Jiri Olsa wrote:
> > I get unnecessary warnings from map__load about "[stack]" maps,
> > saying dso cannot be loaded.

> > Attached patch avoids this warning for maps that are not backed-up
> > by dso.

> > I was wondering if we want to treat stack/heaps/vdso maps the same
> > way or if there's something special about vdso in this regard.
> > Because there could be another fix with setting all stack/heaps/vdso
> > maps as loaded, which is probably little more nicer.

Humm, in the vdso case we have a fallback in thread__find_addr_map, i.e.
its symbol rbtree is empty, we notice that and lookup the symbol in the
kernel symbol tables (vmlinux and modules).

I.e. stack/heap symbols would not apply, this fallback wouldn't happen,
the symbol would be unresolved, the patch then would be just to
map__new, as:

diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index a16ecab..0c1c11b 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -63,7 +63,9 @@ set_identity:
 		} else if (strcmp(filename, "[vdso]") == 0) {
 			dso__set_loaded(dso, self->type);
 			goto set_identity;
-		}
+		} else if (strcmp(filename, "[heap]") == 0 ||
+			   strcmp(filename, "[stack]") == 0)
+			dso__set_loaded(dso, self->type);
 	}
 	return self;
 out_delete:

Right?

- Arnaldo

> > ---
> > When report command proceses adress hits, it tries to resolve
> > them in to the symbol names. This is not possible for stack
> > and heap memory maps, because they are not backed-up by any
> > binary or dso.
> > 
> > This patch avoids the warning "Failed to open..." inside the
> > map__load function for stack and heap maps.
> > 
> > Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> > ---
> >  tools/perf/util/map.c |   15 +++++++++++++++
> >  1 files changed, 15 insertions(+), 0 deletions(-)
> > 
> > diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
> > index a16ecab..ac5fb40 100644
> > --- a/tools/perf/util/map.c
> > +++ b/tools/perf/util/map.c
> > @@ -18,6 +18,14 @@ static inline int is_anon_memory(const char *filename)
> >  	return strcmp(filename, "//anon") == 0;
> >  }
> >  
> > +static inline int is_no_dso_memory(struct map *self)
> > +{
> > +	const char *name = self->dso->long_name;
> > +
> > +	return (!strcmp(name, "[stack]") ||
> > +		!strcmp(name, "[heap]"));
> > +}
> > +
> >  void map__init(struct map *self, enum map_type type,
> >  	       u64 start, u64 end, u64 pgoff, struct dso *dso)
> >  {
> > @@ -108,6 +116,13 @@ int map__load(struct map *self, symbol_filter_t filter)
> >  
> >  	nr = dso__load(self->dso, self, filter);
> >  	if (nr < 0) {
> > +		/*
> > +		 * Do not print warning for maps that cannot
> > +		 * be loaded anyway.
> > +		 */
> > +		if (is_no_dso_memory(self))
> > +			return -1;
> > +
> >  		if (self->dso->has_build_id) {
> >  			char sbuild_id[BUILD_ID_SIZE * 2 + 1];

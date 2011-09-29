Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178Ab1I2QLo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 12:11:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17670 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036Ab1I2QLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 12:11:43 -0400
Date: Thu, 29 Sep 2011 18:11:03 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf, tool: Treat all memory maps without dso file as
 loaded
Message-ID: <20110929161103.GB8950@jolsa.brq.redhat.com>
References: <1312980251-4945-1-git-send-email-jolsa@redhat.com>
 <20110822075322.GI2073@jolsa.brq.redhat.com>
 <20110822141130.GA21345@ghostprotocols.net>
 <20110822145849.GB8694@jolsa.brq.redhat.com>
 <20110824131834.GA2007@jolsa.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110824131834.GA2007@jolsa.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 03:18:34PM +0200, Jiri Olsa wrote:
> On Mon, Aug 22, 2011 at 04:58:49PM +0200, Jiri Olsa wrote:
> > On Mon, Aug 22, 2011 at 11:11:30AM -0300, Arnaldo Carvalho de Melo wrote:
> > > Em Mon, Aug 22, 2011 at 09:53:22AM +0200, Jiri Olsa escreveu:
> > > > hi,
> > > > any feedback on this?
> > > 
> > > Fell thru the cracks, sorry.
> > >  
> > > > On Wed, Aug 10, 2011 at 02:44:11PM +0200, Jiri Olsa wrote:
> > > > > I get unnecessary warnings from map__load about "[stack]" maps,
> > > > > saying dso cannot be loaded.
> > > 
> > > > > Attached patch avoids this warning for maps that are not backed-up
> > > > > by dso.
> > > 
> > > > > I was wondering if we want to treat stack/heaps/vdso maps the same
> > > > > way or if there's something special about vdso in this regard.
> > > > > Because there could be another fix with setting all stack/heaps/vdso
> > > > > maps as loaded, which is probably little more nicer.
> > > 
> > > Humm, in the vdso case we have a fallback in thread__find_addr_map, i.e.
> > > its symbol rbtree is empty, we notice that and lookup the symbol in the
> > > kernel symbol tables (vmlinux and modules).
> > > 
> > > I.e. stack/heap symbols would not apply, this fallback wouldn't happen,
> > > the symbol would be unresolved, the patch then would be just to
> > > map__new, as:
> > > 
> > > diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
> > > index a16ecab..0c1c11b 100644
> > > --- a/tools/perf/util/map.c
> > > +++ b/tools/perf/util/map.c
> > > @@ -63,7 +63,9 @@ set_identity:
> > >  		} else if (strcmp(filename, "[vdso]") == 0) {
> > >  			dso__set_loaded(dso, self->type);
> > >  			goto set_identity;
> > > -		}
> > > +		} else if (strcmp(filename, "[heap]") == 0 ||
> > > +			   strcmp(filename, "[stack]") == 0)
> > > +			dso__set_loaded(dso, self->type);
> > >  	}
> > >  	return self;
> > >  out_delete:
> > > 
> > > Right?
> > 
> > yes, I was not completely sure I was not breaking anything else,
> > so I posted the first patch.. the original patch I had is attached.
> > 
> > I haven't tested this one much though.. let me know and
> > I can resend this one with changelog/testing..
> 
> and here it is ;)

hi,
any feedback?

thanks,
jirka






> 
> thanks,
> jirka
> 
> ---
> The stack/vdso/heap memory maps dont have any dso file.
> Setting the perf dso objects as 'loaded' for these maps,
> we avoid unnecessary warnings like:
> 
>   "Failed to open [stack], continuing without symbols"
> 
> All map__find_* functions still return NULL when searching
> for symbols in these maps.
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> ---
>  tools/perf/util/map.c |   24 ++++++++++++++++++------
>  1 files changed, 18 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
> index a16ecab..7e218e3 100644
> --- a/tools/perf/util/map.c
> +++ b/tools/perf/util/map.c
> @@ -18,6 +18,13 @@ static inline int is_anon_memory(const char *filename)
>  	return strcmp(filename, "//anon") == 0;
>  }
>  
> +static inline int is_no_dso_memory(const char *filename)
> +{
> +	return !strcmp(filename, "[stack]") ||
> +	       !strcmp(filename, "[vdso]")  ||
> +	       !strcmp(filename, "[heap]");
> +}
> +
>  void map__init(struct map *self, enum map_type type,
>  	       u64 start, u64 end, u64 pgoff, struct dso *dso)
>  {
> @@ -42,9 +49,10 @@ struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
>  	if (self != NULL) {
>  		char newfilename[PATH_MAX];
>  		struct dso *dso;
> -		int anon;
> +		int anon, no_dso;
>  
>  		anon = is_anon_memory(filename);
> +		no_dso = is_no_dso_memory(filename);
>  
>  		if (anon) {
>  			snprintf(newfilename, sizeof(newfilename), "/tmp/perf-%d.map", pid);
> @@ -57,12 +65,16 @@ struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
>  
>  		map__init(self, type, start, start + len, pgoff, dso);
>  
> -		if (anon) {
> -set_identity:
> +		if (anon || no_dso) {
>  			self->map_ip = self->unmap_ip = identity__map_ip;
> -		} else if (strcmp(filename, "[vdso]") == 0) {
> -			dso__set_loaded(dso, self->type);
> -			goto set_identity;
> +
> +			/*
> +			 * Set memory without DSO as loaded. All map__find_*
> +			 * functions still return NULL, and we avoid the
> +			 * unnecessary map__load warning.
> +			 */
> +			if (no_dso)
> +				dso__set_loaded(dso, self->type);
>  		}
>  	}
>  	return self;
> -- 
> 1.7.4
> 

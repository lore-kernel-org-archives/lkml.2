Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798Ab1HVHxq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 03:53:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57269 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752057Ab1HVHxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 03:53:38 -0400
Date: Mon, 22 Aug 2011 09:53:22 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf map: Do not display load warning for maps without
 dso
Message-ID: <20110822075322.GI2073@jolsa.brq.redhat.com>
References: <1312980251-4945-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312980251-4945-1-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
any feedback on this?

thanks,
jirka

On Wed, Aug 10, 2011 at 02:44:11PM +0200, Jiri Olsa wrote:
> hi,
> I get unnecessary warnings from map__load about "[stack]" maps,
> saying dso cannot be loaded.
> 
> Attached patch avoids this warning for maps that are
> not backed-up by dso.
> 
> I was wondering if we want to treat stack/heaps/vdso maps
> the same way or if there's something special about vdso
> in this regard. Because there could be another fix with
> setting all stack/heaps/vdso maps as loaded, which
> is probably little more nicer.
> 
> thanks,
> jirka
> 
> ---
> When report command proceses adress hits, it tries to resolve
> them in to the symbol names. This is not possible for stack
> and heap memory maps, because they are not backed-up by any
> binary or dso.
> 
> This patch avoids the warning "Failed to open..." inside the
> map__load function for stack and heap maps.
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> ---
>  tools/perf/util/map.c |   15 +++++++++++++++
>  1 files changed, 15 insertions(+), 0 deletions(-)
> 
> diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
> index a16ecab..ac5fb40 100644
> --- a/tools/perf/util/map.c
> +++ b/tools/perf/util/map.c
> @@ -18,6 +18,14 @@ static inline int is_anon_memory(const char *filename)
>  	return strcmp(filename, "//anon") == 0;
>  }
>  
> +static inline int is_no_dso_memory(struct map *self)
> +{
> +	const char *name = self->dso->long_name;
> +
> +	return (!strcmp(name, "[stack]") ||
> +		!strcmp(name, "[heap]"));
> +}
> +
>  void map__init(struct map *self, enum map_type type,
>  	       u64 start, u64 end, u64 pgoff, struct dso *dso)
>  {
> @@ -108,6 +116,13 @@ int map__load(struct map *self, symbol_filter_t filter)
>  
>  	nr = dso__load(self->dso, self, filter);
>  	if (nr < 0) {
> +		/*
> +		 * Do not print warning for maps that cannot
> +		 * be loaded anyway.
> +		 */
> +		if (is_no_dso_memory(self))
> +			return -1;
> +
>  		if (self->dso->has_build_id) {
>  			char sbuild_id[BUILD_ID_SIZE * 2 + 1];
>  
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

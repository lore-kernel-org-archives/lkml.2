Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab1LSPdm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 10:33:42 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47209 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054Ab1LSPdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 10:33:41 -0500
From: Namhyung Kim <namhyung@gmail.com>
To: Nelson Elhage <nelhage@nelhage.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] perf: __perf_evlist__mmap: Fix errno value on failed map.
References: <1324301972-22740-1-git-send-email-nelhage@nelhage.com>
	<1324301972-22740-2-git-send-email-nelhage@nelhage.com>
Date: Tue, 20 Dec 2011 00:33:30 +0900
In-Reply-To: <1324301972-22740-2-git-send-email-nelhage@nelhage.com> (Nelson
	Elhage's message of "Mon, 19 Dec 2011 08:39:30 -0500")
Message-ID: <87k45sr2yd.fsf@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Nelson

Nelson Elhage <nelhage@nelhage.com> writes:
> On failure, perf_evlist__mmap_per_{cpu,thread} will try to munmap()
> every map that doesn't have a NULL base. This will fail with EINVAL if
> one of them has base == MAP_FAILED, clobbering errno, so that
> perf_evlist__map will return EINVAL on any failure regardless of the
> root cause.
>
> Fix this by resetting failed maps to a NULL base.
>
> Signed-off-by: Nelson Elhage <nelhage@nelhage.com>
> ---
>  tools/perf/util/evlist.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
> index fbb4b4a..271c849 100644
> --- a/tools/perf/util/evlist.c
> +++ b/tools/perf/util/evlist.c
> @@ -298,8 +298,10 @@ static int __perf_evlist__mmap(struct perf_evlist *evlist,
>  	evlist->mmap[idx].mask = mask;
>  	evlist->mmap[idx].base = mmap(NULL, evlist->mmap_len, prot,
>  				      MAP_SHARED, fd, 0);
> -	if (evlist->mmap[idx].base == MAP_FAILED)
> +	if (evlist->mmap[idx].base == MAP_FAILED) {
> +		evlist->mmap[idx].base = NULL;
>  		return -1;
> +	}
>  
>  	perf_evlist__add_pollfd(evlist, fd);
>  	return 0;

Thanks for fixing this. I posted a basically same patch for this [1]
last week, but it seems my patch doesn't get included yet (right?),
and your patch looks bit simpler. So Arnaldo, I'm totally fine if you
decide to take this instead of mine.

Thanks.
Namhyung Kim


[1] https://lkml.org/lkml/2011/12/12/275

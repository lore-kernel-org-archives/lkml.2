Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab2GWSLZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 14:11:25 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:53284 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968Ab2GWSLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 14:11:24 -0400
Date: Mon, 23 Jul 2012 20:11:17 +0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 06/11] perf kvm: limit repetitive guestmount message to
 once per directory
Message-ID: <20120723181117.GB6717@infradead.org>
References: <1342826756-64663-1-git-send-email-dsahern@gmail.com>
 <1342826756-64663-7-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342826756-64663-7-git-send-email-dsahern@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jul 20, 2012 at 05:25:51PM -0600, David Ahern escreveu:
> After 7ed97ad use of the guestmount option without a subdir for *each*
> VM generates an error message for each sample related to that VM. Once
> per VM is enough.
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> ---
>  tools/perf/util/map.c |   11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
> index 16d783d..cc33486 100644
> --- a/tools/perf/util/map.c
> +++ b/tools/perf/util/map.c
> @@ -8,6 +8,7 @@
>  #include <unistd.h>
>  #include "map.h"
>  #include "thread.h"
> +#include "strlist.h"
>  
>  const char *map_type__name[MAP__NR_TYPES] = {
>  	[MAP__FUNCTION] = "Functions",
> @@ -695,7 +696,15 @@ struct machine *machines__findnew(struct rb_root *self, pid_t pid)
>  	    (symbol_conf.guestmount)) {
>  		sprintf(path, "%s/%d", symbol_conf.guestmount, pid);
>  		if (access(path, R_OK)) {
> -			pr_err("Can't access file %s\n", path);
> +			static struct strlist *seen;
> +
> +			if (!seen)
> +				seen = strlist__new(true, NULL);
> +
> +			if (!strlist__has_entry(seen, path)) {
> +				pr_err("Can't access file %s\n", path);
> +				strlist__add(seen, path);
> +			}

At some point we'll need to have __exit functions in userland perf so
that we can delete this when using mem leak detectors :-\ Applying
anyway.

- Arnaldo

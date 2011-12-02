Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157Ab1LBGF1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 01:05:27 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62034 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab1LBGF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 01:05:26 -0500
Message-ID: <4ED86AA1.7070506@gmail.com>
Date: Thu, 01 Dec 2011 23:05:21 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: linux-kernel@vger.kernel.org, acme@infradead.org, peterz@infradead.org,
        mingo@elte.hu, fweisbec@gmail.com
Subject: Re: [PATCH] perf: fix handling of .debug cache for kernel symbols
References: <20111202044825.GA21751@quad>
In-Reply-To: <20111202044825.GA21751@quad>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/01/2011 09:48 PM, Stephane Eranian wrote:
> There was a bug in the way perf was looking for
> kernel symbols when the .debug cache was not in $HOME.

By chance have you encountered problems with annotate in this scenario?
 i.e., remote analysis with a copy of /proc/kallsyms from the target and
using the --vmlinux argument.

For example, 'perf report --kallsyms kallsyms --vmlinux vmlinux ...' and
then attempting to use the annotate option? I have a hit a few issues
with this path - and kernel modules with a symfs path -- that I have not
had time to debug yet.

David


> 
> With the /etc/perfconfig or $HOME/.perfconfig files, it
> is possible to use an alternate location for the .debug
> buildid + binary cache.
> 
> The problem is that the alternate location was ignored
> for kernel symbols, leading to partial profiles in case
> the host kernel was  not the one used to collect the profile,
> e.g., with remote profiling.
> 
> This patch fixes the problem by adding the buildi_dir prefix
> to the lookup path used in dso__load_kernel_sym().
> 
> The change to util.h is necessary to avoid a redefinition
> of _GNU_SOURCE.
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>
> ---
> 
> diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
> index 632b50c..8ace954 100644
> --- a/tools/perf/util/symbol.c
> +++ b/tools/perf/util/symbol.c
> @@ -16,6 +16,7 @@
>  #include "debug.h"
>  #include "symbol.h"
>  #include "strlist.h"
> +#include "util.h"
>  
>  #include <libelf.h>
>  #include <gelf.h>
> @@ -2082,8 +2083,8 @@ static int dso__load_kernel_sym(struct dso *dso, struct map *map,
>  				  sbuild_id);
>  
>  		if (asprintf(&kallsyms_allocated_filename,
> -			     "%s/.debug/[kernel.kallsyms]/%s",
> -			     getenv("HOME"), sbuild_id) == -1) {
> +			     "%s/[kernel.kallsyms]/%s",
> +			     buildid_dir, sbuild_id) == -1) {
>  			pr_err("Not enough memory for kallsyms file lookup\n");
>  			return -1;
>  		}
> diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
> index 0128906..4b90e93 100644
> --- a/tools/perf/util/util.h
> +++ b/tools/perf/util/util.h
> @@ -40,7 +40,9 @@
>  #define decimal_length(x)	((int)(sizeof(x) * 2.56 + 0.5) + 1)
>  
>  #define _ALL_SOURCE 1
> +#ifndef _GNU_SOURCE
>  #define _GNU_SOURCE 1
> +#endif
>  #define _BSD_SOURCE 1
>  #define HAS_BOOL
>  

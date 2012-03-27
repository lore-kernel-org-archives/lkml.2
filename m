Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab2C0OPa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 10:15:30 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36008 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab2C0OP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 10:15:27 -0400
Date: Tue, 27 Mar 2012 11:15:24 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Miller <davem@davemloft.net>
Cc: Ingo Molnar <mingo@kernel.org>, Stephane Eranian <eranian@google.com>,
        Sorin Dumitru <dumitru.sorin87@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] perf: Validate address in symbol__inc_addr_samples().
Message-ID: <20120327141523.GA6931@infradead.org>
References: <20120325.162808.1311176271259118121.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120325.162808.1311176271259118121.davem@davemloft.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, Mar 25, 2012 at 04:28:08PM -0400, David Miller escreveu:
> If addr < sym->start then we are going to access past the end of the
> h->addr[] array, since the offset calculated will be huge.
> 
> Trigger an assertion instead of randomly scribbling memory when this
> situation occurs.

I'm applying this one instead, please check if you have any concerns
with this approach:

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index e5a462f..21c7590 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -64,8 +64,8 @@ int symbol__inc_addr_samples(struct symbol *sym,
struct map *map,
 
        pr_debug3("%s: addr=%#" PRIx64 "\n", __func__,
map->unmap_ip(map, addr));
 
-       if (addr >= sym->end)
-               return 0;
+       if (addr < sym->start || addr >= sym->end)
+               return -ERANGE;
 
        offset = addr - sym->start;
        h = annotation__histogram(notes, evidx);

And will make 'top' check the result, as 'report' already does, but
telling the user that there is a bug that should be reported to lkml,
using a WARN_ON_ONCE like method, telling the map, dso and symbol names.

This code already checked if the addr was after the end, but was
silently dropping samples in this case, oops.

So do a range check and return -ERANGE, so that tools can use their UI
specific way of telling the user that some samples are being dropped,
but don't panic and stop the tool.

I'll add Reported-by for Stephane and others that also reported this in
the past.


- Arnaldo
 
> Signed-off-by: David S. Miller <davem@davemloft.net>
> ---
>  tools/perf/util/annotate.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
> index e5a462f..734a503 100644
> --- a/tools/perf/util/annotate.c
> +++ b/tools/perf/util/annotate.c
> @@ -15,6 +15,7 @@
>  #include "debug.h"
>  #include "annotate.h"
>  #include <pthread.h>
> +#include <assert.h>
>  
>  const char 	*disassembler_style;
>  
> @@ -64,6 +65,7 @@ int symbol__inc_addr_samples(struct symbol *sym, struct map *map,
>  
>  	pr_debug3("%s: addr=%#" PRIx64 "\n", __func__, map->unmap_ip(map, addr));
>  
> +	assert(addr >= sym->start);
>  	if (addr >= sym->end)
>  		return 0;
>  
> -- 
> 1.7.9.1

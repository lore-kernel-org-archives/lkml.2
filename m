Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345Ab2K1Px3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 10:53:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24632 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932134Ab2K1PxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 10:53:24 -0500
Date: Wed, 28 Nov 2012 16:53:13 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        eranian@google.com, mingo@kernel.org, namhyung@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 31/32] perf, tools: Default to cpu// for events v3
Message-ID: <20121128155313.GF1038@krava.brq.redhat.com>
References: <1352510868-7911-1-git-send-email-andi@firstfloor.org>
 <1352510868-7911-32-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352510868-7911-32-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 09, 2012 at 05:27:47PM -0800, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> When an event fails to parse and it's not in a new style format,
> try to parse it again as a cpu event.
> 
> This allows to use sysfs exported events directly without //, so I can use
> 
> perf record -e tx-aborts ...
> 
> instead of
> 
> perf record -e cpu/tx-aborts/
> 
> v2: Handle multiple events
> v3: Move to separate function
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  tools/perf/util/parse-events.c |   45 +++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 44 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
> index 5b97a2b..70cbd1c 100644
> --- a/tools/perf/util/parse-events.c
> +++ b/tools/perf/util/parse-events.c
> @@ -768,6 +768,47 @@ int parse_events_name(struct list_head *list, char *name)
>  	return 0;
>  }
>  
> +static void str_append(char **s, int *len, const char *a)
> +{
> +	int olen = *s ? strlen(*s) : 0;
> +	int nlen = olen + strlen(a) + 1;
> +	if (*len < nlen) {
> +		*len = *len * 2;
> +		if (*len < nlen)
> +			*len = nlen;
> +		*s = realloc(*s, *len);
> +		if (!*s)
> +			exit(ENOMEM);

Rather use BUG_ON or event better return -ENOMEM.

> +		if (olen == 0)
> +			**s = 0;
> +	}
> +	strcat(*s, a);
> +}

Could this one be moved to util/string.c in some generic form?

thanks,
jirka

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933227Ab2J0UQs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 16:16:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46342 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933171Ab2J0UQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 16:16:47 -0400
Date: Sat, 27 Oct 2012 22:16:26 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        eranian@google.com, mingo@kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 32/33] perf, tools: Default to cpu// for events v2
Message-ID: <20121027201626.GE1039@krava.redhat.com>
References: <1351283415-13170-1-git-send-email-andi@firstfloor.org>
 <1351283415-13170-33-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351283415-13170-33-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 01:30:14PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> When an event fails to parse and it's not in a new style format,
> try to parse it again as a cpu event.
> 
> This allows to use sysfs exported events directly without //, so I can use
> 
> perf record -e tx-aborts ...

hum, seems usefull and hacky ;)

would not work for modifier stuff like:

  tx-aborts:u (not sure if 'u' makes sense for 'tx-aborts'..)

but nevermind, seems like usefull shortcut

> 
> instead of
> 
> perf record -e cpu/tx-aborts/
> 
> v2: Handle multiple events
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  tools/perf/util/parse-events.c |   37 +++++++++++++++++++++++++++++++++++++
>  1 files changed, 37 insertions(+), 0 deletions(-)
> 
> diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
> index f800765..ee6a73c 100644
> --- a/tools/perf/util/parse-events.c
> +++ b/tools/perf/util/parse-events.c
> @@ -768,6 +768,23 @@ int parse_events_name(struct list_head *list, char *name)
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

trailing whitespace

> +			exit(ENOMEM);
> +		if (olen == 0)
> +			**s = 0;
> +	}
> +	strcat(*s, a);
> +}
> +
>  static int parse_events__scanner(const char *str, void *data, int start_token)
>  {
>  	YY_BUFFER_STATE buffer;
> @@ -788,6 +805,26 @@ static int parse_events__scanner(const char *str, void *data, int start_token)
>  	parse_events__flush_buffer(buffer, scanner);
>  	parse_events__delete_buffer(buffer, scanner);
>  	parse_events_lex_destroy(scanner);
> +
> +	if (ret && !strchr(str, '/')) {
> +		char *o = strdup(str);
> +		char *s = NULL;
> +		char *t = o;
> +		char *p;
> +		int len = 0;
> +
> +		if (!o)
> +			return ret;
> +		while ((p = strsep(&t, ",")) != NULL) {
> +			if (s)
> +				str_append(&s, &len, ",");
> +			str_append(&s, &len, "cpu/");
> +			str_append(&s, &len, p);
> +			str_append(&s, &len, "/");
> +		}
> +		free(o);
> +		ret = parse_events__scanner(s, data, start_token);

any chance above could be in separated function?

> +	}
>  	return ret;
>  }
>  
> -- 
> 1.7.7.6
> 

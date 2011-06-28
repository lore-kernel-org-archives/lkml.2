Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab1F1OuW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 10:50:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50940 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757113Ab1F1OsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 10:48:16 -0400
Date: Tue, 28 Jun 2011 10:48:08 -0400
From: Jason Baron <jbaron@redhat.com>
To: Jim Cromie <jim.cromie@gmail.com>
Cc: linux-kernel@vger.kernel.org, gnb@fmeh.org, bvanassche@acm.org,
        gregkh@suse.de
Subject: Re: [PATCH 09/11] dynamic_debug: add_to_pending() saves non-matching
 queries for later.
Message-ID: <20110628144808.GC2472@redhat.com>
References: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
 <1309244992-2305-10-git-send-email-jim.cromie@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309244992-2305-10-git-send-email-jim.cromie@gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jim,

A number of ppl have expressed interest to me in this functionality...

I'm wondering if we should call out this usage explicitly with a new
flag like '+a'. Meaning 'add' as a pending query if it doesn't match
anything existing.

In this way, we can have error when things don't match in the normal case.
Otherwise, somebody might think they've enabled something when they've in fact
added a pending query.

Otherwise, it looks pretty good.

thanks,

-Jason


On Tue, Jun 28, 2011 at 01:09:50AM -0600, Jim Cromie wrote:
> When a query/rule doesnt match, call add_to_pending(new function)
> to copy the query off the stack, into a (new) struct pending_query,
> and add to pending_queries (new) list.
> 
> Patch adds: /sys/module/dynamic_debug/parameters/
>   verbose - rw, added previously, here for completeness
>   pending_ct - ro, shows current count of pending queries
>   pending_max - rw, set max pending, further pending queries are rejected
> 
> With this and previous patches, queries added on the boot-line which
> do not match (because module is not built-in, and thus not present yet)
> are added to pending_queries.
> 
> IE, with these boot-line additions:
>  dynamic_debug.verbose=1 ddebug_query="module scx200_hrt +p"
> 
> Kernel will log the following:
> 
> ddebug_exec_queries: query 0: "module scx200_hrt +p"
> ddebug_tokenize: split into words: "module" "scx200_hrt" "+p"
> ddebug_parse_query: parsed q->function="(null)" q->filename="(null)" q->module="scx200_hrt" q->format="(null)" q->lineno=0-0
> ddebug_parse_flags: op='+'
> ddebug_parse_flags: flags=0x1
> ddebug_parse_flags: *flagsp=0x1 *maskp=0xffffffff
> ddebug_exec_query: nfound 0 on q->function="(null)" q->filename="(null)" q->module="scx200_hrt" q->format="(null)" q->lineno=0-0
> ddebug_add_to_pending: add to pending: q->function="(null)" q->filename="(null)" q->module="scx200_hrt" q->format="(null)" q->lineno=0-0
> ddebug_add_to_pending: ddebug: query saved as pending 1
> 
> Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
> ---
>  lib/dynamic_debug.c |   78 +++++++++++++++++++++++++++++++++++++++++++++++----
>  1 files changed, 72 insertions(+), 6 deletions(-)
> 
> diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
> index 9b8b1e8..37d0275 100644
> --- a/lib/dynamic_debug.c
> +++ b/lib/dynamic_debug.c
> @@ -53,6 +53,16 @@ struct ddebug_query {
>  	unsigned int first_lineno, last_lineno;
>  };
>  
> +struct pending_query {
> +	struct list_head link;
> +	struct ddebug_query query;
> +	char filename[100];
> +	char module[30];
> +	char function[50];
> +	char format[200];
> +	unsigned int flags, mask;
> +};
> +
>  struct ddebug_iter {
>  	struct ddebug_table *table;
>  	unsigned int idx;
> @@ -61,7 +71,13 @@ struct ddebug_iter {
>  static DEFINE_MUTEX(ddebug_lock);
>  static LIST_HEAD(ddebug_tables);
>  static int verbose = 0;
> -module_param(verbose, int, 0744);
> +module_param(verbose, int, 0644);
> +
> +/* legal but inapplicable queries, save and test against new modules */
> +static LIST_HEAD(pending_queries);
> +static int pending_ct, pending_max = 100;
> +module_param(pending_ct, int, 0444);
> +module_param(pending_max, int, 0644);
>  
>  /* Return the last part of a pathname */
>  static inline const char *basename(const char *path)
> @@ -96,6 +112,56 @@ static char *ddebug_describe_flags(struct _ddebug *dp, char *buf,
>  	return buf;
>  }
>  
> +static char prbuf_query[300];
> +
> +static char *show_ddebug_query(const struct ddebug_query *q)
> +{
> +        sprintf(prbuf_query,
> +		"q->function=\"%s\" q->filename=\"%s\" "
> +		"q->module=\"%s\" q->format=\"%s\" q->lineno=%u-%u",
> +		q->function, q->filename, q->module, q->format,
> +		q->first_lineno, q->last_lineno);
> +
> +	return prbuf_query;
> +}
> +
> +/* copy query off stack, save flags & mask, and store in pending-list */
> +static void add_to_pending(const struct ddebug_query *query,
> +			   unsigned int flags, unsigned int mask)
> +{
> +	struct pending_query *pq;
> +
> +	if (pending_ct >= pending_max) {
> +		pr_warn("ddebug: no matches for query, pending is full\n");
> +		return;
> +	}
> +	if (verbose)
> +		pr_info("add to pending: %s\n", show_ddebug_query(query));
> +
> +	pending_ct++;
> +	pq = kzalloc(sizeof(struct pending_query), GFP_KERNEL);
> +
> +	/* copy non-null match-specs into allocd mem, update pointers */
> +	if (query->module)
> +		pq->query.module = strcpy(pq->module, query->module);
> +	if (query->function)
> +		pq->query.function = strcpy(pq->function, query->function);
> +	if (query->filename)
> +		pq->query.filename = strcpy(pq->filename, query->filename);
> +	if (query->format)
> +		pq->query.format = strcpy(pq->format, query->format);
> +
> +	pq->flags = flags;
> +	pq->mask = mask;
> +
> +	mutex_lock(&ddebug_lock);
> +	list_add(&pq->link, &pending_queries);
> +	mutex_unlock(&ddebug_lock);
> +
> +	if (verbose)
> +		pr_info("ddebug: query saved as pending %d\n", pending_ct);
> +}
> +
>  /*
>   * Search the tables for _ddebug's which match the given
>   * `query' and apply the `flags' and `mask' to them.  Tells
> @@ -348,11 +414,7 @@ static int ddebug_parse_query(char *words[], int nwords,
>  	}
>  
>  	if (verbose)
> -		pr_info("q->function=\"%s\" q->filename=\"%s\" "
> -		       "q->module=\"%s\" q->format=\"%s\" q->lineno=%u-%u\n",
> -			query->function, query->filename,
> -			query->module, query->format, query->first_lineno,
> -			query->last_lineno);
> +		pr_info("parsed %s\n", show_ddebug_query(query));
>  
>  	return 0;
>  }
> @@ -437,6 +499,10 @@ static int ddebug_exec_query(char *query_string)
>  	/* actually go and implement the change */
>  	nfound = ddebug_change(&query, flags, mask);
>  
> +	pr_info("nfound %d on %s\n", nfound, show_ddebug_query(&query));
> +	if (!nfound)
> +		ddebug_add_to_pending(&query, flags, mask);
> +
>  	return 0;
>  }
>  
> -- 
> 1.7.4.1
> 

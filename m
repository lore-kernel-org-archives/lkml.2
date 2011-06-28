Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065Ab1F1TSY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 15:18:24 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:33934 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab1F1TSS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 15:18:18 -0400
MIME-Version: 1.0
In-Reply-To: <1309244992-2305-10-git-send-email-jim.cromie@gmail.com>
References: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com> <1309244992-2305-10-git-send-email-jim.cromie@gmail.com>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Tue, 28 Jun 2011 13:17:48 -0600
Message-ID: <BANLkTinwwaD=O2nFEN8G+U2eWBPMUM9Ovg@mail.gmail.com>
Subject: Re: [PATCH 09/11] dynamic_debug: add_to_pending() saves non-matching
 queries for later.
To: linux-kernel@vger.kernel.org
Cc: gnb@fmeh.org, jbaron@redhat.com, bvanassche@acm.org, gregkh@suse.de,
        Jim Cromie <jim.cromie@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 1:09 AM, Jim Cromie <jim.cromie@gmail.com> wrote:
> When a query/rule doesnt match, call add_to_pending(new function)
> to copy the query off the stack, into a (new) struct pending_query,
> and add to pending_queries (new) list.
>
> Patch adds: /sys/module/dynamic_debug/parameters/
>  verbose - rw, added previously, here for completeness
>  pending_ct - ro, shows current count of pending queries
>  pending_max - rw, set max pending, further pending queries are rejected
>
> With this and previous patches, queries added on the boot-line which
> do not match (because module is not built-in, and thus not present yet)
> are added to pending_queries.
>
> IE, with these boot-line additions:
>  dynamic_debug.verbose=1 ddebug_query="module scx200_hrt +p"
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
>  lib/dynamic_debug.c |   78 +++++++++++++++++++++++++++++++++++++++++++++++----
>  1 files changed, 72 insertions(+), 6 deletions(-)
>
> diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
> index 9b8b1e8..37d0275 100644
> --- a/lib/dynamic_debug.c
> +++ b/lib/dynamic_debug.c
> @@ -53,6 +53,16 @@ struct ddebug_query {
>        unsigned int first_lineno, last_lineno;
>  };
>
> +struct pending_query {
> +       struct list_head link;
> +       struct ddebug_query query;
> +       char filename[100];
> +       char module[30];
> +       char function[50];
> +       char format[200];
> +       unsigned int flags, mask;
> +};
> +
>  struct ddebug_iter {
>        struct ddebug_table *table;
>        unsigned int idx;
> @@ -61,7 +71,13 @@ struct ddebug_iter {
>  static DEFINE_MUTEX(ddebug_lock);
>  static LIST_HEAD(ddebug_tables);
>  static int verbose = 0;
> -module_param(verbose, int, 0744);
> +module_param(verbose, int, 0644);
> +
> +/* legal but inapplicable queries, save and test against new modules */
> +static LIST_HEAD(pending_queries);
> +static int pending_ct, pending_max = 100;
> +module_param(pending_ct, int, 0444);
> +module_param(pending_max, int, 0644);
>
>  /* Return the last part of a pathname */
>  static inline const char *basename(const char *path)
> @@ -96,6 +112,56 @@ static char *ddebug_describe_flags(struct _ddebug *dp, char *buf,
>        return buf;
>  }
>
> +static char prbuf_query[300];
> +
> +static char *show_ddebug_query(const struct ddebug_query *q)
> +{


this part (the static fixed-length var)
gives me some heartburn.

I almost went with macros using pr_info to replace the
 2 show_*_query fns, but a <debugfs/dynamic_debug/pending file
might want to use show_pending_query

advice ?

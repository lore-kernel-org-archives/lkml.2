Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758266Ab1GKSgs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 14:36:48 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:50037 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758099Ab1GKSgr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 14:36:47 -0400
MIME-Version: 1.0
In-Reply-To: <1310370416-6322-9-git-send-email-jim.cromie@gmail.com>
References: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
 <1310370416-6322-1-git-send-email-jim.cromie@gmail.com> <1310370416-6322-9-git-send-email-jim.cromie@gmail.com>
From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 11 Jul 2011 20:36:27 +0200
X-Google-Sender-Auth: 2ITd9An3zPdn2kNZ3b0G7gH0jU8
Message-ID: <CAO+b5-piFe5mEPf82Mm8gmiqX2SiPTOVpNDY-3C22PNA6MxXsg@mail.gmail.com>
Subject: Re: [PATCH 08/21] dynamic_debug: factor show_ddebug_query out of ddebug_parse_query
To: Jim Cromie <jim.cromie@gmail.com>
Cc: jbaron@redhat.com, linux-kernel@vger.kernel.org, joe@perches.com,
        gregkh@suse.de, gnb@fmeh.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 9:46 AM, Jim Cromie <jim.cromie@gmail.com> wrote:
> Will reuse for show_pending_query too.  Alloc and free
> print buffer space inside ddebug_exec_queries, instead of
> a permanent static allocation.
>
> Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
> ---
>  lib/dynamic_debug.c |   24 +++++++++++++++++++-----
>  1 files changed, 19 insertions(+), 5 deletions(-)
>
> diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
> index de2a679..81268e2 100644
> --- a/lib/dynamic_debug.c
> +++ b/lib/dynamic_debug.c
> @@ -96,6 +96,19 @@ static char *ddebug_describe_flags(struct _ddebug *dp, char *buf,
>        return buf;
>  }
>
> +static char *prbuf_query;
> +
> +static char *show_ddebug_query(const struct ddebug_query *q)
> +{
> +       sprintf(prbuf_query,
> +               "q->function=\"%s\" q->filename=\"%s\" "
> +               "q->module=\"%s\" q->format=\"%s\" q->lineno=%u-%u",
> +               q->function, q->filename, q->module, q->format,
> +               q->first_lineno, q->last_lineno);
> +
> +       return prbuf_query;
> +}
> +
>  /*
>  * Search the tables for _ddebug's which match the given
>  * `query' and apply the `flags' and `mask' to them.  Tells
> @@ -344,11 +357,7 @@ static int ddebug_parse_query(char *words[], int nwords,
>        }
>
>        if (verbose)
> -               pr_info("q->function=\"%s\" q->filename=\"%s\" "
> -                       "q->module=\"%s\" q->format=\"%s\" q->lineno=%u-%u\n",
> -                       query->function, query->filename,
> -                       query->module, query->format, query->first_lineno,
> -                       query->last_lineno);
> +               pr_info("parsed %s\n", show_ddebug_query(query));
>
>        return 0;
>  }
> @@ -440,6 +449,10 @@ static int ddebug_exec_queries(char *query)
>        char *split;
>        int i, errs = 0, exitcode = 0, rc;
>
> +       prbuf_query = kmalloc(1024, GFP_KERNEL);
> +       if (prbuf_query == NULL)
> +               return -ENOMEM;
> +
>        for (i = 0; query; query = split, i++) {
>                split = strchr(query, ';');
>                if (split)
> @@ -454,6 +467,7 @@ static int ddebug_exec_queries(char *query)
>                        exitcode = rc;
>                }
>        }
> +       kfree(prbuf_query);
>        if (verbose)
>                pr_info("processed %d queries, with %d errs\n", i, errs);

Why to invoke kmalloc() with a magic constant as the first argument
while the above code can be simplified by replacing the sprintf() call
(that is missing an output buffer size check) by a kasprintf() call ?
And why does the static variable 'prbuf_query' exist at all ?

Bart.

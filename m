Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab1GLFyk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 01:54:40 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:49830 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953Ab1GLFyj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 01:54:39 -0400
MIME-Version: 1.0
In-Reply-To: <1310370416-6322-4-git-send-email-jim.cromie@gmail.com>
References: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
 <1310370416-6322-1-git-send-email-jim.cromie@gmail.com> <1310370416-6322-4-git-send-email-jim.cromie@gmail.com>
From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 12 Jul 2011 07:54:19 +0200
X-Google-Sender-Auth: AEFUMtqOXAPcTUXsQml_S3F2U7c
Message-ID: <CAO+b5-pXKeQ8zk367M4FNG5r6vUm6dOVBcNRaoJr+4i=kOy35A@mail.gmail.com>
Subject: Re: [PATCH 03/21] dynamic_debug: process multiple commands on a line
To: Jim Cromie <jim.cromie@gmail.com>
Cc: jbaron@redhat.com, linux-kernel@vger.kernel.org, joe@perches.com,
        gregkh@suse.de, gnb@fmeh.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 9:46 AM, Jim Cromie <jim.cromie@gmail.com> wrote:
> Process multiple commands per line, separated by ';'.  All commands are
> processed, independent of errors, allowing individual commands to fail,
> for example when a module is not installed.  Last error code is returned.
> With this, extensive command sets can be given on the boot-line.
>
> Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
> ---
>  lib/dynamic_debug.c |   30 ++++++++++++++++++++++++++++--
>  1 files changed, 28 insertions(+), 2 deletions(-)
>
> diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
> index 1597d5a..ae72402 100644
> --- a/lib/dynamic_debug.c
> +++ b/lib/dynamic_debug.c
> @@ -423,6 +423,32 @@ static int ddebug_exec_query(char *query_string)
>        return 0;
>  }
>
> +/* handle multiple queries, continue on error, return last error */
> +static int ddebug_exec_queries(char *query)
> +{
> +       char *split;
> +       int i, errs = 0, exitcode = 0, rc;
> +
> +       for (i = 0; query; query = split, i++) {
> +               split = strchr(query, ';');
> +               if (split)
> +                       *split++ = '\0';
> +
> +               if (verbose)
> +                       pr_info("query %d: \"%s\"\n", i, query);
> +
> +               rc = ddebug_exec_query(query);
> +               if (rc) {
> +                       errs++;
> +                       exitcode = rc;
> +               }
> +       }
> +       if (verbose)
> +               pr_info("processed %d queries, with %d errs\n", i, errs);
> +
> +       return exitcode;
> +}
> +

Does the above mean that semicolon is considered a valid separator but
newline not ?

Bart.

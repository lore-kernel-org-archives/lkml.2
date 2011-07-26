Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab1GZHJR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 03:09:17 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58143 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103Ab1GZHJK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 03:09:10 -0400
MIME-Version: 1.0
In-Reply-To: <1311630170-26057-4-git-send-email-jim.cromie@gmail.com>
References: <1311630170-26057-1-git-send-email-jim.cromie@gmail.com> <1311630170-26057-4-git-send-email-jim.cromie@gmail.com>
From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 26 Jul 2011 09:08:49 +0200
X-Google-Sender-Auth: SzrfvBvtGEl8m1OhcBT-Gvjl4zM
Message-ID: <CAO+b5-rpXrAZ6bAtWiy+rCaWEmRCwzMmNrqsRWQChM9nkdofiw@mail.gmail.com>
Subject: Re: [PATCH 03/25] dynamic_debug: use pr_debug instead of pr_info
To: Jim Cromie <jim.cromie@gmail.com>
Cc: jbaron@redhat.com, joe@perches.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, gnb@fmeh.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 11:42 PM, Jim Cromie <jim.cromie@gmail.com> wrote:
> Replace almost all occurrences of "if (verbose) pr_info()" with
> pr_debug(), and get full control of output at each callsite.
> Leave a few sites unaltered:
>
> 1st also uses pr_cont(), and theres no pr_debug_cont().
> 2nd is in ddebug_add_module(), which is called during arch_init,
> too early for callsite to be enabled when called.
>
> 3rd, pr_debug doesnt work in dynamic_debug_init(), its too early.
> Also move the print ddebug_setup_string prior to parsing, since
> afterwards it's been chopped up with '\0's, and only 1st word is seen.
>
> Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
> ---
>  lib/dynamic_debug.c |   66 ++++++++++++++++++++-------------------------------
>  1 files changed, 26 insertions(+), 40 deletions(-)
>
> diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
> index af6f1ae..a7161db 100644
> --- a/lib/dynamic_debug.c
> +++ b/lib/dynamic_debug.c
> @@ -157,18 +157,17 @@ static void ddebug_change(const struct ddebug_query *query,
>                                dp->enabled = 1;
>                        else
>                                dp->enabled = 0;
> -                       if (verbose)
> -                               pr_info("changed %s:%d [%s]%s %s\n",
> -                                       dp->filename, dp->lineno,
> -                                       dt->mod_name, dp->function,
> -                                       ddebug_describe_flags(dp, flagbuf,
> -                                                       sizeof(flagbuf)));
> +                       pr_debug("changed %s:%d [%s]%s %s\n",
> +                               dp->filename, dp->lineno,
> +                               dt->mod_name, dp->function,
> +                               ddebug_describe_flags(dp, flagbuf,
> +                                               sizeof(flagbuf)));

Changing pr_info() into pr_debug() inside the dynamic_debug
implementation seems like a really bad idea to me. Such changes make
it hard to find out via source code reading whether or not there is a
risk that invoking one of these pr_debug() macros will cause infinite
recursion.

Bart.

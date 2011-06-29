Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741Ab1F2Kup (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 06:50:45 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:59568 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037Ab1F2Kuo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 06:50:44 -0400
MIME-Version: 1.0
In-Reply-To: <1309244992-2305-4-git-send-email-jim.cromie@gmail.com>
References: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com> <1309244992-2305-4-git-send-email-jim.cromie@gmail.com>
From: Bart Van Assche <bvanassche@acm.org>
Date: Wed, 29 Jun 2011 12:50:23 +0200
X-Google-Sender-Auth: R3LyVKyD8l-vuCTh3qnGLnviKqQ
Message-ID: <BANLkTim2Q93LhBvGODVvEnvJiowtOk=DsA@mail.gmail.com>
Subject: Re: [PATCH 03/11] dynamic_debug: process multiple commands on a line
To: Jim Cromie <jim.cromie@gmail.com>
Cc: linux-kernel@vger.kernel.org, gnb@fmeh.org, jbaron@redhat.com,
        gregkh@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 9:09 AM, Jim Cromie <jim.cromie@gmail.com> wrote:
> Process multiple commands per line, separated by ';'.  All commands are
> processed, independent of errors, allowing individual commands to fail,
> for example when a module is not installed.  Last error code is returned.
> With this, extensive command sets can be given on the boot-line.
>
> Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
> ---
>  Documentation/dynamic-debug-howto.txt |   14 ++++++++++-
>  lib/dynamic_debug.c                   |   39 +++++++++++++++++++++++++++++++-
>  2 files changed, 49 insertions(+), 4 deletions(-)
>
> diff --git a/Documentation/dynamic-debug-howto.txt b/Documentation/dynamic-debug-howto.txt
> index f959909..d0faf98 100644
> --- a/Documentation/dynamic-debug-howto.txt
> +++ b/Documentation/dynamic-debug-howto.txt
> @@ -92,8 +92,18 @@ nullarbor:~ # echo -c 'file svcsock.c\nline 1603 +p' >
>  nullarbor:~ # echo -n 'file svcsock.c line 1603 +p' >
>                                <debugfs>/dynamic_debug/control
>
> -Commands are bounded by a write() system call.  If you want to do
> -multiple commands you need to do a separate "echo" for each, like:
> +Commands are bounded by a write() system call.  Subject to this limit
> +(or 1024 for boot-line parameter) you can send multiple commands,
> +separated by ';'
> +
> +foo:~ # echo "module nsc_gpio +p ; module pc8736x_gpio +p ; " \
> + "module scx200_gpio +p " > /dbg/dynamic_debug/control
> +
> +Multiple commands are processed independently, this allows you to send
> +commands which may fail, for example if a module is not present.  The
> +last failing command returns its error.
> +
> +Or you can do an "echo" for each, like:
>
>  nullarbor:~ # echo 'file svcsock.c line 1603 +p' > /proc/dprintk ;\
>  > echo 'file svcsock.c line 1563 +p' > /proc/dprintk
> diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
> index eb08a2f..0e567ad 100644
> --- a/lib/dynamic_debug.c
> +++ b/lib/dynamic_debug.c
> @@ -428,6 +428,41 @@ static int ddebug_exec_query(char *query_string)
>        return 0;
>  }
>
> +/* handle multiple queries, continue on error, return last error */
> +static int ddebug_exec_queries(char *query)
> +{
> +       char *split = query;
> +       int i, errs = 0, exitcode = 0, rc;
> +
> +       if (verbose)
> +               /* clean up for logging */
> +               for (; (split = strpbrk(split, "\t\n")); split++)
> +                       *split = ' ';

The above will join multiple lines into a single line and hence will
cause a shell statement like the one below to be interpret as a single
query:

printf "module nsc_gpio +p\n module pc8736x_gpio +p\n" > /proc/dprintk

Are you sure that's how things should work ?

> +       for (i = 0; query; query = split, i++) {
> +

No blank line past "for" please.

> +               split = strchr(query, ';');
> +               if (split)
> +                       *split++ = '\0';
> +
> +               if (verbose)
> +                       printk(KERN_INFO "%s: query %d: \"%s\"",
> +                               __func__, i, query);
> +
> +               rc = ddebug_exec_query(query);
> +               if (rc) {
> +                       errs++;
> +                       exitcode = rc;
> +               }
> +       }
> +       if (verbose)
> +               printk(KERN_INFO
> +                       "%s: processed %d queries, with %d errs",
> +                       __func__, i, errs);
> +
> +       return exitcode;
> +}
> +
>  int __dynamic_pr_debug(struct _ddebug *descriptor, const char *fmt, ...)
>  {
>        va_list args;
> @@ -492,7 +527,7 @@ static ssize_t ddebug_proc_write(struct file *file, const char __user *ubuf,
>                printk(KERN_INFO "%s: read %d bytes from userspace\n",
>                        __func__, (int)len);
>
> -       ret = ddebug_exec_query(tmpbuf);
> +       ret = ddebug_exec_queries(tmpbuf);
>        if (ret)
>                return ret;
>
> @@ -804,7 +839,7 @@ static int __init dynamic_debug_init(void)
>
>        /* ddebug_query boot param got passed -> set it up */
>        if (ddebug_setup_string[0] != '\0') {
> -               ret = ddebug_exec_query(ddebug_setup_string);
> +               ret = ddebug_exec_queries(ddebug_setup_string);
>                if (ret)
>                        pr_warning("Invalid ddebug boot param %s",
>                                   ddebug_setup_string);
> --
> 1.7.4.1
>
>

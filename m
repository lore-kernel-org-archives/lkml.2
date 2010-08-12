Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760723Ab0HLV3E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 17:29:04 -0400
Received: from smtp-out.google.com ([74.125.121.35]:54526 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755006Ab0HLV3B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 17:29:01 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=u+3ByHNLAg5PaAgLdE4Pv7t2XM5mtZfUbMX6Qt2Uza1ydlt2Z/DmhiN7ub+FC+ptg
	KoMZPkqoNiwoyEAgNgezw==
MIME-Version: 1.0
In-Reply-To: <1281635958-21177-1-git-send-email-tzanussi@gmail.com>
References: <1281635958-21177-1-git-send-email-tzanussi@gmail.com>
Date: Thu, 12 Aug 2010 23:28:44 +0200
Message-ID: <AANLkTi=rgu02EB1GtaAb6bk-S8XssinTnaqpiZQVpVRQ@mail.gmail.com>
Subject: Re: [PATCH] perf trace: get rid of the hard-coded paths in the report scripts
From: Stephane Eranian <eranian@google.com>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, acme@infradead.org, mingo@elte.hu,
        acme@redhat.com, fweisbec@gmail.com, peterz@infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 7:59 PM, Tom Zanussi <tzanussi@gmail.com> wrote:
> The perf trace report shell scripts hard-code the exec path of the
> scripts into their command-lines, which doesn't work if perf has been
> installed somewhere else.
>
> Instead, perf trace should create the paths at run-time.  This patch
> does that and removes the hard-coded paths from all the report scripts.
>
> v2 changes: The first version inadvertantly caused scripts run from
> outside the perf exec path to fail e.g. 'perf trace -s test.py'.  The
> fix is to try the script name without the exec path first, then the
> version using the exec path, which restores the expected behavior.
>
> Reported-by: Stephane Eranian <eranian@google.com>
> Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
> ---
>  tools/perf/builtin-trace.c                         |   22 ++++++++++++++++---
>  tools/perf/scripts/perl/bin/failed-syscalls-report |    2 +-
>  tools/perf/scripts/perl/bin/rw-by-file-report      |    2 +-
>  tools/perf/scripts/perl/bin/rw-by-pid-report       |    2 +-
>  tools/perf/scripts/perl/bin/rwtop-report           |    2 +-
>  tools/perf/scripts/perl/bin/wakeup-latency-report  |    2 +-
>  tools/perf/scripts/perl/bin/workqueue-stats-report |    2 +-
>  .../python/bin/failed-syscalls-by-pid-report       |    2 +-
>  .../perf/scripts/python/bin/sched-migration-report |    2 +-
>  tools/perf/scripts/python/bin/sctop-report         |    2 +-
>  .../python/bin/syscall-counts-by-pid-report        |    2 +-
>  .../perf/scripts/python/bin/syscall-counts-report  |    3 +-
>  12 files changed, 30 insertions(+), 15 deletions(-)
>
> diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
> index 40a6a29..88a1883 100644
> --- a/tools/perf/builtin-trace.c
> +++ b/tools/perf/builtin-trace.c
> @@ -573,6 +573,7 @@ int cmd_trace(int argc, const char **argv, const char *prefix __used)
>        const char *suffix = NULL;
>        const char **__argv;
>        char *script_path;
> +       struct stat perf_stat;
>        int i, err;
>
>        if (argc >= 2 && strncmp(argv[1], "rec", strlen("rec")) == 0) {
> @@ -689,8 +690,6 @@ int cmd_trace(int argc, const char **argv, const char *prefix __used)
>                return -EINVAL;
>
>        if (generate_script_lang) {
> -               struct stat perf_stat;
> -
>                int input = open(input_name, O_RDONLY);
>                if (input < 0) {
>                        perror("failed to open file");
> @@ -719,10 +718,25 @@ int cmd_trace(int argc, const char **argv, const char *prefix __used)
>        }
>
>        if (script_name) {
> -               err = scripting_ops->start_script(script_name, argc, argv);
> +               char script_exec_path[MAXPATHLEN];
> +
> +               snprintf(script_exec_path, MAXPATHLEN, "%s", script_name);
> +               err = stat(script_exec_path, &perf_stat);

Why not simply use access() instead of stat() here?

> +               if (err < 0) {
> +                       snprintf(script_exec_path, MAXPATHLEN, "%s/scripts/%s",
> +                                perf_exec_path(), script_name);
> +                       err = stat(script_exec_path, &perf_stat);
And here?

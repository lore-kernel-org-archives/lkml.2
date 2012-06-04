Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab2FDHbZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 03:31:25 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:57607 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753731Ab2FDHbY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 03:31:24 -0400
MIME-Version: 1.0
In-Reply-To: <20120515111111.GA9870@quad>
References: <20120515111111.GA9870@quad>
Date: Mon, 4 Jun 2012 09:31:22 +0200
Message-ID: <CABPqkBRNao_cTvaoTAt3Av=SP5hcGxzFVjerQ0hnkJtY+S3TMw@mail.gmail.com>
Subject: Re: [PATCH] perf stat: fix default output file
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, peterz@infradead.org, mingo@elte.hu, dsahern@gmail.com,
        jim.cromie@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping?

On Tue, May 15, 2012 at 1:11 PM, Stephane Eranian <eranian@google.com> wrote:
>
> The following commit:
>
> commit 56f3bae70638b33477a6015fd362ccfe354fd3ee
> Author: Jim Cromie <jim.cromie@gmail.com>
> Date:   Wed Sep 7 17:14:00 2011 -0600
>
>    perf stat: Add --log-fd <N> option to redirect stderr elsewhere
>
> introduced a bug in the way perf stat outputs the results by default, i.e.,
> without the --log-fd or --output option. It would default to writing to
> file descriptor 0, i.e., stdin. Writing to stdin is allowed and is equivalent
> to writing to stdout. However, there is a major difference for any script that
> was already capturing the output of perf stat via redirection:
>
>    perf stat >/tmp/log .... or perf stat 2>/tmp/log ....
>
> They would not capture anything anymore. They would have to do:
>    perf stat 0>/tmp/log ...
>
> This breaks compatibility with existing scripts and does not look very
> natural.
>
> This patch fixes the problem by looking at output_fd only when it
> was modified by user (> 0). It also checks that the value if positive.
> Passing --log-fd 0 is ignored.
>
> I would also argue that defaulting to stderr for the results is not
> the right thing to do, though this patch does not address this specific
> issue.
>
> Signed-off-by: Stephane Eranian <eranian@google.com>
> ---
>
> diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
> index 36603e4..56e6040 100644
> --- a/tools/perf/builtin-stat.c
> +++ b/tools/perf/builtin-stat.c
> @@ -1179,6 +1179,12 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
>                fprintf(stderr, "cannot use both --output and --log-fd\n");
>                usage_with_options(stat_usage, options);
>        }
> +
> +       if (output_fd < 0) {
> +               fprintf(stderr, "argument to --log-fd must be a > 0\n");
> +               usage_with_options(stat_usage, options);
> +       }
> +
>        if (!output) {
>                struct timespec tm;
>                mode = append_file ? "a" : "w";
> @@ -1190,7 +1196,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
>                }
>                clock_gettime(CLOCK_REALTIME, &tm);
>                fprintf(output, "# started on %s\n", ctime(&tm.tv_sec));
> -       } else if (output_fd != 2) {
> +       } else if (output_fd > 0) {
>                mode = append_file ? "a" : "w";
>                output = fdopen(output_fd, mode);
>                if (!output) {

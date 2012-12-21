Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799Ab2LUIcS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 03:32:18 -0500
Received: from mail.skyhub.de ([78.46.96.112]:53390 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906Ab2LUIcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 03:32:10 -0500
Date: Fri, 21 Dec 2012 09:32:05 +0100
From: Borislav Petkov <bp@alien8.de>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 6/6] perf annotate: Add --gtk option
Message-ID: <20121221083205.GA15226@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Pekka Enberg <penberg@kernel.org>
References: <1356078018-31905-1-git-send-email-namhyung@kernel.org>
 <1356078018-31905-7-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1356078018-31905-7-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2012 at 05:20:18PM +0900, Namhyung Kim wrote:
> Now we have GTK2 implementation, add a new --gtk option to use it.
> 
> Cc: Pekka Enberg <penberg@kernel.org>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/Documentation/perf-annotate.txt | 4 ++++
>  tools/perf/builtin-annotate.c              | 5 ++++-
>  2 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/perf/Documentation/perf-annotate.txt b/tools/perf/Documentation/perf-annotate.txt
> index c8ffd9fd5c6a..482e1f753127 100644
> --- a/tools/perf/Documentation/perf-annotate.txt
> +++ b/tools/perf/Documentation/perf-annotate.txt
> @@ -66,6 +66,10 @@ OPTIONS
>  	used. This interfaces starts by centering on the line with more
>  	samples, TAB/UNTAB cycles through the lines with more samples.
>  
> +--gtk:: Use the GTK interface. Use of --gtk requires (but not uses) a tty,

What does that even mean?

* it requires one but doesn't use it by default

* it requires one but if none is present, falls back to stdio

* it simply checks for tty presence and uses something completely different

* something else

?

> +	if one is not present, as when piping to other commands, the stdio
> +	interface is used.
> +
>  -C::
>  --cpu:: Only report samples for the list of CPUs provided. Multiple CPUs can
>  	be provided as a comma-separated list with no space: 0,1. Ranges of
> diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
> index 034e9b003c62..dcc090526e56 100644
> --- a/tools/perf/builtin-annotate.c
> +++ b/tools/perf/builtin-annotate.c
> @@ -34,7 +34,7 @@
>  
>  struct perf_annotate {
>  	struct perf_tool tool;
> -	bool	   force, use_tui, use_stdio;
> +	bool	   force, use_tui, use_stdio, use_gtk;
>  	bool	   full_paths;
>  	bool	   print_line;
>  	const char *sym_hist_filter;
> @@ -277,6 +277,7 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __maybe_unused)
>  		    "be more verbose (show symbol address, etc)"),
>  	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
>  		    "dump raw trace in ASCII"),
> +	OPT_BOOLEAN(0, "gtk", &annotate.use_gtk, "Use the GTK interface"),
>  	OPT_BOOLEAN(0, "tui", &annotate.use_tui, "Use the TUI interface"),
>  	OPT_BOOLEAN(0, "stdio", &annotate.use_stdio, "Use the stdio interface"),
>  	OPT_STRING('k', "vmlinux", &symbol_conf.vmlinux_name,
> @@ -307,6 +308,8 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __maybe_unused)
>  		use_browser = 0;
>  	else if (annotate.use_tui)
>  		use_browser = 1;
> +	else if (annotate.use_gtk)
> +		use_browser = 2;

Btw, acme, those use_browser values could use proper defines like:

#define PERF_BROWSER_NONE	0
#define PERF_BROWSER_TUI	1
#define PERF_BROWSER_GTK	2

or even an enum or whatever else comes natural in perf-speak.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

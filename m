Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126Ab2HGPun (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 11:50:43 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:57523 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262Ab2HGPul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 11:50:41 -0400
Date: Tue, 7 Aug 2012 17:50:36 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/2] perf tools: Support for events bash completion
Message-ID: <20120807155033.GC12858@somewhere.redhat.com>
References: <1344345586-15068-1-git-send-email-fweisbec@gmail.com>
 <1344345586-15068-3-git-send-email-fweisbec@gmail.com>
 <50212AA4.604@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50212AA4.604@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 08:48:04AM -0600, David Ahern wrote:
> On 8/7/12 7:19 AM, Frederic Weisbecker wrote:
> >Add basic bash completion for the -e option in record, top
> >and stat subcommands. Only hardware, software and tracepoint
> >events are supported.
> >
> >Breakpoints, raw events and events grouping completion
> >need more thinking.
> >
> >Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> >Cc: David Ahern <dsahern@gmail.com>
> >Cc: Ingo Molnar <mingo@kernel.org>
> >Cc: Jiri Olsa <jolsa@redhat.com>
> >Cc: Namhyung Kim <namhyung@gmail.com>
> >Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> >Cc: Stephane Eranian <eranian@google.com>
> >---
> >  tools/perf/bash_completion     |    6 +++-
> >  tools/perf/builtin-list.c      |   14 ++++---
> >  tools/perf/util/parse-events.c |   70 +++++++++++++++++++++++++---------------
> >  tools/perf/util/parse-events.h |    7 ++--
> >  4 files changed, 61 insertions(+), 36 deletions(-)
> >
> >diff --git a/tools/perf/bash_completion b/tools/perf/bash_completion
> >index 3547703..25f4d99 100644
> >--- a/tools/perf/bash_completion
> >+++ b/tools/perf/bash_completion
> >@@ -6,12 +6,16 @@ _perf()
> >  	local cur
> >
> >  	COMPREPLY=()
> >-	_get_comp_words_by_ref cur
> >+	_get_comp_words_by_ref cur prev
> >
> >  	# List perf subcommands
> >  	if [ $COMP_CWORD -eq 1 ]; then
> >  		cmds=$(perf --list-cmds)
> >  		COMPREPLY=( $( compgen -W '$cmds' -- "$cur" ) )
> >+	# List possible events for -e option
> >+	elif [[ $prev == "-e" && "${COMP_WORDS[1]}" == @(record|stat|top) ]]; then
> >+		cmds=$(perf list --raw-dump)
> >+		COMPREPLY=( $( compgen -W '$cmds' -- $cur ) )
> >  	# Fall down to list regular files
> >  	else
> >  		_filedir
> 
> Any reason to show a file list except for -i and -o options? e.g.,

Yeah, for example with perf record when you pass a command to launch and profile.

In any case I think it's a better idea to keep this as a default. Not breaking the
pre-existing default completion in the guarantee that the new completion is going
to be more useful than a burden.

> 
> diff --git a/tools/perf/bash_completion b/tools/perf/bash_completion
> index 25f4d99..be97349 100644
> --- a/tools/perf/bash_completion
> +++ b/tools/perf/bash_completion
> @@ -17,7 +17,7 @@ _perf()
>         cmds=$(perf list --raw-dump)
>         COMPREPLY=( $( compgen -W '$cmds' -- $cur ) )
>     # Fall down to list regular files
> -   else
> +   elif [[ $prev == "-o" || $prev == "-i" ]]; then
>         _filedir
>     fi
>  } &&
> 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757147Ab2EGONk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 10:13:40 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:56816 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757044Ab2EGONh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 10:13:37 -0400
Date: Mon, 7 May 2012 16:13:31 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, Jiri Olsa <jolsa@redhat.com>,
        Arun Sharma <asharma@fb.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Julia Lawall <julia@diku.dk>, Tom Zanussi <tzanussi@gmail.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 00/15] tools: Unify perf and trace-cmd trace event format
 parsing v3
Message-ID: <20120507141331.GB28254@gmail.com>
References: <1335356819-16710-1-git-send-email-fweisbec@gmail.com>
 <20120507081424.GE16608@gmail.com>
 <1336397821.14207.136.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336397821.14207.136.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Mon, 2012-05-07 at 10:14 +0200, Ingo Molnar wrote:
> 
> > So can we please make a libevent.so, built sanely within 
> > tools/perf/lib/ or such and distributed together with perf so 
> > that the two can never get out of sync?
> 
> If you do this, you need to find a way to turn off -Wswitch-enum as that
> seems to (at least on my gcc) ignore defaults.
> 
> Thus we end up with:
> 
> diff --git a/Makefile b/Makefile
> index 18ad079..217548b 100644
> 
> diff --git a/parse-filter.c b/parse-filter.c
> index d09fbd2..0ac249c 100644
> --- a/parse-filter.c
> +++ b/parse-filter.c
> @@ -367,6 +367,12 @@ create_arg_item(struct event_format *event, const
> char *token,
>  		arg->type = FILTER_ARG_FIELD;
>  		arg->field.field = field;
>  		break;
> +	case EVENT_ERROR:
> +	case EVENT_NONE:
> +	case EVENT_SPACE:
> +	case EVENT_NEWLINE:
> +	case EVENT_OP:
> +	case EVENT_DELIM:
>  	default:
>  		free_arg(arg);
>  		show_error(error_str, "expected a value but found %s",

The advantage of this warning is that when a new enum value is 
added, every usage site is forced to consider it.

Code not using it indeed needs to be updated.

> Looking at what was done in the current code, there's lots of :
> 
> 	case PRINT_NULL:
> 	case PRINT_FIELD ... PRINT_SYMBOL:
> 	case PRINT_STRING:
> 	default:
> 
> Which looks more of a maintenance nightmare. How does this help? The
> FOO ... BAR, will hide the same errors that you are trying to prevent.

Indeed the FOO...BAR pattern should not be used (i.e. the above 
is a bug in essence), unless it's clearly some genuine same-type 
numeric range that is expressed, where new fields can never get 
inbetween.

> If you were suppose to handle something between FOO and BAR, then you
> just ignored it too.

Correct.

> It also makes that "default" redundant.

Yes.

> This is one of those warnings that causes more pain than it 
> helps.

I disagree, when I switched to it then it found some real bugs 
and new changes were incremental.

> If you strongly believe that all these warnings are helpful, 
> than we should push to add these warnings to the kernel too.

For subsystems I maintain we could consider it - but for the 
kernel as a whole it would be quite some work.

Thanks,

	Ingo

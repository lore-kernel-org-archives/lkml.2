Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336Ab2EGNhG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 09:37:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25418 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756105Ab2EGNhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 09:37:03 -0400
X-Authority-Analysis: v=2.0 cv=OMylLFmB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=_s2ZMIMYyfwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=8ZS6Btx8uB3dEi3HNmUA:9 a=A6z-zd2m3Z-kgKKLxpcA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1336397821.14207.136.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 00/15] tools: Unify perf and trace-cmd trace event
 format parsing v3
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@kernel.org>
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
Date: Mon, 07 May 2012 09:37:01 -0400
In-Reply-To: <20120507081424.GE16608@gmail.com>
References: <1335356819-16710-1-git-send-email-fweisbec@gmail.com>
	 <20120507081424.GE16608@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-07 at 10:14 +0200, Ingo Molnar wrote:

> So can we please make a libevent.so, built sanely within 
> tools/perf/lib/ or such and distributed together with perf so 
> that the two can never get out of sync?

If you do this, you need to find a way to turn off -Wswitch-enum as that
seems to (at least on my gcc) ignore defaults.

Thus we end up with:

diff --git a/Makefile b/Makefile
index 18ad079..217548b 100644

diff --git a/parse-filter.c b/parse-filter.c
index d09fbd2..0ac249c 100644
--- a/parse-filter.c
+++ b/parse-filter.c
@@ -367,6 +367,12 @@ create_arg_item(struct event_format *event, const
char *token,
 		arg->type = FILTER_ARG_FIELD;
 		arg->field.field = field;
 		break;
+	case EVENT_ERROR:
+	case EVENT_NONE:
+	case EVENT_SPACE:
+	case EVENT_NEWLINE:
+	case EVENT_OP:
+	case EVENT_DELIM:
 	default:
 		free_arg(arg);
 		show_error(error_str, "expected a value but found %s",


I found that I added over 20 of these trying to keep -Wswitch-enum
happy, before i decided to give up (there's many more than 20 places
that need updates).

Looking at what was done in the current code, there's lots of :

	case PRINT_NULL:
	case PRINT_FIELD ... PRINT_SYMBOL:
	case PRINT_STRING:
	default:

Which looks more of a maintenance nightmare. How does this help? The
FOO ... BAR, will hide the same errors that you are trying to prevent.
If you were suppose to handle something between FOO and BAR, then you
just ignored it too.

It also makes that "default" redundant.

This is one of those warnings that causes more pain than it helps.

If you strongly believe that all these warnings are helpful, than we
should push to add these warnings to the kernel too.

-- Steve



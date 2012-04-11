Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932533Ab2DKOeA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 10:34:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52382 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754622Ab2DKOd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 10:33:59 -0400
Date: Wed, 11 Apr 2012 16:33:13 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Robert Richter <robert.richter@amd.com>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, andi@firstfloor.org
Subject: Re: [PATCH 5/8] perf, tool: Separate 'mem:' event scanner bits
Message-ID: <20120411143313.GA5170@m.brq.redhat.com>
References: <1333574176-11388-1-git-send-email-jolsa@redhat.com>
 <1333574176-11388-6-git-send-email-jolsa@redhat.com>
 <20120411132818.GA5046@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120411132818.GA5046@erda.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 03:28:18PM +0200, Robert Richter wrote:
> On 04.04.12 23:16:13, Jiri Olsa wrote:
> > Separating 'mem:' scanner processing, so we can parse out
> > modifier specifically and dont clash with other rules.
> > 
> > This is just precaution for the future, so we dont need to worry
> > about the rules clashing where we need to parse out any sub-rule
> > of global rules.
> > 
> > Learning bison/flex as I go... ;)
> 
> All this lex/yacc thing is over-engineered. Having this for just
> parsing events events is overkill and introduces more problems than it
> solves.
> 
> I am looking at this because I want to extend perf tools to have
> support for dynamic allocated pmus, esp. for IBS. I have had to
> completly rework my code because of this change and it is still hard
> to find a solution for this. I guess there was a reason to use
> lex/yacc, but I don't think we need it for parsing *all* types of
> events.
hi,
I could try to help you, please feel free to send me details

> 
> First, not every developer knows about lex and yacc, so this raises
> the bar to modify and improve the code. I already had worked with
> lex/yacc some years ago. What I remember and learned from it is to
> avoid using it because there are easier ways to solve the same
> problems. Esp. I learned to keep things simple and not to invent
> complex syntax or languages. Unfortunatlly, this is what happens here
> (remember, we just want to parse events, nothing more).
> 
> It also adds a more complex tool chain and the result of the generated
> code is heavily affected by them and the used distro. The discussion
> about having precompiled code in the repository had shown its
> problems. There is also no control of the quality of the generated
> code. With something like the following you are actually stucked to

We saw some problems with some RHEL6 using buggy bison version.. but
that's about it AFAIK.

> build perf:
> 
>  $ make
>  ...
>      CC util/parse-events-flex.o
>  cc1: warnings being treated as errors
>  <stdout>: In function 'yy_get_next_buffer':
>  <stdout>:1504:3: error: comparison between signed and unsigned integer expressions
>  util/parse-events.l: In function 'parse_events_lex':
>  util/parse-events.l:122:1: error: ignoring return value of 'fwrite', declared with attribute warn_unused_result
>  make: *** [util/parse-events-flex.o] Error 1

We had to disable some of the warnings to get it compiled.
Above failure is from your modification, right?
Since I dont see mentioned parse-events.l:122 causing the issue.


> 
> But the main problem I see are side effects of the syntax for one
> event type to another. The lexer generates a token stream and the
> syntax of each token is predefined, e.g. the word 'config' always
> returns the PE_TERM token. Thus, you are not able to use that word for
> other purposes, let's say in a tracepoint. Another example is the word
> 'race' that is always detected as a raw-event token. This side effects
> are not easy to discover and to test.

This patch is actually part of the solution for this.
You can add 'start' conditions' to lexer and do specific matching
for specific prefix.

As for the PE_TERM issue you mentioned, the util/parse-events.l file has
following comment addressing this issue:

        /*
         * These are event config hardcoded term names to be specified
         * within xxx/.../ syntax. So far we dont clash with other * names,
         * so we can put them here directly. In case the we have a * conflict
         * in future, this needs to go into '//' condition block.
         */

> 
> This makes it also hard to extend the syntax. Since certain token
> patterns are already defined for a special event type, the same
> pattern can not be used again. If the setup of this event fails the
> parser is not able to setup a different event type. See this example:
> 
>  <pmu>:<some_string>:<modifier>
>  <pmu>:<raw_config>:<modifier>
> 
> This syntax is already used for a single event type (tracepoints) and
> can't be reused anymore. There are options to solve this by defining
> the syntax different:
> 
>  <pmu>::<some_string>::<modifier>
>  <pmu>/<some_string>/:<modifier>
> 
> ... or so. Alternativly one could write a more complex lexer that goes
> back and forth in the buffer using yyless() or so.
> 
> One could also argument here that the syntax needs to be well defined,
> which would prevent the problems above, but I don't want to implement
> a nice syntax, I want to parse events.
> 
> The previous implementation worked simple and straightforward by
> passing the event string to the event parsers until there was a
> match. I haven't had the feeling of unresolvable issues with the plain
> C implementation. So why lex/yacc?

I believe the original reason was to handle event grouping within
the event syntax, which would not be that straightforward with
the old implementation.

It was discussed somewhere in here:
http://marc.info/?t=130105133700002&r=1&w=2
http://marc.info/?t=129065042800002&r=1&w=2
http://marc.info/?l=linux-kernel&m=129067262931833&w=2

My opinion is that using the parser for this made the code more
readable/straightforward, since we dont need to deal with the
actual parsing. But as you said some bison/flex knowledge is
needed to get orientated.

wbr,
jirka

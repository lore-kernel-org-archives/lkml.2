Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933486Ab1LFPEs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 10:04:48 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45144 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933389Ab1LFPEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 10:04:47 -0500
Subject: Re: [PATCH 06/10] perf report: Setup browser if stdout is a pipe
From: Tom Zanussi <tzanussi@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20111206132910.GG7059@infradead.org>
References: <1323167560-2282-1-git-send-email-robert.richter@amd.com>
	 <1323167560-2282-7-git-send-email-robert.richter@amd.com>
	 <20111206132910.GG7059@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Dec 2011 09:04:44 -0600
Message-ID: <1323183884.2059.49.camel@elnicho>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-12-06 at 11:29 -0200, Arnaldo Carvalho de Melo wrote:
> Em Tue, Dec 06, 2011 at 11:32:36AM +0100, Robert Richter escreveu:
> > The decision to setup the browser should be made if stdout is pipe,
> > not stdin.
> 
> I can't remember what made that logic be like that...  Here it is:
> 
> commit 46656ac7fb3252f8a3db29b18638e0e8067849ba
> Author: Tom Zanussi <tzanussi@gmail.com>
> Date:   Thu Apr 1 23:59:17 2010 -0500
> 
>     perf report: Introduce special handling for pipe input
>     
>     Adds special treatment for stdin - if the user specifies '-i -'
>     to perf report, the intent is that the event stream be written
>     to stdin rather than from a disk file.
>     
>     The actual handling of the '-' filename is done by the session;
>     this just adds a signal handler to stop reporting, and turns off
>     interference by the pager.
>     
>     Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
>     Acked-by: Thomas Gleixner <tglx@linutronix.de>
>     Cc: fweisbec@gmail.com
>     Cc: rostedt@goodmis.org
>     Cc: k-keiichi@bx.jp.nec.com
>     Cc: acme@ghostprotocols.net
>     LKML-Reference: <1270184365-8281-4-git-send-email-tzanussi@gmail.com>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> I can't understand the comment either, as I think it should've read "the
> intent is that the event stream be _read from stdin_ rather than from a
> disk file."
> 
> And I don't know what would be the pager interference there.
> 
> Tom, could you elaborate on this?
> 

Hi Arnaldo,

Yeah, I think your comment is correct - the commit has a typo and should
read 'the intent is that the event stream be read from stdin'.

Basically, it's from the standpoint of a pipeline such as 'perf record |
perf report+scripting engine' where the output of perf record is
continuously fed into a scripting engine.  The script in then end takes
complete control of the output and doesn't want to be interfered with by
a pager.  IIRC that caused a problem with the 'top'-type scripts.

Anyway, from the standpoint of 'perf report' in a 'live' pipeline, I
think the current code is correct - if the input is coming from a pipe,
the assumption is that it's being passed to a script which will take
care of all the output details, so turn the pager off...

Tom 

> Thanks,
> 
> - Arnaldo
>     
>  
> > Signed-off-by: Robert Richter <robert.richter@amd.com>
> > ---
> >  tools/perf/builtin-report.c |    9 ++++++---
> >  1 files changed, 6 insertions(+), 3 deletions(-)
> > 
> > diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
> > index 4d7c834..88ca2d4 100644
> > --- a/tools/perf/builtin-report.c
> > +++ b/tools/perf/builtin-report.c
> > @@ -504,6 +504,8 @@ static const struct option options[] = {
> >  
> >  int cmd_report(int argc, const char **argv, const char *prefix __used)
> >  {
> > +	struct stat st;
> > +
> >  	argc = parse_options(argc, argv, options, report_usage, 0);
> >  
> >  	if (use_stdio)
> > @@ -514,10 +516,11 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
> >  	if (inverted_callchain)
> >  		callchain_param.order = ORDER_CALLER;
> >  
> > -	if (strcmp(input_name, "-") != 0)
> > -		setup_browser(true);
> > -	else
> > +	if (!fstat(STDOUT_FILENO, &st) && S_ISFIFO(st.st_mode))
> >  		use_browser = 0;
> > +	else
> > +		setup_browser(true);
> > +
> >  	/*
> >  	 * Only in the newt browser we are doing integrated annotation,
> >  	 * so don't allocate extra space that won't be used in the stdio
> > -- 
> > 1.7.7
> > 



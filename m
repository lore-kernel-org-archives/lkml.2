Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933372Ab1LFN3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 08:29:18 -0500
Received: from casper.infradead.org ([85.118.1.10]:50547 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933031Ab1LFN3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 08:29:17 -0500
Date: Tue, 6 Dec 2011 11:29:10 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/10] perf report: Setup browser if stdout is a pipe
Message-ID: <20111206132910.GG7059@infradead.org>
References: <1323167560-2282-1-git-send-email-robert.richter@amd.com> <1323167560-2282-7-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323167560-2282-7-git-send-email-robert.richter@amd.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Dec 06, 2011 at 11:32:36AM +0100, Robert Richter escreveu:
> The decision to setup the browser should be made if stdout is pipe,
> not stdin.

I can't remember what made that logic be like that...  Here it is:

commit 46656ac7fb3252f8a3db29b18638e0e8067849ba
Author: Tom Zanussi <tzanussi@gmail.com>
Date:   Thu Apr 1 23:59:17 2010 -0500

    perf report: Introduce special handling for pipe input
    
    Adds special treatment for stdin - if the user specifies '-i -'
    to perf report, the intent is that the event stream be written
    to stdin rather than from a disk file.
    
    The actual handling of the '-' filename is done by the session;
    this just adds a signal handler to stop reporting, and turns off
    interference by the pager.
    
    Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
    Acked-by: Thomas Gleixner <tglx@linutronix.de>
    Cc: fweisbec@gmail.com
    Cc: rostedt@goodmis.org
    Cc: k-keiichi@bx.jp.nec.com
    Cc: acme@ghostprotocols.net
    LKML-Reference: <1270184365-8281-4-git-send-email-tzanussi@gmail.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>


I can't understand the comment either, as I think it should've read "the
intent is that the event stream be _read from stdin_ rather than from a
disk file."

And I don't know what would be the pager interference there.

Tom, could you elaborate on this?

Thanks,

- Arnaldo
    
 
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> ---
>  tools/perf/builtin-report.c |    9 ++++++---
>  1 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
> index 4d7c834..88ca2d4 100644
> --- a/tools/perf/builtin-report.c
> +++ b/tools/perf/builtin-report.c
> @@ -504,6 +504,8 @@ static const struct option options[] = {
>  
>  int cmd_report(int argc, const char **argv, const char *prefix __used)
>  {
> +	struct stat st;
> +
>  	argc = parse_options(argc, argv, options, report_usage, 0);
>  
>  	if (use_stdio)
> @@ -514,10 +516,11 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
>  	if (inverted_callchain)
>  		callchain_param.order = ORDER_CALLER;
>  
> -	if (strcmp(input_name, "-") != 0)
> -		setup_browser(true);
> -	else
> +	if (!fstat(STDOUT_FILENO, &st) && S_ISFIFO(st.st_mode))
>  		use_browser = 0;
> +	else
> +		setup_browser(true);
> +
>  	/*
>  	 * Only in the newt browser we are doing integrated annotation,
>  	 * so don't allocate extra space that won't be used in the stdio
> -- 
> 1.7.7
> 

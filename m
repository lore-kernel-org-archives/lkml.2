Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932949Ab2CZScH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 14:32:07 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:57674 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932796Ab2CZScE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 14:32:04 -0400
Date: Mon, 26 Mar 2012 15:32:00 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: =?iso-8859-1?Q?J=F6rg?= Sommer <joerg@alea.gnuu.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] perf tools: Fix parsing of unary operator in ?:
 expression
Message-ID: <20120326183200.GB5195@infradead.org>
References: <05a6b9ad17375452aedc994c4553137750db0a13.1332709498.git.joerg@alea.gnuu.de>
 <bc768c12ba3df410cb3a049ea6d88d39a993768d.1332709498.git.joerg@alea.gnuu.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bc768c12ba3df410cb3a049ea6d88d39a993768d.1332709498.git.joerg@alea.gnuu.de>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, Mar 25, 2012 at 11:11:32PM +0200, Jörg Sommer escreveu:
> Parsing an expression like
> 
> print fmt: "reason %s (%d)", …, REC->errno < 0 ? -REC->errno : REC->reason
> 
> in kvm_space_exit fails with

There is no 'kvm_space_exit' I could google for except in this patch,
this is 'kvm_userspace_exit', right?

Fixing that in the changeset log.

- Arnaldo
 
> Fatal unknown op ':'
> 
> The colon after a simple operator signals the end of this expression. The
> token should not be advanced, because the colon is handled in
> process_cond(). Hence, it's enough to signal there's an operation
> heading.
> 
> Signed-off-by: Jörg Sommer <joerg@alea.gnuu.de>
> ---
> An alternative could be:
> 
>  --- a/tools/perf/util/trace-event-parse.c
>  +++ b/tools/perf/util/trace-event-parse.c
>  @@ -1287,7 +1287,7 @@ process_op(struct event *event, struct print_arg *arg, char **tok)
>                 return EVENT_NONE;
>         }
>  
> -       if (type == EVENT_OP) {
> +       if (type == EVENT_OP && strcmp(*tok, ":") != 0) {
>                 int prio;
>  
>                 /* higher prios need to be closer to the root */
> 
> 
>  tools/perf/util/trace-event-parse.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
> index 185e284..d7b5880 100644
> --- a/tools/perf/util/trace-event-parse.c
> +++ b/tools/perf/util/trace-event-parse.c
> @@ -1125,6 +1125,7 @@ static int get_op_prio(char *op)
>  		case '|':
>  			return 13;
>  		case '?':
> +		case ':':
>  			return 16;
>  		default:
>  			die("unknown op '%c'", op[0]);
> @@ -1202,6 +1203,8 @@ process_op(struct event *event, struct print_arg *arg, char **tok)
>  
>  		type = process_arg(event, right, tok);
>  
> +	} else if (strcmp(token, ":") == 0) {
> +		return EVENT_OP;
>  	} else if (strcmp(token, "?") == 0) {
>  
>  		left = malloc_or_die(sizeof(*left));
> -- 
> 1.7.9.1

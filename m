Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933240Ab2CZSPb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 14:15:31 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33845 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932638Ab2CZSP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 14:15:29 -0400
Date: Mon, 26 Mar 2012 15:15:24 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: =?iso-8859-1?Q?J=F6rg?= Sommer <joerg@alea.gnuu.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] perf tools: Concatenate strings in expressions
Message-ID: <20120326181524.GA5195@infradead.org>
References: <05a6b9ad17375452aedc994c4553137750db0a13.1332709498.git.joerg@alea.gnuu.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <05a6b9ad17375452aedc994c4553137750db0a13.1332709498.git.joerg@alea.gnuu.de>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, Mar 25, 2012 at 11:08:39PM +0200, Jörg Sommer escreveu:
> The tracepoint event kvm_userspace_exit uses string snippet the C
> compiler concatenates to a big string, e.g. "KVM_EXIT_" "UNKNOWN". The
> parser of the data must do the same and join successive strings.
> 
> print fmt: "reason %s (%d)", … __print_symbolic(REC->reason, { 0, "KVM_EXIT_" "UNKNOWN" }, { 1, "KVM_EXIT_" "EXCEPTION" } …
> 
> Signed-off-by: Jörg Sommer <joerg@alea.gnuu.de>
> ---
>  tools/perf/util/trace-event-parse.c |   15 +++++++++++++++
>  1 files changed, 15 insertions(+), 0 deletions(-)
> 
> diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
> index 1a8d4dc..185e284 100644
> --- a/tools/perf/util/trace-event-parse.c
> +++ b/tools/perf/util/trace-event-parse.c
> @@ -1726,6 +1726,21 @@ process_arg_token(struct event *event, struct print_arg *arg,
>  		}
>  		break;
>  	case EVENT_DQUOTE:
> +		atom = token;
> +		type = read_token_item(&token);
> +
> +		/* merge with following strings */
> +		while (type == EVENT_DQUOTE) {
> +			atom = realloc(atom, strlen(atom) + strlen(token) + 1);

realloc can fail, please check its result and take appropriate action.

- Arnaldo

> +			strcat(atom, token);
> +			free_token(token);
> +			type = read_token_item(&token);
> +		}
> +
> +		arg->type = PRINT_ATOM;
> +		arg->atom.atom = atom;
> +
> +		break;
>  	case EVENT_SQUOTE:
>  		arg->type = PRINT_ATOM;
>  		arg->atom.atom = token;
> -- 
> 1.7.9.1

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739Ab2BIBo1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 20:44:27 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:38695 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab2BIBoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 20:44:25 -0500
X-Authority-Analysis: v=2.0 cv=T9kOvo2Q c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=e8-TlU39mkIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=VnNF1IyMAAAA:8 a=CuGMnioctxv6RoJs2BIA:9 a=6kgRh1s7MLHrMZxcA9IA:7 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=iqr0Z1ZxwKlwHhAL:21 a=CT5qzadYD1h2gmX0:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1328751864.2200.125.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] perf tools: Allow expressions in __print_symbolic()
 fields
From: Steven Rostedt <rostedt@goodmis.org>
To: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>, linux-perf-users@vger.kernel.org
Date: Wed, 08 Feb 2012 20:44:24 -0500
In-Reply-To: <1315148939-14313-1-git-send-email-stefanha@linux.vnet.ibm.com>
References: <1315148939-14313-1-git-send-email-stefanha@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo,

Can you pull this patch into perf? You can add my:

Acked-by: Steven Rostedt <rostedt@goodmis.org>

Thanks!

-- Steve


On Sun, 2011-09-04 at 16:08 +0100, Stefan Hajnoczi wrote:
> The __print_symbolic() function takes a sequence of key-value pairs for
> pretty-printing a constant.  The new kvm:kvm_exit print fmt uses the
> expression:
> 
>   __print_symbolic(..., { 0x040 + 1, "DB excp" }, ...)
> 
> Currently only atoms are supported and this print fmt fails to parse.
> This patch adds support for expressions instead of just atoms so that
> 0x040 + 1 is parsed successfully.  Also add arg_num_eval() support for
> the '+' operator.
> 
> Signed-off-by: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
> ---
> The kvm:kvm_exit event was not recording enough information to format it.  I
> recently fixed this by introducing a __print_symbolic(), this commit has not
> yet hit linux.git but I think it will soon.  In order to correctly format the
> new kvm:kvm_exit, this patch to extend event parsing is required.
> 
>  tools/perf/util/trace-event-parse.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
> index 0a7ed5b..d0a4548 100644
> --- a/tools/perf/util/trace-event-parse.c
> +++ b/tools/perf/util/trace-event-parse.c
> @@ -1425,6 +1425,11 @@ static long long arg_num_eval(struct print_arg *arg)
>  				die("unknown op '%s'", arg->op.op);
>  			}
>  			break;
> +		case '+':
> +			left = arg_num_eval(arg->op.left);
> +			right = arg_num_eval(arg->op.right);
> +			val = left + right;
> +			break;
>  		default:
>  			die("unknown op '%s'", arg->op.op);
>  		}
> @@ -1485,6 +1490,13 @@ process_fields(struct event *event, struct print_flag_sym **list, char **tok)
>  
>  		free_token(token);
>  		type = process_arg(event, arg, &token);
> +
> +		if (type == EVENT_OP)
> +			type = process_op(event, arg, &token);
> +
> +		if (type == EVENT_ERROR)
> +			goto out_free;
> +
>  		if (test_type_token(type, token, EVENT_DELIM, ","))
>  			goto out_free;
>  



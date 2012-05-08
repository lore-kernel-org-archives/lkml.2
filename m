Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628Ab2EHOTX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 10:19:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26623 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755220Ab2EHOTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 10:19:22 -0400
X-Authority-Analysis: v=2.0 cv=cssZYiEi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=DP5z0Fm-GvoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=20KFwNOVAAAA:8 a=wmoV8Ok_AAAA:8 a=mPfFzUqFSPvdVt5yyicA:9 a=DRrjbNz6F0GHnCdge9UA:7 a=PUjeQqilurYA:10 a=GeWVzuwf79YA:10 a=jEp0ucaQiEUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1336486760.14207.176.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 3/4] ftrace: No return value for ftrace_process_locs
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: fweisbec@gmail.com, mingo@redhat.com, linux-kernel@vger.kernel.org
Date: Tue, 08 May 2012 10:19:20 -0400
In-Reply-To: <1335342219-2782-4-git-send-email-jolsa@redhat.com>
References: <1335342219-2782-1-git-send-email-jolsa@redhat.com>
	 <1335342219-2782-4-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-25 at 10:23 +0200, Jiri Olsa wrote:
> The return value of ftrace_process_locs is never checked. The function
> tries to update as many calls as possible and in case of error there's
> either warning output or ftrace_bug call.
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> ---
>  kernel/trace/ftrace.c |   37 ++++++++++++++++---------------------
>  1 files changed, 16 insertions(+), 21 deletions(-)
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index b3ceecd..e67f5b3 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -1930,7 +1930,7 @@ static int ops_traces_mod(struct ftrace_ops *ops)
>  	return ftrace_hash_empty(hash);
>  }
>  
> -static int ftrace_update_code(struct module *mod)
> +static void ftrace_update_code(struct module *mod)
>  {
>  	struct ftrace_page *pg;
>  	struct dyn_ftrace *p;
> @@ -1959,7 +1959,7 @@ static int ftrace_update_code(struct module *mod)
>  		for (i = 0; i < pg->index; i++) {
>  			/* If something went wrong, bail without enabling anything */
>  			if (unlikely(ftrace_disabled))
> -				return -1;
> +				return;
>  
>  			p = &pg->records[i];
>  			p->flags = ref;
> @@ -1968,8 +1968,8 @@ static int ftrace_update_code(struct module *mod)
>  			 * Do the initial record conversion from mcount jump
>  			 * to the NOP instructions.
>  			 */
> -			if (!ftrace_code_disable(mod, p))
> -				break;
> +			if (WARN_ON_ONCE(!ftrace_code_disable(mod, p)))
> +				return;

Why the warning? If ftrace_disabled is set, something broke a long time
ago, and the ftrace_bug gives its own warning.

I don't think this is needed.

-- Steve




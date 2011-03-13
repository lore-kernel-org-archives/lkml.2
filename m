Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908Ab1CMPG4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 11:06:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21618 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751622Ab1CMPGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 11:06:55 -0400
Date: Sun, 13 Mar 2011 15:58:11 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] tracing - putting cond_resched into tace_pipe loop
Message-ID: <20110313145811.GA30558@redhat.com>
References: <1299970786-8075-1-git-send-email-jolsa@redhat.com> <1299970786-8075-3-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299970786-8075-3-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12, Jiri Olsa wrote:
>
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -3237,10 +3237,23 @@ waitagain:
>  		 * One of the trace_seq_* functions is not used properly.
>  		 */
>  		WARN_ON(iter->seq.full);
> +
> +		/*
> +		 * There's a chance this loop might get quite tight,
> +		 * causing latency in non preemptive kernel.
> +		 */
> +		cond_resched();
> +		if (signal_pending(current)) {
> +			sret = -EINTR;
> +			break;

First of all: I do not pretend I understand this code ;) Still, a
couple of nits.

-EINTR doesn't look exactly right, I'd suggest -ERESTARTSYS. The same
for tracing_wait_pipe() btw, I think it should be fixed.



I wonder if it makes sense to simply "break" if signal_pending(), it
is possible we already have something to report via trace_seq_to_user().
Then we could do

	-	if (sret == -EBUSY)
	-		goto waitagain;
	+	if (sret == -EBUSY) {
	+		if (!signal_pending())
	+			goto waitagain;
	+		sret = -ERESTARTSYS;
	+	}

Or we can change tracing_wait_pipe() to check signal_pending()
uncondditionally, I dunno.

Up to you, but note that otherwise the logic looks a bit strange.
Suppose that signal_pending() is already true when we call
tracing_wait_pipe(). In this case we are going to do the "unnecessary"
work and then return EINTR/ERESTART. This is correct, the next
invocation does trace_seq_to_user() before anything else, just
looks a bit strange.

Oleg.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759304Ab2JKUnK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 16:43:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9521 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754856Ab2JKUnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 16:43:05 -0400
X-Authority-Analysis: v=2.0 cv=a96yBDuF c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=3qt6UQL6dIsA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=NrfBHxz3jJsA:10 a=06tA6L26wezkRAk1y2AA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1349988183.24256.68.camel@gandalf.local.home>
Subject: Re: [PATCH v5 3/3] tracing: Format non-nanosec times from tsc clock
 without a decimal point.
From: Steven Rostedt <rostedt@goodmis.org>
To: David Sharp <dhsharp@google.com>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Date: Thu, 11 Oct 2012 16:43:03 -0400
In-Reply-To: <1349148680-9509-3-git-send-email-dhsharp@google.com>
References: <1349148680-9509-1-git-send-email-dhsharp@google.com>
	 <1349148680-9509-3-git-send-email-dhsharp@google.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-01 at 20:31 -0700, David Sharp wrote:

>  static int
> -lat_print_timestamp(struct trace_seq *s, u64 abs_usecs,
> -		    unsigned long rel_usecs)
> +lat_print_timestamp(struct trace_iterator *iter, u64 next_ts)
>  {
> -	return trace_seq_printf(s, " %4lldus%c: ", abs_usecs,
> -				rel_usecs > preempt_mark_thresh ? '!' :
> -				  rel_usecs > 1 ? '+' : ' ');
> +	unsigned long verbose = trace_flags & TRACE_ITER_VERBOSE;
> +	unsigned long in_ns = iter->iter_flags & TRACE_FILE_TIME_IN_NS;
> +	unsigned long long abs_ts = iter->ts - iter->tr->time_start;
> +	unsigned long long rel_ts = next_ts - iter->ts;
> +	struct trace_seq *s = &iter->seq;
> +	unsigned long mark_thresh;
> +	int ret;
> +
> +	if (in_ns) {
> +		abs_ts = ns2usecs(abs_ts);
> +		rel_ts = ns2usecs(rel_ts);
> +	}
> +
> +	if (verbose && in_ns) {
> +		unsigned long abs_msec = abs_ts;
> +		unsigned long abs_usec = do_div(abs_msec, USEC_PER_MSEC);
> +		unsigned long rel_msec = rel_ts;
> +		unsigned long rel_usec = do_div(rel_msec, USEC_PER_MSEC);
> +
> +		ret = trace_seq_printf(
> +				s, "[%08llx] %ld.%03ldms (+%ld.%03ldms): ",
> +				ns2usecs(iter->ts),
> +				abs_msec, abs_usec,
> +				rel_msec, rel_usec);
> +	} else if (verbose && !in_ns) {
> +		ret = trace_seq_printf(
> +				s, "[%016llx] %lld (+%lld): ",
> +				iter->ts, abs_ts, rel_ts);
> +	} else if (!verbose && in_ns) {
> +		ret = trace_seq_printf(
> +				s, " %4lldus: ",

Missing %c.

> +				abs_ts,
> +				rel_ts > preempt_mark_thresh_us ? '!' :
> +				  rel_ts > 1 ? '+' : ' ');
> +	} else { /* !verbose && !in_ns */
> +		ret = trace_seq_printf(s, " %4lld%s%c: ", abs_ts);

Um, "%s%c" with no matching arguments.

-- Steve

> +	}
> +	return ret;
>  }
>  



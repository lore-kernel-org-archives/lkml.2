Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553Ab0EMIy0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 04:54:26 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:18442 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab0EMIyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 04:54:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:in-reply-to:references
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=JQO9P9e9SvONq8ItPB03j7o1gkt/VTM9DZcnf8+HU+kmNVM+EWndy68RWIg03vGT5B
         K+EJ9EvsiE1J69gqPp85bacRB3jYiX3nP+nwt7vifUvHydhkx3ILU+IYKZRjIAGv6WL/
         LeJA6iB7demEfHXkiSaNlIA+g9qbIKevECl5A=
Date: Thu, 13 May 2010 11:54:14 +0300
From: Pekka Paalanen <pq@iki.fi>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 3/4] tracing: Allow mmio tracer to display
 trace_printk() and other events
Message-ID: <20100513115414.7688b51d@daedalus.pq.iki.fi>
In-Reply-To: <20100513012302.352845720@goodmis.org>
References: <20100513012110.558313399@goodmis.org>
	<20100513012302.352845720@goodmis.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 May 2010 21:21:13 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> From: Steven Rostedt <srostedt@redhat.com>
> 
> The mmio tracer has its own function to handle reading of events.
> But if it encounters an event that it does not understand it
> ignores it instead of telling the calling function that it is not
> processing it.
> 
> If someone adds trace_printk() or enables events along with the
> mmio tracer, then these events will not be displayed in the trace
> output.
> 
> Simple solution is to just have the mmio print return UNHANDLED to
> let the caller know that it did not processes the event and the
> caller can process the event further.

Does this not mean that the mmiotrace output may contain
foreign lines? If it does, it will break the user space.
The dump format is specified in
Documentation/trace/mmiotrace.txt.

If you want to handle arbitrary messages, format them as
MARK events, please.

If I understood correctly, then NAK for this patch. Otherwise,
could you explain how this does not break the mmiotrace dump
format?

Is the tracing infrastructure now supporting several
active tracers at the same time? If yes, and if mmiotrace
should be able to co-operate, we need a new revision of the
dump format, or a tool that extracts the mmiotrace
events in the current format.

Thanks.

> Reported-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Pekka Paalanen <pq@iki.fi>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/trace/trace_mmiotrace.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/trace/trace_mmiotrace.c
> b/kernel/trace/trace_mmiotrace.c index 017fa37..592c00f 100644
> --- a/kernel/trace/trace_mmiotrace.c
> +++ b/kernel/trace/trace_mmiotrace.c
> @@ -282,7 +282,8 @@ static enum print_line_t
> mmio_print_line(struct trace_iterator *iter) case TRACE_PRINT:
>  		return mmio_print_mark(iter);
>  	default:
> -		return TRACE_TYPE_HANDLED; /* ignore unknown
> entries */
> +		/* Not our event */
> +		return TRACE_TYPE_UNHANDLED;
>  	}
>  }
>  
> -- 
> 1.7.0

-- 
Pekka Paalanen
http://www.iki.fi/pq/

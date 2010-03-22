Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077Ab0CVTp1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 15:45:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:40350 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755707Ab0CVTpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 15:45:23 -0400
X-Authority-Analysis: v=1.0 c=1 a=Mu4US8vvsWgA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=DfNHnWVPAAAA:8 a=d_ZOWKRBav44VayQ4fQA:9 a=XUoJ2O76a5YCg82NN-oA:7 a=GR8XvufNo3EK8U-wNuMdZK77LhMA:4 a=PUjeQqilurYA:10 a=lBRciGGoxdUA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 1/3 v3] Add tracing_off_event() to stop tracing when a
 bug or warning occur
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Chase Douglas <chase.douglas@canonical.com>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Randy Dunlap <randy.dunlap@oracle.com>
In-Reply-To: <1269283708-3556-1-git-send-email-chase.douglas@canonical.com>
References: <1269283708-3556-1-git-send-email-chase.douglas@canonical.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 22 Mar 2010 15:45:20 -0400
Message-ID: <1269287120.2957.55.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-22 at 14:48 -0400, Chase Douglas wrote:
> The tracing_off_event() function calls tracing_off() to stop tracing
> when an event occurs. By default, only BUG-type events stop tracing,
> while WARNING type events do not. This is controlled through the
> tracing_off={none,warn,bug} commandline parameter.
> 
> Call this function from bug and warning event handlers to enable a user
> to debug their kernel by starting a trace, hitting an event, and then
> retrieving trace info knowing that the trace was stopped right after the
> event was hit.
> 
> Signed-off-by: Chase Douglas <chase.douglas@canonical.com>

Please run the code through checkpatch.pl

> ---
>  include/linux/kernel.h     |    7 +++++++
>  kernel/trace/ring_buffer.c |   35 +++++++++++++++++++++++++++++++++++
>  2 files changed, 42 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 7f07074..a19d545 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -478,16 +478,23 @@ static inline char *pack_hex_byte(char *buf, u8 byte)
>   *
>   * Most likely, you want to use tracing_on/tracing_off.
>   */
> +typedef enum {
> +	TRACE_EVENT_BUG = 0,
> +	TRACE_EVENT_WARN,
> +} trace_event_t;

No need for a typedef here.

> +
>  #ifdef CONFIG_RING_BUFFER
>  void tracing_on(void);
>  void tracing_off(void);
>  /* trace_off_permanent stops recording with no way to bring it back */
>  void tracing_off_permanent(void);
> +void tracing_off_event(trace_event_t event);
>  int tracing_is_on(void);
>  #else
>  static inline void tracing_on(void) { }
>  static inline void tracing_off(void) { }
>  static inline void tracing_off_permanent(void) { }
> +static inline void tracing_off_event(trace_event_t event) { }
>  static inline int tracing_is_on(void) { return 0; }
>  #endif
>  #ifdef CONFIG_TRACING
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index 0287f9f..6a5f535 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -193,6 +193,41 @@ void tracing_off_permanent(void)
>  	set_bit(RB_BUFFERS_DISABLED_BIT, &ring_buffer_flags);
>  }
>  
> +static trace_event_t tracing_off_event_ctrl = TRACE_EVENT_BUG;
> +
> +/**
> + * tracing_off_event - turn off tracing depending on event type
> + * @event: type of event that occurred
> + *
> + * This function checks the event type to determine whether tracing should be
> + * disabled. Useful for disabling tracing on bugs or warnings.
> + */
> +void tracing_off_event(trace_event_t event)
> +{
> +	if (event <= tracing_off_event_ctrl)
> +		tracing_off();
> +}
> +EXPORT_SYMBOL_GPL(tracing_off_event);
> +
> +static int __init tracing_off_event_setup(char *str)
> +{
> +	if (!strcmp("none", str))
> +		tracing_off_event_ctrl = -1;
> +	else if (!strcmp("bug", str))
> +		tracing_off_event_ctrl = TRACE_EVENT_BUG;
> +	else if (!strcmp("warn", str))
> +		tracing_off_event_ctrl = TRACE_EVENT_WARN;
> +	else
> +	{

Must be "else {"

-- Steve

> +		printk(KERN_NOTICE "Invalid value passed for tracing_off parameter\n");
> +		return 1;
> +	}
> +
> +	return 0;
> +}
> +
> +__setup("tracing_off=", tracing_off_event_setup);
> +
>  /**
>   * tracing_is_on - show state of ring buffers enabled
>   */



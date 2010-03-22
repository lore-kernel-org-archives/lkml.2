Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181Ab0CVQP2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 12:15:28 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:32877 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755154Ab0CVQP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 12:15:26 -0400
Date: Mon, 22 Mar 2010 09:14:20 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Chase Douglas <chase.douglas@canonical.com>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 1/3] Add tracing_off_event() to stop tracing when a bug
 or warning occur
Message-Id: <20100322091420.a12739f2.randy.dunlap@oracle.com>
In-Reply-To: <1268920132-30512-1-git-send-email-chase.douglas@canonical.com>
References: <1268920132-30512-1-git-send-email-chase.douglas@canonical.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4BA79799.00F4:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Mar 2010 09:48:50 -0400 Chase Douglas wrote:

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
> ---
>  include/linux/kernel.h     |    5 +++++
>  kernel/trace/ring_buffer.c |   34 ++++++++++++++++++++++++++++++++++
>  2 files changed, 39 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 7f07074..107091f 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -478,16 +478,21 @@ static inline char *pack_hex_byte(char *buf, u8 byte)
>   *
>   * Most likely, you want to use tracing_on/tracing_off.
>   */
> +#define TRACE_EVENT_BUG 0
> +#define TRACE_EVENT_WARN 1
> +
>  #ifdef CONFIG_RING_BUFFER
>  void tracing_on(void);
>  void tracing_off(void);
>  /* trace_off_permanent stops recording with no way to bring it back */
>  void tracing_off_permanent(void);
> +void tracing_off_event(long event);
>  int tracing_is_on(void);
>  #else
>  static inline void tracing_on(void) { }
>  static inline void tracing_off(void) { }
>  static inline void tracing_off_permanent(void) { }
> +static inline void tracing_off_event(long event) { }
>  static inline int tracing_is_on(void) { return 0; }
>  #endif
>  #ifdef CONFIG_TRACING
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index 0287f9f..b148862 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -193,6 +193,40 @@ void tracing_off_permanent(void)
>  	set_bit(RB_BUFFERS_DISABLED_BIT, &ring_buffer_flags);
>  }
>  
> +static long tracing_event_mask = TRACE_EVENT_BUG;
> +
> +/**
> + * tracing_off_event - turn off tracing depending on event type

Please add the function parameter to the kernel-doc to make it complete
& prevent warnings;  something like:

 * @event: which event happened


> + *
> + * This function checks the event type to determine whether tracing should be
> + * disabled. Useful for disabling tracing on bugs or warnings.
> + */
> +void tracing_off_event(long event)
> +{
> +	if (event <= tracing_event_mask)
> +		tracing_off();
> +}
> +EXPORT_SYMBOL_GPL(tracing_off_event);
> +
> +static int __init tracing_off_event_setup(char *str)
> +{
> +	if (!strcmp("none", str))
> +		tracing_event_mask = -1;
> +	else if (!strcmp("bug", str))
> +		tracing_event_mask = TRACE_EVENT_BUG;
> +	else if (!strcmp("warn", str))
> +		tracing_event_mask = TRACE_EVENT_WARN;
> +	else
> +	{
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
> -- 


---
~Randy

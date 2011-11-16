Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757885Ab1KPOP6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 09:15:58 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:58476 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757766Ab1KPOP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 09:15:57 -0500
X-Authority-Analysis: v=2.0 cv=Pdt9d1dd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=l4wf8OQxcBQA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=QyXUC8HyAAAA:8 a=h8ME-5bNdfUv_24Q1ZQA:9 a=t0PPo93HVTV8fbKxZugA:7 a=QEXdDO2ut3YA:10 a=dGJ0OcVc7YAA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH] tracing: add trace console
From: Steven Rostedt <rostedt@goodmis.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1321438728.4773.16.camel@jlt3.sipsolutions.net>
References: <1321438728.4773.16.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Nov 2011 09:15:54 -0500
Message-ID: <1321452954.4181.20.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Added Peter, Thomas and Andrew ]

On Wed, 2011-11-16 at 11:18 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> As described in the Kconfig entry, logging printk
> output is useful to correlate (existing) printk
> debugging with (existing) tracing. The easiest way
> to achieve this is to register a console that just
> calls trace_printk(), which this module does.

I'm good with this. Anyone have any issues with it?

-- Steve

> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  kernel/trace/Kconfig         |   13 ++++++++++
>  kernel/trace/Makefile        |    2 +
>  kernel/trace/trace-console.c |   55 +++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 70 insertions(+)
> 
> --- a/kernel/trace/Kconfig	2011-11-16 11:11:27.000000000 +0100
> +++ b/kernel/trace/Kconfig	2011-11-16 11:11:35.000000000 +0100
> @@ -368,6 +368,19 @@ config BLK_DEV_IO_TRACE
>  
>  	  If unsure, say N.
>  
> +config TRACE_CONSOLE
> +	tristate "Support for a tracing console"
> +	help
> +	  Say M (or Y if you must, but this is not recommended) to be able
> +	  to get a tracing console that puts every kernel message into the
> +	  tracing infrastructure using trace_printk(). This is useful to
> +	  correlate (existing) printk debugging with tracing. When using it
> +	  remember to set the console level, e.g. with "dmesg -n8".
> +
> +	  The module is called trace-console.
> +
> +	  Say N if unsure.
> +
>  config KPROBE_EVENT
>  	depends on KPROBES
>  	depends on HAVE_REGS_AND_STACK_ACCESS_API
> --- a/kernel/trace/Makefile	2011-11-16 11:11:27.000000000 +0100
> +++ b/kernel/trace/Makefile	2011-11-16 11:11:35.000000000 +0100
> @@ -62,4 +62,6 @@ ifeq ($(CONFIG_TRACING),y)
>  obj-$(CONFIG_KGDB_KDB) += trace_kdb.o
>  endif
>  
> +obj-$(CONFIG_TRACE_CONSOLE) += trace-console.o
> +
>  libftrace-y := ftrace.o
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ b/kernel/trace/trace-console.c	2011-11-16 11:11:35.000000000 +0100
> @@ -0,0 +1,55 @@
> +/*
> + * Copyright (c) 2011 Intel Corporation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> + *
> + * The full GNU General Public License is included in this distribution in
> + * the file called COPYING.
> + *
> + * Author: Johannes Berg <johannes.berg@intel.com>
> + */
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/console.h>
> +
> +MODULE_AUTHOR("Johannes Berg <johannes.berg@intel.com>");
> +MODULE_DESCRIPTION("Console driver for tracing");
> +MODULE_LICENSE("GPL");
> +
> +
> +static void trace_msg(struct console *con, const char *msg, unsigned int len)
> +{
> +	trace_printk("%*s", len, msg);
> +}
> +
> +static struct console traceconsole = {
> +	.name	= "tracecon",
> +	.flags	= CON_ENABLED,
> +	.write	= trace_msg,
> +};
> +
> +static int __init init_traceconsole(void)
> +{
> +	register_console(&traceconsole);
> +	return 0;
> +}
> +
> +static void __exit exit_traceconsole(void)
> +{
> +	unregister_console(&traceconsole);
> +}
> +
> +module_init(init_traceconsole);
> +module_exit(exit_traceconsole);
> 



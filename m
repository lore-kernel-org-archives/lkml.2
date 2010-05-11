Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757778Ab0EKDae (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 23:30:34 -0400
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:44839 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751417Ab0EKDad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 23:30:33 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAI5s6EtGHnqu/2dsb2JhbACeI3K6b4UUBA
Date: Mon, 10 May 2010 23:30:27 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 10/10 -v3][RFC] tracing: Combine event filter_active
	and enable into single flags field
Message-ID: <20100511033026.GA28162@Krystal>
References: <20100511030020.837892321@goodmis.org> <20100511030911.927339838@goodmis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20100511030911.927339838@goodmis.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 23:27:54 up 33 days, 13:21,  3 users,  load average: 0.49, 0.46,
	0.58
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> The filter_active and enable both use an int (4 bytes each) to
> set a single flag. We can save 4 bytes per event by combining the
> two into a single integer.
> 
>    text	   data	    bss	    dec	    hex	filename
> 5788186	1337252	9351592	16477030	 fb6b66	vmlinux.orig
> 5761074	1262596	9351592	16375262	 f9ddde	vmlinux.id
> 5761007	1256916	9351592	16369515	 f9c76b	vmlinux.flags
> 
> This gives us another 5K in savings.
> 
> The modification of both the enable and filter fields are done
> under the event_mutex, so it is still safe to combine the two.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
[...]
>  struct ftrace_event_call {
>  	struct list_head	list;
>  	struct ftrace_event_class *class;
> @@ -154,8 +164,15 @@ struct ftrace_event_call {
>  	void			*mod;
>  	void			*data;
>  
> -	int			enabled;
> -	int			filter_active;
> +	/*
> +	 * 32 bit flags:
> +	 *   bit 1:		enabled
> +	 *   bit 2:		filter_active
> +	 *
> +	 *  Must hold event_mutex to change.
> +	 */
> +	unsigned int		flags;
> +

I would also comment about flags read-side:

 * Flags are read concurrently without locking.

Besides that minor nit, the whole patchset has my

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

Thanks!

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com

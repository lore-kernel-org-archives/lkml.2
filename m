Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074Ab2ITNGS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 09:06:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4034 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249Ab2ITNGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 09:06:16 -0400
Date: Thu, 20 Sep 2012 09:05:45 -0400
From: Eric Paris <eparis@redhat.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        jlayton@redhat.com
Subject: Re: [PATCH 1/1] audit: Use a tracepoint for getname
Message-ID: <20120920090545.465ca00d@redhat.com>
In-Reply-To: <20120919225659.GA11325@ghostprotocols.net>
References: <20120919225659.GA11325@ghostprotocols.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cc'ing Jeff Layton who has recently done a lot of getname work and I
want to make sure he sees this.


On Wed, 19 Sep 2012 15:56:59 -0700
Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:

> Al, Eric,
> 
> 	Was this considered before? Acceptable?
> 
> - Arnaldo
> 
> ---
> 
> Instead of an explicit hook only for audit, use a tracepoint, so that
> other users that need to know about filenames can hook there just like
> audit.

> @@ -978,6 +986,9 @@ static int __init audit_init(void)
>  	else
>  		audit_sock->sk_sndtimeo = MAX_SCHEDULE_TIMEOUT;
>  
> +	if (register_trace_getname(audit_getname, NULL))
> +		audit_panic("cannot register getname tracepoint");
> +
>  	skb_queue_head_init(&audit_skb_queue);
>  	skb_queue_head_init(&audit_skb_hold_queue);
>  	audit_initialized = AUDIT_INITIALIZED;

I think we need to just use panic instead of audit_panic.  This early
at boot userspace would not have been able to tell the kernel that
audit_panic == panic nor would the box die later if userspace ask for
that functionality.  Instead the box would run but audit would be
broken, which customers who want audit_panic == panic would be most
upset about.

Otherwise, its good to me.

-Eric

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858Ab2ITPLp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 11:11:45 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45249 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755712Ab2ITPLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 11:11:43 -0400
Date: Thu, 20 Sep 2012 08:11:36 -0700
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Eric Paris <eparis@redhat.com>
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
Message-ID: <20120920151136.GD11325@ghostprotocols.net>
References: <20120919225659.GA11325@ghostprotocols.net>
 <20120920090545.465ca00d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120920090545.465ca00d@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Sep 20, 2012 at 09:05:45AM -0400, Eric Paris escreveu:
> cc'ing Jeff Layton who has recently done a lot of getname work and I
> want to make sure he sees this.

Thanks, will try with his patchset applied, but see below...
 
> On Wed, 19 Sep 2012 15:56:59 -0700
> Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:
> > @@ -978,6 +986,9 @@ static int __init audit_init(void)
> >  	else
> >  		audit_sock->sk_sndtimeo = MAX_SCHEDULE_TIMEOUT;
> >  
> > +	if (register_trace_getname(audit_getname, NULL))
> > +		audit_panic("cannot register getname tracepoint");
> > +
> >  	skb_queue_head_init(&audit_skb_queue);
> >  	skb_queue_head_init(&audit_skb_hold_queue);
> >  	audit_initialized = AUDIT_INITIALIZED;
> 
> I think we need to just use panic instead of audit_panic.  This early

I don't have an opinion on that matter, just used what is done on the 'true'
part of that other else, some lines above the register_trace_getname if:

        audit_sock = netlink_kernel_create(&init_net, NETLINK_AUDIT,
                                           THIS_MODULE, &cfg);
        if (!audit_sock)
                audit_panic("cannot initialize netlink socket");
        else
                audit_sock->sk_sndtimeo = MAX_SCHEDULE_TIMEOUT;

> at boot userspace would not have been able to tell the kernel that
> audit_panic == panic nor would the box die later if userspace ask for
> that functionality.  Instead the box would run but audit would be

But then why audit_panic is called when netlink_kernel_create fails?

> broken, which customers who want audit_panic == panic would be most
> upset about.
> 
> Otherwise, its good to me.

Thanks!

- Arnaldo

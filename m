Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab1K2KIA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 05:08:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47226 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753924Ab1K2KH6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 05:07:58 -0500
Date: Tue, 29 Nov 2011 11:07:42 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: fweisbec@gmail.com, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 4/9] ftrace: Add enable/disable ftrace_ops control
 interface
Message-ID: <20111129100742.GA1602@m.brq.redhat.com>
References: <1322417074-5834-1-git-send-email-jolsa@redhat.com>
 <1322417074-5834-5-git-send-email-jolsa@redhat.com>
 <1322511693.17003.30.camel@frodo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322511693.17003.30.camel@frodo>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 03:21:33PM -0500, Steven Rostedt wrote:
> 
> >  
> > @@ -311,6 +321,9 @@ static int __unregister_ftrace_function(struct ftrace_ops *ops)
> >  	if (ret < 0)
> >  		return ret;
> >  
> > +	if (ops->flags & FTRACE_OPS_FL_CONTROL)
> > +		jump_label_dec(&ftrace_ops_control);
> > +
> >  	if (ftrace_enabled)
> >  		update_ftrace_function();
> >  
> > @@ -3577,8 +3590,14 @@ ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip)
> >  	preempt_disable_notrace();
> >  	op = rcu_dereference_raw(ftrace_ops_list);
> >  	while (op != &ftrace_list_end) {
> > +		if (static_branch(&ftrace_ops_control))
> 
> Instead of doing a static_branch() here, which makes me really nervous,
> because this is called in function trace context, which has some strict
> rules of its own, and is probably prone to recursion, we could add
> another "ops" similar to the global_ops.
> 
> We could make a control_ops, and add all ops with the
> FTRACE_OPS_FL_CONTROL flag set to it. And then this function will have
> its own loop that it will check the disabled flag, for the ops
> registered to it.
> 
> This code doesn't need to be touched, we just add a layer of redirection
> for control ops and it will solve the jump_label issue.

sounds good, I'll make the change

thanks,
jirka

> 
> -- Steve
> 
> > +			if ((op->flags & FTRACE_OPS_FL_CONTROL) &&
> > +			    atomic_read(&op->disabled))
> > +				goto next;
> > +
> >  		if (ftrace_ops_test(op, ip))
> >  			op->func(ip, parent_ip);
> > + next:
> >  		op = rcu_dereference_raw(op->next);
> >  	};
> >  	preempt_enable_notrace();
> 
> 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab1K1UVh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 15:21:37 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:61966 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985Ab1K1UVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 15:21:36 -0500
X-Authority-Analysis: v=2.0 cv=dOUkaZlb c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=6ethm6nK9TkA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=iDWzb0xajQmwM6VxoM0A:9 a=abfTwDWtVDxc_ewlnQQA:7 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH 4/9] ftrace: Add enable/disable ftrace_ops control
 interface
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: fweisbec@gmail.com, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <1322417074-5834-5-git-send-email-jolsa@redhat.com>
References: <1322417074-5834-1-git-send-email-jolsa@redhat.com>
	 <1322417074-5834-5-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Nov 2011 15:21:33 -0500
Message-ID: <1322511693.17003.30.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>  
> @@ -311,6 +321,9 @@ static int __unregister_ftrace_function(struct ftrace_ops *ops)
>  	if (ret < 0)
>  		return ret;
>  
> +	if (ops->flags & FTRACE_OPS_FL_CONTROL)
> +		jump_label_dec(&ftrace_ops_control);
> +
>  	if (ftrace_enabled)
>  		update_ftrace_function();
>  
> @@ -3577,8 +3590,14 @@ ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip)
>  	preempt_disable_notrace();
>  	op = rcu_dereference_raw(ftrace_ops_list);
>  	while (op != &ftrace_list_end) {
> +		if (static_branch(&ftrace_ops_control))

Instead of doing a static_branch() here, which makes me really nervous,
because this is called in function trace context, which has some strict
rules of its own, and is probably prone to recursion, we could add
another "ops" similar to the global_ops.

We could make a control_ops, and add all ops with the
FTRACE_OPS_FL_CONTROL flag set to it. And then this function will have
its own loop that it will check the disabled flag, for the ops
registered to it.

This code doesn't need to be touched, we just add a layer of redirection
for control ops and it will solve the jump_label issue.

-- Steve

> +			if ((op->flags & FTRACE_OPS_FL_CONTROL) &&
> +			    atomic_read(&op->disabled))
> +				goto next;
> +
>  		if (ftrace_ops_test(op, ip))
>  			op->func(ip, parent_ip);
> + next:
>  		op = rcu_dereference_raw(op->next);
>  	};
>  	preempt_enable_notrace();



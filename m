Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923Ab1CKDiD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 22:38:03 -0500
Received: from ozlabs.org ([203.10.76.45]:56755 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573Ab1CKDiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 22:38:00 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        chris <chris@chris-wilson.co.uk>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH][RFC] tracing: Enable tracepoints via module parameters
In-Reply-To: <1299622684.20306.77.camel@gandalf.stny.rr.com>
References: <1299622684.20306.77.camel@gandalf.stny.rr.com>
User-Agent: Notmuch/0.3.1 (http://notmuchmail.org) Emacs/23.1.1 (i686-pc-linux-gnu)
Date: Fri, 11 Mar 2011 10:03:09 +1030
Message-ID: <877hc64klm.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Mar 2011 17:18:04 -0500, Steven Rostedt <rostedt@goodmis.org> wrote:
> A few months ago it was suggested to have a way to enable tracepoints in
> a module when it is loaded. I tried various methods, but this one seems
> to be the least intrusive. In fact, it requires no modification to the
> module code.

This seems quite nice!

Importantly, do you like it better than the previous version?  I like it
because it doesn't touch my code, but that's not a fair test.

A few minor things:
1) Can we document this somewhere more persistent too? ftrace.txt?
2) Your documentation should probably just use "trace_foo_bar" and omit
   the "=1".  Because we can :)
3) Can we share more with param_set_bool?  Nice to have it in one place
   when someone decides the kernel really needs to accept "=true" or
   whatever.
4) =n should really unset the flag, so args fight correctly.

eg (wildly untested):

int ftrace_mod_param_set(const char *val, const struct kernel_param *kp)
{
	struct ftrace_event_call *call = kp->arg;
        struct kernel_param bool_kp;
        bool set;
        int err;

        /* We work exactly like param_set_bool. */
        bool_kp.arg = &set;
        bool_kp.flags = KPARAM_ISBOOL;
        err = param_set_bool(val, &bool_kp);
        if (err)
                return err;

       	/* Set flag to tell ftrace to enable this event on init */
        if (set)
                call->flags = TRACE_EVENT_FL_MOD_ENABLE;
        else
                call->flags &= ~TRACE_EVENT_FL_MOD_ENABLE;

	return 0;
}

Cheers,
Rusty.

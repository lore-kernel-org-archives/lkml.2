Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990Ab1IFULh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 16:11:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17564 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754123Ab1IFULd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 16:11:33 -0400
Date: Tue, 6 Sep 2011 22:08:18 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Add new PTRACE_O_TRACESTOP option, make it control
	new ptrace behavior.
Message-ID: <20110906200818.GA28349@redhat.com>
References: <201109042311.18793.vda.linux@googlemail.com> <1315242384.1888.64.camel@dhcp-25-63.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315242384.1888.64.camel@dhcp-25-63.brq.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05, Denys Vlasenko wrote:
>
> Add new PTRACE_O_TRACESTOP option, make it control new ptrace behavior.
>
> Introduce new ptrace option, PTRACE_O_TRACESTOP. This makes API
> more symmetric: every PTRACE_EVENT_event has corresponding PTRACE_O_TRACEevent now,
> as it used to have before PTRACE_SEIZE was introduced.
>
> PTRACE_SEIZE does not assume PTRACE_O_TRACESTOP, but with this patch
> it allows any PTRACE_O_opts to be set at attach time

Well. This assumes that the only difference with PTRACE_SEIZE is the
new stop/interrupt behaviour. I am not sure this is "safe" to assume.

Tejun, what do you think?

>From the correctness pov, the patch is mostly correct. but you forgot
to update ptrace_init_task(). I bet you didn't try to test the patch ;)

>  int ptrace_request(struct task_struct *child, long request,
>  		   unsigned long addr, unsigned long data)
>  {
> -	bool seized = child->ptrace & PT_SEIZED;
> +	bool stop_events_enabled = child->ptrace & PT_TRACE_STOP;

May be ptrace_event_enabled(child, PTRACE_EVENT_STOP) looks better...
The same about other PT_TRACE_STOP checks, although this is cosmetic.


And. Given that you can set/clear PT_TRACE_STOP in ptrace_setoptions(),
you need the locking.

Just for example. do_signal_stop() calls ptrace_trap_notify() and hits
WARN_ON_ONCE(!PT_TRACE_STOP) because it was cleared in between.

Oleg.


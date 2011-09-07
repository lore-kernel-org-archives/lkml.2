Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462Ab1IGEzM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 00:55:12 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48441 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770Ab1IGEzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 00:55:09 -0400
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 2/2] Add new PTRACE_O_TRACESTOP option, make it control new ptrace behavior.
Date: Wed, 7 Sep 2011 06:55:05 +0200
User-Agent: KMail/1.8.2
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
References: <201109042311.18793.vda.linux@googlemail.com> <1315242384.1888.64.camel@dhcp-25-63.brq.redhat.com> <20110906200818.GA28349@redhat.com>
In-Reply-To: <20110906200818.GA28349@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201109070655.05898.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 September 2011 22:08, Oleg Nesterov wrote:
> On 09/05, Denys Vlasenko wrote:
> >
> > Add new PTRACE_O_TRACESTOP option, make it control new ptrace behavior.
> >
> > Introduce new ptrace option, PTRACE_O_TRACESTOP. This makes API
> > more symmetric: every PTRACE_EVENT_event has corresponding PTRACE_O_TRACEevent now,
> > as it used to have before PTRACE_SEIZE was introduced.
> >
> > PTRACE_SEIZE does not assume PTRACE_O_TRACESTOP, but with this patch
> > it allows any PTRACE_O_opts to be set at attach time
> 
> Well. This assumes that the only difference with PTRACE_SEIZE is the
> new stop/interrupt behaviour. I am not sure this is "safe" to assume.

I'd say that with this change, PTRACE_SEIZE is just PTRACE_ATTACH
with the possibility to set options on attach. Nothing more.

> Tejun, what do you think?


> >  int ptrace_request(struct task_struct *child, long request,
> >  		   unsigned long addr, unsigned long data)
> >  {
> > -	bool seized = child->ptrace & PT_SEIZED;
> > +	bool stop_events_enabled = child->ptrace & PT_TRACE_STOP;
> 
> May be ptrace_event_enabled(child, PTRACE_EVENT_STOP) looks better...
> The same about other PT_TRACE_STOP checks, although this is cosmetic.

Good idea. I will send a new patch a bit later.

> And. Given that you can set/clear PT_TRACE_STOP in ptrace_setoptions(),
> you need the locking.
>
> Just for example. do_signal_stop() calls ptrace_trap_notify() and hits
> WARN_ON_ONCE(!PT_TRACE_STOP) because it was cleared in between.

PTRACE_SETOPTIONS can be used only on stopped tracees. Can do_signal_stop()
run on a tracee while it is stopped?

-- 
vda

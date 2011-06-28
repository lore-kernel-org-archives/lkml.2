Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759627Ab1F1Qic (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 12:38:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63711 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759598Ab1F1QhK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 12:37:10 -0400
Date: Tue, 28 Jun 2011 18:35:12 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptrace: make former thread ID available via
	PTRACE_GETEVENTMSG after PTRACE_EVENT_EXEC stop (v.2)
Message-ID: <20110628163512.GA11937@redhat.com>
References: <201106262108.43011.vda.linux@googlemail.com> <20110626200442.GA16293@redhat.com> <20110627081139.GY30101@htj.dyndns.org> <20110627134713.GB3527@redhat.com> <20110627135252.GB30101@htj.dyndns.org> <20110627151827.GA6223@redhat.com> <20110628082512.GA3386@htj.dyndns.org> <BANLkTik2KqKGwBAqN+CSz7_ergx5VM9x4A@mail.gmail.com> <20110628123823.GD3386@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110628123823.GD3386@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28, Tejun Heo wrote:
>
> Hello,
>
> On Tue, Jun 28, 2011 at 02:30:36PM +0200, Denys Vlasenko wrote:
> > On Tue, Jun 28, 2011 at 10:25 AM, Tejun Heo <tj@kernel.org> wrote:
> > > On Mon, Jun 27, 2011 at 05:18:27PM +0200, Oleg Nesterov wrote:
> > > Yeah, but that's a pretty silly way to do it.  If we make it depend on
> > > PT_SEIZED, we can simply say "if seized, EXEC reports..." but as it
> > > currently stands, it would go like "If the message is non-zero on
> > > EXEC, it indicates...  This behavior is valid since kernel version
> > > x.x.x".
> >
> > This is true for any new addition to API.
> > It starts from some kernel version.
>
> Hmmm... but as I wrote above, we have a choice to make here and the
> two options are clearly different?

I do not really understand your concerns. Yes, yes, yes, if we do not
bind this feauture with PT_SEIZED, then the application has to take
care _if_ it wants to use it without PT_SEIZED. So what? This is the
problem of that application. This change can't break the application
which do not want or do not know about this feature.


And how can we bind it to PT_SEIZED? We can't do something like

	old_pid = 0;
	if (PT_SEIZED) {
		old_pid = task_pid_nr_ns(...);
	}

	...

	ptrace_event(PTRACE_EVENT_EXEC, old_pid);

in search_binary_handler(), this is racy, the tracer can attach in the
window and we want to avoid SIGTRAP.

So, we should pass the valid old_pid to ptrace_event() unconditionally
(btw, Denys, I think we should do this anyway, but perhaps we can do
this later) and then uglify ptrace_event() somehow.

Say,

	static inline void ptrace_event(int event, unsigned long message)
	{
+		if (event == PTRACE_EVENT_EXEC && !PT_SEIZED)
+			message = 0;

		if (unlikely(ptrace_event_enabled(current, event))) {
			current->ptrace_message = message;
			ptrace_notify((event << 8) | SIGTRAP);
		} else if (event == PTRACE_EVENT_EXEC && unlikely(current->ptrace)) {
			/* legacy EXEC report via SIGTRAP */
			send_sig(SIGTRAP, current, 0);
		}
	}

looks a bit ugly. Or, perhaps,

	static inline void ptrace_event(int event, unsigned long message)
	{
		bool enabled = ptrace_event_enabled(current, event);

		if (event == PTRACE_EVENT_EXEC) {
			if (PT_SEIZED) {
				enabled = true;
			} else {
				if (!enabled) {
					send_sig(SIGTRAP, current, 0);
					return;
				}
				message = 0;
			}
		}

		if (enabled) {
			current->ptrace_message = message;
			ptrace_notify((event << 8) | SIGTRAP);
		}
	}

a bit better, bit still not very nice. For what? I tend to agree with
Denys, and I think we should listen to the user-space developer who
actually uses ptrace.


That said, I leave it to you and Denys, personally I am fine either way.

FYI, I need to disappear till Thursday.

Oleg.


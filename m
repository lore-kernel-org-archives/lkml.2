Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582Ab1IFBF2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 21:05:28 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46901 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab1IFBFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 21:05:22 -0400
From: Denys Vlasenko <vda.linux@googlemail.com>
To: "Indan Zupancic" <indan@nul.nu>
Subject: Re: RFC: PTRACE_SEIZE needs API cleanup?
Date: Tue, 6 Sep 2011 03:05:19 +0200
User-Agent: KMail/1.8.2
Cc: "Denys Vlasenko" <dvlasenk@redhat.com>, "Oleg Nesterov" <oleg@redhat.com>,
        "Tejun Heo" <tj@kernel.org>, linux-kernel@vger.kernel.org
References: <201109042311.18793.vda.linux@googlemail.com> <1315231572.1888.35.camel@dhcp-25-63.brq.redhat.com> <a9c6784bdb67df6d1eb8ccbdefec4e7f.squirrel@webmail.greenhost.nl>
In-Reply-To: <a9c6784bdb67df6d1eb8ccbdefec4e7f.squirrel@webmail.greenhost.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201109060305.19607.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 September 2011 19:44, Indan Zupancic wrote:
> On Mon, September 5, 2011 16:06, Denys Vlasenko wrote:
> > In case you meant that "if we request group-stop notifications by using
> > __WALL | WSTOPPED, and we get group-stop notification, and we do
> > PTRACE_CONT, then task does not run (it sits in group-stop until SIGCONT
> > or death)", then we have a problem: gdb can't use this interface, it
> > needs to be able to restart the thread (only one thread, not all of
> > them, so sending SIGCONT is not ok!) from the group-stop. Yes, it's
> > weird, but it's the real requirement from gdb users.
> [...]
> > SIGCONT's side effect of waking up from group-stop can't be blocked.
> > SIGCONT always wakes up all threads in thread group.
> > Using SIGCONT to control tracee will race with SIGCONTs from other
> > sources.
> >
> > This makes SIGCONT a too coarse instrument for the job.
> [...]
> > Yes... until gdb will want to give user a choice after SIGSTOP: continue
> > to sit in group-stop until SIGCONT (wasn't possible until
> > PTRACE_LISTEN), or continue executing (gdb's current behavior if user
> > uses "continue" command). Therefore, gdb needs a way to do both.
> 
> Having thought a bit more about this, I think this is less of a problem
> than it seems, because for a group stop we get a ptrace event for each
> task, and this should be true for SIGCONT as well. So gdb could also
> always let the group stop happen, and only when prompted to do so by
> a user, continue one thread by sending SIGCONT and letting all the other
> threads hang in trapped state.

Won't work. SIGCONT unpauses all threads in the thread group,
and _then_ it is delivered to one of the threads. You can block
or ignore it, yes, but it is too late: the unpausing already happened,
and blocking/ignoring will only affect SIGCONT handler execution,
if the program has one.

-- 
vda

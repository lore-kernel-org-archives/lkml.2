Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847Ab1IFRT0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 13:19:26 -0400
Received: from smarthost1.greenhost.nl ([195.190.28.78]:41618 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab1IFRTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 13:19:21 -0400
Message-ID: <400150a2d773c6b7dd8f88e1b74c883d.squirrel@webmail.greenhost.nl>
In-Reply-To: <201109060305.19607.vda.linux@googlemail.com>
References: <201109042311.18793.vda.linux@googlemail.com>
    <1315231572.1888.35.camel@dhcp-25-63.brq.redhat.com>
    <a9c6784bdb67df6d1eb8ccbdefec4e7f.squirrel@webmail.greenhost.nl>
    <201109060305.19607.vda.linux@googlemail.com>
Date: Tue, 6 Sep 2011 19:19:00 +0200
Subject: Re: RFC: PTRACE_SEIZE needs API cleanup?
From: "Indan Zupancic" <indan@nul.nu>
To: "Denys Vlasenko" <vda.linux@googlemail.com>
Cc: "Denys Vlasenko" <dvlasenk@redhat.com>, "Oleg Nesterov" <oleg@redhat.com>,
        "Tejun Heo" <tj@kernel.org>, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.0
X-Scan-Signature: 74bd734068bee68206891dc8710ce62a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, September 6, 2011 03:05, Denys Vlasenko wrote:
> On Monday 05 September 2011 19:44, Indan Zupancic wrote:
>> On Mon, September 5, 2011 16:06, Denys Vlasenko wrote:
>> > In case you meant that "if we request group-stop notifications by using
>> > __WALL | WSTOPPED, and we get group-stop notification, and we do
>> > PTRACE_CONT, then task does not run (it sits in group-stop until SIGCONT
>> > or death)", then we have a problem: gdb can't use this interface, it
>> > needs to be able to restart the thread (only one thread, not all of
>> > them, so sending SIGCONT is not ok!) from the group-stop. Yes, it's
>> > weird, but it's the real requirement from gdb users.
>> [...]
>> > SIGCONT's side effect of waking up from group-stop can't be blocked.
>> > SIGCONT always wakes up all threads in thread group.
>> > Using SIGCONT to control tracee will race with SIGCONTs from other
>> > sources.
>> >
>> > This makes SIGCONT a too coarse instrument for the job.
>> [...]
>> > Yes... until gdb will want to give user a choice after SIGSTOP: continue
>> > to sit in group-stop until SIGCONT (wasn't possible until
>> > PTRACE_LISTEN), or continue executing (gdb's current behavior if user
>> > uses "continue" command). Therefore, gdb needs a way to do both.
>>
>> Having thought a bit more about this, I think this is less of a problem
>> than it seems, because for a group stop we get a ptrace event for each
>> task, and this should be true for SIGCONT as well. So gdb could also
>> always let the group stop happen, and only when prompted to do so by
>> a user, continue one thread by sending SIGCONT and letting all the other
>> threads hang in trapped state.
>
> Won't work. SIGCONT unpauses all threads in the thread group,
> and _then_ it is delivered to one of the threads.

No, it is delivered to _all_ threads. With current ptrace you never see a
SIGCONT, but it should behave the same as SIGSTOP, which results in one
ptrace event for each thread.

> You can block
> or ignore it, yes, but it is too late: the unpausing already happened,
> and blocking/ignoring will only affect SIGCONT handler execution,
> if the program has one.

Not doing PTRACE_CONT will keep the thread hanging in trapped state.
All threads get a SIGCONT, not only one, so you can pause all threads
this way.

Greetings,

Indan



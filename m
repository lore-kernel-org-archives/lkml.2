Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996Ab1IGQGz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:06:55 -0400
Received: from smarthost1.greenhost.nl ([195.190.28.78]:53786 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283Ab1IGQGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:06:45 -0400
Message-ID: <c0d6265ba03f6fbc1658d3281b037b8a.squirrel@webmail.greenhost.nl>
In-Reply-To: <201109070447.45193.vda.linux@googlemail.com>
References: <201109042311.18793.vda.linux@googlemail.com>
    <201109060305.19607.vda.linux@googlemail.com>
    <400150a2d773c6b7dd8f88e1b74c883d.squirrel@webmail.greenhost.nl>
    <201109070447.45193.vda.linux@googlemail.com>
Date: Wed, 7 Sep 2011 16:24:13 +0200
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
X-Scan-Signature: 3b058867a8808b2a73617ccb478d635a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, September 7, 2011 04:47, Denys Vlasenko wrote:
> On Tuesday 06 September 2011 19:19, Indan Zupancic wrote:
>> >> > In case you meant that "if we request group-stop notifications by using
>> >> > __WALL | WSTOPPED, and we get group-stop notification, and we do
>> >> > PTRACE_CONT, then task does not run (it sits in group-stop until SIGCONT
>> >> > or death)", then we have a problem: gdb can't use this interface, it
>> >> > needs to be able to restart the thread (only one thread, not all of
>> >> > them, so sending SIGCONT is not ok!) from the group-stop. Yes, it's
>> >> > weird, but it's the real requirement from gdb users.
>> >> [...]
>> >> > SIGCONT's side effect of waking up from group-stop can't be blocked.
>> >> > SIGCONT always wakes up all threads in thread group.
>> >> > Using SIGCONT to control tracee will race with SIGCONTs from other
>> >> > sources.
>> >> >
>> >> > This makes SIGCONT a too coarse instrument for the job.
>> >> [...]
>> >> > Yes... until gdb will want to give user a choice after SIGSTOP: continue
>> >> > to sit in group-stop until SIGCONT (wasn't possible until
>> >> > PTRACE_LISTEN), or continue executing (gdb's current behavior if user
>> >> > uses "continue" command). Therefore, gdb needs a way to do both.
>> >>
>> >> Having thought a bit more about this, I think this is less of a problem
>> >> than it seems, because for a group stop we get a ptrace event for each
>> >> task, and this should be true for SIGCONT as well. So gdb could also
>> >> always let the group stop happen, and only when prompted to do so by
>> >> a user, continue one thread by sending SIGCONT and letting all the other
>> >> threads hang in trapped state.
>> >
>> > Won't work. SIGCONT unpauses all threads in the thread group,
>> > and _then_ it is delivered to one of the threads.
>>
>> No, it is delivered to _all_ threads.
>
> Wrong.

Argh, indeed! I always confused the SIGSTOP after fork/clone with the SIGSTOP
I sent, thinking the SIGSTOP was sent to all tasks.

Well, so much for that idea then.

>> With current ptrace you never see a SIGCONT
>
> Wrong. Even rather old strace 4.5.9 does show it.

I meant a resuming SIGCONT, not just any SIGCONT. But that a normal SIGCONT isn't
seen by all threads should have been a hint for me that perhaps the same isn't true
for SIGSTOPs, and that perhaps I should take a better look instead of repeating the
same test and mistake.

>> Not doing PTRACE_CONT will keep the thread hanging in trapped state.
>> All threads get a SIGCONT, not only one, so you can pause all threads
>> this way.
>
> As I said, you are wrong about SIGCONT.

Indeed, I was wrong.

Greetings,

Indan



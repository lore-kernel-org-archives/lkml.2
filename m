Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264Ab1CCBzh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 20:55:37 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:37824 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300Ab1CCBzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 20:55:36 -0500
Message-ID: <019ad511a576046f79364a846041a64c.squirrel@webmail.greenhost.nl>
In-Reply-To: <201103030230.27363.vda.linux@googlemail.com>
References: <20110301152457.GE26074@htj.dyndns.org>
    <20110302133206.GA9838@redhat.com>
    <0a2c2dfb67198c5bd2cfc6e6c1896f23.squirrel@webmail.greenhost.nl>
    <201103030230.27363.vda.linux@googlemail.com>
Date: Thu, 3 Mar 2011 02:55:32 +0100 (CET)
Subject: Re: [RFC] Proposal for ptrace improvements
From: "Indan Zupancic" <indan@nul.nu>
To: "Denys Vlasenko" <vda.linux@googlemail.com>
Cc: "Oleg Nesterov" <oleg@redhat.com>, "Tejun Heo" <tj@kernel.org>,
        "Roland McGrath" <roland@redhat.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org,
        "Michael Kerrisk" <mtk.manpages@googlemail.com>
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.1
X-Scan-Signature: bbdeaaa4d227adae8d620e69c05793d6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, March 3, 2011 02:30, Denys Vlasenko wrote:
> On Thursday 03 March 2011 01:47, Indan Zupancic wrote:
>> On Wed, March 2, 2011 14:32, Oleg Nesterov wrote:
>> > On 03/02, Tejun Heo wrote:
>> >> On Wed, Mar 02, 2011 at 06:07:35AM +0100, Indan Zupancic wrote:
>> >> > I'm not sure what Denys is talking about: Currently it's impossible to
>> >> > pass along SIGSTOP to traced processes. Quoting the ptrace manpage:
>> >> >
>> >> >    PTRACE_CONT
>> >> >           Restarts  the stopped child process.  If data is nonzero and not
>> >> >           SIGSTOP, it is interpreted as a signal to be  delivered  to  the
>> >> >           child;  otherwise,  no  signal is delivered.
>> >>
>> >> AFAICS, that's not true.  SIGSTOP isn't treated differently from other
>> >> signals in the ptrace signal delivery path.  Maybe it was true in the
>> >> past.
>> >
>> > Yes, this is not true. And it seems this was never true.
>> >
>> > This is the second time this manpage confuses people in this discussion,
>> > probably it should be fixed...
>>
>> Passing SIGSTOP does not actually stop the traced task, which is in line
>> with what the manpage says. All it does is generating that second SIGSTOP
>> notification, but when the task is continued it's running, not stopped.
>
> It can be argued that after this the task is running _precisely_
> because it was continued by the debugger.

That would be an incorrect argument. PTRACE_CONT is supposed to let the
task continue doing whatever it was doing, and in the case of receiving
SIGSTOP that was going into a stopped state.

>> So ptraced tasks can't be stopped with SIGSTOP and continued with SIGCONT.
>
> It can be stopped - just do not PTRACE_CONT it after second SIGSTOP
> notification.

Stopped for tracing is not the same as stopped by SIGSTOP! So saying
to just hang in the traced state is not a good solution. This would
mean that there are special rules for SIGSTOP handling compared to
other signals, that's stupid.

- The tracer shouldn't get that second notification at all if it didn't
  ask for it.

- It's hard to distinguish a SIGSTOP from an undocumented "task stopping"
  notification which is lying because the task didn't stop after that
  event was handled.

- There is no need or use for this complexity, just pass along SIGSTOP!

>
> The bug is that it can't be continued with SIGCONT after that.

No, that is a side effect of your buggy work around which proves that
SIGSTOP doesn't currently work.

For a debugger it doesn't matter much, but for anything that tries to be
unobtrusive like strace this is just madness.

> That's the gist of Tejun Heo's proposal.
>
> Oleg's proposal is a bit different. It proposes that we do need
> to do PTRACE_CONT after second SIGSTOP notification too,
> but task will be indeed stopped after this, and resumed
> when SIGCONT arrives.

Please implement Oleg's proposal, anything else is madness.

Ptrace and task stopping because of SIGSTOP are two independent things
and should be treated like that, if you want to improve ptrace.

Greetings,

Indan



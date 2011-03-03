Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875Ab1CCArz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 19:47:55 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:46602 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756799Ab1CCArx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 19:47:53 -0500
Message-ID: <0a2c2dfb67198c5bd2cfc6e6c1896f23.squirrel@webmail.greenhost.nl>
In-Reply-To: <20110302133206.GA9838@redhat.com>
References: <20110301152457.GE26074@htj.dyndns.org>
    <201103011757.48593.vda.linux@googlemail.com>
    <20110301170953.GB17933@htj.dyndns.org>
    <AANLkTi=8=Tw2aYzvwM_s8dsMmw3W_tYjsYkqTHS9moUW@mail.gmail.com>
    <20110301183454.GC23527@mtj.dyndns.org>
    <830cc1666bd4a610d5e870218f06bd2d.squirrel@webmail.greenhost.nl>
    <20110302074447.GE19669@htj.dyndns.org>
    <20110302133206.GA9838@redhat.com>
Date: Thu, 3 Mar 2011 01:47:46 +0100 (CET)
Subject: Re: [RFC] Proposal for ptrace improvements
From: "Indan Zupancic" <indan@nul.nu>
To: "Oleg Nesterov" <oleg@redhat.com>
Cc: "Tejun Heo" <tj@kernel.org>, "Denys Vlasenko" <vda.linux@googlemail.com>,
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
X-Scan-Signature: 246115766b56dba7f675551df821dbd2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, March 2, 2011 14:32, Oleg Nesterov wrote:
> On 03/02, Tejun Heo wrote:
>> On Wed, Mar 02, 2011 at 06:07:35AM +0100, Indan Zupancic wrote:
>> > I'm not sure what Denys is talking about: Currently it's impossible to
>> > pass along SIGSTOP to traced processes. Quoting the ptrace manpage:
>> >
>> >    PTRACE_CONT
>> >           Restarts  the stopped child process.  If data is nonzero and not
>> >           SIGSTOP, it is interpreted as a signal to be  delivered  to  the
>> >           child;  otherwise,  no  signal is delivered.
>>
>> AFAICS, that's not true.  SIGSTOP isn't treated differently from other
>> signals in the ptrace signal delivery path.  Maybe it was true in the
>> past.
>
> Yes, this is not true. And it seems this was never true.
>
> This is the second time this manpage confuses people in this discussion,
> probably it should be fixed...

Passing SIGSTOP does not actually stop the traced task, which is in line
with what the manpage says. All it does is generating that second SIGSTOP
notification, but when the task is continued it's running, not stopped.
So ptraced tasks can't be stopped with SIGSTOP and continued with SIGCONT.

What the manpage says might not be "true", but it is the behaviour
actually seen.

On Wed, March 2, 2011 15:50, Tejun Heo wrote:
> That happens with any stopping signals.  They're two different
> notifications for two different events.  Please read the original
> thread referenced in the RFC for details.

I found subthreads:
http://article.gmane.org/gmane.linux.kernel/1099908
http://thread.gmane.org/gmane.linux.kernel/1093410

So you guys seem to know that SIGSTOP/SIGCONT doesn't work with
current ptrace, why say the manpage is wrong then? I'm confused.

You can fix ptrace to behave sensibly and then update the manpage,
but don't blame the manpage for describing the current behaviour.

>
> WUNTRACED is ignored while ptracing.

Do you mean that waitid always behaves as if WUNTRACED is set? That
is, it reports process stop events even when not asked to? That is not
documented anywhere, neither in the ptrace manpage, nor the waitpid one!

I consider that a bug, it would be a lot more useful if the default was
to not notify stopped events except when asked to. Anyway, for my program
it doesn't matter, as long as blindly passing on the second SIGSTOP is
harmless.

>
>> > Again, not following.  In the proposal, job control and ptrace operate
>> > independently, so on that we seem to agree, but I can't understand
>> > where the STOP signal for the parent comes from?  What are you
>> > referring to?
>>
>> What I mean is, if you have a parent P with a child C, and C is ptraced by T,
>> P shouldn't get SIGSTOP notifications when it waits for C with WUNTRACED set
>> and C is stopped because of a ptrace event.
>
> Yeah, sure, what I'm confused about is why you're bringing that up.
> Nothing changes anything related to that.  There's no reason to bring
> it up.  Am I missing something?

Ignore it, it's not important. I think I got confused about what you
were talking about, because of the entanglement between tracing and
task stopped state.

Guys, any change to ptrace to make it behave more sensible is welcome,
it's fine to change the behaviour if it improves it, as long as it's
backward compatible in the sense that it doesn't break old ptrace users.
Especially SIGSTOP related stuff is more or less transparent for tracers.
Currently it doesn't work and no matter what the tracer does, it can't
work.

I'd argue that not notifying stopped tasks events by default when WUNTRACED
isn't set is fine too, because doing that is just weird and unexpected by
pretty much all current ptrace users.

Greetings,

Indan



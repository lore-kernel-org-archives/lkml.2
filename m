Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525Ab1FCONR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 10:13:17 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43598 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990Ab1FCONQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 10:13:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=sVtimoIPI/uoo/9E8m6DmAAVJOWlVmz9mcYFEn+98Ap4AeTNuaJkMpVoFNpGEprYxy
         LbAUtG1sy2Tey8dEKph55c3J9KJ2pJSjBKBFoXErBMkMY45wlCRwNrH5VuVx70EYpBvX
         AcmSs+FSTUrDrHato+CzfElLAGbY3pjuyLOaI=
MIME-Version: 1.0
In-Reply-To: <201106031311.33929.pedro@codesourcery.com>
References: <1306710760-16440-1-git-send-email-tj@kernel.org>
 <20110603012445.GA14872@mtj.dyndns.org> <201106031357.02859.vda.linux@googlemail.com>
 <201106031311.33929.pedro@codesourcery.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Fri, 3 Jun 2011 16:12:55 +0200
Message-ID: <BANLkTinx8enCJHNMm+LN0TBtSF0=7PGRNw@mail.gmail.com>
Subject: Re: [PATCHSET ptrace] ptrace: implement PTRACE_SEIZE/INTERRUPT and
 group stop notification, take#4
To: Pedro Alves <pedro@codesourcery.com>
Cc: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu,
        bdonlan@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 3, 2011 at 2:11 PM, Pedro Alves <pedro@codesourcery.com> wrote:
>> > > > * What to do about events which are reported by genuine SIGTRAP
>> > > >  generation?
>> > >
>> > > I don't understand what you meant here. Example(s)?
>> >
>> > The syscall, breakpoint, single step SIGTRAPs which can't be
>> > distinguished from userland generated SIGTRAPs and may be mixed and/or
>> > lost.  Maybe it's best to leave them alone or maybe we can add some
>> > way to distinguish them which is mostly backward compatible (which is
>> > enabled w/ SEIZE and hopefully doesn't require noticeable userland
>> > changes).
>>
>> Currently, all PTRACE_EVENTs are enabled with ptrace options.
>>
>> I propose using the same way instead of using something different.
>> It works. It's not problematic. Just add more PTRACE_O_foo bits.
>> Then user who really want it will use it, and users which
>> would rather use their existing code with less changes aren't
>> forced to change.
>
> I'm in principle against this.  What realistic good does it
> bring over making exception/syscall SIGTRAPs distinguisheable
> on the siginfo?

Requiring GETSIGINFO on every syscall trap is (1) a bit expensive
and (2) was never needed before.

>  Userspace should see these SIGTRAPs if a tracer
> isn't there anyway, and, even if a tracer _is_ there, you
> may want to forward breakpoint/step SIGTRAPs to the
> tracee, just as if a ptracer wasn't there --- I do that often to
> debug an in-process self debugger.

Ah, you are talking about int3 SIGTRAP? That one, IMHO,
should be treated as "real" signal and passed down to the program
by strace. For debuggers which use int3 as breakpoint insn,
well, I don't know. Perhaps they don't cope well with user-sent
SIGTRAPs anyway?

>  Being able to distinguish the
> cause of the SIGTRAP is useful for self debuggers as well,
> which leads to putting the info in siginfo anyway.

I don't understand what use case you have in mind.

-- 
vda

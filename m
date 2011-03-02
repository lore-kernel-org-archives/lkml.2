Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757696Ab1CBBhq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 20:37:46 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48054 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757369Ab1CBBhp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 20:37:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=IF03Odi22yOjUdm8x5NnFgncrtqwoTpXjEklbSdovhdxuN6oiNetsf9bdtgWx0TjL5
         jF8DUH4dj8BxS6xyPVU1JYGHbb8BpmOmREClI7kCnNP+GYNo/NR50l5SF7Mf4qeCgAjb
         I206gy0Gdjjjx3IkK8kBVbF7liNPp7z//Z3bo=
MIME-Version: 1.0
In-Reply-To: <20090110155720.GA10954@redhat.com>
References: <49639EB8.40204@redhat.com> <4963ABF0.6070400@redhat.com>
 <20090107123457.GB16268@elte.hu> <20090107205322.5F8C7FC3E0@magilla.sf.frob.com>
 <1231598714.11642.53.camel@quest> <20090110155720.GA10954@redhat.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Wed, 2 Mar 2011 02:37:13 +0100
Message-ID: <AANLkTimw5Z00uVsWYP0KGiQ8jDex9yYGNc61SG=9GsGj@mail.gmail.com>
Subject: Re: [RESEND][RFC PATCH v2] waitfd
To: Oleg Nesterov <oleg@redhat.com>
Cc: Scott James Remnant <scott@canonical.com>,
        Roland McGrath <roland@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Casey Dahlin <cdahlin@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Davide Libenzi <davidel@xmailserver.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2009 at 4:57 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 01/10, Scott James Remnant wrote:
>> On Wed, 2009-01-07 at 12:53 -0800, Roland McGrath wrote:
>> > Do we really need another one for this?  How about using signalfd plus
>> > setting the child's exit_signal to a queuing (SIGRTMIN+n) signal instead of
>> > SIGCHLD?  It's slightly more magical for the userland process to know to do
>> > that (fork -> clone SIGRTMIN).  But compared to adding a syscall we don't
>> > really have to add, maybe better.
>> >
>> This wouldn't help the init daemon case:
>>
>> - the exit_signal is set on the child, not on the parent.
>>
>>   While the init daemon could clone() every new process and set
>>   exit_signal, this would not be set for processes reparented to init.
>>
>>   Even if we had a new syscall to change the exit_signal of a given
>>   process, *and* had the init reparent notification patch, this still
>>   wouldn't be sufficient; you'd have a race condition between the time
>>   you were notified of the reparent, and the time you set exit_signal,
>>   in which the child could die.
>>
>>   Since exit_signal is always reset to SIGCHLD before reparenting, this
>>   could be done by resetting it to a different signal; but at this point
>>   we're getting into a rather twisty method full of traps.
>>
>> - exit_signal is reset to SIGCHLD on exec().
>>
>>   Pretty much a plan-killer ;)
>
> I can't understand why should we change ->exit_signal if we want to
> use signalfd. Yes, SIGCHLD is not rt. So what?
>
> We do not need multiple signals in queue if we want to reap multiple
> zombies. Once we have a single SIGCHLD (reported by signalfd or
> whatever) we can do do_wait(WNOHANG) in a loop.
>
> Confused.

I know I am terribly late for the party :)

"do_wait(WNOHANG) in a loop" is a performance problem.

Oleg, do you remember that strace bug when it was swamped
with gazillions of stop notifications from a multithreaded
task, then by dealing with them one-by-one it was causing
unfairness and ultimately "this program never finishes
when run under strace" bug?

And another typical nuisance that running multithreaded
stuff under strace is much slower, even with -e option
which limits the set of decoded syscalls?

Having waitfd would help both cases: strace can gulp
a lot of waitpid notifications in one go, and
batch process them.

-- 
vda

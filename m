Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844Ab1BNRZW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 12:25:22 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53101 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755127Ab1BNRZU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 12:25:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=kAurM/3wU4YSpQRE4hqFGzSZFFp8pBup2LM4uij5XPuEFWq2jKJZK+3qlvum3Cxpt0
         J1RoTTI5pbTtLLsC4l5MPuaCMQNk92seHZ8y/Pg2B8ukZ+qNe/9aOILZPwGv90DcoFye
         9PNAC23KQ+m8X/fe7KRpRRv1l8pOkwmcaNMgQ=
MIME-Version: 1.0
In-Reply-To: <20110214153149.GB8761@redhat.com>
References: <20110204105343.GA12133@htj.dyndns.org> <20110207174821.GA1237@redhat.com>
 <20110209141803.GH3770@htj.dyndns.org> <201102132325.55353.vda.linux@googlemail.com>
 <20110214153149.GB8761@redhat.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Mon, 14 Feb 2011 18:24:58 +0100
Message-ID: <AANLkTikYf1CE41x6FjE6FiZ40v8taRSy8aZ3-5tjAvok@mail.gmail.com>
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after PTRACE_ATTACH
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Roland McGrath <roland@redhat.com>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 4:31 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 02/13, Denys Vlasenko wrote:
>> On Wednesday 09 February 2011 15:18, Tejun Heo wrote:
>> > > > and I'm not really sure whether that's something worth achieving
>> > > > at the cost of debugging capabilities especially when we don't _have_
>> > > > to lose them.
>> > >
>> > > But we do not? I mean, at least this is not worse than the current
>> > > behaviour.
>> >
>> > I think it's worse.  With your changes, debuggers can't diddle the
>> > tasks behind group stop's back which the current users already expect.
>>
>> But this "diddling behind group stop's back" is exactly the current
>> problem with stop signals.
>>
>> Here I try to stop a ptraced process:
>>
>> $ strace -tt sleep 30
>> 23:02:15.619262 execve("/bin/sleep", ["sleep", "30"], [/* 30 vars */]) = 0
>> ...
>> 23:02:15.622112 nanosleep({30, 0}, NULL) = ? ERESTART_RESTARTBLOCK (To be restarted)
>> 23:02:23.781165 --- SIGSTOP (Stopped (signal)) @ 0 (0) ---
>> 23:02:23.781251 --- SIGSTOP (Stopped (signal)) @ 0 (0) ---
>>     (I forgot again why we see it twice. Another quirk I guess...)
>
>      (this is correct, the tracee reports the signal=SIGSTOP, then
>       it reports it actually stopps with exit_code=SIGSTOP)

Ah, I see. Is there any way debugger can distinguish between these two
different stops?

>> 23:02:23.781310 restart_syscall(<... resuming interrupted call ...>) = 0
>> 23:02:45.622433 close(1)                = 0
>> 23:02:45.622743 close(2)                = 0
>> 23:02:45.622885 exit_group(0)           = ?
>>
>> Why sleep didn't stop?
>
> Yes. And I think this all should be fixed.
>
> Although, depending on how we change the kernel, strace may need the
> fixes too.

Exactly my thoughts. strace must not try to inject another SIGSTOP
when it sees the second SIGSTOP event. Currently, it does,
because it has no way to understand that the second one
*is not a signal delivery*.

-- 
vda

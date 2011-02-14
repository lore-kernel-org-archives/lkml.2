Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755639Ab1BNRFd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 12:05:33 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38517 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312Ab1BNRF3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 12:05:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=jLv0RTPPnxktzKsrqidH6RTIP289umP4AcXH8L4YRFnefqbqGm4bXJHEBZo9AyVA9e
         A1J4vOfWAsHBCn8klvfYn2h/fK6KinnF/XaofW52vq8ymPmeYe6O9mvrm202fcE1cfX/
         c1Qm/brkucJ4Je++st+3io7tLDJ5/KaYnBtKo=
MIME-Version: 1.0
In-Reply-To: <20110214150656.GA8761@redhat.com>
References: <1296227324-25295-1-git-send-email-tj@kernel.org>
 <20110204130455.GA3671@redhat.com> <20110204144858.GI12133@htj.dyndns.org>
 <201102132224.25197.vda.linux@googlemail.com> <20110214150656.GA8761@redhat.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Mon, 14 Feb 2011 18:05:03 +0100
Message-ID: <AANLkTin1ufNRPx173HgxD5jbPy3m6kK2-2ppU-jqPx0F@mail.gmail.com>
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

On Mon, Feb 14, 2011 at 4:06 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 02/13, Denys Vlasenko wrote:
>>
>> For example, PTRACE_DETACH requires tracee to be stopped to succeed.
>> If debugger tries to detach while the tracee is running, it will get
>> an error. This forces debugger to do stupid things like sending SIGSTOP,
>> then waiting for tracee to stop, then doing PTRACE_DETACH, then
>> sending SIGCONT. Of course, while this dance is performed,
>> any SIGSTOPs/SIGCONTs which may be  sent to the tracee by other processes
>> are totally disrupted by this.
>
> Yes.
>
>> The natural (for me) fix is to make PTRACE_DETACH work even on running
>> tracee. It simply makes a lot of sense. Why on earth do we need tracee
>> to be stopped? There is no reason.
>
> Agreed, but
>
>> But this is a change in ptrace behavior, and therefore is not acceptable
>> for Roland.
>
> I agree with Roland. Not only this is too visible change, it is not clear
> what detach-with-signal can do if the tracee is not stopped.
>
> This was (very briefly) discussed recently. Probably we can implement
> PTRACE_DETACH_RUNNING (the name is random) which doesn't require the
> stopped tracee but ignores the "data" argument.

IIRC data argument is already ignored by PTRACE_CONT if it is issued in
the ptrace stop which wasn't caused by signal delivery to the tracee.

Basically, *if debugger sees SIGfoo*, it can either allow it:
ptrace(PTRACE_CONT, ...,  SIGfoo);
ignore it:
ptrace(PTRACE_CONT, ...,  0);
or even inject some other signal:
ptrace(PTRACE_CONT, ...,  SIGbar);

but if it resumes tracee from, say, post-execve ptrace stop,
it can't inject a signal: last ptrace() argument will be ignored.

So, it isn't a new precedent to make
ptrace(PTRACE_DETACH, ...,  <something>);
to ignore <something> if tracee isn't in signal-delivery-induced ptrace stop.
In particular, if it isn't in any stop at all, if it's running.

-- 
vda

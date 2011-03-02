Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab1CBPRe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 10:17:34 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51427 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab1CBPRc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 10:17:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=ARtO3W6cR4ZV9VMW0Luz4+4zA6RfnbHX0FC8MKIgTixO+OuyCLtO1/QrBxdjImsYfd
         wMUXlHvAnUGA+Nexa24GRbAmBnMN5Sa2MMRihbwZW63GtC8K5a0+NhfHPGS5xjdIqfPb
         u1EQ4/VgrpoSBg7ztSPCeCxSF10EJxA/jTu8M=
MIME-Version: 1.0
In-Reply-To: <20110302144322.GJ3319@htj.dyndns.org>
References: <20110301152457.GE26074@htj.dyndns.org> <AANLkTi=cUM9S5M7h0unMfbQ88CzqhoDN9CUEVf_9HrdS@mail.gmail.com>
 <20110302073727.GD19669@htj.dyndns.org> <AANLkTimA8wtM4sJu1SMVuOaNXyxEtLcfaj7kJf2NovAd@mail.gmail.com>
 <20110302112756.GI3319@htj.dyndns.org> <AANLkTi=tQ0kLB_MiTArpNAWHUT0id_dbXXLu9UpPhRfN@mail.gmail.com>
 <20110302144322.GJ3319@htj.dyndns.org>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Wed, 2 Mar 2011 16:16:50 +0100
Message-ID: <AANLkTimatMdmovtaouPRy9LVU75LuBOE-9H+LWhhm6qu@mail.gmail.com>
Subject: Re: [RFC] Proposal for ptrace improvements
To: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 2, 2011 at 3:43 PM, Tejun Heo <tj@kernel.org> wrote:
>> # ./a.out
>> PID: 16382
>>  <------ kill -STOP 16382
>>  <------ kill -ABRT 16382
>>  <------ kill -WINCH 16382
>>  <------ kill -CONT 16382
>> sig: 28 Window changed
>> sig: 18 Continued
>> sig: 6 Aborted
>> after sleep: errno=4 Interrupted system call
>> PID: 16382
>>
>>
>> Therefore we also need to think about this aspect of SIGCONT behavior
>> under debuggers.
>>
>> Do we provide for the mechanism for debuggers to
>> prevent execution of *SIGCONT userspace handler*?
>
> Yeah, it's not different from any other signal.  Just squash the
> signal when ptrace signal delivery trap is taken, which is completely
> separate from termination of job control stop triggered by _emission_
> of SIGCONT.  The two are separate.  The proposed changes don't affect
> the delivery path at all.  I really can't understand what your point
> is.
>
>> And, looking at the example above, I see that on resume from stop,
>> *SIGCONT userspace handler* actually doesn't run as *the first handler*
>> after SIGCONT. Other pending signal's handlers may be executed before it.
>
> Signal delivery is not FIFO.  There are some rules that the code
> describes.  If you're interested, take a look at the code but in
> general it would be better to avoid assuming fixed order between
> signal generations and deliveries.

The above example does not show any FIFO-like behavior.

What it does show is that signals queued during stop take effect
immediately after job control stop is terminated.

>> How would the above example look under ptraced process? Particularly,
>> this sequence:
>>  <------ kill -STOP 16382
>>  <------ kill -ABRT 16382
>>  <------ kill -WINCH 16382
>>  <------ kill -CONT 16382
>> sig: 28 Window changed
>> sig: 18 Continued
>> sig: 6 Aborted
>
> There's NO difference regarding signal delivery.  It stays the SAME.

Ok, let's see whether I understand you.

Assuming the program is run under simple debugger which
resumes execution using PTRACE_CONT(sig) on signal delivery stops,
with PTRACE_CONT(0) on ptrace stops,
and doesn't do any PTRACE_CONT on job control stops,
with your proposal the debugger will see and perform
the following actions:

waitpid...
  <------ kill -STOP 16382
waitpid returns WSTOPPED, WSTOPSIG = SIGSTOP
ptrace(PTRACE_GETSIGINFO) doesn't fail (=> it's signal delivery)
ptrace(PTRACE_CONT, SIGSTOP)
waitpid returns WSTOPPED, WSTOPSIG = SIGSTOP
ptrace(PTRACE_GETSIGINFO) fails (=> it's job control stop)
waitpid...
  <------ kill -ABRT 16382
...debugger doesn't wake up...
  <------ kill -WINCH 16382
...debugger doesn't wake up...
  <------ kill -CONT 16382
waitpid returns WSTOPPED, WSTOPSIG = SIGTRAP (it's a ptrace-stop)
ptrace(PTRACE_CONT, 0)
waitpid returns WSTOPPED, WSTOPSIG = SIGWINCH
ptrace(PTRACE_CONT, SIGWINCH)
waitpid returns WSTOPPED, WSTOPSIG = SIGCONT
ptrace(PTRACE_CONT, SIGCONT)
waitpid returns WSTOPPED, WSTOPSIG = SIGABRT
ptrace(PTRACE_CONT, SIGABRT)

Correct?

-- 
vda

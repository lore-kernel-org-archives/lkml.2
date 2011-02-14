Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751170Ab1BNRzA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 12:55:00 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52060 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab1BNRy6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 12:54:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=FUoIJ5Yj4sL8eOwWNE5nw3szuMONXXyspV/sIi1P6yGlO95jGXRDYXxW4hjJ3/LW/F
         lch+qx2Ic6PYyV5P9F12stOz77ZylZyD4xGmLlEJtWrwBSy1sW/O0NeMo5ub7THoigxZ
         61+VUUkUXIWoo45HY0rxigZEtGzOQuwc7uf7g=
MIME-Version: 1.0
In-Reply-To: <20110214173012.GA18742@htj.dyndns.org>
References: <20110204105343.GA12133@htj.dyndns.org> <20110207174821.GA1237@redhat.com>
 <20110209141803.GH3770@htj.dyndns.org> <201102132325.55353.vda.linux@googlemail.com>
 <20110214151340.GP18742@htj.dyndns.org> <AANLkTi=Djwcf9YoUrGtTEOp8W_YhsefzrNhMxVhtw_Lp@mail.gmail.com>
 <20110214173012.GA18742@htj.dyndns.org>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Mon, 14 Feb 2011 18:54:37 +0100
Message-ID: <AANLkTinntVGcOdZSS3gWz39eq3EDiMxXgYfc6+M1Z0iE@mail.gmail.com>
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after PTRACE_ATTACH
To: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 6:30 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On Mon, Feb 14, 2011 at 06:20:52PM +0100, Denys Vlasenko wrote:
>> >> 23:02:15.622112 nanosleep({30, 0}, NULL) = ? ERESTART_RESTARTBLOCK (To be restarted)
>> >> 23:02:23.781165 --- SIGSTOP (Stopped (signal)) @ 0 (0) ---
>> >> 23:02:23.781251 --- SIGSTOP (Stopped (signal)) @ 0 (0) ---
>> >>     (I forgot again why we see it twice. Another quirk I guess...)
>> >> 23:02:23.781310 restart_syscall(<... resuming interrupted call ...>) = 0
>> >> 23:02:45.622433 close(1)                = 0
>> >> 23:02:45.622743 close(2)                = 0
>> >> 23:02:45.622885 exit_group(0)           = ?
> ...
>> > This can be fixed by updating strace, right?  strace can look at the
>> > wait(2) exit code and if the tracee stopped for group stop, wait for
>> > the tracee to be continued instead of issuing PTRACE_SYSCALL.
>>
>> But tracee didn't stop _yet_. Signal is not delivered _yet_, debugger
>> can decide at this point whether to deliver it:
>> ptrace(PTRACE_SYSCALL, $PID, 0x1, SIGSTOP)
>> or ignore:
>> ptrace(PTRACE_SYSCALL, $PID, 0x1, 0)
>>
>> strace has to deliver SIGSTOP if it wants to make program run exactly
>> as it would run without strace. So it tries to do so.
>> Currently, ptrace machinery doesn't react as strace, its user, expects it to.
>
> Okay, maybe I'm missing something but so once SIGSTOP is determined to
> be delivered, then the tracee enters group stop and that's the second
> SIGSTOP notification you get.  At that point, strace should wait for
> the tracee to be continued by SIGCONT.  That should work, right?

Do you mean "Will it work on current kernels" or
"that's what strace has to do and then it is supposed to work correctly,
modulo bugs"?

"Will it work on current kernels" - I don't know. Need to experiment.

"That's what strace has to do and then it is supposed to work correctly,
modulo bugs" - it depends on how we define group-stop and ptrace-stop
relationship.

In this particular scenario, first SIGSTOP is ptrace-stop.
Obviously, we must issue ptrace(PTRACE_SYSCALL, $PID, 0x1, SIGSTOP)
to continue.

Second SIGSTOP is notification of tracee's group-stop to debugger.

The question is, logically, by sending this notification, does tracee,
or does it not enter into ptrace-stop too? (IOW: is ptrace-stop a separate
bit in task state, independent of group-stop?)
If yes, then we need to release tracee from ptrace-stop (but it will remain in
group-stop) by issuing ptrace(PTRACE_SYSCALL, $PID, 0x1, 0).
If not, then we must not do so, because the task is not ptrace-stopped,
and ptrace(PTRACE_SYSCALL, $PID, 0x1, 0) is undefined (I think it should
error out to indicate that).

How do you prefer to define it?

-- 
vda

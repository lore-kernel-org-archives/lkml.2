Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab1BUPQb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 10:16:31 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34734 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283Ab1BUPQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 10:16:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=WYat9H3+pwF6JqnPiyFFHvfzd9teGSxdJK7e9urBZUXo9+KGr4sdNSt/eWct4vQ1Go
         6qyDngqstKaS3s14qrUyzm3vxD71rUD3jTejGY+r5t0/2ovqRH+xVKKwuQDhwiOVidaA
         VBC3ELD9ljWIf0vM5ttIRZHMvvlKJ4yerxNvE=
Date: Mon, 21 Feb 2011 16:16:19 +0100
From: Tejun Heo <tj@kernel.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
 PTRACE_ATTACH
Message-ID: <20110221151619.GM31267@htj.dyndns.org>
References: <20110204105343.GA12133@htj.dyndns.org>
 <20110207174821.GA1237@redhat.com>
 <20110209141803.GH3770@htj.dyndns.org>
 <201102132325.55353.vda.linux@googlemail.com>
 <20110214151340.GP18742@htj.dyndns.org>
 <AANLkTi=Djwcf9YoUrGtTEOp8W_YhsefzrNhMxVhtw_Lp@mail.gmail.com>
 <20110214173012.GA18742@htj.dyndns.org>
 <AANLkTinntVGcOdZSS3gWz39eq3EDiMxXgYfc6+M1Z0iE@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinntVGcOdZSS3gWz39eq3EDiMxXgYfc6+M1Z0iE@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Feb 14, 2011 at 06:54:37PM +0100, Denys Vlasenko wrote:
> > Okay, maybe I'm missing something but so once SIGSTOP is determined to
> > be delivered, then the tracee enters group stop and that's the second
> > SIGSTOP notification you get.  At that point, strace should wait for
> > the tracee to be continued by SIGCONT.  That should work, right?
> 
> Do you mean "Will it work on current kernels" or "that's what strace
> has to do and then it is supposed to work correctly, modulo bugs"?

Yes and no, I think it will mostly work on current kernels if we
concentrate only on the actual stopping and continuing part; however,
there still are two obstacles.

1. The distinction between the first SIGSTOP trapping and the second
   can only be reliably done by GETSIGINFO which in turn will put the
   tracee into TASK_TRACED making the tracee ignore the future SIGCONT
   and the tracer has no way to detect reception of it either.  The
   tracer can make the distinction by looking at the sequence of
   events but it wouldn't work for multithreaded cases and right after
   attach.

2. Due to reparenting, wait(2) notifications (including the SIGCLDs)
   don't get to the real parent at all.

#2 just needs fixing.  I don't think there will be a lot of different
opinions on that one; however, #1 is trickier and one of the biggest
reasons why we have this long thread.

> In this particular scenario, first SIGSTOP is ptrace-stop.
> Obviously, we must issue ptrace(PTRACE_SYSCALL, $PID, 0x1, SIGSTOP)
> to continue.
> 
> Second SIGSTOP is notification of tracee's group-stop to debugger.

So, at this point, the debugger shouldn't be continuing the tracee by
calling PTRACE_SYSCALL but do something else.  What that should be is
still being discussed.

> The question is, logically, by sending this notification, does tracee,
> or does it not enter into ptrace-stop too? (IOW: is ptrace-stop a separate
> bit in task state, independent of group-stop?)
> If yes, then we need to release tracee from ptrace-stop (but it will remain in
> group-stop) by issuing ptrace(PTRACE_SYSCALL, $PID, 0x1, 0).
> If not, then we must not do so, because the task is not ptrace-stopped,
> and ptrace(PTRACE_SYSCALL, $PID, 0x1, 0) is undefined (I think it should
> error out to indicate that).

That preciesly is what is being discussed.  IIUC, Oleg and Roland are
saying that the tracee should enter group stop but not ptrace trap at
that point and then transition into ptrace trap on the first PTRACE
call.  I was agreeing with that at first but changed my mind after
reading these discussions and now I think we should just put it in
ptrace trap and give the debugger a way to notice the end of group
stop.

Thanks.

-- 
tejun

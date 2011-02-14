Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705Ab1BNTnV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 14:43:21 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40718 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab1BNTnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 14:43:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=oYTudh7lzDuCrVQm75nGVrZ9g8vo9/4XxTXSsN3xhcMqdJXF97Ho6CqzxV93K0mqLr
         Y0aH/qblpZYzpu6BvOzz/JF3KzrBO1kST2e/wtI1hG/27RktC6u02D+AuJht8K2BOCsA
         RfWxRk2fH3AVwWi+iIQGnhK/YOn5bikYT5h3U=
MIME-Version: 1.0
In-Reply-To: <20110214190141.GA19221@redhat.com>
References: <20110204105343.GA12133@htj.dyndns.org> <20110207174821.GA1237@redhat.com>
 <20110209141803.GH3770@htj.dyndns.org> <201102132325.55353.vda.linux@googlemail.com>
 <20110214151340.GP18742@htj.dyndns.org> <AANLkTi=Djwcf9YoUrGtTEOp8W_YhsefzrNhMxVhtw_Lp@mail.gmail.com>
 <20110214175144.GC15847@redhat.com> <AANLkTi=VVWVkrqqQyOtsP72S5-nWny=Ukmf_r-m1qMwV@mail.gmail.com>
 <20110214190141.GA19221@redhat.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Mon, 14 Feb 2011 20:42:44 +0100
Message-ID: <AANLkTi=_af8+XKD+d-677JpQZA=AN2EsydscSYxk7z55@mail.gmail.com>
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after PTRACE_ATTACH
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Roland McGrath <roland@redhat.com>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 8:01 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 02/14, Denys Vlasenko wrote:
>>
>> I tried to simply not do ptrace(PTRACE_SYSCALL, ..., 0) at all.
>> Behavior changes, but it is still wrong. Now tracee doesn't wake up
>> on SIGCONT.
>
> please see below,
>
>> 19:41:09.601764 wait4(-1, [{WIFSTOPPED(s) && WSTOPSIG(s) == SIGSTOP}],
>> __WALL, NULL) = 25339
>> 19:41:09.601914 rt_sigprocmask(SIG_BLOCK, [HUP INT QUIT PIPE TERM], NULL, 8) = 0
>> 19:41:09.602081 ptrace(PTRACE_GETSIGINFO, 25339, 0, {si_signo=SIGSTOP,
>> si_code=SI_USER, si_pid=10105, si_uid=0, si_value={int=0, ptr=0}}) = 0
>> 19:41:09.602273 write(2, "--- SIGSTOP (Stopped (signal)) @ 0 (0) ---
>> STOP: si_signo:19 si_code:0 si_status:0 si_value:(nil) \n", 99) = 99
>> 19:41:09.602456 ptrace(PTRACE_SYSCALL, 25339, 0x1, SIGSTOP) = 0
>> 19:41:09.602582 --- SIGCHLD (Child exited) @ 0 (0) ---
>> 19:41:09.602652 rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
>> 19:41:09.602792 wait4(-1, [{WIFSTOPPED(s) && WSTOPSIG(s) == SIGSTOP}],
>> __WALL, NULL) = 25339
>
> OK, it is stopped.
>
>> 19:41:09.603081 ptrace(PTRACE_GETSIGINFO, 25339, 0, 0x7fff436fc730) =
>
> And this changes the state to TASK_TRACED. See another email from me.
> That is why SIGCONT doesn't work.
>
> This is another problem, the kernel should help somehow. This was
> already discussed a bit, but it is not clear what exactly we can do.

Yes, I understand what happens.

Basically, we have TASK_RUNNING, TASK_STOPPED and TASK_TRACED
states, and after entering TASK_TRACED state we lose information
in which state we were before entering it. We need to remember
old state and restore it in order for this example to work.

Or we can avoid entering TASK_TRACED on ptrace(PTRACE_GETSIGINFO) et al.
Can we remain in TASK_STOPPED?

-- 
vda

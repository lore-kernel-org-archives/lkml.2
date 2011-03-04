Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759801Ab1CDRGC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 12:06:02 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65152 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979Ab1CDRGB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 12:06:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=cHTabYNEXSyPsjmylvR/7yjza2MYV1a684c2U6boYrlEr1m/5gMyjF+PHa+odGVyjh
         CuSEM9uzoyL2U/69SEx4syxv6kJJfNoSvMplrp8sp4ZiEcEPJmfI/XiIujtZ1kt+t6Cn
         Ju9KJeR9MJmhn6jqocCdNRoxf6UF0P+TQksNc=
MIME-Version: 1.0
In-Reply-To: <20110304144059.GS20499@htj.dyndns.org>
References: <20110301152457.GE26074@htj.dyndns.org> <20110303173422.GA27960@redhat.com>
 <20110303202246.GB32152@redhat.com> <AANLkTikeCzr-OGkmaaortS7_rR+JCM9B6aJV0c52EMbE@mail.gmail.com>
 <20110304134126.GL20499@htj.dyndns.org> <AANLkTikLd2Kg9Pz+5eLd_irdxoKdrR9qPj8yixeTfvaM@mail.gmail.com>
 <20110304140745.GP20499@htj.dyndns.org> <AANLkTina7D3QffUK7vYvc3aVTvbcJQqm8VgQP3xJKYdw@mail.gmail.com>
 <20110304144059.GS20499@htj.dyndns.org>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Fri, 4 Mar 2011 18:05:08 +0100
Message-ID: <AANLkTinn_J3fxyjgQk02mHpbxh_5fXNk1qT-YwjgCGqK@mail.gmail.com>
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

On Fri, Mar 4, 2011 at 3:40 PM, Tejun Heo <tj@kernel.org> wrote:
> On Fri, Mar 04, 2011 at 03:31:15PM +0100, Denys Vlasenko wrote:
>> On Fri, Mar 4, 2011 at 3:07 PM, Tejun Heo <tj@kernel.org> wrote:
>> > Hello,
>> >
>> > On Fri, Mar 04, 2011 at 02:59:32PM +0100, Denys Vlasenko wrote:
>> >> I would rather speed strace up than slow it down further, even if
>> >> slightly.
>> >
>> > The question to ask is at what cost?  If mostly unnoticeable slow down
>> > makes the API cleaner, I'll go that way.  Everything is a tradeoff.
>>
>> # time sh -c 'ls -lR /usr/share >/dev/null'
>> real  0m2.633s
>>
>> strace without PTRACE_GETSIGINFO:
>> real  0m47.023s
>> real  0m48.799s
>> real  0m47.695s
>>
>> strace with PTRACE_GETSIGINFO:
>> real  0m51.958s
>> real  0m53.773s
>> real  0m51.625s
>
> Great, numbers, so it's ~10 slow down.  Gees, with or without that
> change, strace(2) is heavy, >18 times slower than without.

Here's a typical sequence of operations strace is doing:

wait4(-1, [{WIFSTOPPED(s) && WSTOPSIG(s) == SIGTRAP}], __WALL, NULL) = 10445
ptrace(PTRACE_GETSIGINFO, 10445, 0, {si_signo=SIGTRAP, si_code=0x5,
si_pid=10445, si_uid=0, si_value={int=0, ptr=0}}) = 0
ptrace(PTRACE_PEEKUSER, 10445, 8*ORIG_RAX, [0x36]) = 0
ptrace(PTRACE_PEEKUSER, 10445, 8*CS, [0x23]) = 0
ptrace(PTRACE_PEEKUSER, 10445, 8*RAX, [0xffffffffffffffda]) = 0
ptrace(PTRACE_PEEKUSER, 10445, 8*RBX, [0x1]) = 0
ptrace(PTRACE_PEEKUSER, 10445, 8*RCX, [0x5401]) = 0
ptrace(PTRACE_PEEKUSER, 10445, 8*RDX, [0xffb83f10]) = 0
ptrace(PTRACE_SYSCALL, 10445, 0x1, SIG_0) = 0

IOW: strace wastes a lot of time just transiting to the kernel and back
with simple syscalls to get the information.

What would help here is a "vectorized" waitpid operation
which retrieves much more information in one go:

waitpid_vec(int max_results, int status_vector[], siginfo_t
si_vector[], struct pt_regs reg_vector[])

-- 
vda

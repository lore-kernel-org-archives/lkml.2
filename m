Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601Ab1E0MLA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 08:11:00 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33006 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068Ab1E0MK5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 08:10:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=K+L6ufMyytV+uaesck2xvW5bf7MZ9AO8DmKObvpikUUqa6teMy5aIp88fFABLGW5i1
         wQUhC+v1uGCoQSIhBg2ze8jTsJx/jqHfW6GVHOgT/UOvDfe2qoIa9P25cZF/TTui9spu
         lxnk9G1jle6e0KBhg+VjA7taHBIIOTKWO+XLY=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=UEJqGxAs5p2tA=KzddNOrXCfXfQ@mail.gmail.com>
References: <alpine.LFD.2.02.1105262049180.3078@ionos> <4DDEC589.3010201@mit.edu>
 <20110527061208.GB9260@elte.hu> <BANLkTinOQ_C_-Bix4FTQxHqP3aavmTRrzg@mail.gmail.com>
 <BANLkTi=UEJqGxAs5p2tA=KzddNOrXCfXfQ@mail.gmail.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Fri, 27 May 2011 08:10:37 -0400
X-Google-Sender-Auth: qD6yVe5DwPmmf2hoRvWcvmkP5Zo
Message-ID: <BANLkTik7H=HyjzzCf4pYK-K7rx23DGHh8g@mail.gmail.com>
Subject: Re: [GIT pull] x86 vdso updates
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 7:59 AM, richard -rw- weinberger
<richard.weinberger@gmail.com> wrote:
> On Fri, May 27, 2011 at 1:36 PM, Andrew Lutomirski <luto@mit.edu> wrote:
>> 2. Remove the vsyscall64 sysctl.  That will reduce the number of
>> vsyscalls that require the kernel's help to one.  (This is a bit
>> unfortunate for UML users, but I'm not sure what to do about that.
>> UML vgetcpu is already terminally broken.)
>
> Can you please be a bit more precise on that?
> When there is anything I can do, let me know...

glibc's implementation of time, sched_getcpu, and (for static
binaries) gettimeofday calls a fixed address in kernel space which
returns the answer.  On UML, that address is presumably in *host*
kernel space and the host will return what the host thinks the answer
is.

That's a bit unfortunate if the guest has a different idea of cpu
numbering or what time it is.  Right now, setting kernel.vsyscall64=0
will turn gettimeofday and time (but not sched_getcpu) into a real
syscall.  The problem is that I want to remove the vsyscall64 sysctl.

If this is considered enough of a regression, then I guess we can
leave vsyscall64 around for awhile, but it will require extra work in
the soon-to-be syscall emulation hack to make sure that UML can still
trap the syscall.

The real solution is to fix glibc to use the vDSO which should avoid
this problem entirely.

--Andy

>
> --
> Thanks,
> //richard
>

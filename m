Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756457Ab2ITWkM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 18:40:12 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38443 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756321Ab2ITWkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 18:40:10 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdXxXW5pPHF+6r+qcobjtTNaXP1cmkrrtdDeWcLfGop4gA@mail.gmail.com>
References: <20120807004041.GA27896@www.outflux.net>
	<CAMuHMdXxXW5pPHF+6r+qcobjtTNaXP1cmkrrtdDeWcLfGop4gA@mail.gmail.com>
Date: Thu, 20 Sep 2012 15:40:08 -0700
X-Google-Sender-Auth: zu5Fk-2C5y0foRM-_WfygCC50HI
Message-ID: <CAGXu5jLitrZTef9uJ69Vp-jFTfDgpYipb3p1ACj6cogC3vqxMQ@mail.gmail.com>
Subject: Re: [RE-RESEND][PATCH] audit: replace defines with C stubs
From: Kees Cook <keescook@chromium.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jonas Bonn <jonas@southpole.se>, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        linux@openrisc.net, Linux-Next <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 12:43 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Tue, Aug 7, 2012 at 2:40 AM, Kees Cook <keescook@chromium.org> wrote:
>> This replaces the #defines used when CONFIG_AUDIT or CONFIG_AUDIT_SYSCALLS
>> are disabled so we get type checking during those builds.
>>
>> Suggested-by: Andrew Morton <akpm@linux-foundation.org>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>
> JFYI, the change
>
> -#define audit_syscall_entry(ta,a,b,c,d,e) do { ; } while (0)
> +static inline void audit_syscall_entry(int arch, int major, unsigned long a0,
> +                                      unsigned long a1, unsigned long a2,
> +                                      unsigned long a3)
> +{ }
>
> uncovers a bug on OpenRISC.
>
> Before,
>
>         audit_syscall_entry(audit_arch(), regs->gpr[11],
>                             regs->gpr[3], regs->gpr[4],
>                             regs->gpr[5], regs->gpr[6]);
>
> just expanded to nothing if CONFIG_AUDITSYSCALL was not set.
> Now, it fails to compile with:
>
> arch/openrisc/kernel/ptrace.c:190:2: error: implicit declaration of
> function 'audit_arch'
> http://kisskb.ellerman.id.au/kisskb/buildresult/7191698/

Thanks for catching this! It looks like audit.h is missing
AUDIT_ARCH_OPENRISC entirely, and that openrisc doesn't need an
audit_arch() function at all. It could use AUDIT_ARCH_OPENRISC once
that existed, which would just be EM_OPENRISC. (It looks like little
endian mode isn't used.)

I'll send a patch...

-Kees

-- 
Kees Cook
Chrome OS Security
